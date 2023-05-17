@isTest
private class TestOnBoarding{

	@isTest public static void setup(){
		// Onboarding_Setting__mdt onboardingSettingObj = new Onboarding_Setting__mdt(
		// 	MasterLabel='Test', 
		// 	Max_No_Questions__c=1, 
		// 	DeveloperName='Onboarding_Setting',
		// 	// Step_1A_Banner__c=''
		// );
		// insert onboardingSettingObj;
		OnBoarding.getOnboardingSetting();
		Plan__c plancObj = new Plan__c (
			Name = 'test value', 
			Display_Sequence__c = 1.1, 
			Full_Name__c = 'test value', 
			Image_Url__c = 'test value', 
			Max_Authorised_Person_Count__c = 1.1, 
			Max_Beneficiary_Count__c = 1.1, 
			Max_Director_Count__c = 1.1
		);
		insert plancObj;
		Product_feature__c productfeaturecObj = new Product_feature__c (
			Criteria_Label__c = 'Criteria Label test value', 
			Criteria_Value__c = 'Criteria test value', 
			Display_Sequence__c = 1.1, 
			// Feature_Element__c = 'Here is reference id', 
			Show_Feature__c = true,
			Parent_Feature__c ='Eligbility', 
			Weightage__c = 1.1, 
			Comparison_Operator__c = 'Comparison Opeartor test value',
			Plan__c = plancObj.Id
		);
		insert productfeaturecObj;
		Feature_element__c featureelementcObj = new Feature_element__c (
			Name = 'test value', 
			Data_Type__c ='Text', 
			Display_Sequence__c = 1.1, 
			Question__c = 'test value', 
			Sub_Display_Sequence__c = 1.1,
			Is_PI_Question__c = true
		);
		insert featureelementcObj;
		Dynamic_price__c dynamicpricecObj = new Dynamic_price__c (
			Credit_Limit__c = 1.1, 
			Indemnity_Ratio__c ='0', 
			Maximum_Liability__c = 1.1, 
			Non_Qualify_Loss__c ='5', 
			Premium_Rate_On__c ='Credit Limit', 
			Product__c = plancObj.Id
		);
		insert dynamicpricecObj;
		Discount__c discountObj = new Discount__c(
			Discount_Type__c = 'Percent', 
			Is_Active__c = true, 
			Is_Default__c = true,
			Value__c = 10
		);
		insert discountObj;
}

	@isTest static void testGetProducts() {
		Test.startTest();
		Price_Book__c priceObj = new Price_Book__c(
			Active__c = true,
			Name='ECIC Pricebook'
		);
		insert priceObj;
		Plan__c plancObj = new Plan__c (
			Name = 'test value', 
			Display_Sequence__c = 1.1, 
			Full_Name__c = 'test value', 
			Image_Url__c = 'test value', 
			Max_Authorised_Person_Count__c = 1.1, 
			Max_Beneficiary_Count__c = 1.1, 
			Max_Director_Count__c = 1.1,
			Price_Book__c=priceObj.Id
		);
		insert plancObj;
		List<Plan__c> planList =  OnBoarding.getProducts();
		Test.stopTest();
		System.assertEquals(false, planList.isEmpty());
	}
	@IsTest
	static void testGetProductFeatures(){
		
		Test.startTest();
		Price_Book__c priceObj = new Price_Book__c(
			Active__c = true,
			Name='ECIC Pricebook'
		);
		insert priceObj;
		Plan__c plancObj = new Plan__c (
			Name = 'test value', 
			Display_Sequence__c = 1.1, 
			Full_Name__c = 'test value', 
			Image_Url__c = 'test value', 
			Max_Authorised_Person_Count__c = 1.1, 
			Max_Beneficiary_Count__c = 1.1, 
			Max_Director_Count__c = 1.1,
			Price_Book__c = priceObj.Id
		);
		insert plancObj;
		Product_feature__c productfeaturecObj = new Product_feature__c (
			Criteria_Label__c = 'test value', 
			Criteria_Value__c = 'test value', 
			Display_Sequence__c = 1.1, 
			// Feature_Element__c = 'Here is reference id', 
			Parent_Feature__c ='Eligbility',
			Show_Feature__c = true, 
			Weightage__c = 1.1, 
			Comparison_Operator__c = 'test value',
			Plan__c = plancObj.Id
			
		);
		insert productfeaturecObj;
		List<Product_feature__c> pFeatureList = OnBoarding.getProductFeatures();
		System.assertEquals(false, pFeatureList.isEmpty());
		Test.stopTest();
		
	}
	@IsTest
	static void testGetFeatureElements(){
		
		Test.startTest();
		Feature_element__c featureelementcObj = new Feature_element__c (
			Name = 'test value', 
			Data_Type__c ='Text', 
			Display_Sequence__c = 1.1, 
			Question__c = 'test value', 
			Sub_Display_Sequence__c = 1.1,
			Is_PI_Question__c = true
		);
		insert featureelementcObj;
		List<Feature_Element__c> planList = OnBoarding.getFeatureElements();
		System.assertEquals(false, planList.isEmpty());
		Test.stopTest();
		
	}
	@IsTest
	static void testGetDynamicPrice(){
		
		Test.startTest();
		Price_Book__c priceObj = new Price_Book__c(
			Active__c = true,
			Name='ECIC Pricebook'
		);
		insert priceObj;
		Plan__c plancObj = new Plan__c (
			Name = 'test value', 
			Display_Sequence__c = 1.1, 
			Full_Name__c = 'test value', 
			Image_Url__c = 'test value', 
			Max_Authorised_Person_Count__c = 1.1, 
			Max_Beneficiary_Count__c = 1.1, 
			Max_Director_Count__c = 1.1,
			Price_Book__c = priceObj.Id
		);
		insert plancObj;
		Dynamic_price__c dynamicpricecObj = new Dynamic_price__c (
			Credit_Limit__c = 1.1, 
			Indemnity_Ratio__c ='0', 
			Maximum_Liability__c = 1.1, 
			Non_Qualify_Loss__c ='5', 
			Premium_Rate_On__c ='Credit Limit', 
			Price_Book__c = priceObj.Id,
			Product__c = plancObj.Id
		);
		insert dynamicpricecObj;
		List<Dynamic_Price__c> priceList= OnBoarding.getDynamicPrice();
		System.assertEquals(false, priceList.isEmpty());
		Test.stopTest();
		
	}
	@IsTest
	static void testGetDiscounts(){
		
		Test.startTest();
		Discount__c discountObj = new Discount__c(
			Discount_Type__c = 'Percent', 
			Is_Active__c = true, 
			Is_Default__c = true,
			Value__c = 10
		);
		insert discountObj;
		List<Discount__c> discount = OnBoarding.getDiscounts();
		System.assertEquals(false, discount.isEmpty());
		Test.stopTest();
		
	}
	@IsTest
	static void testSearchProduct(){
		
		Test.startTest();
		
		Price_Book__c priceObj = new Price_Book__c(
			Active__c = true,
			Name='ECIC Pricebook'
		);
		insert priceObj;
		Plan__c plancObj = new Plan__c (
			Name = 'test value', 
			Display_Sequence__c = 1.1, 
			Full_Name__c = 'test value', 
			Image_Url__c = 'test value', 
			Max_Authorised_Person_Count__c = 1.1, 
			Max_Beneficiary_Count__c = 1.1, 
			Max_Director_Count__c = 1.1,
			Price_Book__c = priceObj.Id
		);
		insert plancObj;
		Feature_Element__c featureelementcObj = new Feature_Element__c (
			Name = 'test value', 
			Data_Type__c ='Text', 
			Display_Sequence__c = 1.1, 
			Question__c = 'test value', 
			Sub_Display_Sequence__c = 1.1,
			Is_PI_Question__c = true
		);
		insert featureelementcObj;
		Product_feature__c productfeaturecObj = new Product_feature__c (
			Criteria_Label__c = 'test value', 
			Criteria_Value__c = '10', 
			Display_Sequence__c = 1.1, 
			Feature_Element__c = featureelementcObj.Id, 
			Parent_Feature__c ='Eligbility',
			Show_Feature__c = true, 
			Weightage__c = 1.1, 
			Comparison_Operator__c = '>',
			Plan__c = plancObj.Id
			
		);
		insert productfeaturecObj;
		List<Map<String, String>> features = new List<Map<String, String>> {
		new Map<String, String>{
			'Feature_Element__c'=>featureelementcObj.Id,
			'Criteria_Value__c'=>'10'
		},
		new Map<String, String>{
			'Feature_Element__c'=>featureelementcObj.Id,
			'Criteria_Value__c'=>'20'
		},
		new Map<String, String>{
			'Feature_Element__c'=>featureelementcObj.Id,
			'Criteria_Value__c'=>'30'
		}
	};
		Map<String, Integer> spList = OnBoarding.searchProduct(features);
		System.assertEquals(false, spList.isEmpty());

		Map<String, Integer> spList1 = OnBoarding.searchProduct(null);
		System.assertEquals(null, spList1);
		Test.stopTest();
	}
	

	
}