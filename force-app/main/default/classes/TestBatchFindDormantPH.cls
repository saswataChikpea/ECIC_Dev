@isTest
public with sharing class TestBatchFindDormantPH {
    @isTest
    static void testMethodFirst() {
        TestDataFactory.testDataSetupThree();
        BatchFindDormantPH BPH = new BatchFindDormantPH();
        ID batchID = Database.executeBatch(BPH);
    }
    @isTest
    static void testMethodSecond() {
        TestDataFactory.testDataSetupThree();
        BatchFindDormantPH BPH = new BatchFindDormantPH('credit limiet application checking');
        ID batchID = Database.executeBatch(BPH);
    }
}