@isTest
public with sharing class CreateSBPInvoiceTest {
    @isTest
    static void firstMethod() {
        Test.startTest();
        List<id> polIdList = TestDataFactory.testDataSetup();
        //CreateSBPInvoice.createInvoiceForSBP(polIdList);
         
        ECIC_Settings__c settingObj = [select Batch_To_Schedule__c from ECIC_Settings__c limit 1 ];
        settingObj.Batch_To_Schedule__c='Create SBP Invoice';
        update settingObj;

        ScheduleBatch.shceduleBatchConditionally('');
        BatchCreateSBPInvoice obj = new BatchCreateSBPInvoice();
        DataBase.executeBatch(obj); 
        Test.stopTest();
    }
}