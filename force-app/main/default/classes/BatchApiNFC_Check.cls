public with sharing class BatchApiNFC_Check implements Database.Batchable<SObject>,Database.Stateful {
    public String executeQuery;
    public BatchApiNFC_Check() {
        System.debug('BatchApiNFC_Check constructor');
        String success='Success';
        executeQuery='select id,name from Account where Legacy_Customer_Number__c !=null and  ((Send_Request_For_NFC__c=true and NFC_Check__c= \'' + success + '\') or NFC_Check__c !=\'' + success + '\')';
    }
    public Database.QueryLocator start(Database.BatchableContext bc){
        System.debug('BatchApiNFC_Check start');
        return Database.getQueryLocator(executeQuery);
    }
    public void execute(Database.BatchableContext bc, List<sObject> scope){
        System.debug('BatchApiNFC_Check execute');
        List<ID> accList = new List<ID>();
        for (sObject s:scope) {
            Account acc=(Account)s;
            accList.add(acc.id);
        }
        System.debug('accList :'+accList);
        ApiNFC.getNFCResults(accList);
    }
    public void finish(Database.BatchableContext bc){
        System.debug('BatchApiNFC_Check finished');
    }
}