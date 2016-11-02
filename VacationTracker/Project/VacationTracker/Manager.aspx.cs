using System;
using System.Collections.Generic;
using System.Linq;
using DBHelper;
using VacationTracker;
using System.Configuration;
using System.Data;
using System.Web.Services;

public partial class Manager : System.Web.UI.Page
{
    static int iAssocID = 0;
    static string strAssocName = string.Empty;
    static int iBalancePTO = 0;
    static string strManagerName = string.Empty;
    static string strTeamName = string.Empty;
    static string strMailID = string.Empty;
    static DBConnection dbcProjectInfo;
    CTeam Team = null;
    static CAssociate Assoc = null;
    static CVacation vacation = null;
    static List<CVacation> lstVacation = null;
    static List<CHolidays> lstHolidays = null;
    static int iUniqueID = 1;
    protected void Page_Load(object sender, EventArgs e)
    {
        dbcProjectInfo = new DBConnection(ConfigurationManager.AppSettings["ProjectInfo"]);
        if (!IsPostBack)
        {
            lstVacation = new List<CVacation>();
            lstHolidays = new List<CHolidays>();
            InitalizeDetails();
        }
    }

    private void InitalizeDetails()
    {
        DataTable dtAsscDetails = dbcProjectInfo.GenerateDataTable("SELECT * FROM V_XL_TBL_ASSOCIATE WHERE ID = '" + ((CGLobal)Session["GlobalSession"]).AssocID + "'");
        if (dtAsscDetails.Rows.Count > 0)
        {
            iAssocID = Convert.ToInt32(dtAsscDetails.Rows[0]["PKEY"]);
            strAssocName = Convert.ToString(dtAsscDetails.Rows[0]["NAME"]);
            strTeamName = Convert.ToString(dtAsscDetails.Rows[0]["TEAM_NAME"]);
        }
        iBalancePTO = CUtility.GetPTOBlance(((CGLobal)Session["GlobalSession"]).AssocID, DateTime.Now.Year);
        strManagerName = dbcProjectInfo.retrieveScalar("SELECT NAME FROM V_XL_TBL_ASSOCIATE WHERE TEAM_NAME = '" + strTeamName + "' AND IS_MANAGER = 'Y' GROUP BY TEAM_NAME");
        strMailID = dbcProjectInfo.retrieveScalar("SELECT EMAIL_ID FROM V_XL_TBL_ASSOCIATE WHERE TEAM_NAME = '" + strTeamName + "' AND IS_MANAGER = 'Y' GROUP BY TEAM_NAME");
        Team = new CTeam(strTeamName, strManagerName, strMailID);
        Assoc = new CAssociate(iAssocID, strAssocName, iBalancePTO, Team);
    }

    [WebMethod(EnableSession=true)]
    public static List<CVacation> LoadVacations()
    {
        if (lstVacation != null)
        {
            lstVacation.Clear();
            string strAsscID = "";
            int iSpilOutCnt = 0;
            int iMaxVacCnt = 0;
            string strTeam = dbcProjectInfo.retrieveScalar("SELECT PKEY FROM tbl_teams WHERE Team_Name = '"+ Convert.ToString(strTeamName) +"'");
            iMaxVacCnt = Convert.ToInt32(dbcProjectInfo.retrieveScalar("SELECT IFNULL(Max_Allowed_Vaction,0) FROM TBL_TEAMS WHERE TEAM_NAME = '" + strTeamName + "'"));
            iSpilOutCnt = Convert.ToInt32(dbcProjectInfo.retrieveScalar("SELECT IFNULL(Splil_Out_Vacation,0) FROM TBL_TEAMS WHERE TEAM_NAME = '" + strTeamName + "'"));

            DataTable dtAssocDetails = dbcProjectInfo.GenerateDataTable("SELECT * FROM TBL_ASSOCIATE WHERE IFNULL(TEAM_ID,'') = " + strTeam + "");
            if(dtAssocDetails.Rows.Count > 0)
                strAsscID = string.Join(",",dtAssocDetails.AsEnumerable().Select(x=>x.Field<string>("ID")).ToArray());
            DataTable dtVacations = dbcProjectInfo.GenerateDataTable("SELECT * FROM V_XL_TBL_VACATION WHERE ID IN ('" + strAsscID.Replace(",", "','") + "')");
            if (dtVacations.Rows.Count > 0)
            {
                if (dtVacations.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtVacations.Rows)
                    {
                        int iBal = CUtility.GetPTOBlance(Convert.ToString(dr["ID"]),DateTime.Now.Year);
                        lstVacation.Add(new CVacation(Convert.ToInt32(dr["PKEY"]), Assoc, Convert.ToDateTime(dr["from_date"]).ToString("yyyy-MM-dd"),
                            Convert.ToDateTime(dr["to_date"]).ToString("yyyy-MM-dd"), Convert.ToDateTime(dr["Org_from_date"]).ToString("yyyy-MM-dd"),
                            Convert.ToDateTime(dr["Org_to_date"]).ToString("yyyy-MM-dd"), Convert.ToString(dr["Title"]), Convert.ToString(dr["Description"]), true, Convert.ToString(dr["Approved_status"]), "N", "", Convert.ToString(dr["Name"]), Convert.ToString(dr["EMAIL_ID"]), iBal, "Y", Convert.ToString(dr["Comments"]), (iBalancePTO <= iSpilOutCnt)));
                    }
                }
            }
        }
        return lstVacation;
    }

    [WebMethod]
    public static List<CHolidays> AddHolidays()
    {
        if (lstHolidays.Count == 0)
        {
            DataTable dtHolidays = dbcProjectInfo.GenerateDataTable("SELECT * FROM TBL_HOLIDAYS");
            if (dtHolidays.Rows.Count > 0)
            {
                foreach (DataRow dr in dtHolidays.Rows)
                {
                    lstHolidays.Add(new CHolidays(Convert.ToInt32(dr["PKEY"]),Convert.ToDateTime(dr["Date"]).ToString("yyyy-MM-dd"), Convert.ToDateTime(dr["Date"]).ToString("yyyy-MM-dd"),
                        Convert.ToString(dr["vacation"]),"",true,"N"));
                }
            }
        }
        return lstHolidays;
    }

    [WebMethod]
    public static List<CVacation> UpdateVacation(string Status, int ID, string Comments, string Dates)
    {
        var lstIndex = lstVacation.FindIndex(x => x.ID == ID);
        List<CVacation> lstReturn = null;
        CVacation item = null;
        if (lstIndex >= 0)
        {
            item = lstVacation[lstIndex];
            DateTime dtStartDate = Convert.ToDateTime(item.mFromDate);
            DateTime dtToDate = Convert.ToDateTime(item.mToDate);
            TimeSpan ts = dtToDate - dtStartDate;
            if (ts.Days > 1)
            {
                for (DateTime date = dtStartDate; date.Date < dtToDate.Date; date = date.AddDays(1))
                {
                    var lstMIndex = lstVacation.FindIndex(x => x.FromDate == Convert.ToDateTime(date).ToString("yyyy-MM-dd"));
                    CVacation cMItem = null;
                    if (lstMIndex >= 0)
                    {
                        cMItem = lstVacation[lstMIndex];
                        if (Array.ConvertAll(Dates.Split(',').ToArray(),p=>p.Trim()).Contains(Convert.ToDateTime(date).ToString("dd-MM-yyyy")))
                        {
                            cMItem.bExisting = false;
                            cMItem.Approved = Status;
                            cMItem.isEdited = "Y";
                            if (Status != "1")
                                cMItem.Comments = Comments;
                            else
                                cMItem.Comments = "";
                        }
                        else
                        {
                            cMItem.bExisting = false;
                            if (Status == "1")
                            {
                                cMItem.Approved = "2";
                                cMItem.Comments = Comments;
                            }
                            else if (Status != "1")
                            {
                                cMItem.Approved = "1";
                                cMItem.Comments = "";
                            }
                            cMItem.isEdited = "Y";
                        }
                    }
                }
            }
            else
            {
                item.bExisting = false;
                item.Approved = Status;
                item.isEdited = "Y";
                item.Comments = Comments;
            }
            lstReturn = lstVacation.GetRange(lstIndex, 1);
        }
        return lstReturn;
    }

    public void lnkbtnSubmit_Click(object sender, EventArgs eventargs)
    {
        foreach (CVacation item in lstVacation.Where(x => x.bExisting == false && x.Error == ""))
        {
            string[] strQuery = { "UPDATE TBL_VACATIONS SET STATUS = '" + item.Approved + "',SHOW_NOTIFICATIONS = 1,Comments = '" + item.Comments + "' WHERE PKEY = " + item.ID + "" };
            dbcProjectInfo.executeNonQuery(strQuery);
            if ((Convert.ToDateTime(item.mToDate) - Convert.ToDateTime(item.mFromDate)).Days == 1)
                CUtility.SendNotificationMailToAssociate(item.AssocMailId, Convert.ToDateTime(item.FromDate), Convert.ToDateTime(item.ToDate), Convert.ToString(item.Title), (item.Approved == "1") ? true : false);
        }
    }
}
