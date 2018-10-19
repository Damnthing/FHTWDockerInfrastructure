using Assignment.Core;
using Assignment.Core.BL;
using Assignment.Core.DAL;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Assignment.Models
{
    public class ManageGroupWorkViewModel : ViewModel
    {
        public ManageGroupWorkViewModel()
        {
        }

        public ManageGroupWorkViewModel(GroupWork obj)
            : this()
        {
            if (obj == null) throw new ArgumentNullException("obj");
            Refresh(obj);
        }

        public void Refresh(GroupWork obj)
        {
            var source = obj;
            var dest = this;

            dest.GroupWork = new GroupWorkViewModel(obj);
        }

        public string AddUID { get; set; }

        public GroupWorkViewModel GroupWork { get; private set; }
    }
}