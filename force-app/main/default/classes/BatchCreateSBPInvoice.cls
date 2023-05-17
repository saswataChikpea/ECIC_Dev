global with sharing class BatchCreateSBPInvoice implements Database.Batchable<sObject>, Database.Stateful {
    global String executeQuery;

    global BatchCreateSBPInvoice(){
        executeQuery='select id,name,Exporter__c from Policy__c where Is_Active__c = true ';
    }
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(executeQuery);
    }
    public void execute(Database.BatchableContext bc, List<sObject> scope){
        List<Policy__c> policyList = new List<Policy__c>();
        List<ID> policyIDList = new List<ID>();
        for (sObject s:scope) {
            Policy__c pol=(Policy__c)s;
            policyIDList.add(pol.id);
            System.debug('pol :'+pol);
            
        }
        System.debug('policyIDList : '+policyIDList);
        if(policyIDList != null && policyIDList.size()>0){
            CreateSBPInvoice.createInvoiceForSBP(policyIDList);
        }
    }
    public void finish(Database.BatchableContext bc){
        
        System.debug('BatchCreateSBPInvoice finished');
    }
   
}