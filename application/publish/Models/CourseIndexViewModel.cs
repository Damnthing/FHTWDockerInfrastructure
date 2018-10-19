using Assignment.Core;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Assignment.Models
{
    public class CourseIndexViewModel : ViewModel
    {
        public CourseIndexViewModel()
        {
        }

        public IEnumerable<CourseViewModel> Courses { get; set; }

        public bool ShowWithInactiveLink { get; set; }
        public bool ShowOnlyActiveLink { get; set; }
    }
}