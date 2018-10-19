using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Assignment.Models
{
    public class LoginViewModel
    {
        [Required]
        [Display(Name = "UID")]
        public string UID { get; set; }

        [Required]
        [DataType(DataType.Password)]
        [Display(Name = "Password")]
        public string Password { get; set; }

        [Display(Name = "Remember me?")]
        public bool RememberMe { get; set; }

        public bool DisablePasswordCheck { get; set; }

        public string ReturnUrl { get; set; }

        public void Sanitize()
        {
            if(UID != null)
            {
                UID = UID.Trim().Replace(" ", "");
            }
        }
    }

    public class ImpersonateViewModel
    {
        [Required]
        [Display(Name = "UID")]
        public string UID { get; set; }

        [Display(Name = "As Admin")]
        public bool AsAdmin { get; set; }

        public void Sanitize()
        {
            if (UID != null)
            {
                UID = UID.Trim().Replace(" ", "");
            }
        }
    }
}
