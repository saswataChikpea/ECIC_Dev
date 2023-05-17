@isTest
public with sharing class ApiAMLCheckTest {
    @isTest
    static void testMethodOne() {
        Test.startTest();
        Map<String,String> respMap = TestDataFactory.testDataSetupThree();
        List<ID> polList = new List<ID>();
        polList.add(respMap.get('policyID'));
        ApiAMLCheck.getAMLChecking(polList);
        Test.stopTest();
    }
}