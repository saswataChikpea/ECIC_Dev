public with sharing class CreateAttachmentToPolicy {
    // @future(callout=true)
    // public static void linkDocToParent(String policyId,String scheduleId,String policyName,String docName) {
    //     Boolean isSuccess;
    //     System.debug('CreateAttachmentToPolicy linkDocToParent  docName:'+docName+' policyName:'+policyName+' policyId:'+policyId+' scheduleId: '+scheduleId);
        
    //     String extention='pdf';
    //     Id conDocId;
    //     PageReference schdeule;
    //     if(docName.equals(policyName+'_Schedule1')){
    //        schdeule = Page.PolicyScheduleOne;
    //     }else if(docName.equals(policyName+'_Schedule2')){
    //         schdeule = Page.PolicyScheduleTwo;
    //     }else if(docName.equals(policyName+'_Schedule3')){
    //         schdeule = Page.PolicyScheduleThree;
    //     }else if(docName.equals(policyName+'_Schedule4')){
    //         schdeule = Page.PolicyScheduleFour;
    //     }else if(docName.equals(policyName+'_Cover')){
    //         schdeule = Page.PolicyDocumentCover;
    //     }else if(docName.equals(policyName+'_Document')){
    //         schdeule = Page.PolicyCMSDocument;
    //     }
        
    //     // add parent id to the parameters for standardcontroller
    //     schdeule.getParameters().put('policyId',policyId);
    //     schdeule.getParameters().put('renderAs','PDF');

    //     ContentVersion scheduleFile = new ContentVersion();
    //     scheduleFile.Title= docName;
    //     scheduleFile.PathOnClient = docName + '.' + extention;
    //     Blob scheduleBody;
    //     try {
    //         // returns the output of the page as a PDF
    //         scheduleBody = schdeule.getContent();
    //     // need to pass unit test -- current bug	
    //     } catch (VisualforceException e) {
    //         System.debug('Exception at Creatig Schdeule : '+e.getMessage()+' Stack:'+e.getStackTraceString());
    //         scheduleBody = Blob.valueOf('Exception at Creatig Cover : '+e.getMessage()+' Stack:'+e.getStackTraceString());
    //     }
        
    //     scheduleFile.VersionData = scheduleBody;
    //     scheduleFile.origin = 'C';
    //     try {
    //         insert scheduleFile;
           
    //         System.debug(docName+'Content Version Created Successfully.');
    //         //Get Content Documents
    //         conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:scheduleFile.Id].ContentDocumentId;
    //         System.debug('conDocId==>>'+conDocId);
    //         //Create ContentDocumentLink 
    //         ContentDocumentLink cdlSchedule = New ContentDocumentLink();
    //         cdlSchedule.LinkedEntityId = scheduleId;
    //         cdlSchedule.ContentDocumentId = conDocId;
    //         cdlSchedule.shareType = 'V';
    //         Insert cdlSchedule;
    //         System.debug(docName+' Created Successfully with cdlSchedule:'+cdlSchedule.id);
    //         isSuccess=true;
 
    //     } catch (Exception sch) {
    //         System.debug('Exception occur : '+sch.getMessage()+' Stack : '+sch.getStackTraceString());
    //     }
    //     System.debug('isSuccess ==>'+isSuccess);
    //     //return isSuccess;
    // }
    //@future(callout=true)
    public static void submitDocForSign(String recordId,String docName){
        
        String extention='pdf';
        Boolean isdocInserted;
        String divCode = 'BD'; // BD, UD, CRD
        String password = NULL;
        //String policyName='PL-000000044';
        try {
            ECIC_API_V1.get_ecic_setting(NULL);
            ECIC_API_V1.get_access_token();
            ECIC_API_v1.submitPolicyDocForSign(recordId, docName, divCode, password);
            
        } catch (Exception fex) {
            System.debug('Exception at submitDocForSign '+fex.getMessage()+' Stack : '+fex.getStackTraceString());
        }
    } 

    public static void linkDocToParentByBatch(List<Policy_Schedule__c> policyScheduleIDList) {
        System.debug('linkDocToParentByBatch policyScheduleIDList : '+policyScheduleIDList);
        String extention='pdf';
        List<ContentVersion> contentVerList = new List<ContentVersion>();
        Map<String,String> conVerTitleVsIDMap = new Map<String,String>();
        for(Policy_Schedule__c polSch : policyScheduleIDList){
            System.debug('Type==>>'+polSch.Type__c+' policyName:'+polSch.Policy__r.name+' policyId:'+polSch.Policy__c+' scheduleId: '+polSch.id);
            Id conDocId;
            String docName;
            PageReference schdeule;
            
            if(polSch.Type__c.equals('Schedule 1')){
                //Create Cover with Schdeule 1
                docName=polSch.Policy__r.name+'_Schedule1';
                schdeule = Page.PolicyScheduleOne;
            }else if(polSch.Type__c.equals('Schedule 2')){
                //Create Schdeule 2
                docName=polSch.Policy__r.name+'_Schedule2';
                schdeule = Page.PolicyScheduleTwo;
            }else if(polSch.Type__c.equals('Schedule 3')){
                //Create Schdeule 3
                docName=polSch.Policy__r.name+'_Schedule3';
                schdeule = Page.PolicyScheduleThree;
            }else if(polSch.Type__c.equals('Schedule 4')){
                //Create Schdeule 4
                docName=polSch.Policy__r.name+'_Schedule4';
                schdeule = Page.PolicyScheduleFour;
            }else if(polSch.Type__c.equals('Policy Cover')){
                //Create Cover
                docName=polSch.Policy__r.name+'_Cover';
                schdeule = Page.PolicyDocumentCover;
            }else if(polSch.Type__c.equals('Policy Document')){
                //Create Document
                docName=polSch.Policy__r.name+'_Document';
                schdeule = Page.PolicyCMSDocument;
            }
            System.debug('docName ==>>'+docName);
            // add parent id to the parameters for standardcontroller
            
            schdeule.getParameters().put('policyId',polSch.Policy__c);
            schdeule.getParameters().put('renderAs','PDF');
            ContentVersion docContent = new ContentVersion();
            docContent.Title= docName;
            docContent.PathOnClient = docName + '.' + extention;
            Blob scheduleBody;
            try {
                // returns the output of the page as a PDF
                scheduleBody = schdeule.getContent();
            // need to pass unit test -- current bug	
            } catch (VisualforceException e) {
                System.debug('Exception at Creatig Policy Document : '+e.getMessage()+' Stack:'+e.getStackTraceString());
                //scheduleBody = Blob.valueOf('Exception at Creatig Cover : '+e.getMessage()+' Stack:'+e.getStackTraceString());
            }
            
            docContent.VersionData = scheduleBody;
            docContent.origin = 'C';
            conVerTitleVsIDMap.put(docName,polSch.id);
            contentVerList.add(docContent);
        }
        System.debug('contentVerList==>>'+contentVerList);
        List<ContentDocumentLink> contentDocList= new List<ContentDocumentLink>();
        if(contentVerList != null && !contentVerList.isEmpty()){
            Database.SaveResult[] insertPolicyDoc = Database.insert(contentVerList, False);
            List<ID> conVerIDList = new List<ID>();
            for(Integer i=0;i<insertPolicyDoc.size();i++){
                if(insertPolicyDoc[i].isSuccess()){
                    conVerIDList.add(insertPolicyDoc[i].getId());
                }
            }
            System.debug('conVerIDList >>'+conVerIDList);
            for(ContentVersion conVerRef : [SELECT ContentDocumentId,title FROM ContentVersion WHERE Id in :conVerIDList]){
                System.debug('conVerRef==>>'+conVerRef);
                //Create ContentDocumentLink 
                ContentDocumentLink cdlSchedule = New ContentDocumentLink();
                cdlSchedule.LinkedEntityId = conVerTitleVsIDMap.get(conVerRef.title);
                cdlSchedule.ContentDocumentId = conVerRef.ContentDocumentId;
                cdlSchedule.shareType = 'V';
                contentDocList.add(cdlSchedule);
            }
            System.debug('contentDocList >>'+contentDocList);
            if(contentDocList != null && !contentDocList.isEmpty()){
                Database.SaveResult[] insertConDoc = Database.insert(contentDocList, False);
                List<ID> succeessConDocIDList = new List<id>();
                for(Integer j=0;j<insertConDoc.size();j++){
                    System.debug('Suceessfully inserted : '+insertConDoc[j]);
                    if(insertConDoc[j].success){
                        succeessConDocIDList.add(insertConDoc[j].getId());
                    }
                }
                System.debug('succeessConDocIDList ==>>'+succeessConDocIDList);
                if(succeessConDocIDList !=null && !succeessConDocIDList.isEmpty()){
                    List<ID> signedPolSchIdList = new List<ID>();
                    for(ContentDocumentLink cdlink : [SELECT id,ContentDocument.title,LinkedEntityId from ContentDocumentLink where id in :succeessConDocIDList]){
                        signedPolSchIdList.add(cdlink.LinkedEntityId);
                    }
                    System.debug('signedPolSchIdList ===>>'+signedPolSchIdList);
                    List<Policy_Schedule__c> updateDocAttachPolSchList=new List<Policy_Schedule__c>();
                    if(signedPolSchIdList!=null && !signedPolSchIdList.isEmpty()){
                        for(Policy_Schedule__c sc : [select id, Is_Ready_For_Signing__c from Policy_Schedule__c where id in :signedPolSchIdList]){
                            sc.Is_Ready_For_Signing__c=true;
                            updateDocAttachPolSchList.add(sc);
                        }
                    }
                    System.debug('updateDocAttachPolSchList : '+updateDocAttachPolSchList);
                    if(updateDocAttachPolSchList!=null && !updateDocAttachPolSchList.isEmpty()){
                        update updateDocAttachPolSchList;
                        System.debug('updateDocAttachPolSchList updated successfully.');
                    }
                }
            }
        }
    }
}