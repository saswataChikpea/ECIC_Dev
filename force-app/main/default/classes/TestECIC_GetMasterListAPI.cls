@isTest
public with sharing class TestECIC_GetMasterListAPI {
    @isTest
    static void testGetMasterAddressList(){
        
        TestDataFactory.createEcicSettings();
        /*Account acc = TestDataFactory.createAccount();
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
        jsonObject.put('EXP_DATE',pol.Expiry_Date__c);*/
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_GetMasterListAPI.getMasterAddressList();
        Test.stopTest();
    }

    @isTest
    static void testGetMasterCountryList(){
        
        TestDataFactory.createEcicSettings();
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_GetMasterListAPI.getMasterCountryList();
        Test.stopTest();
    }

    @isTest
    static void testGetMasterLegalTypeList(){
        
        TestDataFactory.createEcicSettings();
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_GetMasterListAPI.getMasterLegalTypeList();
        Test.stopTest();
    }

    @isTest
    static void testGetMasterProductCategoryList(){
        
        TestDataFactory.createEcicSettings();
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_GetMasterListAPI.getMasterProductCategoryList();
        Test.stopTest();
    }

    @isTest
    static void testGetMasterTerminationList(){
        
        TestDataFactory.createEcicSettings();
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_GetMasterListAPI.getMasterTerminationList();
        Test.stopTest();
    }
    @isTest
    static void testGetMasterCurrencyList(){
        
        TestDataFactory.createEcicSettings();
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_GetMasterListAPI.getMasterCurrencyList();
        Test.stopTest();
    }
    @isTest
    static void testGetMasterPayMethodList(){
        
        TestDataFactory.createEcicSettings();
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_GetMasterListAPI.getMasterPayMethodList();
        Test.stopTest();
    }

    @isTest
    static void testGetMasterOriginCountryList(){
        
        TestDataFactory.createEcicSettings();
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_GetMasterListAPI.getMasterOriginCountryList();
        Test.stopTest();
    }
    @isTest
    static void testGetMasterDestinCountryList(){
        
        TestDataFactory.createEcicSettings();
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_GetMasterListAPI.getMasterDestinCountryList();
        Test.stopTest();
    }

    @isTest
    static void testGetMasterPortOfLdngList(){
        
        TestDataFactory.createEcicSettings();
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_GetMasterListAPI.getMasterPortOfLdngList();
        Test.stopTest();
    }

    @isTest
    static void testGetMasterInternalMemoList(){
        
        TestDataFactory.createEcicSettings();
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_GetMasterListAPI.getMasterInternalMemoList();
        Test.stopTest();
    }

    @isTest
    static void testGetMasterBuyerCountryList(){
        
        TestDataFactory.createEcicSettings();
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_GetMasterListAPI.getMasterBuyerCountryList();
        Test.stopTest();
    }

    @isTest
    static void testGetMasterRMReasonList(){
        
        TestDataFactory.createEcicSettings();
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_GetMasterListAPI.getMasterRMReasonList();
        Test.stopTest();
    }

    @isTest
    static void testGetMasterProposalReferList(){
        
        TestDataFactory.createEcicSettings();
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_GetMasterListAPI.getMasterProposalReferList();
        Test.stopTest();
    }

    @isTest
    static void testGetMasterIndustryList(){
        
        TestDataFactory.createEcicSettings();
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_GetMasterListAPI.getMasterIndustryList();
        Test.stopTest();
    }

    
}