using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Task.Models;
using SigmaUtils;
using System.Data;
using System.Configuration;
namespace Task.Controllers
{
    public class LoginController : Controller
    {
        //
        // GET: /Login/
        string strConnString = ConfigurationManager.ConnectionStrings["ConnString"].ToString();
        [HttpGet]
        public ActionResult Login(string Name)
        {
            if (Name == "logout")
            {
                Response.Redirect("~/login/login");
                HttpContext.Session["User"] = "";
                Name = "";
            }
            return View();
        }


        [HttpPost]
        public ActionResult Login( Login login)
        {
            if (ModelState.IsValid)
            {
                DataTable dt = DBWizard.FillDataTable(strConnString, "SP_Select_Login",
                    new object[] { login.Username,login.Password });

                if (dt.Rows.Count > 0)
                {
                    HttpContext.Session["User"] = login.Username;

                    HttpContext.Session["Role"] = dt.Rows[0]["UserID"].ToString();

                    Response.Redirect("~/Univer/Index");
                }
                else
                {
                    ViewBag.name = "User Name and Password doesn't Match";
                }
            }

            return View();
        }
    }
}
