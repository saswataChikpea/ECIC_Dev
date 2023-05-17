@isTest
public with sharing class BR_ReminderTest {
    @isTest
    static void testMethodOne() {
        //Test.startTest();
        TestDataFactory.testDataSetupThree();
         
        ECIC_Settings__c settingObj = [select Batch_To_Schedule__c from ECIC_Settings__c limit 1 ];
        settingObj.Batch_To_Schedule__c='BR Reminder';
        update settingObj;

        ScheduleBatch.shceduleBatchConditionally('');
        BR_Reminder.sendBRReminderToProspect();
        //Test.stopTest();
    }
    @isTest
    static void testMethodSecond(){
        TestDataFactory.testDataSetupThree();
         
        ECIC_Settings__c settingObj = [select Batch_To_Schedule__c from ECIC_Settings__c limit 1 ];
        settingObj.Batch_To_Schedule__c='BR Reminder';
        update settingObj;

        //ScheduleBatch.shceduleBatchConditionally('');
        BatchBR_Reminder BR=new BatchBR_Reminder();
        Database.executeBatch(BR,8);

    }
}