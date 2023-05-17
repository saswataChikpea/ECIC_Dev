public with sharing class OnBoarding{
	/*public class GeneralResponse{
	 @AuraEnabled
	 public List<WrapperProduct> product{get;set;}
	 @AuraEnabled
	 public Boolean isSuccess{get;set;}
	 @AuraEnabled
	 public String errMsg{get;set;}
	 public GeneralResponse(){
	 this.isSuccess = false;
	 }
	 }
	 public class WrapperProduct{
	 @AuraEnabled
	 public String Id{get;set;}
	 @AuraEnabled
	 public String Name{get;set;}
	 @AuraEnabled
	 public String image{get;set;}
	 @AuraEnabled
	 public List<Product_Feature__c> feature{get;set;}
	 }



	 @AuraEnabled
	 public static GeneralResponse getProducts(){
	 GeneralResponse genResponse = new GeneralResponse();
	 try {
	 List<Plan__c> planList = [select id,name from Plan__c];
	 if(planList != null ){
	 genResponse.isSuccess = true;
	 List<WrapperProduct> wpList = new List<WrapperProduct>();
	 for(Plan__c p : planList){
	 WrapperProduct wp = new WrapperProduct();
	 wp.Id = p.id;
	 wp.Name = p.name;
	 wp.image = 'http://www.hkecic.com/materials/category/policies_photo_20181002142740228.jpg';
	 wpList.add(wp);
	 }
	 genResponse.product = wpList;
	 }
	 } catch (Exception e) {
	//throw new AuraHandledException(e.getMessage());
	 genResponse.errMsg = e.getMessage();
	 }
	 System.debug('-->'+genResponse);
	 return genResponse;
	 }*/
	 @AuraEnabled(cacheable = true)
	 public static Onboarding_Setting__mdt getOnboardingSetting(){
		List<Onboarding_Setting__mdt> onb_settings = new List<Onboarding_Setting__mdt>();
		onb_settings = [select MasterLabel, Max_No_Questions__c, DeveloperName,
		Step_1A_Banner__c from Onboarding_Setting__mdt where DeveloperName = 'Onboarding_Setting'];
		return onb_settings.size()>0?onb_settings[0]:null;
	 } 
	@AuraEnabled(cacheable = true)
	public static List<Plan__c> getProducts(){
		List<Plan__c> planList = new List<Plan__c>();
		//try{
			// planList = [select Id, Name, Name_CN__c, Name_HK__c, Premium_Rate__c, Image_Url__c, Image_Url_CN__c, Image_Url_HK__c, Full_Name__c, Full_Name_CN__c, Full_Name_HK__c, Display_Sequence__c,
			// 			Maximum_Liability__c, Minimum_Maximum_Liability__c, Maximum_Liability_Interval__c
			//             from Plan__c where Price_Book__r.Active__c = true
			//             order by Display_Sequence__c];

			planList = [select Id, Name, Name_CN__c, Name_HK__c, Premium_Rate__c, Image_Url__c, Image_Url_CN__c, Image_Url_HK__c, Full_Name__c, Full_Name_CN__c, Full_Name_HK__c, Display_Sequence__c,
			Maximum_Liability__c, Minimum_Maximum_Liability__c, Maximum_Liability_Interval__c,
			(select id, Option_Label__c, Option_Label_Value__c, Premium_Reduction__c, Option_Type__c,Display_Sequence__c, Product__c from Dynamic_Pricing_Parameters__r order by Display_Sequence__c)
			from Plan__c where Price_Book__r.Active__c = true
			order by Display_Sequence__c];


		// } catch (Exception e){
		// 	throw new AuraHandledException(e.getMessage());
		// }
		System.debug('-->' + planList);
		return planList;
	}

	@AuraEnabled(cacheable = true)
	public static List<Product_Feature__c> getProductFeatures(){
		List<Product_Feature__c> pFeatureList = new List<Product_Feature__c>();
		//try{
			pFeatureList = [select Name, Parent_Feature__c, Display_Sequence__c, Criteria_Label__c, Criteria_Value__c, Feature_Element__c, Plan__c, Plan__r.name
			                from Product_Feature__c
			                where Show_Feature__c = true
			                order by Display_Sequence__c];
		// } catch (Exception e){
		// 	throw new AuraHandledException(e.getMessage());
		// }
		return pFeatureList;
	}

	@AuraEnabled(cacheable = true)
	public static List<Feature_Element__c> getFeatureElements(){
		List<Feature_Element__c> planList = [Select Id, Name, Question__c, Question_CH__c, Question_HK__c, Display_Sequence__c, Sub_Display_Sequence__c, Data_Type__c, 
			(Select Id, Name, Element_Value__c, Display_Sequence__c from Feature_Element_Values__r Order by Display_Sequence__c)
		                                     from Feature_Element__c
		                                     where Is_PI_Question__c = true
		                                     order by Display_Sequence__c, Sub_Display_Sequence__c
		                                     NULLS LAST];
		return planList;
	}
	@AuraEnabled(cacheable = false)
	public static void searchProduct1(List<Map<String, String>> features){
		System.debug('-->searchProduct1'+features);
	}

	private  static Boolean comparePfValues(String Criteria_Value, String Criteria_Value2, String val, String operator){
		if ( operator!= null) {
			if (operator =='<>') {
				return Boolean.valueOf( (Integer.valueOf(val) > Integer.valueOf(Criteria_Value2) ) && (Integer.valueOf(val) < Integer.valueOf(Criteria_Value) ) );
			}else if (operator =='<') {
				return Boolean.valueOf( Integer.valueOf(val) < Integer.valueOf(Criteria_Value));
			}else if (operator == '>') {
				return Boolean.valueOf(Integer.valueOf(val) > Integer.valueOf(Criteria_Value));
			}

		}else{
			return Boolean.valueOf(Criteria_Value == val);
		}
		return null;
	}

	@AuraEnabled(cacheable = false)
	public static Map<String, Integer> searchProduct(List<Map<String, String>> features){
		try{
			System.debug('-->searchProduct::: features'+ features);
			// String soql = 'select Plan__c, COUNT(Name) match_count, MIN(Display_Sequence__c)  Display_Sequence from Product_Feature__c where Plan__r.Active__c = true and(';
			// String soql = 'select Plan__c, COUNT(Name) match_count, SUM(Weightage__c) weitage, MIN(Plan__r.Display_Sequence__c)  Display_Sequence from Product_Feature__c where Plan__r.Active__c = true and(';
			// Boolean flag = false;
			Map<String, String> featureMap= new Map<String, String> ();
			List<String> featureElements = new List<String>();
			Map<String, Integer> productWeightMap= new Map <String, Integer> ();

			for (Map<String, String> q_conf : features){
				featureMap.put(q_conf.get('Feature_Element__c'), String.valueOf(q_conf.get('Criteria_Value__c')));
				featureElements.add(q_conf.get('Feature_Element__c'));
			}
			// if (flag)
			// 	soql = soql.substring(0, (soql.length()-2));

			List<Product_Feature__c> pfList=[select Plan__c, Name, Criteria_Label__c, Criteria_Value__c, Criteria_Value2__c, Feature_Element__c, Comparison_Operator__c, Weightage__c, Plan__r.Display_Sequence__c from Product_Feature__c where Plan__r.Active__c = true and Feature_Element__c in :featureElements];
			System.debug('#Search-->pfList=' + pfList);
			System.debug('#Search-->featureMap=' + featureMap);
			
			for (Product_Feature__c pf : pfList) {
				String val = featureMap.get(String.valueOf(pf.get('Feature_Element__c')));
				String criteriaVal = String.valueOf(pf.get('Criteria_Value__c'));
				String criteriaVal2= String.valueOf(pf.get('Criteria_Value2__c'));
				String operator= String.valueOf(pf.get('Comparison_Operator__c'));
				String productName= String.valueOf(pf.get('Plan__c'));
				System.debug(':::'+ criteriaVal+','+val+'::'+operator);
				Boolean temp=comparePfValues(criteriaVal, criteriaVal2,  val, operator);
				if (temp) {
					System.debug(':::'+ temp);
					if (productWeightMap.containsKey(productName)) {
						productWeightMap.put(productName, productWeightMap.get(productName) + Integer.valueOf(pf.get('Weightage__c')));
					}else {
						productWeightMap.put(productName, Integer.valueOf(pf.get('Weightage__c')));
					}
				}
			}
			System.debug('#Search-->productWeightMap=' + productWeightMap);
			return productWeightMap;
	
		} catch (Exception e){
			if(!Test.isRunningTest())
			throw new AuraHandledException(e.getMessage());
			return null;
		}
	}

	@AuraEnabled(cacheable = true)
	public static List<Dynamic_Price__c> getDynamicPrice(){
		List<Dynamic_Price__c> priceList = new List<Dynamic_Price__c>();
		//try{
			// priceList = [select Id, Name, Base_Rate_Per_Anum__c, Base_Rate_Per_Quarter__c, Credit_Limit__c,
			//  Indemnity_Ratio__c, Maximum_Liability__c, Non_Qualify_Loss__c, Premium_Rate_On__c, Product__c,
			//  Pre_Shipment__c, DP__c, OA1_60__c, OA61_120__c
			//              from Dynamic_Price__c where Price_Book__r.Active__c = true order by Name];

			priceList= [select Id, Name, Base_Rate_Per_Anum__c, Base_Rate_Per_Quarter__c, Credit_Limit__c,
			Indemnity_Ratio__c, Maximum_Liability__c, Non_Qualify_Loss__c, Premium_Rate_On__c, Product__c,
			DP__c, DA_OA_0_30__c, DA_OA_31_60__c, DA_OA_61_90__c, DA_OA_91_180__c ,Loading__c,Country_Grade__c
			from Dynamic_Price__c where Price_Book__r.Active__c = true order by Name];

		// } catch (Exception e){
		// 	throw new AuraHandledException(e.getMessage());
		// }
		System.debug('priceList-->' + priceList);
		return priceList;
	}

	@AuraEnabled(cacheable = true)
	public static List<Discount__c> getDiscounts(){
		List<Discount__c> discount = new List<Discount__c>();
		//try{
			discount = [select Discount_Type__c, Is_Active__c, Is_Default__c, Valid_From__c, Valid_To__c, Value__c
			            from Discount__c];
		// } catch (Exception e){
		// 	throw new AuraHandledException(e.getMessage());
		// }
		return discount;
	}
}