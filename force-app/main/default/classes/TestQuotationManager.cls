@isTest
public with sharing class TestQuotationManager {

    private static Map<String,Id> setup(){
        Plan__c prod = new Plan__c(Name='SUP',
        Max_Authorised_Person_Count__c=10,
        Max_Beneficiary_Count__c=10,
        Max_Director_Count__c=10);
        insert prod;
        Plan__c prod2 = new Plan__c(Name='SBP',
        Max_Authorised_Person_Count__c=10,
        Max_Beneficiary_Count__c=10,
        Max_Director_Count__c=10);
        insert prod2;
        
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
		return new Map<String,Id>{'ac_id'=>testAccount.Id, 'usr_id' => communityUser.Id, 'profile_id'=> ProfileId,
        'product_id1'=>prod.Id,  'product_id2'=>prod2.Id};
	}

    @IsTest(SeeAllData=true)
    static void commonTest(){
		Test.startTest();
		Map<String, Id> res = setup();

	
		Map<String,String> prop = new Map<String, String>{'First_Name__c'=>'Aridam', 'Last_Name__c'=>'Mondal', 'account__c'=>res.get('ac_id'),'company_name__c'=>'supchinese','company_email__c'=>'saswata@chikpea.com','Past_Turnover__c'=>'HKD 10,000,001 – 20,000,000','Future_Turnover__c'=>'HKD 20,000,001 – 30,000,000','Insurable_Turnover__c'=>'123','Sales_Amount_Range__c'=>'321','Insurable_Buyers__c'=>'123','Self_Approving_CL__c'=>'No','Buyer_Country_Market__c'=>'ALAND ISLANDS;ALBANIA','Product__c'=>res.get('product_id1'),'Indemnity_Ratio__c'=>'20','NQL__c'=>'5','Base_Rate_Per_Anum__c'=>'1.2','Base_Loading__c'=>'40','Policy_Type__c'=>'56','Indemnity_Percentage__c'=>'60','NQL_Amount__c'=>'50000','Auto_Renewal__c'=>'Automatic Renewal','Language_of_Correspondence__c'=>'English','Policy_Commence_Date__c'=>'2021-12-01','Maximum_Liability__c'=>'1500000','Company_Legal_Type__c'=>'Partnership','Bank_Account__c'=>'false','Payment_Option__c'=>'One-Off','Goods_And_Service__c'=>'12','Bad_Debt_Amount__c'=>'123121','Overdue_Amount__c'=>'123131','BR_Number__c'=>'12312312','BR_Expiry_Date__c'=>'2022-02-25','BR_Document__c'=>'TEST_UPLOAD - Copy.pdf','Corporate_Incorporation_Date__c'=>'2021-10-31','Registered_Territory__c'=>'KOWLOON','Registered_District__c'=>'SHAM SHUI PO','Registered_Correspondence_Same__c'=>'true','Correspondence_Territory__c'=>'KOWLOON','Correspondence_District__c'=>'SHAM SHUI PO','Application_Reason__c'=>'Financing','Contact_Name__c'=>'Saswata Chinese','Title__c'=>'test','Company_Telephone_Number__c'=>'1235467890','Know_About_Hkecic__c'=>'Advertisement=> Magazine','Benificiary_Owners__c'=>'[{\"name\":\"test\",\"type\":\"Director\",\"key\":0,\"editable\":true,\"LastName\":\"test\",\"FirstName\":\"\"}]','Buyer_List__c'=>'','Registered_Address_Line_1__c'=>'23351 lane','Registered_Address_Line_2__c'=>'','Registered_Address_Line_3__c'=>'','Correspondence_Address_Line_1__c'=>'23351 lane','Correspondence_Address_Line_2__c'=>'','Correspondence_Address_Line_3__c'=>'','Receive_Date__c'=>'2021-11-05','Mobile_Number__c'=>'123123121'};
		Id pId=OnboardingCreateSiteUser.createProposal(prop);
		prop.put('Id', pId);

        Map<String,String> prop2 = new Map<String, String>{'First_Name__c'=>'Aridam', 'Last_Name__c'=>'Mondal', 'account__c'=>res.get('ac_id'),'company_name__c'=>'supchinese','company_email__c'=>'saswata@chikpea.com','Past_Turnover__c'=>'HKD 10,000,001 – 20,000,000','Future_Turnover__c'=>'HKD 20,000,001 – 30,000,000','Insurable_Turnover__c'=>'123','Sales_Amount_Range__c'=>'321','Insurable_Buyers__c'=>'123','Self_Approving_CL__c'=>'No','Buyer_Country_Market__c'=>'ALAND ISLANDS;ALBANIA','Product__c'=>res.get('product_id2'),'Indemnity_Ratio__c'=>'20','NQL__c'=>'5','Base_Rate_Per_Anum__c'=>'1.2','Base_Loading__c'=>'40','Policy_Type__c'=>'56','Indemnity_Percentage__c'=>'60','NQL_Amount__c'=>'50000','Auto_Renewal__c'=>'Automatic Renewal','Language_of_Correspondence__c'=>'English','Policy_Commence_Date__c'=>'2021-12-01','Maximum_Liability__c'=>'1500000','Company_Legal_Type__c'=>'Partnership','Bank_Account__c'=>'false','Payment_Option__c'=>'One-Off','Goods_And_Service__c'=>'12','Bad_Debt_Amount__c'=>'123121','Overdue_Amount__c'=>'123131','BR_Number__c'=>'12312312','BR_Expiry_Date__c'=>'2022-02-25','BR_Document__c'=>'TEST_UPLOAD - Copy.pdf','Corporate_Incorporation_Date__c'=>'2021-10-31','Registered_Territory__c'=>'KOWLOON','Registered_District__c'=>'SHAM SHUI PO','Registered_Correspondence_Same__c'=>'true','Correspondence_Territory__c'=>'KOWLOON','Correspondence_District__c'=>'SHAM SHUI PO','Application_Reason__c'=>'Financing','Contact_Name__c'=>'Saswata Chinese','Title__c'=>'test','Company_Telephone_Number__c'=>'1235467890','Know_About_Hkecic__c'=>'Advertisement=> Magazine','Benificiary_Owners__c'=>'[{\"name\":\"test\",\"type\":\"Director\",\"key\":0,\"editable\":true,\"LastName\":\"test\",\"FirstName\":\"\"}]','Buyer_List__c'=>'','Registered_Address_Line_1__c'=>'23351 lane','Registered_Address_Line_2__c'=>'','Registered_Address_Line_3__c'=>'','Correspondence_Address_Line_1__c'=>'23351 lane','Correspondence_Address_Line_2__c'=>'','Correspondence_Address_Line_3__c'=>'','Receive_Date__c'=>'2021-11-05','Mobile_Number__c'=>'123123121'};
		Id pId2=OnboardingCreateSiteUser.createProposal(prop2);
		prop.put('Id', pId2);

        
        QuotationManager.Response qts= QuotationManager.createQuote(pId);
		Quote__c quote= qts.quotations[0];
        QuotationManager.createPolicy(quote.Id);

        QuotationManager.Response qts2= QuotationManager.createQuote(pId2);
		Quote__c quote2= qts2.quotations[0];
        QuotationManager.createPolicy(quote2.Id);

        // QuotationManager.getPublishedContentIds(null);
        QuotationManager.getCMSontentByContentIds(new List<String>{'a0T5D000002YgUMUA0'});
        
		new QuotationManager.Response();


        Test.stopTest();
    }
}