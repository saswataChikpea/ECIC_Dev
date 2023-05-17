trigger handleTask on Task (before insert,before update) {

    if(Trigger.isBefore && Trigger.isUpdate){
        TaskTriggerHandler.handleTask(Trigger.new,Trigger.oldMap);

        // List<ID> recordIdList = new List<ID>();
        // String taskType='';
        // for(Task tt: Trigger.new){
        //     System.debug('Trigger update tt.Type:'+tt.Type);
        //     Task ttOld = Trigger.oldMap.get(tt.id);

        //     if(tt.Type != null){
        //         taskType=tt.Type;
        //         if(tt.Type.equals('BR Check')){
        //             if(ttOld.Status!=null && !ttOld.Status.equals('Completed')){
        //                 System.debug('ttOld.Status :'+ttOld.Status+' tt.Status:'+tt);
        //                 if(tt.Status.equals('Completed')){
        //                     recordIdList.add(tt.WhatId);
        //                 }
        //             }
        //         }else if(tt.Type.equals('Problem Policy Holder')){
        //             if(ttOld.Status!=null && !ttOld.Status.equals('Completed')){
        //                 System.debug('ttOld.Status :'+ttOld.Status+' tt.Status:'+tt);
        //                 if(tt.Status.equals('Completed')){
        //                     recordIdList.add(tt.WhatId);
        //                 }
        //             }
        //         }
                
        //     }
        // }
        // System.debug('recordIdList===>>'+recordIdList);
        // if(recordIdList!=null && !recordIdList.isEmpty()){
        //     System.debug('taskType====>>'+taskType);
        //     if(taskType.equals('BR Check')){
        //         PolicyManagementApi.updateEcicDocStatus(recordIdList);
        //     }else if(taskType.equals('Problem Policy Holder')){
        //         //SME_ConsoleHandler.getNFCRecordFromLegacy(recordIdList[0]);
        //     }
        // }
    }
}