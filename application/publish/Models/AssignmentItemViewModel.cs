using Assignment.Core;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Assignment.Models
{
    public class AssignmentItemViewModel : ViewModel
    {
        public AssignmentItemViewModel()
        {
        }

        public AssignmentItemViewModel(AssignmentItem obj)
            : this()
        {
            if (obj == null) throw new ArgumentNullException("obj");
            Refresh(obj);
        }

        public void Refresh(AssignmentItem obj)
        {
            var source = obj;
            var dest = this;

            dest.ID = source.ID;
            dest.Name = source.Name;
            dest.OpenFrom = source.OpenFrom;
            dest.DueDate = source.DueDate;
            dest.Notes = source.Notes;
            dest.NotifyCIServer = source.NotifyCIServer;

            dest.IsActive = obj.IsActive;
        }

        public void ApplyChanges(AssignmentItem obj)
        {
            if (obj == null) throw new ArgumentNullException("obj");
            var source = this;
            var dest = obj;

            dest.Name = source.Name?.Trim();
            dest.OpenFrom = source.OpenFrom;
            dest.DueDate = source.DueDate ?? DateTime.MinValue;
            dest.Notes = source.Notes;
            dest.NotifyCIServer = source.NotifyCIServer;
        }

        public bool IsActive { get; private set; }

        public int ID { get; private set; }

        [Required]
        public string Name { get; set; }

        public DateTime? OpenFrom { get; set; }
        [Required]
        public DateTime? DueDate { get; set; }

        public string Notes { get; set; }

        [DisplayName("Notify CI-Server")]
        public bool NotifyCIServer { get; set; }
        
        public CourseViewModel Course { get; set; }

        public bool ShowFiles
        {
            get
            {
                if (IsAdmin) return true;
                return IsActive
                    && (!OpenFrom.HasValue || OpenFrom.Value <= DateTime.Now) // TODO: Is this reduntant? IsActive contains a date check
                    && (!DueDate.HasValue || DueDate.Value >= DateTime.Now);
            }
        }

        public bool HasFiles
        {
            get
            {
                return ShowFiles && CurrentFileContent != null && CurrentFileContent.Any();
            }
        }

        public bool AllowAdminUpload
        {
            get
            {
                return !IsActive && IsAdmin;
            }
        }

        public bool AllowAdminView
        {
            get
            {
                return !IsActive && IsAdmin;
            }
        }

        public IEnumerable<SubmissionItemViewModel> CurrentFileContent { get; set; }
        public IEnumerable<CommitItemViewModel> FileCommits { get; set; }

        public bool UnCommitedFileChanges
        {
            get
            {
                return CurrentFileContent != null ? CurrentFileContent.Any(c => c.Added || c.Modified) : false;
            }
        }
    }
}