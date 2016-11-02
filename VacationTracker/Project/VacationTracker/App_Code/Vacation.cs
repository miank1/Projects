using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace VacationTracker
{
    public class CVacation
    {
        CAssociate associate;
        public string FromDate;
        public string ToDate;
        public string mFromDate;
        public string mToDate;
        public string Title;
        public string Reason;
        public string Comments;
        public int ID;
        public bool bExisting;
        public string Approved;
        public string isEdited;
        public string Error;
        public string AssocName;
        public string AssocMailId;
        public int AsscPTOBal;
        public string AssocView;
        public bool bSplilBalance;
        //public string PTOBalance;
        public CVacation(int ID, CAssociate associate, string FromDate, string ToDate,string mFromDate,string mToDate, string Title, string Reason, bool bExisting, string Approved, string Edited, string Error, string AssocName, string AssocMailID, int AsscPTOBal, string AssocView, string Comments, bool bSplilBalance)
        {
            this.ID = ID;
            this.associate = associate;
            this.FromDate = FromDate;
            this.ToDate = ToDate;
            this.mFromDate = mFromDate;
            this.mToDate = mToDate;
            this.Title = Title;
            this.Reason = Reason;
            this.bExisting = bExisting;
            this.Approved = Approved;
            this.isEdited = Edited;
            this.Error = Error;
            this.AssocName = AssocName;
            this.AssocMailId = AssocMailID;
            this.AsscPTOBal = AsscPTOBal;
            this.AssocView = AssocView;
            this.Comments = Comments;
            this.bSplilBalance = bSplilBalance;
        }
        
    }
}