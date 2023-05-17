@isTest
public with sharing class ContentManagementSystemTest {
    @isTest
    static void firstMethohd(){
        String user_id = TestDataFactory.testDataSetupSecond();
        ContentManagementSystem.getPublishedContentIds(user_id);
    }
    @isTest
    static void SecondMethohd(){
        Plan__c prodSBP= new Plan__c();
        prodSBP.name='SBP';
        prodSBP.Max_Authorised_Person_Count__c=10;
        prodSBP.Max_Beneficiary_Count__c=10;
        prodSBP.Max_Director_Count__c=10;
        insert prodSBP;

        CMS_Content__c cms = new CMS_Content__c();
        cms.Content_Id__c='123456789';
        cms.Content_URL__c='https://kennychun--dev2.lightning.force.com/lightning/cms/spaces/0Zu0l0000008ON5CAM/content/20Y0l00000000DyEAI/5OU0l00000000ZmGAI';
        cms.Product__c=prodSBP.id;
        cms.Published_Date__c=Date.today();
        cms.Status__c='Published';
        insert cms;
        List<String> contentIds = new List<String>();
        for(CMS_Content__c cms1 : [select Content_Id__c from CMS_Content__c where id =:cms.id]){
            contentIds.add(cms1.Content_Id__c);
        }
        
        ContentManagementSystem.getCMSontentByContentIdsV1(contentIds);
    }
}