/*-------------------------------------------------------
    Desc : class created from ecic_api_v1 class. this contains all the CL/CLA/DCL related APIs
            This class is for calling ecic apis 
    created by : sayantan@chikpea.com
--------------------------------------------------------*/
global with sharing class ECIC_CL_API_Methods {

    
    // 1.1 cl/CL/get U7, U17, U19 65,70 Retrieve customer CL records
    public static String getCreditLimit(String custNo, String policyType, String buyerCode, String buyerCountr){
        // 1) 1) Item 65 - EC-Reach 2.0 has to get the credit limit application status from the legacy system.
        // 2) Item 70 - EC-Reach 2.0 receives the cancellation results from the legacy system 
                
        Map<String, Object> jsonObject = new Map<String, Object>();
        if(ECIC_API_V1.access_token_success){
            if(String.isNotBlank(custNo) && String.isNotBlank(policyType) && String.isNotBlank(buyerCode) && String.isNotBlank(buyerCountr)){
                Boolean testContent = False;
                String url_extension = '/api/services/cl/CL/get';
                String auth_header = ECIC_API_V1.token_type + ' ' + ECIC_API_V1.access_token;
                String url_parameters = '';
                jsonObject.put('CUS_NO', custNo);
                jsonObject.put('PCY_TYPE', policyType);
                jsonObject.put('BYR_CODE', buyerCode);
                jsonObject.put('BYR_CTRY', buyerCountr);
                Map<String, String> respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
                if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('Exception')){
                    system.debug('Exception in response ====>'+respParserMap.get('Exception'));
                    return 'exception '+respParserMap.get('Exception');
                }
                else if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('ciphertext')){
                    system.debug('json response ====>'+respParserMap.get('ciphertext'));
                    return respParserMap.get('ciphertext');
                }
                else{
                    if(respParserMap != NULL && respParserMap.size()>0){
                        for(String Key : respParserMap.keyset()){
                            system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                        }
                        return JSON.serialize(respParserMap);
                    }
                }
            }
            else return 'Mandatory input missing.';
        }
        else return 'Access token failed.';
        return NULL;
    }


    // 1.2 cl/CL/issue B6, U1, U2 53 CLI changed to CL after payment
    public static String convertCLItoCLApplication(String clApplicationID){
        // 1) Item 53 - After the policyholder makes a payment for the credit limit indication, 
        // EC-Reach 2.0 sends data of the credit limit indication to the legacy system.
        // The legacy system converts the credit limit indication into a credit limit, 
        // then sends the data of the credit limit to EC-Reach 2.0.
        // 1 CUS_NO String 6 234678 Yes Customer No.
        // 2 PCY_TYPE String 2 70 Yes Policy type
        // 3 CL_NO String 10 344556 Yes CL No.
        // 4 CL_EFF_DATE Date 2021-10-01 Yes CL effective date (YYYY-MM-DD)
        // 5 SUBM_TYPE String 1 N Yes Submission type ( N - new , U - uplift , R - renew )
        // 6 PRM_PAID Number 500.00 Yes Premium Paid (HKD)
        // 7 PRM_PAID_DATE Date 2021-10-01 Yes Premium payment date (YYYY-MM-DD)
        
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_V1.access_token_success){
            if(clApplicationID != NULL ){
                // objectAPIName = creditLimitID.getSobjectType().getDescribe().getName();
                // System.debug('objectAPIName ====>'+objectAPIName);
                Boolean testContent = False;
                String url_extension = '/api/services/cl/CL/issue';
                String auth_header = ECIC_API_V1.token_type + ' ' + ECIC_API_V1.access_token;
                String url_parameters = '';
                String query = 'SELECT ID, Name, Exporter__r.Legacy_Customer_Number__c, Policy__r.Legacy_Policy_Type__c, CL_No__c, '+
                        'Legacy_CL_No__c, Legacy_CL_EFF_DATE__c, Legacy_Application_Type__c, Premium_Paid_Legacy__c, Legacy_Premium_Paid_Date__c, '+
                        'Premium_Rate__c,Premium__c,Discount_Rate__c,Discount_Amount__c '+
                        'FROM Credit_Limit_Application__c WHERE ID = \'' + clApplicationID + '\'';
                List<Credit_Limit_Application__c> clalist = DataBase.query(query);       //ECIC_API_v1.get_all_fields_query(clApplicationID)
                System.debug('clalist ===>'+clalist);
                if(clalist != NULL && clalist.size()>0){
                    jsonObject.put('CUS_NO', clalist[0].Exporter__r.Legacy_Customer_Number__c);
                    jsonObject.put('PCY_TYPE', clalist[0].Policy__r.Legacy_Policy_Type__c);
                    jsonObject.put('CL_NO', clalist[0].Legacy_CL_No__c);
                    jsonObject.put('CL_EFF_DATE', clalist[0].Legacy_CL_EFF_DATE__c);
                    jsonObject.put('SUBM_TYPE', clalist[0].Legacy_Application_Type__c);
                    jsonObject.put('PRM_PAID', clalist[0].Premium_Paid_Legacy__c);
                    jsonObject.put('PRM_PAID_DATE', clalist[0].Legacy_Premium_Paid_Date__c);
                    jsonObject.put('PRM_RATE', clalist[0].Premium_Rate__c);
                    jsonObject.put('PRM', clalist[0].Premium__c);
                    jsonObject.put('DIS_RATE', clalist[0].Discount_Rate__c);
                    jsonObject.put('DIS_AMT', clalist[0].Discount_Amount__c);
                    Map<String, String> respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
                    if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('Exception')){
                        system.debug('Exception in response ====>'+respParserMap.get('Exception'));
                        return 'exception '+respParserMap.get('Exception');
                    }
                    else if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('ciphertext')){
                        system.debug('json response ====>'+respParserMap.get('ciphertext'));
                        return respParserMap.get('ciphertext');
                    }
                    else{
                        if(respParserMap != NULL && respParserMap.size()>0){
                            for(String Key : respParserMap.keyset()){
                                system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                            }
                            return 'response received';
                        }
                    }
                }
            }
        }
        return NULL;
    }

    // 1.3 (Moved to 1.7 - 18/11/2021)
    // public static String cancel
    
    // 1.4 cl/CLA/get U17, U19 65,70 Retrieve customer CLA records
    @AuraEnabled
    public static string getCLApplicationAura(String refNo){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_CL_API_Methods.getCLApplication(refNo);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static String getCLApplication(String refNo){
                
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_V1.access_token_success){
            Boolean testContent = False;
            String url_extension = '/api/services/cl/CLA/get';
            String auth_header = ECIC_API_V1.token_type + ' ' + ECIC_API_V1.access_token;
            String url_parameters = '';
            jsonObject.put('REF_NO', refNo);
            Map<String, String> respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
            if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('Exception')){
                system.debug('Exception in response ====>'+respParserMap.get('Exception'));
                return 'exception '+respParserMap.get('Exception');
            }
            else if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('ciphertext')){
                system.debug('json response ====>'+respParserMap.get('ciphertext'));
                return respParserMap.get('ciphertext');
            }
            else{
                if(respParserMap != NULL && respParserMap.size()>0){
                    for(String Key : respParserMap.keyset()){
                        system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                    }
                    return JSON.serialize(respParserMap);
                }
            }
        }
        return NULL;
    }
    
    // 1.5 cl/CLA/create B6, U1, U2 54,58 Amend CLA record
    @AuraEnabled
    public static string createCLApplicationAura(String clApplicationID){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_CL_API_Methods.createCLApplication(clApplicationID);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public static String createCLApplication(String clApplicationID){
        
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        clApplicationID = String.escapeSingleQuotes(clApplicationID);
        if(ECIC_API_V1.access_token_success){
            if(clApplicationID != NULL ){
                // objectAPIName = creditLimitID.getSobjectType().getDescribe().getName();
                // System.debug('objectAPIName ====>'+objectAPIName);
                Boolean testContent = False;
                String url_extension = '/api/services/cl/CLA/create';
                String auth_header = ECIC_API_V1.token_type + ' ' + ECIC_API_V1.access_token;
                String url_parameters = '';
                List<String> claFields = fieldMappingTranslation.get_all_fields_from_ID(clApplicationID);
                List<String> opFields = fieldMappingTranslation.get_all_fields_from_APIName('Outstanding_Payment__c');
                String query =   'SELECT '+ String.join(claFields, ', ')+', '+'Policy__r.Exporter__r.Legacy_Customer_Number__c, '+
                        'Policy__r.Legacy_Policy_Type__c, Policy__r.Exporter__c, '+
                        ' ( SELECT ' + String.join(opFields, ', ') +' FROM Outstanding_Payments__r ) ' +
                        'FROM Credit_Limit_Application__c WHERE ID = \'' + clApplicationID + '\'';
                System.debug('query ====>'+query);
                List<Credit_Limit_Application__c> clalist = DataBase.query(query);       //ECIC_API_v1.get_all_fields_query(clApplicationID)
                System.debug('clalist ===>'+clalist);
                if(clalist != NULL && clalist.size()>0){
                    for(Credit_Limit_Application__c cla : clalist){
                        List<List_Storage__c> ccodelist = fieldMappingTranslation.get_country_code_all();
                        // String buy_ccode = ECIC_API_v1.get_country_code(clalist[0].Buyer_Country__c);
                        jsonObject.put('ACCOUNT_ID',cla.Policy__r.Exporter__c);
                        jsonObject.put('POLICY_ID',cla.Policy__c);
                        jsonObject.put('CREDIT_LIMIT_APPLICATION_ID', cla.ID);
                        jsonObject.put('CUS_NO', cla.Policy__r.Exporter__r.Legacy_Customer_Number__c);// 1 CUS_NO String 6 345678 Yes Customer no.
                        jsonObject.put('PCY_TYPE', cla.Policy__r.Legacy_Policy_Type__c);// 2 PCY_TYPE String 2 51 Yes Policy type
                        jsonObject.put('SUBM_TYPE', cla.Legacy_Application_Type__c);// 3 SUBM_TYPE String 1 N Yes Submission type ( N - new , U - uplift , R - renew ) (For OMBP only)
                        //jsonObject.put('APP_TYPE', cla.Legacy_Export_Type__c);// 4 APP_TYPE String 10 PREPOST Yes Application Type (SVC - Export of service, PREPOST - Pre/Post-shipment, GD - Export of goods)
                        jsonObject.put('APP_TYPE', fieldMappingTranslation.export_type_to_code(cla.Export_Type__c));// 4 APP_TYPE String 10 PREPOST Yes Application Type (SVC - Export of service, PREPOST - Pre/Post-shipment, GD - Export of goods)
                        String appdate = (cla.Application_Date__c!= NULL?fieldMappingTranslation.date_format(cla.Application_Date__c):NULL);
                        jsonObject.put('APP_DATE', appdate);// 5 APP_DATE Date 2021-08-31 Yes Application date (YYYY-MM-DD)
                        String clexpdate = (cla.Expiry_Date__c!= NULL?fieldMappingTranslation.date_format(cla.Expiry_Date__c):NULL);
                        jsonObject.put('CL_EXP_DATE', clexpdate);// 6 CL_EXP_DATE Date 2021-08-31 Yes CL Expiry date (YYYY-MM-DD) (for PCY_TYPE = 70 only) 
                        jsonObject.put('CLA_AMT', cla.CL_Application_Amount__c);// 7 CLA_AMT Number 200000 Yes CLA amount
                        jsonObject.put('PAY_METHOD', cla.Payment_Term_Type__c);// 8 PAY_METHOD String 3 OA Yes Payment method (DP, DA, OA)
                        jsonObject.put('PAY_PERIOD', cla.Payment_Term_Days__c);// 9 PAY_PERIOD Number 90 Yes Payment period
                        jsonObject.put('PRE_CLA_AMT', cla.CL_Pre_Shipment_Application_AMount__c);// 12 CLA amount for Pre-shipment (request if APP_TYPE = PREPOST)
                        jsonObject.put('PRE_PAY_METHOD', cla.Pre_Shipment_Payment_Term_Type__c);// 13 Payment method (DP, DA, OA) for Pre-shipment (request if APP_TYPE =
                        jsonObject.put('PRE_PAY_PERIOD', cla.Pre_Shipment_Payment_Term_Days__c);// 14 Payment period for Pre-shipment (request if APP_TYPE = PREPOST)
                        
                        String byrctry;
                        for (List_Storage__c ccode : ccodeList){
                            if(ccode.List_Type__c == 'Buyer Country' && ccode.ByrCtry_Country_Name__c.equalsIgnoreCase(cla.Buyer_Country__c)){
                                byrctry = ccode.ByrCtry_Country_Code__c;
                                break;
                            }
                        }
                        System.debug('byr_ctry ====>'+byrctry);
                        jsonObject.put('BYR_CTRY', byrctry);
                        jsonObject.put('BYR_CODE', cla.Buyer_Code__c);// 11 BYR_CODE String 6 555666 Buyer code (Either Buyer code or Buyer name must be input)
                        jsonObject.put('BYR_NAME', cla.Buyer_Name__c);// 12 BYR_NAME String 255 BB Ltd. Buyer name (Either Buyer code or Buyer name must be input)
                        jsonObject.put('BYR_ADDR_1', cla.Buyer_Address_Line_1__c);// 13 BYR_ADDR_1 String 60 P.O. BOX 312, Buyer address line 1
                        jsonObject.put('BYR_ADDR_2', cla.Buyer_Address_Line_2__c);// 14 BYR_ADDR_2 String 60 GOLD MARKET, Buyer address line 2
                        jsonObject.put('BYR_ADDR_3', cla.Buyer_Address_Line_3__c);// 15 BYR_ADDR_3 String 60 CURACAO, Buyer address line 3
                        jsonObject.put('BYR_ADDR_4', cla.Buyer_Address_Line_4__c);// 16 BYR_ADDR_4 String 60 U.A.E. Buyer address line 4
                        jsonObject.put('REG_NO', cla.Buyer_Registration_Number__c);// 17 REG_NO String 30 22445566 Buyer Registration number
                        jsonObject.put('DNB_DUNS', cla.DNB_DUNS__c);// 18 DNB_DUNS String 100 XCCVD13458 DnB Duns number (refer to API 1.14)
                        jsonObject.put('HRM_CODE', cla.Harmonized_Code__c);// 19 HRM_CODE String 8 02010234 Harmonized code (must be in 8 digits, and request if APP_TYPE = POST & PCY_TYPE = 70)
                        String portloading;
                        for (List_Storage__c ccode : ccodeList){
                            if(ccode.List_Type__c == 'Port of Loading' && ccode.PortOfLdg_Country_Name__c.equalsIgnoreCase(cla.Port_Of_Loading__c)){
                                portloading = ccode.PortOfLdg_Country_Code__c;
                                break;
                            }
                        }
                        System.debug('port of loading ====>'+portloading);
                        jsonObject.put('PORT_OF_LDG', portloading);// 20 PORT_OF_LDG String 3 HKG Country/Market of Shipment (request if APP_TYPE = POST & PCY_TYPE = 70)
                        String destcountry;
                        for (List_Storage__c ccode : ccodeList){
                            if(ccode.List_Type__c == 'Destination Country' && ccode.DestCtryList_Country_Name__c.equalsIgnoreCase(cla.Destination_Market__c)){
                                destcountry = ccode.DestCtryList_Country_Code__c;
                                break;
                            }
                        }
                        System.debug('destination country ====>'+destcountry);
                        
                        jsonObject.put('DEST_CTRY', destcountry);// 21 DEST_CTRY String 3 USA Destination Country/Market (request if APP_TYPE != SVC)
                        String ORG_CTRY;
                        for (List_Storage__c ccode : ccodeList){
                            if(ccode.List_Type__c == 'Origin Country' && ccode.OrgCtryList_Country_Name__c.equalsIgnoreCase(cla.Market_of_Origin__c)){
                                ORG_CTRY = ccode.OrgCtryList_Country_Code__c;
                                break;
                            }
                        }
                        System.debug('origin country ====>'+ORG_CTRY);
                        jsonObject.put('ORG_CTRY', ORG_CTRY);// 22 ORG_CTRY String 3 CHN Country/Market (request if APP_TYPE = POST & PCY_TYPE = 70)
                        if(cla.Export_Type__c != NULL && !cla.Export_Type__c.containsIgnoreCase('service')){
                            String prodcode = fieldMappingTranslation.get_product_code(cla.Goods_or_Services_Involved__c);
                            jsonObject.put('PRD_CODE', prodcode);// 23 PRD_CODE String 2 02 Product Involved (refer to API 5.4)
                            jsonObject.put('OTH_PRD', cla.Specific_Goods_Involved__c);// 24 OTH_PRD String 255 LAND TRUCK SERVICE Other goods involved / Services involved
                        }
                        else{
                            jsonObject.put('SVC_INVO', cla.Goods_or_Services_Involved__c);// 24 OTH_PRD String 255 LAND TRUCK SERVICE Other goods involved / Services involved
                        }
                        jsonObject.put('IS_HK_EXP', cla.Legacy_Overseas_Goods_or_Services__c);// 25 IS_HK_EXP String 1 Y Will the service be ultimately rendered to an overseas client? /
                        // Will the goods to be sold to the Hong Kong exporter be exported? (Y/N)
                        jsonObject.put('IS_NEW_BYR', cla.Legacy_Is_New_Buyer__c);// 26 IS_NEW_BYR String 1 N Is this your new buyer? / Is this your new client? (request if PCY_TYPE = 51/56)
                        jsonObject.put('TRADE_YR', Decimal.valueOf(cla.Buyer_Trading_Time__c!= NULL?cla.Buyer_Trading_Time__c:'0'));// 27 TRADE_YR Number 4.2 How long have you been trading with this buyer? / How long have you been
                        // rendering services to this client? (only 1 decimal place)
                        jsonObject.put('PRE_LAST_12_SHP_PAY_ILC', cla.Legacy_OPTM_12_Months1__c);// 28 LAST_12_SHP_PAY_METHOD String 3 OA Payment terms of the shipments made to this buyer in the last 12 months /
                        // Payment terms of the services rendered to this client in the last 12 months (DP, DA,
                        jsonObject.put('PRE_LAST_12_SHP_PAY_ILC', cla.Legacy_OPTM_12_Months1__c!= NULL ?'Y':'N');
                        jsonObject.put('PRE_LAST_12_SHP_PAY_PA', cla.Legacy_OPTM_12_Months2__c!= NULL ?'Y':'N');
                        jsonObject.put('PRE_LAST_12_SHP_PAY_DP', cla.Legacy_OPTM_12_Months3__c!= NULL ?'Y':'N');
                        jsonObject.put('PRE_LAST_12_SHP_PAY_DA', cla.Legacy_OPTM_12_Months4__c!= NULL ?'Y':'N');
                        jsonObject.put('PRE_LAST_12_SHP_PAY_OA', cla.Legacy_OPTM_12_Months5__c!= NULL ?'Y':'N');
                        jsonObject.put('PRE_LAST_12_SHP_PAY_ILC_PA_AMT', cla.Order_Payment_Term_Amount_12_Months__c);
                        jsonObject.put('PRE_LAST_12_SHP_PAY_CR_AMT', cla.Order_Payment_Term_Days_12_Months__c);
                        
                        jsonObject.put('LAST_12_SHP_PAY_ILC', (cla.Shipment_Payment_Term_Method_12_Months1__c != NULL && cla.Shipment_Payment_Term_Method_12_Months1__c == 'ILC'?'Y':'N'));
                        jsonObject.put('LAST_12_SHP_PAY_PA', (cla.Shipment_Payment_Term_Method_12_Months2__c != NULL ?'Y':'N'));
                        jsonObject.put('LAST_12_SHP_PAY_DP', cla.Shipment_Payment_Term_Method_12_Months3__c != NULL ?'Y':'N');
                        jsonObject.put('LAST_12_SHP_PAY_DA', cla.Shipment_Payment_Term_Method_12_Months4__c != NULL ?'Y':'N');
                        jsonObject.put('LAST_12_SHP_PAY_OA', cla.Shipment_Payment_Term_Method_12_Months5__c != NULL ?'Y':'N');
                        jsonObject.put('LAST_12_SHP_PAY_ILC_PA_AMT', cla.Shipment_Payment_Term_Amount_12_Months__c);
                        jsonObject.put('LAST_12_SHP_PAY_CR_AMT', cla.Shipment_Payment_Term_Days_12_Months__c);
                        
                        // jsonObject.put('LAST_12_SHP_PAY_METHOD', 60);// 29 LAST_12_SHP_PAY_PERIOD Number 60 Tenor of the shipments made to this buyer in the last 12 months / Tenor of the
                        // // services rendered to this client in the last 12 months
                        // jsonObject.put('LAST_12_SHP_PAY_AMT', 50000);// 30 LAST_12_SHP_PAY_AMT Number 50000 Amount of the shipments made to this buyer in the last 12 months / Amount of the
                        // // services rendered to this client in the last 12 months
                        jsonObject.put('HAS_CANCEL_ORDER', cla.Legacy_Previously_Cancelled_Order__c);// 31 HAS_CANCEL_ORDER String 1 Y Has the buyer previously cancelled firm orders unilaterally? (Y/N)
                        jsonObject.put('IS_ILC_PA_OVERDUE', fieldMappingTranslation.convert_yes_no_code(cla.Unpaid_Overdue_Order__c));// 32 IS_ILC_PA_OVERDUE String 1 Y Are there any payment currently overdue from this buyer under ILC or payment in  advance transactions? (Y/N)
                        if ( cla.Count_Shipment_Overdue__c > 0)
                            jsonObject.put('HAS_SHP_OVERDUE',fieldMappingTranslation.convert_yes_no_code('Yes'));
                        else
                            jsonObject.put('HAS_SHP_OVERDUE',fieldMappingTranslation.convert_yes_no_code('No'));
                        List<Map<String,Object>> objectList = new List<Map<String, Object>>();
                        if (cla.Outstanding_Payments__r.size()>0){
                            for(Outstanding_Payment__c op : cla.Outstanding_Payments__r){
                                Map<String,Object> jsonObject1 = new Map<String, Object>();
                                jsonObject1.put('SHP_DATE', fieldMappingTranslation.date_format(op.Shipment_Or_Invoice_Date__c));// 34.1 SHP_DATE Date 2021-06-01 Shipment date (YYYY-MM-DD)
                                jsonObject1.put('ORG_CUR', op.Gross_Invoice_Currency__c);// 34.2 ORG_CUR String 3 HKD Original Currency
                                jsonObject1.put('ORG_GIV', op.Gross_Invoice_Amount__c);// 34.3 ORG_GIV Number 2000 Original GIV
                                jsonObject1.put('PAY_METHOD', op.Payment_Term_Type__c);// 34.4 PAY_METHOD String 3 OA Payment Method
                                jsonObject1.put('PAY_PERIOD', op.Payment_Term_Days__c);// 34.5 PAY_PERIOD Number 60 Payment Period
                                jsonObject1.put('DUE_DATE', fieldMappingTranslation.date_format(op.Due_Date__c));// 34.6 DUE_DATE Date 2021-08-01 Due date (YYYY-MM-DD)
                                jsonObject1.put('REMARK', op.Remarks__c);// 34.7 REMARK String 500 Free Text  
                                objectList.add(jsonObject1);
                            }
                        }
                        jsonObject.put('OS_PAYMENT', objectList);// 34 OS_PAYMENT List List of outstanding payment records
                        jsonObject.put('ORDER_TYPE', cla.Legacy_Order_Confirmed_or_Negotiation__c);// 35 ORDER_TYPE String 1 2 Order Type (1 - order confirmed, 2 - order negotiation, 3 - No)
                        jsonObject.put('ORDER_PAY_ILC', cla.Legacy_Confirm_OPTM1__c!= NULL ?'Y':'N');
                        jsonObject.put('ORDER_PAY_PA', cla.Legacy_Confirm_OPTM2__c!= NULL ?'Y':'N');
                        jsonObject.put('ORDER_PAY_DP', cla.Legacy_Confirm_OPTM3__c!= NULL ?'Y':'N');
                        jsonObject.put('ORDER_PAY_DA', cla.Legacy_Confirm_OPTM4__c!= NULL ?'Y':'N');
                        jsonObject.put('ORDER_PAY_OA', cla.Legacy_Confirm_OPTM5__c!= NULL ?'Y':'N');
                        jsonObject.put('ORDER_PAY_PERIOD', cla.Order_Payment_Term_Days__c);// 37 ORDER_PAY_PERIOD Number 90 Tenor of the orders confirmed / under negotiation with this buyer
                        jsonObject.put('ORDER_PAY_AMT', cla.Order_Payment_Term_Amount_12_Months__c);// 38 ORDER_PAY_AMT Number 5000 Amount of the orders confirmed / under negotiation with this buyer
                        if ( cla.Shipment_Commence_Month__c != NULL && cla.Shipment_Commence_Year__c != NULL)
                            jsonObject.put('SHP_COMM', fieldMappingTranslation.convert_Year_to_YYYY(cla.Shipment_Commence_Year__c)+
                                fieldMappingTranslation.convert_Mon_to_MM( cla.Shipment_Commence_Month__c ));
                        // 39 SHP_COMM String 6 202112 Shipment commencement date (YYYYMM)
                        jsonObject.put('ORDER_ILC',fieldMappingTranslation.convert_yes_no_code(cla.Received_Order_Payment_Term_Method1__c));// 40 ILC_PA_TYPE String 3 PA ILC - ILC, PA - Payment in advance
                        jsonObject.put('ORDER_PA', fieldMappingTranslation.convert_yes_no_code(cla.Received_Order_Payment_Term_Method2__c));// 41 ILC_PA_AMT Number 2000 ILC/PA amount
                        jsonObject.put('ORDER_ILC_PA_AMT', cla.Received_Order_Amount__c);
                        jsonObject.put('REMARK', cla.Remarks__c);// 42 REMARK String 4000 Free Text Remarks
                    }
                    
                    Map<String, String> respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
                    if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('Exception')){
                        system.debug('Exception in response ====>'+respParserMap.get('Exception'));
                        return 'exception '+respParserMap.get('Exception');
                    }
                    else if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('ciphertext')){
                        system.debug('json response ====>'+respParserMap.get('ciphertext'));
                        return respParserMap.get('ciphertext');
                    }
                    else{
                        if(respParserMap != NULL && respParserMap.size()>0){
                            for(String Key : respParserMap.keyset()){
                                system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                            }
                            return JSON.serialize(respParserMap);
                        }
                    }
                }
                else
                    return 'credit limit application list is null';
            }
            else
                return 'credit limit application id is null.';
        }
        return NULL;
    }

    // 1.6 cl/CLA/amend B6, U1, U2 54,58 Amend CLA record
    @AuraEnabled
    public static string amendCLApplicationAura(ID clApplicationID, String reqType){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_CL_API_Methods.amendCLApplication(clApplicationID, reqType);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public static String amendCLApplication(ID clApplicationID, String reqType){
        // Possible areas to be used:
        // 1) Item 54 - While a credit limit application is still under processing, the policyholder can amend or cancel the credit limit application. EC-Reach 2.0 sends the
        // request and related data to the legacy system.
        // 2) Item 58 - If the user has selected a buyer from the buyer search, and he has changed any of the pre-filled values in the "Buyer Code", "Buyer Country /
        // Market", "Buyer Name", and "Buyer Address" fields, then EC-Reach 2.0 should send these fields to the legacy system, so that the Underwriting team can
        // review and update the buyer record in the legacy system.Possible areas to be used:
        // 1) Item 54 - While a credit limit application is still under processing, the policyholder can amend or cancel the credit limit application. EC-Reach 2.0 sends the
        // request and related data to the legacy system.
        // 2) Item 58 - If the user has selected a buyer from the buyer search, and he has changed any of the pre-filled values in the "Buyer Code", "Buyer Country /
        // Market", "Buyer Name", and "Buyer Address" fields, then EC-Reach 2.0 should send these fields to the legacy system, so that the Underwriting team can
        // review and update the buyer record in the legacy system.
        
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_V1.access_token_success){
            if(clApplicationID != NULL ){
                objectAPIName = clApplicationID.getSobjectType().getDescribe().getName();
                System.debug('objectAPIName ====>'+objectAPIName);
                Boolean testContent = False;
                String url_extension = '/api/services/cl/CLA/amend';
                String auth_header = ECIC_API_V1.token_type + ' ' + ECIC_API_V1.access_token;
                String url_parameters = '';
                List<String> claFields = fieldMappingTranslation.get_all_fields_from_ID(clApplicationID);
                List<Credit_Limit__c> cllist;
                List<Credit_Limit_Application__c> clalist;
                String query = 'SELECT '+ String.join(claFields, ', ');
                List<Map<String, String>> respParserMapList = new LIst<Map<String, String>>();
                Map<String, String> respParserMap;      
                System.debug('query ====>'+query);
                // String query = 'FROM Credit_Limit_Application__c WHERE ID = \'' + clApplicationID + '\'';
                if(objectAPIName.equalsIgnoreCase('Credit_Limit__c')){
                    //ECIC_API_v1.get_all_fields_query(clApplicationID)
                    query += ' FROM Credit_Limit__c WHERE ID = \'' + clApplicationID + '\'';
                    cllist = DataBase.query(query);
                }
                else if (objectAPIName.equalsIgnoreCase('Credit_Limit_Application__c')){
                    query += ' FROM Credit_Limit_Application__c WHERE ID = \'' + clApplicationID + '\'';
                    clalist = DataBase.query(query);
                }
                System.debug('cllist ===>'+cllist);
                System.debug('claList ====>'+clalist);
                
                if(reqtype.equalsIgnoreCase('B') && cllist != NULL && cllist.size()>0){
                    jsonObject.put('REQ_TYPE', reqType); // B for Buyer information, A for CLA Amount
                    jsonObject.put('REF_NO', cllist[0].Legacy_Ref_No__c);
                    // jsonObject.put('BYR_CTRY', buy_ccode);
                    // jsonObject.put('BYR_CODE', (cllist[0].Buyer_Code__c != NULL && cllist[0].Buyer_Code__c != '' && cllist[0].Buyer_Code__c.length()<7?cllist[0].Buyer_Code__c:
                    //         (cllist[0].Buyer_Code__c != NULL && cllist[0].Buyer_Code__c != ''?cllist[0].Buyer_Code__c.substring(0,7):NULL)));
                    jsonObject.put('BYR_NAME', (cllist[0].Amend_Buyer_Name__c != NULL && cllist[0].Amend_Buyer_Name__c != '' && cllist[0].Amend_Buyer_Name__c.length()<256?cllist[0].Amend_Buyer_Name__c:
                            (cllist[0].Amend_Buyer_Name__c != NULL && cllist[0].Amend_Buyer_Name__c != ''?cllist[0].Amend_Buyer_Name__c.substring(0,256):NULL)));
                    jsonObject.put('BYR_ADDR_1', (cllist[0].Amend_Buyer_Address_Line_1__c != NULL && cllist[0].Amend_Buyer_Address_Line_1__c != '' && cllist[0].Amend_Buyer_Address_Line_1__c.length()<61?cllist[0].Amend_Buyer_Address_Line_1__c:
                            (cllist[0].Amend_Buyer_Address_Line_1__c != NULL && cllist[0].Amend_Buyer_Address_Line_1__c != ''?cllist[0].Amend_Buyer_Address_Line_1__c.substring(0,61):NULL)));
                    jsonObject.put('BYR_ADDR_2', (cllist[0].Amend_Buyer_Address_Line_2__c != NULL && cllist[0].Amend_Buyer_Address_Line_2__c != '' && cllist[0].Amend_Buyer_Address_Line_2__c.length()<61?cllist[0].Amend_Buyer_Address_Line_2__c:
                            (cllist[0].Amend_Buyer_Address_Line_2__c != NULL && cllist[0].Amend_Buyer_Address_Line_2__c != ''?cllist[0].Amend_Buyer_Address_Line_2__c.substring(0,61):NULL)));
                    jsonObject.put('BYR_ADDR_3', (cllist[0].Amend_Buyer_Address_Line_3__c != NULL && cllist[0].Amend_Buyer_Address_Line_3__c != '' && cllist[0].Amend_Buyer_Address_Line_3__c.length()<61?cllist[0].Amend_Buyer_Address_Line_3__c:
                            (cllist[0].Amend_Buyer_Address_Line_3__c != NULL && cllist[0].Amend_Buyer_Address_Line_3__c != ''?cllist[0].Amend_Buyer_Address_Line_3__c.substring(0,61):NULL)));
                    jsonObject.put('BYR_ADDR_4', (cllist[0].Amend_Buyer_Address_Line_4__c != NULL && cllist[0].Amend_Buyer_Address_Line_4__c != '' && cllist[0].Amend_Buyer_Address_Line_4__c.length()<61?cllist[0].Amend_Buyer_Address_Line_4__c:
                            (cllist[0].Amend_Buyer_Address_Line_4__c != NULL && cllist[0].Amend_Buyer_Address_Line_4__c != ''?cllist[0].Amend_Buyer_Address_Line_4__c.substring(0,61):NULL)));
                    // jsonObject.put('BYR_CHN_NAME', (cllist[0].Buyer_Name__c != NULL && cllist[0].Buyer_Name__c != '' && cllist[0].Buyer_Name__c.length()<256?cllist[0].Buyer_Name__c:
                    //         (cllist[0].Buyer_Name__c != NULL && cllist[0].Buyer_Name__c != ''?cllist[0].Buyer_Name__c.substring(0,256):NULL)));
                    // jsonObject.put('BYR_CHN_ADDR_1', (cllist[0].Buyer_Address_Line_1__c != NULL && cllist[0].Buyer_Address_Line_1__c != '' && cllist[0].Buyer_Address_Line_1__c.length()<61?cllist[0].Buyer_Address_Line_1__c:
                    //         (cllist[0].Buyer_Address_Line_1__c != NULL && cllist[0].Buyer_Address_Line_1__c != ''?cllist[0].Buyer_Address_Line_1__c.substring(0,61):NULL)));
                    // jsonObject.put('BYR_CHN_ADDR_2',(cllist[0].Buyer_Address_Line_2__c != NULL && cllist[0].Buyer_Address_Line_2__c != '' && cllist[0].Buyer_Address_Line_2__c.length()<61?cllist[0].Buyer_Address_Line_2__c:
                    //         (cllist[0].Buyer_Address_Line_2__c != NULL && cllist[0].Buyer_Address_Line_2__c != ''?cllist[0].Buyer_Address_Line_2__c.substring(0,61):NULL)));
                    // jsonObject.put('BYR_CHN_ADDR_3', (cllist[0].Buyer_Address_Line_3__c != NULL && cllist[0].Buyer_Address_Line_3__c != '' && cllist[0].Buyer_Address_Line_3__c.length()<61?cllist[0].Buyer_Address_Line_3__c:
                    //         (cllist[0].Buyer_Address_Line_3__c != NULL && cllist[0].Buyer_Address_Line_3__c != ''?cllist[0].Buyer_Address_Line_3__c.substring(0,61):NULL)));
                    // jsonObject.put('BYR_CHN_ADDR_4', (cllist[0].Buyer_Address_Line_4__c != NULL && cllist[0].Buyer_Address_Line_4__c != '' && cllist[0].Buyer_Address_Line_4__c.length()<61?cllist[0].Buyer_Address_Line_4__c:
                    //         (cllist[0].Buyer_Address_Line_4__c != NULL && cllist[0].Buyer_Address_Line_4__c != ''?cllist[0].Buyer_Address_Line_4__c.substring(0,61):NULL)));
                    respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
                    respParserMapList.add(respParserMap);
                }
                else if (reqtype.equalsIgnoreCase('A') && claList != NULL && claList.size()>0 &&
                        claList[0].Legacy_Export_Type__c != NULL &&
                        !claList[0].Legacy_Export_Type__c.equalsIgnoreCase('PREPOST')){
                    jsonObject.put('REQ_TYPE', reqType); // B for Buyer information, A for CLA Amount
                    jsonObject.put('REF_NO', clalist[0].Legacy_Ref_No__c);
                    jsonObject.put('DNB_DUNS', clalist[0].DNB_DUNS__c);
                    jsonObject.put('NEW_CLA_AMT', clalist[0].Ammend_Application_Amount__c);
                    respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
                    respParserMapList.add(respParserMap);
                }
                else if(reqtype.equalsIgnoreCase('A') && claList != NULL && claList.size()>0 &&
                        claList[0].Legacy_Export_Type__c != NULL &&
                        claList[0].Legacy_Export_Type__c.equalsIgnoreCase('PREPOST')){
                    jsonObject.put('REQ_TYPE', reqType); // B for Buyer information, A for CLA Amount
                    jsonObject.put('REF_NO', clalist[0].Legacy_Ref_No__c);
                    jsonObject.put('DNB_DUNS', clalist[0].DNB_DUNS__c);
                    jsonObject.put('NEW_CLA_AMT', clalist[0].Ammend_Application_Amount__c);
                    respParserMapList.add(ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header));
                    jsonObject.put('REF_NO', clalist[0].Legacy_Pre_Ref_No__c);
                    jsonObject.put('NEW_CLA_AMT', clalist[0].Ammend_Pre_Shipment_Application_Amount__c);
                    respParserMapList.add(ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header));
                }
                else if (reqtype.equalsIgnoreCase('A') && claList != NULL && claList.size()>0 &&
                        claList[0].Legacy_Export_Type__c == NULL ){
                    jsonObject.put('REQ_TYPE', reqType); // B for Buyer information, A for CLA Amount
                    jsonObject.put('REF_NO', clalist[0].Legacy_Ref_No__c);
                    jsonObject.put('DNB_DUNS', clalist[0].DNB_DUNS__c);
                    jsonObject.put('NEW_CLA_AMT', clalist[0].Ammend_Application_Amount__c);
                    respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
                    respParserMapList.add(respParserMap);
                }
                // respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
                // if(respParserMapList != NULL && respParserMapl.size()>0 && respParserMap.containsKey('Exception')){
                //     system.debug('Exception in response ====>'+respParserMap.get('Exception'));
                //     return 'exception '+respParserMap.get('Exception');
                // }
                // else if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('ciphertext')){
                //     system.debug('json response ====>'+respParserMap.get('ciphertext'));
                //     return respParserMap.get('ciphertext');
                // }
                // else{
                //     if(respParserMap != NULL && respParserMap.size()>0){
                //         for(String Key : respParserMap.keyset()){
                //             system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                //         }
                //         return JSON.serialize(respParserMap);
                //     }
                // }
                return JSON.serialize(respParserMapList);
            }
        }
        return NULL;
    }

    // 1.3 cl/CL/cancel U7 69 Cancel CL record
    // 1.7 cl/CLA/cancel B6, U1, U2 54 Cancel CLA 
    // 1.9 cl/CL/reject U24 72,81 Reject a credit limit (for SBP and SUP) 3 Sep 2021
    // 1.12 cl/DCL/cancel U10 77 Cancel a discretionary credit limit 3 Sep 2021
    // reqType [cl_cancel, cla_cancel, cl_reject, dcl_cancel]
    @AuraEnabled
    public static string cancelCLApplicationAura(String clApplicationID, String reqType){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_CL_API_Methods.cancelCLApplication(clApplicationID, reqType);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @InvocableMethod(callout=true label='Cancel CL, CLA, DCL or reject CL' description='')
    public static void cancelCLApplicationInvoke(List<CancelCLInput> clinputs){ // 0 clId, 1 reqType
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);

            for (CancelCLInput clinput : clinputs) {
                Id clId = Id.valueOf(clinput.clId);
                String reqType = clinput.reqType;
                String response = ECIC_CL_API_Methods.cancelCLApplication(clId, reqType); // 0 clId, 1 reqType
                System.debug('#clid='+clId+', type='+reqType+', res='+response);
            }        
            //TODO: Log reponse/ Error
            //return response;
        } catch (Exception e) {
            throw new GetAccessTokenException(e.getMessage());
        }
    }

    global with sharing class CancelCLInput {
        
        @InvocableVariable(label='CLorCLAId')
        global Id clId;

        @InvocableVariable(label='RequestType')
        global String reqType;

    }

    public class GetAccessTokenException extends Exception {}

    /*
    1.3 /api/services/cl/CL/cancel Req: CUS_NO PCY_TYPE CL_NO CAN_DATE Res: reqType: cl_cancel
    1.7 /api/services/cl/CLA/cancel Req: REF_NO CAN_DATE Res: STS reqType: cla_cancel
    1.9 /api/services/cl/CL/reject Req: CL_NO CUS_NO PCY_TYPE REQ_DATE REJ_EFF_DATE res: CL_NO reqType: cl_reject
    1.12 /api/services/cl/DCL/cancel Req:CUS_NO PCY_TYPE REF_NO Res: RESULT_CODE reqType: dcl_cancel
    */
    public static String cancelCLApplication(Id clApplicationID, String reqType){
        // Possible areas to be used:
        // 1) 1) Item 54 - While a credit limit application is still under processing, the policyholder can 
        // amend or cancel the credit limit application. EC-Reach 2.0 sends the request and related data to the legacy system.
        // 1 REF_NO String 15 CA00258188 Yes Reference No. of CL application
        // 2 CAN_DATE Date 2021-05-18 Yes Cancel Date (YYYY-MM-DD)
        System.debug('clApplicationID='+clApplicationID+', reqType='+reqType);
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_V1.access_token_success){
            if(clApplicationID != NULL ){
                objectAPIName = clApplicationID.getSobjectType().getDescribe().getName();
                System.debug('objectAPIName ====>'+objectAPIName);
                Boolean testContent = False;
                String url_extension = '';
                String auth_header = ECIC_API_V1.token_type + ' ' + ECIC_API_V1.access_token;
                String url_parameters = '';
                List<String> claFields = fieldMappingTranslation.get_all_fields_from_ID(clApplicationID);
                List<Credit_Limit__c> cllist;
                List<Credit_Limit_Application__c> clalist;
                String query = 'SELECT '+ String.join(claFields, ', ');
                //List<Map<String, String>> respParserMapList = new LIst<Map<String, String>>();
                Map<String, String> respParserMap;      
                
                if(objectAPIName.equalsIgnoreCase('Credit_Limit__c')){
                    query += ', Policy__r.Exporter__r.Legacy_Customer_Number__c, Policy__r.Legacy_Policy_Type__c';
                    query += ' FROM Credit_Limit__c WHERE ID = \'' + clApplicationID + '\'';
                    cllist = DataBase.query(query);
                } else if (objectAPIName.equalsIgnoreCase('Credit_Limit_Application__c')){
                    query += ' FROM Credit_Limit_Application__c WHERE ID = \'' + clApplicationID + '\'';
                    clalist = DataBase.query(query);
                }
                System.debug('query ====>'+query);
                System.debug('cllist ===>'+cllist);
                System.debug('claList ====>'+clalist);
                if(clalist != NULL && clalist.size()>0){ 
                    
                    if (reqType.equalsIgnoreCase('cla_cancel')) {
                        //REF_NO CAN_DATE
                        url_extension = '/api/services/cl/CLA/cancel'; 
                        jsonObject.put('REF_NO', clalist[0].Legacy_Ref_No__c);
                        jsonObject.put('CAN_DATE', Date.today());
                        respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
                        //respParserMapList.add(respParserMap);   
                    }                   

                } else if(cllist != NULL && cllist.size()>0){

                    if (reqType.equalsIgnoreCase('cl_cancel')) {
                        // CUS_NO PCY_TYPE CL_NO CAN_DATE 
                        url_extension = '/api/services/cl/CL/cancel';                     
                        jsonObject.put('CUS_NO', cllist[0].Policy__r.Exporter__r.Legacy_Customer_Number__c);
                        jsonObject.put('PCY_TYPE', cllist[0].Policy__r.Legacy_Policy_Type__c);
                        jsonObject.put('CL_NO', cllist[0].CL_No__c);
                        jsonObject.put('CAN_DATE', Date.today());
                        respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
                        //respParserMapList.add(respParserMap);
                    } else if (reqType.equalsIgnoreCase('cl_reject')) {
                        //CL_NO CUS_NO PCY_TYPE REQ_DATE REJ_EFF_DATE  
                        url_extension = '/api/services/cl/CL/reject';                 
                        jsonObject.put('CUS_NO', cllist[0].Policy__r.Exporter__r.Legacy_Customer_Number__c);
                        jsonObject.put('PCY_TYPE', cllist[0].Policy__r.Legacy_Policy_Type__c);
                        jsonObject.put('CL_NO', cllist[0].CL_No__c);
                        jsonObject.put('REQ_DATE', Date.today());
                        jsonObject.put('REJ_EFF_DATE', cllist[0].Reject_Request_Date__c);
                        respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
                        //respParserMapList.add(respParserMap);
                    } else if (reqType.equalsIgnoreCase('dcl_cancel')) {
                        //CUS_NO PCY_TYPE REF_NO
                        url_extension = '/api/services/cl/DCL/cancel';  
                        jsonObject.put('CUS_NO', cllist[0].Policy__r.Exporter__r.Legacy_Customer_Number__c);
                        jsonObject.put('PCY_TYPE', cllist[0].Policy__r.Legacy_Policy_Type__c);
                        jsonObject.put('REF_NO', cllist[0].Legacy_Ref_No__c);
                        respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
                        //respParserMapList.add(respParserMap);
                    }
                } 
                if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('Exception')){
                    system.debug('Exception in response ====>'+respParserMap.get('Exception'));
                    return 'exception '+respParserMap.get('Exception');
                }
                else if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('ciphertext')){
                    system.debug('json response ====>'+respParserMap.get('ciphertext'));
                    return respParserMap.get('ciphertext');
                }
                else{
                    if(respParserMap != NULL && respParserMap.size()>0){
                        for(String Key : respParserMap.keyset()){
                            system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                        }
                        return JSON.serialize(respParserMap);
                    }
                }
            }
            return 'CL/ CLA ID is NULL.';
        }
        return 'Access token failed.';
    }

    // 1.8 cl/CLI/cancel B33 45 Cancel CLI 16-Aug-2021
    /*
    public static String cancelCLIndication (ID CLApplicationID){
        // /api/services/cl/CLI/cancel
        // 1 CL_NO String 10 Yes CL no. needs to cancel
        // 2 CAN_DATE Date Yes Cancel Date (YYYY-MM-DD)
        // 1) Get record by "CL_NO" -- Can not found '"CL_NO" -11 CL master record not found
        //                          -- Check correct CL status, the CL should be in CLI status -18 Incorrect CL status
        //                          -- Check the cancel CLI request already exists -21 Record already exists
        // 2) Check CLI record cancelled Found CLI record, but record status is cancelled -23 CLI current status is cancelled
        // 3) Validate "CAN_DATE" Value is EMPTY or not in API standard format YYYY-MM-DD -20002 Invalid date format
        // item 45	use case B33	
        // Cancel a credit limit indication automatically (for OMBP)	
        // Update the CLI status to legacy system 	Real-time	
        // Policy Management	16-08-2021	
        // "From EC-Reach 2.0 to legacy system:
        // Policyholder ID
        // Policy ID
        // Credit limit indication ID
        // Status: ""Cancelled""
        // Cannellation Date"	"From legacy system to EC-Reach 2.0:
        // Status has been updated successfully or not"	

        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_V1.access_token_success){
            if(CLApplicationID != NULL ){
                String query = 'SELECT ID, Name, Legacy_CL_No__c, Cancellation_Date__c '+     
                        'FROM Credit_Limit_Application__c WHERE ID = \'' + clApplicationID + '\'';
                List<Credit_Limit_Application__c> clalist = DataBase.query(query);       //ECIC_API_v1.get_all_fields_query(clApplicationID)
                System.debug('clalist ===>'+clalist);
                Boolean testContent = False;
                String url_extension = '/api/services/cl/CLI/cancel';
                String auth_header = ECIC_API_V1.token_type + ' ' + ECIC_API_V1.access_token;
                String url_parameters = '';
                
                if(clalist != NULL && clalist.size()>0){
                    jsonObject.put('CL_NO', String.valueOf(clalist[0].Legacy_CL_No__c));
                    jsonObject.put('CAN_DATE', fieldMappingTranslation.date_format(clalist[0].Cancellation_Date__c));
                    Map<String, String> respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
                    if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('Exception')){
                        system.debug('Exception in response ====>'+respParserMap.get('Exception'));
                        return 'exception '+respParserMap.get('Exception');
                    }
                    else if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('ciphertext')){
                        system.debug('json response ====>'+respParserMap.get('ciphertext'));
                        return respParserMap.get('ciphertext');
                    }
                    else{
                        if(respParserMap != NULL && respParserMap.size()>0){
                            for(String Key : respParserMap.keyset()){
                                system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                            }
                            return 'response received';
                        }
                    }
                }
                return NULL;
            }
            return NULL;
        }
        else{
            return NULL;
        }
    }
    */

    // 1.9 (moved to 1.7 - 18-11-2021)
    // 1.10 cl/DCL/create U3, U4 62 Apply discretionary credit limit application 3 Sep 2021
    @AuraEnabled
    public static string createDCLApplicationAura(String clApplicationID){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_CL_API_Methods.createDCLApplication(clApplicationID);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public static String createDCLApplication(String clApplicationID){
        
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        clApplicationID = String.escapeSingleQuotes(clApplicationID);
        if(ECIC_API_V1.access_token_success){
            if(clApplicationID != NULL ){
                // objectAPIName = creditLimitID.getSobjectType().getDescribe().getName();
                // System.debug('objectAPIName ====>'+objectAPIName);
                Boolean testContent = False;
                String url_extension = '/api/services/cl/DCL/create';
                String auth_header = ECIC_API_V1.token_type + ' ' + ECIC_API_V1.access_token;
                String url_parameters = '';
                List<String> claFields = fieldMappingTranslation.get_all_fields_from_ID(clApplicationID);
                List<String> opFields = fieldMappingTranslation.get_all_fields_from_APIName('Outstanding_Payment__c');
                String query =   'SELECT '+ String.join(claFields, ', ')+', '+'Policy__r.Exporter__r.Legacy_Customer_Number__c, '+
                        'Policy__r.Legacy_Policy_Type__c, Policy__r.Exporter__c, '+
                        ' ( SELECT ' + String.join(opFields, ', ') +' FROM Outstanding_Payments__r ) ' +
                        'FROM Credit_Limit_Application__c WHERE ID = \'' + clApplicationID + '\'';
                System.debug('query ====>'+query);
                List<Credit_Limit_Application__c> clalist = DataBase.query(query);       //ECIC_API_v1.get_all_fields_query(clApplicationID)
                System.debug('clalist ===>'+clalist);
                if(clalist != NULL && clalist.size()>0){
                    for(Credit_Limit_Application__c cla : clalist){
                        List<List_Storage__c> ccodelist = fieldMappingTranslation.get_country_code_all();
                        // String buy_ccode = ECIC_API_v1.get_country_code(clalist[0].Buyer_Country__c);
                        jsonObject.put('ACCOUNT_ID',cla.Policy__r.Exporter__c);
                        //jsonObject.put('POLICY_ID',cla.Policy__c);
                        jsonObject.put('CREDIT_LIMIT_APPLICATION_ID', cla.ID);
                        jsonObject.put('CUS_NO', cla.Policy__r.Exporter__r.Legacy_Customer_Number__c);// 1 CUS_NO String 6 345678 Yes Customer no.
                        jsonObject.put('PCY_TYPE', cla.Policy__r.Legacy_Policy_Type__c);// 2 PCY_TYPE String 2 51 Yes Policy type
                        
                        String byrctry;
                        for (List_Storage__c ccode : ccodeList){
                            if(ccode.List_Type__c == 'Buyer Country' && ccode.ByrCtry_Country_Name__c.equalsIgnoreCase(cla.Buyer_Country__c)){
                                byrctry = ccode.ByrCtry_Country_Code__c;
                                break;
                            }
                        }
                        System.debug('byr_ctry ====>'+byrctry);
                        jsonObject.put('BYR_CTRY', byrctry);
                        jsonObject.put('BYR_CODE', cla.Buyer_Code__c);// 11 BYR_CODE String 6 555666 Buyer code (Either Buyer code or Buyer name must be input)
                        jsonObject.put('BYR_NAME', cla.Buyer_Name__c);// 12 BYR_NAME String 255 BB Ltd. Buyer name (Either Buyer code or Buyer name must be input)
                        jsonObject.put('BYR_ADDR_1', cla.Buyer_Address_Line_1__c);// 13 BYR_ADDR_1 String 60 P.O. BOX 312, Buyer address line 1
                        jsonObject.put('BYR_ADDR_2', cla.Buyer_Address_Line_2__c);// 14 BYR_ADDR_2 String 60 GOLD MARKET, Buyer address line 2
                        jsonObject.put('BYR_ADDR_3', cla.Buyer_Address_Line_3__c);// 15 BYR_ADDR_3 String 60 CURACAO, Buyer address line 3
                        jsonObject.put('BYR_ADDR_4', cla.Buyer_Address_Line_4__c);// 16 BYR_ADDR_4 String 60 U.A.E. Buyer address line 4
                        jsonObject.put('REG_NO', cla.Buyer_Registration_Number__c);// 17 REG_NO String 30 22445566 Buyer Registration number
                        
                    }
                    Map<String, String> respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
                    if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('Exception')){
                        system.debug('Exception in response ====>'+respParserMap.get('Exception'));
                        return 'exception '+respParserMap.get('Exception');
                    }
                    else if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('ciphertext')){
                        system.debug('json response ====>'+respParserMap.get('ciphertext'));
                        return respParserMap.get('ciphertext');
                    }
                    else{
                        if(respParserMap != NULL && respParserMap.size()>0){
                            for(String Key : respParserMap.keyset()){
                                system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                            }
                            return JSON.serialize(respParserMap);
                        }
                    }
                }
                else
                    return 'credit limit application list is null';
            }
            else
                return 'credit limit application id is null.';
        }
        return NULL;
    }
     // For SUB buyer vetting 6 Jan 2022 //Arindam
     // 1.10 cl/DCL/create U3, U4 62 Apply discretionary credit limit application 3 Sep 2021
     @AuraEnabled
     public static string createVettingDCLApplicationBulkAura(List<Id> clApplicationIDs){
         try {
             String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
             System.debug('ECIC Setting name ===>'+ecicset);
             String access_token_1=ECIC_API_V1.get_access_token();
             System.debug('access_token_1 ====>'+access_token_1);
             String response = ECIC_CL_API_Methods.createVettingDCLApplicationBulk(clApplicationIDs);
             return response;
         } catch (Exception e) {
             throw new AuraHandledException(e.getMessage());
         }
     }
     public static String createVettingDCLApplicationBulk(List<Id> clApplicationIDs){
         
         String objectAPIName;
        //  clApplicationIDs = String.escapeSingleQuotes(clApplicationIDs);
         if(ECIC_API_V1.access_token_success){
             if(clApplicationIDs != NULL ){
                 // objectAPIName = creditLimitID.getSobjectType().getDescribe().getName();
                 // System.debug('objectAPIName ====>'+objectAPIName);
                 Boolean testContent = False;
                 String url_extension = '/api/services/cl/DCL/create/batch';
                 String auth_header = ECIC_API_V1.token_type + ' ' + ECIC_API_V1.access_token;
                 String url_parameters = '';
                 List<String> claFields = fieldMappingTranslation.get_all_fields_from_ID(clApplicationIDs[0]);
                 List<String> opFields = fieldMappingTranslation.get_all_fields_from_APIName('Outstanding_Payment__c');
                 String query =   'SELECT '+ String.join(claFields, ', ')
                 +', Exporter__r.Legacy_Customer_Number__c, Proposal__r.Policy_Type__c '+
                 //  ' ( SELECT ' + String.join(opFields, ', ') +' FROM Outstanding_Payments__r ) ' +
                 'FROM Buyer_Vetted__c WHERE ID IN :clApplicationIDs';
                 System.debug('query ====>'+query);
                 List<Buyer_Vetted__c> bvList = DataBase.query(query);       //ECIC_API_v1.get_all_fields_query(clApplicationID)
                 System.debug('bvList ===>'+bvList);
                 List<Map<String,Object>> jsonObjects = new List<Map<String,Object>>();
                 if(bvList != NULL && bvList.size()>0){
                     for(Buyer_Vetted__c bv : bvList){
                         Map<String, Object> jsonObject = new Map<String, Object>();
                         List<List_Storage__c> ccodelist = fieldMappingTranslation.get_country_code_all();
                         // String buy_ccode = ECIC_API_v1.get_country_code(bvList[0].Buyer_Country__c);
                         jsonObject.put('ACCOUNT_ID',bv.Exporter__c);
                         //jsonObject.put('POLICY_ID',bv.Policy__c);
                        //  jsonObject.put('CREDIT_LIMIT_APPLICATION_ID', bv.ID);
                         jsonObject.put('BUYER_VETTING_ID', bv.ID);
                         jsonObject.put('CUS_NO', bv.Exporter__r.Legacy_Customer_Number__c);// 1 CUS_NO String 6 345678 Yes Customer no.
                         jsonObject.put('PCY_TYPE', bv.Proposal__r.Policy_Type__c);// 2 PCY_TYPE String 2 51 Yes Policy type
                         
                         String byrctry;
                         for (List_Storage__c ccode : ccodeList){
                             if(ccode.List_Type__c == 'Buyer Country' && ccode.ByrCtry_Country_Name__c.equalsIgnoreCase(bv.Buyer_Country__c)){
                                 byrctry = ccode.ByrCtry_Country_Code__c;
                                 break;
                             }
                         }
                         System.debug('byr_ctry ====>'+byrctry);
                         jsonObject.put('BYR_CTRY', byrctry);
                         jsonObject.put('BYR_CODE', bv.Buyer_Code__c);// 11 BYR_CODE String 6 555666 Buyer code (Either Buyer code or Buyer name must be input)
                         jsonObject.put('BYR_NAME', bv.Buyer_Name__c);// 12 BYR_NAME String 255 BB Ltd. Buyer name (Either Buyer code or Buyer name must be input)
                         jsonObject.put('BYR_ADDR_1', bv.Buyer_Address_Line_1__c);// 13 BYR_ADDR_1 String 60 P.O. BOX 312, Buyer address line 1
                         jsonObject.put('BYR_ADDR_2', bv.Buyer_Address_Line_2__c);// 14 BYR_ADDR_2 String 60 GOLD MARKET, Buyer address line 2
                         jsonObject.put('BYR_ADDR_3', bv.Buyer_Address_Line_3__c);// 15 BYR_ADDR_3 String 60 CURACAO, Buyer address line 3
                         jsonObject.put('BYR_ADDR_4', bv.Buyer_Address_Line_4__c);// 16 BYR_ADDR_4 String 60 U.A.E. Buyer address line 4
                         jsonObject.put('REG_NO', bv.Buyer_Registration_Number__c);// 17 REG_NO String 30 22445566 Buyer Registration number
                         
                         jsonObjects.add(jsonObject);
                     }
                     Map<String, String> respParserMap = ECIC_API_v1.postBatchContentToECIC( jsonObjects, url_extension, url_parameters, auth_header);
                     if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('Exception')){
                         system.debug('Exception in response ====>'+respParserMap.get('Exception'));
                         return 'exception '+respParserMap.get('Exception');
                     }
                     else if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('ciphertext')){
                         system.debug('json response ====>'+respParserMap.get('ciphertext'));
                         return respParserMap.get('ciphertext');
                     }
                     else{
                         if(respParserMap != NULL && respParserMap.size()>0){
                             for(String Key : respParserMap.keyset()){
                                 system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                             }
                             return JSON.serialize(respParserMap);
                         }
                     }
                 }
                 else
                     return 'credit limit application list is null';
             }
             else
                 return 'credit limit application id is null.';
         }
         return NULL;
     }
    // 1.11 cl/DCL/get 80 Get discretionary credit limit record 3 Sep 2021
    // 1.12 (Moved to 1.7 - 18/11/2021)

    // 1.13 /api/services/cl/DCL/amend U9 74 Amend the buyer name and/or address for a discretionary credit limit 3 Sep 2021
    @AuraEnabled
    public static string amendDCLAura(String clApplicationID){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_CL_API_Methods.amendDCL(clApplicationID);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public static String amendDCL(ID clApplicationID){
                
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_V1.access_token_success){
            if(clApplicationID != NULL ){
                objectAPIName = clApplicationID.getSobjectType().getDescribe().getName();
                System.debug('objectAPIName ====>'+objectAPIName);
                Boolean testContent = False;
                String url_extension = '/api/services/cl/DCL/amend';
                String auth_header = ECIC_API_V1.token_type + ' ' + ECIC_API_V1.access_token;
                String url_parameters = '';
                List<String> claFields = fieldMappingTranslation.get_all_fields_from_ID(clApplicationID);
                List<Credit_Limit__c> cllist;
                List<Credit_Limit_Application__c> clalist;
                String query = 'SELECT '+ String.join(claFields, ', ');
                query += ', Policy__r.Exporter__r.Legacy_Customer_Number__c, Policy__r.Legacy_Policy_Type__c';
                //List<Map<String, String>> respParserMapList = new List<Map<String, String>>();
                Map<String, String> respParserMap;
                // String query = 'FROM Credit_Limit_Application__c WHERE ID = \'' + clApplicationID + '\'';
                if(objectAPIName.equalsIgnoreCase('Credit_Limit__c')){
                    //ECIC_API_v1.get_all_fields_query(clApplicationID)
                    query += ' FROM Credit_Limit__c WHERE ID = \'' + clApplicationID + '\'';
                    cllist = DataBase.query(query);
                }
                else if (objectAPIName.equalsIgnoreCase('Credit_Limit_Application__c')){
                    query += ' FROM Credit_Limit_Application__c WHERE ID = \'' + clApplicationID + '\'';
                    clalist = DataBase.query(query);
                }      
                System.debug('query ====>'+query);
                System.debug('cllist ===>'+cllist);
                System.debug('claList ====>'+clalist);
                
                //TODO: 1. Check - Either buyer name or buyer address must be input
                //2. check length 60 char, 255 char for byr name, address
                if(cllist != NULL && cllist.size()>0){
                    jsonObject.put('ACCOUNT_ID', cllist[0].Exporter__c);
                    jsonObject.put('CREDIT_LIMIT_ID', cllist[0].Id);
                    jsonObject.put('REF_NO', cllist[0].Legacy_Ref_No__c);
                    
                    jsonObject.put('CUS_NO', cllist[0].Policy__r.Exporter__r.Legacy_Customer_Number__c);// 1 CUS_NO String 6 345678 Yes Customer no.
                    jsonObject.put('PCY_TYPE', cllist[0].Policy__r.Legacy_Policy_Type__c);// 2 PCY_TYPE String 2 51 Yes Policy type
                    
                    jsonObject.put('BYR_NAME', cllist[0].Amend_Buyer_Name__c);
                    jsonObject.put('BYR_ADDR_1', cllist[0].Amend_Buyer_Address_Line_1__c);
                    jsonObject.put('BYR_ADDR_2', cllist[0].Amend_Buyer_Address_Line_2__c);
                    jsonObject.put('BYR_ADDR_3', cllist[0].Amend_Buyer_Address_Line_3__c);
                    jsonObject.put('BYR_ADDR_4', cllist[0].Amend_Buyer_Address_Line_4__c);
                    
    
                } else if(claList != NULL && claList.size()>0){
                    jsonObject.put('ACCOUNT_ID', claList[0].Exporter__c);
                    jsonObject.put('CREDIT_LIMIT_ID', claList[0].Id);
                    jsonObject.put('REF_NO', claList[0].Legacy_Ref_No__c);
                    
                    jsonObject.put('CUS_NO', claList[0].Policy__r.Exporter__r.Legacy_Customer_Number__c);// 1 CUS_NO String 6 345678 Yes Customer no.
                    jsonObject.put('PCY_TYPE', claList[0].Policy__r.Legacy_Policy_Type__c);// 2 PCY_TYPE String 2 51 Yes Policy type
                    
                    jsonObject.put('BYR_NAME', claList[0].Amend_Buyer_Name__c);
                    jsonObject.put('BYR_ADDR_1', claList[0].Amend_Buyer_Address_Line_1__c);
                    jsonObject.put('BYR_ADDR_2', claList[0].Amend_Buyer_Address_Line_2__c);
                    jsonObject.put('BYR_ADDR_3', claList[0].Amend_Buyer_Address_Line_3__c);
                    jsonObject.put('BYR_ADDR_4', claList[0].Amend_Buyer_Address_Line_4__c);
                    
                }
                respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
                if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('Exception')){
                    system.debug('Exception in response ====>'+respParserMap.get('Exception'));
                    return 'exception '+respParserMap.get('Exception');
                }
                else if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('ciphertext')){
                    system.debug('json response ====>'+respParserMap.get('ciphertext'));
                    return respParserMap.get('ciphertext');
                }
                else{
                    if(respParserMap != NULL && respParserMap.size()>0){
                        for(String Key : respParserMap.keyset()){
                            system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                        }
                        return JSON.serialize(respParserMap);
                    }
                }
            } else
                return 'input id is null.';
        }
        return NULL;
    }
    
    // 1.14 cl/CLA/byrList/search B6, U1, U2 49 Search buyer list by buyer name 3 Sep 2021
    // Search buyer list by buyer name
    @AuraEnabled
    public static string serchBuyerDetailsAura(String buyer_country, String buyer_name, String br_no){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            System.debug('buyer_country aura ====>'+buyer_country);
            System.debug('buyer_name aura ====>'+buyer_name);
            System.debug('br_no aura ====>'+br_no);
            String response = ECIC_CL_API_Methods.serchBuyerDetails(buyer_country,buyer_name, br_no);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public static String serchBuyerDetails (String buyer_country, String buyer_name, String br_no){
        // Possible areas to be used:
        // 1) Item 49 - Fill out and submit a credit limit application form
        // /api/services/cl/CLA/byrList/search
        
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_V1.access_token_success){
            if(buyer_country != NULL ){
                Boolean testContent = False;
                String url_extension = '/api/services/cl/CLA/byrList/search';
                String auth_header = ECIC_API_V1.token_type + ' ' + ECIC_API_V1.access_token;
                String url_parameters = '';
                
                // if(buyerMap != NULL && clalist.size()>0){
                jsonObject.put('BYR_CTRY', buyer_country);
                jsonObject.put('BYR_NAME', buyer_name);
                jsonObject.put('BR_NO', br_no);
                Map<String, String> respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
                if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('Exception')){
                    system.debug('Exception in response ====>'+respParserMap.get('Exception'));
                    return 'exception '+respParserMap.get('Exception');
                }
                else if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('ciphertext')){
                    system.debug('json response ====>'+respParserMap.get('ciphertext'));
                    return respParserMap.get('ciphertext');
                }
                else{
                    if(respParserMap != NULL && respParserMap.size()>0){
                        for(String Key : respParserMap.keyset()){
                            system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                        }
                        return JSON.serialize(respParserMap);
                    }
                }
                // }
                return JSON.serialize(respParserMap);
            }
            return 'Buyer country is null.';
        }
        else{
            return 'API access token failed.';
        }
    }

    // 3.2 /api/services/common/HrmCode/validate B6, U1, U2 Validate the harmonized code (58)
    @AuraEnabled
    public static string validateHrmCodeAura(String hrmCode){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_CL_API_Methods.validateHrmCode(hrmCode);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static string validateHrmCode(String hrmCode){
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_V1.access_token_success){
            if(hrmCode != NULL ){
                Boolean testContent = False;
                String url_extension = '/api/services/common/HrmCode/validate';
                String auth_header = ECIC_API_V1.token_type + ' ' + ECIC_API_V1.access_token;
                String url_parameters = '';
                
                jsonObject.put('HRM_CODE', hrmCode);
                Map<String, String> respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
                if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('Exception')){
                    system.debug('Exception in response ====>'+respParserMap.get('Exception'));
                    return 'exception '+respParserMap.get('Exception');
                }
                else if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('ciphertext')){
                    system.debug('json response ====>'+respParserMap.get('ciphertext'));
                    return respParserMap.get('ciphertext');
                }
                else{
                    if(respParserMap != NULL && respParserMap.size()>0){
                        for(String key : respParserMap.keyset()){
                            system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                        }
                        return JSON.serialize(respParserMap);
                    }
                }
                // }
                return JSON.serialize(respParserMap);
            }
            return 'Harmonized code is null.';
        }
        else{
            return 'API access token failed.';
        }
    }
}