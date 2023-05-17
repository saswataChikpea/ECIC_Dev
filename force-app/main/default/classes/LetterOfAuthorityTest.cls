@isTest
public with sharing class LetterOfAuthorityTest {
    @isTest
    static void testMethodFirst() {
        Map<String,String> respMap=TestDataFactory.testDataSetupThree();
        LetterOfAuthority.fetchAllLA(respMap.get('user_id'));
        LetterOfAuthority.createLAFinancer(respMap.get('policyID'), 'test', 'Whole Policy', '', '', '');
    }

}