/**
 *  check maximum liability has changed from HK$0 to a non-zero amount
    then record the credit limit issue date, which will be used as the anniversary 
    date for resetting the maximum liability
*/
public with sharing class BatchResetMaximumLiability implements Database.Batchable<sObject>, Database.Stateful {
    public Integer recordsProcessed = 0;
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(
            ' SELECT id, name,Maximum_Liability__c,ML_Changed_to_Non_Zero_Date__c  ' +
            ' FROM Policy_Schedule__c  ' +
            ' Where Type__c=\'Schedule 1\' and Policy__r.Status__c = \'Valid\' and ML_Changed_to_Non_Zero_Date__c != null '
        );
    }
    public void execute(Database.BatchableContext bc, List<Policy_Schedule__c> scope){
        List<Policy_Schedule__c> policyList = new List<Policy_Schedule__c>();
        for (Policy_Schedule__c pol : scope) {
            System.debug('pol :'+pol);
            DateTime dT = pol.ML_Changed_to_Non_Zero_Date__c;
            Date nonZeroAmtdate = date.newinstance(dT.year(), dT.month(), dT.day());
            Integer noOfDays = nonZeroAmtdate.daysBetween( Date.today() );
            system.debug( 'Output is ' + noOfDays );
            if(noOfDays == 365){
                policyList.add(pol);
            }
        }
        System.debug('policyList : '+policyList);
        List<Policy_Schedule__c> updatePolicyList = new List<Policy_Schedule__c>();
        if(policyList != null && !policyList.isEmpty()){
            for (Policy_Schedule__c pol : policyList) {
                pol.Maximum_Liability__c = 0;
                updatePolicyList.add(pol);
            }
        }
        try {
            if(updatePolicyList != null && !updatePolicyList.isEmpty()){
                update updatePolicyList;
                System.debug('Policy Reset To Zero');
            }
        } catch (Exception e) {
            System.debug('Exception at BatchResetMaximumLiability execute : '+e.getMessage()+' Stack :'+e.getStackTraceString());
        }
    }
    public void finish(Database.BatchableContext bc){
        //Send mail to those PH whose ML revised to zero.
    }
    
}