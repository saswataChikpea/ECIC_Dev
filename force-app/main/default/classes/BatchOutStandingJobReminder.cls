public with sharing class BatchOutStandingJobReminder implements Database.Batchable<SObject>,Database.Stateful {
    public String executeQuery;
    public BatchOutStandingJobReminder() {
        System.debug('BatchOutStandingJobReminder construtor');
        executeQuery='select id,CreatedDate from Task where  Is_Today_is_4th_Day_of_Task__c=true and X3rd_Day_Email_Reminder_Sent__c=false';
    }
    public Database.QueryLocator start(Database.BatchableContext bc){
        System.debug('BatchOutStandingJobReminder start');
        return Database.getQueryLocator(executeQuery);
    }
    public void execute(Database.BatchableContext bc, List<sObject> scope){
        System.debug('BatchOutStandingJobReminder execute');
        /*List<Policy__c> policyList = new List<Policy__c>();
        List<ID> policyIDList = new List<ID>();
        for (sObject s:scope) {
            Policy__c pol=(Policy__c)s;
            policyIDList.add(pol.id);
            System.debug('pol :'+pol);
            
        }
        System.debug('policyIDList : '+policyIDList);
        if(policyIDList != null && policyIDList.size()>0){
            CreateSBPInvoice.createInvoiceForSBP(policyIDList);
        }*/
        OutStandingJobReminder.sendEmailToSme();
    }
    public void finish(Database.BatchableContext bc){
        System.debug('BatchOutStandingJobReminder finished');
    }
   

}