public with sharing class CMS_Pdf_Controller {
    public List<ConnectApi.ManagedContentVersion> results {get;set;}
    public String Policy_Id{get;set;}
    public String Policy_Type{get;set;}
    public CMS_Pdf_Controller() {
            try {
                Policy_Id = ApexPages.currentPage().getParameters().get('policyId');
                System.debug('Policy Id::'+Policy_Id);
                Id Product_Id;
                Id cmsConId;
                List<Policy__c> policyDetaiLIst = new List<Policy__c>();
                List<CMS_Content__c> cmsContentList = new List<CMS_Content__c>();
                List<Id> cmsConPubIdList = new List<Id>();
                policyDetaiLIst = [select Product__r.Name,Product__c from Policy__c where Id =: Policy_Id];
                for (Policy__c var : policyDetaiLIst) {
                    Product_Id = var.Product__c;
                    Policy_Type = var.Product__r.Name;
                }
                System.debug('Product Id::'+Product_Id);
                cmsContentList = [select Content_Id__c from CMS_Content__c  where Product__c =:Product_Id and  Status__c='Published'];
                for (CMS_Content__c var : cmsContentList) {
                    cmsConId = var.Content_Id__c;
                    cmsConPubIdList.add(cmsConId);
                }
                System.debug('cmsConPubIdList::'+cmsConPubIdList);
                if (cmsConPubIdList != null && !cmsConPubIdList.isEmpty()) {
                    results = getCMSontentByContentIds(cmsConPubIdList);
                }
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
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
            ConnectApi.ManagedContentVersionCollection contentList 
                  = ConnectApi.ManagedContent.getManagedContentByIds(communityId, contentIds, pageParam, pageSize, language, managedContentType);

                  results = contentList.items;  
            System.debug('results : '+results);         
        }
        catch(ConnectApi.ConnectApiException e){
            System.debug('Exception at CMS : '+e.getMessage()+' Stack : '+e.getStackTraceString());
            results = new List<ConnectApi.ManagedContentVersion>();
        }  
        return results;         
    }

}