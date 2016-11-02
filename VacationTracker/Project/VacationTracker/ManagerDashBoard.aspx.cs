using System;
using System.Collections.Generic;
using System.Linq;
using DBHelper;
using VacationTracker;
using System.Configuration;
using System.Data;
using System.Web.Services;
using System.Web.Script.Services;

public partial class ManagerDashBoard : System.Web.UI.Page
{
    static DBConnection db;
    static DataTable DtReport = new DataTable();
    static bool ShowPiechart = false;
    static bool ShowLinechart = false;
    static DateTime FromDate;
    static DateTime ToDate;
    protected void Page_Load(object sender, EventArgs e)
    {
        db = new DBConnection(ConfigurationManager.AppSettings["ProjectInfo"]);
        if(!IsPostBack)
        {
            ShowPiechart = false;
            ShowLinechart = false;
        }
    }


    protected void btnFilter_Click(object sender, EventArgs e)
    {
        DateTime from = Convert.ToDateTime(CalFrom.Text);
        DateTime to = Convert.ToDateTime(CalTo.Text);
        FromDate = Convert.ToDateTime(CalFrom.Text);
        ToDate = Convert.ToDateTime(CalTo.Text);
        if (!string.IsNullOrEmpty(CalFrom.Text) && !string.IsNullOrEmpty(CalTo.Text) && Convert.ToDateTime(CalFrom.Text) > Convert.ToDateTime(CalTo.Text))
        {
            CUtility.CreateMessageAlert(this, "From Date should be less that To Date");
            return;
        }
        string query = string.Format("SELECT V.NAME,V.FROM_DATE,V.TO_DATE FROM `V_XL_TBL_VACATION` V WHERE V.`Approved_status` = 'Y' AND V.NAME IN (SELECT `NAME` FROM `V_XL_TBL_ASSOCIATE` WHERE TEAM_NAME IN (SELECT TEAM_NAME FROM `TBL_TEAMS` T LEFT JOIN `TBL_ASSOCIATE` A ON A.`TEAM_ID` = T.`PKEY` WHERE A.`ID` = '" + ((CGLobal)Session["GlobalSession"]).AssocID + "')) ORDER BY V.FROM_DATE,V.TO_DATE");
        DataTable dtReports = db.GenerateDataTable(query);

        DataTable dt = new DataTable();
        DataRow dr;
        dt.Columns.Add(new DataColumn("Name", typeof(string)));
        dt.Columns.Add(new DataColumn("FROM_DATE", typeof(DateTime)));
        dt.Columns.Add(new DataColumn("TO_DATE", typeof(DateTime)));
        dt.Columns.Add(new DataColumn("vacations", typeof(int)));
        List<DateTime> holidaylist = CUtility.GetHolidayList(from.Year);
        foreach (DataRow Row in dtReports.Rows)
        {
            dr = dt.NewRow();
            dr["Name"] = Row["Name"];
            dr["FROM_DATE"] = Row["FROM_DATE"];
            dr["TO_DATE"] = Row["TO_DATE"];
            dr["vacations"] = CUtility.CalculateVacation(Convert.ToDateTime(Row["FROM_DATE"]), Convert.ToDateTime(Row["TO_DATE"]), holidaylist);
            dt.Rows.Add(dr);
        }


        ShowPiechart = true;
        ShowLinechart = true;

        DtReport = dt;
    }

    protected void lnkbtnClear_Click(object sender, EventArgs e)
    {
        CalFrom.Text = "";
        CalTo.Text = "";
        lblError.Text = "";
        ShowPiechart = false;
        ShowLinechart = false;
    }

    [WebMethod]
    public static List<object> GetChartData()
    {

        List<object> chartData = new List<object>();
        #region working code for dashboard chart
        chartData.Add(new object[] { "Name", "Number of Vacations" });

        if (ShowPiechart)
        {
            if (DtReport.Rows.Count > 0)
            {
                var vardtReports = DtReport.AsEnumerable();
                var td = vardtReports.GroupBy(t => t["Name"]).Select(t => new { Name = t.Key, VactionCount = t.Sum(x => x.Field<int>("vacations")) });
                foreach (var row in td)
                {
                    chartData.Add(new object[] { row.Name, row.VactionCount });
                }
            }
            return chartData;
        }
        else
        {
            return null;
        }
        
        #endregion
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static List<object> GetLineChartData()
    {
        List<object> chartData = new List<object>();
        chartData.Add(new object[] { "days", "No. of Associates", "Pending Approvals" });
        int apsentMembers;
        string query = @"SELECT 
    V.From_Date, V.to_date, V.Approved_status
FROM
    `V_XL_TBL_VACATION` V
WHERE
    V.NAME IN (SELECT 
            `NAME`
        FROM
            `V_XL_TBL_ASSOCIATE`
        WHERE
            TEAM_NAME IN (SELECT 
                    TEAM_NAME
                FROM
                    `TBL_TEAMS` T
                        LEFT JOIN
                    `TBL_ASSOCIATE` A ON A.`TEAM_ID` = T.`PKEY`
                WHERE
                    A.`ID` = 'RD042260'))
ORDER BY V.FROM_DATE , V.TO_DATE";
        string teamMemberQuery = "select count(*) as MemberCount from v_xl_tbl_associate a where a.Team_Name = (select aa.Team_Name from v_xl_tbl_associate aa where aa.ID= 'RD042263')";

        if (ShowLinechart)
        {
            DataTable vacataiontable = db.GenerateDataTable(query);
            List<DateTime> HolidayList = CUtility.GetHolidayList(FromDate.Year);
            HolidayList.Sort();
            //correct the qurey
            DataTable TeamMember = db.GenerateDataTable(teamMemberQuery);
            int numberOfMemberInTeam = 10;
            foreach (DataRow row in TeamMember.Rows)
            {
                numberOfMemberInTeam = Convert.ToInt16(row["MemberCount"]);
            }

            DataTable dt = new DataTable();
            dt.Columns.Add(new DataColumn("days", typeof(int)));
            dt.Columns.Add(new DataColumn("Associate Present", typeof(int)));

            int numberofDays = (ToDate - FromDate).Days;

            DateTime DateIterator = FromDate;
            var vacataiontableEn = vacataiontable.AsEnumerable();
            for (int i = 0; i <= numberofDays - 1; i++)
            {
                var ApprovedVacationRows = from a in vacataiontableEn where Convert.ToString(a["Approved_status"]) == "Y" && (Convert.ToDateTime(a["From_Date"]) <= DateIterator && Convert.ToDateTime(a["To_Date"]) > DateIterator) select a;
                apsentMembers = ApprovedVacationRows.Count();
                var PendingVacationRows = from a in vacataiontableEn where Convert.ToString(a["Approved_status"]) == "N" && (Convert.ToDateTime(a["From_Date"]) <= DateIterator && Convert.ToDateTime(a["To_Date"]) > DateIterator) select a;


                if (DateIterator.DayOfWeek == DayOfWeek.Saturday || DateIterator.DayOfWeek == DayOfWeek.Sunday || HolidayList.BinarySearch(DateIterator) > 0)
                {
                    // all team members will be apsent on weekends
                    chartData.Add(new object[] { DateIterator.Date.ToString("d/MM"), 0, 0 });
                }
                else
                {
                    chartData.Add(new object[] { DateIterator.Date.ToString("d/MM"), numberOfMemberInTeam - apsentMembers, PendingVacationRows.Count() });
                }
                DateIterator = DateIterator.AddDays(1);
            }
            return chartData;

        }
        else
        {
            return null;
        }

    }
}

