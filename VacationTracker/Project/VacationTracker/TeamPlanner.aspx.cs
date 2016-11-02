using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DBHelper;
using VacationTracker;
using System.Configuration;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Text;

public partial class TeamPlanner : System.Web.UI.Page
{
    DBConnection db;
    protected void Page_Load(object sender, EventArgs e)
    {
        db = new DBConnection(ConfigurationManager.AppSettings["ProjectInfo"]);
        if (!IsPostBack)
        {
            BindList();
            BindManager();
        }
    }

    private void BindList()
    {
        string query = "SELECT NAME, is_manager FROM tbl_associate";
        DataSet ds = db.generateDataSet(query);
        chk_AssociateList.DataSource = ds;
        chk_AssociateList.DataValueField = "Name";

        chk_AssociateList.DataBind();
        //chk_AssociateList.DataSource = ds;
        //chk_AssociateList.DataValueField = "is_manager";
        //chk_AssociateList.DataBind();
    }

    private void BindManager()
    {
        string query = "SELECT is_manager FROM tbl_associate";
        DataSet ds = db.generateDataSet(query);
        CheckBoxList1.DataSource = ds;
        CheckBoxList1.DataValueField = "is_manager";
        CheckBoxList1.DataBind();
    }

    protected void btn_Save_Click(object sender, EventArgs e)
    {
        string[] query = new string[1];
        query[0] = "Insert into tbl_teams(Team_Name, Max_Allowed_Vaction)" + " values ('" + txt_TeamName.Text + "', '" + txt_Holidays.Text + "')";
        db.executeNonQuery(query);

        StringBuilder Sassoicatenames = new StringBuilder();
        foreach (ListItem item in chk_AssociateList.Items)
        {
            if (item.Selected)
            {
                Sassoicatenames.Append(string.Format("'{0}',", item.Value));
            }
        }
        Sassoicatenames.Length -= 1;
        string[] query1 = new string[1];

        query1[0] = "UPDATE tbl_associate t SET t.team_ID =( SELECT tt.Pkey FROM tbl_teams tt WHERE tt.Team_Name = '" + txt_TeamName.Text + "') WHERE t.Name IN (" + Sassoicatenames + ")";
        db.executeNonQuery(query1);
    }

}

