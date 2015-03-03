using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;

namespace Task.Models
{
    public class Univer
    {

        public String Universities_Name { get; set; }
        public String En_Universities_Name { get; set; }

        //Admission Fess
        public int count { get; set; }
        public int count1 { get; set; }

        public String Name { get; set; }

        public string Domestic_Fee { get; set; }
        public string Domestic_Weaver { get; set; }
        public string Domestic_Notes { get; set; }
        public string Domestic_URL { get; set; }

        public string International_Fee { get; set; }
        public string International_Weaver { get; set; }
        public string International_Notes { get; set; }
        public string International_URL { get; set; }

        public string Domestic_Comments { get; set; }
        public string International_Comments { get; set; }

        public string Status { get; set; }


        public List<Univer> uni { get; set; }

        //Fall Admissions
        public string Domestic_Admission_Deadline { get; set; }
        public string Domestic_Admission_Notification { get; set; }
        public string Domestic_Admission_Deposit_Deadline { get; set; }
        public string Domestic_Admission_Offer { get; set; }
        public string Domestic_Admission_WaitingListUsed { get; set; }
        public string Domestic_Defer_Admission { get; set; }
        public string Domestic_Transfer_Admission { get; set; }
        public string Domestic_Application_Deadline { get; set; }
        public string Domestic_Admission_Notes { get; set; }
        public string Domestic_Data_URL { get; set; }
        public string Domestic_Fall_Comments { get; set; }


        public string International_Admission_Deadline { get; set; }
        public string International_Admission_Notification { get; set; }
        public string International_Admission_Deposit_Deadline { get; set; }
        public string International_Admission_Offer { get; set; }
        public string International_Admission_WaitingListUsed { get; set; }
        public string International_Defer_Admission { get; set; }
        public string International_Transfer_Admission { get; set; }
        public string International_Application_Deadline { get; set; }
        public string International_Admission_Notes { get; set; }
        public string International_Data_URL { get; set; }
        public string International_Fall_Comments { get; set; }

        public int Fall_count { get; set; }
        public string Fall_Status { get; set; }

        //Early Admissions
        public string Domestic_Early_Decision_Offered{ get; set; }
        public string Domestic_Earlr_Notification { get; set; }
        public string Domestic_Early_Decision_Deadline { get; set; }
        public string Domestic_Early_Deposit_Deadline { get; set; }


        public string Domestic_Earlr_Notification1 { get; set; }
        public string Domestic_Early_Decision_Deadline1 { get; set; }
        public string Domestic_Early_Deposit_Deadline1 { get; set; }

        public string Domestic_Early_Financial_Aid_Deadline { get; set; }
        public string Domestic_Early_Action_offered { get; set; }
        public string Domestic_Early_Action_Deadline { get; set; }
        public string Domestic_Early_Action_Notification { get; set; }
        public string Domestic_Early_Notes { get; set; }
        public string Domestic_Early_Data_URL { get; set; }
        public string Domestic_Early_Comments { get; set; }


        public string International_Early_Decision_Offered { get; set; }
        public string International_Earlr_Notification { get; set; }
        public string International_Early_Decision_Deadline { get; set; }
        public string International_Early_Deposit_Deadline { get; set; }

        public string International_Earlr_Notification1 { get; set; }
        public string International_Early_Decision_Deadline1 { get; set; }
        public string International_Early_Deposit_Deadline1 { get; set; }

        public string International_Early_Financial_Aid_Deadline { get; set; }
        public string International_Early_Action_offered { get; set; }
        public string International_Early_Action_Deadline { get; set; }
        public string International_Early_Action_Notification { get; set; }
        public string International_Early_Notes { get; set; }
        public string International_Early_Data_URL { get; set; }
        public string International_Early_Comments { get; set; }

        public int Early_count { get; set; }
        public string Early_Status { get; set; }

        //Summer Application Admission
        public string Domestic_Summer_Regular_Admission_Deadline{ get; set; }
        public string Domestic_Summer_Admission_Notification { get; set; }
        public string Domestic_Summer_Deposit_Deadline { get; set; }
        public string Domestic_Summer_Accept_Offer{ get; set; }
        public string Domestic_Summer_Admission_WaitingListUsed { get; set; }
        public string Domestic_Summer_Defer_Admission { get; set; }
        public string Domestic_Summer_Transfer_Admission { get; set; }
        public string Domestic_Summer_Financial_Aid_Deadline { get; set; }
        public string Domestic_Summer_Admission_Notes { get; set; }
        public string Domestic_Summer_Data_URL { get; set; }
        public string Domestic_Summer_Comments { get; set; }


        public string International_Summer_Regular_Admission_Deadline { get; set; }
        public string International_Summer_Admission_Notification { get; set; }
        public string International_Summer_Deposit_Deadline { get; set; }
        public string International_Summer_Accept_Offer { get; set; }
        public string International_Summer_Admission_WaitingListUsed { get; set; }
        public string International_Summer_Defer_Admission { get; set; }
        public string International_Summer_Transfer_Admission { get; set; }
        public string International_Summer_Financial_Aid_Deadline { get; set; }
        public string International_Summer_Admission_Notes { get; set; }
        public string International_Summer_Data_URL { get; set; }
        public string International_Summer_Comments { get; set; }

        public int Summer_count { get; set; }
        public string Summer_Status { get; set; }
        
        //Summer Priority Admission
        public string Domestic_Summer_Priority_Decision_Offered{ get; set; }
        public string Domestic_Summer_Priority_Decision_Deadline { get; set; }
        public string Domestic_Summer_Priority_Decision_Notification { get; set; }
        public string Domestic_Summer_Priority_Deposit_Deadline { get; set; }

        public string Domestic_Summer_Priority_Decision_Deadline1 { get; set; }
        public string Domestic_Summer_Priority_Decision_Notification1 { get; set; }
        public string Domestic_Summer_Priority_Deposit_Deadline1 { get; set; }

        public string Domestic_ESummer_Priority_Financial_Aid_Deadline { get; set; }
        public string Domestic_ESummer_Priority_Notes { get; set; }
        public string Domestic_ESummer_Priority_Data_URL { get; set; }
        public string Domestic_ESummer_Priority_Comments { get; set; }


        public string International_Summer_Priority_Decision_Offered { get; set; }
        public string International_Summer_Priority_Decision_Deadline { get; set; }
        public string International_Summer_Priority_Decision_Notification { get; set; }
        public string International_Summer_Priority_Deposit_Deadline { get; set; }

        public string International_Summer_Priority_Decision_Deadline1 { get; set; }
        public string International_Summer_Priority_Decision_Notification1 { get; set; }
        public string International_Summer_Priority_Deposit_Deadline1 { get; set; }

        public string International_ESummer_Priority_Financial_Aid_Deadline { get; set; }
        public string International_ESummer_Priority_Notes { get; set; }
        public string International_ESummer_Priority_Data_URL { get; set; }
        public string International_ESummer_Priority_Comments { get; set; }

        public int Priority_count { get; set; }
        public string Priority_Status { get; set; }

        //Spring Application Admission
        public string Domestic_Spring_Regular_Admission_Deadline { get; set; }
        public string Domestic_Spring_Admission_Notification { get; set; }
        public string Domestic_Spring_Deposit_Deadline { get; set; }
        public string Domestic_Spring_Accept_Offer { get; set; }
        public string Domestic_Spring_Admission_WaitingListUsed { get; set; }
        public string Domestic_Spring_Defer_Admission { get; set; }
        public string Domestic_Spring_Transfer_Admission { get; set; }
        public string Domestic_Spring_Financial_Aid_Deadline { get; set; }
        public string Domestic_Spring_Admission_Notes { get; set; }
        public string Domestic_Spring_Data_URL { get; set; }
        public string Domestic_Spring_Comments { get; set; }

        public string International_Spring_Regular_Admission_Deadline { get; set; }
        public string International_Spring_Admission_Notification { get; set; }
        public string International_Spring_Deposit_Deadline { get; set; }
        public string International_Spring_Accept_Offer { get; set; }
        public string International_Spring_Admission_WaitingListUsed { get; set; }
        public string International_Spring_Defer_Admission { get; set; }
        public string International_Spring_Transfer_Admission { get; set; }
        public string International_Spring_Financial_Aid_Deadline { get; set; }
        public string International_Spring_Admission_Notes { get; set; }
        public string International_Spring_Data_URL { get; set; }
        public string International_Spring_Comments { get; set; }

        public int Spring_count { get; set; }
        public string Spring_Status { get; set; }

        //Spring Priority Admission
        public string Domestic_Spring_Priority_Decision_Offered { get; set; }
        public string Domestic_Spring_Priority_Decision_Deadline { get; set; }
        public string Domestic_Spring_Priority_Decision_Notification { get; set; }
        public string Domestic_Spring_Priority_Deposit_Deadline { get; set; }

        public string Domestic_Spring_Priority_Decision_Deadline1 { get; set; }
        public string Domestic_Spring_Priority_Decision_Notification1 { get; set; }
        public string Domestic_Spring_Priority_Deposit_Deadline1 { get; set; }

        public string Domestic_ESpring_Priority_Financial_Aid_Deadline { get; set; }
        public string Domestic_ESpring_Priority_Notes { get; set; }
        public string Domestic_ESpring_Priority_Data_URL { get; set; }
        public string Domestic_ESpring_Priority_Comments { get; set; }


        public string International_Spring_Priority_Decision_Offered { get; set; }
        public string International_Spring_Priority_Decision_Deadline { get; set; }
        public string International_Spring_Priority_Decision_Notification { get; set; }
        public string International_Spring_Priority_Deposit_Deadline { get; set; }

        public string International_Spring_Priority_Decision_Deadline1 { get; set; }
        public string International_Spring_Priority_Decision_Notification1 { get; set; }
        public string International_Spring_Priority_Deposit_Deadline1 { get; set; }

        public string International_ESpring_Priority_Financial_Aid_Deadline { get; set; }
        public string International_ESpring_Priority_Notes { get; set; }
        public string International_ESpring_Priority_Data_URL { get; set; }
        public string International_ESpring_Priority_Comments { get; set; }

        public int Spring_Priority_count { get; set; }
        public string Spring_Priority_Status { get; set; }


        //Hidden Fileds
        public string Hidenn { get; set; }
        public string Hidenn1 { get; set; }
        public string Hidenn2 { get; set; }
        public string Hidenn3 { get; set; }
        public string Hidenn4 { get; set; }
        public string Hidenn5 { get; set; }


        public string Hidenn6 { get; set; }
        public string Hidenn7 { get; set; }
        public string Hidenn8 { get; set; }
        public string Hidenn9 { get; set; }
        public string Hidenn10 { get; set; }
        public string Hidenn11{ get; set; }

        public string Hidenn12 { get; set; }
        public string Hidenn13{ get; set; }
        public string Hidenn14{ get; set; }
        public string Hidenn15 { get; set; }
        public string Hidenn16 { get; set; }
        public string Hidenn17 { get; set; }

        public string Hidenn18 { get; set; }
        public string Hidenn19 { get; set; }
        public string Hidenn20 { get; set; }
        public string Hidenn21 { get; set; }
        public string Hidenn22{ get; set; }
        public string Hidenn23{ get; set; }

        public string Fallview { get; set; }
        public string Fallview1 { get; set; }

        public string Application_Dates="Application Dates";
        public string Early_Admission = "Early Admission";
        public string Priority_Admission = "Priority Admission";


    }


}