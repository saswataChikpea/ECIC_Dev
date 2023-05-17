@isTest
public with sharing class TestCreateContact {
       
    @isTest
    static void testCreateContactclass(){
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
        Custom_Contact__c cc = new Custom_Contact__c(Contact_Last_Name__c='aa');
        insert cc;
        ECIC_Custom_Event__c ec = new ECIC_Custom_Event__c(Name ='a', Account__c = Acc.id);
        insert ec;   
        list<ECIC_Custom_Event__c> ec1 = [select id from ECIC_Custom_Event__c where ECIC_Custom_Event__c.Name ='a'];
        ec1[0].Status__c = 'Accepted';
        ec1[0].Event_Id__c =null;        
        update ec1;        
    }
}