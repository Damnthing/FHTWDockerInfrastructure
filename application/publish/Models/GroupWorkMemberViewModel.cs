using Assignment.Core;
using Assignment.Core.BL;
using Assignment.Core.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Assignment.Models
{
    public class GroupWorkMemberViewModel : ViewModel
    {
        public GroupWorkMemberViewModel()
        {

        }

        public GroupWorkMemberViewModel(GroupWorkMember obj)
            : this()
        {
            if (obj == null) throw new ArgumentNullException("obj");
            Refresh(obj);
        }

        public void Refresh(GroupWorkMember obj)
        {
            var source = obj;
            var dest = this;

            dest.ID = source.ID;
            dest.UID = source.UID;
            dest.OwnerUID = source.GroupWork.OwnerUID;
            dest.AddedOn = source.AddedOn;
            dest.DeletedOn = source.DeletedOn;
        }

        public void ApplyChanges(GroupWorkMember obj)
        {
            if (obj == null) throw new ArgumentNullException("obj");
            var source = this;
            var dest = obj;

            dest.UID = source.UID;
        }

        public int ID { get; private set; }

        public string UID { get; set; }
        public string OwnerUID { get; private set; }

        public DateTime AddedOn { get; set; }
        public DateTime? DeletedOn { get; set; }

        public bool ShowRemoveButton
        {
            get
            {
                return DeletedOn.HasValue == false
                    && (IsAdmin || OwnerUID == CurrentUID);
            }
        }

    }
}