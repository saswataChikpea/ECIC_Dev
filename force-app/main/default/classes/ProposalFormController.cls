public with sharing class ProposalFormController {
    public string customerName {get;set;}
    public string customerAddress1 {get;set;}
    public string customerAddress2 {get;set;}
    public string customerAddress3 {get;set;}
    public string customerAddressDistrict {get;set;}
    public string customerAddressTerritory {get;set;}
    public string customerNumber {get;set;}
    public string buisnessRegNumber {get;set;}
    public string aoPos {get;set;}
    public string policyType {get;set;}
    public Integer commenceMonth {get;set;}
    public Integer commenceYear {get;set;}
    public string numberOfCreditBuyers {get;set;}
    public string buyersName {get;set;}
    public string productName {get;set;}
    public string proposalId {get;set;}
    public date receivedDate {get;set;}
    
    // ------------------------------------
    public decimal DOM_LAST_TY_TOT_TO {get;set;}
    public decimal DOM_NEXT_TY_LC_TO {get;set;}
    public decimal DOM_NEXT_TY_OA_TO {get;set;}
    public decimal DUE_BD_LAST_2_YR {get;set;}
    
    public ProposalFormController() {
        try {
            proposalId = ApexPages.currentPage().getParameters().get('proposalId');
            for (Proposal__c var : [Select Id,Name,Insurable_Buyers__c,Bad_Debt_Amount__c,Policy_Commence_Date__c,Receive_Date__c,CUS_NO__c,BR_Number__c,Registered_Address_Line_1__c,Registered_Address_Line_2__c,Registered_Address_Line_3__c,Company_Name__c,Product__r.Name,Registered_District__c,Registered_Territory__c from Proposal__c where Id =: proposalId ]) {
            customerName = var.Company_Name__c;
            customerAddress1 = var.Registered_Address_Line_1__c;
            customerAddress2 = var.Registered_Address_Line_2__c; 
            customerAddress3 = var.Registered_Address_Line_3__c; 
            customerNumber = var.CUS_NO__c; 
            buisnessRegNumber = var.BR_Number__c;
            policyType = var.Product__r.Name;
            commenceMonth = var.Policy_Commence_Date__c.Month(); 
            commenceYear = var.Policy_Commence_Date__c.Year();
            numberOfCreditBuyers = var.Insurable_Buyers__c;
            receivedDate = var.Receive_Date__c;
            customerAddressDistrict = var.Registered_District__c;
            customerAddressTerritory = var.Registered_Territory__c;
            DUE_BD_LAST_2_YR = var.Bad_Debt_Amount__c;
        }
            System.debug('customerName::'+customerName);
            System.debug('customerAddress1::'+customerAddress1);
            System.debug('customerAddress2::'+customerAddress2);
            System.debug('customerAddress3::'+customerAddress3);
            System.debug('customerNumber::'+customerNumber);
            System.debug('buisnessRegNumber::'+buisnessRegNumber);
            System.debug('policyType::'+policyType);
            System.debug('commenceMonth::'+commenceMonth);
            System.debug('commenceYear::'+commenceYear);
            System.debug('numberOfCreditBuyers::'+numberOfCreditBuyers);
            System.debug('receivedDate::'+receivedDate);
            System.debug('customerAddressDistrict::'+customerAddressDistrict);
            System.debug('customerAddressTerritory::'+customerAddressTerritory);
            if (policyType == 'SBP') {
                productName = 'SBP';
            } if (policyType == 'SUP') {
                productName = 'SUP';
            } if (policyType == 'OMBP') {
                productName = 'OMBP';
            }

        } catch (Exception e) {
            System.debug('Error: '+e.getMessage());
        }       
}
}