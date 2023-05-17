@isTest
private class PolicyManagementTest {
   
    @isTest
    static void testForSBP() {
        Test.startTest();
        Plan__c prodSBP= new Plan__c();
        prodSBP.name='SBP';
        prodSBP.Max_Authorised_Person_Count__c=10;
        prodSBP.Max_Beneficiary_Count__c=10;
        prodSBP.Max_Director_Count__c=10;
        insert prodSBP;
        
        
        
        Account acc=new Account(); 
        acc.name='SBP Acc';
        insert acc;
        
        Contact con=new Contact();
        con.AccountId=acc.id;
        con.LastName='Last';
        insert con;
        
        Policy__c pol = new Policy__c();
        pol.Product__c = prodSBP.id;
        pol.Exporter__c = acc.id;
        insert pol;

        Policy_Schedule__c polSch = new Policy_Schedule__c();
        polSch.Policy__c=pol.id;
        polSch.Percentage_of_Indemnity__c=90;
        polSch.Policyholder_s_Address__c='Room 123,1234 ABC Street District A';
        polSch.Maximum_Liability__c=100000.00;
        polSch.Type__c='Schedule 1';
        insert polSch;


        
        acc.Current_Policy__c = pol.id;
        update acc;

        //User portalUser=new User();
        //portalUser.ContactId=con.id;
        //insert portalUser;

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


        //PolicyManagement.getAccountID(portalUser.Id);
        PolicyManagement.getAllPolicy(acc.Id);
        PolicyManagement.getAccountDetails(acc.Id);
        PolicyManagement.getAllSchedule(portalUser.Id);
        PolicyManagement.getPolicyHolderData(portalUser.Id);
        PolicyManagement.terminatePolicy(pol.Id,'Others');
        PolicyManagement.getDomainBaseURL();
        System.assertEquals('expected', 'actual', 'msg');
        Test.stopTest();
    }

    @isTest
    static void testForSUP() {
        //Plan__c prodOMBP= new Plan__c();
        //prodOMBP.name='OMBP';
        //insert prodOMBP;
        
        Plan__c prodSBP= new Plan__c();
        prodSBP.name='SUP';
        prodSBP.Max_Authorised_Person_Count__c=10;
        prodSBP.Max_Beneficiary_Count__c=10;
        prodSBP.Max_Director_Count__c=10;
        insert prodSBP;
        
        //Plan__c prodSUP= new Plan__c();
        //prodSUP.name='SUP';
        //insert prodSUP;
        
        
        Account acc=new Account(); 
        acc.name='SUP Acc';
        insert acc;
        
        Contact con=new Contact();
        con.AccountId=acc.id;
        con.LastName='Last';
        insert con;
        
        Policy__c pol = new Policy__c();
        pol.Product__c = prodSBP.id;
        pol.Exporter__c = acc.id;
        insert pol;

        Policy_Schedule__c polSch = new Policy_Schedule__c();
        polSch.Policy__c=pol.id;
        polSch.Percentage_of_Indemnity__c=90;
        polSch.Policyholder_s_Address__c='Room 123,1234 ABC Street District A';
        polSch.Maximum_Liability__c=100000.00;
        polSch.Type__c='Schedule 1';
        insert polSch;


        
        acc.Current_Policy__c = pol.id;
        update acc;

        //User portalUser=new User();
        //portalUser.ContactId=con.id;
        //insert portalUser;

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


        //PolicyManagement.getAccountID(portalUser.Id);
        PolicyManagement.getAllPolicy(acc.Id);
        PolicyManagement.getAccountDetails(acc.Id);
        PolicyManagement.getAllSchedule(portalUser.Id);
        PolicyManagement.getPolicyHolderData(portalUser.Id);
        PolicyManagement.terminatePolicy(pol.Id,'Others');
        
    }

    @isTest
    static void testForOMBP() {
       
        
        Plan__c prodSBP= new Plan__c();
        prodSBP.name='OMBP';
        prodSBP.Max_Authorised_Person_Count__c=10;
        prodSBP.Max_Beneficiary_Count__c=10;
        prodSBP.Max_Director_Count__c=10;
        insert prodSBP;
        
        //Plan__c prodSUP= new Plan__c();
        //prodSUP.name='SUP';
        //insert prodSUP;
        
        
        Account acc=new Account(); 
        acc.name='OMBP Acc';
        insert acc;
        
        Contact con=new Contact();
        con.AccountId=acc.id;
        con.LastName='Last';
        insert con;
        
        Policy__c pol = new Policy__c();
        pol.Product__c = prodSBP.id;
        pol.Exporter__c = acc.id;
        insert pol;

        Policy_Schedule__c polSch = new Policy_Schedule__c();
        polSch.Policy__c=pol.id;
        polSch.Percentage_of_Indemnity__c=90;
        polSch.Policyholder_s_Address__c='Room 123,1234 ABC Street District A';
        polSch.Maximum_Liability__c=100000.00;
        polSch.Type__c='Schedule 1';
        insert polSch;


        
        acc.Current_Policy__c = pol.id;
        update acc;

        //User portalUser=new User();
        //portalUser.ContactId=con.id;
        //insert portalUser;

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


        

        Endorsement__c endorse = new Endorsement__c();
        endorse.Name= 'EN48A';
        endorse.Approval_Required__c='Yes';
        insert endorse;

        Related_Endorsement__c relEnd = new  Related_Endorsement__c();
        relEnd.Endorsement_Type__c = endorse.ID;
        relEnd.Policy__c = pol.Id;
        relEnd.Status__c = 'Approved';
        insert relEnd;

        //PolicyManagement.getAccountID(portalUser.Id);
        PolicyManagement.getAllPolicy(acc.Id);
        PolicyManagement.getAccountDetails(acc.Id);
        PolicyManagement.getAllSchedule(portalUser.Id);
        PolicyManagement.getPolicyHolderData(portalUser.Id);
        PolicyManagement.terminatePolicy(pol.Id,'Others');
        PolicyManagement.fetchAllEndorsements(pol.Id);
        PolicyManagement.getInvoiceData(portalUser.id);
        PolicyManagement.acknowledgePolicyTermination(pol.id);
        PolicyManagement.autoRenwalDateChecking(Date.today());
        PolicyManagement.upDateAutoRenewalSetting('Automatic Renewal',pol.id);
        //PolicyManagement.saveDynamicPrice(polSch.id,true,false,false,'DE',1.1,1.1,1.1,1.1,1.1,1.1,1.1,true,false);

        

        
    }

}