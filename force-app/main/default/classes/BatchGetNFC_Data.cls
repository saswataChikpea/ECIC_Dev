public with sharing class BatchGetNFC_Data {

    public String executeQuery;
    public BatchGetNFC_Data() {
        System.debug('BatchGetNFC_Data construtor');
        executeQuery='select id,Is_Problem_Policy_Holder__c,Get_NFC_Data__c from Account where  Get_NFC_Data__c=true';
    }
    public Database.QueryLocator start(Database.BatchableContext bc){
        System.debug('BatchGetNFC_Data start');
        return Database.getQueryLocator(executeQuery);
    }
    public void execute(Database.BatchableContext bc, List<sObject> scope){
        System.debug('BatchGetNFC_Data execute');
        List<Account> accList = new List<Account>();
        List<ID> accIDList = new List<ID>();
        for (sObject s:scope) {
            Account acc=(Account)s;
            accIDList.add(acc.id);
            System.debug('acc :'+acc);
            
        }
        System.debug('accIDList : '+accIDList);
        if(accIDList != null && accIDList.size()>0){
            //SME_ConsoleHandler.createInvoiceForSBP(policyIDList);
        }
        
    }
    public void finish(Database.BatchableContext bc){
        System.debug('BatchGetNFC_Data finished');
    }
}