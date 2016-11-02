using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using DBHelper;
using VacationTracker;
using System.Configuration;
using System.Data;
using System.Web.Services;

public partial class DashBoard : System.Web.UI.Page
{
    static DBConnection db;
    static DataTable DTquaterDataTable = new DataTable();
    static bool showLineChart = false;
    protected void Page_Load(object sender, EventArgs e)
    {
        db = new DBConnection(ConfigurationManager.AppSettings["ProjectInfo"]);
        if (!IsPostBack)
        {
            bindDropDown();
            if (ddlAssociate.SelectedIndex == 0)
                showLineChart = false;
            else
                showLineChart = true;
        }
    }

    private void bindDropDown()
    {
        ddlYear.Items.Add(new ListItem("2010", "1"));
        ddlYear.Items.Add(new ListItem("2011", "2"));
        ddlYear.Items.Add(new ListItem("2012", "3"));
        ddlYear.Items.Add(new ListItem("2013", "4"));
        ddlYear.Items.Add(new ListItem("2014", "5"));
        ddlYear.Items.Add(new ListItem("2015", "6"));
        ddlYear.Items.Add(new ListItem("2016", "7"));
        ddlYear.Items.Add(new ListItem("2017", "8"));
        ddlYear.Items.Add(new ListItem("2018", "9"));
        ddlYear.Items[6].Selected = true;

        DataTable dt = db.GenerateDataTable("SELECT A.NAME, A.ID FROM TBL_ASSOCIATE A WHERE A.IS_MANAGER!=1 ORDER BY A.ID");
        ddlAssociate.DataSource = dt;
        ddlAssociate.DataValueField = "ID";
        ddlAssociate.DataBind();
        ddlAssociate.Items.Insert(0, "--Select--");
        ddlAssociate.SelectedIndex = 0;
    }

    [WebMethod]
    public static List<object> GetChartData()
    {
        List<object> chartData = new List<object>();
        #region working code for dashboard chart

        string query = "SELECT CASE WHEN a.Team_Name = '' THEN 'Not Assigned' ELSE a.Team_Name END  AS Team_Name,(select count(*) from v_xl_tbl_associate aa where ifnull(aa.Team_Name,'0') = ifnull(a.Team_Name,'0')) as Member_count FROM v_xl_tbl_associate a  group by a.Team_Name order by a.Team_Name";
        DataTable dt = db.GenerateDataTable(query);

        chartData.Add(new object[]
        {
            "Team Name", "Team Strength"
        });

        foreach (DataRow row in dt.Rows)
        {
            chartData.Add(new object[] { row["Team_Name"].ToString(), Int16.Parse(row["Member_count"].ToString()) });
        }
        return chartData;
        #endregion

        #region this to generate dummy data in pie chart
        //if (DTquaterDataTable.Rows.Count == 4)
        // {
        //     //  int q = int.Parse(DTquaterDataTable.Rows[0]["workingDays"].ToString());
        //     chartData.Add(new object [] { "Total Days", "Days" });
        //     chartData.Add(new object[] { "working days", 1 });
        //     chartData.Add(new object[] { "vacations", 3 });
        // }
        // return chartData;
        #endregion
    }

    protected void btnFilter_Click(object sender, EventArgs e)
    {

        int year = int.Parse(ddlYear.SelectedItem.ToString());
        int temp = CUtility.GetPTOBlance(ddlAssociate.SelectedValue, year);
        List<DateTime> listHoliday = CUtility.GetHolidayList(year);
        DateTime StartDate;
        DataTable dt = new DataTable();
        DataRow dr;
        dt.Columns.Add(new DataColumn("quater", typeof(int)));
        dt.Columns.Add(new DataColumn("startDate", typeof(DateTime)));
        dt.Columns.Add(new DataColumn("endDate", typeof(DateTime)));
        dt.Columns.Add(new DataColumn("workingDays", typeof(int)));
        dt.Columns.Add(new DataColumn("vacations", typeof(int)));
        DTquaterDataTable.Rows.Clear();
        for (int quaterNumber = 1; quaterNumber <= 4; quaterNumber++)
        {
            StartDate = new DateTime(year, (quaterNumber - 1) * 3 + 1, 1);
            dr = dt.NewRow();
            dr["quater"] = quaterNumber;
            dr["startDate"] = StartDate;
            dr["endDate"] = StartDate.AddMonths(3).AddDays(-1);
            dr["workingDays"] = CUtility.CalculateVacation(StartDate, StartDate.AddMonths(3).AddDays(-1), listHoliday);
            dr["vacations"] = CUtility.GetVacationCount(ddlAssociate.SelectedValue,
                    StartDate.ToString("yyyy-MM-dd hh:mm:ss"),
                    StartDate.AddMonths(3).AddDays(-1).ToString("yyyy-MM-dd hh:mm:ss"),
                    listHoliday);
            dt.Rows.Add(dr);
        }
        DTquaterDataTable = dt;
        if (ddlAssociate.SelectedIndex == 0)
            showLineChart = false;
        else
            showLineChart = true;

    }

    [System.Web.Services.WebMethod]
    public static object[] GetBarChartData()
    {
        if (showLineChart)
        {
            var chartData = new object[5];
            chartData[0] = new object[]{
                "quater",
                "working days",
                "vacation"
            };
            if (DTquaterDataTable.Rows.Count == 4)
            {
                int i = 1;
                foreach (DataRow row in DTquaterDataTable.Rows)
                {
                    chartData[i] = new object[] { "Quater" + i, int.Parse(row["workingDays"].ToString()), int.Parse(row["vacations"].ToString()) };
                    i++;
                }
            }
            return chartData;
        }
        else
        {
            return null;
        }
    }
}

