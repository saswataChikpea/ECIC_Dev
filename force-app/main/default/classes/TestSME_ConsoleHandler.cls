@isTest
public with sharing class TestSME_ConsoleHandler {
    

    @isTest
    static void testApplyPolicyRecordAura(){
        
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        // SME_ConsoleHandler.getNFCRecordFromLegacy(acc.id);
        Test.stopTest();
    }
}