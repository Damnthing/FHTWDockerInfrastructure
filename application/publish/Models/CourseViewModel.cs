using Assignment.Core;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Assignment.Models
{
    public class CourseViewModel : ViewModel
    {
        public CourseViewModel()
        {
        }

        public CourseViewModel(Course obj)
            : this()
        {
            if (obj == null) throw new ArgumentNullException("obj");
            Refresh(obj);
        }

        public void Refresh(Course obj)
        {
            var source = obj;
            var dest = this;

            dest.ID = source.ID;
            dest.Name = source.Name;
            dest.IsActive = source.IsActive;
            dest.Notes = source.Notes;
            dest.UserUIDs = source.UserUIDs;
            dest.SubmissionType = source.SubmissionType;
        }

        public void ApplyChanges(Course obj)
        {
            if (obj == null) throw new ArgumentNullException("obj");
            var source = this;
            var dest = obj;

            dest.Name = source.Name?.Trim();
            dest.IsActive = source.IsActive;
            dest.Notes = source.Notes;
            dest.UserUIDs = source.UserUIDs;
            dest.SubmissionType = source.SubmissionType;
        }

        public int ID { get; private set; }

        [Required]
        public bool IsActive { get; set; }

        [Required]
        public string Name { get; set; }

        public string Notes { get; set; }
        public string UserUIDs { get; set; }

        [Required]
        [DisplayName("Sub. Type")]
        public SubmissionTypes SubmissionType { get; set; }
        public IEnumerable<SelectListItem> SubmissionTypes
        {
            get
            {
                return new[]
                {
                    new SelectListItem() { Value="Upload", Text="Upload" },
                    new SelectListItem() { Value="Git", Text="Git" },
                    new SelectListItem() { Value="Moodle", Text="Moodle" },
                };
            }
        }

        public IEnumerable<AssignmentItemViewModel> Assignments { get; set; }

        private IEnumerable<GroupWorkViewModel> _groupWorks;
        public IEnumerable<GroupWorkViewModel> GroupWorks
        {
            get
            {
                return _groupWorks;
            }
            set
            {
                _groupWorks = value;
                RefreshGroupWorksAsYaml();
            }
        }

        private void RefreshGroupWorksAsYaml()
        {
            if (_groupWorks != null)
            {
                GroupWorksAsYaml = string.Join("\n",
                    _groupWorks
                        .OrderBy(i => i.OwnerUID)
                        .Select(i => string.Format("      - {0}", i.OwnerUID)));
            }
            else
            {
                GroupWorksAsYaml = null;
            }
        }
        public string GroupWorksAsYaml { get; private set; }

    }
}