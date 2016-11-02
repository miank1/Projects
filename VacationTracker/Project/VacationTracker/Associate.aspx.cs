using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DBHelper;
using VacationTracker;
using System.Configuration;
using System.Data;
using System.Web.Services;

public partial class Associate : System.Web.UI.Page
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
        int iSpilOutCnt = 0;
        int iMaxVacCnt = 0;
        DataTable dtAsscDetails = dbcProjectInfo.GenerateDataTable("SELECT * FROM V_XL_TBL_ASSOCIATE WHERE ID = '" + ((CGLobal)Session["GlobalSession"]).AssocID + "'");
        if (dtAsscDetails.Rows.Count > 0)
        {
            iAssocID = Convert.ToInt32(dtAsscDetails.Rows[0]["PKEY"]);
            strAssocName = Convert.ToString(dtAsscDetails.Rows[0]["NAME"]);
            strTeamName = Convert.ToString(dtAsscDetails.Rows[0]["TEAM_NAME"]);
        }
        iBalancePTO = CUtility.GetPTOBlance(((CGLobal)Session["GlobalSession"]).AssocID, DateTime.Now.Year);
        iMaxVacCnt = Convert.ToInt32(dbcProjectInfo.retrieveScalar("SELECT IFNULL(Max_Allowed_Vaction,0) FROM TBL_TEAMS WHERE TEAM_NAME = '" + strTeamName + "'"));
        iSpilOutCnt = Convert.ToInt32(dbcProjectInfo.retrieveScalar("SELECT IFNULL(Splil_Out_Vacation,0) FROM TBL_TEAMS WHERE TEAM_NAME = '" + strTeamName + "'"));
        strManagerName = dbcProjectInfo.retrieveScalar("SELECT NAME FROM V_XL_TBL_ASSOCIATE WHERE TEAM_NAME = '" + strTeamName + "' AND IS_MANAGER = 'Y' GROUP BY TEAM_NAME");
        strMailID = dbcProjectInfo.retrieveScalar("SELECT EMAIL_ID FROM V_XL_TBL_ASSOCIATE WHERE TEAM_NAME = '" + strTeamName + "' AND IS_MANAGER = 'Y' GROUP BY TEAM_NAME");
        Team = new CTeam(strTeamName, strManagerName, strMailID);
        Assoc = new CAssociate(iAssocID, strAssocName, iBalancePTO, Team);
        //if (iSpilOutCnt != 0 && (iMaxVacCnt - iSpilOutCnt) >= iBalancePTO)
        if (iBalancePTO <= iSpilOutCnt)
        {
            spPTO.Visible = true;
            lblPTO.Text = "<b>PTO Balance : <font color='red'>" + iBalancePTO + "</font></b>";
        }
        else
        {
            spPTO.Visible = false;
            lblPTO.Text = "<b>PTO Balance : " + iBalancePTO + "</b>";
        }
    }

    [WebMethod(EnableSession = true)]
    public static List<string> LoadNotifications()
    {
        List<string> lstNotifications = new List<string>();
        DataTable dtNotifications = dbcProjectInfo.GenerateDataTable("SELECT * FROM V_XL_TBL_VACATION WHERE IFNULL(SHOW_NOTIFICATIONS,'N') = 'Y' AND ID = '" + Convert.ToString(HttpContext.Current.Session["AssocID"]) + "'");
        if (dtNotifications.Rows.Count > 0)
        {
            string[] strUpdateQuery = new string[1];
            string strStatus = string.Empty;
            string strDateRange = string.Empty;
            foreach (DataRow drNotifications in dtNotifications.Rows)
            {
                int iSpanDays = (Convert.ToDateTime(drNotifications["To_Date"]) - Convert.ToDateTime(drNotifications["From_Date"])).Days;
                if(Convert.ToString(drNotifications["Approved_status"]) == "Y")
                {
                    if (iSpanDays == 1)
                        strStatus = "Your applied leave on " + Convert.ToString(drNotifications["From_Date"]) + " was approved.";
                    else
                        strStatus = "Your applied leave from " + Convert.ToString(drNotifications["From_Date"]) + " to " + Convert.ToString(drNotifications["To_Date"]) + " was approved.";
                }
                else if(Convert.ToString(drNotifications["Approved_status"]) == "F")
                {
                    if(iSpanDays == 1)
                        strStatus = "Your applied leave on " + Convert.ToString(drNotifications["From_Date"]) + " was rejected. \n Reason : Too Frequent.";
                    else
                        strStatus = "Your applied leave from " + Convert.ToString(drNotifications["From_Date"]) + " to " + Convert.ToString(drNotifications["To_Date"]) + " was rejected. \n Reason : Too Frequent.";
                }
                else if(Convert.ToString(drNotifications["Approved_status"]) == "P")
                {
                    if(iSpanDays == 1)
                        strStatus = "Your applied leave on " + Convert.ToString(drNotifications["From_Date"]) + " was rejected. \n Reason : Less PTO Balance.";
                    else
                        strStatus = "Your applied leave from " + Convert.ToString(drNotifications["From_Date"]) + " to " + Convert.ToString(drNotifications["To_Date"]) + " was rejected. \n Reason : Less PTO Balance.";
                }
                else if (Convert.ToString(drNotifications["Approved_status"]) == "R")
                {
                    if (iSpanDays == 1)
                        strStatus = "Your applied leave on " + Convert.ToString(drNotifications["From_Date"]) + " was rejected.";
                    else
                        strStatus = "Your applied leave from " + Convert.ToString(drNotifications["From_Date"]) + " to " + Convert.ToString(drNotifications["To_Date"]) + " was rejected.";
                }
                lstNotifications.Add(strStatus);
                strUpdateQuery[0] = "UPDATE TBL_VACATIONS SET SHOW_NOTIFICATIONS = 0 WHERE PKEY = "+ Convert.ToInt32(drNotifications["PKEY"])  +"";
                dbcProjectInfo.executeNonQuery(strUpdateQuery);
            }
        }
        return lstNotifications;
    }

    [WebMethod(EnableSession=true)]
    public static List<CVacation> LoadVacations()
    {
        if (lstVacation != null)
        {
            lstVacation.Clear();
            string strAsscID = "";
            string strTeam = dbcProjectInfo.retrieveScalar("SELECT PKEY FROM tbl_teams WHERE Team_Name = '" + Convert.ToString(strTeamName) + "'");
            DataTable dtAssocDetails = dbcProjectInfo.GenerateDataTable("SELECT * FROM TBL_ASSOCIATE WHERE IFNULL(TEAM_ID,'') = " + strTeam + "");
            if (dtAssocDetails.Rows.Count > 0)
                strAsscID = string.Join(",", dtAssocDetails.AsEnumerable().Select(x => x.Field<string>("ID")).ToArray());
            DataTable dtVacations = dbcProjectInfo.GenerateDataTable("SELECT * FROM V_XL_TBL_VACATION WHERE ID IN ('" + strAsscID.Replace(",", "','") + "')");
            iUniqueID = Convert.ToInt32(dbcProjectInfo.retrieveScalar("SELECT IFNULL(MAX(PKEY),0) FROM `v_xl_tbl_vacation`"));
            iUniqueID = iUniqueID + 1;
            if (dtVacations.Rows.Count > 0)
            {
                foreach (DataRow dr in dtVacations.Rows)
                {
                    int iBal = CUtility.GetPTOBlance(Convert.ToString(dr["ID"]), DateTime.Now.Year);
                    string strAssocView = "Y";
                    string strTitle = "";
                    if (Convert.ToString(dr["ID"]).ToUpper() == Convert.ToString(HttpContext.Current.Session["AssocID"]).ToUpper())
                    {
                        strAssocView = "Y";
                        strTitle = Convert.ToString(dr["Title"]);
                    }
                    else
                    {
                        strAssocView = "N";
                        strTitle = Convert.ToString(dr["Name"]);
                    }
                    lstVacation.Add(new CVacation(Convert.ToInt32(dr["PKEY"]), Assoc, Convert.ToDateTime(dr["from_date"]).ToString("yyyy-MM-dd"),
                            Convert.ToDateTime(dr["to_date"]).ToString("yyyy-MM-dd"), Convert.ToDateTime(dr["Org_from_date"]).ToString("yyyy-MM-dd"),
                            Convert.ToDateTime(dr["Org_to_date"]).ToString("yyyy-MM-dd"), strTitle, Convert.ToString(dr["Description"]), true, Convert.ToString(dr["Approved_status"]), "N", "", Convert.ToString(dr["ID"]), Convert.ToString(dr["EMAIL_ID"]), iBal, strAssocView, Convert.ToString(dr["Comments"]), false));
                }
            }
        }
        return lstVacation;
    }

    [WebMethod]
    public static List<CHolidays> AddHolidays()
    {
        if (lstHolidays != null)
        {
            if (lstHolidays.Count == 0)
            {
                DataTable dtHolidays = dbcProjectInfo.GenerateDataTable("SELECT * FROM TBL_HOLIDAYS");
                if (dtHolidays.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtHolidays.Rows)
                    {
                        lstHolidays.Add(new CHolidays(Convert.ToInt32(dr["PKEY"]), Convert.ToDateTime(dr["Date"]).ToString("yyyy-MM-dd"), Convert.ToDateTime(dr["Date"]).ToString("yyyy-MM-dd"),
                            Convert.ToString(dr["vacation"]), "", true, "N"));
                    }
                }
            }
        }
        return lstHolidays;
    }

    [WebMethod]
    public static List<CVacation> AddVacation(string Title, string Reason, string startDate, string endDate)
    {
        List<CVacation> lstReturn = new List<CVacation>();
        if (lstVacation != null)
        {   
            #region kishna's old logic
            DateTime dateTime = new DateTime(1970, 1, 1, 0, 0, 0, 0);
            startDate = dateTime.AddSeconds(Convert.ToInt64(startDate.Substring(0, endDate.Length - 3))).ToString();
            endDate = dateTime.AddSeconds(Convert.ToInt64(endDate.Substring(0, endDate.Length - 3))).ToString();
            DateTime dtStartDate = Convert.ToDateTime(startDate);
            DateTime dtendDate = Convert.ToDateTime(endDate);

            //Assoc should not add leave on vacation
            if (lstHolidays.Where(x => x.startDate == Convert.ToDateTime(startDate).ToString("yyyy-MM-dd")).Count() > 0)
            {
                lstReturn.Add(new CVacation(0, Assoc, "", "","","", "", "", false, "", "", "Holiday", "", "", 0, "","",false));
                return lstReturn;
            }

            //Validation for checking if user applies leave on same day twice
            foreach (CVacation vacation in lstVacation)
            {
                if (Convert.ToString(HttpContext.Current.Session["AssocID"]).ToUpper() == vacation.AssocName.ToUpper())
                {
                    if (Convert.ToDateTime(vacation.FromDate) < dtendDate && dtStartDate < Convert.ToDateTime(vacation.ToDate))
                    {
                        lstReturn.Add(new CVacation(0, Assoc, "", "","","", "", "", false, "", "", "Duplicate", "", "", 0, "","",false));
                        return lstReturn;
                    }
                }
            }
            
            if(CUtility.IsDuplicateVacation(Convert.ToString(HttpContext.Current.Session["AssocID"]).ToUpper(),Convert.ToDateTime(startDate),Convert.ToDateTime(endDate)))
            {
                lstReturn.Add(new CVacation(0, Assoc, "", "","","", "", "", false, "", "", "Duplicate", "", "", 0, "","",false));
                return lstReturn;
            }

            //Multiple Vacation
            TimeSpan ts = Convert.ToDateTime(endDate) - Convert.ToDateTime(startDate);
            if (ts.Days > 1)
            {
                for (DateTime date = Convert.ToDateTime(startDate); date.Date < Convert.ToDateTime(endDate).Date; date = date.AddDays(1))
                {
                    lstVacation.Add(new CVacation(iUniqueID, Assoc, Convert.ToDateTime(date).ToString("yyyy-MM-dd"), Convert.ToDateTime(date.AddDays(1)).ToString("yyyy-MM-dd"), Convert.ToDateTime(startDate).ToString("yyyy-MM-dd"), Convert.ToDateTime(endDate).ToString("yyyy-MM-dd"), Title, Reason, false, "N", "N", "", "", "", 0, "Y", "", false));
                    iUniqueID++;
                }
                lstReturn.Add(new CVacation(iUniqueID - 1, Assoc, Convert.ToDateTime(startDate).ToString("yyyy-MM-dd"), Convert.ToDateTime(endDate).ToString("yyyy-MM-dd"), Convert.ToDateTime(startDate).ToString("yyyy-MM-dd"), Convert.ToDateTime(endDate).ToString("yyyy-MM-dd"), Title, Reason, false, "N", "N", "", "", "", 0, "Y", "", false));
            }
            else
            {
                lstVacation.Add(new CVacation(iUniqueID, Assoc, Convert.ToDateTime(startDate).ToString("yyyy-MM-dd"), Convert.ToDateTime(endDate).ToString("yyyy-MM-dd"), Convert.ToDateTime(startDate).ToString("yyyy-MM-dd"), Convert.ToDateTime(endDate).ToString("yyyy-MM-dd"), Title, Reason, false, "N", "N", "", "", "", 0, "Y", "", false));
                lstReturn.Add(new CVacation(iUniqueID, Assoc, Convert.ToDateTime(startDate).ToString("yyyy-MM-dd"), Convert.ToDateTime(endDate).ToString("yyyy-MM-dd"), Convert.ToDateTime(startDate).ToString("yyyy-MM-dd"), Convert.ToDateTime(endDate).ToString("yyyy-MM-dd"), Title, Reason, false, "N", "N", "", "", "", 0, "Y", "", false));
                iUniqueID++;
            }
            #endregion
        }
        return lstReturn;
    }

    [WebMethod]
    public static List<CVacation> UpdateVacation(string Title, string Reason, int ID)
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
                        if (cMItem.bExisting)
                        {
                            cMItem.bExisting = false;
                            cMItem.Title = Title;
                            cMItem.Reason = Reason;
                            cMItem.isEdited = "Y";
                        }
                        else
                        {
                            cMItem.Title = Title;
                            cMItem.Reason = Reason;
                            cMItem.isEdited = "N";
                        }
                    }

                }
            }
            else
            {
                if (item.bExisting)
                {
                    item.bExisting = false;
                    item.Title = Title;
                    item.Reason = Reason;
                    item.isEdited = "Y";
                }
                else
                {
                    item.Title = Title;
                    item.Reason = Reason;
                    item.isEdited = "N";
                }
            }
            lstReturn = lstVacation.GetRange(lstIndex, 1);
        }

        return lstReturn;
    }

    [WebMethod]
    public static void Removevacation(int ID)
    {

        var lstIndex = lstVacation.FindIndex(x => x.ID == ID);
        if (lstIndex >= 0)
        {
            CVacation item = lstVacation[lstIndex];
            DateTime dtStartDate = Convert.ToDateTime(item.mFromDate);
            DateTime dtToDate = Convert.ToDateTime(item.mToDate);
            TimeSpan ts = dtToDate - dtStartDate;
            if (ts.Days > 1)
            {
                for (DateTime date = dtStartDate; date.Date < dtToDate.Date; date = date.AddDays(1))
                {
                    var lstMIndex = lstVacation.FindIndex(x => x.FromDate == Convert.ToDateTime(date).ToString("yyyy-MM-dd"));
                    if (lstMIndex >= 0)
                    {
                        CVacation cMItem = lstVacation[lstMIndex];
                        if (cMItem.bExisting)
                        {
                            string[] strQuery = { "DELETE FROM TBL_VACATIONS WHERE PKEY = " + cMItem.ID + "" };
                            dbcProjectInfo.executeNonQuery(strQuery);
                        }
                    }
                    lstVacation.Remove(lstVacation[lstMIndex]);
                }
                
                if (item.bExisting)
                {
                    string[] strQuery = { "DELETE FROM TBL_VACATIONS WHERE PKEY = " + ID + "" };
                    dbcProjectInfo.executeNonQuery(strQuery);
                    CUtility.SendCancelNotificationMailToManager(strAssocName, strMailID, Convert.ToDateTime(item.mFromDate), Convert.ToDateTime(item.mToDate), item.Title, item.Reason);
                }
            }
            else
            {
                if (item.bExisting)
                {
                    string[] strQuery = { "DELETE FROM TBL_VACATIONS WHERE PKEY = " + ID + "" };
                    dbcProjectInfo.executeNonQuery(strQuery);
                    if ((Convert.ToDateTime(item.mToDate) - Convert.ToDateTime(item.mFromDate)).Days == 1)
                        CUtility.SendCancelNotificationMailToManager(strAssocName, strMailID, Convert.ToDateTime(item.mFromDate), Convert.ToDateTime(item.mToDate), item.Title, item.Reason);
                }
                lstVacation.Remove(lstVacation[lstIndex]);
            }
            
        }
    }

    public void lnkbtnSubmit_Click(object sender, EventArgs eventargs)
    {
        if (iBalancePTO > 0)
        {
            string[] strQuery = new string[lstVacation.Count];
            foreach (CVacation item in lstVacation.Where(x => x.bExisting == false && x.Error == ""))
            {
                if (item.isEdited == "N")
                {
                    strQuery[0] = "INSERT INTO TBL_VACATIONS(ASSOCIATE_KEY,FROM_DATE,TO_DATE,`STATUS`,TITLE,DESCRIPTION,UPDATED_TIME,ORG_FROM_DATE,ORG_TO_DATE) values(" + iAssocID + ",'" + item.FromDate + "','" + item.ToDate + "',0,'" + item.Title + "','" + item.Reason + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:MM:ss") + "','" + item.mFromDate + "','" + item.mToDate + "')";
                }
                else
                {
                    strQuery[0] = "UPDATE TBL_VACATIONS SET TITLE = '" + item.Title + "', DESCRIPTION = '" + item.Reason + "' WHERE PKEY = " + item.ID + "";
                }
                dbcProjectInfo.executeNonQuery(strQuery);
                if ((Convert.ToDateTime(item.mToDate) - Convert.ToDateTime(item.mFromDate)).Days == 1)
                    CUtility.SendNotificationMailToManager(strAssocName, strMailID, Convert.ToDateTime(item.mFromDate), Convert.ToDateTime(item.mToDate), Convert.ToString(item.Title), Convert.ToString(item.Reason));
            }
        }
        else if (iBalancePTO == 0 && lstVacation.Where(x => x.bExisting == false && x.Error == "").Count() != 0)
        {
            CUtility.CreateMessageAlert(this.Page, "Insufficient PTO Balance");
            return;
        }
        
    }
}

