using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace VacationTracker
{
    public class CTeam
    {
        public string Name { set; get; }
        public string ManagerName { set; get; }
        public string EmailID { set; get; }

        public CTeam(string Name, string ManagerName, string pEmailID)
        {
            // TODO: Complete member initialization
            this.Name = Name;
            this.ManagerName = ManagerName;
            this.EmailID = pEmailID;
        }
    }
}