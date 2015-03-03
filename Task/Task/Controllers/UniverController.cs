using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using SigmaUtils;
using System.Configuration;
using System.Data;
using Task.Models;

namespace Task.Controllers
{
    public class UniverController : Controller
    {
        //
        // GET: /Univer/

        string strConnString = ConfigurationManager.ConnectionStrings["ConnString"].ToString();

        public static int User_id = 0;
        public ActionResult Index()
        {
            List<Univer> list = new List<Univer>();
            if (HttpContext.Session["User"] != null)
            {

                User_id = Convert.ToInt32(HttpContext.Session["Role"]);

                DataTable dtdetails = DBWizard.FillDataTable(strConnString, "Sp_Select_ivyt_Universities");

                for (int i = 0; i < dtdetails.Rows.Count; i++)
                {
                    list.Add(new Univer
                    {
                        Universities_Name = dtdetails.Rows[i]["Name"].ToString(),
                        En_Universities_Name = Encode(dtdetails.Rows[i]["Name"].ToString() + "*" + dtdetails.Rows[i]["UniversityID"].ToString())
                    });
                }
            }
            else
            {
                Response.Redirect("~/Login/Login");
            }

            return View(list);
        }

        [HttpGet]
        public ActionResult View(string Name)
        {
            List<Univer> list = new List<Univer>();

            Univer uni = new Univer();

            if (HttpContext.Session["User"] != null)
            {

               

                DataTable dtdetails = DBWizard.FillDataTable(strConnString, "Sp_Select_ivyt_Universities");

                for (int i = 0; i < dtdetails.Rows.Count; i++)
                {
                    list.Add(new Univer
                    {
                        Universities_Name = dtdetails.Rows[i]["Name"].ToString(),
                        En_Universities_Name = Encode(dtdetails.Rows[i]["Name"].ToString() + "*" + dtdetails.Rows[i]["UniversityID"].ToString())
                    });
                }

                string na = Decode(Name);

                string[] na1 = na.Split('*');

                uni.uni = list;


                uni.Name = na1[0];

                DataTable dtAdmission = DBWizard.FillDataTable(strConnString, "Sp_Select_ivyt_AdmissionFees",
                       new object[] { na1[1] });


                if (dtAdmission.Rows.Count > 0)
                {
                    uni.count = 1;
                    uni.count1 = 3;
                    for (int i = 0; i < dtAdmission.Rows.Count; i++)
                    {
                        if (i == 0)
                        {

                            uni.Domestic_Fee = dtAdmission.Rows[i]["ApplicationFee"].ToString();
                            uni.Domestic_Notes = dtAdmission.Rows[i]["FeeWaiverNotes"].ToString();
                            uni.Domestic_Weaver = dtAdmission.Rows[i]["ApplicationFeeWaiver"].ToString();
                            uni.Domestic_URL = dtAdmission.Rows[i]["FeeDataURL"].ToString();
                            uni.Domestic_Comments = dtAdmission.Rows[i]["AdmissionFees_Comments"].ToString();

                        }
                        else
                        {

                            uni.International_Fee = dtAdmission.Rows[i]["ApplicationFee"].ToString();
                            uni.International_Notes = dtAdmission.Rows[i]["FeeWaiverNotes"].ToString();
                            uni.International_Weaver = dtAdmission.Rows[i]["ApplicationFeeWaiver"].ToString();
                            uni.International_URL = dtAdmission.Rows[i]["FeeDataURL"].ToString();
                            uni.International_Comments = dtAdmission.Rows[i]["AdmissionFees_Comments"].ToString();
                        }

                        uni.Status = dtAdmission.Rows[i]["AdmissionFees_Status"].ToString();


                    }
                }
                else
                {
                    uni.count = 0;
                    uni.count1 = 3;

                    uni.Domestic_URL = "http://";
                    uni.International_URL = "http://";

                    uni.International_Fee = "";
                    uni.International_Notes = "";
                    uni.International_Weaver = "";
                    uni.International_Comments = "";

                    uni.Domestic_Fee = "";
                    uni.Domestic_Notes = "";
                    uni.Domestic_Weaver = "";
                    uni.Domestic_Comments = "";
                }

                //Fall Application Admission
                DataTable dtFall = DBWizard.FillDataTable(strConnString, "Sp_Select_TB_Fall_Application_Dates",
                       new object[] { na1[1] });


                if (dtFall.Rows.Count > 0)
                {
                    uni.Fall_count = 1;

                    for (int i = 0; i < dtFall.Rows.Count; i++)
                    {
                        if (i == 0)
                        {
                            uni.Domestic_Admission_Deadline = dtFall.Rows[i]["Admission_Deadline"].ToString();
                            uni.Domestic_Admission_Notification = dtFall.Rows[i]["Admission_Notification"].ToString();
                            uni.Domestic_Admission_Deposit_Deadline = dtFall.Rows[i]["Admission_Deposit_Deadline"].ToString();
                            uni.Domestic_Admission_Offer = dtFall.Rows[i]["Admission_Offer"].ToString();
                            uni.Domestic_Admission_WaitingListUsed = dtFall.Rows[i]["Admission_WaitingListUsed"].ToString();
                            uni.Domestic_Defer_Admission = dtFall.Rows[i]["Defer_Admission"].ToString();
                            uni.Domestic_Transfer_Admission = dtFall.Rows[i]["Transfer_Admission"].ToString();
                            uni.Domestic_Application_Deadline = dtFall.Rows[i]["Application_Deadline"].ToString();
                            uni.Domestic_Admission_Notes = dtFall.Rows[i]["Admission_Notes"].ToString();
                            uni.Domestic_Data_URL = dtFall.Rows[i]["Data_URL"].ToString();
                            uni.Domestic_Fall_Comments = dtFall.Rows[i]["Fall_Comments"].ToString();
                        }
                        else
                        {
                            uni.International_Admission_Deadline = dtFall.Rows[i]["Admission_Deadline"].ToString();
                            uni.International_Admission_Notification = dtFall.Rows[i]["Admission_Notification"].ToString();
                            uni.International_Admission_Deposit_Deadline = dtFall.Rows[i]["Admission_Deposit_Deadline"].ToString();
                            uni.International_Admission_Offer = dtFall.Rows[i]["Admission_Offer"].ToString();
                            uni.International_Admission_WaitingListUsed = dtFall.Rows[i]["Admission_WaitingListUsed"].ToString();
                            uni.International_Defer_Admission = dtFall.Rows[i]["Defer_Admission"].ToString();
                            uni.International_Transfer_Admission = dtFall.Rows[i]["Transfer_Admission"].ToString();
                            uni.International_Application_Deadline = dtFall.Rows[i]["Application_Deadline"].ToString();
                            uni.International_Admission_Notes = dtFall.Rows[i]["Admission_Notes"].ToString();
                            uni.International_Data_URL = dtFall.Rows[i]["Data_URL"].ToString();
                            uni.International_Fall_Comments = dtFall.Rows[i]["Fall_Comments"].ToString();
                        }

                        uni.Fall_Status = dtFall.Rows[i]["Fall_Status"].ToString();
                    
                    }
                }
                else
                {
                    uni.Fall_count = 0;

                    uni.Domestic_Data_URL = "http://";
                    uni.International_Data_URL = "http://";
                    uni.Domestic_Admission_Deadline = "";
                    uni.Domestic_Admission_Notification = "";
                    uni.Domestic_Admission_Deposit_Deadline ="";
                    uni.Domestic_Admission_Offer = "";
                    uni.Domestic_Admission_WaitingListUsed = "";
                    uni.Domestic_Defer_Admission = "";
                    uni.Domestic_Transfer_Admission = "";
                    uni.Domestic_Application_Deadline = "";
                    uni.Domestic_Admission_Notes = "";
                    uni.Domestic_Fall_Comments ="";
                    uni.International_Admission_Deadline = "";
                    uni.International_Admission_Notification = "";
                    uni.International_Admission_Deposit_Deadline = "";
                    uni.International_Admission_Offer = "";
                    uni.International_Admission_WaitingListUsed = "";
                    uni.International_Defer_Admission ="";
                    uni.International_Transfer_Admission = "";
                    uni.International_Application_Deadline = "";
                    uni.International_Admission_Notes ="";
                    uni.International_Fall_Comments ="";
                }


                //Fall Early Admission
                DataTable dtEarly = DBWizard.FillDataTable(strConnString, "Sp_Select_TB_Fall_Early_Admission",
                     new object[] { na1[1] });

                if (dtEarly.Rows.Count > 0)
                {
                    uni.Early_count = 1;

                   for (int i = 0; i < dtEarly.Rows.Count; i++)
                    {
                        if (i == 0)
                        {
                            uni.Domestic_Early_Decision_Offered = dtEarly.Rows[i]["Early_Decision_Offered"].ToString();
                            uni.Domestic_Earlr_Notification = dtEarly.Rows[i]["Earlr_Notification"].ToString();
                            uni.Hidenn2 = dtEarly.Rows[i]["Earlr_Notification"].ToString();
                            uni.Domestic_Early_Decision_Deadline = dtEarly.Rows[i]["Early_Decision_Deadline"].ToString();
                            uni.Hidenn = dtEarly.Rows[i]["Early_Decision_Deadline"].ToString();
                            uni.Domestic_Early_Deposit_Deadline = dtEarly.Rows[i]["Early_Deposit_Deadline"].ToString();
                            uni.Hidenn4 = dtEarly.Rows[i]["Early_Deposit_Deadline"].ToString();

                            uni.Domestic_Early_Financial_Aid_Deadline = dtEarly.Rows[i]["Early_Financial_Aid_Deadline"].ToString();
                            uni.Domestic_Early_Action_offered = dtEarly.Rows[i]["Early_Action_offered"].ToString();
                            uni.Domestic_Early_Action_Deadline = dtEarly.Rows[i]["Early_Action_Deadline"].ToString();
                            uni.Domestic_Early_Action_Notification = dtEarly.Rows[i]["Early_Action_Notification"].ToString();
                            uni.Domestic_Early_Notes = dtEarly.Rows[i]["Early_Notes"].ToString();
                            uni.Domestic_Early_Data_URL = dtEarly.Rows[i]["Data_URL"].ToString();
                            uni.Domestic_Early_Comments = dtEarly.Rows[i]["Early_Comments"].ToString();
                        }
                        else
                        {
                            uni.International_Early_Decision_Offered = dtEarly.Rows[i]["Early_Decision_Offered"].ToString();
                            uni.International_Earlr_Notification = dtEarly.Rows[i]["Earlr_Notification"].ToString();
                            uni.Hidenn3 = dtEarly.Rows[i]["Earlr_Notification"].ToString();
                            uni.International_Early_Decision_Deadline = dtEarly.Rows[i]["Early_Decision_Deadline"].ToString();
                            uni.Hidenn2 = dtEarly.Rows[i]["Early_Decision_Deadline"].ToString();
                            uni.International_Early_Deposit_Deadline = dtEarly.Rows[i]["Early_Deposit_Deadline"].ToString();
                            uni.Hidenn5 = dtEarly.Rows[i]["Early_Decision_Deadline"].ToString();
                            uni.International_Early_Financial_Aid_Deadline = dtEarly.Rows[i]["Early_Financial_Aid_Deadline"].ToString();
                            uni.International_Early_Action_offered = dtEarly.Rows[i]["Early_Action_offered"].ToString();
                            uni.International_Early_Action_Deadline = dtEarly.Rows[i]["Early_Action_Deadline"].ToString();
                            uni.International_Early_Action_Notification = dtEarly.Rows[i]["Early_Action_Notification"].ToString();
                            uni.International_Early_Notes = dtEarly.Rows[i]["Early_Notes"].ToString();
                            uni.International_Early_Data_URL = dtEarly.Rows[i]["Data_URL"].ToString();
                            uni.International_Early_Comments = dtEarly.Rows[i]["Early_Comments"].ToString();
                        }

                        uni.Early_Status = dtEarly.Rows[i]["Early_Status"].ToString();
                    }
                }
                else
                {
                    uni.Early_count = 0;

                    uni.International_Early_Data_URL = "http://";
                    uni.Domestic_Early_Data_URL = "http://";

                    uni.International_Early_Decision_Offered = "";
                    uni.International_Earlr_Notification = "";
                    uni.International_Early_Decision_Deadline = "";
                    uni.International_Early_Deposit_Deadline = "";

                    uni.International_Earlr_Notification1 = "";
                    uni.International_Early_Decision_Deadline1 = "";
                    uni.International_Early_Deposit_Deadline1 = "";

                    uni.International_Early_Financial_Aid_Deadline = "";
                    uni.International_Early_Action_offered = "";
                    uni.International_Early_Action_Deadline = "";
                    uni.International_Early_Action_Notification = "";
                    uni.International_Early_Notes = "";
                    uni.International_Early_Comments = "";

                    uni.Domestic_Early_Decision_Offered = "";
                    uni.Domestic_Earlr_Notification = "";
                    uni.Domestic_Early_Decision_Deadline = "";
                    uni.Domestic_Early_Deposit_Deadline = "";

                    uni.Domestic_Earlr_Notification1 = "";
                    uni.Domestic_Early_Decision_Deadline1 = "";
                    uni.Domestic_Early_Deposit_Deadline1 = "";

                    uni.Domestic_Early_Financial_Aid_Deadline = "";
                    uni.Domestic_Early_Action_offered = "";
                    uni.Domestic_Early_Action_Deadline = "";
                    uni.Domestic_Early_Action_Notification = "";
                    uni.Domestic_Early_Notes = "";
                    uni.Domestic_Early_Data_URL = "";
                    uni.Domestic_Early_Comments = "";
                }

                //Spring Admission
                DataTable dtSpring = DBWizard.FillDataTable(strConnString, "Sp_Select_Tb_Spring_Application_Dates",
                        new object[] { na1[1] });

                if (dtSpring.Rows.Count > 0)
                {
                    uni.Spring_count = 1;

                    for (int i = 0; i < dtSpring.Rows.Count; i++)
                    {
                        if (i == 0)
                        {
                            uni.Domestic_Spring_Regular_Admission_Deadline = dtSpring.Rows[i]["Admission_Deadline"].ToString();
                            uni.Domestic_Spring_Admission_Notification = dtSpring.Rows[i]["Admission_Notification"].ToString();
                            uni.Domestic_Spring_Deposit_Deadline = dtSpring.Rows[i]["Deposit_Deadline"].ToString();
                            uni.Domestic_Spring_Accept_Offer = dtSpring.Rows[i]["Accept_Offer"].ToString();
                            uni.Domestic_Spring_Admission_WaitingListUsed = dtSpring.Rows[i]["Admission_WaitingListUsed"].ToString();
                            uni.Domestic_Spring_Defer_Admission = dtSpring.Rows[i]["Defer_Admission"].ToString();
                            uni.Domestic_Spring_Transfer_Admission = dtSpring.Rows[i]["Transfer_Admission"].ToString();
                            uni.Domestic_Spring_Financial_Aid_Deadline = dtSpring.Rows[i]["Financial_Aid_Deadline"].ToString();
                            uni.Domestic_Spring_Admission_Notes = dtSpring.Rows[i]["Notes"].ToString();
                            uni.Domestic_Spring_Data_URL = dtSpring.Rows[i]["Data_URL"].ToString();
                            uni.Domestic_Spring_Comments = dtSpring.Rows[i]["Spring_Comments"].ToString();
                        }
                        else
                        {
                            uni.International_Spring_Regular_Admission_Deadline = dtSpring.Rows[i]["Admission_Deadline"].ToString();
                            uni.International_Spring_Admission_Notification = dtSpring.Rows[i]["Admission_Notification"].ToString();
                            uni.International_Spring_Deposit_Deadline = dtSpring.Rows[i]["Deposit_Deadline"].ToString();
                            uni.International_Spring_Accept_Offer = dtSpring.Rows[i]["Accept_Offer"].ToString();
                            uni.International_Spring_Admission_WaitingListUsed = dtSpring.Rows[i]["Admission_WaitingListUsed"].ToString();
                            uni.International_Spring_Defer_Admission = dtSpring.Rows[i]["Defer_Admission"].ToString();
                            uni.International_Spring_Transfer_Admission = dtSpring.Rows[i]["Transfer_Admission"].ToString();
                            uni.International_Spring_Financial_Aid_Deadline = dtSpring.Rows[i]["Financial_Aid_Deadline"].ToString();
                            uni.International_Spring_Admission_Notes = dtSpring.Rows[i]["Notes"].ToString();
                            uni.International_Spring_Data_URL = dtSpring.Rows[i]["Data_URL"].ToString();
                            uni.International_Spring_Comments = dtSpring.Rows[i]["Spring_Comments"].ToString();
                        }

                        uni.Spring_Status = dtSpring.Rows[i]["Spring_Status"].ToString();
                    }
                }
                else
                {
                    uni.Spring_count = 0;

                    uni.Domestic_Spring_Regular_Admission_Deadline = "";
                    uni.Domestic_Spring_Admission_Notification = "";
                    uni.Domestic_Spring_Deposit_Deadline = "";
                    uni.Domestic_Spring_Accept_Offer = "";
                    uni.Domestic_Spring_Admission_WaitingListUsed = "";
                    uni.Domestic_Spring_Defer_Admission = "";
                    uni.Domestic_Spring_Transfer_Admission = "";
                    uni.Domestic_Spring_Financial_Aid_Deadline = "";
                    uni.Domestic_Spring_Admission_Notes = "";
                    uni.Domestic_Spring_Data_URL = "http://";
                    uni.Domestic_Spring_Comments = "";

                    uni.International_Spring_Regular_Admission_Deadline = "";
                    uni.International_Spring_Admission_Notification = "";
                    uni.International_Spring_Deposit_Deadline = "";
                    uni.International_Spring_Accept_Offer = "";
                    uni.International_Spring_Admission_WaitingListUsed = "";
                    uni.International_Spring_Defer_Admission = "";
                    uni.International_Spring_Transfer_Admission = "";
                    uni.International_Spring_Financial_Aid_Deadline = "";
                    uni.International_Spring_Admission_Notes = "";
                    uni.International_Spring_Data_URL = "http://";
                    uni.International_Spring_Comments = "";
                }

                //Summer Admission
                DataTable dtSummer = DBWizard.FillDataTable(strConnString, "Sp_Select_Tb_Summer_Application_Datess",
                        new object[] { na1[1] });

                if (dtSummer.Rows.Count > 0)
                {
                    uni.Summer_count = 1;

                    for (int i = 0; i < dtSummer.Rows.Count; i++)
                    {
                        if (i == 0)
                        {
                            uni.Domestic_Summer_Regular_Admission_Deadline = dtSummer.Rows[i]["Admission_Deadline"].ToString();
                            uni.Domestic_Summer_Admission_Notification = dtSummer.Rows[i]["Admission_Notification"].ToString();
                            uni.Domestic_Summer_Deposit_Deadline = dtSummer.Rows[i]["Deposit_Deadline"].ToString();
                            uni.Domestic_Summer_Accept_Offer = dtSummer.Rows[i]["Accept_Offer"].ToString();
                            uni.Domestic_Summer_Admission_WaitingListUsed = dtSummer.Rows[i]["Admission_WaitingListUsed"].ToString();
                            uni.Domestic_Summer_Defer_Admission = dtSummer.Rows[i]["Defer_Admission"].ToString();
                            uni.Domestic_Summer_Transfer_Admission = dtSummer.Rows[i]["Transfer_Admission"].ToString();
                            uni.Domestic_Summer_Financial_Aid_Deadline = dtSummer.Rows[i]["Financial_Aid_Deadline"].ToString();
                            uni.Domestic_Summer_Admission_Notes = dtSummer.Rows[i]["Notes"].ToString();
                            uni.Domestic_Summer_Data_URL = dtSummer.Rows[i]["Data_URL"].ToString();
                            uni.Domestic_Summer_Comments = dtSummer.Rows[i]["Spring_Comments"].ToString();
                        }
                        else
                        {
                            uni.International_Summer_Regular_Admission_Deadline = dtSummer.Rows[i]["Admission_Deadline"].ToString();
                            uni.International_Summer_Admission_Notification = dtSummer.Rows[i]["Admission_Notification"].ToString();
                            uni.International_Summer_Deposit_Deadline = dtSummer.Rows[i]["Deposit_Deadline"].ToString();
                            uni.International_Summer_Accept_Offer = dtSummer.Rows[i]["Accept_Offer"].ToString();
                            uni.International_Summer_Admission_WaitingListUsed = dtSummer.Rows[i]["Admission_WaitingListUsed"].ToString();
                            uni.International_Summer_Defer_Admission = dtSummer.Rows[i]["Defer_Admission"].ToString();
                            uni.International_Summer_Transfer_Admission = dtSummer.Rows[i]["Transfer_Admission"].ToString();
                            uni.International_Summer_Financial_Aid_Deadline = dtSummer.Rows[i]["Financial_Aid_Deadline"].ToString();
                            uni.International_Summer_Admission_Notes = dtSummer.Rows[i]["Notes"].ToString();
                            uni.International_Summer_Data_URL = dtSummer.Rows[i]["Data_URL"].ToString();
                            uni.International_Summer_Comments = dtSummer.Rows[i]["Spring_Comments"].ToString();
                        }

                        uni.Summer_Status = dtSummer.Rows[i]["Spring_Status"].ToString();
                    }
                }
                else
                {
                    uni.Summer_count = 0;

                    uni.Domestic_Summer_Regular_Admission_Deadline = "";
                    uni.Domestic_Summer_Admission_Notification = "";
                    uni.Domestic_Summer_Deposit_Deadline = "";
                    uni.Domestic_Summer_Accept_Offer = "";
                    uni.Domestic_Summer_Admission_WaitingListUsed = "";
                    uni.Domestic_Summer_Defer_Admission = "";
                    uni.Domestic_Summer_Transfer_Admission = "";
                    uni.Domestic_Summer_Financial_Aid_Deadline = "";
                    uni.Domestic_Summer_Admission_Notes = "";
                    uni.Domestic_Summer_Data_URL = "http://";
                    uni.Domestic_Summer_Comments = "";

                    uni.International_Summer_Regular_Admission_Deadline = "";
                    uni.International_Summer_Admission_Notification = "";
                    uni.International_Summer_Deposit_Deadline = "";
                    uni.International_Summer_Accept_Offer = "";
                    uni.International_Summer_Admission_WaitingListUsed = "";
                    uni.International_Summer_Defer_Admission = "";
                    uni.International_Summer_Transfer_Admission = "";
                    uni.International_Summer_Financial_Aid_Deadline = "";
                    uni.International_Summer_Admission_Notes = "";
                    uni.International_Summer_Data_URL = "http://";
                    uni.International_Summer_Comments = "";
                }


                //Spring Priority Admission
                DataTable dtSpring_Priority = DBWizard.FillDataTable(strConnString, "Sp_Select_Tb_Spring_Priority_Dates",
                       new object[] { na1[1] });


                if (dtSpring_Priority.Rows.Count > 0)
                {
                    uni.Spring_Priority_count = 1;

                    for (int i = 0; i < dtSpring_Priority.Rows.Count; i++)
                    {
                        if (i == 0)
                        {
                            uni.Domestic_Spring_Priority_Decision_Offered = dtSpring_Priority.Rows[i]["Decision_Offered"].ToString();

                            uni.Domestic_Spring_Priority_Decision_Deadline = dtSpring_Priority.Rows[i]["Decision_Deadline"].ToString();
                            uni.Hidenn6 = dtSpring_Priority.Rows[i]["Decision_Deadline"].ToString();
                            uni.Domestic_Spring_Priority_Decision_Notification = dtSpring_Priority.Rows[i]["Decision_Notification"].ToString();
                            uni.Hidenn8 = dtSpring_Priority.Rows[i]["Decision_Notification"].ToString();
                            uni.Domestic_Spring_Priority_Deposit_Deadline = dtSpring_Priority.Rows[i]["Deposit_Deadline"].ToString();
                            uni.Hidenn10 = dtSpring_Priority.Rows[i]["Deposit_Deadline"].ToString();


                            uni.Domestic_ESpring_Priority_Financial_Aid_Deadline = dtSpring_Priority.Rows[i]["Financial_Aid_Deadline"].ToString();
                            uni.Domestic_ESpring_Priority_Notes = dtSpring_Priority.Rows[i]["Notes"].ToString();
                            uni.Domestic_ESpring_Priority_Data_URL = dtSpring_Priority.Rows[i]["Data_URL"].ToString();
                            uni.Domestic_ESpring_Priority_Comments = dtSpring_Priority.Rows[i]["Spring_Comments"].ToString();
                        }
                        else
                        {
                            uni.International_Spring_Priority_Decision_Offered = dtSpring_Priority.Rows[i]["Decision_Offered"].ToString();

                            uni.International_Spring_Priority_Decision_Deadline = dtSpring_Priority.Rows[i]["Decision_Deadline"].ToString();
                            uni.Hidenn7 = dtSpring_Priority.Rows[i]["Decision_Deadline"].ToString();
                            uni.International_Spring_Priority_Decision_Notification = dtSpring_Priority.Rows[i]["Decision_Notification"].ToString();
                            uni.Hidenn9 = dtSpring_Priority.Rows[i]["Decision_Notification"].ToString();
                            uni.International_Spring_Priority_Deposit_Deadline = dtSpring_Priority.Rows[i]["Deposit_Deadline"].ToString();
                            uni.Hidenn11 = dtSpring_Priority.Rows[i]["Deposit_Deadline"].ToString();
                            uni.International_ESpring_Priority_Financial_Aid_Deadline = dtSpring_Priority.Rows[i]["Financial_Aid_Deadline"].ToString();
                            uni.International_ESpring_Priority_Notes = dtSpring_Priority.Rows[i]["Notes"].ToString();
                            uni.International_ESpring_Priority_Data_URL = dtSpring_Priority.Rows[i]["Data_URL"].ToString();
                            uni.International_ESpring_Priority_Comments = dtSpring_Priority.Rows[i]["Spring_Comments"].ToString();
                        }

                        uni.Spring_Priority_Status= dtSpring_Priority.Rows[i]["Spring_Status"].ToString();
                    }
                }
                else
                {
                    uni.Spring_Priority_count = 0;

                    uni.Domestic_Spring_Priority_Decision_Offered = "";
                    uni.Domestic_Spring_Priority_Decision_Deadline = "";
                    uni.Domestic_Spring_Priority_Decision_Notification = "";
                    uni.Domestic_Spring_Priority_Deposit_Deadline = "";

                    uni.Domestic_Spring_Priority_Decision_Deadline1 = "";
                    uni.Domestic_Spring_Priority_Decision_Notification1 = "";
                    uni.Domestic_Spring_Priority_Deposit_Deadline1 = "";

                    uni.Domestic_ESpring_Priority_Financial_Aid_Deadline = "";
                    uni.Domestic_ESpring_Priority_Notes = "";
                    uni.Domestic_ESpring_Priority_Data_URL = "http://";
                    uni.Domestic_ESpring_Priority_Comments = "";

                    uni.International_Spring_Priority_Decision_Offered = "";
                    uni.International_Spring_Priority_Decision_Deadline = "";
                    uni.International_Spring_Priority_Decision_Notification = "";
                    uni.International_Spring_Priority_Deposit_Deadline = "";

                    uni.International_Spring_Priority_Decision_Deadline1 = "";
                    uni.International_Spring_Priority_Decision_Notification1 = "";
                    uni.International_Spring_Priority_Deposit_Deadline1 = "";

                    uni.International_ESpring_Priority_Financial_Aid_Deadline = "";
                    uni.International_ESpring_Priority_Notes = "";
                    uni.International_ESpring_Priority_Data_URL = "http://";
                    uni.International_ESpring_Priority_Comments = "";
                }

                //Summer Priority Admission
                DataTable dtSummer_Priority = DBWizard.FillDataTable(strConnString, "Sp_Select_Tb_Summer_Priority_Dates",
                       new object[] { na1[1] });


                if (dtSummer_Priority.Rows.Count > 0)
                {
                    uni.Priority_count = 1;

                    for (int i = 0; i < dtSummer_Priority.Rows.Count; i++)
                    {
                        if (i == 0)
                        {
                            uni.Domestic_Summer_Priority_Decision_Offered = dtSummer_Priority.Rows[i]["Decision_Offered"].ToString();

                            uni.Domestic_Summer_Priority_Decision_Deadline = dtSummer_Priority.Rows[i]["Decision_Deadline"].ToString();
                            uni.Hidenn12 = dtSummer_Priority.Rows[i]["Decision_Deadline"].ToString();
                            uni.Domestic_Summer_Priority_Decision_Notification = dtSummer_Priority.Rows[i]["Decision_Notification"].ToString();
                            uni.Hidenn14 = dtSummer_Priority.Rows[i]["Decision_Notification"].ToString();
                            uni.Domestic_Summer_Priority_Deposit_Deadline = dtSummer_Priority.Rows[i]["Deposit_Deadline"].ToString();
                            uni.Hidenn16 = dtSummer_Priority.Rows[i]["Deposit_Deadline"].ToString();
                            uni.Domestic_ESummer_Priority_Financial_Aid_Deadline = dtSummer_Priority.Rows[i]["Financial_Aid_Deadline"].ToString();
                            uni.Domestic_ESummer_Priority_Notes = dtSummer_Priority.Rows[i]["Notes"].ToString();
                            uni.Domestic_ESummer_Priority_Data_URL = dtSummer_Priority.Rows[i]["Data_URL"].ToString();
                            uni.Domestic_ESummer_Priority_Comments = dtSummer_Priority.Rows[i]["Spring_Comments"].ToString();
                        }
                        else
                        {
                            uni.International_Summer_Priority_Decision_Offered = dtSummer_Priority.Rows[i]["Decision_Offered"].ToString();

                            uni.International_Summer_Priority_Decision_Deadline = dtSummer_Priority.Rows[i]["Decision_Deadline"].ToString();
                            uni.Hidenn13 = dtSummer_Priority.Rows[i]["Decision_Deadline"].ToString();
                            uni.International_Summer_Priority_Decision_Notification = dtSummer_Priority.Rows[i]["Decision_Notification"].ToString();
                            uni.Hidenn15 = dtSummer_Priority.Rows[i]["Decision_Notification"].ToString();
                            uni.International_Summer_Priority_Deposit_Deadline = dtSummer_Priority.Rows[i]["Deposit_Deadline"].ToString();
                            uni.Hidenn17 = dtSummer_Priority.Rows[i]["Deposit_Deadline"].ToString();
                            uni.International_ESummer_Priority_Financial_Aid_Deadline = dtSummer_Priority.Rows[i]["Financial_Aid_Deadline"].ToString();
                            uni.International_ESummer_Priority_Notes = dtSummer_Priority.Rows[i]["Notes"].ToString();
                            uni.International_ESummer_Priority_Data_URL = dtSummer_Priority.Rows[i]["Data_URL"].ToString();
                            uni.International_ESummer_Priority_Comments = dtSummer_Priority.Rows[i]["Spring_Comments"].ToString();
                        }

                        uni.Priority_Status = dtSummer_Priority.Rows[i]["Spring_Status"].ToString();
                    }
                }
                else
                {
                    uni.Priority_count = 0;


                    uni.Domestic_Summer_Priority_Decision_Offered = "";
                    uni.Domestic_Summer_Priority_Decision_Deadline = "";
                    uni.Domestic_Summer_Priority_Decision_Notification = "";
                    uni.Domestic_Summer_Priority_Deposit_Deadline = "";

                    uni.Domestic_Summer_Priority_Decision_Deadline1 = "";
                    uni.Domestic_Summer_Priority_Decision_Notification1 = "";
                    uni.Domestic_Summer_Priority_Deposit_Deadline1 = "";

                    uni.Domestic_ESummer_Priority_Financial_Aid_Deadline = "";
                    uni.Domestic_ESummer_Priority_Notes = "";
                    uni.Domestic_ESummer_Priority_Data_URL = "http://";
                    uni.Domestic_ESummer_Priority_Comments = "";

                    uni.International_Summer_Priority_Decision_Offered = "";
                    uni.International_Summer_Priority_Decision_Deadline = "";
                    uni.International_Summer_Priority_Decision_Notification = "";
                    uni.International_Summer_Priority_Deposit_Deadline = "";

                    uni.International_Summer_Priority_Decision_Deadline1 = "";
                    uni.International_Summer_Priority_Decision_Notification1 = "";
                    uni.International_Summer_Priority_Deposit_Deadline1 = "";

                    uni.International_ESummer_Priority_Financial_Aid_Deadline = "";
                    uni.International_ESummer_Priority_Notes = "";
                    uni.International_ESummer_Priority_Data_URL = "http://";
                    uni.International_ESummer_Priority_Comments = "";
                }

            }
            else
            {
                Response.Redirect("~/Login/Login");
            }

          

            return View(uni);
        }

        [ HttpPost]
        public ActionResult View(string Name,Univer uni1,string Save)
        {
            string na = Decode(Name);

            string[] na1 = na.Split('*');

            if (Save == "Save")
            {
                if (uni1.Domestic_Fee == null)
                {
                    uni1.Domestic_Fee = "0.00";
                }

                if (uni1.Domestic_Weaver == null)
                {
                    uni1.Domestic_Weaver = "";
                }

                if (uni1.Domestic_Notes == null)
                {
                    uni1.Domestic_Notes = "";
                }

                if (uni1.Domestic_URL == null)
                {
                    uni1.Domestic_URL = "";
                }

                int id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Insert_AdmissionFeeid",
                    new object[] { User_id, na1[1], 1, uni1.Domestic_Fee,uni1.Domestic_Weaver,uni1.Domestic_Notes,
                    uni1.Domestic_URL}));

                if (uni1.International_Fee == null)
                {
                    uni1.International_Fee = "0.00";
                }

                if (uni1.International_Weaver == null)
                {
                    uni1.International_Weaver = "";
                }

                if (uni1.International_Notes == null)
                {
                    uni1.International_Notes = "";
                }

                if (uni1.International_URL == null)
                {
                    uni1.International_URL = "";
                }

                id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Insert_AdmissionFeeid",
                    new object[] { User_id, na1[1], 2, uni1.International_Fee,uni1.International_Weaver,uni1.International_Notes,
                    uni1.International_URL}));

                if (id > 0)
                {
                     ViewBag.Message = "Admission Fee Saved Successfully";
                }
            }
            else if (Save == "Fall_Save")
            {
                if (uni1.Domestic_Admission_Deadline == null)
                {
                    uni1.Domestic_Admission_Deadline = "";
                }
                if (uni1.Domestic_Admission_Notification == null)
                {
                    uni1.Domestic_Admission_Notification = "";
                }
                if (uni1.Domestic_Admission_Deposit_Deadline == null)
                {
                    uni1.Domestic_Admission_Deposit_Deadline = "";
                }
                if (uni1.Domestic_Admission_Offer == null)
                {
                    uni1.Domestic_Admission_Offer = "";
                }
                if (uni1.Domestic_Admission_WaitingListUsed == null)
                {
                    uni1.Domestic_Admission_WaitingListUsed = "";
                }
                if (uni1.Domestic_Defer_Admission == null)
                {
                    uni1.Domestic_Defer_Admission = "";
                }
                if (uni1.Domestic_Transfer_Admission == null)
                {
                    uni1.Domestic_Transfer_Admission = "";
                }
                if (uni1.Domestic_Application_Deadline == null)
                {
                    uni1.Domestic_Application_Deadline = "";
                }
                if (uni1.Domestic_Admission_Notes == null)
                {
                    uni1.Domestic_Admission_Notes = "";
                }
                if (uni1.Domestic_Data_URL == null)
                {
                    uni1.Domestic_Data_URL = "";
                }

                int id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Insert_Fall_Application_Dates",
                    new object[] { User_id, na1[1], 1, uni1.Domestic_Admission_Deadline,uni1.Domestic_Admission_Notification,
                        uni1.Domestic_Admission_Deposit_Deadline,uni1.Domestic_Admission_Offer,
                        uni1.Domestic_Admission_WaitingListUsed,uni1.Domestic_Defer_Admission,uni1.Domestic_Transfer_Admission,
                       uni1.Domestic_Application_Deadline,uni1.Domestic_Admission_Notes,uni1.Domestic_Data_URL}));


                if (uni1.International_Admission_Deadline == null)
                {
                    uni1.International_Admission_Deadline = "";
                }
                if (uni1.International_Admission_Notification == null)
                {
                    uni1.International_Admission_Notification = "";
                }
                if (uni1.International_Admission_Deposit_Deadline == null)
                {
                    uni1.International_Admission_Deposit_Deadline = "";
                }
                if (uni1.International_Admission_Offer == null)
                {
                    uni1.International_Admission_Offer = "";
                }
                if (uni1.International_Admission_WaitingListUsed == null)
                {
                    uni1.International_Admission_WaitingListUsed = "";
                }
                if (uni1.International_Defer_Admission == null)
                {
                    uni1.International_Defer_Admission = "";
                }
                if (uni1.International_Transfer_Admission == null)
                {
                    uni1.International_Transfer_Admission = "";
                }
                if (uni1.International_Application_Deadline == null)
                {
                    uni1.International_Application_Deadline = "";
                }
                if (uni1.International_Admission_Notes == null)
                {
                    uni1.International_Admission_Notes = "";
                }
                if (uni1.International_Data_URL == null)
                {
                    uni1.International_Data_URL = "";
                }

                id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Insert_Fall_Application_Dates",
                    new object[] { User_id, na1[1], 1, uni1.International_Admission_Deadline,uni1.International_Admission_Notification,
                       uni1.International_Admission_Deposit_Deadline,uni1.International_Admission_Offer,
                       uni1.International_Admission_WaitingListUsed,uni1.International_Defer_Admission,uni1.International_Transfer_Admission,
                        uni1.International_Application_Deadline,uni1.International_Admission_Notes,uni1.International_Data_URL}));

                if (id > 0)
                {
                    ViewBag.Message = "Fall Admission Saved Successfully";
                }
            }
            else if (Save == "Early_Save")
            {
                if (uni1.Domestic_Early_Decision_Offered == null)
                {
                    uni1.Domestic_Early_Decision_Offered = "";
                }
                if (uni1.Domestic_Earlr_Notification == null)
                {
                    uni1.Domestic_Earlr_Notification = "";
                }
                if (uni1.Domestic_Early_Decision_Deadline == null)
                {
                    uni1.Domestic_Early_Decision_Deadline = "";
                }
                if (uni1.Domestic_Early_Deposit_Deadline == null)
                {
                    uni1.Domestic_Early_Deposit_Deadline = "";
                }
                if (uni1.Domestic_Early_Financial_Aid_Deadline == null)
                {
                    uni1.Domestic_Early_Financial_Aid_Deadline = "";
                }
                if (uni1.Domestic_Early_Action_offered == null)
                {
                    uni1.Domestic_Early_Action_offered = "";
                }
                if (uni1.Domestic_Early_Action_Deadline == null)
                {
                    uni1.Domestic_Early_Action_Deadline = "";
                }
                if (uni1.Domestic_Early_Action_Notification == null)
                {
                    uni1.Domestic_Early_Action_Notification = "";
                }
                if (uni1.Domestic_Early_Notes == null)
                {
                    uni1.Domestic_Early_Notes = "";
                }
                if (uni1.Domestic_Early_Data_URL == null)
                {
                    uni1.Domestic_Early_Data_URL = "";
                }

                int id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Insert_Early_Admission",
                  new object[] { User_id, na1[1], 1, uni1.Domestic_Early_Decision_Offered,uni1.Domestic_Earlr_Notification,
                        uni1.Domestic_Early_Decision_Deadline,uni1.Domestic_Early_Deposit_Deadline,
                        uni1.Domestic_Early_Financial_Aid_Deadline,uni1.Domestic_Early_Action_offered,
                        uni1.Domestic_Early_Action_Deadline,
                       uni1.Domestic_Early_Action_Notification,uni1.Domestic_Early_Notes,uni1.Domestic_Early_Data_URL}));

                if (uni1.International_Early_Decision_Offered == null)
                {
                    uni1.International_Early_Decision_Offered = "";
                }
                if (uni1.International_Earlr_Notification == null)
                {
                    uni1.International_Earlr_Notification = "";
                }
                if (uni1.International_Early_Decision_Deadline == null)
                {
                    uni1.International_Early_Decision_Deadline = "";
                }
                if (uni1.International_Early_Deposit_Deadline == null)
                {
                    uni1.International_Early_Deposit_Deadline = "";
                }
                if (uni1.International_Early_Financial_Aid_Deadline == null)
                {
                    uni1.International_Early_Financial_Aid_Deadline = "";
                }
                if (uni1.International_Early_Action_offered == null)
                {
                    uni1.International_Early_Action_offered = "";
                }
                if (uni1.International_Early_Action_Deadline == null)
                {
                    uni1.International_Early_Action_Deadline = "";
                }
                if (uni1.International_Early_Action_Notification == null)
                {
                    uni1.International_Early_Action_Notification = "";
                }
                if (uni1.International_Early_Notes == null)
                {
                    uni1.International_Early_Notes = "";
                }
                if (uni1.International_Early_Data_URL == null)
                {
                    uni1.International_Early_Data_URL = "";
                }

                 id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Insert_Early_Admission",
                  new object[] { User_id, na1[1], 2, uni1.International_Early_Decision_Offered,
                      uni1.International_Earlr_Notification,
                        uni1.International_Early_Decision_Deadline,uni1.International_Early_Deposit_Deadline,
                        uni1.International_Early_Financial_Aid_Deadline,uni1.International_Early_Action_offered,
                        uni1.International_Early_Action_Deadline,
                       uni1.International_Early_Action_Notification,uni1.International_Early_Notes,
                       uni1.International_Early_Data_URL}));

                 if (id > 0)
                 {
                     ViewBag.Message = "Early Admission Saved Successfully";
                 }



            }

            else if (Save == "Spring_Save")
            {
                if (uni1.Domestic_Spring_Regular_Admission_Deadline == null)
                {
                    uni1.Domestic_Spring_Regular_Admission_Deadline = "";
                }
                if (uni1.Domestic_Spring_Admission_Notification == null)
                {
                    uni1.Domestic_Spring_Admission_Notification = "";
                }
                if (uni1.Domestic_Spring_Deposit_Deadline == null)
                {
                    uni1.Domestic_Spring_Deposit_Deadline = "";
                }
                if (uni1.Domestic_Spring_Accept_Offer == null)
                {
                    uni1.Domestic_Spring_Accept_Offer = "";
                }
                if (uni1.Domestic_Spring_Admission_WaitingListUsed == null)
                {
                    uni1.Domestic_Spring_Admission_WaitingListUsed = "";
                }
                if (uni1.Domestic_Spring_Defer_Admission == null)
                {
                    uni1.Domestic_Spring_Defer_Admission = "";
                }
                if (uni1.Domestic_Spring_Transfer_Admission == null)
                {
                    uni1.Domestic_Spring_Transfer_Admission = "";
                }
                if (uni1.Domestic_Spring_Financial_Aid_Deadline == null)
                {
                    uni1.Domestic_Spring_Financial_Aid_Deadline = "";
                }
                if (uni1.Domestic_Spring_Admission_Notes == null)
                {
                    uni1.Domestic_Spring_Admission_Notes = "";
                }
                if (uni1.Domestic_Spring_Data_URL == null)
                {
                    uni1.Domestic_Spring_Data_URL = "";
                }

                int id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Insert_Spring_Admission",
                 new object[] { User_id, na1[1], 1, uni1.Domestic_Spring_Regular_Admission_Deadline,
                uni1.Domestic_Spring_Admission_Notification,uni1.Domestic_Spring_Deposit_Deadline,
                 uni1.Domestic_Spring_Accept_Offer,uni1.Domestic_Spring_Admission_WaitingListUsed,
                 uni1.Domestic_Spring_Defer_Admission,uni1.Domestic_Spring_Transfer_Admission,
                uni1.Domestic_Spring_Financial_Aid_Deadline,uni1.Domestic_Spring_Admission_Notes,
                uni1.Domestic_Spring_Data_URL }));


                if (uni1.International_Spring_Regular_Admission_Deadline == null)
                {
                    uni1.International_Spring_Regular_Admission_Deadline = "";
                }
                if (uni1.International_Spring_Admission_Notification == null)
                {
                    uni1.International_Spring_Admission_Notification = "";
                }
                if (uni1.International_Spring_Deposit_Deadline == null)
                {
                    uni1.International_Spring_Deposit_Deadline = "";
                }
                if (uni1.International_Spring_Accept_Offer == null)
                {
                    uni1.International_Spring_Accept_Offer = "";
                }
                if (uni1.International_Spring_Admission_WaitingListUsed == null)
                {
                    uni1.International_Spring_Admission_WaitingListUsed = "";
                }
                if (uni1.International_Spring_Defer_Admission == null)
                {
                    uni1.International_Spring_Defer_Admission = "";
                }
                if (uni1.International_Spring_Transfer_Admission == null)
                {
                    uni1.International_Spring_Transfer_Admission = "";
                }
                if (uni1.International_Spring_Financial_Aid_Deadline == null)
                {
                    uni1.International_Spring_Financial_Aid_Deadline = "";
                }
                if (uni1.International_Spring_Admission_Notes == null)
                {
                    uni1.International_Spring_Admission_Notes = "";
                }
                if (uni1.International_Spring_Data_URL == null)
                {
                    uni1.International_Spring_Data_URL = "";
                }

                 id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Insert_Spring_Admission",
                 new object[] { User_id, na1[1], 2, uni1.International_Spring_Regular_Admission_Deadline,
                uni1.International_Spring_Admission_Notification,uni1.International_Spring_Deposit_Deadline,
                 uni1.International_Spring_Accept_Offer,uni1.International_Spring_Admission_WaitingListUsed,
                 uni1.International_Spring_Defer_Admission,uni1.International_Spring_Transfer_Admission,
                uni1.International_Spring_Financial_Aid_Deadline,uni1.International_Spring_Admission_Notes,
                uni1.International_Spring_Data_URL }));

                 if (id > 0)
                 {
                     ViewBag.Message = "Spring Admission Saved Successfully";
                 }

            }
            else if (Save == "Summer_Save")
            {
                if (uni1.Domestic_Summer_Regular_Admission_Deadline == null)
                {
                    uni1.Domestic_Summer_Regular_Admission_Deadline = "";
                }
                if (uni1.Domestic_Summer_Admission_Notification == null)
                {
                    uni1.Domestic_Summer_Admission_Notification = "";
                }
                if (uni1.Domestic_Summer_Deposit_Deadline == null)
                {
                    uni1.Domestic_Summer_Deposit_Deadline = "";
                }
                if (uni1.Domestic_Summer_Accept_Offer == null)
                {
                    uni1.Domestic_Summer_Accept_Offer = "";
                }
                if (uni1.Domestic_Summer_Admission_WaitingListUsed == null)
                {
                    uni1.Domestic_Summer_Admission_WaitingListUsed = "";
                }
                if (uni1.Domestic_Summer_Defer_Admission == null)
                {
                    uni1.Domestic_Summer_Defer_Admission = "";
                }
                if (uni1.Domestic_Summer_Transfer_Admission == null)
                {
                    uni1.Domestic_Summer_Transfer_Admission = "";
                }
                if (uni1.Domestic_Summer_Financial_Aid_Deadline == null)
                {
                    uni1.Domestic_Summer_Financial_Aid_Deadline = "";
                }
                if (uni1.Domestic_Summer_Admission_Notes == null)
                {
                    uni1.Domestic_Summer_Admission_Notes = "";
                }
                if (uni1.Domestic_Summer_Data_URL == null)
                {
                    uni1.Domestic_Summer_Data_URL = "";
                }

                int id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Insert_Summer_Admission",
                 new object[] { User_id, na1[1], 1, uni1.Domestic_Summer_Regular_Admission_Deadline,
                uni1.Domestic_Summer_Admission_Notification,uni1.Domestic_Summer_Deposit_Deadline,
                 uni1.Domestic_Summer_Accept_Offer,uni1.Domestic_Summer_Admission_WaitingListUsed,
                 uni1.Domestic_Summer_Defer_Admission,uni1.Domestic_Summer_Transfer_Admission,
                uni1.Domestic_Summer_Financial_Aid_Deadline,uni1.Domestic_Summer_Admission_Notes,
                uni1.Domestic_Summer_Data_URL }));


                if (uni1.International_Summer_Regular_Admission_Deadline == null)
                {
                    uni1.International_Summer_Regular_Admission_Deadline = "";
                }
                if (uni1.International_Summer_Admission_Notification == null)
                {
                    uni1.International_Summer_Admission_Notification = "";
                }
                if (uni1.International_Summer_Deposit_Deadline == null)
                {
                    uni1.International_Summer_Deposit_Deadline = "";
                }
                if (uni1.International_Summer_Accept_Offer == null)
                {
                    uni1.International_Summer_Accept_Offer = "";
                }
                if (uni1.International_Summer_Admission_WaitingListUsed == null)
                {
                    uni1.International_Summer_Admission_WaitingListUsed = "";
                }
                if (uni1.International_Summer_Defer_Admission == null)
                {
                    uni1.International_Summer_Defer_Admission = "";
                }
                if (uni1.International_Summer_Transfer_Admission == null)
                {
                    uni1.International_Summer_Transfer_Admission = "";
                }
                if (uni1.International_Summer_Financial_Aid_Deadline == null)
                {
                    uni1.International_Summer_Financial_Aid_Deadline = "";
                }
                if (uni1.International_Summer_Admission_Notes == null)
                {
                    uni1.International_Summer_Admission_Notes = "";
                }
                if (uni1.International_Summer_Data_URL == null)
                {
                    uni1.International_Summer_Data_URL = "";
                }

                id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Insert_Summer_Admission",
                new object[] { User_id, na1[1], 2, uni1.International_Summer_Regular_Admission_Deadline,
                uni1.International_Summer_Admission_Notification,uni1.International_Summer_Deposit_Deadline,
                 uni1.International_Summer_Accept_Offer,uni1.International_Summer_Admission_WaitingListUsed,
                 uni1.International_Summer_Defer_Admission,uni1.International_Summer_Transfer_Admission,
                uni1.International_Summer_Financial_Aid_Deadline,uni1.International_Summer_Admission_Notes,
                uni1.International_Summer_Data_URL }));

                if (id > 0)
                {
                    ViewBag.Message = "Summer Admission Saved Successfully";
                }
               
            }
            else if (Save == "Spring_Priority_Save")
            {
                if (uni1.Domestic_Spring_Priority_Decision_Offered == null)
                {
                    uni1.Domestic_Spring_Priority_Decision_Offered = "";
                }
                if (uni1.Domestic_Spring_Priority_Decision_Deadline == null)
                {
                    uni1.Domestic_Spring_Priority_Decision_Deadline = "";
                }
                if (uni1.Domestic_Spring_Priority_Decision_Notification == null)
                {
                    uni1.Domestic_Spring_Priority_Decision_Notification = "";
                }
                if (uni1.Domestic_Spring_Priority_Deposit_Deadline == null)
                {
                    uni1.Domestic_Spring_Priority_Deposit_Deadline = "";
                }
                if (uni1.Domestic_ESpring_Priority_Financial_Aid_Deadline == null)
                {
                    uni1.Domestic_ESpring_Priority_Financial_Aid_Deadline = "";
                }
                if (uni1.Domestic_ESpring_Priority_Notes == null)
                {
                    uni1.Domestic_ESpring_Priority_Notes = "";
                }
                if (uni1.Domestic_ESpring_Priority_Data_URL == null)
                {
                    uni1.Domestic_ESpring_Priority_Data_URL = "";
                }

                int id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Insert_Spring_Priority_Admission",
            new object[] { User_id, na1[1], 1, uni1.Domestic_Spring_Priority_Decision_Offered,
                uni1.Domestic_Spring_Priority_Decision_Deadline,uni1.Domestic_Spring_Priority_Decision_Notification,
                 uni1.Domestic_Spring_Priority_Deposit_Deadline,uni1.Domestic_ESpring_Priority_Financial_Aid_Deadline,
                 uni1.Domestic_ESpring_Priority_Notes,uni1.Domestic_ESpring_Priority_Data_URL, }));

                if (uni1.International_Spring_Priority_Decision_Offered == null)
                {
                    uni1.International_Spring_Priority_Decision_Offered = "";
                }
                if (uni1.International_Spring_Priority_Decision_Deadline == null)
                {
                    uni1.International_Spring_Priority_Decision_Deadline = "";
                }
                if (uni1.International_Spring_Priority_Decision_Notification == null)
                {
                    uni1.International_Spring_Priority_Decision_Notification = "";
                }
                if (uni1.International_Spring_Priority_Deposit_Deadline == null)
                {
                    uni1.International_Spring_Priority_Deposit_Deadline = "";
                }
                if (uni1.International_ESpring_Priority_Financial_Aid_Deadline == null)
                {
                    uni1.International_ESpring_Priority_Financial_Aid_Deadline = "";
                }
                if (uni1.International_ESpring_Priority_Notes == null)
                {
                    uni1.International_ESpring_Priority_Notes = "";
                }
                if (uni1.International_ESpring_Priority_Data_URL == null)
                {
                    uni1.International_ESpring_Priority_Data_URL = "";
                }

                 id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Insert_Spring_Priority_Admission",
            new object[] { User_id, na1[1], 2, uni1.International_Spring_Priority_Decision_Offered,
                uni1.International_Spring_Priority_Decision_Deadline,uni1.International_Spring_Priority_Decision_Notification,
                 uni1.International_Spring_Priority_Deposit_Deadline,uni1.International_ESpring_Priority_Financial_Aid_Deadline,
                 uni1.International_ESpring_Priority_Notes,uni1.International_ESpring_Priority_Data_URL, }));

                 if (id > 0)
                 {
                     ViewBag.Message = "Spring Priority Admission Saved Successfully";
                 }
            }
            else if (Save == "Summer_Priority_Save")
            {
                if (uni1.Domestic_Summer_Priority_Decision_Offered == null)
                {
                    uni1.Domestic_Summer_Priority_Decision_Offered = "";
                }
                if (uni1.Domestic_Summer_Priority_Decision_Deadline == null)
                {
                    uni1.Domestic_Summer_Priority_Decision_Deadline = "";
                }
                if (uni1.Domestic_Summer_Priority_Decision_Notification == null)
                {
                    uni1.Domestic_Summer_Priority_Decision_Notification = "";
                }
                if (uni1.Domestic_Summer_Priority_Deposit_Deadline == null)
                {
                    uni1.Domestic_Summer_Priority_Deposit_Deadline = "";
                }
                if (uni1.Domestic_ESummer_Priority_Financial_Aid_Deadline == null)
                {
                    uni1.Domestic_ESummer_Priority_Financial_Aid_Deadline = "";
                }
                if (uni1.Domestic_ESummer_Priority_Notes == null)
                {
                    uni1.Domestic_ESummer_Priority_Notes = "";
                }
                if (uni1.Domestic_ESummer_Priority_Data_URL == null)
                {
                    uni1.Domestic_ESummer_Priority_Data_URL = "";
                }

                int id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Insert_Summer_Priority_Admission",
            new object[] { User_id, na1[1], 1, uni1.Domestic_Summer_Priority_Decision_Offered,
                uni1.Domestic_Summer_Priority_Decision_Deadline,uni1.Domestic_Summer_Priority_Decision_Notification,
                 uni1.Domestic_Summer_Priority_Deposit_Deadline,uni1.Domestic_ESummer_Priority_Financial_Aid_Deadline,
                 uni1.Domestic_ESummer_Priority_Notes,uni1.Domestic_ESummer_Priority_Data_URL, }));

                if (uni1.International_Summer_Priority_Decision_Offered == null)
                {
                    uni1.International_Summer_Priority_Decision_Offered = "";
                }
                if (uni1.International_Summer_Priority_Decision_Deadline == null)
                {
                    uni1.International_Summer_Priority_Decision_Deadline = "";
                }
                if (uni1.International_Summer_Priority_Decision_Notification == null)
                {
                    uni1.International_Summer_Priority_Decision_Notification = "";
                }
                if (uni1.International_Summer_Priority_Deposit_Deadline == null)
                {
                    uni1.International_Summer_Priority_Deposit_Deadline = "";
                }
                if (uni1.International_ESummer_Priority_Financial_Aid_Deadline == null)
                {
                    uni1.International_ESummer_Priority_Financial_Aid_Deadline = "";
                }
                if (uni1.International_ESummer_Priority_Notes == null)
                {
                    uni1.International_ESummer_Priority_Notes = "";
                }
                if (uni1.International_ESummer_Priority_Data_URL == null)
                {
                    uni1.International_ESummer_Priority_Data_URL = "";
                }

                id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Insert_Summer_Priority_Admission",
           new object[] { User_id, na1[1], 2, uni1.International_Summer_Priority_Decision_Offered,
                uni1.International_Summer_Priority_Decision_Deadline,uni1.International_Summer_Priority_Decision_Notification,
                 uni1.International_Summer_Priority_Deposit_Deadline,uni1.International_ESummer_Priority_Financial_Aid_Deadline,
                 uni1.International_ESummer_Priority_Notes,uni1.International_ESummer_Priority_Data_URL, }));

                if (id > 0)
                {
                    ViewBag.Message = "Summer Priority Admission Saved Successfully";
                }
            }
            List<Univer> list = new List<Univer>();

            Univer uni = new Univer();

            if (HttpContext.Session["User"] != null)
            {



                DataTable dtdetails = DBWizard.FillDataTable(strConnString, "Sp_Select_ivyt_Universities");

                for (int i = 0; i < dtdetails.Rows.Count; i++)
                {
                    list.Add(new Univer
                    {
                        Universities_Name = dtdetails.Rows[i]["Name"].ToString(),
                        En_Universities_Name = Encode(dtdetails.Rows[i]["Name"].ToString() + "*" + dtdetails.Rows[i]["UniversityID"].ToString())
                    });
                }



                if (Save == "Update")
                {
                    if (uni1.Domestic_Fee == null)
                    {
                        uni1.Domestic_Fee = "0.00";
                    }

                    if (uni1.Domestic_Weaver == null)
                    {
                        uni1.Domestic_Weaver = "";
                    }

                    if (uni1.Domestic_Notes == null)
                    {
                        uni1.Domestic_Notes = "";
                    }

                    if (uni1.Domestic_URL == null)
                    {
                        uni1.Domestic_URL = "";
                    }

                    int id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Update_AdmissionFeeid1",
                        new object[] { User_id, na1[1], 1, uni1.Domestic_Fee,uni1.Domestic_Weaver,uni1.Domestic_Notes,
                    uni1.Domestic_URL}));

                    if (uni1.International_Fee == null)
                    {
                        uni1.International_Fee = "0.00";
                    }

                    if (uni1.International_Weaver == null)
                    {
                        uni1.International_Weaver = "";
                    }

                    if (uni1.International_Notes == null)
                    {
                        uni1.International_Notes = "";
                    }

                    if (uni1.International_URL == null )
                    {
                        uni1.International_URL = "";
                    }

                    id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Update_AdmissionFeeid1",
                        new object[] { User_id, na1[1], 2, uni1.International_Fee,uni1.International_Weaver,uni1.International_Notes,
                    uni1.International_URL}));

                    if (id > 0)
                    {
                        ViewBag.Message = "Admission Fee Updated Successfully";
                    }
                }
                else if (Save == "Fall_Update")
                {
                    if (uni1.Domestic_Admission_Deadline == null)
                    {
                        uni1.Domestic_Admission_Deadline = "";
                    }
                    if (uni1.Domestic_Admission_Notification == null)
                    {
                        uni1.Domestic_Admission_Notification = "";
                    }
                    if (uni1.Domestic_Admission_Deposit_Deadline == null)
                    {
                        uni1.Domestic_Admission_Deposit_Deadline = "";
                    }
                    if (uni1.Domestic_Admission_Offer == null)
                    {
                        uni1.Domestic_Admission_Offer = "";
                    }
                    if (uni1.Domestic_Admission_WaitingListUsed == null)
                    {
                        uni1.Domestic_Admission_WaitingListUsed = "";
                    }
                    if (uni1.Domestic_Defer_Admission == null)
                    {
                        uni1.Domestic_Defer_Admission = "";
                    }
                    if (uni1.Domestic_Transfer_Admission == null)
                    {
                        uni1.Domestic_Transfer_Admission = "";
                    }
                    if (uni1.Domestic_Application_Deadline == null)
                    {
                        uni1.Domestic_Application_Deadline = "";
                    }
                    if (uni1.Domestic_Admission_Notes == null)
                    {
                        uni1.Domestic_Admission_Notes = "";
                    }
                    if (uni1.Domestic_Data_URL == null)
                    {
                        uni1.Domestic_Data_URL = "";
                    }

                    int id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Update_Fall_Application_Dates1",
                        new object[] { User_id, na1[1], 1, uni1.Domestic_Admission_Deadline,uni1.Domestic_Admission_Notification,
                        uni1.Domestic_Admission_Deposit_Deadline,uni1.Domestic_Admission_Offer,
                        uni1.Domestic_Admission_WaitingListUsed,uni1.Domestic_Defer_Admission,uni1.Domestic_Transfer_Admission,
                       uni1.Domestic_Application_Deadline,uni1.Domestic_Admission_Notes,uni1.Domestic_Data_URL}));


                    if (uni1.International_Admission_Deadline == null)
                    {
                        uni1.International_Admission_Deadline = "";
                    }
                    if (uni1.International_Admission_Notification == null)
                    {
                        uni1.International_Admission_Notification = "";
                    }
                    if (uni1.International_Admission_Deposit_Deadline == null)
                    {
                        uni1.International_Admission_Deposit_Deadline = "";
                    }
                    if (uni1.International_Admission_Offer == null)
                    {
                        uni1.International_Admission_Offer = "";
                    }
                    if (uni1.International_Admission_WaitingListUsed == null)
                    {
                        uni1.International_Admission_WaitingListUsed = "";
                    }
                    if (uni1.International_Defer_Admission == null)
                    {
                        uni1.International_Defer_Admission = "";
                    }
                    if (uni1.International_Transfer_Admission == null)
                    {
                        uni1.International_Transfer_Admission = "";
                    }
                    if (uni1.International_Application_Deadline == null)
                    {
                        uni1.International_Application_Deadline = "";
                    }
                    if (uni1.International_Admission_Notes == null)
                    {
                        uni1.International_Admission_Notes = "";
                    }
                    if (uni1.International_Data_URL == null)
                    {
                        uni1.International_Data_URL = "";
                    }

                    id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Update_Fall_Application_Dates1",
                        new object[] { User_id, na1[1], 1, uni1.International_Admission_Deadline,uni1.International_Admission_Notification,
                       uni1.International_Admission_Deposit_Deadline,uni1.International_Admission_Offer,
                       uni1.International_Admission_WaitingListUsed,uni1.International_Defer_Admission,uni1.International_Transfer_Admission,
                        uni1.International_Application_Deadline,uni1.International_Admission_Notes,uni1.International_Data_URL}));

                        ViewBag.Message = "Fall Admission Updated Successfully";
                       
                }
                else if (Save == "Early_Update")
                {
                    if (uni1.Domestic_Early_Decision_Offered == null)
                    {
                        uni1.Domestic_Early_Decision_Offered = "";
                    }
                    if (uni1.Domestic_Earlr_Notification == null)
                    {
                        uni1.Domestic_Earlr_Notification = "";
                    }
                    if (uni1.Domestic_Early_Decision_Deadline == null)
                    {
                        uni1.Domestic_Early_Decision_Deadline = "";
                    }
                    if (uni1.Domestic_Early_Deposit_Deadline == null)
                    {
                        uni1.Domestic_Early_Deposit_Deadline= "";
                    }
                    if (uni1.Domestic_Early_Financial_Aid_Deadline == null)
                    {
                        uni1.Domestic_Early_Financial_Aid_Deadline = "";
                    }
                    if (uni1.Domestic_Early_Action_offered == null)
                    {
                        uni1.Domestic_Early_Action_offered = "";
                    }
                    if (uni1.Domestic_Early_Action_Deadline == null)
                    {
                        uni1.Domestic_Early_Action_Deadline = "";
                    }
                    if (uni1.Domestic_Early_Action_Notification == null)
                    {
                        uni1.Domestic_Early_Action_Notification = "";
                    }
                    if (uni1.Domestic_Early_Notes == null)
                    {
                        uni1.Domestic_Early_Notes = "";
                    }
                    if (uni1.Domestic_Early_Data_URL == null)
                    {
                        uni1.Domestic_Early_Data_URL = "";
                    }

                    int id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Update_Early_Admission",
                      new object[] { User_id, na1[1], 1, uni1.Domestic_Early_Decision_Offered,uni1.Domestic_Earlr_Notification,
                        uni1.Domestic_Early_Decision_Deadline,uni1.Domestic_Early_Deposit_Deadline,
                        uni1.Domestic_Early_Financial_Aid_Deadline,uni1.Domestic_Early_Action_offered,
                        uni1.Domestic_Early_Action_Deadline,
                       uni1.Domestic_Early_Action_Notification,uni1.Domestic_Early_Notes,uni1.Domestic_Early_Data_URL}));

                    if (uni1.International_Early_Decision_Offered == null)
                    {
                        uni1.International_Early_Decision_Offered = "";
                    }
                    if (uni1.International_Earlr_Notification == null)
                    {
                        uni1.International_Earlr_Notification = "";
                    }
                    if (uni1.International_Early_Decision_Deadline == null)
                    {
                        uni1.International_Early_Decision_Deadline= "";
                    }
                    if (uni1.International_Early_Deposit_Deadline == null)
                    {
                        uni1.International_Early_Deposit_Deadline = "";
                    }
                    if (uni1.International_Early_Financial_Aid_Deadline == null)
                    {
                        uni1.International_Early_Financial_Aid_Deadline = "";
                    }
                    if (uni1.International_Early_Action_offered == null)
                    {
                        uni1.International_Early_Action_offered = "";
                    }
                    if (uni1.International_Early_Action_Deadline == null)
                    {
                        uni1.International_Early_Action_Deadline = "";
                    }
                    if (uni1.International_Early_Action_Notification == null)
                    {
                        uni1.International_Early_Action_Notification = "";
                    }
                    if (uni1.International_Early_Notes == null)
                    {
                        uni1.International_Early_Notes = "";
                    }
                    if (uni1.International_Early_Data_URL == null)
                    {
                        uni1.International_Early_Data_URL = "";
                    }

                    id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Update_Early_Admission",
                     new object[] { User_id, na1[1], 2, uni1.International_Early_Decision_Offered,
                      uni1.International_Earlr_Notification,
                        uni1.International_Early_Decision_Deadline,uni1.International_Early_Deposit_Deadline,
                        uni1.International_Early_Financial_Aid_Deadline,uni1.International_Early_Action_offered,
                        uni1.International_Early_Action_Deadline,
                       uni1.International_Early_Action_Notification,uni1.International_Early_Notes,
                       uni1.International_Early_Data_URL}));

                    if (id > 0)
                    {
                        ViewBag.Message = "Early Admission Updated Successfully";
                    }



                }

                else if (Save == "Spring_Update")
                {
                    if (uni1.Domestic_Spring_Regular_Admission_Deadline == null)
                    {
                        uni1.Domestic_Spring_Regular_Admission_Deadline = "";
                    }
                    if (uni1.Domestic_Spring_Admission_Notification == null)
                    {
                        uni1.Domestic_Spring_Admission_Notification = "";
                    }
                    if (uni1.Domestic_Spring_Deposit_Deadline == null)
                    {
                        uni1.Domestic_Spring_Deposit_Deadline = "";
                    }
                    if (uni1.Domestic_Spring_Accept_Offer == null)
                    {
                        uni1.Domestic_Spring_Accept_Offer = "";
                    }
                    if (uni1.Domestic_Spring_Admission_WaitingListUsed == null)
                    {
                        uni1.Domestic_Spring_Admission_WaitingListUsed = "";
                    }
                    if (uni1.Domestic_Spring_Defer_Admission == null)
                    {
                        uni1.Domestic_Spring_Defer_Admission = "";
                    }
                    if (uni1.Domestic_Spring_Transfer_Admission == null)
                    {
                        uni1.Domestic_Spring_Transfer_Admission = "";
                    }
                    if (uni1.Domestic_Spring_Financial_Aid_Deadline == null)
                    {
                        uni1.Domestic_Spring_Financial_Aid_Deadline = "";
                    }
                    if (uni1.Domestic_Spring_Admission_Notes == null)
                    {
                        uni1.Domestic_Spring_Admission_Notes = "";
                    }
                    if (uni1.Domestic_Spring_Data_URL == null)
                    {
                        uni1.Domestic_Spring_Data_URL = "";
                    }

                    int id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Update_Spring_Admission",
                     new object[] { User_id, na1[1], 1, uni1.Domestic_Spring_Regular_Admission_Deadline,
                uni1.Domestic_Spring_Admission_Notification,uni1.Domestic_Spring_Deposit_Deadline,
                 uni1.Domestic_Spring_Accept_Offer,uni1.Domestic_Spring_Admission_WaitingListUsed,
                 uni1.Domestic_Spring_Defer_Admission,uni1.Domestic_Spring_Transfer_Admission,
                uni1.Domestic_Spring_Financial_Aid_Deadline,uni1.Domestic_Spring_Admission_Notes,
                uni1.Domestic_Spring_Data_URL }));


                    if (uni1.International_Spring_Regular_Admission_Deadline == null)
                    {
                        uni1.International_Spring_Regular_Admission_Deadline = "";
                    }
                    if (uni1.International_Spring_Admission_Notification == null)
                    {
                        uni1.International_Spring_Admission_Notification = "";
                    }
                    if (uni1.International_Spring_Deposit_Deadline == null)
                    {
                        uni1.International_Spring_Deposit_Deadline = "";
                    }
                    if (uni1.International_Spring_Accept_Offer == null)
                    {
                        uni1.International_Spring_Accept_Offer = "";
                    }
                    if (uni1.International_Spring_Admission_WaitingListUsed == null)
                    {
                        uni1.International_Spring_Admission_WaitingListUsed = "";
                    }
                    if (uni1.International_Spring_Defer_Admission == null)
                    {
                        uni1.International_Spring_Defer_Admission = "";
                    }
                    if (uni1.International_Spring_Transfer_Admission == null)
                    {
                        uni1.International_Spring_Transfer_Admission = "";
                    }
                    if (uni1.International_Spring_Financial_Aid_Deadline == null)
                    {
                        uni1.International_Spring_Financial_Aid_Deadline = "";
                    }
                    if (uni1.International_Spring_Admission_Notes == null)
                    {
                        uni1.International_Spring_Admission_Notes = "";
                    }
                    if (uni1.International_Spring_Data_URL == null)
                    {
                        uni1.International_Spring_Data_URL = "";
                    }

                    id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Update_Spring_Admission",
                    new object[] { User_id, na1[1], 2, uni1.International_Spring_Regular_Admission_Deadline,
                uni1.International_Spring_Admission_Notification,uni1.International_Spring_Deposit_Deadline,
                 uni1.International_Spring_Accept_Offer,uni1.International_Spring_Admission_WaitingListUsed,
                 uni1.International_Spring_Defer_Admission,uni1.International_Spring_Transfer_Admission,
                uni1.International_Spring_Financial_Aid_Deadline,uni1.International_Spring_Admission_Notes,
                uni1.International_Spring_Data_URL }));

                        ViewBag.Message = "Spring Admission Updated Successfully";
                    

                }
                else if (Save == "Spring_Priority_Update")
                {
                    if (uni1.Domestic_Spring_Priority_Decision_Offered == null)
                    {
                        uni1.Domestic_Spring_Priority_Decision_Offered = "";
                    }
                    if (uni1.Domestic_Spring_Priority_Decision_Deadline == null)
                    {
                        uni1.Domestic_Spring_Priority_Decision_Deadline = "";
                    }
                    if (uni1.Domestic_Spring_Priority_Decision_Notification == null)
                    {
                        uni1.Domestic_Spring_Priority_Decision_Notification = "";
                    }
                    if (uni1.Domestic_Spring_Priority_Deposit_Deadline == null)
                    {
                        uni1.Domestic_Spring_Priority_Deposit_Deadline = "";
                    }
                    if (uni1.Domestic_ESpring_Priority_Financial_Aid_Deadline == null)
                    {
                        uni1.Domestic_ESpring_Priority_Financial_Aid_Deadline = "";
                    }
                    if (uni1.Domestic_ESpring_Priority_Notes == null)
                    {
                        uni1.Domestic_ESpring_Priority_Notes = "";
                    }
                    if (uni1.Domestic_ESpring_Priority_Data_URL == null)
                    {
                        uni1.Domestic_ESpring_Priority_Data_URL = "";
                    }

                    int id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Update_Spring_Priority_Admission",
                new object[] { User_id, na1[1], 1, uni1.Domestic_Spring_Priority_Decision_Offered,
                uni1.Domestic_Spring_Priority_Decision_Deadline,uni1.Domestic_Spring_Priority_Decision_Notification,
                 uni1.Domestic_Spring_Priority_Deposit_Deadline,uni1.Domestic_ESpring_Priority_Financial_Aid_Deadline,
                 uni1.Domestic_ESpring_Priority_Notes,uni1.Domestic_ESpring_Priority_Data_URL, }));

                    if (uni1.International_Spring_Priority_Decision_Offered == null)
                    {
                        uni1.International_Spring_Priority_Decision_Offered = "";
                    }
                    if (uni1.International_Spring_Priority_Decision_Deadline == null)
                    {
                        uni1.International_Spring_Priority_Decision_Deadline = "";
                    }
                    if (uni1.International_Spring_Priority_Decision_Notification == null)
                    {
                        uni1.International_Spring_Priority_Decision_Notification = "";
                    }
                    if (uni1.International_Spring_Priority_Deposit_Deadline == null)
                    {
                        uni1.International_Spring_Priority_Deposit_Deadline = "";
                    }
                    if (uni1.International_ESpring_Priority_Financial_Aid_Deadline == null)
                    {
                        uni1.International_ESpring_Priority_Financial_Aid_Deadline = "";
                    }
                    if (uni1.International_ESpring_Priority_Notes == null)
                    {
                        uni1.International_ESpring_Priority_Notes = "";
                    }
                    if (uni1.International_ESpring_Priority_Data_URL == null)
                    {
                        uni1.International_ESpring_Priority_Data_URL = "";
                    }

                    id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Update_Spring_Priority_Admission",
               new object[] { User_id, na1[1], 2, uni1.International_Spring_Priority_Decision_Offered,
                uni1.International_Spring_Priority_Decision_Deadline,uni1.International_Spring_Priority_Decision_Notification,
                 uni1.International_Spring_Priority_Deposit_Deadline,uni1.International_ESpring_Priority_Financial_Aid_Deadline,
                 uni1.International_ESpring_Priority_Notes,uni1.International_ESpring_Priority_Data_URL }));

                        ViewBag.Message = "Spring Priority Admission Updated Successfully";
               
                }
                else if (Save == "Summer_Update")
                {
                    if (uni1.Domestic_Summer_Regular_Admission_Deadline == null)
                    {
                        uni1.Domestic_Summer_Regular_Admission_Deadline = "";
                    }
                    if (uni1.Domestic_Summer_Admission_Notification == null)
                    {
                        uni1.Domestic_Summer_Admission_Notification = "";
                    }
                    if (uni1.Domestic_Summer_Deposit_Deadline == null)
                    {
                        uni1.Domestic_Summer_Deposit_Deadline = "";
                    }
                    if (uni1.Domestic_Summer_Accept_Offer == null)
                    {
                        uni1.Domestic_Summer_Accept_Offer = "";
                    }
                    if (uni1.Domestic_Summer_Admission_WaitingListUsed == null)
                    {
                        uni1.Domestic_Summer_Admission_WaitingListUsed = "";
                    }
                    if (uni1.Domestic_Summer_Defer_Admission == null)
                    {
                        uni1.Domestic_Summer_Defer_Admission = "";
                    }
                    if (uni1.Domestic_Summer_Transfer_Admission == null)
                    {
                        uni1.Domestic_Summer_Transfer_Admission = "";
                    }
                    if (uni1.Domestic_Summer_Financial_Aid_Deadline == null)
                    {
                        uni1.Domestic_Summer_Financial_Aid_Deadline = "";
                    }
                    if (uni1.Domestic_Summer_Admission_Notes == null)
                    {
                        uni1.Domestic_Summer_Admission_Notes = "";
                    }
                    if (uni1.Domestic_Summer_Data_URL == null)
                    {
                        uni1.Domestic_Summer_Data_URL = "";
                    }

                    int id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Update_Tb_Summer_Application_Dates",
                     new object[] { User_id, na1[1], 1, uni1.Domestic_Summer_Regular_Admission_Deadline,
                uni1.Domestic_Summer_Admission_Notification,uni1.Domestic_Summer_Deposit_Deadline,
                 uni1.Domestic_Summer_Accept_Offer,uni1.Domestic_Summer_Admission_WaitingListUsed,
                 uni1.Domestic_Summer_Defer_Admission,uni1.Domestic_Summer_Transfer_Admission,
                uni1.Domestic_Summer_Financial_Aid_Deadline,uni1.Domestic_Summer_Admission_Notes,
                uni1.Domestic_Summer_Data_URL }));


                    if (uni1.International_Summer_Regular_Admission_Deadline == null)
                    {
                        uni1.International_Summer_Regular_Admission_Deadline = "";
                    }
                    if (uni1.International_Summer_Admission_Notification == null)
                    {
                        uni1.International_Summer_Admission_Notification = "";
                    }
                    if (uni1.International_Summer_Deposit_Deadline == null)
                    {
                        uni1.International_Summer_Deposit_Deadline = "";
                    }
                    if (uni1.International_Summer_Accept_Offer == null)
                    {
                        uni1.International_Summer_Accept_Offer = "";
                    }
                    if (uni1.International_Summer_Admission_WaitingListUsed == null)
                    {
                        uni1.International_Summer_Admission_WaitingListUsed = "";
                    }
                    if (uni1.International_Summer_Defer_Admission == null)
                    {
                        uni1.International_Summer_Defer_Admission = "";
                    }
                    if (uni1.International_Summer_Transfer_Admission == null)
                    {
                        uni1.International_Summer_Transfer_Admission = "";
                    }
                    if (uni1.International_Summer_Financial_Aid_Deadline == null)
                    {
                        uni1.International_Summer_Financial_Aid_Deadline = "";
                    }
                    if (uni1.International_Summer_Admission_Notes == null)
                    {
                        uni1.International_Summer_Admission_Notes = "";
                    }
                    if (uni1.International_Summer_Data_URL == null)
                    {
                        uni1.International_Summer_Data_URL = "";
                    }

                    id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Update_Tb_Summer_Application_Dates",
                    new object[] { User_id, na1[1], 2, uni1.International_Summer_Regular_Admission_Deadline,
                uni1.International_Summer_Admission_Notification,uni1.International_Summer_Deposit_Deadline,
                 uni1.International_Summer_Accept_Offer,uni1.International_Summer_Admission_WaitingListUsed,
                 uni1.International_Summer_Defer_Admission,uni1.International_Summer_Transfer_Admission,
                uni1.International_Summer_Financial_Aid_Deadline,uni1.International_Summer_Admission_Notes,
                uni1.International_Summer_Data_URL }));

                        ViewBag.Message = "Summer Admission Updated Successfully";
                   

                }
                else if (Save == "Summer_Priority_Update")
            {
                if (uni1.Domestic_Summer_Priority_Decision_Offered == null)
                {
                    uni1.Domestic_Summer_Priority_Decision_Offered = "";
                }
                if (uni1.Domestic_Summer_Priority_Decision_Deadline == null)
                {
                    uni1.Domestic_Summer_Priority_Decision_Deadline = "";
                }
                if (uni1.Domestic_Summer_Priority_Decision_Notification == null)
                {
                    uni1.Domestic_Summer_Priority_Decision_Notification = "";
                }
                if (uni1.Domestic_Summer_Priority_Deposit_Deadline == null)
                {
                    uni1.Domestic_Summer_Priority_Deposit_Deadline = "";
                }
                if (uni1.Domestic_ESummer_Priority_Financial_Aid_Deadline == null)
                {
                    uni1.Domestic_ESummer_Priority_Financial_Aid_Deadline = "";
                }
                if (uni1.Domestic_ESummer_Priority_Notes == null)
                {
                    uni1.Domestic_ESummer_Priority_Notes = "";
                }
                if (uni1.Domestic_ESummer_Priority_Data_URL == null)
                {
                    uni1.Domestic_ESummer_Priority_Data_URL = "";
                }

                int id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Update_Tb_Summer_Priority_Dates",
            new object[] { User_id, na1[1], 1, uni1.Domestic_Summer_Priority_Decision_Offered,
                uni1.Domestic_Summer_Priority_Decision_Deadline,uni1.Domestic_Summer_Priority_Decision_Notification,
                 uni1.Domestic_Summer_Priority_Deposit_Deadline,uni1.Domestic_ESummer_Priority_Financial_Aid_Deadline,
                 uni1.Domestic_ESummer_Priority_Notes,uni1.Domestic_ESummer_Priority_Data_URL }));

                if (uni1.International_Summer_Priority_Decision_Offered == null)
                {
                    uni1.International_Summer_Priority_Decision_Offered = "";
                }
                if (uni1.International_Summer_Priority_Decision_Deadline == null)
                {
                    uni1.International_Summer_Priority_Decision_Deadline = "";
                }
                if (uni1.International_Summer_Priority_Decision_Notification == null)
                {
                    uni1.International_Summer_Priority_Decision_Notification = "";
                }
                if (uni1.International_Summer_Priority_Deposit_Deadline == null)
                {
                    uni1.International_Summer_Priority_Deposit_Deadline = "";
                }
                if (uni1.International_ESummer_Priority_Financial_Aid_Deadline == null)
                {
                    uni1.International_ESummer_Priority_Financial_Aid_Deadline = "";
                }
                if (uni1.International_ESummer_Priority_Notes == null)
                {
                    uni1.International_ESummer_Priority_Notes = "";
                }
                if (uni1.International_ESummer_Priority_Data_URL == null)
                {
                    uni1.International_ESummer_Priority_Data_URL = "";
                }

                id = Convert.ToInt32(DBWizard.ExecuteScalar(strConnString, "Sp_Update_Tb_Summer_Priority_Dates",
           new object[] { User_id, na1[1], 2, uni1.International_Summer_Priority_Decision_Offered,
                uni1.International_Summer_Priority_Decision_Deadline,uni1.International_Summer_Priority_Decision_Notification,
                 uni1.International_Summer_Priority_Deposit_Deadline,uni1.International_ESummer_Priority_Financial_Aid_Deadline,
                 uni1.International_ESummer_Priority_Notes,uni1.International_ESummer_Priority_Data_URL, }));


                    ViewBag.Message = "Summer Priority Admission Updated Successfully";
            }
                if (Save == "Delete")
                {

                    DBWizard.ExecuteNonQuery(strConnString, "Sp_Delete_AdmissionFeeid1",
                        new object[] { na1[1] });

                    ViewBag.Message = "Admission Fee Deleted Successfully";
                    uni = new Univer();
                    ModelState.Clear();
                }
                if (Save == "FallDelete")
                {

                    DBWizard.ExecuteNonQuery(strConnString, "Sp_delete_Fall_Application_Dates1",
                        new object[] { na1[1] });

                    ViewBag.Message = "Fall Admission Deleted Successfully";
                    uni = new Univer();
                    ModelState.Clear();
                }
                if (Save == "EarlyDelete")
                {

                    DBWizard.ExecuteNonQuery(strConnString, "Sp_delete_Early_Admission",
                        new object[] { na1[1] });

                    ViewBag.Message = "Early Admission Deleted Successfully";
                    uni = new Univer();
                    ModelState.Clear();
                }
                if (Save == "SpringDelete")
                {

                    DBWizard.ExecuteNonQuery(strConnString, "Sp_delete_Spring_Admission",
                        new object[] { na1[1] });

                    ViewBag.Message = "Spring Admission Deleted Successfully";
                    uni = new Univer();
                    ModelState.Clear();
                }
                if (Save == "PriDelete")
                {

                    DBWizard.ExecuteNonQuery(strConnString, "Sp_Delete_Spring_Priority_Admission",
                        new object[] { na1[1] });

                    ViewBag.Message = "Spring Priority Admission Deleted Successfully";
                    uni = new Univer();
                    ModelState.Clear();
                }

                if (Save == "SummerDelete")
                {

                    DBWizard.ExecuteNonQuery(strConnString, "Sp_Delete_Tb_Summer_Application_Dates",
                        new object[] { na1[1] });

                    ViewBag.Message = "Summer Admission Deleted Successfully";
                    uni = new Univer();
                    ModelState.Clear();
                }
                if (Save == "SummerpriDelete")
                {

                    DBWizard.ExecuteNonQuery(strConnString, "Sp_Delete_Tb_Summer_Priority_Dates",
                        new object[] { na1[1] });

                    ViewBag.Message = "Summer Priority Admission Deleted Successfully";
                    uni = new Univer();
                    ModelState.Clear();
                }



                uni.uni = list;


                uni.Name = na1[0];


                //Application Fee
                DataTable dtAdmission = DBWizard.FillDataTable(strConnString, "Sp_Select_ivyt_AdmissionFees",
                       new object[] { na1[1] });


                if (dtAdmission.Rows.Count > 0)
                {
                    if (Save == "Update" || Save == "Save")
                    {
                        uni.count = 2;
                    }
                    else
                    {
                        uni.count = 1;
                    }
                    for (int i = 0; i < dtAdmission.Rows.Count; i++)
                    {
                        if (i == 0)
                        {
                            
                                uni.Domestic_Fee = dtAdmission.Rows[i]["ApplicationFee"].ToString();
                                uni.Domestic_Notes = dtAdmission.Rows[i]["FeeWaiverNotes"].ToString();
                               uni.Domestic_Weaver = dtAdmission.Rows[i]["ApplicationFeeWaiver"].ToString();
                                uni.Domestic_URL = dtAdmission.Rows[i]["FeeDataURL"].ToString();
                                uni.Domestic_Comments = dtAdmission.Rows[i]["AdmissionFees_Comments"].ToString();
                         
                        }
                        else
                        {

                            uni.International_Fee = dtAdmission.Rows[i]["ApplicationFee"].ToString();
                                uni.International_Notes  = dtAdmission.Rows[i]["FeeWaiverNotes"].ToString();
                               uni. International_Weaver  = dtAdmission.Rows[i]["ApplicationFeeWaiver"].ToString();
                                uni.International_URL  = dtAdmission.Rows[i]["FeeDataURL"].ToString();
                                uni.International_Comments = dtAdmission.Rows[i]["AdmissionFees_Comments"].ToString();
                        }

                        uni.Status = dtAdmission.Rows[i]["AdmissionFees_Status"].ToString();
                        
                        
                    }
                }
                else
                {
                    uni.count = 0;
                    uni.count1 = 3;

                    uni.Domestic_URL = "http://";
                    uni.International_URL = "http://";

                    uni.International_Fee = "";
                    uni.International_Notes = "";
                    uni.International_Weaver = "";
                    uni.International_Comments = "";

                    uni.Domestic_Fee = "";
                    uni.Domestic_Notes = "";
                    uni.Domestic_Weaver = "";
                    uni.Domestic_Comments = "";
                }

                //Fall Application Admission

                DataTable dtFall = DBWizard.FillDataTable(strConnString, "Sp_Select_TB_Fall_Application_Dates",
                      new object[] { na1[1] });


                if (dtFall.Rows.Count > 0)
                {
                    if (Save == "Fall_Update" || Save == "Fall_Save")
                    {
                        uni.Fall_count = 2;
                        uni.count1 = 0;
                    }
                    else
                    {
                        uni.Fall_count = 1;
                    }

                    for (int i = 0; i < dtFall.Rows.Count; i++)
                    {
                        if (i == 0)
                        {
                            uni.Domestic_Admission_Deadline = dtFall.Rows[i]["Admission_Deadline"].ToString();
                            uni.Domestic_Admission_Notification = dtFall.Rows[i]["Admission_Notification"].ToString();
                            uni.Domestic_Admission_Deposit_Deadline = dtFall.Rows[i]["Admission_Deposit_Deadline"].ToString();
                            uni.Domestic_Admission_Offer = dtFall.Rows[i]["Admission_Offer"].ToString();
                            uni.Domestic_Admission_WaitingListUsed = dtFall.Rows[i]["Admission_WaitingListUsed"].ToString();
                            uni.Domestic_Defer_Admission = dtFall.Rows[i]["Defer_Admission"].ToString();
                            uni.Domestic_Transfer_Admission = dtFall.Rows[i]["Transfer_Admission"].ToString();
                            uni.Domestic_Application_Deadline = dtFall.Rows[i]["Application_Deadline"].ToString();
                            uni.Domestic_Admission_Notes = dtFall.Rows[i]["Admission_Notes"].ToString();
                            uni.Domestic_Data_URL = dtFall.Rows[i]["Data_URL"].ToString();
                            uni.Domestic_Fall_Comments = dtFall.Rows[i]["Fall_Comments"].ToString();
                        }
                        else
                        {
                            uni.International_Admission_Deadline = dtFall.Rows[i]["Admission_Deadline"].ToString();
                            uni.International_Admission_Notification = dtFall.Rows[i]["Admission_Notification"].ToString();
                            uni.International_Admission_Deposit_Deadline = dtFall.Rows[i]["Admission_Deposit_Deadline"].ToString();
                            uni.International_Admission_Offer = dtFall.Rows[i]["Admission_Offer"].ToString();
                            uni.International_Admission_WaitingListUsed = dtFall.Rows[i]["Admission_WaitingListUsed"].ToString();
                            uni.International_Defer_Admission = dtFall.Rows[i]["Defer_Admission"].ToString();
                            uni.International_Transfer_Admission = dtFall.Rows[i]["Transfer_Admission"].ToString();
                            uni.International_Application_Deadline = dtFall.Rows[i]["Application_Deadline"].ToString();
                            uni.International_Admission_Notes = dtFall.Rows[i]["Admission_Notes"].ToString();
                            uni.International_Data_URL = dtFall.Rows[i]["Data_URL"].ToString();
                            uni.International_Fall_Comments = dtFall.Rows[i]["Fall_Comments"].ToString();
                        }

                        uni.Fall_Status = dtFall.Rows[i]["Fall_Status"].ToString();
                    }
                }
                else
                {
                    uni.Fall_count = 0;
                    uni.Domestic_Data_URL = "http://";
                    uni.International_Data_URL = "http://";
                    uni.Domestic_Admission_Deadline = "";
                    uni.Domestic_Admission_Notification = "";
                    uni.Domestic_Admission_Deposit_Deadline ="";
                    uni.Domestic_Admission_Offer = "";
                    uni.Domestic_Admission_WaitingListUsed = "";
                    uni.Domestic_Defer_Admission = "";
                    uni.Domestic_Transfer_Admission = "";
                    uni.Domestic_Application_Deadline = "";
                    uni.Domestic_Admission_Notes = "";
                    uni.Domestic_Fall_Comments ="";
                    uni.International_Admission_Deadline = "";
                    uni.International_Admission_Notification = "";
                    uni.International_Admission_Deposit_Deadline = "";
                    uni.International_Admission_Offer = "";
                    uni.International_Admission_WaitingListUsed = "";
                    uni.International_Defer_Admission ="";
                    uni.International_Transfer_Admission = "";
                    uni.International_Application_Deadline = "";
                    uni.International_Admission_Notes ="";
                    uni.International_Fall_Comments ="";
                }

                 //Fall Early Admission
                DataTable dtEarly = DBWizard.FillDataTable(strConnString, "Sp_Select_TB_Fall_Early_Admission",
                     new object[] { na1[1] });

                if (dtEarly.Rows.Count > 0)
                {
                    if (Save == "Early_Update" || Save == "Early_Save")
                    {
                        uni.Early_count = 2;
                        uni.count1 = 0;
                        uni.count = 0;
                    }
                    else
                    {
                        uni.Early_count = 1;
                    }

                    for (int i = 0; i < dtEarly.Rows.Count; i++)
                    {
                        if (i == 0)
                        {
                            uni.Domestic_Early_Decision_Offered = dtEarly.Rows[i]["Early_Decision_Offered"].ToString();
                            uni.Domestic_Earlr_Notification = dtEarly.Rows[i]["Earlr_Notification"].ToString();
                            uni.Hidenn2 = dtEarly.Rows[i]["Earlr_Notification"].ToString();
                            uni.Domestic_Early_Decision_Deadline = dtEarly.Rows[i]["Early_Decision_Deadline"].ToString();
                            uni.Hidenn = dtEarly.Rows[i]["Early_Decision_Deadline"].ToString();
                            uni.Domestic_Early_Deposit_Deadline = dtEarly.Rows[i]["Early_Deposit_Deadline"].ToString();
                            uni.Hidenn4 = dtEarly.Rows[i]["Early_Deposit_Deadline"].ToString();

                            uni.Domestic_Early_Financial_Aid_Deadline = dtEarly.Rows[i]["Early_Financial_Aid_Deadline"].ToString();
                            uni.Domestic_Early_Action_offered = dtEarly.Rows[i]["Early_Action_offered"].ToString();
                            uni.Domestic_Early_Action_Deadline = dtEarly.Rows[i]["Early_Action_Deadline"].ToString();
                            uni.Domestic_Early_Action_Notification = dtEarly.Rows[i]["Early_Action_Notification"].ToString();
                            uni.Domestic_Early_Notes = dtEarly.Rows[i]["Early_Notes"].ToString();
                            uni.Domestic_Early_Data_URL = dtEarly.Rows[i]["Data_URL"].ToString();
                            uni.Domestic_Early_Comments = dtEarly.Rows[i]["Early_Comments"].ToString();
                        }
                        else
                        {
                            uni.International_Early_Decision_Offered = dtEarly.Rows[i]["Early_Decision_Offered"].ToString();
                            uni.International_Earlr_Notification = dtEarly.Rows[i]["Earlr_Notification"].ToString();
                            uni.Hidenn3 = dtEarly.Rows[i]["Earlr_Notification"].ToString();
                            uni.International_Early_Decision_Deadline = dtEarly.Rows[i]["Early_Decision_Deadline"].ToString();
                            uni.Hidenn2 = dtEarly.Rows[i]["Early_Decision_Deadline"].ToString();
                            uni.International_Early_Deposit_Deadline = dtEarly.Rows[i]["Early_Deposit_Deadline"].ToString();
                            uni.Hidenn5 = dtEarly.Rows[i]["Early_Decision_Deadline"].ToString();
                            uni.International_Early_Financial_Aid_Deadline = dtEarly.Rows[i]["Early_Financial_Aid_Deadline"].ToString();
                            uni.International_Early_Action_offered = dtEarly.Rows[i]["Early_Action_offered"].ToString();
                            uni.International_Early_Action_Deadline = dtEarly.Rows[i]["Early_Action_Deadline"].ToString();
                            uni.International_Early_Action_Notification = dtEarly.Rows[i]["Early_Action_Notification"].ToString();
                            uni.International_Early_Notes = dtEarly.Rows[i]["Early_Notes"].ToString();
                            uni.International_Early_Data_URL = dtEarly.Rows[i]["Data_URL"].ToString();
                            uni.International_Early_Comments = dtEarly.Rows[i]["Early_Comments"].ToString();
                        }

                        uni.Early_Status = dtEarly.Rows[i]["Early_Status"].ToString();
                    }
                }
                else
                {
                    uni.Early_count=0;

                    uni.International_Early_Data_URL = "http://";
                    uni.Domestic_Early_Data_URL = "http://";

                    uni.International_Early_Decision_Offered ="";
                    uni.International_Earlr_Notification = "";
                    uni.International_Early_Decision_Deadline ="";
                    uni.International_Early_Deposit_Deadline = "";

                    uni.International_Earlr_Notification1 ="";
                    uni.International_Early_Decision_Deadline1 = "";
                    uni.International_Early_Deposit_Deadline1 = "";

                    uni.International_Early_Financial_Aid_Deadline = "";
                    uni.International_Early_Action_offered = "";
                    uni.International_Early_Action_Deadline = "";
                    uni.International_Early_Action_Notification ="";
                    uni.International_Early_Notes = "";
                    uni.International_Early_Comments = "";

                    uni.Domestic_Early_Decision_Offered = "";
                    uni.Domestic_Earlr_Notification ="";
                    uni.Domestic_Early_Decision_Deadline = "";
                    uni.Domestic_Early_Deposit_Deadline = "";

                    uni.Domestic_Earlr_Notification1 ="";
                    uni.Domestic_Early_Decision_Deadline1 = "";
                    uni.Domestic_Early_Deposit_Deadline1 = "";

                    uni.Domestic_Early_Financial_Aid_Deadline = "";
                    uni.Domestic_Early_Action_offered = "";
                    uni.Domestic_Early_Action_Deadline = "";
                    uni.Domestic_Early_Action_Notification = "";
                    uni.Domestic_Early_Notes = "";
                    uni.Domestic_Early_Comments ="";
                }

                //Spring Admission
                DataTable dtSpring = DBWizard.FillDataTable(strConnString, "Sp_Select_Tb_Spring_Application_Dates",
                        new object[] { na1[1] });

                if (dtSpring.Rows.Count > 0)
                {
                    if (Save == "Spring_Update" || Save == "Spring_Save")
                    {
                        uni.Spring_count = 2;
                        uni.count1 = 0; uni.count = 0;
                    }
                    else
                    {
                        uni.Spring_count = 1;
                    }

                    for (int i = 0; i < dtSpring.Rows.Count; i++)
                    {
                        if (i == 0)
                        {
                            uni.Domestic_Spring_Regular_Admission_Deadline = dtSpring.Rows[i]["Admission_Deadline"].ToString();
                            uni.Domestic_Spring_Admission_Notification = dtSpring.Rows[i]["Admission_Notification"].ToString();
                            uni.Domestic_Spring_Deposit_Deadline = dtSpring.Rows[i]["Deposit_Deadline"].ToString();
                            uni.Domestic_Spring_Accept_Offer = dtSpring.Rows[i]["Accept_Offer"].ToString();
                            uni.Domestic_Spring_Admission_WaitingListUsed = dtSpring.Rows[i]["Admission_WaitingListUsed"].ToString();
                            uni.Domestic_Spring_Defer_Admission = dtSpring.Rows[i]["Defer_Admission"].ToString();
                            uni.Domestic_Spring_Transfer_Admission = dtSpring.Rows[i]["Transfer_Admission"].ToString();
                            uni.Domestic_Spring_Financial_Aid_Deadline = dtSpring.Rows[i]["Financial_Aid_Deadline"].ToString();
                            uni.Domestic_Spring_Admission_Notes = dtSpring.Rows[i]["Notes"].ToString();
                            uni.Domestic_Spring_Data_URL = dtSpring.Rows[i]["Data_URL"].ToString();
                            uni.Domestic_Spring_Comments = dtSpring.Rows[i]["Spring_Comments"].ToString();
                        }
                        else
                        {
                            uni.International_Spring_Regular_Admission_Deadline = dtSpring.Rows[i]["Admission_Deadline"].ToString();
                            uni.International_Spring_Admission_Notification = dtSpring.Rows[i]["Admission_Notification"].ToString();
                            uni.International_Spring_Deposit_Deadline = dtSpring.Rows[i]["Deposit_Deadline"].ToString();
                            uni.International_Spring_Accept_Offer = dtSpring.Rows[i]["Accept_Offer"].ToString();
                            uni.International_Spring_Admission_WaitingListUsed = dtSpring.Rows[i]["Admission_WaitingListUsed"].ToString();
                            uni.International_Spring_Defer_Admission = dtSpring.Rows[i]["Defer_Admission"].ToString();
                            uni.International_Spring_Transfer_Admission = dtSpring.Rows[i]["Transfer_Admission"].ToString();
                            uni.International_Spring_Financial_Aid_Deadline = dtSpring.Rows[i]["Financial_Aid_Deadline"].ToString();
                            uni.International_Spring_Admission_Notes = dtSpring.Rows[i]["Notes"].ToString();
                            uni.International_Spring_Data_URL = dtSpring.Rows[i]["Data_URL"].ToString();
                            uni.International_Spring_Comments = dtSpring.Rows[i]["Spring_Comments"].ToString();
                        }

                        uni.Spring_Status = dtSpring.Rows[i]["Spring_Status"].ToString();
                    }
                }
                else
                {
                    uni.Spring_count = 0;

                    uni.Domestic_Spring_Regular_Admission_Deadline = "";
                    uni.Domestic_Spring_Admission_Notification = "";
                    uni.Domestic_Spring_Deposit_Deadline = "";
                    uni.Domestic_Spring_Accept_Offer = "";
                    uni.Domestic_Spring_Admission_WaitingListUsed = "";
                    uni.Domestic_Spring_Defer_Admission = "";
                    uni.Domestic_Spring_Transfer_Admission ="";
                    uni.Domestic_Spring_Financial_Aid_Deadline = "";
                    uni.Domestic_Spring_Admission_Notes = "";
                    uni.Domestic_Spring_Data_URL = "http://";
                    uni.Domestic_Spring_Comments = "";

                    uni.International_Spring_Regular_Admission_Deadline = "";
                    uni.International_Spring_Admission_Notification = "";
                    uni.International_Spring_Deposit_Deadline = "";
                    uni.International_Spring_Accept_Offer = "";
                    uni.International_Spring_Admission_WaitingListUsed = "";
                    uni.International_Spring_Defer_Admission = "";
                    uni.International_Spring_Transfer_Admission = "";
                    uni.International_Spring_Financial_Aid_Deadline = "";
                    uni.International_Spring_Admission_Notes = "";
                    uni.International_Spring_Data_URL = "http://";
                    uni.International_Spring_Comments = "";
                }

                //Summer Admission
                DataTable dtSummer = DBWizard.FillDataTable(strConnString, "Sp_Select_Tb_Summer_Application_Datess",
                        new object[] { na1[1] });

                if (dtSummer.Rows.Count > 0)
                {
                    if (Save == "Summer_Update" || Save == "Summer_Save")
                    {
                        uni.Summer_count = 2;
                        uni.count1 = 0; uni.count = 0;
                    }
                    else
                    {
                        uni.Summer_count = 1;
                    }

                    for (int i = 0; i < dtSummer.Rows.Count; i++)
                    {
                        if (i == 0)
                        {
                            uni.Domestic_Summer_Regular_Admission_Deadline = dtSummer.Rows[i]["Admission_Deadline"].ToString();
                            uni.Domestic_Summer_Admission_Notification = dtSummer.Rows[i]["Admission_Notification"].ToString();
                            uni.Domestic_Summer_Deposit_Deadline = dtSummer.Rows[i]["Deposit_Deadline"].ToString();
                            uni.Domestic_Summer_Accept_Offer = dtSummer.Rows[i]["Accept_Offer"].ToString();
                            uni.Domestic_Summer_Admission_WaitingListUsed = dtSummer.Rows[i]["Admission_WaitingListUsed"].ToString();
                            uni.Domestic_Summer_Defer_Admission = dtSummer.Rows[i]["Defer_Admission"].ToString();
                            uni.Domestic_Summer_Transfer_Admission = dtSummer.Rows[i]["Transfer_Admission"].ToString();
                            uni.Domestic_Summer_Financial_Aid_Deadline = dtSummer.Rows[i]["Financial_Aid_Deadline"].ToString();
                            uni.Domestic_Summer_Admission_Notes = dtSummer.Rows[i]["Notes"].ToString();
                            uni.Domestic_Summer_Data_URL = dtSummer.Rows[i]["Data_URL"].ToString();
                            uni.Domestic_Summer_Comments = dtSummer.Rows[i]["Spring_Comments"].ToString();
                        }
                        else
                        {
                            uni.International_Summer_Regular_Admission_Deadline = dtSummer.Rows[i]["Admission_Deadline"].ToString();
                            uni.International_Summer_Admission_Notification = dtSummer.Rows[i]["Admission_Notification"].ToString();
                            uni.International_Summer_Deposit_Deadline = dtSummer.Rows[i]["Deposit_Deadline"].ToString();
                            uni.International_Summer_Accept_Offer = dtSummer.Rows[i]["Accept_Offer"].ToString();
                            uni.International_Summer_Admission_WaitingListUsed = dtSummer.Rows[i]["Admission_WaitingListUsed"].ToString();
                            uni.International_Summer_Defer_Admission = dtSummer.Rows[i]["Defer_Admission"].ToString();
                            uni.International_Summer_Transfer_Admission = dtSummer.Rows[i]["Transfer_Admission"].ToString();
                            uni.International_Summer_Financial_Aid_Deadline = dtSummer.Rows[i]["Financial_Aid_Deadline"].ToString();
                            uni.International_Summer_Admission_Notes = dtSummer.Rows[i]["Notes"].ToString();
                            uni.International_Summer_Data_URL = dtSummer.Rows[i]["Data_URL"].ToString();
                            uni.International_Summer_Comments = dtSummer.Rows[i]["Spring_Comments"].ToString();
                        }

                        uni.Summer_Status = dtSummer.Rows[i]["Spring_Status"].ToString();
                    }
                }
                else
                {
                    uni.Summer_count = 0;


                    uni.Domestic_Summer_Regular_Admission_Deadline = "";
                    uni.Domestic_Summer_Admission_Notification = "";
                    uni.Domestic_Summer_Deposit_Deadline = "";
                    uni.Domestic_Summer_Accept_Offer = "";
                    uni.Domestic_Summer_Admission_WaitingListUsed = "";
                    uni.Domestic_Summer_Defer_Admission = "";
                    uni.Domestic_Summer_Transfer_Admission = "";
                    uni.Domestic_Summer_Financial_Aid_Deadline = "";
                    uni.Domestic_Summer_Admission_Notes = "";
                    uni.Domestic_Summer_Data_URL = "http://";
                    uni.Domestic_Summer_Comments = "";

                    uni.International_Summer_Regular_Admission_Deadline = "";
                    uni.International_Summer_Admission_Notification = "";
                    uni.International_Summer_Deposit_Deadline = "";
                    uni.International_Summer_Accept_Offer = "";
                    uni.International_Summer_Admission_WaitingListUsed = "";
                    uni.International_Summer_Defer_Admission = "";
                    uni.International_Summer_Transfer_Admission = "";
                    uni.International_Summer_Financial_Aid_Deadline = "";
                    uni.International_Summer_Admission_Notes = "";
                    uni.International_Summer_Data_URL = "http://";
                    uni.International_Summer_Comments = "";
                }


                //Spring Priority Admission
                DataTable dtSpring_Priority = DBWizard.FillDataTable(strConnString, "Sp_Select_Tb_Spring_Priority_Dates",
                       new object[] { na1[1] });


                if (dtSpring_Priority.Rows.Count > 0)
                {
                    if (Save == "Spring_Priority_Update" || Save == "Spring_Priority_Save")
                    {
                        uni.Spring_Priority_count = 2;
                        uni.count1 = 0; uni.count = 0;
                    }
                    else
                    {
                        uni.Spring_Priority_count = 1;
                    }

                    for (int i = 0; i < dtSpring_Priority.Rows.Count; i++)
                    {
                        if (i == 0)
                        {
                            uni.Domestic_Spring_Priority_Decision_Offered = dtSpring_Priority.Rows[i]["Decision_Offered"].ToString();

                            uni.Domestic_Spring_Priority_Decision_Deadline = dtSpring_Priority.Rows[i]["Decision_Deadline"].ToString();
                            uni.Hidenn6 = dtSpring_Priority.Rows[i]["Decision_Deadline"].ToString();
                            uni.Domestic_Spring_Priority_Decision_Notification = dtSpring_Priority.Rows[i]["Decision_Notification"].ToString();
                            uni.Hidenn8 = dtSpring_Priority.Rows[i]["Decision_Notification"].ToString();
                            uni.Domestic_Spring_Priority_Deposit_Deadline = dtSpring_Priority.Rows[i]["Deposit_Deadline"].ToString();
                            uni.Hidenn10 = dtSpring_Priority.Rows[i]["Deposit_Deadline"].ToString();


                            uni.Domestic_ESpring_Priority_Financial_Aid_Deadline = dtSpring_Priority.Rows[i]["Financial_Aid_Deadline"].ToString();
                            uni.Domestic_ESpring_Priority_Notes = dtSpring_Priority.Rows[i]["Notes"].ToString();
                            uni.Domestic_ESpring_Priority_Data_URL = dtSpring_Priority.Rows[i]["Data_URL"].ToString();
                            uni.Domestic_ESpring_Priority_Comments = dtSpring_Priority.Rows[i]["Spring_Comments"].ToString();
                        }
                        else
                        {
                            uni.International_Spring_Priority_Decision_Offered = dtSpring_Priority.Rows[i]["Decision_Offered"].ToString();

                            uni.International_Spring_Priority_Decision_Deadline = dtSpring_Priority.Rows[i]["Decision_Deadline"].ToString();
                            uni.Hidenn7 = dtSpring_Priority.Rows[i]["Decision_Deadline"].ToString();
                            uni.International_Spring_Priority_Decision_Notification = dtSpring_Priority.Rows[i]["Decision_Notification"].ToString();
                            uni.Hidenn9 = dtSpring_Priority.Rows[i]["Decision_Notification"].ToString();
                            uni.International_Spring_Priority_Deposit_Deadline = dtSpring_Priority.Rows[i]["Deposit_Deadline"].ToString();
                            uni.Hidenn11 = dtSpring_Priority.Rows[i]["Deposit_Deadline"].ToString();
                            uni.International_ESpring_Priority_Financial_Aid_Deadline = dtSpring_Priority.Rows[i]["Financial_Aid_Deadline"].ToString();
                            uni.International_ESpring_Priority_Notes = dtSpring_Priority.Rows[i]["Notes"].ToString();
                            uni.International_ESpring_Priority_Data_URL = dtSpring_Priority.Rows[i]["Data_URL"].ToString();
                            uni.International_ESpring_Priority_Comments = dtSpring_Priority.Rows[i]["Spring_Comments"].ToString();
                        }

                        uni.Spring_Priority_Status = dtSpring_Priority.Rows[i]["Spring_Status"].ToString();
                    }
                }
                else
                {
                    uni.Spring_Priority_count = 0;

                    uni.Domestic_Spring_Priority_Decision_Offered = "";
                    uni.Domestic_Spring_Priority_Decision_Deadline = "";
                    uni.Domestic_Spring_Priority_Decision_Notification = "";
                    uni.Domestic_Spring_Priority_Deposit_Deadline = "";

                    uni.Domestic_Spring_Priority_Decision_Deadline1 = "";
                    uni.Domestic_Spring_Priority_Decision_Notification1 = "";
                    uni.Domestic_Spring_Priority_Deposit_Deadline1 = "";

                    uni.Domestic_ESpring_Priority_Financial_Aid_Deadline = "";
                    uni.Domestic_ESpring_Priority_Notes = "";
                    uni.Domestic_ESpring_Priority_Data_URL = "http://";
                    uni.Domestic_ESpring_Priority_Comments = "";

                    uni.International_Spring_Priority_Decision_Offered = "";
                    uni.International_Spring_Priority_Decision_Deadline = "";
                    uni.International_Spring_Priority_Decision_Notification = "";
                    uni.International_Spring_Priority_Deposit_Deadline = "";

                    uni.International_Spring_Priority_Decision_Deadline1 = "";
                    uni.International_Spring_Priority_Decision_Notification1 = "";
                    uni.International_Spring_Priority_Deposit_Deadline1 = "";

                    uni.International_ESpring_Priority_Financial_Aid_Deadline = "";
                    uni.International_ESpring_Priority_Notes = "";
                    uni.Domestic_ESpring_Priority_Data_URL = "http://";
                    uni.Domestic_ESpring_Priority_Comments = "";
                }

                //Summer Priority Admission
                DataTable dtSummer_Priority = DBWizard.FillDataTable(strConnString, "Sp_Select_Tb_Summer_Priority_Dates",
                       new object[] { na1[1] });


                if (dtSummer_Priority.Rows.Count > 0)
                {
                    if (Save == "Summer_Priority_Update" || Save == "Summer_Priority_Save")
                    {
                        uni.Priority_count = 2;
                        uni.count1 = 0; uni.count = 0;
                    }
                    else
                    {
                        uni.Priority_count = 1;
                    }
                    

                    for (int i = 0; i < dtSummer_Priority.Rows.Count; i++)
                    {
                        if (i == 0)
                        {
                            uni.Domestic_Summer_Priority_Decision_Offered = dtSummer_Priority.Rows[i]["Decision_Offered"].ToString();

                            uni.Domestic_Summer_Priority_Decision_Deadline = dtSummer_Priority.Rows[i]["Decision_Deadline"].ToString();
                            uni.Hidenn12 = dtSummer_Priority.Rows[i]["Decision_Deadline"].ToString();
                            uni.Domestic_Summer_Priority_Decision_Notification = dtSummer_Priority.Rows[i]["Decision_Notification"].ToString();
                            uni.Hidenn14 = dtSummer_Priority.Rows[i]["Decision_Notification"].ToString();
                            uni.Domestic_Summer_Priority_Deposit_Deadline = dtSummer_Priority.Rows[i]["Deposit_Deadline"].ToString();
                            uni.Hidenn16 = dtSummer_Priority.Rows[i]["Deposit_Deadline"].ToString();
                            uni.Domestic_ESummer_Priority_Financial_Aid_Deadline = dtSummer_Priority.Rows[i]["Financial_Aid_Deadline"].ToString();
                            uni.Domestic_ESummer_Priority_Notes = dtSummer_Priority.Rows[i]["Notes"].ToString();
                            uni.Domestic_ESummer_Priority_Data_URL = dtSummer_Priority.Rows[i]["Data_URL"].ToString();
                            uni.Domestic_ESummer_Priority_Comments = dtSummer_Priority.Rows[i]["Spring_Comments"].ToString();
                        }
                        else
                        {
                            uni.International_Summer_Priority_Decision_Offered = dtSummer_Priority.Rows[i]["Decision_Offered"].ToString();
                            
                            uni.International_Summer_Priority_Decision_Deadline = dtSummer_Priority.Rows[i]["Decision_Deadline"].ToString();
                            uni.Hidenn13 = dtSummer_Priority.Rows[i]["Decision_Deadline"].ToString();
                            uni.International_Summer_Priority_Decision_Notification = dtSummer_Priority.Rows[i]["Decision_Notification"].ToString();
                            uni.Hidenn15 = dtSummer_Priority.Rows[i]["Decision_Notification"].ToString();
                            uni.International_Summer_Priority_Deposit_Deadline = dtSummer_Priority.Rows[i]["Deposit_Deadline"].ToString();
                            uni.Hidenn17 = dtSummer_Priority.Rows[i]["Deposit_Deadline"].ToString();
                            uni.International_ESummer_Priority_Financial_Aid_Deadline = dtSummer_Priority.Rows[i]["Financial_Aid_Deadline"].ToString();
                            uni.International_ESummer_Priority_Notes = dtSummer_Priority.Rows[i]["Notes"].ToString();
                            uni.International_ESummer_Priority_Data_URL = dtSummer_Priority.Rows[i]["Data_URL"].ToString();
                            uni.International_ESummer_Priority_Comments = dtSummer_Priority.Rows[i]["Spring_Comments"].ToString();
                        }

                        uni.Priority_Status = dtSummer_Priority.Rows[i]["Spring_Status"].ToString();
                    }
                }
                else
                {
                    uni.Priority_count = 0;


                    uni.Domestic_Summer_Priority_Decision_Offered = "";
                    uni.Domestic_Summer_Priority_Decision_Deadline = "";
                    uni.Domestic_Summer_Priority_Decision_Notification = "";
                    uni.Domestic_Summer_Priority_Deposit_Deadline = "";

                    uni.Domestic_Summer_Priority_Decision_Deadline1 = "";
                    uni.Domestic_Summer_Priority_Decision_Notification1 = "";
                    uni.Domestic_Summer_Priority_Deposit_Deadline1 = "";

                    uni.Domestic_ESummer_Priority_Financial_Aid_Deadline = "";
                    uni.Domestic_ESummer_Priority_Notes = "";
                    uni.Domestic_ESummer_Priority_Data_URL = "http://";
                    uni.Domestic_ESummer_Priority_Comments = "";

                    uni.International_Summer_Priority_Decision_Offered = "";
                    uni.International_Summer_Priority_Decision_Deadline = "";
                    uni.International_Summer_Priority_Decision_Notification = "";
                    uni.International_Summer_Priority_Deposit_Deadline = "";

                    uni.International_Summer_Priority_Decision_Deadline1 = "";
                    uni.International_Summer_Priority_Decision_Notification1 = "";
                    uni.International_Summer_Priority_Deposit_Deadline1 = "";

                    uni.International_ESummer_Priority_Financial_Aid_Deadline = "";
                    uni.International_ESummer_Priority_Notes = "";
                    uni.International_ESummer_Priority_Data_URL = "http://";
                    uni.Domestic_ESummer_Priority_Comments = "";
                }

            }
            else
            {
                Response.Redirect("~/Login/Login");
            }




            return View(uni);
        }
        public string Encode(string encodeMe)
        {
            byte[] encoded = System.Text.Encoding.UTF8.GetBytes(encodeMe);
            return Convert.ToBase64String(encoded);
        }

        public static string Decode(string decodeMe)
        {
            byte[] encoded = Convert.FromBase64String(decodeMe);
            return System.Text.Encoding.UTF8.GetString(encoded);
        }

    }
}
