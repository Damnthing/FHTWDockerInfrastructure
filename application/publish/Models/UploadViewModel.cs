using Assignment.Core;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Assignment.Models
{
    public class UploadViewModel : ViewModel
    {
        public UploadViewModel()
        {

        }

        public UploadViewModel(AssignmentItem obj)
        {
            Assignment = new AssignmentItemViewModel(obj);
            Course = new CourseViewModel(obj.Course);
        }
        public AssignmentItemViewModel Assignment { get; set; }
        public CourseViewModel Course { get; set; }

        public IEnumerable<SubmissionItemViewModel> CurrentContent { get; set; }
        public IEnumerable<CommitItemViewModel> Commits { get; set; }

        public bool UnCommitedChanges
        {
            get
            {
                return CurrentContent != null ? CurrentContent.Any(c => c.Added || c.Modified) : false;
            }
        }
    }
}