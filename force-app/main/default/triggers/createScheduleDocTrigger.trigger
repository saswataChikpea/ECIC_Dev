trigger createScheduleDocTrigger on Policy_Schedule__c (after Update) {
    System.debug('Trigger createScheduleDocTrigger');
    if(Trigger.isUpdate){
        System.debug('Trigger Update.');
        String policyId;
        String scheduleId;
        String docName;
        String policyName;
        boolean isDocSigned=false;
        for(Policy_Schedule__c schRef : Trigger.new){
            policyId = schRef.Policy__c;
        }
        if(policyId!= null && !policyId.equals('')){
            Policy__c polRef = [select id,name from Policy__c where id =:policyId];
            policyName = polRef.name;
        }
        System.debug('policyId >>>'+policyId+' policyName==>>'+policyName);
        for(Policy_Schedule__c pschedule : Trigger.new){
            System.debug('pschedule.Type__c===>>'+pschedule.Type__c+' pschedule : Is_Schedule_Signed__c: '+pschedule.Is_Schedule_Signed__c+' Is_Ready_For_Signing__c: '+pschedule.Is_Ready_For_Signing__c);
            if(pschedule.Type__c!=null){
                Policy_Schedule__c polSchOld = Trigger.oldMap.get(pschedule.id);
                if(!polSchOld.Is_Ready_For_Signing__c && pschedule.Is_Ready_For_Signing__c && !pschedule.Is_Schedule_Signed__c){
                    isDocSigned=pschedule.Is_Schedule_Signed__c;
                    policyId = pschedule.Policy__c;
                    scheduleId = pschedule.id;
                    
                    if(pschedule.Type__c.equals('Schedule 1')){
                        //Create Cover with Schdeule 1
                        docName=policyName+'_Schedule1';
                    }else if(pschedule.Type__c.equals('Schedule 2')){
                        //Create Schdeule 2
                        docName=policyName+'_Schedule2';
                    }else if(pschedule.Type__c.equals('Schedule 3')){
                        //Create Schdeule 3
                        docName=policyName+'_Schedule3';
                    }else if(pschedule.Type__c.equals('Schedule 4')){
                        //Create Schdeule 4
                        docName=policyName+'_Schedule4';
                    }else if(pschedule.Type__c.equals('Policy Cover')){
                        //Create Cover
                        docName=policyName+'_Cover';
                    }else if(pschedule.Type__c.equals('Policy Document')){
                        //Create Document
                        docName=policyName+'_Document';
                    }
                    System.debug('docName ======>>>'+docName);
                }else{
                    System.debug('Doc : '+pschedule.name+' id:'+pschedule.id+' Not ready for signing.');
                }
            }
        }
        System.debug('isDocSigned:'+isDocSigned);
        if(!isDocSigned){
            System.debug('Link docName :'+docName);
            //CreateAttachmentToPolicy.linkDocToParent(policyId,scheduleId,policyName,docName);
        }
    }
}