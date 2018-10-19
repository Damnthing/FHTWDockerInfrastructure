using Assignment.Core.SubmissionStoreProvider;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Assignment.Models
{
    public class SubmissionItemViewModel : ViewModel
    {
        public SubmissionItemViewModel()
        {

        }

        public SubmissionItemViewModel(SubmissionItem obj)
        {
            if (obj == null) throw new ArgumentNullException("obj");
            Refresh(obj);
        }

        public void Refresh(SubmissionItem obj)
        {
            var source = obj;
            var dest = this;

            dest.Name = source.Name;
            dest.FilePath = source.FilePath;
            dest.Added = source.Added;
            dest.Deleting = source.Deleting;
            dest.Modified = source.Modified;
            dest.IsHidden = StorageConstants.HiddenFiles.Contains(System.IO.Path.GetFileName(source.Name).ToLower());
        }

        public string Name { get; set; }
        public string FilePath { get; set; }
        public bool Added { get; set; }
        public bool Deleting { get; set; }
        public bool Modified { get; set; }

        public bool IsHidden { get; set; }
    }
}