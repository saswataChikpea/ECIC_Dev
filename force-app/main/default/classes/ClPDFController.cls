public with sharing class ClPDFController {
    private final Credit_Limit__c cl;
    public Date application_date{get;set;}
    public Decimal CL_Application_Amount{get;set;}    
    public string Payment_Term_Type{get;set;}
    public Decimal Payment_Term_Days{get;set;}
    public String Buyer_Name{get;set;}
    public String Buyer_Country{get;set;}
    public String Buyer_Address_Line_1{get;set;}
    public String Buyer_Address_Line_2{get;set;}
    public String Buyer_Address_Line_3{get;set;}
    public String Buyer_Address_Line_4{get;set;}
    public String Buyer_Code{get;set;}
    public String account_Name{get;set;}
    public String account_Registered_Address_Line_1{get;set;}
    public String account_Registered_Address_Line_2{get;set;}
    public String account_Registered_Address_Line_3{get;set;}
    public String account_Registered_District{get;set;}
    public String account_Registered_Territory{get;set;}
    public String account_Correspondence_Address_Line_1{get;set;}
    public String account_Correspondence_Address_Line_2{get;set;}
    public String account_Correspondence_Address_Line_3{get;set;}
    public String account_Correspondence_District{get;set;}
    public String account_Correspondence_Territory{get;set;}
    public String account_Language_of_Correspondence{get;set;}
    public String Policy_Legacy_Customer_Number{get;set;}
    public String cl_condition{get;set;}
    public Decimal cl_Amount{get;set;}
    public Date cl_approve_date{get;set;}
    public String cl_no{get;set;}


    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public ClPDFController(ApexPages.StandardController stdController) {
        String cl_str = ApexPages.currentPage().getParameters().get('cl');
        System.debug('cl_str='+cl_str);
        Credit_Limit__c new_cl = (Credit_Limit__c) JSON.deserialize(cl_str,SObject.class);
        System.debug('new_cl='+new_cl);
        // List<Credit_Limit__c> cl_list = [select Id, Name,Application_Date__c,CL_Application_Amount__c,Payment_Term_Type__c,Payment_Term_Days__c,Buyer_Name__c,Buyer_Country__c,Buyer_Address_Line_1__c,Buyer_Address_Line_2__c,Buyer_Address_Line_3__c,Buyer_Address_Line_4__c,Buyer_Code__c,Exporter__r.Name,Exporter__r.Registered_Address_Line_1__c,Exporter__r.Registered_Address_Line_2__c,Exporter__r.Registered_Address_Line_3__c,Exporter__r.Registered_District__c,Exporter__r.Registered_Territory__c,Exporter__r.Correspondence_Address_Line_1__c,Exporter__r.Correspondence_Address_Line_2__c,Exporter__r.Correspondence_Address_Line_3__c,Exporter__r.Correspondence_District__c,Exporter__r.Correspondence_Territory__c,Exporter__r.Language_of_Correspondence__c,Policy__r.Legacy_Customer_Number__c from Credit_Limit__c where Id=:stdController.getId()];
        List<Account> acc = [Select Id,Name,Registered_Address_Line_1__c,Registered_Address_Line_2__c,Registered_Address_Line_3__c,Registered_District__c,Registered_Territory__c,Legacy_Customer_Number__c from Account where Id=:new_cl.Exporter__c];
        
            application_date = new_cl.Application_Date__c ;
            Buyer_Name = new_cl.Buyer_Name__c;
            Buyer_Address_Line_1 = new_cl.Buyer_Address_Line_1__c;
            Buyer_Address_Line_2 = new_cl.Buyer_Address_Line_2__c;
            Buyer_Address_Line_3 = new_cl.Buyer_Address_Line_3__c;
            Buyer_Address_Line_4 = new_cl.Buyer_Address_Line_4__c;
            Buyer_Code = new_cl.Buyer_Code__c;
            cl_no = new_cl.CL_No__c;
            cl_Amount = new_cl.CL_Amount__c;
            if(new_cl.Approve_Date__c!=null)
                cl_approve_date = new_cl.Approve_Date__c;
            if(new_cl.CL_Condition__c!=null)
                cl_condition = new_cl.CL_Condition__c;
            if((acc.size()>0) && (acc[0].Legacy_Customer_Number__c != null))
                Policy_Legacy_Customer_Number = acc[0].Legacy_Customer_Number__c;
            if((acc.size()>0) && (acc[0].Name != null))
                account_Name = acc[0].Name;
            if((acc.size()>0) && (acc[0].Registered_Address_Line_1__c != null))
                account_Registered_Address_Line_1 = acc[0].Registered_Address_Line_1__c;
            if((acc.size()>0) && (acc[0].Registered_Address_Line_2__c != null))
                account_Registered_Address_Line_2 = acc[0].Registered_Address_Line_2__c;
            if((acc.size()>0) && (acc[0].Registered_Address_Line_3__c != null))
                account_Registered_Address_Line_3 = acc[0].Registered_Address_Line_3__c;
            if((acc.size()>0) && (acc[0].Registered_District__c != null))
                account_Registered_District = acc[0].Registered_District__c;
            if((acc.size()>0) && (acc[0].Registered_Territory__c != null))  
                account_Registered_Territory =acc[0].Registered_Territory__c;
            Payment_Term_Type = new_cl.Payment_Term_Type__c;
            Payment_Term_Days = new_cl.Payment_Term_Days__c;
        // }
    }

    public String getGreeting() {
        return 'Hello ' + cl.name + ' (' + cl.id + ')';
    }
    
}