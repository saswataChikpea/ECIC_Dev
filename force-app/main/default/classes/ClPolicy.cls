public  with sharing class ClPolicy {
    @AuraEnabled
    public static Policy__c getPolicyDetails(Id acc_id) {
        // Id acc_id = [Select contact.AccountId from user where id=:user_id];
        try{
            System.debug('acc_id='+acc_id);
            return [Select Id,Name,Available_Credit_Check__c,Commencement_Date__c,
            Exporter__r.Name,Exporter__r.Limited_Access__c,Free_Credit_Check__c,Is_Active__c,Issue_Date__c,Paid_Credit_Check__c, Policy_Renewal_Date__c,
            Policyholder_s_Address__c,Product__r.Name,Status__c,Used_Credit_check__c,Legacy_Policy_Type__c,Legacy_Customer_Number__c,
            (Select Effective_Date__c,Expiry_Date__c,Issue_Date__c from Policy_Schedules__r)
            from Policy__c where Exporter__c = :acc_id and Is_Active__c=true];
            // return [Select Available_Credit_Check__c
            // from Policy__c where Exporter__c = :acc_id];
        } catch (Exception e) {
            System.debug('Exception='+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static Id getPolicyHolder(Id user_id) {
        System.debug('getPolicyHolder');
        Id accountId = [Select contact.AccountId from user where id =:user_id].contact.AccountId;
        return accountId;

    }
   
   
}