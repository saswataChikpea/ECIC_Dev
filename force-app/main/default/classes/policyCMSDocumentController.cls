public with sharing class policyCMSDocumentController {
    public String policyID {get;set;}
    public String productId {get;set;}
    public String productName {get;set;}
    public String productTitle {get;set;}
    public String policyNumber {get;set;}
    public List<ConnectApi.ManagedContentVersion> results {get;set;}
    
    public boolean isTheCoverExist {get;set;}
    public String theCover {get;set;}
    public boolean isPolicyTermHeaderContentExist {get;set;}
    public String policyTermHeaderContent {get;set;}
    public boolean isExistContractCoveredAndRelatedConditions {get;set;}
    public String contractCoveredAndRelatedConditions {get;set;}
    public boolean isExistCreditLimit {get;set;}
    public String creditLimit {get;set;}
    public boolean isExistDecAndPrem {get;set;}
    public String decAndPrem {get;set;}
    public boolean isExistLossMinimisation {get;set;}
    public String lossMinimisation {get;set;}
    public boolean isExistExclusion {get;set;}
    public String exclusion {get;set;}
    public boolean isExistClaimsAndRecoveries {get;set;}
    public String claimsAndRecoveries {get;set;}
    public boolean isExistGeneralConditions {get;set;}
    public String generalConditions {get;set;}
    public boolean isExistMiscellenious {get;set;}
    public String miscellenious {get;set;}
    public boolean isExistConfidentiality {get;set;}
    public String confidentiality {get;set;}
    public boolean isExistDefinitions {get;set;}
    public String definitions {get;set;}
    public boolean isExistPremium {get;set;}
    public String premium {get;set;}
    public boolean isExistPolRemarks {get;set;}
    public String polRemarks {get;set;}


    public policyCMSDocumentController() {
        //System.debug('policyTermHeaderContent===>>'+ApexPages.currentPage().getParameters().get('policyTermHeaderContent'));
        System.debug('===>>'+ApexPages.currentPage().getParameters().get('policyID'));
        policyID=ApexPages.currentPage().getParameters().get('policyID');
        Policy__c polObj = [select name,Product__c,Product__r.name,Product__r.Full_Name__c from Policy__c where id =:policyID];
        productId = polObj.Product__c;
        productName = polObj.Product__r.name;
        productTitle = polObj.Product__r.Full_Name__c;
        policyNumber = polObj.name;
        System.debug('productId : '+productId+' productName :'+productName);
        List<Id> cmsPubConIdList=new List<Id>();
        for(CMS_Content__c cms : [select Content_Id__c from CMS_Content__c  where Product__c =:productId and  Status__c='Published']){
            cmsPubConIdList.add(cms.Content_Id__c);
        }
        System.debug('cmsPubConIdList : '+cmsPubConIdList);
        if(cmsPubConIdList !=null && !cmsPubConIdList.isEmpty()){
            System.debug('Fetch CMS content');
            results = getCMSontentByContentIds(cmsPubConIdList);
        }
        try {
            if(results!= null && !results.isEmpty()){
                for(ConnectApi.ManagedContentVersion cm : results){
                    System.debug('Loop Title >>>'+cm.title+'<<<Value:>>>> '+cm.contentNodes.get('body'));
                    ConnectApi.ManagedContentNodeValue manage = cm.contentNodes.get('body');
                    //ConnectApi.ManagedContentTextNodeValue textValue = manage.nodeType;
                    //System.debug('textValue====>>>: '+manage.nodeType+' build:>>>> '+manage.getBuildVersion()+' '+manage.toString().substringAfterLast('value=').remove(']'));
                    System.debug('Title Checking===>>'+productName+' THE COVER'.toUpperCase().toUpperCase()+'<===');
                    if(cm.title.toUpperCase().equals(productName+' POLICY TERM HEADER'.toUpperCase())){
                        isPolicyTermHeaderContentExist = true;
                        policyTermHeaderContent = manage.toString().substringAfterLast('value=').remove(']');
                    }else if(cm.title.toUpperCase().equals(productName+' THE COVER'.toUpperCase().toUpperCase())){
                        isTheCoverExist = true;
                        theCover = manage.toString().substringAfterLast('value=').remove(']');
                    }else if(cm.title.toUpperCase().equals(productName+' CONTRACTS COVERED AND RELATED CONDITIONS'.toUpperCase().toUpperCase())){
                        isExistContractCoveredAndRelatedConditions = true;
                        contractCoveredAndRelatedConditions = manage.toString().substringAfterLast('value=').remove(']');
                    }else if(cm.title.toUpperCase().equals(productName+' CREDIT LIMIT'.toUpperCase().toUpperCase())){
                        isExistCreditLimit = true;
                        creditLimit = manage.toString().substringAfterLast('value=').remove(']');
                    }else if(cm.title.toUpperCase().equals(productName+' DECLARATIONS AND PREMIUM'.toUpperCase().toUpperCase())){
                        isExistDecAndPrem = true;
                        decAndPrem = manage.toString().substringAfterLast('value=').remove(']');
                    }else if(cm.title.toUpperCase().equals(productName+' LOSS MINIMISATION'.toUpperCase().toUpperCase())){
                        isExistLossMinimisation = true;
                        lossMinimisation = manage.toString().substringAfterLast('value=').remove(']');
                    }else if(cm.title.toUpperCase().equals(productName+' EXCLUSIONS'.toUpperCase().toUpperCase())){
                        isExistExclusion = true;
                        exclusion = manage.toString().substringAfterLast('value=').remove(']');
                    }else if(cm.title.toUpperCase().equals(productName+' CLAIMS AND RECOVERIES'.toUpperCase().toUpperCase())){
                        isExistClaimsAndRecoveries = true;
                        claimsAndRecoveries = manage.toString().substringAfterLast('value=').remove(']');
                    }else if(cm.title.toUpperCase().equals(productName+' GENERAL CONDITIONS'.toUpperCase().toUpperCase())){
                        isExistGeneralConditions = true;
                        generalConditions = manage.toString().substringAfterLast('value=').remove(']');
                    }else if(cm.title.toUpperCase().equals(productName+' MISCELLANEOUS'.toUpperCase().toUpperCase())){
                        isExistMiscellenious = true;
                        miscellenious = manage.toString().substringAfterLast('value=').remove(']');
                    }else if(cm.title.toUpperCase().equals(productName+' CONFIDENTIALITY'.toUpperCase().toUpperCase())){
                        isExistConfidentiality = true;
                        confidentiality = manage.toString().substringAfterLast('value=').remove(']');
                    }else if(cm.title.toUpperCase().equals(productName+' DEFINITIONS'.toUpperCase().toUpperCase())){
                        isExistDefinitions = true;
                        definitions = manage.toString().substringAfterLast('value=').remove(']');
                    }else if(cm.title.toUpperCase().equals(productName+' PREMIUM'.toUpperCase().toUpperCase())){
                        isExistPremium = true;
                        premium = manage.toString().substringAfterLast('value=').remove(']');
                    }else if(cm.title.toUpperCase().equals(productName+' POLICY SCHEULE 1 REMARKS'.toUpperCase().toUpperCase())){
                        isExistPolRemarks = true;
                        polRemarks = manage.toString().substringAfterLast('value=').remove(']');
                    }
                }
            }
        } catch (Exception ex) {
            System.debug('Exception while iterating the results Message: '+ex.getMessage()+' Reason :'+ex.getStackTraceString());
        }
        
        System.debug('isPolicyTermHeaderContentExist : '+isPolicyTermHeaderContentExist+' isTheCoverExist:'+isTheCoverExist);
    }

    public static List<ConnectApi.ManagedContentVersion> getCMSontentByContentIds(List<String> contentIds) {
        //List<String> contentIds = new List<String>();
        System.debug('contentIds :'+contentIds);
        String communityId;
        List<ConnectApi.ManagedContentVersion> results;
        try {
            Network netObj = [select id from Network where name='EC-Reach'];
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
            //System.debug('results : '+results);         
        }
        catch(ConnectApi.ConnectApiException e){
            System.debug('Exception at CMS : '+e.getMessage()+' Stack : '+e.getStackTraceString());
            results = new List<ConnectApi.ManagedContentVersion>();
        }  
        return results;         
    }
}