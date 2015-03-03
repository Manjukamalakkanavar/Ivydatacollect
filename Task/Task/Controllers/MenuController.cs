using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Task.Controllers
{
    public class MenuController : Controller
    {
        //
        // GET: /Menu/

        [HttpGet]
        public ActionResult Menu()
        {
            if (HttpContext.Session["User"] != null)
            {

            }
            else
            {
                Response.Redirect("~/Login/Login");
            }
            return View();
        }

        [HttpPost]
        public ActionResult Menu(string Save)
        {
            if (HttpContext.Session["User"] != null)
            {
                if (Save == "Collect")
                {
                    Response.Redirect("~/Univer/Index");
                }
                else
                {
                    Response.Redirect("~/Data_View/Index");
                }
            }
            else
            {
                Response.Redirect("~/Login/Login");
            }
            return View();
        }
    }
}
