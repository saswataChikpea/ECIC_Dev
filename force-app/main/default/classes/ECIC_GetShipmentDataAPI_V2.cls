public with sharing class ECIC_GetShipmentDataAPI_V2 {
    //  7.1 add shipment details
    public static String AddShipmentAPIcall(){        
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            
            Boolean testContent = False;
            String url_extension = '/api/services/de/De/add';
            String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
            String url_parameters = '';
                                
            jsonObject.put('SHIPMENT_ID', '123456789012345678');
            jsonObject.put('RECV_DATE', '2021-09-06');
            jsonObject.put('CUS_NO', '372495');
            jsonObject.put('PCY_TYPE', '51');
            jsonObject.put('DE_METHOD','I');
            //String IS_PRE_SHP = sdlist[0].Pre_Shipment_Declaration__c ? 'Y':'N';
            jsonObject.put('IS_PRE_SHP', 'Y');
            //String IS_OVERSEA_SUBS = sdlist[0].Shipment_was_made_by_anoverseas_subsidia__c ? 'Y':'N';
            jsonObject.put('IS_OVERSEA_SUBS', 'Y');
            //jsonObject.put('BYR_CTRY', sdlist[0].Buyer_Country_Code__c);
            jsonObject.put('BYR_CTRY', 'USA');
            //jsonObject.put('BYR_CODE', sdlist[0].Buyer_Code__c);
            jsonObject.put('BYR_CODE', '162519');
            jsonObject.put('SHP_DATE', '2021-09-06');
            jsonObject.put('ORG_CUR', 'USD');
            jsonObject.put('ORG_GIV', 1000);
            jsonObject.put('EXCH_RATE', 7.714);
            jsonObject.put('GIV', 2236.25);//1000
            jsonObject.put('PRM_RATE', 0.12);
            jsonObject.put('PRM', 1000);
            jsonObject.put('DIS_RATE', 0.12);
            jsonObject.put('DIS_AMT', 100);
            jsonObject.put('NET_PRM', 1000);
            jsonObject.put('PAY_METHOD', 'OA');
            jsonObject.put('PAY_PERIOD', '90');//120
            jsonObject.put('DUE_DATE', '2021-09-06');
            //jsonObject.put('ENDR_NO', sdlist[0].Endorsement__c);
            jsonObject.put('ENDR_NO', 'EN49A');
            jsonObject.put('PORT_OF_LDG', 'CHN');
            jsonObject.put('OGR_CTRY', 'CHN');
            jsonObject.put('DEST_CTRY', 'USA');
            jsonObject.put('HRM_CODE', '02040000');
            jsonObject.put('CUS_REF_NO', '12121212');

            //System.debug('PCY_TYPE :===>>>'+sdlist[0].Policy__r.Legacy_Policy_Type__c);
            //String IS_PRE_SHP = sdlist[0].Pre_Shipment_Declaration__c ? 'Y':'N';
            //System.debug('IS_PRE_SHP :===>>>'+IS_PRE_SHP );

            //shipment.put('OS_SHIPMENT_ID','a0T0l000004VrlGEAS');
            //shipment.put('REF_NO','shp-1');
            //shipment.put('SHP_DATE','2021-11-04');
            // jsonObject.put('SHIPMENT_ID','a0T0l000004WeypEAC');
            // jsonObject.put('IS_SVC','Y');
            // jsonObject.put('ORG_CUR','USD');
            // jsonObject.put('ORG_GIV','2236.25');
            // jsonObject.put('PAY_METHOD','OA');
            // jsonObject.put('PAY_PERIOD','90');
            // jsonObject.put('DUE_DATE','2021-12-04');
            // jsonObject.put('NEW_PAY_METHOD',null);
            // jsonObject.put('NEW_PAY_PERIOD',null);
            // jsonObject.put('NEW_DUE_DATE',null);
            // jsonObject.put('ORG_CTRY','HKG');
            // jsonObject.put('DEST_CTRY','USA');
            // jsonObject.put('PORT_OF_LDG','CHN');
            // jsonObject.put('HRM_CODE','02040000');
            System.debug('==JSON==>>'+System.JSON.serializePretty(jsonObject));
            System.debug('==JSON 1==>>'+System.JSON.serialize(jsonObject));
            system.debug('=========== Before Call =========>'+jsonObject+'==url_parameters=='+url_parameters+'==auth_header=='+auth_header);
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
        return null;
    } 
    
    public static String AddShipmentAPIWithSampleData(){        
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            
            Boolean testContent = False;
            String url_extension = '/api/services/de/De/add';
            String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
            String url_parameters = '';
                                
            jsonObject.put('SHIPMENT_ID', 'a0T0l000004WkMrEAK');
            jsonObject.put('RECV_DATE', '2021-09-22');
            jsonObject.put('CUS_NO', '367305');
            jsonObject.put('PCY_TYPE', '51');
            jsonObject.put('DE_METHOD','M');
            jsonObject.put('IS_PRE_SHP', 'N');
            jsonObject.put('IS_OVERSEA_SUBS', 'N');
            jsonObject.put('BYR_CTRY', 'USA');
            jsonObject.put('BYR_CODE', '162519');
            jsonObject.put('SHP_DATE', '2022-09-07');
            jsonObject.put('ORG_CUR', 'USD');
            jsonObject.put('ORG_GIV', '10000');
            jsonObject.put('EXCH_RATE','7.812345');
            jsonObject.put('GIV', '780000');//1000
            jsonObject.put('PRM_RATE', '0.12');
            jsonObject.put('PRM', '1000');
            jsonObject.put('DIS_RATE', '0.1');
            jsonObject.put('DIS_AMT', '100');
            jsonObject.put('NET_PRM', '900');
            jsonObject.put('PAY_METHOD', 'DA');
            jsonObject.put('PAY_PERIOD', '30');//120
            jsonObject.put('DUE_DATE', '2022-10-07');
            jsonObject.put('ENDR_NO', '');
            jsonObject.put('PORT_OF_LDG', 'CHN');
            jsonObject.put('ORG_CTRY', 'USA');
            jsonObject.put('DEST_CTRY', 'JPN');
            jsonObject.put('HRM_CODE', '98011111');
            jsonObject.put('CUS_REF_NO', 'ECR-0001');

            System.debug('==JSON==>>'+System.JSON.serializePretty(jsonObject));
            System.debug('==JSON 1==>>'+System.JSON.serialize(jsonObject));
            system.debug('=========== Before Call =========>'+jsonObject+'==url_parameters=='+url_parameters+'==auth_header=='+auth_header);
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
        return null;
    } 
}