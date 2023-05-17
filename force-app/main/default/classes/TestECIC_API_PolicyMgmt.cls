@isTest
public with sharing class TestECIC_API_PolicyMgmt {
    @isTest
    static void testApplyPolicyRecordAura(){
        
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
        String res = ECIC_API_PolicyMgmt.applyPolicyRecordAura(jsonObject);
        Test.stopTest();
    }

    @isTest
    static void testAmendPolicyRecordAura(){
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Plan__c prod = TestDataFactory.createProduct('SBP');
        Proposal__c proposal = TestDataFactory.createProposal(acc.id);
        Quote__c quote = TestDataFactory.createQuotation(acc.id);
        Policy__c pol = TestDataFactory.createPolicyWithSchedule(prod.id,acc.id);
        Map<String, Object> jsonObject = new Map<String, Object>();
        //jsonObject.put('ACCOUNT_ID',acc.id);
        //jsonObject.put('PROPOSAL_ID',proposal.id);
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
        String res = ECIC_API_PolicyMgmt.amendPolicyRecordAura(jsonObject);
        Test.stopTest();
    }

    @isTest
    static void testCheckPolicyDetailsAura(){
        
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Plan__c prod = TestDataFactory.createProduct('SBP');
        Proposal__c proposal = TestDataFactory.createProposal(acc.id);
        Quote__c quote = TestDataFactory.createQuotation(acc.id);
        Policy__c pol = TestDataFactory.createPolicyWithSchedule(prod.id,acc.id);
        Map<String, Object> jsonObject = new Map<String, Object>();
        jsonObject.put('PCY_TYPE',pol.Legacy_Policy_Type__c);
        jsonObject.put('BR_NO','12345678');

        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_API_PolicyMgmt.checkPolicyDetailsAura('70','12345678');
        Test.stopTest();
    }

    @isTest
    static void testCheckOtherPHCompAura(){
        
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Plan__c prod = TestDataFactory.createProduct('SBP');
        Proposal__c proposal = TestDataFactory.createProposal(acc.id);
        Quote__c quote = TestDataFactory.createQuotation(acc.id);
        Policy__c pol = TestDataFactory.createPolicyWithSchedule(prod.id,acc.id);
        Map<String, Object> jsonObject = new Map<String, Object>();
        jsonObject.put('PCY_TYPE',pol.Legacy_Policy_Type__c);
        jsonObject.put('BR_NO','12345678');

        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_API_PolicyMgmt.checkOtherPHCompAura('12345678');
        Test.stopTest();
    }
    @isTest
    static void testCheckProblemPHCompAura(){
        
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Plan__c prod = TestDataFactory.createProduct('SBP');
        Proposal__c proposal = TestDataFactory.createProposal(acc.id);
        Quote__c quote = TestDataFactory.createQuotation(acc.id);
        Policy__c pol = TestDataFactory.createPolicyWithSchedule(prod.id,acc.id);
        Map<String, Object> jsonObject = new Map<String, Object>();
        jsonObject.put('PCY_TYPE',pol.Legacy_Policy_Type__c);
        jsonObject.put('BR_NO','12345678');

        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_API_PolicyMgmt.checkProblemPHCompAura('12345678');
        Test.stopTest();
    }

    @isTest
    static void testCheckHoldOSOnlinePlcyAura(){
        
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Plan__c prod = TestDataFactory.createProduct('SBP');
        Proposal__c proposal = TestDataFactory.createProposal(acc.id);
        Quote__c quote = TestDataFactory.createQuotation(acc.id);
        Policy__c pol = TestDataFactory.createPolicyWithSchedule(prod.id,acc.id);
        Map<String, Object> jsonObject = new Map<String, Object>();
        jsonObject.put('PCY_TYPE',pol.Legacy_Policy_Type__c);
        jsonObject.put('BR_NO','12345678');

        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_API_PolicyMgmt.checkHoldOSOnlinePlcyAura('70','12345678');
        Test.stopTest();
    }
    @isTest
    static void testCheckHoldOfflinePlcyAura(){
        
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Plan__c prod = TestDataFactory.createProduct('SBP');
        Proposal__c proposal = TestDataFactory.createProposal(acc.id);
        Quote__c quote = TestDataFactory.createQuotation(acc.id);
        Policy__c pol = TestDataFactory.createPolicyWithSchedule(prod.id,acc.id);
        Map<String, Object> jsonObject = new Map<String, Object>();
        jsonObject.put('PCY_TYPE',pol.Legacy_Policy_Type__c);
        jsonObject.put('BR_NO','12345678');

        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_API_PolicyMgmt.checkHoldOfflinePlcyAura('70','12345678');
        Test.stopTest();
    }
    @isTest
    static void testCheckTermOthPcyPHAura(){
        
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Plan__c prod = TestDataFactory.createProduct('SBP');
        Proposal__c proposal = TestDataFactory.createProposal(acc.id);
        Quote__c quote = TestDataFactory.createQuotation(acc.id);
        Policy__c pol = TestDataFactory.createPolicyWithSchedule(prod.id,acc.id);
        Map<String, Object> jsonObject = new Map<String, Object>();
        jsonObject.put('PCY_TYPE',pol.Legacy_Policy_Type__c);
        jsonObject.put('BR_NO','12345678');

        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_API_PolicyMgmt.checkTermOthPcyPHAura('12345678');
        Test.stopTest();
    }

    @isTest
    static void testApplyProposalAura(){
        
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Plan__c prod = TestDataFactory.createProduct('SBP');
        Proposal__c proposal = TestDataFactory.createProposal(acc.id);
        Quote__c quote = TestDataFactory.createQuotation(acc.id);
        Policy__c pol = TestDataFactory.createPolicyWithSchedule(prod.id,acc.id);
        Map<String, Object> jsonObject = new Map<String, Object>();
        jsonObject.put('ACCOUNT_ID',acc.id);
        jsonObject.put('PROPOSAL_ID',proposal.id);
        jsonObject.put('PCY_TYPE',pol.Legacy_Policy_Type__c);
        jsonObject.put('RECV_DATE','2021-05-11');
        jsonObject.put('BR_NO','12345678');
        jsonObject.put('STS','O');
        /*jsonObject.put('ISS_DATE','12345678');
        jsonObject.put('EXP_LAST_FY_TOT_TO','12345678');
        jsonObject.put('EXP_LAST_FY_LC_TO','12345678');
        jsonObject.put('EXP_LAST_FY_DP_DA_OA_TO','12345678');
        jsonObject.put('EXP_NEXT_FY_TOT_TO','12345678');
        jsonObject.put('EXP_NEXT_FY_LC_TO','12345678');
        jsonObject.put('EXP_NEXT_FY_DP_DA_OA_TO','12345678');
        jsonObject.put('BYR_CNT_UP_TO_1M','12345678');
        jsonObject.put('BYR_CNT_1M_TO_5M','12345678');
        jsonObject.put('BYR_CNT_OVER_5M','12345678');
        jsonObject.put('LAST_BYR_CNT_UP_TO_1M','12345678');
        jsonObject.put('LAST_BYR_CNT_1M_TO_5M','12345678');
        jsonObject.put('LAST_BYR_CNT_OVER_5M','12345678');*/
        jsonObject.put('LAST_2_YR_BAD_DEBT',1);
        jsonObject.put('OVER_30_DAY_OD_AMT',1);
        jsonObject.put('IND_CODE','03');
        jsonObject.put('COMMENCE_DATE','2021-07-01');
        jsonObject.put('SETUP_DATE','2010-01-01');
        jsonObject.put('LEGAL_TYPE','PROP');
        jsonObject.put('BR_EXP_DATE','2021-12-12');
        jsonObject.put('OFF_ADDR_1','ROOM C-D, 14/F,');
        jsonObject.put('OFF_ADDR_4','LAI CHI KOK,');

        jsonObject.put('OFF_ADDR_DIST','CENTRAL');
        jsonObject.put('COR_ADDR_4','LAI CHI KOK,');
        jsonObject.put('COR_ADDR_DIST','CENTRAL');
        jsonObject.put('LANG_TYPE','E');
        jsonObject.put('CONT_PERSON_ID','0010l00001IGyYnAAL');
        jsonObject.put('CONT_PERSON_NAME','Chan Tai Man');
        jsonObject.put('CONT_PERSON_TITLE','Manager');
        jsonObject.put('CONT_PERSON_EMAIL','test@hkecic.com');
        jsonObject.put('CONT_PERSON_MOBILE','55667788');
        
        /*
        jsonObject.put('DOM_LAST_FY_TOT_TO','12345678');
        jsonObject.put('DOM_LAST_FY_LC_TO','12345678');
        jsonObject.put('DOM_LAST_FY_DP_DA_OA_TO','12345678');
        jsonObject.put('DOM_NEXT_FY_TOT_TO','12345678');
        jsonObject.put('DOM_NEXT_FY_LC_TO','12345678');
        jsonObject.put('DOM_NEXT_FY_DP_DA_OA_TO','12345678');
        jsonObject.put('IM_PCT','12345678');
        jsonObject.put('REF_BY_LIST','12345678');
        jsonObject.put('BIZ_NATURE','12345678');*/



        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_API_PolicyMgmt.applyProposalAura(jsonObject);
        Test.stopTest();
    }

    @isTest
    static void testAmendProposalAura(){
        
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Plan__c prod = TestDataFactory.createProduct('SBP');
        Proposal__c proposal = TestDataFactory.createProposal(acc.id);
        Quote__c quote = TestDataFactory.createQuotation(acc.id);
        Policy__c pol = TestDataFactory.createPolicyWithSchedule(prod.id,acc.id);
        Map<String, Object> jsonObject = new Map<String, Object>();
        jsonObject.put('ACCOUNT_ID',acc.id);
        jsonObject.put('PROPOSAL_ID',proposal.id);
        jsonObject.put('PCY_TYPE',pol.Legacy_Policy_Type__c);
        jsonObject.put('RECV_DATE','2021-05-11');
        jsonObject.put('BR_NO','12345678');
        jsonObject.put('STS','O');
        jsonObject.put('LAST_2_YR_BAD_DEBT',1);
        jsonObject.put('OVER_30_DAY_OD_AMT',1);
        jsonObject.put('IND_CODE','03');
        jsonObject.put('COMMENCE_DATE','2021-07-01');
        jsonObject.put('SETUP_DATE','2010-01-01');
        jsonObject.put('LEGAL_TYPE','PROP');
        jsonObject.put('BR_EXP_DATE','2021-12-12');
        jsonObject.put('OFF_ADDR_1','ROOM C-D, 14/F,');
        jsonObject.put('OFF_ADDR_4','LAI CHI KOK,');

        jsonObject.put('OFF_ADDR_DIST','CENTRAL');
        jsonObject.put('COR_ADDR_4','LAI CHI KOK,');
        jsonObject.put('COR_ADDR_DIST','CENTRAL');
        jsonObject.put('LANG_TYPE','E');
        jsonObject.put('CONT_PERSON_ID','0010l00001IGyYnAAL');
        jsonObject.put('CONT_PERSON_NAME','Chan Tai Man');
        jsonObject.put('CONT_PERSON_TITLE','Manager');
        jsonObject.put('CONT_PERSON_EMAIL','test@hkecic.com');
        jsonObject.put('CONT_PERSON_MOBILE','55667788');
        



        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_API_PolicyMgmt.amendProposalAura(jsonObject);
        Test.stopTest();
    }

    @isTest
    static void testApplyQuoteAura(){
        
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
        jsonObject.put('CUS_NO','372496');
        jsonObject.put('PCY_TYPE',pol.Legacy_Policy_Type__c);
        jsonObject.put('ISS_DATE','5/8/2021');
        jsonObject.put('ACC_DATE','25/6/2021');
        //jsonObject.put('QUO_EXP_DATE','12345678');
        



        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_API_PolicyMgmt.applyQuoteAura(jsonObject);
        Test.stopTest();
    }

    @isTest
    static void testAmmendQuoteAura(){
        
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
        jsonObject.put('CUS_NO','372496');
        jsonObject.put('PCY_TYPE',pol.Legacy_Policy_Type__c);
        jsonObject.put('ISS_DATE','5/8/2021');
        jsonObject.put('ACC_DATE','25/6/2021');
        jsonObject.put('STS','AC');
        



        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_API_PolicyMgmt.ammendQuoteAura(jsonObject);
        Test.stopTest();
    }

    @isTest
    static void testAddPolicySchedule1Aura(){
        
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Plan__c prod = TestDataFactory.createProduct('SBP');
        Proposal__c proposal = TestDataFactory.createProposal(acc.id);
        Quote__c quote = TestDataFactory.createQuotation(acc.id);
        Policy__c pol = TestDataFactory.createPolicyWithSchedule(prod.id,acc.id);
        Policy_Schedule__c polSchedule = TestDataFactory.createPolicySchedule(pol.id); 
        Map<String, Object> jsonObject = new Map<String, Object>();
        jsonObject.put('POLICY_ID',pol.id);
        jsonObject.put('POLICY_S1_ID',polSchedule.id);
        jsonObject.put('CUS_NO','372496');
        jsonObject.put('PCY_TYPE',pol.Legacy_Policy_Type__c);
        jsonObject.put('ISS_DATE','2021-12-15');
        jsonObject.put('COMMENCE_DATE','2021-07-15');
        jsonObject.put('EFF_DATE','2021-07-15');
        jsonObject.put('EXP_DATE','2021-07-15');
        jsonObject.put('STS','W');

        jsonObject.put('ML',500000);
        jsonObject.put('PCY_DEPOSIT',1000);
        jsonObject.put('IM_PCT',90);
        jsonObject.put('PCY_FEE',1500);
        jsonObject.put('NQL',50000);
        jsonObject.put('EX_RISK','REPD');
        



        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_API_PolicyMgmt.addPolicySchedule1Aura(jsonObject);
        Test.stopTest();
    }

    @isTest
    static void testAddPolicySchedule2Aura(){
        
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Plan__c prod = TestDataFactory.createProduct('SBP');
        Proposal__c proposal = TestDataFactory.createProposal(acc.id);
        Quote__c quote = TestDataFactory.createQuotation(acc.id);
        Policy__c pol = TestDataFactory.createPolicyWithSchedule(prod.id,acc.id);
        Policy_Schedule__c polSchedule = TestDataFactory.createPolicySchedule(pol.id); 
        Map<String, Object> jsonObject = new Map<String, Object>();
        jsonObject.put('POLICY_ID',pol.id);
        jsonObject.put('POLICY_S2_ID',polSchedule.id);
        jsonObject.put('CUS_NO','372496');
        jsonObject.put('PCY_TYPE',pol.Legacy_Policy_Type__c);
        jsonObject.put('ISS_DATE','2021-12-15');
        //jsonObject.put('COMMENCE_DATE','2021-07-15');
        jsonObject.put('EFF_DATE','2021-07-15');
        jsonObject.put('EXP_DATE','2021-07-15');
        jsonObject.put('STS','W');

        jsonObject.put('LDG_PCT',35);
        jsonObject.put('PRE_LDG_PCT',0);
        List<String> portOfLoading=new List<String>();
        portOfLoading.add('India');
        jsonObject.put('PORT_OF_LDG',portOfLoading);
        jsonObject.put('CTRY_CODE',1500);
        
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_API_PolicyMgmt.addPolicySchedule2Aura(jsonObject);
        Test.stopTest();
    }

    @isTest
    static void testAddPolicySchedule3Aura(){
        
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Plan__c prod = TestDataFactory.createProduct('SBP');
        Proposal__c proposal = TestDataFactory.createProposal(acc.id);
        Quote__c quote = TestDataFactory.createQuotation(acc.id);
        Policy__c pol = TestDataFactory.createPolicyWithSchedule(prod.id,acc.id);
        Policy_Schedule__c polSchedule = TestDataFactory.createPolicySchedule(pol.id); 
        Map<String, Object> jsonObject = new Map<String, Object>();
        jsonObject.put('POLICY_ID',pol.id);
        jsonObject.put('QUOTATION_ID',quote.id);
        
        jsonObject.put('POLICY_S3_ID',polSchedule.id);
        jsonObject.put('CUS_NO','372496');
        jsonObject.put('PCY_TYPE',pol.Legacy_Policy_Type__c);
        jsonObject.put('ISS_DATE','2021-12-15');
        jsonObject.put('COMMENCE_DATE','2021-07-15');
        jsonObject.put('EFF_DATE','2021-07-15');
        jsonObject.put('EXP_DATE','2021-07-15');
        jsonObject.put('STS','W');

        jsonObject.put('REBATE_PCT',15);
        
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_API_PolicyMgmt.addPolicySchedule3Aura(jsonObject);
        Test.stopTest();
    }

    @isTest
    static void testUpdatePolicyStatus(){
        
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Plan__c prod = TestDataFactory.createProduct('SBP');
        Proposal__c proposal = TestDataFactory.createProposal(acc.id);
        Quote__c quote = TestDataFactory.createQuotation(acc.id);
        Policy__c pol = TestDataFactory.createPolicyWithSchedule(prod.id,acc.id);
        Set<String> policyIDset =  new Set<String>();
        policyIDset.add(pol.id);
        Policy_Schedule__c polSchedule = TestDataFactory.createPolicySchedule(pol.id); 
        /*Map<String, Object> jsonObject = new Map<String, Object>();
        jsonObject.put('POLICY_ID',pol.id);
        jsonObject.put('QUOTATION_ID',quote.id);
        
        jsonObject.put('POLICY_S3_ID',polSchedule.id);
        jsonObject.put('CUS_NO','372496');
        jsonObject.put('PCY_TYPE',pol.Legacy_Policy_Type__c);
        jsonObject.put('ISS_DATE','2021-12-15');
        jsonObject.put('COMMENCE_DATE','2021-07-15');
        jsonObject.put('EFF_DATE','2021-07-15');
        jsonObject.put('EXP_DATE','2021-07-15');
        jsonObject.put('STS','W');

        jsonObject.put('REBATE_PCT',15);*/
        
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_API_PolicyMgmt.updatePolicyStatus(policyIDset);
        Test.stopTest();
    }

    @isTest
    static void testUpdatePolicyCCFAura(){
        
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Plan__c prod = TestDataFactory.createProduct('SBP');
        Proposal__c proposal = TestDataFactory.createProposal(acc.id);
        Quote__c quote = TestDataFactory.createQuotation(acc.id);
        Policy__c pol = TestDataFactory.createPolicyWithSchedule(prod.id,acc.id);
        Set<String> policyIDset =  new Set<String>();
        policyIDset.add(pol.id);
        Policy_Schedule__c polSchedule = TestDataFactory.createPolicySchedule(pol.id); 
        /*Map<String, Object> jsonObject = new Map<String, Object>();
        jsonObject.put('POLICY_ID',pol.id);
        jsonObject.put('QUOTATION_ID',quote.id);
        
        jsonObject.put('POLICY_S3_ID',polSchedule.id);
        jsonObject.put('CUS_NO','372496');
        jsonObject.put('PCY_TYPE',pol.Legacy_Policy_Type__c);
        jsonObject.put('ISS_DATE','2021-12-15');
        jsonObject.put('COMMENCE_DATE','2021-07-15');
        jsonObject.put('EFF_DATE','2021-07-15');
        jsonObject.put('EXP_DATE','2021-07-15');
        jsonObject.put('STS','W');

        jsonObject.put('REBATE_PCT',15);*/
        
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_API_PolicyMgmt.updatePolicyCCFAura(pol.id);
        Test.stopTest();
    }

    @isTest
    static void testAddShipmentDetailsAura(){
        
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Plan__c prod = TestDataFactory.createProduct('SBP');
        Proposal__c proposal = TestDataFactory.createProposal(acc.id);
        Quote__c quote = TestDataFactory.createQuotation(acc.id);
        Policy__c pol = TestDataFactory.createPolicyWithSchedule(prod.id,acc.id);
        Set<String> policyIDset =  new Set<String>();
        policyIDset.add(pol.id);
        Policy_Schedule__c polSchedule = TestDataFactory.createPolicySchedule(pol.id); 
        Map<String, Object> jsonObject = new Map<String, Object>();
        
        jsonObject.put('SHIPMENT_ID','123456789012345678');
        jsonObject.put('RECV_DATE','2021-09-06');
        jsonObject.put('CUS_NO','372496');
        jsonObject.put('PCY_TYPE',pol.Legacy_Policy_Type__c);
        jsonObject.put('DE_METHOD','I');
        jsonObject.put('IS_PRE_SHP','Y');
        jsonObject.put('IS_OVERSEA_SUBS','N');
        jsonObject.put('BYR_CTRY','USA');
        jsonObject.put('BYR_CODE','000001');
        jsonObject.put('SHP_DATE','2021-09-06');
        jsonObject.put('ORG_CUR','USD');

        jsonObject.put('ORG_GIV',1000);
        jsonObject.put('EXCH_RATE',7.714);
        jsonObject.put('GIV',1000);
        jsonObject.put('PAY_METHOD','OA');
        jsonObject.put('PAY_PERIOD',120);
        jsonObject.put('DUE_DATE','2021-07-15');
        jsonObject.put('ENDR_NO','EN49A');
        jsonObject.put('PORT_OF_LDG','CHN');
        jsonObject.put('OGR_CTRY','CHN');
        jsonObject.put('DEST_CTRY','CHN');
        jsonObject.put('HRM_CODE','98010000');
        
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_API_PolicyMgmt.addShipmentDetailsAura(jsonObject);
        Test.stopTest();
    }

    @isTest
    static void testAmendShipmentDetailsAura(){
        
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Plan__c prod = TestDataFactory.createProduct('SBP');
        Proposal__c proposal = TestDataFactory.createProposal(acc.id);
        Quote__c quote = TestDataFactory.createQuotation(acc.id);
        Policy__c pol = TestDataFactory.createPolicyWithSchedule(prod.id,acc.id);
        Set<String> policyIDset =  new Set<String>();
        policyIDset.add(pol.id);
        Policy_Schedule__c polSchedule = TestDataFactory.createPolicySchedule(pol.id); 
        Map<String, Object> jsonObject = new Map<String, Object>();
        
        jsonObject.put('SHIPMENT_ID','123456789012345678');
        jsonObject.put('RECV_DATE','2021-09-06');
        jsonObject.put('CUS_NO','372496');
        jsonObject.put('PCY_TYPE',pol.Legacy_Policy_Type__c);
        jsonObject.put('DE_METHOD','I');
        jsonObject.put('IS_PRE_SHP','Y');
        jsonObject.put('IS_OVERSEA_SUBS','N');
        jsonObject.put('BYR_CTRY','USA');
        jsonObject.put('BYR_CODE','000001');
        jsonObject.put('SHP_DATE','2021-09-06');
        jsonObject.put('ORG_CUR','USD');

        jsonObject.put('ORG_GIV',1000);
        jsonObject.put('EXCH_RATE',7.714);
        jsonObject.put('GIV',1000);
        jsonObject.put('PAY_METHOD','OA');
        jsonObject.put('PAY_PERIOD',120);
        jsonObject.put('DUE_DATE','2021-07-15');
        jsonObject.put('ENDR_NO','EN49A');
        jsonObject.put('PORT_OF_LDG','CHN');
        jsonObject.put('OGR_CTRY','CHN');
        jsonObject.put('DEST_CTRY','CHN');
        jsonObject.put('HRM_CODE','98010000');
        
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_API_PolicyMgmt.amendShipmentDetailsAura(jsonObject);
        Test.stopTest();
    }

    @isTest
    static void testSettleAccountPaymentAura(){
        
        TestDataFactory.createEcicSettings();
        Account acc = TestDataFactory.createAccount();
        Plan__c prod = TestDataFactory.createProduct('SBP');
        Proposal__c proposal = TestDataFactory.createProposal(acc.id);
        Quote__c quote = TestDataFactory.createQuotation(acc.id);
        Policy__c pol = TestDataFactory.createPolicyWithSchedule(prod.id,acc.id);
        Set<String> policyIDset =  new Set<String>();
        policyIDset.add(pol.id);
        Policy_Schedule__c polSchedule = TestDataFactory.createPolicySchedule(pol.id); 
        Map<String, Object> jsonObject = new Map<String, Object>();
        
        jsonObject.put('INVOICE_ID','123456789012345678');
        jsonObject.put('INV_DATE','2021-09-06');
        jsonObject.put('CUS_NO','372496');
        jsonObject.put('PCY_TYPE',pol.Legacy_Policy_Type__c);
        jsonObject.put('DUE_DATE','2021-10-01');
        jsonObject.put('RMDR_DATE_1','2021-10-01');
        jsonObject.put('RMDR_DATE_2','2021-10-01');
        jsonObject.put('INSTL_TYPE','F');
        jsonObject.put('SEQ_NO',1);
        jsonObject.put('PAID_DATE','2021-10-01');
        jsonObject.put('PCY_EFF_DATE','2021-10-01');

        jsonObject.put('ML',1000);
        jsonObject.put('PRM_RATE',1);
        jsonObject.put('PRM',1);
        jsonObject.put('DIS_RATE',1);
        jsonObject.put('DIS_AMT',1);
        jsonObject.put('NET_PRM',1);
        jsonObject.put('PAID_AMT',1);
        
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        
        
        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock); 
        String res = ECIC_API_PolicyMgmt.settleAccountPaymentAura(jsonObject);
        Test.stopTest();
    }
}