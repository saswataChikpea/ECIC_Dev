@isTest
public with sharing class TestBatchResetMaximumLiability {
    @isTest
    static void testMethodFirst() {
        TestDataFactory.testDataSetupThree();
        ECIC_Settings__c settingObj = [select Batch_To_Schedule__c from ECIC_Settings__c limit 1 ];
        settingObj.Batch_To_Schedule__c='Reset Maximum Liability';
        update settingObj;

        ScheduleBatch.shceduleBatchConditionally('');
        
        //Test.stopTest();
    }
    @isTest
    static void testMethodSecond(){
        TestDataFactory.testDataSetupThree();
        BatchResetMaximumLiability BRM = new BatchResetMaximumLiability();
        DataBase.executeBatch(BRM); 
    }

}