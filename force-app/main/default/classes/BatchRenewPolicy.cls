global with sharing class BatchRenewPolicy implements Database.Batchable<SObject>,Database.Stateful,Database.AllowsCallouts {
    public String executeQuery;
    public BatchRenewPolicy() {
        System.debug('BatchRenewPolicy constructor');
        String todayDate = String.valueOf(Date.valueOf(system.now())); 
        System.debug('todayDate=='+todayDate);
        String success='Success';
        executeQuery='select id from Policy__c where '+
        ' Legacy_Customer_Number__c !=null and '+
        ' Expiry_Date__c!=null and  Expiry_Date__c=TODAY and Renewal_Settings__c = \'Automatic Renewal\' '  ;
    }
    public Database.QueryLocator start(Database.BatchableContext bc){
        System.debug('BatchRenewPolicy start executeQuery : '+executeQuery);
        return Database.getQueryLocator(executeQuery);
    }
    public void execute(Database.BatchableContext bc, List<sObject> scope){
        System.debug('BatchRenewPolicy execute');
        List<Id> policyIdList = new List<Id>();
        for (sObject s:scope) {
            Policy__c pol=(Policy__c)s;
            policyIdList.add(pol.id);
        }
        RenewPolicy.renewPolicyAutomatically(policyIdList);
    }
    public void finish(Database.BatchableContext bc){
        System.debug('BatchRenewPolicy finished');
    }
}