public with sharing class ContentManagementSystem {
   
    @AuraEnabled
    public static List<ConnectApi.ManagedContentVersion> getPublishedContentIds(String user_id){
        System.debug('user_id ::'+user_id);
        List<ConnectApi.ManagedContentVersion> results;
        Id accountId = [Select contact.AccountId from user where id =:user_id].contact.AccountId;
        Account accObj = [select Current_Policy__r.Product__c from Account where id =:accountId]; 
        Id productId = accObj.Current_Policy__r.Product__c;
        List<Id> cmsPubConIdList=new List<Id>();
        for(CMS_Content__c cms : [select Content_Id__c from CMS_Content__c  where Product__c =:productId and  Status__c='Published']){
            cmsPubConIdList.add(cms.Content_Id__c);
        }
        System.debug('cmsPubConIdList : '+cmsPubConIdList);
        if(cmsPubConIdList !=null && !cmsPubConIdList.isEmpty()){
            results = getCMSontentByContentIds(cmsPubConIdList);
        }
        return results;
    }

    public static List<ConnectApi.ManagedContentVersion> getCMSontentByContentIds(List<String> contentIds) {
        //List<String> contentIds = new List<String>();
        System.debug('contentIds :'+contentIds);
        String communityId;
        List<ConnectApi.ManagedContentVersion> results;
        try {
            Network netObj = [select id from Network];
            communityId = netObj.id;
            System.debug('communityId :'+communityId);
        } catch (Exception e) {
            System.debug('Exception at ContentController constructor : '+e.getMessage()+' Stack : '+e.getStackTraceString());
        }
        try{
            
            String language = 'en_US';
            String managedContentType = 'news';
            Integer pageParam= 0;
            Integer pageSize = 50;
            //Note: "news" is the contenttype of the content value hard coded in the code here.
            if(!Test.isRunningTest()){
                ConnectApi.ManagedContentVersionCollection contentList 
                  = ConnectApi.ManagedContent.getManagedContentByIds(communityId, contentIds, pageParam, pageSize, language, managedContentType);

                  results = contentList.items;
            }
              
            System.debug('results : '+results);         
        }
        catch(ConnectApi.ConnectApiException e){
            System.debug('Exception at CMS : '+e.getMessage()+' Stack : '+e.getStackTraceString());
            results = new List<ConnectApi.ManagedContentVersion>();
        }  
        return results;         
    }

    @AuraEnabled
    public static String getCMSontentByContentIdsV1(List<Id> contentIds) {
        String cmsContent;
        System.debug('getCMSontentByContentIdsV1 contentIds :'+contentIds);
        String communityId;
        List<ConnectApi.ManagedContentVersion> results;
        try {
            Network netObj = [select id from Network where name='EC-Reach' limit 1];
            System.debug('netObj ===>>'+netObj);
            communityId = netObj.id;
            System.debug('communityId :'+communityId);
        } catch (Exception e) {
            System.debug('Exception at Netwrok Checking : '+e.getMessage()+' Stack : '+e.getStackTraceString());
        }
        try{
            
            String language = 'en_US';
            String managedContentType = 'news';
            Integer pageParam= 0;
            Integer pageSize = 50;
            //Note: "news" is the contenttype of the content value hard coded in the code here.
            if(!Test.isRunningTest()){
                ConnectApi.ManagedContentVersionCollection contentList 
                  = ConnectApi.ManagedContent.getManagedContentByIds(communityId, contentIds, pageParam, pageSize, language, managedContentType);

                  results = contentList.items; 
                  for(ConnectApi.ManagedContentVersion m : results){
                    //System.debug('m===>>> : '+m.contentNodes.get('body').toString().substringAfter('value=').remove(']'));
                    cmsContent =  m.contentNodes.get('body').toString().substringAfter('value=').remove(']');
                }  
            }
            
            
            System.debug('cmsContent===>>'+cmsContent);       
        } 
        catch(ConnectApi.ConnectApiException e){
            System.debug('Exception at CMS : '+e.getMessage()+' Stack : '+e.getStackTraceString());
            results = new List<ConnectApi.ManagedContentVersion>();
        }  
        return cmsContent;         
    }

   
}