global with sharing class BatchInitiateSigningOfTheDocument  implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts {
    global String executeQuery;
    global BatchInitiateSigningOfTheDocument() {
        executeQuery = 'select id,name,Policy__c,Policy__r.name,Type__c,Is_Schedule_Signed__c from Policy_Schedule__c where Is_Schedule_Signed__c = false and Is_Ready_For_Signing__c=false  ';
    }
    public Database.QueryLocator start(Database.BatchableContext bc){
        System.debug('BatchInitiateSigningOfTheDocument start');
        return Database.getQueryLocator(executeQuery);
    }
    public void execute(Database.BatchableContext bc, List<sObject> scope){
        System.debug('BatchInitiateSigningOfTheDocument execute');
        List<Policy_Schedule__c> polSchList = new List<Policy_Schedule__c>();
        for (sObject s:scope) {
            Policy_Schedule__c pschedule=(Policy_Schedule__c)s;
            polSchList.add(pschedule);
        }
        System.debug('polSchList ====>>'+polSchList);
        if(polSchList!= null && !polSchList.isEmpty()){
            //update polSchList;
            CreateAttachmentToPolicy.linkDocToParentByBatch(polSchList);
            System.debug('Polict Document is ready for signing!!');
        }
    }
    public void finish(Database.BatchableContext bc){
        System.debug('BatchInitiateSigningOfTheDocument finished');
        BatchForSigningTheDocument BFSTD = new BatchForSigningTheDocument();
        Database.executeBatch(BFSTD,1);
    }
}