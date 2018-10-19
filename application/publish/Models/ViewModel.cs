using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Assignment.Models
{
    public class ViewModel
    {
        public string CurrentUID
        {
            get
            {
                return System.Threading.Thread.CurrentPrincipal.Identity.Name;
            }
        }

        public bool IsAdmin
        {
            get
            {
                return System.Threading.Thread.CurrentPrincipal.IsInRole("Admin");
            }
        }

        public string SuccessMessage { get; set; }
    }
}
