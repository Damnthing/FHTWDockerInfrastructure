using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Assignment.Models
{
    public class LogFileViewModel
    {
        public IEnumerable<LogLineViewModel> Lines { get; set; }
    }

    public class LogLineViewModel
    {
        public string Message { get; set; }
        public string Color
        {
            get
            {
                if (Message.StartsWith("\t")) return "red";
                if (Message.Contains("[DEBUG]")) return "darkgray";
                if (Message.Contains("[WARN]")) return "#aa0";
                if (Message.Contains("[ERROR]")) return "red";
                return "black";
            }
        }
    }
}
