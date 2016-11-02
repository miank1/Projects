using System;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using DBHelper;
using VacationTracker;
using System.Data;
public partial class HeaderControl : System.Web.UI.UserControl
{
    public string strVirtualPath;
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.AppendHeader("Cache-Control", "no-store");
        if (string.IsNullOrEmpty(((CGLobal)Session["GlobalSession"]).Role))
            Response.Redirect("login.aspx");

        DBConnection dbc = new DBConnection(System.Configuration.ConfigurationManager.AppSettings["ProjectInfo"]);
        lblUserName.Text = "<b>Welcome: </b>" + Convert.ToString(((CGLobal)Session["GlobalSession"]).AssocName);
        if (!String.IsNullOrEmpty(((CGLobal)Session["GlobalSession"]).Role) && (((CGLobal)Session["GlobalSession"]).Role.ToString() == "ADMIN" || ((CGLobal)Session["GlobalSession"]).Role.ToString() == "MANAGER"))
        {
            string strScript = "<script>ShowMenu();</script>";
            this.Page.RegisterStartupScript("ShowMenu", strScript);
            if (((CGLobal)Session["GlobalSession"]).Role.ToString() == "ADMIN")
                lblUserName.Text = "<b>Welcome: </b>" + "Administrator";
            LoadHeaderMenu(((CGLobal)Session["GlobalSession"]).Role);
        }
        strVirtualPath = Request.ApplicationPath.ToString();


    }

    private void LoadHeaderMenu(string Role)
    {
        DataTable dtMenu = new DataTable();
        dtMenu.Columns.Add("DISPLAY_NAME");
        dtMenu.Columns.Add("CSS_CLASS");
        dtMenu.Columns.Add("QUERY_STRING");
        dtMenu.Columns.Add("ROLE");
        dtMenu.Rows.Add("DashBoard", "fa fa-tachometer fa-5x", "DashBoard.aspx","ADMIN");
        dtMenu.Rows.Add("Team Grouping", "fa fa-users fa-5x", "TeamGrouping.aspx", "ADMIN");
        dtMenu.Rows.Add("Holiday Planner", "fa fa-calendar fa-5x", "VacationPlanner.aspx", "ADMIN");
        dtMenu.Rows.Add("Reports", "fa fa-file fa-5x", "Reports.aspx", "ADMIN");
        dtMenu.Rows.Add("DashBoard", "fa fa-tachometer fa-5x", "ManagerDashBoard.aspx", "MANAGER");
        dtMenu.Rows.Add("Vacation Approve / Reject", "fa fa-calendar fa-5x", "Manager.aspx", "MANAGER");
        dtMenu.Rows.Add("Reports", "fa fa-file fa-5x", "ManagerReports.aspx", "MANAGER");

        if (Role == "MANAGER")
            SectionGrp.Attributes.Add("style", "border-color: #389BEF; background-color: #F9F9F9; padding: 0px; margin: 0px; border-width: 3px; border-color: #389BEF; border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-radius: 0px 5px 5px 0px; min-width: 125px; min-height: 240px;");
        else
            SectionGrp.Attributes.Add("style", "border-color: #389BEF; background-color: #F9F9F9; padding: 0px; margin: 0px; border-width: 3px; border-color: #389BEF; border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-radius: 0px 5px 5px 0px; min-width: 125px; min-height: 275px;");

        dtMenu = dtMenu.Select("ROLE = '" + Role + "'").CopyToDataTable();
        string strPreviousMenu = string.Empty;
        foreach (DataRow drMenu in dtMenu.Rows)
        {
            if (strPreviousMenu != "Row_" + Convert.ToString(drMenu["DISPLAY_NAME"]).Replace(" ", "_"))
                strPreviousMenu = "Row_" + Convert.ToString(drMenu["DISPLAY_NAME"]).Replace(" ", "_");
            else
                continue;

            HtmlTableRow _htmlRow = new HtmlTableRow();
            _htmlRow.ID = strPreviousMenu;
            _htmlRow.Style.Add("height", "68px");
            HtmlTableCell _htmlCell = new HtmlTableCell();
            _htmlCell.ID = "Cell_" + Convert.ToString(drMenu["DISPLAY_NAME"]).Replace(" ", "_");
            _htmlCell.Align = "center";
            _htmlCell.Style.Add("width", "123px");
            _htmlCell.Attributes.Add("class", "ImageButton1");
            _htmlCell.Style.Add("padding", "0px");
            _htmlCell.Style.Add("margin", "0px");

            HtmlGenericControl _htmlSpanIcon = new HtmlGenericControl("span");
            _htmlSpanIcon.Style.Add("height", "48px");
            _htmlSpanIcon.Style.Add("width", "115px");
            _htmlSpanIcon.Style.Add("color", "white");
            _htmlSpanIcon.Attributes.Add("class", "CLICK_BLOCK_HDR_MENU " + Convert.ToString(drMenu["CSS_CLASS"]));

            HtmlGenericControl _htmlAnchor = new HtmlGenericControl("a");
            string strURL = Convert.ToString(drMenu["QUERY_STRING"]);
            _htmlAnchor.Attributes.Add("href", strURL);
            _htmlAnchor.Attributes.Add("class", "fa");
            _htmlAnchor.Style.Add("cursor", "pointer");

            HtmlGenericControl _htmlSpanText = new HtmlGenericControl("span");
            _htmlSpanText.Style.Add("font-size", "14px");
            _htmlSpanText.Style.Add("font-weight", "bold");
            _htmlSpanText.Style.Add("color", "white");
            _htmlSpanText.InnerText = Convert.ToString(drMenu["DISPLAY_NAME"]);
            _htmlSpanText.Attributes.Add("class", "hideallulli");

            _htmlSpanIcon.Controls.Add(new Literal() { Text = "<br/>" });
            _htmlSpanIcon.Controls.Add(_htmlSpanText);
            _htmlAnchor.Controls.Add(_htmlSpanIcon);
            _htmlCell.Controls.Add(_htmlAnchor);
            _htmlRow.Controls.Add(_htmlCell);
            tblMenu.Controls.Add(_htmlRow);
        }
    }
}