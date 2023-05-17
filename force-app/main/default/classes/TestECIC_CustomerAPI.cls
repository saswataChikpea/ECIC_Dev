@isTest
public with sharing class TestECIC_CustomerAPI {
    @isTest
    static void testGetCustBR(){
        
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Plan__c prod = TestDataFactory.createProduct('SBP');
        Proposal__c proposal = TestDataFactory.createProposal(acc.id);
        Quote__c quote = TestDataFactory.createQuotation(acc.id);
        Policy__c pol = TestDataFactory.createPolicyWithSchedule(prod.id,acc.id);
        Map<String, Object> jsonObject = new Map<String, Object>();
        jsonObject.put('ACCOUNT_ID',acc.id);
        jsonObject.put('PROPOSAL_ID',proposal.id);
        jsonObject.put('QUOTATION_ID',quote.id);
        jsonObject.put('POLICY_ID',pol.id);
        jsonObject.put('REQ_TYPE','N');
        jsonObject.put('CUS_NO',acc.Legacy_Customer_Number__c);
        jsonObject.put('PCY_TYPE',pol.Legacy_Policy_Type__c);
        jsonObject.put('COMMERCE_DATE',pol.Commencement_Date__c);
        jsonObject.put('EFF_DATE',pol.Effective_Date__c);
        jsonObject.put('EXP_DATE',pol.Expiry_Date__c);
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_CustomerAPI.getCustBR('345678');
        Test.stopTest();
    }

    @isTest
    static void testAddContactPerson(){
        
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Plan__c prod = TestDataFactory.createProduct('SBP');
        Proposal__c proposal = TestDataFactory.createProposal(acc.id);
        Quote__c quote = TestDataFactory.createQuotation(acc.id);
        Policy__c pol = TestDataFactory.createPolicyWithSchedule(prod.id,acc.id);
        Contact con = TestDataFactory.createContact(acc.id);
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_CustomerAPI.addContactPerson(con.Id);
        Test.stopTest();
    }

    @isTest
    static void testAmendConPerson(){
        
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Plan__c prod = TestDataFactory.createProduct('SBP');
        Proposal__c proposal = TestDataFactory.createProposal(acc.id);
        Quote__c quote = TestDataFactory.createQuotation(acc.id);
        Policy__c pol = TestDataFactory.createPolicyWithSchedule(prod.id,acc.id);
        Contact con = TestDataFactory.createContact(acc.id);
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        // String res = ECIC_CustomerAPI.amendConPerson(con);
        Test.stopTest();
    }

    @isTest
    static void testDeleteConPerson(){
        
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Plan__c prod = TestDataFactory.createProduct('SBP');
        Proposal__c proposal = TestDataFactory.createProposal(acc.id);
        Quote__c quote = TestDataFactory.createQuotation(acc.id);
        Policy__c pol = TestDataFactory.createPolicyWithSchedule(prod.id,acc.id);
        Contact con = TestDataFactory.createContact(acc.id);
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        // String res = ECIC_CustomerAPI.deleteConPerson(con);
        Test.stopTest();
    }

    @isTest
    static void testUpdateCustomer(){
        
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Plan__c prod = TestDataFactory.createProduct('SBP');
        Proposal__c proposal = TestDataFactory.createProposal(acc.id);
        Quote__c quote = TestDataFactory.createQuotation(acc.id);
        Policy__c pol = TestDataFactory.createPolicyWithSchedule(prod.id,acc.id);
        Contact con = TestDataFactory.createContact(acc.id);
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        // String res = ECIC_CustomerAPI.updateCustomer(acc.id,acc);
        Test.stopTest();
    }

    @isTest
    static void testGetNFCRecordAura(){
        
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Plan__c prod = TestDataFactory.createProduct('SBP');
        Proposal__c proposal = TestDataFactory.createProposal(acc.id);
        Quote__c quote = TestDataFactory.createQuotation(acc.id);
        Policy__c pol = TestDataFactory.createPolicyWithSchedule(prod.id,acc.id);
        Contact con = TestDataFactory.createContact(acc.id);
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_CustomerAPI.getNFCRecordAura(acc.Legacy_Customer_Number__c);
        Test.stopTest();
    }
    @isTest
    static void testCreateNFCRecordAura(){
        
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Plan__c prod = TestDataFactory.createProduct('SBP');
        Proposal__c proposal = TestDataFactory.createProposal(acc.id);
        Quote__c quote = TestDataFactory.createQuotation(acc.id);
        Policy__c pol = TestDataFactory.createPolicyWithSchedule(prod.id,acc.id);
        Contact con = TestDataFactory.createContact(acc.id);
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_CustomerAPI.createNFCRecordAura(acc.Legacy_Customer_Number__c);
        Test.stopTest();
    }

    @isTest
    static void testGetOfflinePolicy(){
        
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Plan__c prod = TestDataFactory.createProduct('SBP');
        Proposal__c proposal = TestDataFactory.createProposal(acc.id);
        Quote__c quote = TestDataFactory.createQuotation(acc.id);
        Policy__c pol = TestDataFactory.createPolicyWithSchedule(prod.id,acc.id);
        Contact con = TestDataFactory.createContact(acc.id);
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_CustomerAPI.getOfflinePolicy('12345678');
        Test.stopTest();
    }
}