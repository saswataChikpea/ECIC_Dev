global with sharing class BatchExpireCL implements Database.Batchable<sObject>, Database.Stateful {
    global String query_str;
    global Date today;
    global BatchExpireCL() {
        today = Date.today();
        query_str = 'select Id,Name,Expiry_Date__c,CL_Amount__c,Exporter__c,CL_Status__c,Policy__c,policy__r.Product__r.Name from Credit_Limit__c where Expiry_Date__c=:today';
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        try{
            System.debug('query_str='+query_str);
        }catch(Exception e){
            System.debug('Exception='+e.getMessage());
        }
        
        return Database.getQueryLocator(query_str);
    }
    global void execute(Database.BatchableContext bc, List<sObject> scope){
        System.debug('credit limit record='+scope);
        List<Credit_Limit__c> cl_list = new List<Credit_Limit__c>();
        for (sObject s : scope) {
            Credit_Limit__c cl=(Credit_Limit__c)s;
            System.debug('cl--'+cl.id);
            System.debug('policy type='+cl.policy__r.Product__r.Name);
            cl.CL_Status__c = 'Invalid';
            cl_list.add(cl);
		}
        try{
            if(cl_list.size()>0) {
                update cl_list;
                for (Credit_Limit__c each_cl:cl_list) {
                    if (each_cl.policy__r.Product__r.Name == 'SBP')
                        CLApiHandler.CalculateMLSBP(each_cl.Policy__c, each_cl.Exporter__c);
                    else if (each_cl.policy__r.Product__r.Name == 'OMBP')
                        CLApiHandler.CalculateML(each_cl.Policy__c,each_cl.CL_Amount__c,each_cl.Approve_Date__c,each_cl.Exporter__c);
                }
            }
        }catch(Exception e) {
            ExceptionLogger.log(e, 'BatchExpireCL');
            System.debug('Exception='+e.getMessage()+' Stack :'+e.getStackTraceString());
        }
        
    }
    global void finish(Database.BatchableContext bc) {
        System.debug('BatchExpireCL finished');
    }
}