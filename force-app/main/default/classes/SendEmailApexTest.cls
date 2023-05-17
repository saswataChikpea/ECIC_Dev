@isTest
public with sharing class SendEmailApexTest {
    private static Map<String,Id> setup(){
        Account testAccount = new Account(name ='Test Account', Language_of_Correspondence__c='Chinese');
        insert testAccount;
        Contact con = new Contact(LastName ='testCon',AccountId = testAccount.Id, Email = 'satya@ckp.com',
        Enable_Email_Notification__c=true);
		insert con;
        // Id profileId = [Select Id From Profile Where Name = 'EC-Reach Login Profile' LIMIT 1].Id;
        // User communityUser = new User(FirstName = 'Test', LastName = 'User',
		// Email = 'test.user@invalid.com',
		// ContactId = con.Id,

		// ProfileId = profileId, UserName =  'test-user@fakeemail.com',
		// Alias = 'tuser1', CommunityNickName = 'hexDigest1122', TimeZoneSidKey = 'America/New_York',
		// LocaleSidKey = 'en_US', EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US'
		// );
		// insert communityUser;

		// Verification_Method__c vm = new Verification_Method__c(Account__c= testAccount.Id,
		// EMAIL__c= true);
		// insert vm; 

        User smeUser = new User(

            ProfileId = [SELECT Id FROM Profile WHERE Name = 'SME Team Staff'].Id,
            LastName = 'Last',
            //ContactId = con.Id,
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
        insert smeUser;
        

        ECIC_Document__c ecicDoc = new ECIC_Document__c();
        ecicDoc.Status__c='Invalid';
        ecicDoc.Account__c=testAccount.id;
        ecicDoc.First_Rejection_Mail_Sent__c=true;
        ecicDoc.First_Reminder_Email_Sent__c=false;
        ecicDoc.First_Rejection_Mail_Sent_Date__c=Datetime.now().addDays(-6);
        //ecicDoc.is_7th_Day_Email_Reminder_Req__c=true;
        ecicDoc.Second_Reminder_Email_Sent__c=false;
        insert ecicDoc;

        return new Map<String,Id>{'ac_id'=>testAccount.Id, 'attachmentId'=>ecicDoc.Id};
        //, 'usr_id' => communityUser.Id, 'profile_id'=> ProfileId,
        //'product_id1'=>prod.Id,  'product_id2'=>prod2.Id
    }
    @isTest(seeAllData=true)
    static void testSendEmailAccount(){
        Test.startTest();
		Map<String, Id> res = setup();
        SendEmailApex.SendEmailRequest emailRequest = new SendEmailApex.SendEmailRequest();
        emailRequest.accId = res.get('ac_id');
        emailRequest.whatId = res.get('ac_id');
        emailRequest.templateName = 'Email_First_Response';
        emailRequest.ccSME = true;
        emailRequest.attachmentIds = ''+res.get('attachmentId');
        //emailRequest.runtimeAttachmentUrls = '/apex/P055_Proposal_Form';
        SendEmailApex.sendEmailFromProcessBuider(new List<SendEmailApex.SendEmailRequest>{emailRequest});

        SendEmailApex.sendEmailFuture(res.get('ac_id'), res.get('ac_id'), 'Email_First_Response', false, null, '/apex/P055_Proposal_Form');

        SendEmailApex.sendEmailSME('Email_First_Response', res.get('ac_id'));

        Test.stopTest();                
    }
}