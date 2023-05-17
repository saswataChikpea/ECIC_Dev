public with sharing class FetchCmsContent {

    
 
    @AuraEnabled(cacheable=true)
    public static List<ConnectApi.ManagedContentVersion> initMethod(){
        ContentController ContentController = new ContentController();
        return ContentController.results;
    }
 
    public class ContentController{
        //@AuraEnabled public String managedContentIdsStr { get; set; }
        //@AuraEnabled public String topicNamesStr { get; set; }
        //@AuraEnabled public String contentType { get; set; }
        //@AuraEnabled public String errorMessage { get; set; }
        @AuraEnabled public String communityId {get; set; }
        @AuraEnabled public List<ConnectApi.ManagedContentVersion> results { get; set; }
 
        public ContentController(){
            //communityId = Network.getNetworkId();
            try {
                Network netObj;
                if(!Test.isRunningTest()){
                    netObj = [select id from Network];
                    
                }
                communityId = netObj.id;
                
            } catch (Exception e) {
                System.debug('Exception at ContentController constructor : '+e.getMessage()+' Stack : '+e.getStackTraceString());
            }
            
            System.debug('communityId : '+communityId);
            getCMSontent();
        }
         
        public void getCMSontent() {
            List<String> contentIds = new List<String>();
            List<String> topicNames = new List<String>();
            try{
                /*if(topicNamesStr != null && !String.isEmpty(topicNamesStr)){
                    topicNames = topicNamesStr.split(',',-1); 
                }
                
                
                for(Integer i=0;i<topicNames.size();i++){
                    topicNames.set(i,topicNames.get(i).trim());
                }*/
                
                String language = 'en_US';
                //Note: "news" is the contenttype of the content value hard coded in the code here.
                ConnectApi.ManagedContentVersionCollection contentList; 
                if(!Test.isRunningTest()){
                    
                    contentList = ConnectApi.ManagedContent.getManagedContentByTopicsAndIds(communityId, contentIds, topicNames, 0, 50, language, 'news');
                    
                    results = contentList.items;
                }
                  
                
                System.debug('results : '+results);         
            }
            catch(ConnectApi.ConnectApiException e){
                System.debug('Error Message : '+e);
                results = new List<ConnectApi.ManagedContentVersion>();
            }           
        }
        
    }   
}