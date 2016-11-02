using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using DBHelper;
using VacationTracker;
using System.Configuration;
using System.Data;
using System.Collections;

public partial class TeamGrouping : System.Web.UI.Page
{
    DBConnection dbc;
    static DataTable dtUpdate;
    protected void Page_Load(object sender, EventArgs e)
    {
        dbc = new DBConnection(ConfigurationManager.AppSettings["ProjectInfo"]);
        if (!IsPostBack)
        {
            LoadFields();
        }
        IdentifyManager(lstAvailable, lstSelected);
    }

    private void LoadFields()
    {
        DataTable dtTeamNames = dbc.GenerateDataTable("SELECT * FROM TBL_TEAMS ORDER BY TEAM_NAME");
        DataTable dtAssociates = dbc.GenerateDataTable("SELECT * FROM V_XL_TBL_ASSOCIATE ORDER BY NAME");
        lstAvailable.Items.Clear();
        lstSelected.Items.Clear();
        txtVacationCount.Text = "";
        txtSpilOutVacationCount.Text = "";
        txtTeamName.Text = "";
        lnkbtnChangeTeam.Visible = true;
        btnAdd.Enabled = false;
        btnAdd.CssClass = "PopupButtonDisabled";
        btnRemove.Enabled = false;
        btnRemove.CssClass = "PopupButtonDisabled";
        if (dtTeamNames.Rows.Count > 0)
        {
            ddlTeam.Items.Clear();
            ddlTeam.DataSource = dtTeamNames;
            ddlTeam.DataValueField = dtTeamNames.Columns["PKEY"].ColumnName;
            ddlTeam.DataTextField = dtTeamNames.Columns["TEAM_NAME"].ColumnName;
            ddlTeam.DataBind();
            ddlTeam.Items.Insert(0, "--Select--");
            ddlTeam.SelectedIndex = 0;
        }

        if (dtAssociates.Rows.Count > 0)
        {
            lstAvailable.DataTextField = "Name";
            lstAvailable.DataValueField = "PKEY";
            lstAvailable.DataSource = dtAssociates;
            lstAvailable.DataBind(); 
        }
        IdentifyManager(lstAvailable, lstSelected);
    }

    protected void EnableControls(bool bEnabled)
    {
        lnkbtnAdd.Enabled = bEnabled;
        lnkbtnDelete.Enabled = bEnabled;
        lnkbtnClear.Enabled = bEnabled;
    }

    protected bool IdentifyManager(ListBox lstAvailable,ListBox lstSelected)
    {
        bool bExists = false;
        DataTable dtAssociates = dbc.GenerateDataTable("SELECT * FROM V_XL_TBL_ASSOCIATE ORDER BY NAME");
        string strManagerKeys = string.Join(",", dtAssociates.AsEnumerable().Where(x => x.Field<string>("IS_MANAGER") == "Y").Select(x => x.Field<int>("PKEY")).ToArray());
        string strAvailableKeys = string.Join(",", lstAvailable.Items.Cast<ListItem>().Select(x => x.Value).ToArray());
        string strSelectedKeys = string.Join(",", lstSelected.Items.Cast<ListItem>().Select(x => x.Value).ToArray());
        var cAvailable = strManagerKeys.Split(',').ToArray().Intersect(strAvailableKeys.Split(','));
        var cSelected = strManagerKeys.Split(',').ToArray().Intersect(strSelectedKeys.Split(','));

        foreach(string strAvailable in cAvailable)
            lstAvailable.Items[lstAvailable.Items.IndexOf(lstAvailable.Items.FindByValue(strAvailable))].Attributes.Add("style", "color:red");

        foreach (string strSelected in cSelected)
        {
            bExists = true;
            lstSelected.Items[lstSelected.Items.IndexOf(lstSelected.Items.FindByValue(strSelected))].Attributes.Add("style", "color:red");
        }
        return bExists;
    }

    protected void ddlTeam_SelectIndexChanged(object sender, EventArgs eventArgs)
    {
        lstAvailable.Items.Clear();
        lstSelected.Items.Clear();
        LoadTeamValues();
    }

    protected void LoadTeamValues()
    {
        DataTable dtAssociates = dbc.GenerateDataTable("SELECT * FROM V_XL_TBL_ASSOCIATE ORDER BY NAME");
        DataTable dtTeam;
        DataTable dtAssoc = dtAssociates.Clone();
        lstAvailable.Items.Clear();
        lstSelected.Items.Clear();
        if (ddlTeam.SelectedIndex > 0)
        {
            lnkbtnChangeTeam.Visible = false;
            btnAdd.Enabled = true;
            btnAdd.CssClass = "PopupButton";
            btnRemove.Enabled = true;
            btnRemove.CssClass = "PopupButton";
            dtTeam = dbc.GenerateDataTable("SELECT * FROM V_XL_TBL_ASSOCIATE WHERE TEAM_NAME = '" + ddlTeam.SelectedItem.Text + "' ORDER BY NAME");
            txtVacationCount.Text = dbc.retrieveScalar("SELECT Max_Allowed_Vaction FROM tbl_teams WHERE Team_Name = '" + ddlTeam.SelectedItem.Text + "'");
            txtSpilOutVacationCount.Text = dbc.retrieveScalar("SELECT IFNULL(Splil_Out_Vacation,'0') FROM tbl_teams WHERE Team_Name = '" + ddlTeam.SelectedItem.Text + "'");
            //DataRow[] drTeamMembers = dtAssociates.Select("Team_Name not in('" + ddlTeam.SelectedItem.Text + "')", "Name");
            DataRow[] drTeamMembers = dtAssociates.Select("Team_Name in('')", "Name");
            foreach (DataRow dr in drTeamMembers)
            {
                dtAssoc.ImportRow(dr);
            }
            dtAssoc.AcceptChanges();
            dtUpdate = dtAssoc.Copy();
            lstAvailable.DataTextField = "NAME";
            lstAvailable.DataValueField = "PKEY";
            lstAvailable.DataSource = dtAssoc;
            lstAvailable.DataBind();

            if (dtTeam.Rows.Count > 0)
            {
                lstSelected.DataTextField = "NAME";
                lstSelected.DataValueField = "PKEY";
                lstSelected.DataSource = dtTeam;
                lstSelected.DataBind();
            }
        }
        else if (ddlTeam.SelectedIndex == 0)
        {
            txtVacationCount.Text = "";
            txtSpilOutVacationCount.Text = "";
            lnkbtnChangeTeam.Visible = true;
            btnAdd.Enabled = false;
            btnAdd.CssClass = "PopupButtonDisabled";
            btnRemove.Enabled = false;
            btnRemove.CssClass = "PopupButtonDisabled";
            LoadFields();
        }

        IdentifyManager(lstAvailable,lstSelected);
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {

        if (lstAvailable.SelectedIndex > -1)
        {
            ListItem obj = lstAvailable.SelectedItem;
            lstSelected.SelectedIndex = -1;
            foreach (ListItem item in lstAvailable.Items)
            {
                if (item.Selected)
                {
                    lstSelected.Items.Add(item);
                }
            }
            foreach (ListItem item in lstSelected.Items)
            {
                if (item.Selected)
                {
                    lstAvailable.Items.Remove(item);

                }
            }
            lstAvailable.SelectedIndex = -1;
        }
        lstSelected = SortListAndCombo(lstSelected);
        lstAvailable = SortListAndCombo(lstAvailable);
    }

    protected void lnkbtnChangeTeam_Click(object sender, EventArgs eventArgs)
    {
        string strUserList = string.Empty;
        foreach (ListItem _listItem in lstAvailable.Items)
            if (_listItem.Selected)
                strUserList += _listItem.Value + ",";

        strUserList = strUserList.Remove(strUserList.Length - 1, 1);
        if (strUserList.Split(',').Count() > 1)
        {
            CUtility.CreateMessageAlert(this.Page, "Only single associate should be selected");
            return;
        }
        string strTeamIndex = dbc.retrieveScalar("SELECT TEAM_ID FROM TBL_ASSOCIATE WHERE PKEY IN (" + strUserList.Replace(",", "','") + ")");
        string strIsManager = dbc.retrieveScalar("SELECT IS_MANAGER FROM TBL_ASSOCIATE WHERE PKEY IN(" + strUserList.Replace(", ", "','") + ")");
        if (string.IsNullOrEmpty(strTeamIndex) || strTeamIndex == "0")
        {
            CUtility.CreateMessageAlert(this.Page, "Selected associate was not assigned to any of the teams");
            return;
        }
        if (strIsManager == "1")
        {
            DataTable dtTeams = dbc.GenerateDataTable("SELECT * FROM TBL_ASSOCIATE WHERE TEAM_ID = '"+ strTeamIndex +"'");
            if (dtTeams.Rows.Count > 1)
            {
                CUtility.CreateMessageAlert(this.Page, "Selected manager cannot be assigned to another team");
                return;
            }
        }
        
        string strScript = "<script>Open('ChangeAssocTeam.aspx?UserList=" + strUserList + "','35','15');</script>";
        this.Page.RegisterStartupScript("popup", strScript);
    }

    protected void btnRemove_Click(object sender, EventArgs e)
    {

        if (lstSelected.SelectedIndex > -1)
        {
            ListItem obj = lstSelected.SelectedItem;
            lstAvailable.SelectedIndex = -1;
            foreach (ListItem item in lstSelected.Items)
            {
                if (item.Selected)
                {
                    lstAvailable.Items.Add(item);
                }
            }
            foreach (ListItem item in lstAvailable.Items)
            {
                if (item.Selected)
                {
                    lstSelected.Items.Remove(item);

                }
            }
            lstSelected.SelectedIndex = -1;
        }
        lstSelected = SortListAndCombo(lstSelected);
        lstAvailable = SortListAndCombo(lstAvailable);
    }

    protected void lnbtnAdd_Click(object sender, EventArgs eventArgs)
    {
        btnAdd.Enabled = true;
        btnAdd.CssClass = "PopupButton";
        btnRemove.Enabled = true;
        btnRemove.CssClass = "PopupButton";
        lnkbtnDelete.Enabled = false;
        lnkbtnDelete.CssClass = "PopupButtonDisabled";
        lnkbtnDelete.Attributes.Add("style", "");
        lnkbtnClear.Enabled = true;
        lnkbtnClear.CssClass = "PopupButton";
        lnkbtnDelete.Attributes.Add("style", "");
        lnkbtnClear.Enabled = true;
        DataTable dtAvailable = dbc.GenerateDataTable("SELECT * FROM V_XL_TBL_ASSOCIATE WHERE IFNULL(Team_Name,'') = ''");
        ddlTeam.SelectedIndex = -1;
        ddlTeam.Visible = false;
        txtTeamName.Visible = true;
        lstAvailable.Items.Clear();
        lstSelected.Items.Clear();
        txtVacationCount.Text = "";
        txtSpilOutVacationCount.Text = "";
        if (dtAvailable.Rows.Count > 0)
        {
            lstAvailable.DataTextField = "NAME";
            lstAvailable.DataValueField = "PKEY";
            lstAvailable.DataSource = dtAvailable;
            lstAvailable.DataBind();
        }
        IdentifyManager(lstAvailable, lstSelected);
    }

    protected void lnkbtnSubmit_Click(object sender, EventArgs eventArgs)
    {
        if(lstSelected.Items.Count > 0 && !IdentifyManager(lstAvailable,lstSelected))
        {
            CUtility.CreateMessageAlert(this.Page,"Atleast one manager should be selected in the team");
            return;
        }

        if (txtTeamName.Visible)
        {
            DataTable dtTeams = dbc.GenerateDataTable("SELECT * FROM TBL_TEAMS WHERE Team_Name = '"+ Convert.ToString(txtTeamName.Text) +"'");
            if (dtTeams.Rows.Count > 0)
            {
                CUtility.CreateMessageAlert(this.Page, "Team Name already exists");
                return;
            }
            string[] strTeamQuery = new string[10];
            string strTeamID = string.Empty;
            if (!string.IsNullOrEmpty(Convert.ToString(txtTeamName.Text)) && !string.IsNullOrEmpty(Convert.ToString(txtVacationCount.Text)))
            {
                strTeamQuery[0] = "INSERT INTO TBL_TEAMS(Team_Name,Max_Allowed_Vaction,Splil_Out_Vacation) VALUES ('" + Convert.ToString(txtTeamName.Text) + "','" + Convert.ToString(txtVacationCount.Text) + "','" + (String.IsNullOrEmpty(txtSpilOutVacationCount.Text.ToString()) ? "0" : Convert.ToString(txtSpilOutVacationCount.Text)) + "')";
                dbc.executeNonQuery(strTeamQuery);
                strTeamID = dbc.retrieveScalar("SELECT PKEY FROM TBL_TEAMS WHERE Team_Name = '"+ Convert.ToString(txtTeamName.Text) +"'"); 
            }
            foreach (ListItem lstItem in lstSelected.Items)
            {
                string[] strQuery = { " UPDATE TBL_ASSOCIATE SET team_ID = " + strTeamID + " WHERE PKEY = " + Convert.ToInt32(lstItem.Value) + "" };
                dbc.executeNonQuery(strQuery);
            }
            
            txtTeamName.Text = "";
            txtTeamName.Visible = false;
            lnkbtnClear.Enabled = false;
            lnkbtnClear.CssClass = "PopupButtonDisabled";
            lnkbtnClear.Attributes.Add("style", "");
            lnkbtnClear.Enabled = true;
            lnkbtnDelete.Enabled = true;
            lnkbtnDelete.CssClass = "PopupButton";
            lnkbtnDelete.Attributes.Add("style", "");
            ddlTeam.Visible = true;
            LoadFields();
            return;
        }

        if (ddlTeam.SelectedIndex > 0)
        {
            foreach (ListItem lstItem in lstSelected.Items)
            {
                string[] strQuery = { " UPDATE TBL_ASSOCIATE SET team_ID = " + ddlTeam.SelectedValue + " WHERE PKEY = "+ Convert.ToInt32(lstItem.Value) +"" };
                dbc.executeNonQuery(strQuery);
            }
            foreach (ListItem lstItem in lstAvailable.Items)
            {
                DataRow[] drExists = dtUpdate.Select("PKEY in('" + lstItem.Value + "')");
                if (drExists.Count() == 0)
                {
                    string[] strQuery = { " UPDATE TBL_ASSOCIATE SET team_ID = '0' WHERE PKEY = " + Convert.ToInt32(lstItem.Value) + "" };
                    dbc.executeNonQuery(strQuery);
                }
            }
            string[] strVacQuery = { "UPDATE TBL_TEAMS SET Max_Allowed_Vaction = " + Convert.ToString(txtVacationCount.Text) + ",Splil_Out_Vacation = " + (String.IsNullOrEmpty(txtSpilOutVacationCount.Text.ToString()) ? "0" : Convert.ToString(txtSpilOutVacationCount.Text)) + " WHERE PKEY = " + ddlTeam.SelectedValue + "" };
            dbc.executeNonQuery(strVacQuery);
        }
    }

    protected void lnkCancel_Click(object sender, EventArgs eventArgs)
    {
        if (!ddlTeam.Visible)
        {
            txtTeamName.Visible = false;
            ddlTeam.Visible = true;
            lnkbtnClear.Enabled = false;
            lnkbtnClear.CssClass = "PopupButtonDisabled";
            lnkbtnClear.Attributes.Add("style", "");
            lnkbtnDelete.Enabled = true;
            lnkbtnDelete.CssClass = "PopupButton";
            lnkbtnDelete.Attributes.Add("style", "");
        }
        if (ddlTeam.SelectedIndex >= 0)
        {
            LoadTeamValues();
        }
    }

    protected void lnkbtnDelete_Click(object sender, EventArgs eventArgs)
    {
        if (ddlTeam.SelectedIndex > 0)
        {
            if (lstSelected.Items.Count > 0)
            {
                CUtility.CreateMessageAlert(this.Page, "Please remove the assigned associates from the team");
                return;
            }

            if (lstSelected.Items.Count == 0)
            {
                string[] strDelQuery = { "DELETE FROM TBL_TEAMS  WHERE PKEY = "+ ddlTeam.SelectedValue +"" };
                dbc.executeNonQuery(strDelQuery);
            }
            LoadFields();
        }
    }

    protected void lnkbtnClear_Click(object sender, EventArgs eventArgs)
    {
        txtTeamName.Text = "";
        ddlTeam.SelectedIndex = 0;
        txtVacationCount.Text = "";
        txtSpilOutVacationCount.Text = "";
        LoadFields();
    }

    private ListBox SortListAndCombo(ListBox List)
    {
        try
        {
            System.Collections.SortedList _order = new SortedList();
            List<string> _iListSelectedItem = new List<string>();


            foreach (ListItem _li in List.Items)
            {
                if (!(_order.Contains(_li.Text)) &&
                    !(_order.ContainsValue(_li.Value)))
                    _order.Add(_li.Text, _li.Value);
                else
                {
                    return List;
                }

                if (_li.Selected)
                    _iListSelectedItem.Add(_li.Value);
            }

            List.Items.Clear();

            foreach (String _strValue in _order.Keys)
            {
                List.Items.Add(new ListItem(_strValue, _order[_strValue].ToString()));
            }

            foreach (ListItem _li in List.Items)
                if (_iListSelectedItem.Contains(_li.Value))
                    _li.Selected = true;

            IdentifyManager(lstAvailable, lstSelected);
        }
        catch (Exception Er)
        {
        }
        return List;
    }
}


