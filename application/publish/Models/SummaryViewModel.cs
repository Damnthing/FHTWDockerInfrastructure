using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Assignment.Models
{
    public class SummaryViewModel
    {
        public string UID { get; set; }

        public List<GroupWorkViewModel> GroupWorks { get; set; }
        public bool ShowGroupWorks
        {
            get
            {
                return GroupWorks != null && GroupWorks.Count > 0;
            }
        }
    }
}