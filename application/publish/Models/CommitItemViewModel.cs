using Assignment.Core.SubmissionStoreProvider;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Assignment.Models
{
    public class CommitItemViewModel : ViewModel
    {
        public CommitItemViewModel()
        {

        }

        public CommitItemViewModel(CommitItem obj)
        {
            if (obj == null) throw new ArgumentNullException("obj");
            Refresh(obj);
        }

        public void Refresh(CommitItem obj)
        {
            var source = obj;
            var dest = this;

            dest.Message = source.Message;
            dest.Timestamp = source.Timestamp;
            dest.Author = source.Author;
            dest.Email = source.Email;
        }

        public string Message { get; set; }
        public DateTime Timestamp { get; set; }

        public string Author { get; set; }
        public string Email { get; set; }
    }
}