global with sharing class BatchSetPaymentReminder implements Database.Batchable<sObject>, Database.Stateful {
    global String fetchPaymentReminderRecords;
    global BatchSetPaymentReminder() {
        fetchPaymentReminderRecords = 'select Sent_Payment_Reminder_Today__c,Payment_Reminder_Date__c,Status__c from Invoice__c where Sent_Payment_Reminder_Today__c=true and Status__c != \'Paid\' and Status__c !=\'Cancelled\'  ';
        System.debug('BatchSetPaymentReminder constructor Query fetchPaymentReminderRecords : '+fetchPaymentReminderRecords);
    }
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(fetchPaymentReminderRecords);
    }
    public void execute(Database.BatchableContext bc, List<sObject> scope){
        List<Invoice__c> updateInvList = new List<Invoice__c>();
        for (sObject s : scope) {
            //Invoice__c invObj = new Invoice__c();
            Invoice__c inv=(Invoice__c)s;
            DateTime dT = System.now().addDays(14);
            inv.Payment_Reminder_Date__c = Date.newInstance(dT.year(), dT.month(), dT.day());
            updateInvList.add(inv);
        }
        
        try {
            if(updateInvList !=null && !updateInvList.isEmpty()){
                update updateInvList;
                System.debug('Invoice payment reminder updated successfully!!!');
            }
        } catch (Exception e) {
            System.debug('Exception at BatchSetPaymentReminder execute : '+e.getMessage()+' Stack :'+e.getStackTraceString());
        }
    }
    public void finish(Database.BatchableContext bc){
        
        System.debug('BatchSetPaymentReminder finished');
    }
}