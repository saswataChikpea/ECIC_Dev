@isTest
public with sharing class TestCLApiHandler {
    public static List<Credit_Limit_Application__c> createRecordSBP(Integer count) {
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
        Commencement_Date__c=Date.today().addMonths(-13),
        Issue_Date__c=Date.today().addDays(-5),
        Exporter__c=acc.Id,        
        Is_Active__c=true);
        insert policy;
        Policy_Schedule__c schedule = new Policy_Schedule__c(
        Policy__c=policy.Id,
        Effective_Date__c=Date.today().addDays(-5),
        Issue_Date__c=Date.today().addDays(-5),
        Maximum_Liability__c=150000,
        Type__c='Schedule 1'
        );
        insert schedule;
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
        Commencement_Date__c=Date.today().addMonths(-13),
        Issue_Date__c=Date.today().addDays(-5),
        Exporter__c=acc.Id,        
        Is_Active__c=true);
        insert policy;
        Policy_Schedule__c schedule = new Policy_Schedule__c(
        Policy__c=policy.Id,
        Effective_Date__c=Date.today().addDays(-5),
        Issue_Date__c=Date.today().addDays(-5),
        Maximum_Liability__c=150000,
        Type__c='Schedule 1',
        Base_Rate_Per_Quarter__c=0.8
        );
        insert schedule;
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
    static void TestApproveCL(){
        test.startTest();
        List<Credit_Limit_Application__c> cla_list = createRecordSBP(1);
        Map<String, Object> Json_obj = 
            new Map<String, Object> {
              'id' => cla_list[0].Id,
              'approve_date__c' => String.valueOf(Date.today()),
              'Pre_Approve_Date' => '',
              'cl_effective_date__c' => String.valueOf(Date.today()),
              'expiry_date__c' => String.valueOf(Date.today().addDays(90)),
              'pre_expiry_date__c' => '',
              'Application_Date__c' => String.valueOf(Date.today().addDays(-1)),
              'Application_Completion_Date__c' => String.valueOf(Date.today().addDays(-1)),
              'CL_Status__c' => 'valid',
              'export_type__c' => 'Export of Goods',
              'remarks__c' => 'Test',
              'specific_goods_involved__c' => '',
              'goods_or_services_involved__c' => '',
              'cl_no__c' => '12345',
              'harmonized_code__c' => '',
              'port_of_loading__c' => 'BANGLADESH',
              'market_of_origin__c' => 'CHINA',
              'destination_market__c' => 'FRANCE',
              'buyer_registration_number__c' => '123456',
              'cl_amount__c' => 120000,
              'payment_term_days__c' => 120,
              'payment_term_type__c' => 'OA',
              'buyer_code__c' => '12345',
              'buyer_address_line_1__c' => 'abc',
              'buyer_address_line_2__c' => 'abkj',
              'buyer_address_line_3__c' => 'dhu',
              'buyer_address_line_4__c' => 'mno',
              'buyer_name__c' => 'Test',
              'buyer_country__c' => 'INDIA',
              'product_type__c' => 'OMBP',
              'is_dcl__c' => false

            };
        CLApiHandler.ApproveCL(Json_obj);               
        test.stopTest();
    }
    @isTest
    static void TestApproveCL2(){
        test.startTest();
        List<Credit_Limit_Application__c> cla_list = createRecordSBP(1);
        Map<String, Object> Json_obj2 = 
            new Map<String, Object> {
              'id' => cla_list[0].Id,
              'approve_date__c' => String.valueOf(Date.today()),
              'Pre_Approve_Date' => String.valueOf(Date.today()),
              'cl_effective_date__c' => String.valueOf(Date.today()),
              'expiry_date__c' => String.valueOf(Date.today().addDays(90)),
              'pre_expiry_date__c' => '',
              'Application_Date__c' => String.valueOf(Date.today().addDays(-1)),
              'Application_Completion_Date__c' => String.valueOf(Date.today().addDays(-1)),
              'CL_Status__c' => 'valid',
              'export_type__c' => 'Export of Goods (Pre-shipment and post-shipment risk)',
              'remarks__c' => 'Test',
              'specific_goods_involved__c' => '',
              'goods_or_services_involved__c' => '',
              'cl_no__c' => '12345',
              'harmonized_code__c' => '',
              'port_of_loading__c' => 'BANGLADESH',
              'market_of_origin__c' => 'CHINA',
              'destination_market__c' => 'FRANCE',
              'buyer_registration_number__c' => '123456',
              'cl_amount__c' => 120000,
              'pre_cl_amount__c' => 121000,
              'payment_term_days__c' => 120,
              'pre_payment_term_days__c' => 120,
              'payment_term_type__c' => 'OA',
              'pre_payment_term_type__c' => 'OA',
              'buyer_code__c' => '12345',
              'buyer_address_line_1__c' => 'abc',
              'buyer_address_line_2__c' => 'abkj',
              'buyer_address_line_3__c' => 'dhu',
              'buyer_address_line_4__c' => 'mno',
              'buyer_name__c' => 'Test',
              'buyer_country__c' => 'INDIA',
              'product_type__c' => 'SBP',
              'is_dcl__c' => false

            };
            CLApiHandler.ApproveCL(Json_obj2);
            test.stopTest();
    }
    @isTest
    static void TestApproveCL3(){
        test.startTest();
        List<Credit_Limit_Application__c> cla_list = createRecordOMBP(1);
        Map<String, Object> Json_obj2 = 
            new Map<String, Object> {
              'id' => cla_list[0].Id,
              'approve_date__c' => String.valueOf(Date.today()),
              'Pre_Approve_Date' => String.valueOf(Date.today()),
              'cl_effective_date__c' => String.valueOf(Date.today()),
              'expiry_date__c' => String.valueOf(Date.today().addDays(90)),
              'pre_expiry_date__c' => '',
              'Application_Date__c' => String.valueOf(Date.today().addDays(-1)),
              'Application_Completion_Date__c' => String.valueOf(Date.today().addDays(-1)),
              'CL_Status__c' => 'Application_Approved',
              'export_type__c' => 'Export of Goods',
              'remarks__c' => 'Test',
              'specific_goods_involved__c' => '',
              'goods_or_services_involved__c' => '',
              'cl_no__c' => '12345',
              'harmonized_code__c' => '12345678',
              'port_of_loading__c' => 'BANGLADESH',
              'market_of_origin__c' => 'CHINA',
              'destination_market__c' => 'FRANCE',
              'buyer_registration_number__c' => '123456',
              'cl_amount__c' => 120000,
              'pre_cl_amount__c' => 121000,
              'payment_term_days__c' => 120,
              'pre_payment_term_days__c' => 120,
              'payment_term_type__c' => 'OA',
              'pre_payment_term_type__c' => 'OA',
              'buyer_code__c' => '12345',
              'buyer_address_line_1__c' => 'abc',
              'buyer_address_line_2__c' => 'abkj',
              'buyer_address_line_3__c' => 'dhu',
              'buyer_address_line_4__c' => 'mno',
              'buyer_name__c' => 'Test',
              'buyer_country__c' => 'INDIA',
              'product_type__c' => 'OMBP',
              'is_dcl__c' => false

            };
            CLApiHandler.ApproveCL(Json_obj2);
            test.stopTest();
    }

    @isTest
    static void TestApproveCL4(){
        test.startTest();
        List<Credit_Limit_Application__c> cla_list = createRecordOMBP(1);
        Map<String, Object> Json_obj2 = 
            new Map<String, Object> {
              'id' => cla_list[0].Id,
              'approve_date__c' => String.valueOf(Date.today()),
              'Pre_Approve_Date' => String.valueOf(Date.today()),
              'cl_effective_date__c' => String.valueOf(Date.today()),
              'expiry_date__c' => String.valueOf(Date.today().addDays(90)),
              'pre_expiry_date__c' => '',
              'Application_Date__c' => String.valueOf(Date.today().addDays(-1)),
              'Application_Completion_Date__c' => String.valueOf(Date.today().addDays(-1)),
              'CL_Status__c' => 'Application_Approved',
              'export_type__c' => 'Export of Goods',
              'remarks__c' => 'Test',
              'specific_goods_involved__c' => '',
              'goods_or_services_involved__c' => '',
              'cl_no__c' => '12345',
              'harmonized_code__c' => '12345678',
              'port_of_loading__c' => 'BANGLADESH',
              'market_of_origin__c' => 'CHINA',
              'destination_market__c' => 'FRANCE',
              'buyer_registration_number__c' => '123456',
              'cl_amount__c' => 120000,
              'pre_cl_amount__c' => 121000,
              'payment_term_days__c' => 120,
              'pre_payment_term_days__c' => 120,
              'payment_term_type__c' => 'OA',
              'pre_payment_term_type__c' => 'OA',
              'buyer_code__c' => '12345',
              'buyer_address_line_1__c' => 'abc',
              'buyer_address_line_2__c' => 'abkj',
              'buyer_address_line_3__c' => 'dhu',
              'buyer_address_line_4__c' => 'mno',
              'buyer_name__c' => 'Test',
              'buyer_country__c' => 'INDIA',
              'product_type__c' => 'OMBP',
              'ref_no__c' => '12365',
              'is_dcl__c' => true
            };
            CLApiHandler.ApproveCL(Json_obj2);
            test.stopTest();
    }

    @isTest
    static void TestUpdateRejectCLA(){
        test.startTest();
        List<Credit_Limit_Application__c> cla_list = createRecordOMBP(1);
        Map<String, Object> Json_obj2 = 
            new Map<String, Object> {
              'id' => cla_list[0].Id,
              'approve_date__c' => String.valueOf(Date.today()),
              'Pre_Approve_Date' => String.valueOf(Date.today()),
              'cl_effective_date__c' => String.valueOf(Date.today()),
              'expiry_date__c' => String.valueOf(Date.today().addDays(90)),
              'pre_expiry_date__c' => '',
              'Application_Date__c' => String.valueOf(Date.today().addDays(-1)),
              'Application_Completion_Date__c' => String.valueOf(Date.today().addDays(-1)),
              'CL_Status__c' => 'cancelled',
              'export_type__c' => 'Export of Goods',
              'remarks__c' => 'Test',
              'specific_goods_involved__c' => '',
              'goods_or_services_involved__c' => '',
              'cl_no__c' => '12345',
              'harmonized_code__c' => '12345678',
              'port_of_loading__c' => 'BANGLADESH',
              'market_of_origin__c' => 'CHINA',
              'destination_market__c' => 'FRANCE',
              'buyer_registration_number__c' => '123456',
              'cl_amount__c' => 120000,
              'pre_cl_amount__c' => 121000,
              'payment_term_days__c' => 120,
              'pre_payment_term_days__c' => 120,
              'payment_term_type__c' => 'OA',
              'pre_payment_term_type__c' => 'OA',
              'buyer_code__c' => '12345',
              'buyer_address_line_1__c' => 'abc',
              'buyer_address_line_2__c' => 'abkj',
              'buyer_address_line_3__c' => 'dhu',
              'buyer_address_line_4__c' => 'mno',
              'buyer_name__c' => 'Test',
              'buyer_country__c' => 'INDIA',
              'product_type__c' => 'OMBP',
              'ref_no__c' => '12365',
              'is_dcl__c' => true,
              'cancellation_date__c' => String.valueOf(Date.today())            
            };
            Map<String, Object> meta_data = 
            new Map<String, Object>{
                'data' => new List<Object>{Json_obj2}
            };

            CLApiHandler.UpdateRejectCLA(meta_data);
            test.stopTest();
    }

    @isTest
    static void TestUpdateRejectCL(){
        test.startTest();
        List<Credit_Limit_Application__c> cla_list = createRecordOMBP(1);
        Credit_Limit__c cl = new Credit_Limit__c(
            cancellation_date__c=Date.today(),
            Buyer_Name__c='ABC',
            Buyer_Code__c='12345',
            Application_Date__c=Date.today(),
            CL_Effective_Date__c=Date.today(),
            CL_Application_Amount__c=10000,
            CL_Status__c='Processing',
            Exporter__c=cla_list[0].Exporter__c,
            Policy__c=cla_list[0].Policy__c
        );
        insert cl;
        Map<String, Object> Json_obj2 = 
            new Map<String, Object> {
              'id' => cl.Id,              
              'CL_Status__c' => 'cancelled',              
              'is_dcl__c' => false,
              'cancellation_date__c' => String.valueOf(Date.today())            
            };
            Map<String, Object> meta_data = 
            new Map<String, Object>{
                'data' => new List<Object>{Json_obj2}
            };
            CLApiHandler.UpdateRejectCL(meta_data);
            test.stopTest();
    }

    @isTest
    static void TestRejectReapply(){
        test.startTest();
        List<Credit_Limit_Application__c> cla_list = createRecordOMBP(1);
        Map<String, Object> Json_obj2 = 
            new Map<String, Object> {
              'id' => cla_list[0].Id,
              'status__c' => 'Rejected'
            };
            CLApiHandler.RejectReapply(Json_obj2);
            test.stopTest();
    }

    @isTest
    static void TestDCLCancel(){
        test.startTest();
        List<Credit_Limit_Application__c> cla_list = createRecordOMBP(1);
        Map<String, Object> Json_obj2 = 
            new Map<String, Object> {
              'id' => cla_list[0].Id,
              'is_dcl__c' => true,
              'cancellation_date__c' => String.valueOf(Date.today()),
              'policy__c' => cla_list[0].Policy__c,
              'cl_Status__c' => 'Cancelled'
            };
            CLApiHandler.DCLCancel(Json_obj2);
            test.stopTest();
    }
    @isTest
    static void TestDCLAmend(){
        test.startTest();
        List<Credit_Limit_Application__c> cla_list = createRecordOMBP(1);
        Credit_Limit__c cl = new Credit_Limit__c(
            cancellation_date__c=Date.today(),
            Buyer_Name__c='ABC',
            Buyer_Code__c='12345',
            Application_Date__c=Date.today(),
            CL_Effective_Date__c=Date.today(),
            CL_Application_Amount__c=10000,
            CL_Status__c='Processing',
            Exporter__c=cla_list[0].Exporter__c,
            Policy__c=cla_list[0].Policy__c
        );
        insert cl;
        Map<String, Object> Json_obj2 = 
            new Map<String, Object> {
              'discretionary_credit_limit_id__c' => cl.Id,
              'buyer_name__c' => 'test',
              'buyer_address_line_1__c' => 'test2',
              'buyer_address_line_2__c' => 'test3',
              'buyer_address_line_3__c' => 'test4',
              'buyer_address_line_4__c' => 'test5',
              'buyer_code__c' => '12345'              
            };
            CLApiHandler.DCLAmend(Json_obj2);
            test.stopTest();
    }

}