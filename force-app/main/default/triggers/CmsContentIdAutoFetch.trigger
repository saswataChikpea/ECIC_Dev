trigger CmsContentIdAutoFetch on CMS_Content__c (before insert ) {
    
    for(CMS_Content__c cms:Trigger.new){
       
        //List<CMS_Content__c> url = new List<CMS_Content__c>();
       
        string url = cms.Content_URL__c;
        string[] splitted = url.split('content');
        //cms.Content_Id__c = splitted[1];
        string splitted1 = splitted[1];  // https://kennychun--dev2.lightning.force.com/lightning/cms/spaces/0Zu0l0000008ON5CAM/content
                                        //  /20Y0l00000000CNEAY/5OU0l00000000ckGAA
        system.debug(splitted[1]);      //   20Y0l00000000CNEAY
        string[] splitted2 = splitted1.split('\\/');
        system.debug(splitted2[1]);
        cms.Content_Id__c = splitted2[1];
        cms.Version_Id__c = splitted2[2];
        
        
        
    }
    
}