using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace VacationTracker
{
    public class CAssociate:CPerson
    {
        int BalancePTO{set; get;}
        int ID;
        CTeam team;
        public bool isManager = false;
        public String AssocID { set; get; }

        public CAssociate(int ID, string name, int BalancePTO, CTeam team)
        {
            // TODO: Complete member initialization
            this.ID = ID;
            this._Name = name;
            this.BalancePTO = BalancePTO;
            this.team = team;
        }

    }
}