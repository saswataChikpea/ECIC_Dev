/*--------------------------------------------------------
    desc : class for Shipment API
    created on  24-Dec-2021
    created by : athar@chikpea.com 

---------------------------------------------------------*/

public with sharing class ECIC_GetShipmentDataAPI {
    
    //  7.1 add shipment details
    public static String AddShipmentAPIcall(String sdId){        
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            if(sdId != null){
                
                Boolean testContent = False;
                String url_extension = '/api/services/de/De/add';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
                String query = 'SELECT ID, Name, CreatedDate, Policy__r.Legacy_Customer_Number__c,'
                    +'Policy__r.Legacy_Policy_Type__c, Type__c, Pre_Shipment_Declaration__c,'
                    +'Shipment_was_made_by_anoverseas_subsidia__c, Buyer_Country_Code__c, Buyer_Code__c,'
                    +'Shipment_Date__c, Currency__c, Gross_Invoice_Value__c, Exchange_Rate__c, Gross_Invoice_Value_HKD__c,'
                    +'Premium_Rate__c, Premium__c, Discount_Rate__c, Discount_Amount__c, Net_Premium__c, Payment_Term_Type__c,'
                    +'Payment_Term_Days__c, Due_Date__c, Endorsement__c, Port_of_Loading_Ship_From__c, Country_of_Origin__c,'
                    +'Destination_Country_Market_Ship_to__c, Harmonized_Code__c, Policyholder_Reference_No__c '
                    +'FROM Shipment_Declaration__c WHERE ID = \'' + sdId + '\'';
             
                List<Shipment_Declaration__c> sdlist = DataBase.query(query);
                
                System.debug('sdlist ===>'+sdlist);
                if(sdlist != NULL && sdlist.size()>0){                    
                    jsonObject.put('SHIPMENT_ID', sdlist[0].Id);
                    jsonObject.put('RECV_DATE', sdlist[0].CreatedDate!= NULL?fieldMappingTranslation.date_format(sdlist[0].CreatedDate):NULL);
                    jsonObject.put('CUS_NO', sdlist[0].Policy__r.Legacy_Customer_Number__c);
                    jsonObject.put('PCY_TYPE', sdlist[0].Policy__r.Legacy_Policy_Type__c);
                    jsonObject.put('DE_METHOD', sdlist[0].Type__c);
                    jsonObject.put('IS_PRE_SHP', sdlist[0].Pre_Shipment_Declaration__c);
                    jsonObject.put('IS_OVERSEA_SUBS', sdlist[0].Shipment_was_made_by_anoverseas_subsidia__c);
                    jsonObject.put('BYR_CTRY', sdlist[0].Buyer_Country_Code__c);
                    jsonObject.put('BYR_CODE', sdlist[0].Buyer_Code__c);
                    jsonObject.put('SHP_DATE', sdlist[0].Shipment_Date__c!= NULL?fieldMappingTranslation.date_format(sdlist[0].Shipment_Date__c):NULL);
                    jsonObject.put('ORG_CUR', sdlist[0].Currency__c);
                    jsonObject.put('ORG_GIV', sdlist[0].Gross_Invoice_Value__c);
                    jsonObject.put('EXCH_RATE', sdlist[0].Exchange_Rate__c);
                    jsonObject.put('GIV', sdlist[0].Gross_Invoice_Value_HKD__c);
                    jsonObject.put('PRM_RATE', sdlist[0].Premium_Rate__c);
                    jsonObject.put('PRM', sdlist[0].Premium__c);
                    jsonObject.put('DIS_RATE', sdlist[0].Discount_Rate__c);
                    jsonObject.put('DIS_AMT', sdlist[0].Discount_Amount__c);
                    jsonObject.put('NET_PRM', sdlist[0].Net_Premium__c);
                    jsonObject.put('PAY_METHOD', sdlist[0].Payment_Term_Type__c);
                    jsonObject.put('PAY_PERIOD', sdlist[0].Payment_Term_Days__c);
                    jsonObject.put('DUE_DATE', sdlist[0].Due_Date__c!= NULL?fieldMappingTranslation.date_format(sdlist[0].Due_Date__c):NULL);
                    jsonObject.put('ENDR_NO', sdlist[0].Endorsement__c);
                    jsonObject.put('PORT_OF_LDG', sdlist[0].Port_of_Loading_Ship_From__c);
                    jsonObject.put('OGR_CTRY', sdlist[0].Country_of_Origin__c);
                    jsonObject.put('DEST_CTRY', sdlist[0].Destination_Country_Market_Ship_to__c);
                    jsonObject.put('HRM_CODE', sdlist[0].Harmonized_Code__c);
                    jsonObject.put('CUS_REF_NO', sdlist[0].Policyholder_Reference_No__c);

                    system.debug('============ Before Call =========>'+jsonObject+'==url_parameters=='+url_parameters+'==auth_header=='+auth_header);
                    Map<String, String> respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
                    system.debug('=========== after Call =========>'+respParserMap);

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
                            String msg = '';
                            for(String Key : respParserMap.keyset()){
                                msg += key +' == value ==>'+respParserMap.get(key);
                                system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                            }
                            return msg;
                        }
                    return null;                              
                    }                    
                }
                else{
                    return NULL;
                }        
            }
            else{
                return NULL;
            }         
        }
        return null;
    }
    
    //  7.2 edit shipment details /api/services/de/De/amend
    public static String amendShipmentAPIcall(String sdId){        
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            if(sdId != null){
                
                Boolean testContent = False;
                String url_extension = '/api/services/de/De/amend';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
                String query = 'SELECT ID, Name, CreatedDate, Policy__r.Legacy_Customer_Number__c,'
                    +'Policy__r.Legacy_Policy_Type__c, Type__c, Pre_Shipment_Declaration__c,'
                    +'Shipment_was_made_by_anoverseas_subsidia__c, Buyer_Country_Code__c, Buyer_Code__c,'
                    +'Shipment_Date__c, Currency__c, Gross_Invoice_Value__c, Exchange_Rate__c, Gross_Invoice_Value_HKD__c,'
                    +'Premium_Rate__c, Premium__c, Discount_Rate__c, Discount_Amount__c, Net_Premium__c, Payment_Term_Type__c,'
                    +'Payment_Term_Days__c, Due_Date__c, Endorsement__c, Port_of_Loading_Ship_From__c, Country_of_Origin__c,'
                    +'Destination_Country_Market_Ship_to__c, Harmonized_Code__c, Policyholder_Reference_No__c '
                    +'FROM Shipment_Declaration__c WHERE ID = \'' + sdId + '\'';
             
                List<Shipment_Declaration__c> sdlist = DataBase.query(query);
                
                System.debug('sdlist ===>'+sdlist);
                if(sdlist != NULL && sdlist.size()>0){                    
                    jsonObject.put('SHIPMENT_ID', sdlist[0].Id);
                    jsonObject.put('RECV_DATE', sdlist[0].CreatedDate!= NULL?fieldMappingTranslation.date_format(sdlist[0].CreatedDate):NULL);
                    jsonObject.put('CUS_NO', sdlist[0].Policy__r.Legacy_Customer_Number__c);
                    jsonObject.put('PCY_TYPE', sdlist[0].Policy__r.Legacy_Policy_Type__c);
                    jsonObject.put('DE_METHOD', sdlist[0].Type__c);
                    jsonObject.put('IS_PRE_SHP', sdlist[0].Pre_Shipment_Declaration__c);
                    jsonObject.put('IS_OVERSEA_SUBS', sdlist[0].Shipment_was_made_by_anoverseas_subsidia__c);
                    jsonObject.put('BYR_CTRY', sdlist[0].Buyer_Country_Code__c);
                    jsonObject.put('BYR_CODE', sdlist[0].Buyer_Code__c);
                    jsonObject.put('SHP_DATE', sdlist[0].Shipment_Date__c!= NULL?fieldMappingTranslation.date_format(sdlist[0].Shipment_Date__c):NULL);
                    jsonObject.put('ORG_CUR', sdlist[0].Currency__c);
                    jsonObject.put('ORG_GIV', sdlist[0].Gross_Invoice_Value__c);
                    jsonObject.put('EXCH_RATE', sdlist[0].Exchange_Rate__c);
                    jsonObject.put('GIV', sdlist[0].Gross_Invoice_Value_HKD__c);
                    jsonObject.put('PRM_RATE', sdlist[0].Premium_Rate__c);
                    jsonObject.put('PRM', sdlist[0].Premium__c);
                    jsonObject.put('DIS_RATE', sdlist[0].Discount_Rate__c);
                    jsonObject.put('DIS_AMT', sdlist[0].Discount_Amount__c);
                    jsonObject.put('NET_PRM', sdlist[0].Net_Premium__c);
                    jsonObject.put('PAY_METHOD', sdlist[0].Payment_Term_Type__c);
                    jsonObject.put('PAY_PERIOD', sdlist[0].Payment_Term_Days__c);
                    jsonObject.put('DUE_DATE', sdlist[0].Due_Date__c!= NULL?fieldMappingTranslation.date_format(sdlist[0].Due_Date__c):NULL);
                    jsonObject.put('ENDR_NO', sdlist[0].Endorsement__c);
                    jsonObject.put('PORT_OF_LDG', sdlist[0].Port_of_Loading_Ship_From__c);
                    jsonObject.put('OGR_CTRY', sdlist[0].Country_of_Origin__c);
                    jsonObject.put('DEST_CTRY', sdlist[0].Destination_Country_Market_Ship_to__c);
                    jsonObject.put('HRM_CODE', sdlist[0].Harmonized_Code__c);
                    jsonObject.put('CUS_REF_NO', sdlist[0].Policyholder_Reference_No__c);

                    system.debug('============ Before Call =========>'+jsonObject+'==url_parameters=='+url_parameters+'==auth_header=='+auth_header);
                    Map<String, String> respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
                    system.debug('=========== after Call =========>'+respParserMap);

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
                            String msg = '';
                            for(String Key : respParserMap.keyset()){
                                msg += key +' == value ==>'+respParserMap.get(key);
                                system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                            }
                            return msg;
                        }
                    return null;                              
                    }                    
                }
                else{
                    return NULL;
                }        
            }
            else{
                return NULL;
            }         
        }
        return null;
    }

    //  7.3 edit shipment details /api/services/de/De/delete
    public static String deleteShipmentAPIcall(String sdId){
        
        return null;
    }

}