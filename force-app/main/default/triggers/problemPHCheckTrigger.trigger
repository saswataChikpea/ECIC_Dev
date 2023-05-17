trigger problemPHCheckTrigger on ECIC_Document__c (before insert,before update, After insert) {
    System.debug('Trigger Context isUpdate: '+Trigger.isUpdate+' isInsert:'+Trigger.isInsert);
       
    List<String> docBRList = new List<String>();
    List<String> docIdList = new List<String>();
    List<String> docAccIdList = new List<String>();
    for (ECIC_Document__c doc : Trigger.new) {
        if(Trigger.isUpdate){
            System.debug('Trigger update');
            ECIC_Document__c docOld = Trigger.oldMap.get(doc.id);
            if(docOld.Status__c!=null && !docOld.Status__c.equals('Valid')){
                if(doc.Status__c!=null && doc.Status__c.equals('Valid')){
                    docIdList.add(doc.id); 
                    docBRList.add(doc.BR_Number__c);
                    docAccIdList.add(doc.Account__c);
                }
            }
            if(docOld.Status__c!=null && !docOld.Status__c.equals('In Valid')){
                System.debug('docOld.Status__c=>'+docOld.Status__c+' doc.Status__c:'+doc.Status__c);
                //if(doc.Status__c!=null && doc.Status__c.equals('Invalid')){
                    String emailTemplateName;
                    if(doc.Reject_Reason__c!=null){
                        if(doc.Reject_Reason__c.equals('Unmatched BR Number')){
                            emailTemplateName='Unmatch_BR_number';
                        }else if(doc.Reject_Reason__c.equals('Unmatched Company Name')){
                            emailTemplateName='Unmatch_company_address';
                        }else if(doc.Reject_Reason__c.equals('Unmatched Company Address')){
                            emailTemplateName='Unmatch_company_name';
                        }
                    }else {
                        //doc.addError('Please Select Reject Reason.');
                    }
                    if(emailTemplateName!=null && !emailTemplateName.equals('')){
                        System.debug('Found emailTemplate: '+emailTemplateName);
                        SendEmailApex.sendEmailFuture(doc.Account__c, doc.id, emailTemplateName, false, null, null);
                    }
                // }else{
                //     if(doc.Reject_Reason__c != null ){
                //         doc.addError('Reject Reason is only allowed for Status Invalid');
                //     }
                // }
            }else{
                doc.addError('Already Rejected.');
            }
        }
        // if(Trigger.isInsert){
        //     System.debug('Trigger insert');
        //     if(doc.Status__c!= null && doc.Status__c.equals('Valid')){
        //         docIdList.add(doc.id);
        //         docBRList.add(doc.BR_Number__c);
        //         docAccIdList.add(doc.Account__c);
        //     }
        // }
        
    }
    System.debug('docIdList : '+docIdList);
    if(docIdList!= null && !docIdList.isEmpty()){
        PolicyManagementApi.problemPolicyHolder(docIdList[0],docBRList[0],docAccIdList[0]);
    }
    /////// content document owner update
    if(Trigger.isInsert && Trigger.isAfter){
        Set<Id> ids= new Set<Id>();
        for (ECIC_Document__c ed : Trigger.new) {
            ids.add(ed.Id);
        }
        EcicDocumentTriggerHandler.handleAfterTrigger(ids);
    }
    if(Trigger.isInsert && Trigger.isBefore){
        for (ECIC_Document__c ed : Trigger.new) {
            ed.Backup_Status__c='Invalid';
        }
    }
}