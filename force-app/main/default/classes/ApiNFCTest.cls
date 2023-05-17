@isTest
public with sharing class ApiNFCTest {
    @isTest
    static void testMethodOne() {
        Test.startTest();
        Map<String,String> respMap = TestDataFactory.testDataSetupThree();
        List<ID> polList = new List<ID>();
        polList.add(respMap.get('policyID'));
        ApiNFC.getNFCResults(polList);
        Test.stopTest();
    }
}