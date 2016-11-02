using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace VacationTracker
{
    public class CHolidays
    {
        public int Id { set; get; }
        public string startDate { set; get; }
        public string EndDate { set; get; }
        public string Occasion { set; get; }
        public string Error { set; get; }
        public bool bExisting { set; get; }
        public string isEdited { set; get;  }

        public CHolidays(int id,string startDate, string EndDate, string Occasion, string Error,bool Existing,string Edited)
        {
            // TODO: Complete member initialization
            this.Id = id;
            this.startDate = startDate;
            this.EndDate = EndDate;
            this.Occasion = Occasion;
            this.Error = Error;
            this.bExisting = Existing;
            this.isEdited = Edited;
        }
    }
}