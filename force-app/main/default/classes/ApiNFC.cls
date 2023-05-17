public with sharing class ApiNFC {
    @InvocableMethod(label='Search NFC result' description='')
    public static void getNFCResults(List<ID> ids){
        Policy__c pol=[select Is_NFC_Clean__c from Policy__c where id = :ids];
        if(!pol.Is_NFC_Clean__c){
            pol.Is_NFC_Clean__c=true;
        }
        update pol;
        System.debug('Policy NFC Clear Updated Succesfully.');
    }

    public static void nfcResultsChecking(List<id> accIdList){
        for(String accId : accIdList){
            SME_ConsoleHandler.sendRequestForNfcResults(accId);
        }
    }
}