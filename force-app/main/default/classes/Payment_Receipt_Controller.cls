public with sharing class Payment_Receipt_Controller {
    public String Payment_Id {get;set;}
    public String Receipt_No {get;set;}
    public DateTime Payment_Date {get;set;}
    public String Payment_Date_top {get;set;}
    public String Payment_Date_bottom {get;set;}
    public String Title {get;set;}
    public String Company_Name {get;set;}
    public String Policy_Id {get;set;}
    public String Payment_Receipt_no {get;set;}
    public String Policy_Type {get;set;}
    public String Customer_Number {get;set;}
    public String Invoice_No {get;set;}
    public Decimal Payment_Amt {get;set;}
    public String Invoice_Id {get;set;} 
    public Decimal Invoice_Total {get;set;}
    public List<Invoice_Line__c> invoiceLinesList {get;set;}
    public List<AggregateResult> Invoice_Total_list {get;set;}


    public Payment_Receipt_Controller() {
        // Payment_Id = ApexPages.currentPage().getParameters().get('paymentId');
        Invoice_Id = ApexPages.currentPage().getParameters().get('InvoiceId');
        System.debug('Invoice_Id::'+Invoice_Id);

        Invoice__c invObj = [select id,name,Policy__c,Payment__c from Invoice__c where id = :Invoice_Id];
        Payment_Id = invObj.Payment__c;
        Policy_Id = invObj.Policy__c;
        Invoice_No = invObj.name;

        System.debug('Payment_Id::'+Payment_Id);
        System.debug('Policy_Id::'+Policy_Id);
        for (Payment__c var : [Select Id,Name,Account__r.Current_Policy__c,Payment_Date__c,Amount__c,Invoice__r.Name,Invoice__r.Id from Payment__c where Invoice__c =:Invoice_Id]) {
            // Policy_Id = var.Account__r.Current_Policy__c;
            // Invoice_No = var.Invoice__r.Name;
            Payment_Amt = var.Amount__c;
            // Invoice_Id = var.Invoice__r.Id; 
            Payment_Receipt_no = var.Name;
        }
        System.debug('Invoice_Id::'+Invoice_Id);
        System.debug('Payment_Amt::'+Payment_Amt);
        for (Payment__c var : [Select Id,Payment_Date__c,Description__c from Payment__c where Invoice__r.Id =: Invoice_Id]) {
            DateTime dT3 = var.Payment_Date__c;
            Payment_Date = Date.newInstance(dT3.year(), dT3.month(), dT3.day());
            // Payment_Message = var.Description__c;
        }
        System.debug('Policy_Id::'+Policy_Id);
        for ( Policy__c var : [select Product__r.Name from Policy__c where Id =: Policy_Id]) {
            Policy_Type = var.Product__r.Name;
        }
        
        invoiceLinesList =  [Select Id,Name,Buyer_s_Code__c,CL_application_no__c,Gross_Invoice_Value__c,Net_Premium__c from Invoice_Line__c where Invoice__r.Id =: Invoice_Id ORDER BY Id ];
        Invoice_Total_List = [Select SUM(Net_Premium__c) Premium from Invoice_Line__c where Invoice__r.Id =: Invoice_Id];

        for (AggregateResult var : Invoice_Total_List) {
            Invoice_Total = (Decimal)var.get('Premium');
        }

        if (Policy_Type.equals('OMBP')) {
            Payment_Date_top = '1st August 2021';
            Payment_Date_bottom = ' 1/8/2021';
            Customer_Number = '312868/70';
            Receipt_No = 'R220800001';
            Company_Name = 'ABC Ltd';
            Title = 'Premium for Online Micro-Business Policy (OMBP)';
        } else if (Policy_Type.equals('SBP')) {
            Payment_Date_top = '12th August 2021';
            Payment_Date_bottom = '12/8/2021';
            Customer_Number = '312868/70';
            Receipt_No = 'R220800015';
            Company_Name = 'ABC Ltd';
            Title = 'Premium for Online Small Business Policy (OSBP)';
        } else if (Policy_Type.equals('SUP')) {
            Payment_Date_top = '19th June 2021';
            Payment_Date_bottom = '19/6/2021';
            Customer_Number = '312868/70';
            Receipt_No = 'R220600021';
            Company_Name = 'ABC Ltd';
            Title = 'Premium for Self-Underwritten Policy (SUP)';
        }
        
        
    }
}