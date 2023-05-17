public with sharing class TaskTriggerHandler {
    public static void handleTask(List<Task> taskList,Map<Id, Task> oldValuesMap) {
        try {
            List<ID> recordIdList = new List<ID>();
            List<Policy__c> updatePolList = new List<Policy__c>();
            List<Id> polIdList = new List<Id>();
            String taskType='';
            for(Task tt : taskList){
                Task ttOld = oldValuesMap.get(tt.Id);
                System.debug('New task :'+tt+' Old task:'+ttOld);
                if(ttOld.Status!=null && !ttOld.Status.equals('Completed') && tt.Status.equals('Completed') && tt.Type!=null ){
                    taskType = tt.Type;
                    if(tt.Type.equals('Review Un Clean NFC Results For Policy Renewal')){
                        polIdList.add(tt.WhatId);
                    }else if(tt.Type.equals('AML Checking For Policy Renewal')){
                        polIdList.add(tt.WhatId);
                    }else if(tt.Type.equals('BR Check')){
                        recordIdList.add(tt.WhatId);
                    }else if(tt.Type.equals('Problem Policy Holder')){
                        recordIdList.add(tt.WhatId);
                    }
                }
            }
            System.debug('polIdList ==>>'+polIdList);
            if(polIdList != null && !polIdList.isEmpty()){
                for(Policy__c policy : [select AML_Check__c,NFC_Check__c from Policy__c where id in :polIdList  ]){
                    if(taskType.equals('Review Un Clean NFC Results For Policy Renewal')){
                        policy.NFC_Check__c = 'Approved';
                    }else if(taskType.equals('AML Checking For Policy Renewal')){
                        policy.AML_Check__c = 'Approved';
                    }
                    updatePolList.add(policy);
                }
            }
            System.debug('updatePolList ==>>'+updatePolList);
            if(updatePolList != null && !updatePolList.isEmpty()){
                update updatePolList;
                System.debug('Policy updated.');
            }
            System.debug('recordIdList===>>'+recordIdList);
            if(recordIdList!=null && !recordIdList.isEmpty()){
                System.debug('taskType====>>'+taskType);
                if(taskType.equals('BR Check')){
                    PolicyManagementApi.updateEcicDocStatus(recordIdList);
                }else if(taskType.equals('Problem Policy Holder')){
                    //SME_ConsoleHandler.getNFCRecordFromLegacy(recordIdList[0]);
                }
            }
        } catch (Exception e) {
            System.debug('Exception at TaskTriggerHandler handleTask : '+e.getMessage()+' Stack :'+e.getStackTraceString());
            ExceptionLogger.log(e, 'TaskTriggerHandler');
            ExceptionLogger.email(e);  
        }
    }
}