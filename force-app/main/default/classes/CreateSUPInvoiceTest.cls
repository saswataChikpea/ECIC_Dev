@isTest
public with sharing class CreateSUPInvoiceTest {
    @isTest
    static void firstMethod(){
        Test.startTest();
        List<id> polIdList = TestDataFactory.testDataSetup();
        CreateSUPInvoice.createInvoiceForSUP(polIdList[0]);
        Test.stopTest();
    }
}