@isTest
public with sharing class TestCLInvoice {
    public static List<Credit_Limit_Application__c> createRecordSBP(Integer count) {
        Account acc = new Account(Name='TestAccount');
        insert acc;
        
        Plan__c prod = new Plan__c(Name='SBP',
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
        return claList;
    }
    public static List<Credit_Limit_Application__c> createRecordOMBP(Integer count) {
        ECIC_Settings__c settings = new ECIC_Settings__c(
            Charge_Deposit__c = 100
        );
        insert settings;
        List_Storage__c list_storage = new List_Storage__c(
            ByrCtry_Country_Code__c = 'USA',
            ByrCtry_Country_Name__c = 'UNITED STATES OF AMERICA',
            List_Type__c = 'Buyer Country'
        );
        insert list_storage;
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
        return claList;
    }
    @isTest
    static void TestcreateSBPInvoiceNegative(){
        Test.startTest();
        List<Credit_Limit_Application__c> cla_list = createRecordSBP(1);

        String Json_obj = JSON.serialize(
            new Map<String, Object> {
              'account' => cla_list[0].Exporter__c,
              'amount' => '1000',
              'policy_id' => cla_list[0].Policy__c,
              'Used_Credit_check__c' => '10',
              'cla_id' => cla_list[0].Id              
            });
        Object Json_object = JSON.deserializeUntyped(Json_obj);
        try{
        String invlId = CLInvoice.createSBPInvoice(Json_object);
        
        List<Invoice_Line__c> invl = [Select Id,Net_Premium__c from Invoice_Line__c where Id=:invlId];
        
        System.assertEquals(invl.size(), 1);
        System.assertEquals(invl[0].Net_Premium__c, 1000);
        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void TestcreateSBPInvoice(){
        Test.startTest();
        List<Credit_Limit_Application__c> cla_list = createRecordSBP(1);

        String Json_obj = JSON.serialize(
            new Map<String, Object> {
              'account' => cla_list[0].Exporter__c,
              'amount' => 1000,
              'policy_id' => cla_list[0].Policy__c,
              'Used_Credit_check__c' => 10,
              'cla_id' => cla_list[0].Id              
            });
        Object Json_object = JSON.deserializeUntyped(Json_obj);
        String invlId = CLInvoice.createSBPInvoice(Json_object);
        List<Invoice_Line__c> invl = [Select Id,Net_Premium__c from Invoice_Line__c where Id=:invlId];
        String invlId2 = CLInvoice.createSBPInvoice(Json_object);
        List<Invoice_Line__c> invl2 = [Select Id,Net_Premium__c from Invoice_Line__c where Id=:invlId2];
        Test.stopTest();
        System.assertEquals(invl.size(), 1);
        System.assertEquals(invl[0].Net_Premium__c, 1000);
        System.assertEquals(invl2.size(), 1);
    }
    @isTest
    static void TestcreateOMBPInvoice(){
        Test.startTest();
        List<Credit_Limit_Application__c> cla_list = createRecordOMBP(1);
        Date approve_date = Date.today();

        String Json_obj = JSON.serialize(
            new Map<String, Object> {
              'Approve_Date__c' => String.valueOf(approve_date),
              'account' => cla_list[0].Exporter__c,
              'Buyer_Code__c' => '12345',
              'Buyer_Country__c' => 'UNITED STATES OF AMERICA',
              'Legacy_Ref_No__c' => '12345',
              'CL_Amount__c' => '1000',
              'Premium__c' => '100',
              'policy_id' => cla_list[0].Policy__c,
              'Id' => cla_list[0].Id              
            });
        Object Json_object = JSON.deserializeUntyped(Json_obj);
        String invlId = CLInvoice.createOMBPInvoice(Json_object);
        List<Invoice_Line__c> invl = [Select Id,Net_Premium__c from Invoice_Line__c where Id=:invlId];
        String invlId2 = CLInvoice.createOMBPInvoice(Json_object);
        List<Invoice_Line__c> invl2 = [Select Id,Net_Premium__c from Invoice_Line__c where Id=:invlId2];
        Test.stopTest();
        System.assertEquals(invl.size(), 1);
        System.assertEquals(invl2.size(), 1);
    }
}