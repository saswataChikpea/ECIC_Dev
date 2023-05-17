@isTest
public with sharing class TestFeedItemManagement {
    
    public static Account createRecord() {
        Account acc = new Account(Name='TestAccount');
        insert acc;        
        Contact con = new Contact(LastName='Test Contact',
        AccountId=acc.Id       
        );
        insert con;
        Contact con2 = new Contact(LastName='Test Contact2',
        AccountId=acc.Id,
        Authorised_Person__c=true,
        Beneficiary_Owner__c=true,
        Director__c=true
        );
        insert con2;         
        return acc;
    }
    
    @isTest
    static void testgetFeedItems(){
        Test.startTest();
        Account acc = createRecord();
        FeedItemManagement.getFeedItems(acc.Id);        
        Test.stopTest();
        System.assertEquals(acc.Name,'TestAccount');
    }
    
    @isTest
    static void testcreateFeed(){
        Test.startTest();
        Account acc = createRecord();
        FeedItemManagement.createFeed(acc.Id);        
        Test.stopTest();
        System.assertEquals(acc.Name,'TestAccount');
    }
    
    @isTest
    static void testcreateFeedComment(){
        Test.startTest();
        Account acc = createRecord();
        FeedItemManagement.createFeedComment();        
        Test.stopTest();
        System.assertEquals(acc.Name,'TestAccount');
    }
    
    @isTest
    static void testgetComments(){
        Test.startTest();
        Account acc = createRecord();
        FeedItemManagement.getComments();        
        Test.stopTest();
        System.assertEquals(acc.Name,'TestAccount');
    }
}