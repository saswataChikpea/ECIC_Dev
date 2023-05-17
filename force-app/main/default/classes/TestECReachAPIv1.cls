@isTest
public with sharing class TestECReachAPIv1 {

    /**
     * http://cloudyworlds.blogspot.com/2012/12/writing-test-classes-for-apex-rest.html
     * https://salesforce.stackexchange.com/questions/4988/writing-test-classes-for-apex-restservice
     * https://developer.salesforce.com/forums?id=906F00000009AC1IAM
     *  
    */    
    @IsTest
    static void postMethodResponse(){

        TestCLDataFactory.insertECCSetting();
        String jsonMsg = '{"meta_data":{"Buyer_Country__c":"INDIA","Buyer_Code__c":"122208"},"ver":"1","api":"credit_limit","op":"u"}';
        Test.startTest();        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/ecreachapi';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(jsonMsg);

        RestContext.request = req;
        RestContext.response = res;

        ECReachAPIv1.postMethodResponse();
        
        Test.stopTest();
        
    }


}