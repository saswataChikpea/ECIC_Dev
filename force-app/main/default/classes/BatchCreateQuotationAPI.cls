public with sharing class BatchCreateQuotationAPI implements Database.Batchable<SObject>,Database.Stateful,Database.AllowsCallouts {
    public String executeQuery;
    public BatchCreateQuotationAPI() {
        System.debug('BatchCreateQuotationAPI construtor');
        executeQuery='Select id, name, Issue_Date__c, Expiry_Date__c, Account__c, Product__c,Product__r.Name, '+ 
       'Proposal__r.Policy_Commence_Date__c, Proposal__r.CUS_NO__c, Proposal__r.Policy_Type__c, Proposal__r.Master_Proposal__c '+
       'from Quote__c where Status__c=\'In Progress\'';
    }
  
    public Database.QueryLocator start(Database.BatchableContext bc){
        System.debug('BatchCreateQuotationAPI start\n'+executeQuery);
        return Database.getQueryLocator(executeQuery);
    }
    public void execute(Database.BatchableContext bc, List<sObject> scope){
        System.debug('BatchCreateQuotationAPI execute');
        List<Quote__c> quoteList = new List<Quote__c>();
        for (sObject s:scope) {
            Quote__c quote=(Quote__c)s;
            quoteList.add(quote);         
        }
        System.debug('quoteList : '+quoteList);
        if(quoteList != null && quoteList.size()>0){
           BatchCreateQuotationHandler.handleQuoteCreationAPI();
        }        
    }
    public void finish(Database.BatchableContext bc){
        System.debug('BatchCreateQuotationAPI finished');
    }
}