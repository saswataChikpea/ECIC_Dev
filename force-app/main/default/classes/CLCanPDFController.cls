public with sharing class CLCanPDFController {
    private final Credit_Limit__c cl;
    public Date can_date{get;set;}
    public String cust_no{get;set;}
    public Decimal cl_amount{get;set;}
    public String payment_term_type{get;set;}
    public Decimal payment_term_day{get;set;}
    public String buyer_name{get;set;}
    public String buyer_code{get;set;}
    public Date effective_date{get;set;}
    public CLCanPDFController(ApexPages.StandardController stdController) {
        this.cl = [Select Id,Cancellation_Date__c,Policy__r.Legacy_Customer_Number__c,CL_Amount__c,Payment_Term_Type__c,Payment_Term_Days__c,Buyer_Name__c,Buyer_Code__c,CL_Effective_Date__c from Credit_Limit__c where Id=:stdController.getId()];
        if(this.cl.Cancellation_Date__c!=null)
            can_date = this.cl.Cancellation_Date__c;
        cust_no = this.cl.Policy__r.Legacy_Customer_Number__c;
        cl_amount = this.cl.CL_Amount__c;
        payment_term_type = this.cl.Payment_Term_Type__c;
        payment_term_day = this.cl.Payment_Term_Days__c;
        buyer_name = this.cl.Buyer_Name__c;
        buyer_code = this.cl.Buyer_Code__c;
        if(this.cl.CL_Effective_Date__c!=null)
            effective_date = this.cl.CL_Effective_Date__c;
    }
}