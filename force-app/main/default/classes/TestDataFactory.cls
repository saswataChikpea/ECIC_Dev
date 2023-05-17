@isTest
public with sharing class TestDataFactory {
    public static List<ID> testDataSetup(){

        ECIC_Settings__c setObj = new ECIC_Settings__c();
        setObj.Charge_Deposit__c=100;
        //Create SBP Invoice,Change Payment Reminder Date,Reset Maximum Liability,Three Days older Task Reminder,BR Reminder
        setObj.Batch_To_Schedule__c='Create SBP Invoice';
        setObj.Time_To_Schedule_SBP_Invoice_Batch__c=System.now();
        setObj.Time_To_Schedule_Task_Remider_Email__c=System.now();
        setObj.Time_To_Schedule_BR_Reminder_Batch__c=System.now();
        insert setObj;

        Plan__c prodSBP= new Plan__c();
        prodSBP.name='SBP';
        prodSBP.Max_Authorised_Person_Count__c=10;
        prodSBP.Max_Beneficiary_Count__c=10;
        prodSBP.Max_Director_Count__c=10;
        insert prodSBP;
        
        
        
        Account acc=new Account(); 
        acc.name='SBP Acc';
        insert acc;

        Price_Book__c pb = new Price_Book__c();
        pb.Active__c=true;
        insert pb;
        
        Contact con=new Contact();
        con.AccountId=acc.id;
        con.LastName='Last';
        insert con;
        
        Policy__c pol = new Policy__c();
        pol.Product__c = prodSBP.id;
        pol.Exporter__c = acc.id;
        pol.Is_Charge_Deposit_Applied__c=false;
        pol.Commencement_Date__c= Date.today();
        pol.Is_Active__c=true;
        pol.Invoiced__c=false;
        insert pol;
        List<ID> polIdList = new List<ID>();
        polIdList.add(pol.id);

        Policy_Schedule__c polSch = new Policy_Schedule__c();
        polSch.Policy__c=pol.id;
        
        polSch.Policyholder_s_Address__c='Room 123,1234 ABC Street District A';
        polSch.Maximum_Liability__c=100000.00;
        polSch.Type__c='Schedule 1';
        polSch.Base_Loading__c='100';
        polSch.Percentage_of_Indemnity__c=90;
        polSch.Exclusion_of_Risk__c='Repudiation Risk';
        polSch.Payment_Type__c='Quarterly';
        polSch.Maximum_Liability__c=200000;
        polSch.Base_Rate_Per_Anum__c=100;
        polSch.Non_Qualifying_Loss_Amount__c=10;
        polSch.Issue_Date__c=Date.today();
        insert polSch;

        acc.Current_Policy__c = pol.id;
        update acc;

        Endorsement__c endorse = new Endorsement__c();
        endorse.Name= 'EN48A';
        endorse.Approval_Required__c='Yes';
        insert endorse;

        Related_Endorsement__c relEnd = new  Related_Endorsement__c();
        relEnd.Endorsement_Type__c = endorse.ID;
        relEnd.Policy__c = pol.Id;
        relEnd.Status__c = 'Approved';
        relEnd.Issue_Date__c=Date.today();
        insert relEnd;

        Dynamic_Price__c dp= new Dynamic_Price__c();
        dp.Loading__c='190';
        dp.DP__c=100;
        dp.DA_OA_0_30__c=100;
        dp.DA_OA_31_60__c=100;
        dp.DA_OA_61_90__c=100;
        dp.DA_OA_91_180__c=100;
        dp.Price_Book__c=pb.id;
        dp.Country_Grade__c='GRADE_BC';
        insert dp;

        Credit_Limit__c cl = new Credit_Limit__c();
        cl.Buyer_Name__c = 'Buyer Name';
        cl.Buyer_Code__c= 'Buyer Code';
        cl.Buyer_Country__c = 'ALGERIA';
        cl.Policy__c=pol.id;
        cl.Exporter__c=acc.id;
        insert cl;

        Shipment_Declaration__c sd = new Shipment_Declaration__c();
        sd.Type__c='Individual';
        sd.Status__c='Settled';
        sd.Shipment_Service_Type__c='Shipment';
        sd.Shipment_Year__c='2021';
        sd.Shipment_Month__c='Shipment';
        sd.Shipment_was_made_by_anoverseas_subsidia__c=true;
        sd.Shipment_Date__c= Date.today();
        sd.Review_Port_of_Loading__c= true;
        sd.Reference_Number__c='h1h2';
        sd.Reason_For_Late_Declaration__c='';
        sd.Reason_For_Cancellation__c='';
        sd.Reason_For_Amendment__c='';
        sd.Pre_Shipment_Declaration__c=false;
        sd.Port_Of_Loading_Approval__c='Approved';
        sd.Policy__c = pol.id;
        sd.Invoiced__c=false;
        sd.Gross_Invoice_Value__c=100;
        //sd.Gross_Invoice_Value__c='HKD';
        sd.Buyer_Name__c='Buyer Name';
        sd.Buyer_Code__c='Buyer Code';
        sd.Amend_Approval_Required__c=true;
        sd.Amend_Approved_by_Leader__c = false;
        sd.Backup_Buyer_Code__c='Buyer Code';
        sd.Backup_Buyer_Name__c='buyer Name';
        sd.Backup_Contract_Date__c=Date.today();
        sd.Backup_Country_of_Origin__c='ALGERIA';
        sd.Payment_Term_Type__c='DA';
        sd.Shipment_Month__c='March';
        sd.Payment_Term_Days__c=40;
        insert sd;

        Shipment_Declaration_History__c sdh = new Shipment_Declaration_History__c();

        Invoice__c invObj = new Invoice__c();
        invObj.Account__c = acc.id;
        invObj.Installment_Type__c='F';
        //invObj.Invoice_Date__c=getDate(System.now());
        invObj.Policy__c = pol.id;
        invObj.Status__c ='UnPaid';
        insert invObj;

        Invoice_Line__c invLineObj = new Invoice_Line__c();
        invLineObj.Invoice__c = invObj.id;
        invLineObj.Buyer_s_Code__c = 'B001';
        invLineObj.Line_Amount__c =100; 
        invLineObj.Net_Premium__c =100; 
        invLineObj.Payment_Terms__c='OA 30';
        invLineObj.Premium_Due_Date__c=Date.today();
        insert invLineObj;



        User portalUser = new User(

            ProfileId = [SELECT Id FROM Profile WHERE Name = 'EC-Reach Login Profile'].Id,
            LastName = 'Last',
            ContactId = con.Id,
            Email = 'satya@ckp.com',
            Username = 'satya@ckp.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert portalUser;
        return polIdList;
    }
    public static String testDataSetupSecond(){

        ECIC_Settings__c setObj = new ECIC_Settings__c();
        setObj.Charge_Deposit__c=100;
        //Create SBP Invoice,Change Payment Reminder Date,Reset Maximum Liability,Three Days older Task Reminder,BR Reminder
        setObj.Batch_To_Schedule__c='Create SBP Invoice';
        setObj.Time_To_Schedule_SBP_Invoice_Batch__c=System.now();
        setObj.Time_To_Schedule_Task_Remider_Email__c=System.now();
        setObj.Time_To_Schedule_BR_Reminder_Batch__c=System.now();
        insert setObj;

        Plan__c prodSBP= new Plan__c();
        prodSBP.name='SBP';
        prodSBP.Max_Authorised_Person_Count__c=10;
        prodSBP.Max_Beneficiary_Count__c=10;
        prodSBP.Max_Director_Count__c=10;
        insert prodSBP;
        
        
        
        Account acc=new Account(); 
        acc.name='SBP Acc';
        insert acc;

        Price_Book__c pb = new Price_Book__c();
        pb.Active__c=true;
        insert pb;
        
        Contact con=new Contact();
        con.AccountId=acc.id;
        con.LastName='Last';
        insert con;
        
        Policy__c pol = new Policy__c();
        pol.Product__c = prodSBP.id;
        pol.Exporter__c = acc.id;
        pol.Is_Charge_Deposit_Applied__c=false;
        pol.Commencement_Date__c= Date.today();
        pol.Is_Active__c=true;
        pol.Invoiced__c=false;
        insert pol;
        List<ID> polIdList = new List<ID>();
        polIdList.add(pol.id);

        Policy_Schedule__c polSch = new Policy_Schedule__c();
        polSch.Policy__c=pol.id;
        
        polSch.Policyholder_s_Address__c='Room 123,1234 ABC Street District A';
        polSch.Maximum_Liability__c=100000.00;
        polSch.Type__c='Schedule 1';
        polSch.Base_Loading__c='100';
        polSch.Percentage_of_Indemnity__c=90;
        polSch.Exclusion_of_Risk__c='Repudiation Risk';
        polSch.Payment_Type__c='Quarterly';
        polSch.Maximum_Liability__c=200000;
        polSch.Base_Rate_Per_Anum__c=100;
        polSch.Non_Qualifying_Loss_Amount__c=10;
        polSch.Issue_Date__c=Date.today();
        insert polSch;

        acc.Current_Policy__c = pol.id;
        update acc;

        Endorsement__c endorse = new Endorsement__c();
        endorse.Name= 'EN48A';
        endorse.Approval_Required__c='Yes';
        insert endorse;

        Related_Endorsement__c relEnd = new  Related_Endorsement__c();
        relEnd.Endorsement_Type__c = endorse.ID;
        relEnd.Policy__c = pol.Id;
        relEnd.Status__c = 'Approved';
        relEnd.Issue_Date__c=Date.today();
        insert relEnd;

        Dynamic_Price__c dp= new Dynamic_Price__c();
        dp.Loading__c='190';
        dp.DP__c=100;
        dp.DA_OA_0_30__c=100;
        dp.DA_OA_31_60__c=100;
        dp.DA_OA_61_90__c=100;
        dp.DA_OA_91_180__c=100;
        dp.Price_Book__c=pb.id;
        dp.Country_Grade__c='GRADE_BC';
        insert dp;

        Credit_Limit__c cl = new Credit_Limit__c();
        cl.Buyer_Name__c = 'Buyer Name';
        cl.Buyer_Code__c= 'Buyer Code';
        cl.Buyer_Country__c = 'ALGERIA';
        cl.Policy__c=pol.id;
        cl.Exporter__c=acc.id;
        insert cl;

        Shipment_Declaration__c sd = new Shipment_Declaration__c();
        sd.Type__c='Individual';
        sd.Status__c='Settled';
        sd.Shipment_Service_Type__c='Shipment';
        sd.Shipment_Year__c='2021';
        sd.Shipment_Month__c='Shipment';
        sd.Shipment_was_made_by_anoverseas_subsidia__c=true;
        sd.Shipment_Date__c= Date.today();
        sd.Review_Port_of_Loading__c= true;
        sd.Reference_Number__c='h1h2';
        sd.Reason_For_Late_Declaration__c='';
        sd.Reason_For_Cancellation__c='';
        sd.Reason_For_Amendment__c='';
        sd.Pre_Shipment_Declaration__c=false;
        sd.Port_Of_Loading_Approval__c='Approved';
        sd.Policy__c = pol.id;
        sd.Invoiced__c=false;
        sd.Gross_Invoice_Value__c=100;
        //sd.Gross_Invoice_Value__c='HKD';
        sd.Buyer_Name__c='Buyer Name';
        sd.Buyer_Code__c='Buyer Code';
        sd.Amend_Approval_Required__c=true;
        sd.Amend_Approved_by_Leader__c = false;
        sd.Backup_Buyer_Code__c='Buyer Code';
        sd.Backup_Buyer_Name__c='Buyer Name';
        sd.Backup_Contract_Date__c=Date.today();
        sd.Backup_Country_of_Origin__c='ALGERIA';
        sd.Payment_Term_Type__c='DA';
        sd.Shipment_Month__c='March';
        sd.Payment_Term_Days__c=40;
        insert sd;

        Shipment_Declaration_History__c sdh = new Shipment_Declaration_History__c();

        Invoice__c invObj = new Invoice__c();
        invObj.Account__c = acc.id;
        invObj.Installment_Type__c='F';
        //invObj.Invoice_Date__c=getDate(System.now());
        invObj.Policy__c = pol.id;
        invObj.Status__c ='UnPaid';
        insert invObj;

        Invoice_Line__c invLineObj = new Invoice_Line__c();
        invLineObj.Invoice__c = invObj.id;
        invLineObj.Buyer_s_Code__c = 'B001';
        invLineObj.Line_Amount__c =100; 
        invLineObj.Net_Premium__c =100; 
        invLineObj.Payment_Terms__c='OA 30';
        invLineObj.Premium_Due_Date__c=Date.today();
        insert invLineObj;



        User portalUser = new User(

            ProfileId = [SELECT Id FROM Profile WHERE Name = 'EC-Reach Login Profile'].Id,
            LastName = 'Last',
            ContactId = con.Id,
            Email = 'satya@ckp.com',
            Username = 'satya@ckp.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert portalUser;

        CMS_Content__c cms = new CMS_Content__c();
        cms.Content_Id__c='20Y5D000000039MUAQ';
        cms.Content_URL__c='https://kennychun--dev2.lightning.force.com/lightning/cms/spaces/0Zu0l0000008ON5CAM/content/20Y0l00000000DyEAI/5OU0l00000000ZmGAI';
        cms.Product__c=prodSBP.id;
        cms.Published_Date__c=Date.today();
        cms.Status__c='Published';
        insert cms;
        return portalUser.id;
    }
    public static Map<string,String> testDataSetupThree(){

        /*ECIC_Settings__c setObj = new ECIC_Settings__c();
        setObj.Charge_Deposit__c=100;
        //Create SBP Invoice,Change Payment Reminder Date,Reset Maximum Liability,Three Days older Task Reminder,BR Reminder
        setObj.Batch_To_Schedule__c='Create SBP Invoice';
        setObj.Time_To_Schedule_SBP_Invoice_Batch__c=System.now();
        setObj.Time_To_Schedule_Task_Remider_Email__c=System.now();
        setObj.Time_To_Schedule_BR_Reminder_Batch__c=System.now();
        setObj.Enable_Monthy_Lump_Sum__c=true;
        setObj.Allowed_Port_of_Loading__c='India';
        insert setObj;*/
        ECIC_Settings__c settings = new ECIC_Settings__c(
        Name='ECIC_UAT', 
        Access_Token__c='3ByIUWx45HU3aXg',
        Access_Token_Updated__c=Datetime.newInstance(2021,09,28, 10,44,08), 
        Access_Token_Valid_Upto__c=Datetime.newInstance(2021,09,28, 11,44,08), 
        ecic_hmac_key__c='mt9c1Re4G6RiKUxnQa', 
        ecic_public_key__c='Gn4eB1ciY', 
        ecic_public_rsa_key__c='IDAQAB', 
        ecic_uat_hmac_key__c='mt9c1Re4G6RiK', 
        ecic_uat_public_key__c='Gn4eB1', 
        ecic_uat_public_rsa_key__c='RajX8XdkwIDAQAB', 
        ecic_private_rsa_key__c='YTW7kExS1iH450Jk', 
        ecic_uat_private_rsa_key__c='TjkEOI8exYTW7kExS1iH450Jk', 
        Intialization_Vector__c='Example of IV256', 
        sf_private_rsa_key__c='nN7elYD43tML', 
        sf_public_rsa_key__c='rQIDAQAB', 
        sf_uat_private_rsa_key__c='YJvZrQIDAQAB', 
        test_mode__c=true, 
        ECIC_API_Client_ID__c='XXXXXXX_dev', 
        ECIC_API_Client_Secret__c='kJSAbfkjn', 
        ECIC_API_Password__c='abcdef', 
        ECIC_API_Username__c='XXXXXXXX_dev', 
        ECIC_UAT_API_Client_ID__c='XXXXXXX_dev', 
        ECIC_UAT_API_Client_Secret__c='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
        ECIC_UAT_API_Password__c='XXXXXXXXXXXXXXXXXXX', 
        ECIC_UAT_API_Username__c='XXXXXXXX_dev',
        Charge_Deposit__c=100,
        //Create SBP Invoice,Change Payment Reminder Date,Reset Maximum Liability,Three Days older Task Reminder,BR Reminder
        Batch_To_Schedule__c='Create SBP Invoice',
        Time_To_Schedule_SBP_Invoice_Batch__c=System.now(),
        Time_To_Schedule_Task_Remider_Email__c=System.now(),
        Time_To_Schedule_BR_Reminder_Batch__c=System.now(),
        Enable_Monthy_Lump_Sum__c=true,
        Allowed_Port_of_Loading__c='India'
        );
        insert settings;

        Gateway__c gateObj = new Gateway__c();
        gateObj.Name='Gloabal Pay';
        gateObj.Is_Test__c=true;
        gateObj.Test_Access_Key__c='Test_Access_Key__c';//ce445f6e66e0383b967eb7558583c656
        gateObj.Test_Secret_Key__c='Test_Secret_Key__c';//3363b13a888244829a6dfcc1eac99c31bac1f73a6adc49f09ef93d48cee667348123d617e348418f86c827b4bde7fc62955b36a5cac149d68c51c60028a32d607ab8c3eb6f7d437a92c0a5ab7de5d543f1be48c99d514b1a9508c39d82c5d9bb84fac26610974f7499790236b494de4bdeb64da8e8bb476d9c5b4ece40e3b723
        gateObj.Test_End_Point__c='https://testsecureacceptance.cybersource.com/pay';
        gateObj.Test_Redirect_URL__c='https://testsecureacceptance.cybersource.com/pay';
        insert gateObj;


        Plan__c prodSBP= new Plan__c();
        prodSBP.name='OMBP';
        prodSBP.Max_Authorised_Person_Count__c=10;
        prodSBP.Max_Beneficiary_Count__c=10;
        prodSBP.Max_Director_Count__c=10;
        insert prodSBP;
        
        
        
        Account acc=new Account(); 
        acc.name='SBP Acc';
        insert acc;

        Contact conObj = new Contact();
        conObj.Email='satya@chikpea.com';
        conObj.Enable_Email_Notification__c=true;
        conObj.AccountId = acc.id;
        conObj.LastName = 'vishwa';
        insert conObj;

        Task ttask = new Task();
        ttask.X3rd_Day_Email_Reminder_Sent__c=false;
        insert ttask;
        Datetime yesterday = Datetime.now().addDays(-3);
        Test.setCreatedDate(ttask.Id, yesterday);
        Task taskObj = [select createdDate,X3rd_Day_Email_Reminder_Sent__c,Is_Today_is_4th_Day_of_Task__c from Task where id=:ttask.id ];
        System.debug('taskObj ===>>'+taskObj);
        
        Price_Book__c pb = new Price_Book__c();
        pb.Active__c=true;
        insert pb;
        
        Contact con=new Contact();
        con.AccountId=acc.id;
        con.LastName='Last';
        insert con;
        
        Policy__c pol = new Policy__c();
        pol.Product__c = prodSBP.id;
        pol.Exporter__c = acc.id;
        pol.Is_Charge_Deposit_Applied__c=false;
        pol.Commencement_Date__c= Date.today();
        pol.Is_Active__c=true;
        pol.Invoiced__c=false;
        pol.Status__c='Valid';
        pol.Effective_Date__c=Date.today();
        insert pol;
        List<ID> polIdList = new List<ID>();
        polIdList.add(pol.id);

        Policy_Schedule__c polSch = new Policy_Schedule__c();
        polSch.Policy__c=pol.id;
        
        polSch.Policyholder_s_Address__c='Room 123,1234 ABC Street District A';
        polSch.Maximum_Liability__c=100000.00;
        polSch.Type__c='Schedule 1';
        polSch.Base_Loading__c='100';
        polSch.Percentage_of_Indemnity__c=90;
        polSch.Exclusion_of_Risk__c='Repudiation Risk';
        polSch.Payment_Type__c='Quarterly';
        polSch.Maximum_Liability__c=200000;
        polSch.Base_Rate_Per_Anum__c=100;
        polSch.Non_Qualifying_Loss_Amount__c=10;
        polSch.ML_Changed_to_Non_Zero_Date__c=Datetime.now().addDays(-365);

        insert polSch;

        acc.Current_Policy__c = pol.id;
        update acc;

        Credit_Limit_Application__c cla= new Credit_Limit_Application__c();
        cla.Policy__c=pol.id;
        cla.Application_Date__c = Date.today().addDays(-6);
        cla.Exporter__c=acc.id;
        cla.CL_Status__c='Valid';
        insert cla;

        Endorsement__c endorse = new Endorsement__c();
        endorse.Name= 'EN67';
        endorse.Approval_Required__c='Yes';
        insert endorse;

        Related_Endorsement__c relEnd = new  Related_Endorsement__c();
        relEnd.Endorsement_Type__c = endorse.ID;
        relEnd.Policy__c = pol.Id;
        relEnd.Status__c = 'Approved';
        relEnd.Endorsement_Type__c=endorse.id;
        relEnd.Issue_Date__c=Date.today();
        insert relEnd;

        Dynamic_Price__c dp= new Dynamic_Price__c();
        dp.Loading__c='190';
        dp.DP__c=100;
        dp.DA_OA_0_30__c=100;
        dp.DA_OA_31_60__c=100;
        dp.DA_OA_61_90__c=100;
        dp.DA_OA_91_180__c=100;
        dp.Price_Book__c=pb.id;
        dp.Country_Grade__c='GRADE_BC';
        insert dp;

        Credit_Limit__c cl = new Credit_Limit__c();
        cl.Buyer_Name__c = 'Buyer Name';
        cl.Buyer_Code__c= 'Buyer Code';
        cl.Buyer_Country__c = 'ALGERIA';
        cl.Policy__c=pol.id;
        cl.Exporter__c=acc.id;
        cl.CL_Effective_Date__c=Date.today().addDays(-6);
        insert cl;

        Shipment_Declaration__c sd = new Shipment_Declaration__c();
        sd.Type__c='Individual';
        sd.Status__c='Settled';
        sd.Shipment_Service_Type__c='Shipment';
        sd.Shipment_Year__c='2021';
        sd.Shipment_Month__c='Shipment';
        sd.Shipment_was_made_by_anoverseas_subsidia__c=true;
        sd.Shipment_Date__c= Date.today();
        sd.Review_Port_of_Loading__c= true;
        sd.Reference_Number__c='h1h2';
        sd.Reason_For_Late_Declaration__c='';
        sd.Reason_For_Cancellation__c='';
        sd.Reason_For_Amendment__c='';
        sd.Pre_Shipment_Declaration__c=false;
        sd.Port_Of_Loading_Approval__c='Approved';
        sd.Policy__c = pol.id;
        sd.Invoiced__c=false;
        sd.Gross_Invoice_Value__c=100;
        //sd.Gross_Invoice_Value__c='HKD';
        sd.Buyer_Name__c='Buyer Name';
        sd.Buyer_Code__c='Buyer Code';
        sd.Amend_Approval_Required__c=true;
        sd.Amend_Approved_by_Leader__c = false;
        sd.Backup_Buyer_Code__c='Buyer Code';
        sd.Backup_Buyer_Name__c='Buyer Name';
        sd.Backup_Contract_Date__c=Date.today();
        sd.Backup_Country_of_Origin__c='ALGERIA';
        sd.Payment_Term_Type__c='DA';
        sd.Shipment_Month__c='March';
        sd.Payment_Term_Days__c=40;
        insert sd;

        Shipment_Declaration_History__c sdh = new Shipment_Declaration_History__c();
        sdh.Type__c='Individual';
        sdh.Status__c='Settled';
        //sdh.Shipment_Service_Type__c='Shipment';
        //sdh.Shipment_Year__c='2021';
        //sdh.Shipment_Month__c='Shipment';
        sdh.Shipment_was_made_by_anoverseas_subsidia__c=true;
        sdh.Shipment_Date__c= Date.today();
        //sdh.Review_Port_of_Loading__c= true;
        //sdh.Reference_Number__c='h1h2';
        //sdh.Reason_For_Late_Declaration__c='';
        //sdh.Reason_For_Cancellation__c='';
        sdh.Reason_For_Amendment__c='';
        sdh.Pre_Shipment_Declaration__c=false;
        //sdh.Port_Of_Loading_Approval__c='Approved';
        sdh.Policy__c = pol.id;
        //sdh.Invoiced__c=false;
        sdh.Gross_Invoice_Value__c=100;
        //sd.Gross_Invoice_Value__c='HKD';
        sdh.Buyer_Name__c='Buyer Name';
        sdh.Buyer_Code__c='Buyer Code';
        //sdh.Amend_Approval_Required__c=true;
        //sdh.Amend_Approved_by_Leader__c = false;
        
        sdh.Payment_Term_Type__c='DA';
        //sdh.Shipment_Month__c='March';
        sdh.Payment_Term_Days__c=40;
        sdh.Shipment_Declaration__c = sd.id;
        insert sdh;

        Invoice__c invObj = new Invoice__c();
        invObj.Account__c = acc.id;
        invObj.Installment_Type__c='F';
        //invObj.Invoice_Date__c=getDate(System.now());
        invObj.Policy__c = pol.id;
        invObj.Status__c ='UnPaid';
        invObj.Payment_Reminder_Date__c=Date.today();
        invObj.Due_Date__c=Date.today();
        invObj.Frist_Reminder_Date__c=Date.today();
        invObj.Second_Reminder_Date__c=Date.today();
        //invObj.Payment_Date__c=Date.today();
        //invObj.Effective_Date__c=Date.today();
        insert invObj;

        Invoice_Line__c invLineObj = new Invoice_Line__c();
        invLineObj.Invoice__c = invObj.id;
        invLineObj.Buyer_s_Code__c = 'B001';
        invLineObj.Line_Amount__c =100; 
        invLineObj.Net_Premium__c =100; 
        invLineObj.Payment_Terms__c='OA 30';
        invLineObj.Premium_Due_Date__c=Date.today();
        insert invLineObj;

        Payment__c pay = new Payment__c();
        pay.Payment_Date__c=Date.today();
        pay.Description__c='';
        pay.Amount__c=100;
        pay.Invoice__c=invObj.id;
        pay.Status__c='ACCEPT';
        pay.Policy__c=pol.id;
        insert pay;



        User portalUser = new User(

            ProfileId = [SELECT Id FROM Profile WHERE Name = 'EC-Reach Login Profile'].Id,
            LastName = 'Last',
            ContactId = con.Id,
            Email = 'satya@ckp.com',
            Username = 'satya@ckp.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert portalUser;

        CMS_Content__c cms = new CMS_Content__c();
        cms.Content_Id__c='123456789';
        cms.Content_URL__c='https://kennychun--dev2.lightning.force.com/lightning/cms/spaces/0Zu0l0000008ON5CAM/content/20Y0l00000000DyEAI/5OU0l00000000ZmGAI';
        cms.Product__c=prodSBP.id;
        cms.Published_Date__c=Date.today();
        cms.Status__c='Published';
        insert cms;

        ECIC_Document__c ecicDoc = new ECIC_Document__c();
        ecicDoc.Status__c='Invalid';
        ecicDoc.Account__c=acc.id;
        ecicDoc.First_Rejection_Mail_Sent__c=true;
        ecicDoc.First_Reminder_Email_Sent__c=false;
        ecicDoc.First_Rejection_Mail_Sent_Date__c=Datetime.now().addDays(-6);
        //ecicDoc.is_7th_Day_Email_Reminder_Req__c=true;
        ecicDoc.Second_Reminder_Email_Sent__c=false;
        insert ecicDoc;
        //Datetime yesterday = Datetime.now().addDays(-6);
        //Test.setCreatedDate(ecicDoc.Id, yesterday);
        ECIC_Document__c ecicNew = [select createdDate, First_Rejection_Mail_Sent__c,
        First_Reminder_Email_Sent__c,
        Second_Reminder_Email_Sent__c,
        is_7th_Day_Email_Reminder_Req__c, 
        First_Rejection_Mail_Sent_Date__c
         from ECIC_Document__c where id = :ecicDoc.id  ];
        System.debug(Datetime.now().addDays(-6)+'==>ecicNew:'+ecicNew);

        Map<String,String> respMap = new Map<String,string>();
        respMap.put('shipmentID',sd.id);
        respMap.put('user_id',portalUser.id);
        respMap.put('policyID',pol.id);
        respMap.put('invoiceID',invObj.id);
        respMap.put('cla_id',cla.id);//
        respMap.put('endorsementID',relEnd.id);

        return respMap;
    }
    
    public static ECIC_Settings__c createEcicSettings(){
        
        ECIC_Settings__c settings = new ECIC_Settings__c(
        Name='ECIC_UAT', 
        Access_Token__c='3ByIUWx45HU3aXg',
        Access_Token_Updated__c=Datetime.newInstance(2021,09,28, 10,44,08), 
        Access_Token_Valid_Upto__c=Datetime.newInstance(2021,09,28, 11,44,08), 
        ecic_hmac_key__c='mt9c1Re4G6RiKUxnQa', 
        ecic_public_key__c='Gn4eB1ciY', 
        ecic_public_rsa_key__c='IDAQAB', 
        ecic_uat_hmac_key__c='mt9c1Re4G6RiK', 
        ecic_uat_public_key__c='Gn4eB1', 
        ecic_uat_public_rsa_key__c='RajX8XdkwIDAQAB', 
        ecic_private_rsa_key__c='YTW7kExS1iH450Jk', 
        ecic_uat_private_rsa_key__c='TjkEOI8exYTW7kExS1iH450Jk', 
        Intialization_Vector__c='Example of IV256', 
        sf_private_rsa_key__c='nN7elYD43tML', 
        sf_public_rsa_key__c='rQIDAQAB', 
        sf_uat_private_rsa_key__c='YJvZrQIDAQAB', 
        test_mode__c=true, 
        ECIC_API_Client_ID__c='XXXXXXX_dev', 
        ECIC_API_Client_Secret__c='kJSAbfkjn', 
        ECIC_API_Password__c='abcdef', 
        ECIC_API_Username__c='XXXXXXXX_dev', 
        ECIC_UAT_API_Client_ID__c='XXXXXXX_dev', 
        ECIC_UAT_API_Client_Secret__c='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
        ECIC_UAT_API_Password__c='XXXXXXXXXXXXXXXXXXX', 
        ECIC_UAT_API_Username__c='XXXXXXXX_dev',
        Charge_Deposit__c=100,
        //Create SBP Invoice,Change Payment Reminder Date,Reset Maximum Liability,Three Days older Task Reminder,BR Reminder
        Batch_To_Schedule__c='Create SBP Invoice',
        Time_To_Schedule_SBP_Invoice_Batch__c=System.now(),
        Time_To_Schedule_Task_Remider_Email__c=System.now(),
        Time_To_Schedule_BR_Reminder_Batch__c=System.now(),
        Enable_Monthy_Lump_Sum__c=true,
        Allowed_Port_of_Loading__c='India'
        );
        insert settings;
        System.debug('Test Class Debug settings===>>'+settings);
        return settings;
    }
    public static Account createAccount() {
        Account acc = new Account(Name='TestAccount',Legacy_Customer_Number__c='372527');
        insert acc;
        return acc;
    }
    public static Contact createContact(String accID) {
        Contact con=new Contact();
        con.AccountId=accID;
        con.LastName='Last';
        con.FirstName='FN';
        con.Email='test@ecic.com';
        insert con;
        return con;
    }
    public static ECIC_Document__c createEcicDocument(String accID) {
        ECIC_Document__c ecicDoc = new ECIC_Document__c();
        ecicDoc.Status__c='Invalid';
        ecicDoc.Account__c=accID;
        ecicDoc.First_Rejection_Mail_Sent__c=true;
        ecicDoc.First_Reminder_Email_Sent__c=false;
        ecicDoc.First_Rejection_Mail_Sent_Date__c=Datetime.now().addDays(-6);
        //ecicDoc.is_7th_Day_Email_Reminder_Req__c=true;
        ecicDoc.Second_Reminder_Email_Sent__c=false;
        insert ecicDoc;
        return ecicDoc;
    }
    
    
    public static Plan__c createProduct(String plan_type){
        Plan__c prod = new Plan__c(Name=plan_type,
        Max_Authorised_Person_Count__c=10,
        Max_Beneficiary_Count__c=10,
        Max_Director_Count__c=10);
        insert prod;
        return prod;
    }
    public static Proposal__c createProposal(String accId){
        Proposal__c proposal = new Proposal__c(Account__c=accId);
        insert proposal;
        return proposal;
    }
    public static Quote__c createQuotation(String accId){
        Quote__c quotation = new Quote__c(Account__c=accId);
        insert quotation;
        return quotation;
    }

    public static Policy__c createPolicyWithSchedule(Id prod_id,Id acc_id) {
        Policy__c policy = new Policy__c(
        Status__c='Open',
        Product__c=prod_id,
        Free_Credit_Check__c=10,
        Used_Credit_check__c=0,
        Commencement_Date__c=Date.today().addMonths(-13),
        Effective_Date__c=Date.today(),
        Issue_Date__c=Date.today().addDays(-5),
        Expiry_Date__c=Date.today().adddays(365),
        Exporter__c=acc_id, 
        Sync_with_Legacy__c=false,       
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
        return policy;
    }
    public static Policy_Schedule__c createPolicySchedule(Id policy_id) {
        
        Policy_Schedule__c schedule = new Policy_Schedule__c(
        Policy__c=policy_id,
        Effective_Date__c=Date.today().addDays(-5),
        Issue_Date__c=Date.today().addDays(-5),
        Maximum_Liability__c=150000,
        Type__c='Schedule 1'
        );
        insert schedule;
        return schedule;
    }
    public static Credit_Limit_Application__c createCLA(Id acc_id, Id policy_id){
        Credit_Limit_Application__c cl_app = new Credit_Limit_Application__c(
                Buyer_Name__c='ABC',
                Buyer_Code__c='12345',
                Buyer_Address_Line_1__c='abab',
                Buyer_Address_Line_2__c='iopipo',
                Buyer_Address_Line_3__c='alojj',
                Buyer_Address_Line_4__c='pwieo',
                Application_Date__c=Date.today().addDays(-5),
                CL_Application_Amount__c=10000,
                CL_Status__c='Processing',
                Exporter__c=acc_id,
                Policy__c=policy_id,
                Legacy_Ref_No__c='656464',
                Legacy_Pre_Ref_No__c='787878'
            );
            insert cl_app;
            return cl_app;
    }
    public static Credit_Limit__c createCL(Id acc_id, Id policy_id){
        Credit_Limit__c cl = new Credit_Limit__c(
                Buyer_Name__c='ABC',
                Buyer_Code__c='12345',
                Buyer_Address_Line_1__c='abab',
                Buyer_Address_Line_2__c='iopipo',
                Buyer_Address_Line_3__c='alojj',
                Buyer_Address_Line_4__c='pwieo',
                Application_Date__c=Date.today().addDays(-5),
                CL_Application_Amount__c=10000,
                CL_Amount__c=10000,
                CL_Status__c='Valid',
                Exporter__c=acc_id,
                Policy__c=policy_id,
                Legacy_Ref_No__c='656464'
            );
            insert cl;
            return cl;
    }
}