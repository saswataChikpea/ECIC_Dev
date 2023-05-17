public with sharing class BatchHandleOutstandingApplication implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {
  public String executeQuery;
  public BatchHandleOutstandingApplication() {
    System.debug('BatchHandleOutstandingApplication construtor');
    executeQuery =
      'Select id, name, Account__c, Product__c,Product__r.Name, ' +
      'Policy_Commence_Date__c, CUS_NO__c, Policy_Type__c, Master_Proposal__c ' +
      'Under_Processing_Notification_Sent__c, Policy_Application_SME_Reminder_Sent__c,  from Proposal__c where Status__c=\'Processing\' ';
  }

  public Database.QueryLocator start(Database.BatchableContext bc) {
    System.debug('BatchHandleOutstandingApplication start\n' + executeQuery);
    return Database.getQueryLocator(executeQuery);
  }
  public void execute(Database.BatchableContext bc, List<sObject> scope) {
    System.debug('BatchHandleOutstandingApplication execute');
    List<Proposal__c> propList = new List<Proposal__c>();
    for (sObject s : scope) {
      Proposal__c quote = (Proposal__c) s;
      propList.add(quote);
    }
    System.debug('propList : ' + propList);
    if (propList != null && propList.size() > 0) {
      BatchHandleOutstandingApplicationHandler.handleOutstandingProposal(
        propList
      );
    }
  }
  public void finish(Database.BatchableContext bc) {
    System.debug('BatchHandleOutstandingApplication finished');
  }
}