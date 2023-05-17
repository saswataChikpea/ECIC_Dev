@isTest
public with sharing class TestBatchSetPaymentReminder {
    @isTest
    static void testMethodFirst() {
        TestDataFactory.testDataSetupThree();
        ECIC_Settings__c settingObj = [select Batch_To_Schedule__c from ECIC_Settings__c limit 1 ];
        settingObj.Batch_To_Schedule__c='Change Payment Reminder Date';
        update settingObj;

        ScheduleBatch.shceduleBatchConditionally('');
        
    }
    @isTest
    static void testMethodSecond() {
        TestDataFactory.testDataSetupThree();
        
        BatchSetPaymentReminder obj = new BatchSetPaymentReminder();
        DataBase.executeBatch(obj); 
        //Test.stopTest();
    }
}