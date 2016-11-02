using System;
using DBHelper;
using System.Configuration;
using System.Data;

public partial class ChangeAssocTeam : System.Web.UI.Page
{
    DBConnection dbc;
    protected void Page_Load(object sender, EventArgs e)
    {
        dbc = new DBConnection(ConfigurationManager.AppSettings["ProjectInfo"]);
        if (!IsPostBack)
        {
            FillDropDown();
        }
    }

    protected void FillDropDown()
    {
        DataTable dtTeams = dbc.GenerateDataTable("SELECT * FROM TBL_TEAMS ORDER BY TEAM_NAME");
        string strTeamIndex = dbc.retrieveScalar("SELECT TEAM_ID FROM TBL_ASSOCIATE WHERE PKEY IN (" + Convert.ToString(Request.QueryString["UserList"]).Replace(",", "','") + ")");
        if (string.IsNullOrEmpty(strTeamIndex))
            strTeamIndex = "0";
        string strTeamName = dbc.retrieveScalar("SELECT TEAM_NAME FROM TBL_TEAMS WHERE PKEY = " + strTeamIndex + "");
        if (dtTeams.Rows.Count > 0)
        {
            ddlTeam.Items.Clear();
            ddlTeam.DataTextField = "TEAM_NAME";
            ddlTeam.DataValueField = "PKEY";
            ddlTeam.DataSource = dtTeams;
            ddlTeam.DataBind();
            ddlTeam.Items[ddlTeam.Items.IndexOf(ddlTeam.Items.FindByText(strTeamName))].Selected = true;
        }

    }
    protected void btnAssign_Click(object sender, EventArgs eventArgs)
    {
        if (ddlTeam.SelectedIndex > -1)
        {
            string[] strQuery = { "UPDATE TBL_ASSOCIATE SET TEAM_ID = " + ddlTeam.SelectedValue + " WHERE PKEY = " + Convert.ToString(Request.QueryString["UserList"]).Replace(",", "','") + "" };
            dbc.executeNonQuery(strQuery);
        }
        string strScript = "<script>Close();</script>";
        this.Page.RegisterStartupScript("Close", strScript);
    }
}

