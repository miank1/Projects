using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using DBHelper;
using VacationTracker;
using System.Configuration;
using System.Data;

public partial class Reports : System.Web.UI.Page
{
    DBConnection db;
    protected void Page_Load(object sender, EventArgs e)
    {
        db = new DBConnection(ConfigurationManager.AppSettings["ProjectInfo"]);
        if (!IsPostBack)
        {
            bindDropDown();
        }
    }

    private void bindDropDown()
    {
        ddlYear.Items.Add(new ListItem("2010","1"));
        ddlYear.Items.Add(new ListItem("2011","2"));
        ddlYear.Items.Add(new ListItem("2012","3"));
        ddlYear.Items.Add(new ListItem("2013","4"));
        ddlYear.Items.Add(new ListItem("2014","5"));
        ddlYear.Items.Add(new ListItem("2015","6"));
        ddlYear.Items.Add(new ListItem("2016","7"));
        ddlYear.Items.Add(new ListItem("2017","8"));
        ddlYear.Items.Add(new ListItem("2018", "9"));
        ddlYear.Items[6].Selected = true;

        DataTable dt = db.GenerateDataTable("SELECT A.NAME, A.ID FROM TBL_ASSOCIATE A WHERE A.IS_MANAGER!=1 ORDER BY A.ID");
        ddlAssociate.DataSource = dt;
        ddlAssociate.DataValueField = "ID";
        ddlAssociate.DataBind();
    }

    protected void btnFilter_Click(object sender, EventArgs e)
    {
        //Showing Vacation Balance
        int iBalancePTO = 0;
        int iSpilOutCnt = 0;
        int iMaxVacCnt = 0;
        lblPTO.Visible = true;
        spPTO.Visible = true;
        string strTeamName = db.retrieveScalar("SELECT TEAM_NAME FROM `TBL_TEAMS` T LEFT JOIN `TBL_ASSOCIATE` A ON a.`team_ID` = T.`Pkey` WHERE a.`ID` = '"+ Convert.ToString(ddlAssociate.SelectedItem.Text) +"'");
        iMaxVacCnt = Convert.ToInt32(db.retrieveScalar("SELECT IFNULL(Max_Allowed_Vaction,0) FROM TBL_TEAMS WHERE TEAM_NAME = '" + strTeamName + "'"));
        iSpilOutCnt = Convert.ToInt32(db.retrieveScalar("SELECT IFNULL(Splil_Out_Vacation,0) FROM TBL_TEAMS WHERE TEAM_NAME = '" + strTeamName + "'"));
        iBalancePTO = CUtility.GetPTOBlance(ddlAssociate.SelectedItem.Text, DateTime.Now.Year);
        //if (iSpilOutCnt != 0 && (iMaxVacCnt - iSpilOutCnt) >= iBalancePTO)
        if (iBalancePTO <= iSpilOutCnt)
        {
            spPTO.Visible = true;
            lblPTO.Text = "<b>Vacation Balance : <font color='red'>" + iBalancePTO + "</font></b>";
        }
        else
        {
            spPTO.Visible = false;
            lblPTO.Text = "<b>Vacation Balance : " + iBalancePTO + "</b>";
        }

        int year = int.Parse(ddlYear.SelectedItem.Text);
        List<DateTime> listHoliday = CUtility.GetHolidayList(year);
        DateTime StartDate;
        DataTable dt = new DataTable();
        DataRow dr;
        dt.Columns.Add(new DataColumn("quater", typeof(int)));
        dt.Columns.Add(new DataColumn("startDate", typeof(DateTime)));
        dt.Columns.Add(new DataColumn("endDate", typeof(DateTime)));
        dt.Columns.Add(new DataColumn("workingDays", typeof(int)));
        dt.Columns.Add(new DataColumn("vacations", typeof(int)));

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
        gvquaterlyReport.DataSource = dt;
        gvquaterlyReport.DataBind();
    }
}

