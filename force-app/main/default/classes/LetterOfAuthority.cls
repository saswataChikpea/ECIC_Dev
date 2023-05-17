public with sharing class LetterOfAuthority {

    @AuraEnabled
    public static List<LA_Financier__c> fetchAllLA(Id usrId){
        System.debug('fetchAllLA usrId : '+usrId);
        List<LA_Financier__c> laList = new List<LA_Financier__c>();
        try {
            Account accObj = PolicyManagement.getPolicyHolderData(usrId);
            if(accObj.Current_Policy__c != null){
                laList = [select id,name,Issue_Date__c,Status__c from LA_Financier__c where Policy__c =:accObj.Current_Policy__c order by name desc ];

            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        System.debug('laList : '+laList);
        return laList;
       
    }
    @AuraEnabled
    public static Boolean createLAFinancer(Id policyID,
                                            String policyHolderName,
                                            String typeOfLA,
                                            String effectiveDate,
                                            String bankName,
                                            String bankAddress){
        System.debug('policyHolderName : '+policyHolderName+'\ntypeOfLA :'+typeOfLA+' \neefectiveDate : '+effectiveDate+' \nBankName : '+bankName+' \n Address:'+bankAddress);
        Boolean isLAFinancerCreated;
        try {
            LA_Financier__c laFinanceObj = new LA_Financier__c();
            laFinanceObj.Policy__c = policyID;
            laFinanceObj.Policy_Holder_Name__c = policyHolderName;
            laFinanceObj.Type__c = typeOfLA;
            laFinanceObj.Bank_Name__c = bankName;
            laFinanceObj.Bank_Address__c = bankAddress;
            laFinanceObj.Status__c = 'Inactive';
            insert laFinanceObj;
            isLAFinancerCreated = true;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return isLAFinancerCreated;
    }
}