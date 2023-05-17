public with sharing class BatchCreateQuotation implements Database.Batchable<SObject>,Database.Stateful,Database.AllowsCallouts {
    public String executeQuery;
    public BatchCreateQuotation() {
        System.debug('BatchCreateQuotation construtor');
        executeQuery='Select Id, Name, Policy_Type__c, CUS_NO__c,  Status__c, Is_Legacy_Verified__c, NFC_Status__c, AML_Case__c,'+
        'Product__r.Name, (select Id, Name, Status__c from Buyers_Vetted__r)'+
         'from Proposal__c where Status__c =\'Processing\' AND Is_Legacy_Verified__c = true AND NFC_Status__c =\'Clean\'' +
        'AND AML_Case__c =\'Approved\' AND NAR_1_Case__c = \'Approved\'';
    }
  
    public Database.QueryLocator start(Database.BatchableContext bc){
        System.debug('BatchCreateQuotation start');
        return Database.getQueryLocator(executeQuery);
    }
    public void execute(Database.BatchableContext bc, List<sObject> scope){
        System.debug('BatchCreateQuotation execute');
        // List<Account> accList = new List<Account>();    
        List<Proposal__c> propList = new List<Proposal__c>();
        for (sObject s:scope) {
            Proposal__c prop=(Proposal__c)s;
            // if (acc?.Proposals__r.size() == 0) {
                // }
            propList.add(prop);

            // System.debug('prop :'+acc);
            
        }
        System.debug('propList : '+propList);
        if(propList != null && propList.size()>0){
            //SME_ConsoleHandler.createInvoiceForSBP(policyIDList);
           BatchCreateQuotationHandler.handleQuoteCreation(propList);
            // ExceptionLogger.auraLog(emailMsg, 'BatchCreateQuotation');
            // ExceptionLogger.auraEmail(emailMsg);
        }
        // else {
        //     ExceptionLogger.auraLog('BatchCreateQuotation has run successfully.', 'BatchCreateQuotation');
        //     System.debug('BatchCreateQuotation:: no error found');
        // }
        
    }
    public void finish(Database.BatchableContext bc){
        System.debug('BatchCreateQuotation finished:: calling BatchCreateQuotationAPI');
        // Id batchJobId = Database.executeBatch(new BatchCreateQuotationAPI(), 1);
        // System.debug('batchJobId'+batchJobId);
        BatchCreateQuotationHandler.handleQuoteCreationAPI();
    }
}