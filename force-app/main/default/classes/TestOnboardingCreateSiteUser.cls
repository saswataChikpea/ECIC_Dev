@isTest
private class TestOnboardingCreateSiteUser{

	private static Map<String,Id> setup(){

		Account testAccount = new Account(name ='Test Account');
        insert testAccount;
		Id profileId = [Select Id From Profile Where Name = 'EC-Reach Login Profile' LIMIT 1].Id;
		
		Contact con = new Contact(LastName ='testCon',AccountId = testAccount.Id);
		insert con;
		
		User communityUser = new User(FirstName = 'Test', LastName = 'User',
		Email = 'test.user@invalid.com',
		ContactId = con.Id,

		ProfileId = profileId, UserName =  'test-user@fakeemail.com',
		Alias = 'tuser1', CommunityNickName = 'hexDigest1122', TimeZoneSidKey = 'America/New_York',
		LocaleSidKey = 'en_US', EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US'
		);
		insert communityUser;

		Verification_Method__c vm = new Verification_Method__c(Account__c= testAccount.Id,
		EMAIL__c= true);
		insert vm; 
		return new Map<String,Id>{'ac_id'=>testAccount.Id, 'usr_id' => communityUser.Id, 'profile_id'=> ProfileId};
	}
	/*
	@IsTest
	static void testGetVerificationStatus(){
		
		Test.startTest();
		Account accountObj = new Account (
			Proposal_Data__c = 'Test Value', 
			Is_Email_Verified__c = TRUE, 
			Name = 'Debjyoti Account'
		);
		insert accountObj;
		Contact  contactObj = new Contact(
			AccountId = accountObj.Id,
			LastName = 'Debjyoti Contact'
		);
		insert contactObj;
		Verification_method__c verificationmethodcObj = new Verification_method__c (
			Account__c = accountObj.Id, 
			EMAIL__c = TRUE, 
			SMS__c = TRUE
		);
		insert verificationmethodcObj;
		User userObj = new User(
			Username = 'debjyoti@test.com',
			Email = 'debjyoti@b4b.ai',
			FirstName = 'Debjyoti',
			LastName = 'ECIC'
			// ProfileId =  1
		);
		insert userObj;
		Verification_Method__c vslist = OnboardingCreateSiteUser.getVerificationStatus(userObj.Id);
		Test.stopTest();
		
	}
	@IsTest
	static void testCreateUserId(){
		
		Test.startTest();
		
		Test.stopTest();
		
	}*/

	@IsTest
	static void createAccountTest(){
		Test.startTest();
		Map<String,String> accDetail = new Map<String,String>{'Name'=>'TEST'};
		Map<String,String> userDetail = new Map<String,String>{
			'Account_Name'=> 'ecic test data', 'FirstName'=> '', 'LastName'=> 'aridummy5', 'Email'=> 'arindam@chikpea.com', 'Mobile'=> '237',
			'Username'=> 'aridummy5i234t@chikpea.com', 'Password'=> 'Get2work$', 'Confirm_Password'=> 'Get2work$'
		};
		Map<String,String>  brFile = new Map<String,String>{
			'file'=> '2FtrcXmzT9i69ZtGDEiBBEREY%2BFBLlcjqiodZBIJFiwYAHs7bu0Sp8CNKKgQAghhBCNKCgQQgghRCMKCoQQQgjRiIICIYQQQjT6P8%2BQ4O5m9dX6AAAAAElFTkSuQmCC',
			'filename'=> 'zen7.png'
		};
		OnboardingCreateSiteUser.Response res = OnboardingCreateSiteUser.createAccount(accDetail, userDetail, 'propsal1', brFile, '12345678');
		OnboardingCreateSiteUser.Response res1 = OnboardingCreateSiteUser.initEmailVerify('aridummy5i234t@chikpea.com', 'Get2work$');
		OnboardingCreateSiteUser.Response res2 = OnboardingCreateSiteUser.verifyEmail('123456');
		//System.assertEquals(res.statusCode, 100);

		
		Test.stopTest();
	}
	@IsTest
	static void getVerificationStatusTest(){
		Test.startTest();
		Map<String, Id> res = setup();

	
		Map<String,String> prop = new Map<String, String>{'First_Name__c'=>'Aridam', 'Last_Name__c'=>'Mondal', 'account__c'=>res.get('ac_id'),'company_name__c'=>'supchinese','company_email__c'=>'saswata@chikpea.com','Past_Turnover__c'=>'HKD 10,000,001 – 20,000,000','Future_Turnover__c'=>'HKD 20,000,001 – 30,000,000','Insurable_Turnover__c'=>'123','Sales_Amount_Range__c'=>'321','Insurable_Buyers__c'=>'123','Self_Approving_CL__c'=>'No','Buyer_Country_Market__c'=>'ALAND ISLANDS;ALBANIA','Product__c'=>null,'Indemnity_Ratio__c'=>'20','NQL__c'=>'5','Base_Rate_Per_Anum__c'=>'1.2','Base_Loading__c'=>'40','Policy_Type__c'=>'56','Indemnity_Percentage__c'=>'60','NQL_Amount__c'=>'50000','Auto_Renewal__c'=>'Automatic Renewal','Language_of_Correspondence__c'=>'English','Policy_Commence_Date__c'=>'2021-12-01','Maximum_Liability__c'=>'1500000','Company_Legal_Type__c'=>'Partnership','Bank_Account__c'=>'false','Payment_Option__c'=>'One-Off','Goods_And_Service__c'=>'12','Bad_Debt_Amount__c'=>'123121','Overdue_Amount__c'=>'123131','BR_Number__c'=>'12312312','BR_Expiry_Date__c'=>'2022-02-25','BR_Document__c'=>'TEST_UPLOAD - Copy.pdf','Corporate_Incorporation_Date__c'=>'2021-10-31','Registered_Territory__c'=>'KOWLOON','Registered_District__c'=>'SHAM SHUI PO','Registered_Correspondence_Same__c'=>'true','Correspondence_Territory__c'=>'KOWLOON','Correspondence_District__c'=>'SHAM SHUI PO','Application_Reason__c'=>'Financing','Contact_Name__c'=>'Saswata Chinese','Title__c'=>'test','Company_Telephone_Number__c'=>'1235467890','Know_About_Hkecic__c'=>'Advertisement=> Magazine','Benificiary_Owners__c'=>'[{\"name\":\"test\",\"type\":\"Director\",\"key\":0,\"editable\":true,\"LastName\":\"test\",\"FirstName\":\"\"}]','Buyer_List__c'=>'','Registered_Address_Line_1__c'=>'23351 lane','Registered_Address_Line_2__c'=>'','Registered_Address_Line_3__c'=>'','Correspondence_Address_Line_1__c'=>'23351 lane','Correspondence_Address_Line_2__c'=>'','Correspondence_Address_Line_3__c'=>'','Receive_Date__c'=>'2021-11-05','Mobile_Number__c'=>'123123121'};
		Id pId=OnboardingCreateSiteUser.createProposal(prop);
		prop.put('Id', pId);
		OnboardingCreateSiteUser.createProposal(prop);
		OnboardingCreateSiteUser.getProposalData(res.get('usr_id'));
		OnboardingCreateSiteUser.getLastProposal(res.get('usr_id'));
		OnboardingCreateSiteUser.getProposal(res.get('usr_id'));
		OnboardingCreateSiteUser.getProposalList(res.get('usr_id'));
		OnboardingCreateSiteUser.getQuotationList(res.get('usr_id'));
		
		OnboardingCreateSiteUser.getCompleteProposal(pId);
		
		QuotationManager.Response qts= QuotationManager.createQuote(pId);
		Quote__c quote= qts.quotations[0];
		// OnboardingCreateSiteUser.getQuotation(null);
		// OnboardingCreateSiteUser.getProposalFromQuote(null);
		OnboardingCreateSiteUser.getQuotation(quote.Id);
		OnboardingCreateSiteUser.getProposalFromQuote(quote.Id);

		Map<String,String> data = new Map<String, String>{
			'Id'=> pId,
			'CUS_NO__c'=> '234567',
			'Is_Legacy_Verified__c'=> 'true',
			'Is_Error__c'=> 'false',
			'Legacy_Response__c'=> 'TEST DATA'
		};
		
		OnboardingCreateSiteUser.updateProposal(data);
		
		OnboardingCreateSiteUser.getVerificationStatus(res.get('usr_id'));
		OnboardingCreateSiteUser.checkDupliateEmail(res.get('usr_id'));
		OnboardingCreateSiteUser.EmailVerifySuccessful(res.get('usr_id'));
		
		OnboardingCreateSiteUser.reviseQuotation(prop, quote.Id);

		
		Map<SObjectField,String> registrationAttributes= new Map<SObjectField,String>{
			
		};
		OnboardingCreateSiteUser siteUser= new OnboardingCreateSiteUser();
		siteUser.createUser(res.get('ac_id'), res.get('profile_id'), registrationAttributes, 'Get2work$');


		Test.stopTest();
	}

	@IsTest
	static void createProposalTest(){
		Test.startTest();
		Map<String, Id> res = setup();
		new OnboardingCreateSiteUser.AuthPerson();
		new OnboardingCreateSiteUser.Response();
		
		Test.stopTest();
	}
}