public with sharing class CLProductDetails {
    @AuraEnabled(cacheable=true)    
    public static Plan__c getProductDetails(String prd_name) {
        List<Plan__c> products = [Select Base_Amount__c,CL_Amount_Step__c,Cost_of_Extra_Credit_Check__c,Default_Payment_Term_Days__c,Default_Payment_Term_Type__c,Description__c,Discretionary_Credit_Limits__c,Display_Sequence__c,Endorsements__c,Extra_Credit_Check__c,Full_Name__c,Invoiceing__c,Letter_of_Authority__c,Max_Authorised_Person_Count__c,Max_Beneficiary_Count__c,Max_Director_Count__c,Maximum_Credit_Limit_Amount__c,Maximum_Liability__c,Maximum_Tenor__c,Minimum_Credit_Limit_Amount__c,Number_of_Free_Credit_Check__c,Name,Policy_Deposit__c,Policy_Fee__c,Premium_Rate__c,Range_of_Acceptance_Rates__c,Range_of_Credit_Limit_Amounts__c,Range_of_Maximum_Liability__c,Validity_Period_of_Credit_Limits__c from Plan__c where Name=:prd_name and Active__c=true];
        if(products!=null && products.size()>0)
        return products[0];
        else 
            return null;
    }
    public CLProductDetails() {

    }
}