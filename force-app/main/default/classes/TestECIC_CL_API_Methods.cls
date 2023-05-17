@isTest
public with sharing class TestECIC_CL_API_Methods {
    public static List<Credit_Limit_Application__c> createRecord(Integer count) {
        List_Storage__c list_storage = new List_Storage__c(
            ByrCtry_Country_Code__c = 'USA',
            ByrCtry_Country_Name__c = 'UNITED STATES OF AMERICA',
            List_Type__c = 'Buyer Country'
        );
        insert list_storage;
        Account acc = new Account(Name='TestAccount');
        insert acc;
        
        Plan__c prod = new Plan__c(Name='SBP',
        Max_Authorised_Person_Count__c=10,
        Max_Beneficiary_Count__c=10,
        Max_Director_Count__c=10);
        insert prod;
        Policy__c policy = new Policy__c(
        Status__c='Open',
        Product__c=prod.Id,
        Free_Credit_Check__c=10,
        Used_Credit_check__c=0,
        Commencement_Date__c=Date.today().addMonths(-13),
        Issue_Date__c=Date.today().addDays(-5),
        Exporter__c=acc.Id,        
        Is_Active__c=true);
        insert policy;
        Policy_Schedule__c schedule = new Policy_Schedule__c(
        Policy__c=policy.Id,
        Effective_Date__c=Date.today().addDays(-5),
        Issue_Date__c=Date.today().addDays(-5),
        Maximum_Liability__c=150000,
        Type__c='Schedule 1'
        );
        insert schedule;
        Date application_date = Date.today().addDays(-5);
        List<Credit_Limit__c> clList = new List<Credit_Limit__c>();
        // Credit_Limit__c cla;
        List<Credit_Limit_Application__c> claList = new List<Credit_Limit_Application__c>();
        for (Integer i=0;i<count;i++){
            Credit_Limit_Application__c cl_app = new Credit_Limit_Application__c(
                Buyer_Name__c='ABC',
                Buyer_Code__c='12345',
                Buyer_Address_Line_1__c='abab',
                Buyer_Address_Line_2__c='iopipo',
                Buyer_Address_Line_3__c='alojj',
                Buyer_Address_Line_4__c='pwieo',
                Application_Date__c=application_date,
                CL_Application_Amount__c=10000,
                CL_Status__c='Processing',
                Exporter__c=acc.Id,
                Policy__c=policy.Id,
                Legacy_Ref_No__c='656464',
                Legacy_Pre_Ref_No__c='787878'

            );
            claList.add(cl_app);
        }
        insert claList;
        return claList;
    }
    
    @isTest
    static void TestgetCLApplicationAura(){
        TestCLDataFactory.insertECCSetting();
        Account acc = TestCLDataFactory.createAccount();
        Plan__c prod = TestCLDataFactory.createProduct('OMBP');
        Policy__c policy =  TestCLDataFactory.createPolicyWithSchedule(prod.Id,acc.Id);
        Credit_Limit_Application__c cla = TestCLDataFactory.createCLA(acc.Id,policy.Id);

        Test.startTest();        
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock);        
        String res = ECIC_CL_API_Methods.getCLApplicationAura(cla.Legacy_Ref_No__c);
        Test.stopTest();
    }
    @isTest
    static void TestvalidateHrmCodeAura(){
        TestCLDataFactory.insertECCSetting();
        Test.startTest();        
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock);        
        String res = ECIC_CL_API_Methods.validateHrmCodeAura('12345678');
        Test.stopTest();
    }

    @isTest
    static void TestserchBuyerDetailsAura(){
        TestCLDataFactory.insertECCSetting();
        Test.startTest();        
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock);        
        String res = ECIC_CL_API_Methods.serchBuyerDetailsAura('USA','abcd','12345678');
        Test.stopTest();
    }

    @isTest
    static void TestamendDCLAura(){
        TestCLDataFactory.insertECCSetting();
        Account acc = TestCLDataFactory.createAccount();
        Plan__c prod = TestCLDataFactory.createProduct('OMBP');
        Policy__c policy =  TestCLDataFactory.createPolicyWithSchedule(prod.Id,acc.Id);
        Credit_Limit__c dcl = TestCLDataFactory.createDCL(acc.Id,policy.Id);
        Test.startTest();        
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock);        
        String res = ECIC_CL_API_Methods.amendDCLAura(dcl.Id);
        Test.stopTest();
    }

    @isTest
    static void TestamendDCLAura2(){
        TestCLDataFactory.insertECCSetting();
        Account acc = TestCLDataFactory.createAccount();
        Plan__c prod = TestCLDataFactory.createProduct('OMBP');
        Policy__c policy =  TestCLDataFactory.createPolicyWithSchedule(prod.Id,acc.Id);
        Credit_Limit_Application__c dcla = TestCLDataFactory.createDCLA(acc.Id,policy.Id);
        Test.startTest();        
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock);        
        String res = ECIC_CL_API_Methods.amendDCLAura(dcla.Id);
        Test.stopTest();
    }

    @isTest
    static void TestcreateDCLApplicationAura(){
        TestCLDataFactory.insertECCSetting();
        Account acc = TestCLDataFactory.createAccount();
        Plan__c prod = TestCLDataFactory.createProduct('SUP');
        Policy__c policy =  TestCLDataFactory.createPolicyWithSchedule(prod.Id,acc.Id);
        Credit_Limit_Application__c dcla = TestCLDataFactory.createDCLA(acc.Id,policy.Id);
        Test.startTest();        
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock);        
        String res = ECIC_CL_API_Methods.createDCLApplicationAura(dcla.Id);
        Test.stopTest();
    }
    @isTest
    static void cancelCLApplication(){
        TestCLDataFactory.insertECCSetting();
        Account acc = TestCLDataFactory.createAccount();
        Plan__c prod = TestCLDataFactory.createProduct('SUP');
        Policy__c policy =  TestCLDataFactory.createPolicyWithSchedule(prod.Id,acc.Id);
        Credit_Limit_Application__c cla = TestCLDataFactory.createCLA(acc.Id,policy.Id);
        Credit_Limit__c cl = TestCLDataFactory.createCL(acc.Id,policy.Id);
        Test.startTest();        
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock);        
        String res = ECIC_CL_API_Methods.cancelCLApplicationAura(cla.Id,'cla_cancel');
        String res2 = ECIC_CL_API_Methods.cancelCLApplicationAura(cl.Id,'cl_cancel');
        String res3 = ECIC_CL_API_Methods.cancelCLApplicationAura(cl.Id,'cl_reject');
        String res4 = ECIC_CL_API_Methods.cancelCLApplicationAura(cl.Id,'dcl_cancel');
        Test.stopTest();
    }

    @isTest
    static void TestamendCLApplicationAura() {
        TestCLDataFactory.insertECCSetting();
        Account acc = TestCLDataFactory.createAccount();
        Plan__c prod = TestCLDataFactory.createProduct('SUP');
        Policy__c policy =  TestCLDataFactory.createPolicyWithSchedule(prod.Id,acc.Id);
        Credit_Limit_Application__c cla = TestCLDataFactory.createCLA(acc.Id,policy.Id);
        Credit_Limit__c cl = TestCLDataFactory.createCL(acc.Id,policy.Id);
        Test.startTest();        
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock);        
        String res = ECIC_CL_API_Methods.amendCLApplicationAura(cla.Id,'A');
        cla.Legacy_Export_Type__c='PREPOST';
        update cla;
        String res1 = ECIC_CL_API_Methods.amendCLApplicationAura(cla.Id,'A');
        cla.Legacy_Export_Type__c='SVC';
        update cla;
        String res2 = ECIC_CL_API_Methods.amendCLApplicationAura(cla.Id,'A');
        String res3 = ECIC_CL_API_Methods.amendCLApplicationAura(cl.Id,'B');
        Test.stopTest();
    }

    @isTest
    static void TestcreateCLApplicationAura() {
        TestCLDataFactory.insertECCSetting();
        Account acc = TestCLDataFactory.createAccount();
        Plan__c prod = TestCLDataFactory.createProduct('SUP');
        Policy__c policy =  TestCLDataFactory.createPolicyWithSchedule(prod.Id,acc.Id);
        Credit_Limit_Application__c cla = TestCLDataFactory.createCLA(acc.Id,policy.Id);
        Test.startTest();        
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock);        
        String res = ECIC_CL_API_Methods.createCLApplicationAura(cla.Id);
        
        Test.stopTest();
    }

    @isTest
    static void TestconvertCLItoCLApplication() {
        TestCLDataFactory.insertECCSetting();
        Account acc = TestCLDataFactory.createAccount();
        Plan__c prod = TestCLDataFactory.createProduct('SUP');
        Policy__c policy =  TestCLDataFactory.createPolicyWithSchedule(prod.Id,acc.Id);
        Credit_Limit_Application__c cla = TestCLDataFactory.createCLA(acc.Id,policy.Id);
        Test.startTest();        
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();        
        String resp_body2 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body2, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock);        
        String res = ECIC_CL_API_Methods.convertCLItoCLApplication(cla.Id);        
        Test.stopTest();
    }

}