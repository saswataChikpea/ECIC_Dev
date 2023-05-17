public with sharing class BatchBR_Reminder implements Database.Batchable<SObject>,Database.Stateful {
    public String executeQuery;
    public BatchBR_Reminder() {
        System.debug('BatchBR_Reminder construtor');
        String status='Invalid';
        executeQuery='select id,CreatedDate,Status__c,Account__c,Product__c,  '+
        ' First_Rejection_Mail_Sent__c,First_Rejection_Mail_Sent_Date__c,'+
        ' First_Reminder_Email_Sent__c,First_Reminder_Email_Sent_Date__c,'+
        ' Second_Reminder_Email_Sent__c,Second_Reminder_Email_Sent_Date__c, '+
        ' Is_Email_Sent_At_30th_Day__c,Email_Sent_At_30th_Day_Date__c, '+
        ' First_14th_Day_Reminder__c,First_14th_Day_Reminder_Date__c, '+
        ' Second_Reminder_Email_Sent__c,Second_Reminder_Email_Sent_Date__c '+
        ' from ECIC_Document__c where  Status__c='+status+' and First_Rejection_Mail_Sent__c=true';
        System.debug('executeQuery===>>'+executeQuery);
    }
    public Database.QueryLocator start(Database.BatchableContext bc){
        System.debug('BatchBR_Reminder start');
        return Database.getQueryLocator(executeQuery);
    }
    public void execute(Database.BatchableContext bc, List<sObject> scope){
        System.debug('BatchBR_Reminder execute');
        List<ECIC_Document__c> ecicDocList = new List<ECIC_Document__c>();
        for (sObject s:scope) {
            ECIC_Document__c doc=(ECIC_Document__c)s;
            ecicDocList.add(doc);
        }
        System.debug('ecicDocList : '+ecicDocList);
        if(ecicDocList != null && ecicDocList.size()>0){
            BR_Reminder.sendBrReminderAtSpecificInterval(ecicDocList);
        }
    }
    public void finish(Database.BatchableContext bc){
        System.debug('BatchBR_Reminder finished');
    }
}