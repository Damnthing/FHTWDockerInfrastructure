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
    public class GroupWorkViewModel : ViewModel
    {
        public GroupWorkViewModel()
        {
        }

        public GroupWorkViewModel(GroupWork obj)
            : this()
        {
            if (obj == null) throw new ArgumentNullException("obj");
            Refresh(obj);
        }

        public void Refresh(GroupWork obj)
        {
            var source = obj;
            var dest = this;

            dest.ID = source.ID;
            dest.OwnerUID = source.OwnerUID;
            dest.Course = source.Course.Name;
            dest.Name = source.Name;
            dest.Notes = source.Notes;
            dest.CreatedOn = source.CreatedOn;
            dest.ChangedOn = source.ChangedOn;

            dest.GroupWorkMembersCount = source.Member.Count(i => i.DeletedOn.HasValue == false);
        }

        public void ApplyChanges(GroupWork obj, BL bl)
        {
            if (obj == null) throw new ArgumentNullException("obj");
            var source = this;
            var dest = obj;

            dest.Course = bl.GetCourses().Single(c => c.Name == source.Course);
            dest.Name = source.Name;
            dest.Notes = source.Notes;
        }

        public int ID { get; private set; }

        [Required]
        public string Course { get; set; }
        private IEnumerable<Course> _courseItems;
        public IEnumerable<SelectListItem> CourseItems
        {
            get
            {
                return new[] { new SelectListItem() { Text = "Please select a course", Value = "" } }
                    .Concat(
                        (_courseItems ?? Enumerable.Empty<Course>())
                        .Select(i => new SelectListItem()
                        {
                            Selected = i.Name == this.Course,
                            Text = i.Name,
                            Value = i.Name
                        }))
                    .ToList();
            }
        }
        public void SetCourseItems(IEnumerable<Course> items)
        {
            _courseItems = items;
        }

        public IEnumerable<GroupWorkMemberViewModel> GroupWorkMembers { get; private set; }
        public void SetGroupWorkMembers(IEnumerable<GroupWorkMember> members)
        {
            if (members == null) throw new ArgumentNullException("members");
            GroupWorkMembers = members.OrderBy(i => i.AddedOn).Select(i => new GroupWorkMemberViewModel(i)).ToList();
            GroupWorkMembersCount = GroupWorkMembers.Count(i => i.DeletedOn.HasValue == false);
        }

        [Display(Name = "Owner UID")]
        public string OwnerUID { get; set; }

        public DateTime CreatedOn { get; private set; }
        public DateTime ChangedOn { get; private set; }

        [Display(Name = "Group name", Prompt = "OPTIONAL: name of the group.")]
        public string Name { get; set; }
        [Display(Prompt = "OPTIONAL: some notes.")]
        public string Notes { get; set; }

        [Display(Name = "# Members")]
        public int GroupWorkMembersCount { get; private set; }

        public bool ShowManageButton
        {
            get
            {
                return IsAdmin || OwnerUID == CurrentUID;
            }
        }

    }
}