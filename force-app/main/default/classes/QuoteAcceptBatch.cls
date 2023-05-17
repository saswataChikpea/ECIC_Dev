public with sharing class QuoteAcceptBatch {
    
    public String executeQuery;
    public QuoteAcceptBatch() {
        System.debug('QuoteAcceptBatch construtor');
        executeQuery='select id, Account__c, Name, Issue_Date__c, status__c from Quote__c where Issue_Date__c != null and status__c = \'Pending for acceptance\'';
    }

    
    public Database.QueryLocator start(Database.BatchableContext bc){
        System.debug('QuoteAcceptBatch start');
        return Database.getQueryLocator(executeQuery);
    }
    public void execute(Database.BatchableContext bc, List<sObject> scope){
        System.debug('QuoteAcceptBatch execute');
        List<Quote__c> QtList = new List<Quote__c>();
        List<ID> qtIDList = new List<ID>();
        for (sObject s:scope) {
            Quote__c qt=(Quote__c)s;
            qtIDList.add(qt.id);
            System.debug('qt :'+qt);
            QtList.add(qt);
        }
        System.debug('qtIDList : '+qtIDList);
        if(qtIDList != null && qtIDList.size()>0)
        {
            list<ECIC_Settings__c> Settings = [select id, Name, Quotation_Acceptance_Period__c, Quotation_Acceptance_Reminder__c from ECIC_Settings__c limit 1];
            list<Quote__c> qtListUpdate = new list<Quote__c>();
            for(Quote__c qt1 : QtList)
            {
                Integer days = qt1.Issue_Date__c.daysBetween(date.today());
                System.debug('===========Days Remain======'+qt1.Name+'==='+days);                

                if(Settings != null && Settings[0].Quotation_Acceptance_Period__c >= days)
                {
                    if(days == Settings[0].Quotation_Acceptance_Reminder__c)
                    {
                        System.debug('===========Inside Reminder Email ======');
                        SendEmailApex.sendEmailFuture(qt1.Account__c, qt1.id, 'Proposal_Reminder_Email', false, null, null);

                    }else if(days == Settings[0].Quotation_Acceptance_Period__c)                    
                    {
                        System.debug('===========Inside Void Status ======');
                        qt1.status__c = 'Void';
                        qtListUpdate.add(qt1);
                    }
                }
            } 
            if(qtListUpdate !=null && qtListUpdate.size()>0)
            {
                System.debug('===========Quote Void Status updated======'+qtListUpdate);
                update qtListUpdate;
            }           
        }
        
    }
    public void finish(Database.BatchableContext bc){
        System.debug('QuoteAcceptBatch finished');
    }

    
}