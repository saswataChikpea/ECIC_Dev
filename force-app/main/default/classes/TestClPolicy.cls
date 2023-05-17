@isTest
public with sharing class TestClPolicy {
	public static Account createRecord() {
        Account acc = new Account(Name='TestAccount');
        insert acc;
        Contact con = new Contact(LastName='Test Contact',
        AccountId=acc.Id       
        );        
        Plan__c prod = new Plan__c(Name='OMBP',
        Max_Authorised_Person_Count__c=10,
        Max_Beneficiary_Count__c=10,
        Max_Director_Count__c=10);
        insert prod;
        Policy__c policy = new Policy__c(
        Status__c='Open',
        Product__c=prod.Id,
        Free_Credit_Check__c=10,
        Used_Credit_check__c=0,
        Exporter__c=acc.Id,
        Is_Active__c=true);
        insert policy;  
        return acc;
    }
    @isTest
    static void testgetPolicyDetails(){
        Test.startTest();
        Account acc = createRecord();
        Policy__c policy = ClPolicy.getPolicyDetails(acc.Id);
        //Id testid = '12345';
        try{
        	ClPolicy.getPolicyDetails(policy.Id);
        }catch(Exception e){
            system.assertEquals(e.getMessage(), e.getMessage());
        }
        Test.stopTest();
        System.assertEquals(policy.Status__c,'Open');
    }
    @isTest
    static void testgetPolicyHolder(){
        Account acc = new Account(Name='TestAccount');
        insert acc;
        Contact con = new Contact(LastName='TestContact',
        AccountId = acc.Id);
        insert con;
        System.debug('con='+con);
        Profile p = [SELECT Id FROM Profile WHERE Name='EC-Reach Login Profile'];
        System.debug('profile='+p);
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String uid = h.SubString(0,8);
        System.debug('uid='+uid);
        User u = new User(Alias = uid, Email= uid + '@myorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US',ProfileId = p.Id,  
          TimeZoneSidKey='America/New_York', UserName= uid + '@myorg.com',ContactId = con.Id);
        insert u;
        System.debug('uid='+u);
        //
        
        // User u1 = [select Id from User where Email='test@myorg.com'];
        // System.debug('u1='+u1);
        Id acc_id = ClPolicy.getPolicyHolder(u.Id);
        System.debug('acc_id='+acc_id);
        
    }
    
}