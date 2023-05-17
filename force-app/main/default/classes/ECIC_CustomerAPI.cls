/*-----------------------------------------------------
    Desc : class for calling the customer related apis of ECIC legacy system. 
            created from ecic_api_v1 class
    created by : sayantan@chikpea.com
    created date : 13-Sep-2021
------------------------------------------------------*/
public with sharing class ECIC_CustomerAPI {

    // 4.1  Get customer BR record
    public static String getCustBR (String cus_no){
        // Possible areas to be used:
        // 1) Item 22 - Send the BR no, expiry date to legacy systems after SME completed the BR O/S job in ECR
        // 2) Item 24 - Update legacy system of policyholder's information after SME team updated it on EC-Reach 2.0
            Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            if(cus_no != NULL ){
                Boolean testContent = False;
                String url_extension = '/api/services/customer/BR/get';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
                
                jsonObject.put('CUS_NO', '123456');
                
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
        else{
            return NULL;
        }
    }
    
    // 4.3 /api/services/customer/ContactPerson/add  Add customer contact person information
    @AuraEnabled
    public static string addContactPersonAura(Id contactId){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_CustomerAPI.addContactPerson(contactId);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static String addContactPerson(Id contactId){
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        Contact con;
        if(ECIC_API_v1.access_token_success){
            if(con != NULL ){
                // objectAPIName = creditLimitID.getSobjectType().getDescribe().getName();
                // System.debug('objectAPIName ====>'+objectAPIName);
                Boolean testContent = False;
                String url_extension = '/api/services/customer/ContactPerson/add';
                String auth_header = ECIC_API_v1.token_type + ' ' + ECIC_API_v1.access_token;
                String url_parameters = '';
                // better send the case record it self rather than query. cause query limit.
                // query on case and check the record type
                // if(clList != NULL && clList.size()>0){
                    // for(case cl : clList){
                        jsonObject.put('CUS_NO', '123456');
                        String person_name = con.firstName+' '+con.lastname;
                        if(person_name.length()>45)
                            person_name = person_name.substring(0,44);
                        jsonObject.put('CONT_PERSON_NAME', person_name);
                        jsonObject.put('CONT_PERSON_TITLE', con.Title);
                        String emailstr=con.Email;
                        if(con.Email.length()>60)
                            emailstr = emailstr.substring(0,59);
                        jsonObject.put('CONT_PERSON_EMAIL', emailstr);
                        jsonObject.put('CONT_PERSON_MOBILE', con.Phone);
                        jsonObject.put('CONT_PERSON_SUBC', 'sub');  // con subscribe, unsubscribe
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
                    // }
                // }
            
            }
            return NULL;
        }
        else{
            return NULL;
        }
    }


    // 4.4 /api/services/customer/ContactPerson/amend Amend customer contact person information
    @AuraEnabled
    public static string amendContactPersonAura(Id contactId){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_CustomerAPI.amendContactPerson(contactId);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static String amendContactPerson(Id contactId){
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        Contact con;
        if(ECIC_API_v1.access_token_success){
            if(con != NULL ){
                Boolean testContent = False;
                String url_extension = '/api/services/customer/ContactPerson/amend';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
                jsonObject.put('CUS_NO', '123456');
                jsonObject.put('SEQ_NO', 1);
                String person_name = con.firstName+' '+con.lastname;
                if(person_name.length()>45)
                    person_name = person_name.substring(0,44);
                jsonObject.put('CONT_PERSON_NAME', person_name);
                jsonObject.put('CONT_PERSON_TITLE', con.Title);
                String emailstr=con.Email;
                if(con.Email.length()>60)
                    emailstr = emailstr.substring(0,59);
                jsonObject.put('CONT_PERSON_EMAIL', emailstr);
                jsonObject.put('CONT_PERSON_MOBILE', con.Phone);
                jsonObject.put('CONT_PERSON_SUBC', 'sub');  // con subscribe, unsubscribe
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
        else{
            return NULL;
        }
    }

    
    // 4.5 /api/services/customer/ContactPerson/delete  delete customer contact person information
    @AuraEnabled
    public static string deleteContactPersonAura(Id contactId){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_CustomerAPI.deleteContactPerson(contactId);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static String deleteContactPerson(Id contactId){
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        Contact con;
        if(ECIC_API_v1.access_token_success){
            if(con != NULL ){
                // 1 CUS_NO String 6 234567 Yes Customer No.
                // 2 SEQ_NO Number 1 Yes Sequence No.
                
                Boolean testContent = False;
                String url_extension = '/api/services/customer/ContactPerson/delete';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
                jsonObject.put('CUS_NO', '123456');
                jsonObject.put('SEQ_NO', 1);
                
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
        else{
            return NULL;
        }
    }


    // 4.6 /api/services/customer/CusNameAddr/amend  Change customer name & address information
    @AuraEnabled
    public static string updateCustomerAura(Id accountId){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_CustomerAPI.updateCustomer(accountId);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static String updateCustomer(Id accountId){
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        Account acc;
        if(ECIC_API_v1.access_token_success){
            if(acc != NULL ){
                // 1 CUS_NO String 6 345678 Yes Customer No.
                // 2 CUS_NAME String 600 ABCDEF, LTD. Yes Company name
                // 3 OFF_ADDR_1 String 60 ROOM C-D, 14/F, Yes Registered address line 1
                // 4 OFF_ADDR_2 String 60 ABC BLDG, Registered address line 2
                // 5 OFF_ADDR_3 String 60 NG YIP STREET, Registered address line 3
                // 6 OFF_ADDR_4 String 60 LAI CHI KOK, Registered address line 4
                // 7 OFF_ADDR_DIST String 60 CENTRAL Registered address district
                // 8 COR_ADDR_1 String 60 ROOM C-D, 14/F, Yes Correspondence address line 1
                // 9 COR_ADDR_2 String 60 ABC BLDG, Correspondence address line 2
                // 10 COR_ADDR_3 String 60 NG YIP STREET, Correspondence address line 3
                // 11 COR_ADDR_4 String 60 LAI CHI KOK, Correspondence address line 4
                // 12 COR_ADDR_DIST String 60 CENTRAL Correspondence address district
                // 13 CUS_NAME_HK String 200 製造有限公司 Company name (in Traditional Chinese)
                // 14 OFF_ADDR_1_HK String 60 常悅道9號 Registered address line 1 (in Traditional Chinese)
                // 15 OFF_ADDR_2_HK String 60 企業廣場一期 Registered address line 2 (in Traditional Chinese)
                // 16 OFF_ADDR_3_HK String 60 二座 Registered address line 3 (in Traditional Chinese)
                // 17 OFF_ADDR_4_HK String 60 60樓699室 Registered address line 4 (in Traditional Chinese)
                // 18 OFF_ADDR_DIST_HK String 60 九龍灣 Registered address district (in Traditional Chinese)
                // 19 COR_ADDR_1_HK String 60 常悅道9號 Correspondence address line 1 (in Traditional Chinese)
                // 20 COR_ADDR_2_HK String 60 企業廣場一期 Correspondence address line 2 (in Traditional Chinese)
                // 21 COR_ADDR_3_HK String 60 二座 Correspondence address line 3 (in Traditional Chinese)
                // 22 COR_ADDR_4_HK String 60 60樓699室 Correspondence address line 4 (in Traditional Chinese)
                // 23 COR_ADDR_DIST_HK String 60 九龍灣 Correspondence address district (in Traditional Chinese)
                // 24 COM_TEL_NO String 45 22334455 Company telephone no.
                // 25 LANG_TYPE String 2 E Yes Language to be used for outgoing correspondence (E - English/T - Traditional
                // Response META_DATA
                
                Boolean testContent = False;
                String url_extension = '/api/services/customer/CusNameAddr/amend';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
                // jsonObject.put('CUS_NO', (acc.Legacy_Customer_Number__c != NULL && clalist[0].Buyer_Code__c != '' && clalist[0].Buyer_Code__c.length()<7?clalist[0].Buyer_Code__c:
                //         (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != ''?clalist[0].Buyer_Code__c.substring(0,7):NULL)));
                // jsonObject.put('CUS_NAME', (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != '' && clalist[0].Buyer_Code__c.length()<7?clalist[0].Buyer_Code__c:
                //         (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != ''?clalist[0].Buyer_Code__c.substring(0,7):NULL)));
                // jsonObject.put('OFF_ADDR_1', (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != '' && clalist[0].Buyer_Code__c.length()<7?clalist[0].Buyer_Code__c:
                //         (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != ''?clalist[0].Buyer_Code__c.substring(0,7):NULL)));
                // jsonObject.put('OFF_ADDR_2', (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != '' && clalist[0].Buyer_Code__c.length()<7?clalist[0].Buyer_Code__c:
                // (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != ''?clalist[0].Buyer_Code__c.substring(0,7):NULL)));
                // jsonObject.put('OFF_ADDR_3',(clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != '' && clalist[0].Buyer_Code__c.length()<7?clalist[0].Buyer_Code__c:
                // (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != ''?clalist[0].Buyer_Code__c.substring(0,7):NULL)));
                // jsonObject.put('OFF_ADDR_4',(clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != '' && clalist[0].Buyer_Code__c.length()<7?clalist[0].Buyer_Code__c:
                // (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != ''?clalist[0].Buyer_Code__c.substring(0,7):NULL)));
                // jsonObject.put('OFF_ADDR_DIST',(clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != '' && clalist[0].Buyer_Code__c.length()<7?clalist[0].Buyer_Code__c:
                // (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != ''?clalist[0].Buyer_Code__c.substring(0,7):NULL)));
                // jsonObject.put('COR_ADDR_1',(clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != '' && clalist[0].Buyer_Code__c.length()<7?clalist[0].Buyer_Code__c:
                // (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != ''?clalist[0].Buyer_Code__c.substring(0,7):NULL)));
                // jsonObject.put('COR_ADDR_2', (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != '' && clalist[0].Buyer_Code__c.length()<7?clalist[0].Buyer_Code__c:
                // (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != ''?clalist[0].Buyer_Code__c.substring(0,7):NULL)));
                // jsonObject.put('COR_ADDR_3', (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != '' && clalist[0].Buyer_Code__c.length()<7?clalist[0].Buyer_Code__c:
                // (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != ''?clalist[0].Buyer_Code__c.substring(0,7):NULL)));
                // jsonObject.put('COR_ADDR_4', (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != '' && clalist[0].Buyer_Code__c.length()<7?clalist[0].Buyer_Code__c:
                // (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != ''?clalist[0].Buyer_Code__c.substring(0,7):NULL)));
                // jsonObject.put('COR_ADDR_DIST', (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != '' && clalist[0].Buyer_Code__c.length()<7?clalist[0].Buyer_Code__c:
                // (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != ''?clalist[0].Buyer_Code__c.substring(0,7):NULL)));
                // jsonObject.put('CUS_NAME_HK', (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != '' && clalist[0].Buyer_Code__c.length()<7?clalist[0].Buyer_Code__c:
                // (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != ''?clalist[0].Buyer_Code__c.substring(0,7):NULL)));
                // jsonObject.put('OFF_ADDR_1_HK', (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != '' && clalist[0].Buyer_Code__c.length()<7?clalist[0].Buyer_Code__c:
                // (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != ''?clalist[0].Buyer_Code__c.substring(0,7):NULL)));
                // jsonObject.put('OFF_ADDR_2_HK',(clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != '' && clalist[0].Buyer_Code__c.length()<7?clalist[0].Buyer_Code__c:
                // (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != ''?clalist[0].Buyer_Code__c.substring(0,7):NULL)));
                // jsonObject.put('OFF_ADDR_3_HK', (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != '' && clalist[0].Buyer_Code__c.length()<7?clalist[0].Buyer_Code__c:
                // (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != ''?clalist[0].Buyer_Code__c.substring(0,7):NULL)));
                // jsonObject.put('OFF_ADDR_4_HK', (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != '' && clalist[0].Buyer_Code__c.length()<7?clalist[0].Buyer_Code__c:
                // (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != ''?clalist[0].Buyer_Code__c.substring(0,7):NULL)));
                // jsonObject.put('OFF_ADDR_DIST_HK', (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != '' && clalist[0].Buyer_Code__c.length()<7?clalist[0].Buyer_Code__c:
                // (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != ''?clalist[0].Buyer_Code__c.substring(0,7):NULL)));
                // jsonObject.put('COR_ADDR_1_HK', (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != '' && clalist[0].Buyer_Code__c.length()<7?clalist[0].Buyer_Code__c:
                // (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != ''?clalist[0].Buyer_Code__c.substring(0,7):NULL)));
                // jsonObject.put('COR_ADDR_2_HK', (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != '' && clalist[0].Buyer_Code__c.length()<7?clalist[0].Buyer_Code__c:
                // (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != ''?clalist[0].Buyer_Code__c.substring(0,7):NULL)));
                // jsonObject.put('COR_ADDR_3_HK', (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != '' && clalist[0].Buyer_Code__c.length()<7?clalist[0].Buyer_Code__c:
                // (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != ''?clalist[0].Buyer_Code__c.substring(0,7):NULL)));
                // jsonObject.put('COR_ADDR_4_HK', 1);(clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != '' && clalist[0].Buyer_Code__c.length()<7?clalist[0].Buyer_Code__c:
                // (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != ''?clalist[0].Buyer_Code__c.substring(0,7):NULL)));
                // jsonObject.put('COR_ADDR_DIST_HK', (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != '' && clalist[0].Buyer_Code__c.length()<7?clalist[0].Buyer_Code__c:
                // (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != ''?clalist[0].Buyer_Code__c.substring(0,7):NULL)));
                // jsonObject.put('COM_TEL_NO', (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != '' && clalist[0].Buyer_Code__c.length()<7?clalist[0].Buyer_Code__c:
                // (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != ''?clalist[0].Buyer_Code__c.substring(0,7):NULL)));
                // jsonObject.put('LANG_TYPE', (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != '' && clalist[0].Buyer_Code__c.length()<7?clalist[0].Buyer_Code__c:
                // (clalist[0].Buyer_Code__c != NULL && clalist[0].Buyer_Code__c != ''?clalist[0].Buyer_Code__c.substring(0,7):NULL)));
    
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
        else{
            return NULL;
        }
    }
        // 4.7        customer/NFC/get
    @AuraEnabled
    public static string getNFCRecordAura(String cutomerNumber){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            //String response = ECIC_API_PolicyMgmt.applyProposal(cutomerNumber);
            String response = ECIC_CustomerAPI.getNFCRecord(cutomerNumber);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
            // return NULL;
        }
        // return NULL;
    }
    public static String getNFCRecord(String cutomerNumber){
        Map<String, Object> jsonObject = new Map<String, Object>();
        // /api/services/customer/NFC/get
        // Request META_DATA 1 CUS_NO String 6 Yes Customer No.
        // Response META_DATA 1 NFC List List of NFC records
        // 1.1 RPT_RECV_DATE Date Report Received Date (YYYY-MM-DD)
        // 1.2 REV_DATE Date Review Date (YYYY-MM-DD)
        // 1.3 REV_OFR String 15 Review Officer
        // 1.4 ACK_STS String 1 Acknowledge Status ( Y = Acknowledge, N = Not Yet process )
        // 1.5 CASES List List of Case records
        // 1.5.1 CASE_TYPE String 8 Case type (CRT / DEBT)
        // 1.5.2 CASE_ID Number Record ID
        // 1.5.3 CASE_STS String 2 Case status (O - outstanding, V - void)
        // 1.5.4 CASE_DATE String 10 Case date (YYYY)
        // 1.5.5 CASE_AMT Number Case amount
        // 1.5.6 CASE_CREATE_RMK String Case create remark
        // 1.5.7 CASE_UPDATE_RMK String Case update remark
        // Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            // if(customerID != NULL && customerID != ''){
                // objectAPIName = creditLimitID.getSobjectType().getDescribe().getName();
                // System.debug('objectAPIName ====>'+objectAPIName);
                Boolean testContent = False;
                String url_extension = '/api/services/customer/NFC/get';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
                // better send the case record it self rather than query. cause query limit.
                // query on case and check the record type
                // if(clList != NULL && clList.size()>0){
                    // for(case cl : clList){
                        jsonObject.put('CUS_NO', cutomerNumber);
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
                    // }
                // }
            
            // }
            return NULL;
        }
        else{
            return NULL;
        }
    }
        // 4.8        customer/NFC/create
    @AuraEnabled
    public static string createNFCRecordAura(String cutomerNumber){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            //String response = ECIC_API_PolicyMgmt.applyProposal(cutomerNumber);
            String response = ECIC_CustomerAPI.createNFCRecord(cutomerNumber);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
            // return NULL;
        }
        // return NULL;
    }


    public static String createNFCRecord(String customerID){
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            if(customerID != NULL && customerID != ''){
                // objectAPIName = creditLimitID.getSobjectType().getDescribe().getName();
                // System.debug('objectAPIName ====>'+objectAPIName);
                Boolean testContent = False;
                String url_extension = '/api/services/customer/NFC/create';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
                // better send the case record it self rather than query. cause query limit.
                // query on case and check the record type
                // if(clList != NULL && clList.size()>0){
                    // for(case cl : clList){
                        jsonObject.put('CUS_NO', customerID);
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
                    // }
                // }
            
            }
            return NULL;
        }
        else{
            return NULL;
        }
    }
        // 4.9   Retrieve the non-OMBP/SBP/SUP outstanding proposal / quotation
    public static String getOfflinePolicy(String BR_NO){
        // 1) Item 17 - If the prospect has an outstanding non-OMBP / SBP / SUP proposal in the legacy system, 
        // then EC-Reach 2.0 shows an alert message on the application case
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            if(BR_NO != NULL && BR_NO != ''){
                Boolean testContent = False;
                String url_extension = '/api/services/customer/OfflinePslQuoAO/get';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
                
                jsonObject.put('BR_NO', BR_NO);
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
        else{
            return NULL;
        }
    }
    
}