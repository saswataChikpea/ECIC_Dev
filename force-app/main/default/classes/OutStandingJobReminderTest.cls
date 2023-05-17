@isTest
public with sharing class OutStandingJobReminderTest {
    @isTest
    static void testMethodFirst() {
        TestDataFactory.testDataSetupThree();
        Test.startTest();
        ECIC_Settings__c settingObj = [select Batch_To_Schedule__c from ECIC_Settings__c limit 1 ];
        settingObj.Batch_To_Schedule__c='Three Days older Task Reminder';
        update settingObj;

        ScheduleBatch.shceduleBatchConditionally('');
        BatchOutStandingJobReminder obj = new BatchOutStandingJobReminder();
        DataBase.executeBatch(obj); 
        Test.stopTest();
    }
}