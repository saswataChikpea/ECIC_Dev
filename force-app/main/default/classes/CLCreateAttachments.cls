public with sharing class CLCreateAttachments {

    
    public static void linkDocToParent(Credit_Limit__c cl,String page_name) {
        System.debug('linkDocToParent cl='+cl);
        System.debug('page_name='+page_name);
        String extention='pdf';
        List<ContentVersion> contentVerList = new List<ContentVersion>();
        Map<String,String> conVerTitleVsIDMap = new Map<String,String>();
        String docName;
        PageReference cl_page;
        
        if(page_name == 'CLApproveOMBP') {
            cl_page = Page.CLApproveOMBP;
            docName = 'CL_Approve_'+cl.CL_No__c;
        } else if(page_name == 'CLApproveSBP') {
            cl_page = Page.CLApproveSBP;
            docName = 'CL_Approve_'+cl.CL_No__c;
        } else if(page_name == 'CLApproveSUP') {
            cl_page = Page.CLApproveSUP;
            docName = 'CL_Approve_'+cl.CL_No__c;
        }
        String cl_str = JSON.serialize(cl);
        cl_page.getParameters().put('id',cl.Id);
        cl_page.getParameters().put('cl',cl_str);
        cl_page.getParameters().put('renderAs','PDF');
        ContentVersion docContent = new ContentVersion();
        docContent.Title= docName;
        docContent.PathOnClient = docName + '.pdf';
        Blob docBody;
        try {
            // returns the output of the page as a PDF
            docBody = cl_page.getContent();
        // need to pass unit test -- current bug	
        } catch (VisualforceException e) {
            System.debug('Exception at Creatig cl Document : '+e.getMessage()+' Stack:'+e.getStackTraceString());
            //scheduleBody = Blob.valueOf('Exception at Creatig Cover : '+e.getMessage()+' Stack:'+e.getStackTraceString());
        }
        docContent.VersionData = docBody;
        docContent.origin = 'C';
        conVerTitleVsIDMap.put(docName,cl.Id);
        contentVerList.add(docContent);
        System.debug('contentVerList==>>'+contentVerList);
        List<ContentDocumentLink> contentDocList= new List<ContentDocumentLink>();
        //---------
        if(contentVerList != null && !contentVerList.isEmpty()){
            Database.SaveResult[] insertClDoc = Database.insert(contentVerList, False);
            List<ID> conVerIDList = new List<ID>();
            for(Integer i=0;i<insertClDoc.size();i++){
                if(insertClDoc[i].isSuccess()){
                    conVerIDList.add(insertClDoc[i].getId());
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
                    List<ID> signedClIdList = new List<ID>();
                    for(ContentDocumentLink cdlink : [SELECT id,ContentDocument.title,LinkedEntityId from ContentDocumentLink where id in :succeessConDocIDList]){
                        signedClIdList.add(cdlink.LinkedEntityId);
                    }
                    System.debug('signedPolSchIdList ===>>'+signedClIdList);
                    submitDocForSign(cl.Id,docName);
                    //------- api call --------
                    // String extention='pdf';
                   /* Boolean isdocInserted;
                    String divCode = 'UD'; // BD, UD, CRD
                    String password = NULL;
                    //String policyName='PL-000000044';
                    try {
                        ECIC_API_V1.get_ecic_setting(NULL);
                        ECIC_API_V1.get_access_token();
                        ECIC_API_v1.submitCLDocForSign(cl_id, docName, divCode, password);
                        
                    } catch (Exception fex) {
                        System.debug('Exception at submitDocForSign '+fex.getMessage()+' Stack : '+fex.getStackTraceString());
                    }*/
                    //-------
                    /*List<Policy_Schedule__c> updateDocAttachPolSchList=new List<Policy_Schedule__c>();
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
                    }*/
                }
            }
        }
    }

    public static void linkCLADocToParent(Credit_Limit_Application__c cla,String page_name) {
        System.debug('linkDocToParent cla='+cla);
        System.debug('page_name='+page_name);
        String extention='pdf';
        List<ContentVersion> contentVerList = new List<ContentVersion>();
        Map<String,String> conVerTitleVsIDMap = new Map<String,String>();
        String docName;
        PageReference cla_page;
        
        if(page_name == 'CLACancelOMBP') {
            cla_page = Page.CLACancel;
            docName = 'CLA_Cancel_'+cla.Name;
        } else if(page_name == 'CLACancelSBP') {
            cla_page = Page.CLACancelSBP;
            docName = 'CLA_Cancel_'+cla.Name;
        } else if(page_name == 'CLACancelSUP') {
            cla_page = Page.CLACancelSUP;
            docName = 'CLA_Cancel_'+cla.Name;
        }
        cla_page.getParameters().put('Id',cla.Id);
        cla_page.getParameters().put('renderAs','PDF');
        ContentVersion docContent = new ContentVersion();
        docContent.Title= docName;
        docContent.PathOnClient = docName + '.pdf';
        Blob docBody;
        try {
            // returns the output of the page as a PDF
            docBody = cla_page.getContent();
        // need to pass unit test -- current bug	
        } catch (VisualforceException e) {
            System.debug('Exception at Creatig cl Document : '+e.getMessage()+' Stack:'+e.getStackTraceString());
            //scheduleBody = Blob.valueOf('Exception at Creatig Cover : '+e.getMessage()+' Stack:'+e.getStackTraceString());
        }
        docContent.VersionData = docBody;
        docContent.origin = 'C';
        conVerTitleVsIDMap.put(docName,cla.id);
        contentVerList.add(docContent);
        System.debug('contentVerList==>>'+contentVerList);
        List<ContentDocumentLink> contentDocList= new List<ContentDocumentLink>();
        //---------
        if(contentVerList != null && !contentVerList.isEmpty()){
            Database.SaveResult[] insertClDoc = Database.insert(contentVerList, False);
            List<ID> conVerIDList = new List<ID>();
            for(Integer i=0;i<insertClDoc.size();i++){
                if(insertClDoc[i].isSuccess()){
                    conVerIDList.add(insertClDoc[i].getId());
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
                    List<ID> signedClaIdList = new List<ID>();
                    for(ContentDocumentLink cdlink : [SELECT id,ContentDocument.title,LinkedEntityId from ContentDocumentLink where id in :succeessConDocIDList]){
                        signedClaIdList.add(cdlink.LinkedEntityId);
                    }
                    System.debug('signedPolSchIdList ===>>'+signedClaIdList);
                    submitDocForSign(cla.Id,docName);
                    /*List<Policy_Schedule__c> updateDocAttachPolSchList=new List<Policy_Schedule__c>();
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
                    }*/
                }
            }
        }
    }

    @future(callout=true)
    public static void submitDocForSign(String recordId,String docName){
        
        String extention='pdf';
        Boolean isdocInserted;
        String divCode = 'UD'; // BD, UD, CRD
        String password = NULL;
        //String policyName='PL-000000044';
        try {
            ECIC_API_V1.get_ecic_setting(NULL);
            ECIC_API_V1.get_access_token();
            ECIC_API_v1.submitCLDocForSign(recordId, docName, divCode, password);
            
        } catch (Exception fex) {
            System.debug('Exception at submitDocForSign '+fex.getMessage()+' Stack : '+fex.getStackTraceString());
        }
    }
}