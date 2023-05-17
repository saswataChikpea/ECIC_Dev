/**
 *  Condition To find a dormant policyholder
    1. Need to make a query on  the credit limit application and check the Application date range not in last 30 days? 
    AND
    2. Need to query on credit limit and check if he has no valid credit limits over the past 30 days.
    If find then create a task for sme team staff
*/
global with sharing class BatchFindDormantPH implements Database.Batchable<sObject>, Database.Stateful {
    global String creditLimeAppQuery;
    global boolean isCreditLimitChecking;
    global boolean isCreditLimitAppChecking;

    global BatchFindDormantPH(String credit_limit){
        isCreditLimitChecking  = false;
        isCreditLimitAppChecking = false;
        creditLimeAppQuery='SELECT id, Policy__c' +
        ' FROM Credit_Limit_Application__c  ' +
        ' Where Application_Date__c <= LAST_N_DAYS:30';
        isCreditLimitAppChecking = true;
    }
    global BatchFindDormantPH(){
        isCreditLimitChecking  = false;
        isCreditLimitAppChecking = false;
        creditLimeAppQuery='select id,Policy__c from Credit_Limit__c where CL_Status__c=\'Valid\' and CL_Effective_Date__c <= LAST_N_DAYS:30 ';
        isCreditLimitChecking = true;
    }
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(creditLimeAppQuery);
    }
    public void execute(Database.BatchableContext bc, List<sObject> scope){
        List<Task> taskList = new List<Task>();
        System.debug('BatchFindDormantPH isCreditLimitAppChecking:'+isCreditLimitAppChecking+' isCreditLimitChecking:'+isCreditLimitChecking);
        if(isCreditLimitAppChecking){
            for (sObject scla : scope) {
                System.debug('scla :'+scla);
                Credit_Limit_Application__c cla = (Credit_Limit_Application__c) scla;
                Task ttObj = new Task();
                ttObj.WhatId = cla.Policy__c;
                ttObj.Subject = 'Terminate Dormant Policy';
                ttObj.Description = 'Credit Limit Application does not exist in last 30 days';
                ttObj.Status = 'Open';
                taskList.add(ttObj);
    
            }
        }else if(isCreditLimitChecking){
            for (sObject scl : scope) {
                System.debug('scl :'+scl);
                Credit_Limit__c cl = (Credit_Limit__c) scl;
                Task ttObj = new Task();
                ttObj.Subject = 'Terminate Dormant Policy';
                ttObj.Description = 'Credit Limit with status vaid does not exist in last 30 days';
                ttObj.Status = 'Open';
                ttObj.WhatId = cl.Policy__c;
                taskList.add(ttObj);
            }
        }
       
        try {
            if(taskList != null && !taskList.isEmpty()){
                insert taskList;
                System.debug('Found dormant policy!!!');
            }
        } catch (Exception e) {
            System.debug('Exception at BatchFindDormantPH execute : '+e.getMessage()+' Stack :'+e.getStackTraceString());
        }
    }
    public void finish(Database.BatchableContext bc){
        
        System.debug('BatchFindDormantPH finished');
    }
    
}