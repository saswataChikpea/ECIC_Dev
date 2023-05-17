trigger CMSDuplicateContentId on CMS_Content__c (after insert , after update) {
    //List<CMS_Content__c> contactList = new List<CMS_Content__c>();
    Set<String> newIdSet = new Set<String>();
    Set<ID> newContentIdSet = new Set<ID>();
    String cmsId= '';
    for(CMS_Content__c cms:Trigger.new)
        
    {  system.debug('screen' + cms);
        if ( cms.Content_Id__c != null  )
        {
            cmsId= cms.id;
            if(cms.Status__c == 'Published'){
                newIdSet.add(cms.Id);
                newContentIdSet.add(cms.Content_Id__c);
            }
        }
    }
        system.debug('newIdSet:::'+cmsId+'::'+ newIdSet);
        List<CMS_Content__c> existingURLList = [Select Id, Content_Id__c,Status__c  From CMS_Content__c 
                                                Where Content_Id__c IN :newContentIdSet ];
    
        system.debug('existingURLList:::'+ existingURLList);
        List<CMS_Content__c> updateCMSList = new List<CMS_Content__c>();
        for ( CMS_Content__c content : existingURLList ) 
        { 
            if(!newIdSet.contains(content.Id) && content.Status__c != 'Un Published'){
                content.Status__c = 'Un Published';
                updateCMSList.add(content);
            }
        }
    system.debug('updateCMSList:::'+ updateCMSList);
        if (updateCMSList != null && !updateCMSList.isEmpty()){
            system.debug(updateCMSList);
            update updateCMSList ;
        }
 
}