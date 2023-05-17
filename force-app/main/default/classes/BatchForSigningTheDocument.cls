global with sharing class BatchForSigningTheDocument implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts {
    global String executeQuery;
    public BatchForSigningTheDocument() {
        executeQuery = 'select id,name,Last_Signed_Date__c,Type__c,Policy__c,Policy__r.name,Is_Schedule_Signed__c from Policy_Schedule__c where Is_Schedule_Signed__c = false and Is_Ready_For_Signing__c=true ';
    }
    public Database.QueryLocator start(Database.BatchableContext bc){
        System.debug('BatchForSigningTheDocument start');
        return Database.getQueryLocator(executeQuery);
    }
    public void execute(Database.BatchableContext bc, List<sObject> scope){
        System.debug('BatchForSigningTheDocument execute');
        List<String> docNameList = new List<string>();
        Map<String,String> schIdvsdocNameMap = new Map<String,String>(); 
        for (sObject s:scope) {
            String docName;
            Policy_Schedule__c pschedule=(Policy_Schedule__c)s;
            System.debug('Start Signing '+pschedule.Type__c);
            if(pschedule.Type__c.equals('Schedule 1')){
                
                docName=pschedule.Policy__r.name+'_Schedule1';
                schIdvsdocNameMap.put(pschedule.id,pschedule.Policy__r.name+'_Schedule1');
            }else if(pschedule.Type__c.equals('Schedule 2')){
               
                docName=pschedule.Policy__r.name+'_Schedule2';
                schIdvsdocNameMap.put(pschedule.id,pschedule.Policy__r.name+'_Schedule2');
            }else if(pschedule.Type__c.equals('Schedule 3')){
                
                docName=pschedule.Policy__r.name+'_Schedule3';
                schIdvsdocNameMap.put(pschedule.id,pschedule.Policy__r.name+'_Schedule3');
            }else if(pschedule.Type__c.equals('Schedule 4')){
               
                docName=pschedule.Policy__r.name+'_Schedule4';
                schIdvsdocNameMap.put(pschedule.id,pschedule.Policy__r.name+'_Schedule4');
            }else if(pschedule.Type__c.equals('Policy Cover')){
               
                docName=pschedule.Policy__r.name+'_Cover';
                schIdvsdocNameMap.put(pschedule.id,pschedule.Policy__r.name+'_Cover');
            }else if(pschedule.Type__c.equals('Policy Document')){
                
                docName=pschedule.Policy__r.name+'_Document';
                schIdvsdocNameMap.put(pschedule.id,pschedule.Policy__r.name+'_Document');
            }
            docNameList.add(docName);
        }
        System.debug('schIdvsdocNameMap ===>>'+schIdvsdocNameMap);
        if(schIdvsdocNameMap!=null && !schIdvsdocNameMap.isEmpty()){
            for(String key : schIdvsdocNameMap.keySet()){
                System.debug('Called For :'+key+' '+schIdvsdocNameMap.get(key));
                CreateAttachmentToPolicy.submitDocForSign(key,schIdvsdocNameMap.get(key));//s
            }
            //CreateAttachmentToPolicy.submitDocForSign('PL-000000044_Schedule_3');
        }
    }
    public void finish(Database.BatchableContext bc){
        System.debug('BatchForSigningTheDocument finished');
    }
}