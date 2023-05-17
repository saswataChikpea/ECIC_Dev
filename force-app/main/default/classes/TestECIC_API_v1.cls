@isTest
public with sharing class TestECIC_API_v1 {
    
    @IsTest
    static void get_ecic_setting(){
        //insert data
        TestCLDataFactory.insertECCSetting();
        Test.startTest();
        //call
        String settingName = ECIC_API_v1.get_ecic_setting('ECIC_UAT');
        Test.stopTest();  
        System.assertEquals('ECIC_UAT', settingName);      
    }

    @IsTest
    static void get_access_token(){
        TestCLDataFactory.insertECCSetting();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock);
        String token;
        Test.startTest();
        token = ECIC_API_v1.get_access_token();
        Test.stopTest();
        System.assertEquals('eyJhb', token);
        System.assertEquals(true, ECIC_API_v1.access_token_success); 
    }

    @IsTest
    static void postContentToECIC(){
        ECIC_API_v1.access_token_success = True;
        ECIC_API_V1.token_type = '';
        ECIC_API_V1.access_token = 'eyJhb';
        Map<String, Object> jsonObject = new Map<String, Object>{'REF_NO' => 'r12345'};
        Boolean testContent = False;
        String url_extension = '/api/services/cl/CLA/get';
        String auth_header = ECIC_API_V1.token_type + ' ' + ECIC_API_V1.access_token;
        String url_parameters = '';
        String resp_body = '{"rtn_code":"1","rtn_msgs":null,"meta_data":null}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock);
        Map<String, String> res;
        Test.startTest();
        res = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
        System.debug(res);
        Test.stopTest();
        //System.assertEquals('eyJhb', token); 
    }

    @IsTest
    static void test_connection(){
        TestCLDataFactory.insertECCSetting();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock);
        String token;
        Test.startTest();
        token = ECIC_API_v1.get_access_token();
        ECIC_API_v1.test_connection();
        ECIC_API_v1.test_connection_content(new Map<String, Object>());
        Test.stopTest();
        System.assertEquals('eyJhb', token); 
    }

    @IsTest
    static void generateRandomString(){
        String str = ECIC_API_v1.generateRandomString(10);
        System.assertEquals(10, str.length());
    }

    @IsTest
    static void docSignToken(){
        TestCLDataFactory.insertECCSetting();
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();
        String uid = ECIC_API_v1.generateRandomString(10);
        Map<String, Object> jsonObject = new Map<String, Object>{'UID' => uid,'FILESIZE' => '5242878', 'FILENAME' => 'DOC_B.pdf', 'PASSWORD' => 'ecic1234', 'DIV_CODE' => 'CRD' };
        String resp_body1 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":{"signing_token":"iUGFxVlYpF","time_expired":"2021-12-09 00:02:06","retry_sec":null}}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body1, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock);
        Map<String, String> res = ECIC_API_v1.docSignToken(jsonObject);
        System.debug(res);
        Test.stopTest();
    }

    @IsTest
    static void submitDocForSign(){
        String pdfContent = 'Unsigned PDF template.';
        String fileName = 'sample';
        String divCode = 'BD'; // BD / UD / CRD
        String password = Null;         
        
        TestCLDataFactory.insertECCSetting();

        ContentVersion cv = new ContentVersion();
        cv.Title= fileName;
        cv.PathOnClient = 'sample.pdf';
        cv.VersionData = Blob.toPdf(pdfContent);
        cv.origin = 'C';
        insert cv;
        
        Test.startTest();
        
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();            
        
        // ECIC_API_v1.submitDocForSign(fileName, divCode, password); 

        String signedFileName = fileName + '-signed';
        ContentVersion cvSigned = [SELECT Id, Title, PathOnClient, VersionData, origin, ContentSize 
                        FROM ContentVersion WHERE Title = :signedFileName and IsLatest = true LIMIT 1];
        System.assertEquals(cv.origin, cvSigned.origin);

        Boolean testMode = ECIC_API_v1.ecic_setting?.test_mode__c;
        String doctoken = 'Cc4BHqbKAc';
        String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
        // ECIC_API_v1.submitDocForSignFutureMethod(auth_header, fileName, doctoken, testMode);

        Test.stopTest();    
    }

    @IsTest
    static void retrieveExchngRate(){
        TestCLDataFactory.insertECCSetting();
        Test.startTest();
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory tokenmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, tokenmock);
        String token = ECIC_API_v1.get_access_token();
        String CUR_DATE = '';
        String CUR_CODE = '';
        String IS_EXACT_DATE = '';
        String ROW_INDEX = '';
        String resp_body1 = '{"rtn_code":"1","rtn_msgs":null,"meta_data":{"EXCH_RATE":"0.7812"}}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body1, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock);
        Map<String, String> res = ECIC_API_v1.retrieveExchngRate(CUR_DATE, CUR_CODE, IS_EXACT_DATE, ROW_INDEX);
        System.debug(res);
        Test.stopTest();
    }

    //Target class SendHTTPRequestClass
    @IsTest
    static void sendRequest(){
        String resp_body = '{"access_token":"eyJhb","iss":"https://api-uat.ec-reach.com.hk/api/","token_type":"Bearer","iat":"1638950810"}';
        TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock);
        HTTPResponse res;
        Map<String, String> resp_map;
        Test.startTest();
        res = SendHTTPRequestClass.sendRequest('/api/services/oauth2/token', '?', NULL, NULL);
        resp_map = JSON_Parser.json_parsing_method(res.getBody());
        Test.stopTest();
        System.assertEquals('eyJhb', resp_map.get('access_token')); 
        
    }


    @IsTest
    static void sendBlobRequest(){
        String respString = 'Test PDF template';
        Blob resp_body = Blob.valueof(respString);
        TestHTTPBlobMockFactory httpmock = new TestHTTPBlobMockFactory(200, 'OK', resp_body, new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, httpmock);
        HTTPResponse res;
        Test.startTest();
        res = SendHTTPRequestClass.sendBlobRequest(true, 
            '/api/services/docsign/sign', 
            '', 
            new Map<String, String>(), 
            NULL);
        Blob resBlob = res.getBodyAsBlob();        
        Test.stopTest();
        System.assertEquals(respString, resBlob.toString()); 
        
    }



}