using System;
using System.Web;
using DBHelper;
using VacationTracker;
using System.Configuration;
using System.Data;

public partial class Login : System.Web.UI.Page
{
    DBConnection dbc;
    public static CAssociate Assoc = null;
    public static CTeam Team = null;
    CGLobal Global = new CGLobal();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Session["GlobalSession"] = Global;
            ((CGLobal)Session["GlobalSession"]).Role = "";
        }
        dbc = new DBConnection(ConfigurationManager.AppSettings["ProjectInfo"]);
        lblError.Text = "&nbsp";
    }

    protected void btnSubmit_Click(object sender, EventArgs eventArgs)
    {
        DataTable dtUser;
        bool bLogin = false;
        bool bManager = false;
        string strUserId = Convert.ToString(txtUserName.Text);
        string strPassword = Convert.ToString(txtPassword.Text);
        Session["GlobalSession"] = Global;
        if (!string.IsNullOrEmpty(strUserId) && !string.IsNullOrEmpty(strPassword))
        {
            dtUser = dbc.GenerateDataTable("SELECT * FROM TBL_ASSOCIATE WHERE ID = '" + strUserId + "' AND Password = '" + strPassword + "'");
            if (dtUser.Rows.Count > 0)
            {
                Team = new CTeam(Convert.ToString(dtUser.Rows[0]["Name"]),"","");
                Assoc = new CAssociate(0, Convert.ToString(dtUser.Rows[0]["Name"]), 0, Team);
                Assoc.AssocID = Convert.ToString(dtUser.Rows[0]["ID"]);
                ((CGLobal)Session["GlobalSession"]).AssocID = Convert.ToString(dtUser.Rows[0]["ID"]);
                ((CGLobal)Session["GlobalSession"]).AssocName = Convert.ToString(dtUser.Rows[0]["Name"]);
                Session["AssocID"] = Convert.ToString(dtUser.Rows[0]["ID"]);
                bManager = Convert.ToString(dtUser.Rows[0]["IS_MANAGER"]) == "1" ? true : false;
                bLogin = true;
            }
            else
            {
                if (strUserId.ToUpper() != "ADMIN" && strPassword.ToUpper() != "ADMIN")
                {
                    lblError.Style.Add("visibility", "visible");
                    lblError.Text = "Invalid Login information. Please try again";
                    return;
                }
            }
        }
        //Redirection page
        string role = Convert.ToString(ddlRole.SelectedItem.Text);

        if (role == "Administrator")
        {
            if (strUserId.ToUpper() == "ADMIN" && strPassword.ToUpper() == "ADMIN")
            {
                ((CGLobal)Session["GlobalSession"]).Role = "ADMIN";
                HttpContext.Current.Response.Redirect("~/DashBoard.aspx");
            }
            else
            {
                lblError.Style.Add("visibility", "visible");
                lblError.Text = "Invalid Login information. Please try again";
                return;
            }

        }
        else if (role == "Manager")
        {
            if (bLogin && bManager)
            {
                ((CGLobal)Session["GlobalSession"]).Role = "MANAGER";
                HttpContext.Current.Response.Redirect("~/Manager.aspx");
            }
            else
            {
                lblError.Style.Add("visibility", "visible");
                lblError.Text = "Invalid Login information. Please try again";
                return;
            }
        }
        else if (role == "Associate")
        {
            if (bLogin && !bManager)
            {
                ((CGLobal)Session["GlobalSession"]).Role = "ASSOCIATE";
                HttpContext.Current.Response.Redirect("~/Associate.aspx");
            }
            else
            {
                lblError.Style.Add("visibility", "visible");
                lblError.Text = "Invalid Login information. Please try again";
                return;
            }
        }
    }
}

