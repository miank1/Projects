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

public partial class VacationPlanner : System.Web.UI.Page
{
    static DBConnection dbcProjectInfo;
    static List<CHolidays> lstHolidays = null;
    static int iUniqueID = 1;
    protected void Page_Load(object sender, EventArgs e)
    {
        dbcProjectInfo = new DBConnection(ConfigurationManager.AppSettings["ProjectInfo"]);
        if (!IsPostBack)
        {
            lstHolidays = new List<CHolidays>();
        }
        InitalizeDetails();
    }

    private void InitalizeDetails()
    {
        DataTable dtHolidays = dbcProjectInfo.GenerateDataTable("SELECT * FROM TBL_HOLIDAYS");
        if (dtHolidays.Rows.Count > 0)
        {
            lblVacation.Text = "<b>#.of Holidays : " + dtHolidays.Rows.Count + "</b>";
        }
    }

    [WebMethod]
    public static List<CHolidays> LoadHolidays()
    {
        lstHolidays.Clear();
        DataTable dtHolidays = dbcProjectInfo.GenerateDataTable("SELECT * FROM TBL_HOLIDAYS");
        iUniqueID = Convert.ToInt32(dbcProjectInfo.retrieveScalar("SELECT IFNULL(MAX(PKEY),0) FROM `TBL_HOLIDAYS`"));
        iUniqueID = iUniqueID + 1;
        if (dtHolidays.Rows.Count > 0)
        {
            foreach (DataRow dr in dtHolidays.Rows)
            {
                lstHolidays.Add(new CHolidays(Convert.ToInt32(dr["PKEY"]),Convert.ToDateTime(dr["Date"]).ToString("yyyy-MM-dd"), Convert.ToDateTime(dr["Date"]).ToString("yyyy-MM-dd"),
                        Convert.ToString(dr["vacation"]),"",true,"N"));
            }
        }
        return lstHolidays;
    }

    [WebMethod]
    public static List<CHolidays> AddHolidays(string startDate, string endDate, string ocassion)
    {
        List<CHolidays> lstReturn = new List<CHolidays>();
        DateTime dateTime = new DateTime(1970, 1, 1, 0, 0, 0, 0);
        startDate = dateTime.AddSeconds(Convert.ToInt64(startDate.Substring(0, startDate.Length - 3))).ToString();
        endDate = dateTime.AddSeconds(Convert.ToInt64(endDate.Substring(0, endDate.Length - 3))).ToString();

        //Validation for checking if user applies leave on same day twice
        if (lstHolidays.Where(x => x.startDate == Convert.ToDateTime(startDate).ToString("yyyy-MM-dd")).Count() > 0)
        {
            lstReturn.Add(new CHolidays(0,"","","","Duplicate",false,""));
            return lstReturn;
        }

        lstHolidays.Add(new CHolidays(iUniqueID, Convert.ToDateTime(startDate).ToString("yyyy-MM-dd"), Convert.ToDateTime(endDate).ToString("yyyy-MM-dd"), ocassion, "", false, "N"));
        lstReturn.Add(new CHolidays(iUniqueID, Convert.ToDateTime(startDate).ToString("yyyy-MM-dd"), Convert.ToDateTime(endDate).ToString("yyyy-MM-dd"), ocassion, "", false, "N"));
        iUniqueID++;
        return lstReturn;
    }

    [WebMethod]
    public static List<CHolidays> UpdateHoliday(string Ocassion, int ID)
    {
        var lstIndex = lstHolidays.FindIndex(x => x.Id == ID);
        List<CHolidays> lstReturn = null;
        CHolidays item = null;

        if (lstIndex >= 0)
        {
            item = lstHolidays[lstIndex];
            if (item.bExisting)
            {
                item.bExisting = false;
                item.Occasion = Ocassion;
                item.isEdited = "Y";
            }
            else
            {
                item.Occasion = Ocassion;
                item.isEdited = "N";
            }
            lstReturn = lstHolidays.GetRange(lstIndex, 1);
        }

        return lstReturn;
    }

    [WebMethod]
    public static void RemoveHolidays(int ID)
    {

        var lstIndex = lstHolidays.FindIndex(x => x.Id == ID);
        if (lstIndex >= 0)
        {
            CHolidays item = lstHolidays[lstIndex];
            if (item.bExisting)
            {
                string[] strQuery = { "DELETE FROM TBL_HOLIDAYS WHERE PKEY = " + ID + "" };
                dbcProjectInfo.executeNonQuery(strQuery);
            }
            lstHolidays.Remove(lstHolidays[lstIndex]);
        }
    }

    public void lnkbtnSubmit_Click(object sender, EventArgs eventargs)
    {
        string[] strQuery = new string[lstHolidays.Count];
        
        foreach (CHolidays item in lstHolidays.Where(x => x.bExisting == false && x.Error == ""))
        {
            if (item.isEdited == "N")
            {
                strQuery[0] = "INSERT INTO TBL_HOLIDAYS(Date,vacation,updated_time) values('" + item.startDate + "','" + item.Occasion + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:MM:ss") + "')";
            }
            else
            {
                strQuery[0] = "UPDATE TBL_HOLIDAYS SET vacation = '" + item.Occasion + "' WHERE PKEY = " + item.Id + "";
            }
            dbcProjectInfo.executeNonQuery(strQuery);
            InitalizeDetails();
        }
        if(lstHolidays.Where(x => x.bExisting == false && x.Error == "").Count() > 0)
            CUtility.SendHolidayNotification(lstHolidays);
    }
}

