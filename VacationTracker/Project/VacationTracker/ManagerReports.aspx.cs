using System;
using DBHelper;
using VacationTracker;
using System.Configuration;
using System.Data;

public partial class ManagerReports : System.Web.UI.Page
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
        DataTable dt = db.GenerateDataTable("SELECT `Name`,ID FROM `v_xl_tbl_associate` WHERE Team_Name IN (SELECT team_name FROM `v_xl_tbl_associate` WHERE ID = '" + ((CGLobal)Session["GlobalSession"]).AssocID + "') GROUP BY `NAME` ORDER BY NAME");
        ddlAssociate.DataSource = dt;
        ddlAssociate.DataValueField = "ID";
        ddlAssociate.DataTextField = "Name";
        ddlAssociate.DataBind();
        ddlAssociate.Items.Insert(0, "--Select--");
        ddlAssociate.SelectedIndex = 0;
    }

    protected void btnFilter_Click(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(CalFrom.Text) && !string.IsNullOrEmpty(CalTo.Text) && Convert.ToDateTime(CalFrom.Text) > Convert.ToDateTime(CalTo.Text))
        {
            CUtility.CreateMessageAlert(this, "From Date should be less that To Date");
            return;
        }
        string query = string.Format("SELECT V.NAME,V.FROM_DATE,V.TO_DATE FROM `V_XL_TBL_VACATION` V WHERE V.`Approved_status` = 'Y' AND V.NAME IN (SELECT `NAME` FROM `V_XL_TBL_ASSOCIATE` WHERE TEAM_NAME IN (SELECT TEAM_NAME FROM `TBL_TEAMS` T LEFT JOIN `TBL_ASSOCIATE` A ON A.`TEAM_ID` = T.`PKEY` WHERE A.`ID` = '" + ((CGLobal)Session["GlobalSession"]).AssocID + "')) ORDER BY V.FROM_DATE,V.TO_DATE");
        DataTable dtReports = db.GenerateDataTable(query);
        if (!string.IsNullOrEmpty(CalFrom.Text) && !string.IsNullOrEmpty(CalTo.Text))
        {
            dtReports = dtReports.AsEnumerable()
                .Where(x => Convert.ToDateTime(x.Field<string>("FROM_DATE")) >= Convert.ToDateTime(CalFrom.Text) &&
                    Convert.ToDateTime(x.Field<string>("TO_DATE")) <= Convert.ToDateTime(CalTo.Text)).CopyToDataTable();
        }
        if (ddlAssociate.SelectedIndex > 0 && dtReports.Rows.Count > 0)
            dtReports = dtReports.Select("Name = '" + ddlAssociate.SelectedItem.Text + "'").CopyToDataTable();
        gvquaterlyReport.DataSource = dtReports;
        gvquaterlyReport.DataBind();
        lblRecordsCount.Visible = true;
        lblRecordsCount.Text = "<b> #.of records : " + dtReports.Rows.Count + " </b>";
    }

    protected void lnkbtnClear_Click(object sender, EventArgs e)
    {
        ddlAssociate.SelectedIndex = 0;
        CalFrom.Text = "";
        CalTo.Text = "";
        gvquaterlyReport.DataSource = "";
        gvquaterlyReport.DataBind();
        lblRecordsCount.Visible = false;
        lblError.Text = "";
    }
}

