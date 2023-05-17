@isTest
public with sharing class TestCLApplicationRecord {
    
    public static List<Credit_Limit__c> createRecord(Integer count) {
        Account acc = new Account(Name='TestAccount');
        insert acc;
        
        Plan__c prod = new Plan__c(Name='OMBP',
        Max_Authorised_Person_Count__c=10,
        Max_Beneficiary_Count__c=10,
        Max_Director_Count__c=10);
        insert prod;
        Policy__c policy = new Policy__c(
        Status__c='Open',
        Product__c=prod.Id,
        Free_Credit_Check__c=10,
        Used_Credit_check__c=0,
        Exporter__c=acc.Id,
        Is_Active__c=true);
        insert policy;
        Date application_date = Date.today().addDays(-5);
        List<Credit_Limit__c> clList = new List<Credit_Limit__c>();
        // Credit_Limit__c cla;
        for (Integer i=0;i<count;i++){
            Credit_Limit__c cla = new Credit_Limit__c(
                Buyer_Name__c='ABC',
                Buyer_Code__c='12345',
                Application_Date__c=application_date,
                CL_Effective_Date__c=application_date,
                CL_Application_Amount__c=10000,
                CL_Status__c='Processing',
                Exporter__c=acc.Id,
                Policy__c=policy.Id
            );
            clList.add(cla);
        }
        insert clList;

        List<Credit_Limit_Application__c> claList = new List<Credit_Limit_Application__c>();
        // Credit_Limit_Application__c cl_app;

        for (Integer i=0;i<count;i++){
            Credit_Limit_Application__c cl_app = new Credit_Limit_Application__c(
                Buyer_Name__c='ABC',
                Buyer_Code__c='12345',
                Application_Date__c=application_date,
                CL_Application_Amount__c=10000,
                CL_Status__c='Processing',
                Exporter__c=acc.Id,
                Policy__c=policy.Id
            );
            claList.add(cl_app);
        }
        insert claList;
        return clList;
    }
    public static List<Credit_Limit__c> createDCLRecord(Integer count){
        Account acc = new Account(Name='TestAccount');
        insert acc;
        
        Plan__c prod = new Plan__c(Name='SUP',
        Max_Authorised_Person_Count__c=10,
        Max_Beneficiary_Count__c=10,
        Max_Director_Count__c=10);
        insert prod;
        Policy__c policy = new Policy__c(
        Status__c='Open',
        Product__c=prod.Id,
        Free_Credit_Check__c=10,
        Used_Credit_check__c=0,
        Exporter__c=acc.Id,
        Is_Active__c=true);
        insert policy;
        Date application_date = Date.today().addDays(-5);
        List<Credit_Limit__c> clList = new List<Credit_Limit__c>();
        // Credit_Limit__c cla;
        for (Integer i=0;i<count;i++){
            Credit_Limit__c cla = new Credit_Limit__c(
                Buyer_Name__c='ABC',
                Buyer_Code__c='12345',
                Application_Date__c=application_date,
                CL_Effective_Date__c=application_date,
                CL_Status__c='Processing',
                Exporter__c=acc.Id,
                Policy__c=policy.Id,
                Is_Dcl__c=true
            );
            clList.add(cla);
        }
        insert clList;

        List<Credit_Limit_Application__c> claList = new List<Credit_Limit_Application__c>();
        // Credit_Limit_Application__c cl_app;

        for (Integer i=0;i<count;i++){
            Credit_Limit_Application__c cl_app = new Credit_Limit_Application__c(
                Buyer_Name__c='ABC',
                Buyer_Code__c='12345',
                Application_Date__c=application_date,
                CL_Application_Amount__c=10000,
                CL_Status__c='Processing',
                Exporter__c=acc.Id,
                Policy__c=policy.Id,
                Is_Dcl__c=true
            );
            claList.add(cl_app);
        }
        insert claList;
        return clList;
    }
    public static List<Credit_Limit_Application__c> createCLADraftRecord(Integer count){
        Account acc = new Account(Name='TestAccount');
        insert acc;
        
        Plan__c prod = new Plan__c(Name='SUP',
        Max_Authorised_Person_Count__c=10,
        Max_Beneficiary_Count__c=10,
        Max_Director_Count__c=10);
        insert prod;
        Policy__c policy = new Policy__c(
        Status__c='Open',
        Product__c=prod.Id,
        Free_Credit_Check__c=10,
        Used_Credit_check__c=0,
        Exporter__c=acc.Id,
        Is_Active__c=true);
        insert policy;
        Date application_date = Date.today().addDays(-5);
        
        List<Credit_Limit_Application__c> claList = new List<Credit_Limit_Application__c>();
        // Credit_Limit_Application__c cl_app;

        for (Integer i=0;i<count;i++){
            Credit_Limit_Application__c cl_app = new Credit_Limit_Application__c(
                Buyer_Name__c='ABC',
                Buyer_Code__c='12345',
                Application_Date__c=application_date,
                CL_Application_Amount__c=10000,
                CL_Status__c='Processing',
                Exporter__c=acc.Id,
                Policy__c=policy.Id,
                Is_Draft__c=true
            );
            claList.add(cl_app);
        }
        insert claList;
        return claList;
    }
    @isTest
    static void TestgetDiscretionaryCreditLimitRecord(){
        String buyer_name='ABC';
        String buyer_code='12345';
        String status='Processing';
        String from_date='';
        String to_date='';
        Date from_date2 = Date.today().addDays(-10);
        Date to_date2 = Date.today().addDays(10);
        Test.startTest();
        List<Credit_Limit__c> clrecords = createDCLRecord(5);   
        Credit_Limit__c cl = [Select Policy__c from Credit_Limit__c where Id=:clrecords[0].Id];
        CLApplicationRecord.ClClaWrapper clList= CLApplicationRecord.getDiscretionaryCreditLimitRecord(buyer_name,buyer_code,status,from_date,to_date,cl.Policy__c);
        CLApplicationRecord.ClClaWrapper clList2= CLApplicationRecord.getDiscretionaryCreditLimitRecord('','','',String.valueOf(from_date2),String.valueOf(to_date),cl.Policy__c);
        CLApplicationRecord.ClClaWrapper clList3= CLApplicationRecord.getDiscretionaryCreditLimitRecord('','','Processing',String.valueOf(from_date2),String.valueOf(to_date),cl.Policy__c);
        // List<Credit_Limit__c> clList4=CLApplicationRecord.getCreditLimitRecordByID(clrecords[0].Id);
        CLApplicationRecord.ClClaWrapper clList5= CLApplicationRecord.getDiscretionaryCreditLimitRecord('',buyer_code,status,String.valueOf(from_date2),String.valueOf(to_date),cl.Policy__c);
        CLApplicationRecord.ClClaWrapper clList6= CLApplicationRecord.getDiscretionaryCreditLimitRecord('',buyer_code,'',String.valueOf(from_date2),String.valueOf(to_date),cl.Policy__c);
        // List<Credit_Limit__c> clList7= CLApplicationRecord.getCreditLimitRecord('',buyer_code,'','2021-05-05',to_date);
        // List<Credit_Limit__c> clList8= CLApplicationRecord.getCreditLimitRecord('','','','','2021-05-05');
        Test.stopTest();
        System.debug('clList='+clList);
        System.debug('clList='+clList2.clList.size());
        System.assertEquals(clList.clList.size(),5);
        System.assertEquals(clList2.clList.size(),5);
        System.assertEquals(clList3.clList.size(),5);
        // System.assertEquals(clList4.size(),1);
        System.assertEquals(clList5.clList.size(),5);
        System.assertEquals(clList6.clList.size(),5);
        // System.assertEquals(clList7.size(),0);
        // System.assertEquals(clList8.size(),0);
    }
    @isTest
    static void TestgetCLADraftListByPolicy(){
        Test.startTest();
        List<Credit_Limit_Application__c> clarecords = createCLADraftRecord(5);
        List<Credit_Limit_Application__c> claList = CLApplicationRecord.getCLADraftListByPolicy(clarecords[0].Policy__c);
        Test.stopTest();
        System.assertEquals(claList.size(),5);
    }
    @isTest
    static void TestDeleteDraft(){
        Test.startTest();
        List<Credit_Limit_Application__c> clarecords = createCLADraftRecord(5);
        CLApplicationRecord.DeleteDraft(clarecords[0].Id);
        Test.stopTest();
    }
    
    @isTest
    static void TestgetCreditLimitRecord(){
        String buyer_name='ABC';
        String buyer_code='12345';
        String status='Processing';
        String from_date='';
        String to_date='';
        Date from_date2 = Date.today().addDays(-10);
        Date to_date2 = Date.today().addDays(10);
        Test.startTest();
        List<Credit_Limit__c> clrecords = createRecord(5);   
        Credit_Limit__c cl = [Select Policy__c from Credit_Limit__c where Id=:clrecords[0].Id];
        CLApplicationRecord.ClClaWrapper clList= CLApplicationRecord.getCreditLimitRecord(buyer_name,buyer_code,status,from_date,to_date,cl.Policy__c);
        CLApplicationRecord.ClClaWrapper clList2= CLApplicationRecord.getCreditLimitRecord('','','',String.valueOf(from_date2),String.valueOf(to_date),cl.Policy__c);
        CLApplicationRecord.ClClaWrapper clList3= CLApplicationRecord.getCreditLimitRecord('','','Processing',String.valueOf(from_date2),String.valueOf(to_date),cl.Policy__c);
        // List<Credit_Limit__c> clList4=CLApplicationRecord.getCreditLimitRecordByID(clrecords[0].Id);
        CLApplicationRecord.ClClaWrapper clList5= CLApplicationRecord.getCreditLimitRecord('',buyer_code,status,String.valueOf(from_date2),String.valueOf(to_date),cl.Policy__c);
        CLApplicationRecord.ClClaWrapper clList6= CLApplicationRecord.getCreditLimitRecord('',buyer_code,'',String.valueOf(from_date2),String.valueOf(to_date),cl.Policy__c);
        // List<Credit_Limit__c> clList7= CLApplicationRecord.getCreditLimitRecord('',buyer_code,'','2021-05-05',to_date);
        // List<Credit_Limit__c> clList8= CLApplicationRecord.getCreditLimitRecord('','','','','2021-05-05');
        Test.stopTest();
        System.debug('clList='+clList);
        System.debug('clList='+clList2.clList.size());
        System.assertEquals(clList.clList.size(),5);
        System.assertEquals(clList2.clList.size(),5);
        System.assertEquals(clList3.clList.size(),5);
        // System.assertEquals(clList4.size(),1);
        System.assertEquals(clList5.clList.size(),5);
        System.assertEquals(clList6.clList.size(),5);
        // System.assertEquals(clList7.size(),0);
        // System.assertEquals(clList8.size(),0);
    }
    @isTest
    static void TestgetExistingDCL(){
        String buyer_name='ABC';
        String buyer_code='12345';
        String status='Processing';
        String from_date='';
        String to_date='';
        Date from_date2 = Date.today().addDays(-10);
        Date to_date2 = Date.today().addDays(10);
        Test.startTest();
        List<Credit_Limit__c> clrecords = createDCLRecord(5);   
        Credit_Limit__c cl = [Select Policy__c from Credit_Limit__c where Id=:clrecords[0].Id];
        CLApplicationRecord.ClClaWrapper clList= CLApplicationRecord.getExistingDCL(cl.Policy__c,buyer_code);
        Test.stopTest();
        System.assertEquals(clList.clList.size(),5);
    }
    @isTest
    static void testgetCreditLimitApplicationRecordByID(){
        Test.startTest();
        List<Credit_Limit__c> clrecords = createRecord(5);
        Credit_Limit_Application__c cla = [select Id from Credit_Limit_Application__c where Buyer_Name__c='ABC' Limit 1];
        Credit_Limit_Application__c cla2 = CLApplicationRecord.getCreditLimitApplicationRecordByID(cla.Id);
        Test.stopTest();
        System.assertEquals(cla2.Buyer_Name__c,'ABC');
    }
    @isTest
    static void testgetCLListByPolicy() {
        Test.startTest();
        List<Credit_Limit__c> clrecords = createRecord(5);   
        Credit_Limit__c cl = [Select Policy__c from Credit_Limit__c where Id=:clrecords[0].Id];
        List<Credit_Limit__c> clList = CLApplicationRecord.getCLListByPolicy(cl.Policy__c);
        Test.stopTest();
        System.assertEquals(clList.size(),5);
    }

    @isTest
    static void testgetCLAListByPolicy() {
        Test.startTest();
        List<Credit_Limit__c> clrecords = createRecord(5);   
        Credit_Limit_Application__c cla = [Select Policy__c from Credit_Limit_Application__c where Buyer_Name__c='ABC' Limit 1];
        List<Credit_Limit_Application__c> claList = CLApplicationRecord.getCLAListByPolicy(cla.Policy__c);
        Test.stopTest();
        System.assertEquals(claList.size(),5);
    }
    @isTest
    static void testgetCLCLAListByPolicy(){
        Test.startTest();
        List<Credit_Limit__c> clrecords = createRecord(5);
        CLApplicationRecord.ClClaWrapper clList= CLApplicationRecord.getCLCLAListByPolicy(clrecords[0].Policy__c);
        Test.stopTest();
        System.assertEquals(clList.clList.size(),5);
    }
    @isTest
    static void testgetDCLDCLAListByPolicy(){
        Test.startTest();
        List<Credit_Limit__c> clrecords = createDCLRecord(5);
        CLApplicationRecord.ClClaWrapper clList= CLApplicationRecord.getDCLDCLAListByPolicy(clrecords[0].Policy__c);
        Test.stopTest();
        System.assertEquals(clList.clList.size(),5);
    }

    @isTest
    static void testgetExistingBuyers() {
        Test.startTest();
        Account acc = new Account(Name='TestAccount');
        insert acc;
        
        Plan__c prod = new Plan__c(Name='OMBP',
        Max_Authorised_Person_Count__c=10,
        Max_Beneficiary_Count__c=10,
        Max_Director_Count__c=10);
        insert prod;
        Policy__c policy = new Policy__c(
        Status__c='Open',
        Product__c=prod.Id,
        Free_Credit_Check__c=10,
        Used_Credit_check__c=0,
        Exporter__c=acc.Id);
        insert policy;
        Credit_Limit__c cl = new Credit_Limit__c(
                Buyer_Name__c='ABC',
                Buyer_Code__c='12345',
                CL_Application_Amount__c=10000,
                CL_Status__c='Valid',
                Exporter__c=acc.Id,
                Policy__c=policy.Id
            );
        insert cl;
        List<Credit_Limit__c> clList = CLApplicationRecord.getExistingBuyers(policy.Id);
        Test.stopTest();
        System.assertEquals(clList.size(),1);
    }

    @isTest
    static void testcreateOutstandingPaymentBuyer() {
        Test.startTest();
        List<Credit_Limit__c> clrecords = createRecord(1);
        Credit_Limit_Application__c cla = [select Id from Credit_Limit_Application__c where Buyer_Name__c='ABC' Limit 1];
        List<Object> obj_list = new List<Object>();
        String Json_obj = JSON.serialize(
            new Map<String, Object> {
              'InvoiceDueDate' => '2021-08-05',
              'InvoiceDate' => '2021-07-05',
              'InvoiceAmount' => '1000',
              'PaymentTermsDays' => '90',
              'InvoiceCurrency' => 'INR',
              'PaymentTermsType' => 'OA',
              'InvoiceRemark' => 'test'
            });
            obj_list.add(JSON.deserializeUntyped(Json_obj));
            CLApplicationRecord.createOutstandingPaymentBuyer(obj_list,cla.Id);
            Test.stopTest();

    }

}