using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace DBHelper
{
    public static class StaticMembers
    {
        public static string _PROJECT_PKEY;
        public static string _CLIENT_NAME;
        public static string _PROJECT_NAME;
        public static string _CONNECTION_STRING;
        public static string _PRIMARYTABLE;
        public static string _APP_NAME;
        public static string _APP_VERSION;
        public static string _DISPLAY_DATE_FORMAT;
        
        
        public static string _USERNAME;
        public static string _USER_ROLE;
        public static string _EMPLOYEE_NAME;
        public static string _EMPID;


        public static string _FIELDS;
        public static string _LEASEPKEY;
        public static string _RECORD_PKEY;
        public static string _SECTIONNAME;
        public static string _SECTIONTABLE;
        public static string _ACTION;
        public static string _DELETE_TIME;

        public static string _LEASEIDTOSELECT;
        public static string _SAVE_TIME;


        public static string _HIDEMAINHEADER;
        public static string _MENU_NAME;
        public static string _NODE_TAG;
        public static string _NODE_TEXT;
        

        public static string _REPORTPKEY;
        
      
        
        
        
                

        public static void WriteLogFile(string ErrorMsg, string ClassName, string FunctionName)
        {
            try
            {
                //string strErrorPath;
                //strErrorPath = AppDomain.CurrentDomain.BaseDirectory + "\\errorlog.txt";
                //StreamWriter sw = new StreamWriter(strErrorPath, true);
                //sw.Write(ErrorMsg + "-" + ClassName + "-" + FunctionName + "\r");
                //sw.Flush();
                //sw.Close();
                //sw.Dispose();
                //sw = null;
            }
            catch (Exception err)
            {
                string strErr = err.Message;
            }
        }
    }

    public class WebConfigurationSettings
    {
        public string ProjectPkey { get; set; }
        public string ClientName { get; set; }
        public string ProjectName { get; set; }
        public string ConnectionString { get; set; }
        public string ApplicationName { get; set; }
        public string ApplicationVersion { get; set; }
        public string DisplayDateFormat { get; set; }
        public string UserPkey { get; set; }
        public string UserName { get; set; }
        public string UserRole { get; set; }
        public string UserFullName { get; set; }
        public string EmployeeId { get; set; }
        public string PrimaryTable { get; set; }
        public string KeyFields { get; set; }
        public string LeasePkey { get; set; }
        public string RecordPkey { get; set; }
        public string SectionName { get; set; }
        public string SectionTable { get; set; }
        public string Action { get; set; }
        public string DeleteTime { get; set; }
        public string SaveTime { get; set; }
        public string BulkSelectKeyField { get; set; }
        public string BulkSelectLeaseIdList { get; set; }
        public string MainMenuHeaderDisplayStatus { get; set; }
        public string MenuName { get; set; }
        public string NodeTag { get; set; }
        public string NodeText { get; set; }
        public string LastAccessedPage { get; set; }
        public string BVEngineXMLPath { get; set; }
        public string MoneyFormat { get; set; }
        public string OutputPath { get; set; }
        public string RecordAuditTrail { get; set; }
        public string DocumentPath { get; set; }
        public string DocumentSite { get; set; }
        public string IsDocumentSection { get; set; }//Added by kishore for DocSync
        public string IsClientCommentsSection { get; set; }//Added by kishore for Client Feedback Sections
        public string IsDoubleCheckFeedbackSection { get; set; }//Added by kishore for Client Feedback Sections
        public string BVCodeXMLPath { get; set; } // Added by Maha for Displaying Code Based BV which is configured in another XML
        public string IsClientCommentsDependable { get; set; } // Added by Maha for checking whether client comments has to display from dependable dropdown
    }
}