public with sharing class CLAPdfController {
    
    private final Credit_Limit_Application__c cla;
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

    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public CLAPdfController(ApexPages.StandardController stdController) {
        System.debug('Id='+stdController.getId());
        List<Credit_Limit_Application__c> cla_list = [select Id, Name,Application_Date__c,CL_Application_Amount__c,Payment_Term_Type__c,Payment_Term_Days__c,Buyer_Name__c,Buyer_Country__c,Buyer_Address_Line_1__c,Buyer_Address_Line_2__c,Buyer_Address_Line_3__c,Buyer_Address_Line_4__c,Buyer_Code__c,Exporter__r.Name,Exporter__r.Registered_Address_Line_1__c,Exporter__r.Registered_Address_Line_2__c,Exporter__r.Registered_Address_Line_3__c,Exporter__r.Registered_District__c,Exporter__r.Registered_Territory__c,Exporter__r.Correspondence_Address_Line_1__c,Exporter__r.Correspondence_Address_Line_2__c,Exporter__r.Correspondence_Address_Line_3__c,Exporter__r.Correspondence_District__c,Exporter__r.Correspondence_Territory__c,Exporter__r.Language_of_Correspondence__c,Policy__r.Legacy_Customer_Number__c from Credit_Limit_Application__c where Id=:stdController.getId()];
        //(Credit_Limit_Application__c)stdController.getRecord();
        if((cla_list!= null) && (cla_list.size()>0)) {
            this.cla = cla_list[0];
            if(this.cla.Application_Date__c!=null)
                application_date = this.cla.Application_Date__c;
            Buyer_Name = this.cla.Buyer_Name__c;
            Buyer_Address_Line_1 = this.cla.Buyer_Address_Line_1__c;
            Buyer_Address_Line_2 = this.cla.Buyer_Address_Line_2__c;
            Buyer_Address_Line_3 = this.cla.Buyer_Address_Line_3__c;
            Buyer_Address_Line_4 = this.cla.Buyer_Address_Line_4__c;
            Buyer_Code = this.cla.Buyer_Code__c;
            Policy_Legacy_Customer_Number = this.cla.Policy__r.Legacy_Customer_Number__c;
            account_Name = this.cla.Exporter__r.Name;
            account_Registered_Address_Line_1 = this.cla.Exporter__r.Registered_Address_Line_1__c;
            account_Registered_Address_Line_2 = this.cla.Exporter__r.Registered_Address_Line_2__c;
            account_Registered_Address_Line_3 = this.cla.Exporter__r.Registered_Address_Line_3__c;
            account_Registered_District = this.cla.Exporter__r.Registered_District__c;
            account_Registered_Territory =this.cla.Exporter__r.Registered_Territory__c;
            Payment_Term_Type = this.cla.Payment_Term_Type__c;
            Payment_Term_Days = this.cla.Payment_Term_Days__c;
        }
    }

    public String getGreeting() {
        return 'Hello ' + cla.name + ' (' + cla.id + ')';
    }

}