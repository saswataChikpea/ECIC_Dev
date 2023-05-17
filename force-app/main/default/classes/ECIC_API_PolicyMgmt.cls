/*---------------------------------------------------------
    desc : class for calling the policy management related ecic apis.
            created from ecic_api_v1 class. 
    created by : sayantan@chikpea.com
    Modified for onboarding related call out as well.
----------------------------------------------------------*/

public with sharing class ECIC_API_PolicyMgmt {
    //  6.1      apply for the respective policy.
    @AuraEnabled
    public static string applyPolicyRecordAura(Map<String, Object> jsonObject){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_API_PolicyMgmt.applyPolicyRecord(jsonObject);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public static String applyPolicyRecord(Map<String, Object> jsonObject){
        // Possible areas to be used:
        // 1) Item 15 - Sync policy, schedule, endorsement details to legacy systems
        // 2) Item 21 - Save back the customer, policy, proposal, quotation records to the legacy system
        // 3) Item 30 - Sync policy, schedule, endorsement details to legacy systems
        // 4) Item 39 - Sync all these to legacy if policy commenced :
        // Customer details: PH name, address
        // Policy details e.g. policy period
        // S1 e.g. ML,indemnity, NQL
        // S2 e.g. primum rate, port of loading, etc.
        // Endorsements: Endorsement no
        // LA bank details: e.g. bank code, branch code, bank name & address, etc.

        // 1 REQ_TYPE String 1 Yes N - New policy, R - Renewal policy
        // 2 CUS_NO String 6 Yes Customer No.
        // 3 PCY_TYPE String 3 Yes Policy type
        // 4 PSL_REC_ID Number Yes Proposal Record ID
        // 5 COMMERCE_DATE Date Yes Policy commercement date (YYYY-MM-DD)
        // 6 EFF_DATE Date Yes Policy effective date (YYYY-MM-DD)
        // 7 EXP_DATE Date Yes Policy Expiry date (YYYY-MM-DD) (Suppose the policy will be expired after one
        // 8 STS String 1 Yes Record status
        // V - Void
        // C - Current policy record
        // W - Processing renewal or quotation
        // N - Accepted and waiting to commerce
        // E - Expired policy record
        // P - Previous policy record

        // Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            if(jsonObject != NULL && jsonObject.size()>0){
                // objectAPIName = creditLimitID.getSobjectType().getDescribe().getName();
                // System.debug('objectAPIName ====>'+objectAPIName);
                Boolean testContent = False;
                String url_extension = '/api/services/policy/Policy/apply';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
                // better send the case record it self rather than query. cause query limit.
                // query on case and check the record type
                // if(clList != NULL && clList.size()>0){
                    // for(case cl : clList){
                        /*
                        jsonObject.put('REQ_TYPE', 'N');
                        jsonObject.put('CUS_NO', '123456');
                        jsonObject.put('PCY_TYPE', 'abc');
                        jsonObject.put('PSL_REC_ID', 123456);
                        jsonObject.put('COMMERCE_DATE', 'YYYY-MM-DD');
                        jsonObject.put('EFF_DATE', 'YYYY-MM-DD');
                        jsonObject.put('EXP_DATE', 'YYYY-MM-DD');
                        jsonObject.put('STS', 'W');
                        */
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
                                String msg = '';
                                for(String Key : respParserMap.keyset()){
                                    system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                                    msg +=  key +' == value ==>'+respParserMap.get(key);
                                }
                                return msg;
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

    // 6.2      amend policy record
    @AuraEnabled
    public static string amendPolicyRecordAura(Map<String, Object> jsonObject){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_API_PolicyMgmt.amendPolicyRecord(jsonObject);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public static String amendPolicyRecord(Map<String, Object> jsonObject){
        // Possible areas to be used:
        // 1) Item 15 - Sync policy, schedule, endorsement details to legacy systems
        // 2) Item 21 - Save back the customer, policy, proposal, quotation records to the legacy system
        // 3) Item 30 - Sync policy, schedule, endorsement details to legacy systems
        // 4) Item 39 - Sync all these to legacy if policy commenced :
        // Customer details: PH name, address
        // Policy details e.g. policy period
        // S1 e.g. ML,indemnity, NQL
        // S2 e.g. primum rate, port of loading, etc.
        // Endorsements: Endorsement no
        // LA bank details: e.g. bank code, branch code, bank name & address, etc.
        // Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        // String policyID = pol.ID;
        if(ECIC_API_v1.access_token_success){
            if(jsonObject != NULL && jsonObject.size()>0){
                // objectAPIName = creditLimitID.getSobjectType().getDescribe().getName();
                // System.debug('objectAPIName ====>'+objectAPIName);
                Boolean testContent = False;
                String url_extension = '/api/services/policy/Policy/amend';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
                // better send the case record it self rather than query. cause query limit.
                // query on case and check the record type
                // if(clList != NULL && clList.size()>0){
                    // for(case cl : clList){
                        /*
                        jsonObject.put('REQ_TYPE', 'N');
                        jsonObject.put('PCY_REC_ID', 123456);
                        jsonObject.put('CUS_NO', '123456');
                        jsonObject.put('PCY_TYPE', 'abc');
                        jsonObject.put('COMMERCE_DATE', 'YYYY-MM-DD');
                        jsonObject.put('EFF_DATE', 'YYYY-MM-DD');
                        jsonObject.put('EXP_DATE', 'YYYY-MM-DD');
                        jsonObject.put('STS', 'W');
                        */
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
                                String msg = '';
                                for(String Key : respParserMap.keyset()){
                                    system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                                    msg +=  key +' == value ==>'+respParserMap.get(key);
                                }
                                return msg;
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

    // 6.3     To check whether company is an existing PH for respective policy type
    @AuraEnabled
    public static string checkPolicyDetailsAura(String PCY_TYPE, String BR_NO){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_API_PolicyMgmt.checkPolicyDetails(PCY_TYPE, BR_NO);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public static String checkPolicyDetails(String PCY_TYPE, String BR_NO){
        // Possible areas to be used:
        // 1) Item 17 - If the prospect has an outstanding non-OMBP / SBP / SUP proposal 
        // in the legacy system, then EC-Reach 2.0 shows an alert message on the application case.
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            if((PCY_TYPE != NULL && PCY_TYPE != '') && (BR_NO != NULL && BR_NO != '')){
                // objectAPIName = creditLimitID.getSobjectType().getDescribe().getName();
                // System.debug('objectAPIName ====>'+objectAPIName);
                Boolean testContent = False;
                String url_extension = '/api/services/policy/Policy/isExistPH';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
                // better send the case record it self rather than query. cause query limit.
                // query on case and check the record type
                // if(clList != NULL && clList.size()>0){
                    // for(case cl : clList){
                        jsonObject.put('PCY_TYPE', PCY_TYPE);
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
                                String msg = '';
                                for(String Key : respParserMap.keyset()){
                                    system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                                    msg +=  key +' == value ==>'+respParserMap.get(key);
                                }
                                return msg;
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

    // 6.4     To check whether company is an existing PH in other policy type and policyholder termination has not been proceeded yet.
    @AuraEnabled
    public static string checkOtherPHCompAura(String BR_NO){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_API_PolicyMgmt.checkOtherPHComp(BR_NO);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public static String checkOtherPHComp(String BR_NO){
        // Possible areas to be used:
        // 1) Item 2 - If the ex-policyholder previously had an offline policy, then there must be a termination record in the 
        // legacy system before the ex-policyholder can proceed with the application. (EC-Reach 2.0 needs to send a request to the 
        // legacy system to check if a termination record exists.)
        // 2) Item 8 - Send a request to the legacy system, to check if the prospect has an offline policy or another quotation 
        // for an offline policy when he tries to accept the quotation issued by EC-Reach 2.0
        // 3) Item 17 - If the prospect has an outstanding non-OMBP / SBP / SUP proposal in the legacy system, 
        // then EC-Reach 2.0 shows an alert message on the
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            if(BR_NO != NULL && BR_NO != ''){
                // objectAPIName = creditLimitID.getSobjectType().getDescribe().getName();
                // System.debug('objectAPIName ====>'+objectAPIName);
                Boolean testContent = False;
                
                String url_extension = '/api/services/policy/Policy/isValidOthPcyPH';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
                // better send the case record it self rather than query. cause query limit.
                // query on case and check the record type
                // if(clList != NULL && clList.size()>0){
                    // for(case cl : clList){
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
                                String msg = '';
                                for(String Key : respParserMap.keyset()){
                                    system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                                    msg +=  key +' == value ==>'+respParserMap.get(key);
                                }
                                return msg;
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

    // 6.5     To check whether company is classified as problem policyholder regardless of the PH status
    @AuraEnabled
    //public static string checkProblemPHCompAura(String PCY_TYPE, String BR_NO){
    public static string checkProblemPHCompAura(String BR_NO){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            //String response = ECIC_API_PolicyMgmt.checkProblemPHComp(PCY_TYPE, BR_NO);
            String response = ECIC_API_PolicyMgmt.checkProblemPHComp(BR_NO);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    //public static String checkProblemPHComp(String PCY_TYPE, String BR_NO){
    public static String checkProblemPHComp(String BR_NO){
        // Possible areas to be used:
        // 1)  Item 23 - Send a request to the legacy system for the problematic policyholder list
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            //if((PCY_TYPE != NULL && PCY_TYPE != '') && (BR_NO != NULL && BR_NO != '')){
                if( BR_NO != NULL && BR_NO != ''){
                // objectAPIName = creditLimitID.getSobjectType().getDescribe().getName();
                // System.debug('objectAPIName ====>'+objectAPIName);
                Boolean testContent = False;
                String url_extension = '/api/services/policy/Policy/isProblemPH';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
                // better send the case record it self rather than query. cause query limit.
                // query on case and check the record type
                // if(clList != NULL && clList.size()>0){
                    // for(case cl : clList){
                        //jsonObject.put('PCY_TYPE', PCY_TYPE);//Commented By Satya
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
                                String msg = '';
                                for(String Key : respParserMap.keyset()){
                                    system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                                    msg +=  key +' == value ==>'+respParserMap.get(key);
                                }
                                return msg;
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

    // 6.6     To check whether company is holding an O/S online proposal or quotation regardless of the policy type
    @AuraEnabled
    public static string checkHoldOSOnlinePlcyAura(String PCY_TYPE, String BR_NO){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_API_PolicyMgmt.checkHoldOSOnlinePlcy(PCY_TYPE, BR_NO);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public static String checkHoldOSOnlinePlcy(String PCY_TYPE, String BR_NO){
        // Possible areas to be used:
        // 1) Item 8 - Send a request to the legacy system, to check if the prospect has an offline policy or another quotation for an offline policy when he tries to accept the
        // quotation issued by EC-Reach 2.0
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            if((PCY_TYPE != NULL && PCY_TYPE != '') && (BR_NO != NULL && BR_NO != '')){
                // objectAPIName = creditLimitID.getSobjectType().getDescribe().getName();
                // System.debug('objectAPIName ====>'+objectAPIName);
                Boolean testContent = False;
                String url_extension = '/api/services/policy/Policy/isHoldOsOnlinePsl';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
                // better send the case record it self rather than query. cause query limit.
                // query on case and check the record type
                // if(clList != NULL && clList.size()>0){
                    // for(case cl : clList){
                        jsonObject.put('PCY_TYPE', PCY_TYPE);
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
                                String msg = '';
                                for(String Key : respParserMap.keyset()){
                                    system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                                    msg +=  key +' == value ==>'+respParserMap.get(key);
                                }
                                return msg;
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

    // 6.7     To check whether company is holding an O/S offline proposal or quotation regardless of the policy type
    @AuraEnabled
    public static string checkHoldOfflinePlcyAura(String PCY_TYPE, String BR_NO){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_API_PolicyMgmt.checkHoldOfflinePlcy(PCY_TYPE, BR_NO);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public static String checkHoldOfflinePlcy(String PCY_TYPE, String BR_NO){
        // Possible areas to be used:
        // 1) Item 8 - Send a request to the legacy system, to check if the prospect has an offline policy or another quotation for an offline policy when he tries to accept the
        // quotation issued by EC-Reach 2.0
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            if((PCY_TYPE != NULL && PCY_TYPE != '') && (BR_NO != NULL && BR_NO != '')){
                // objectAPIName = creditLimitID.getSobjectType().getDescribe().getName();
                // System.debug('objectAPIName ====>'+objectAPIName);
                Boolean testContent = False;
                String url_extension = '/api/services/policy/Policy/isHoldOsOnlinePsl';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
                // better send the case record it self rather than query. cause query limit.
                // query on case and check the record type
                // if(clList != NULL && clList.size()>0){
                    // for(case cl : clList){
                        jsonObject.put('PCY_TYPE', PCY_TYPE);
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
                                String msg = '';
                                for(String Key : respParserMap.keyset()){
                                    system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                                    msg +=  key +' == value ==>'+respParserMap.get(key);
                                }
                                return msg;
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

    // 6.8     To check whether company is an existing PH in other policy type and termination date is more than 30 days
    @AuraEnabled
    public static string checkTermOthPcyPHAura(String BR_NO){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_API_PolicyMgmt.checkTermOthPcyPH(BR_NO);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public static String checkTermOthPcyPH(String BR_NO){
        // Possible areas to be used:
        // 1) Item 17 - If the prospect has an outstanding non-OMBP / SBP / SUP proposal in the legacy system, then EC-Reach 2.0 shows an alert message on the
        // application case.
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            if(BR_NO != NULL && BR_NO != ''){
                // objectAPIName = creditLimitID.getSobjectType().getDescribe().getName();
                // System.debug('objectAPIName ====>'+objectAPIName);
                Boolean testContent = False;
                String url_extension = '/api/services/policy/Policy/getOthPcyTermDate';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
                // better send the case record it self rather than query. cause query limit.
                // query on case and check the record type
                // if(clList != NULL && clList.size()>0){
                    // for(case cl : clList){
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
                                String msg = '';
                                for(String Key : respParserMap.keyset()){
                                    system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                                    msg +=  key +' == value ==>'+respParserMap.get(key);
                                }
                                return msg;
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

    // 6.9      apply proposal record.
    @AuraEnabled
    public static string applyProposalAura(Map<String, Object> jsonObject){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_API_PolicyMgmt.applyProposal(jsonObject);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
            // return NULL;
        }
        // return NULL;
    }
    public static String applyProposal(Map<String, Object> jsonObject){   //String proposalID
        // 1 CUS_NO String 6 372447 Yes Customer No.
        // 2 PCY_TYPE String 2 51 Yes Policy type
        // 3 RECV_DATE Date 2021-05-11 Yes Receive Date
        // 4 BR_NO String 8 12345678 Yes Business registration number
        // Request META_DATA
        // Checking
        // Value is N or R
        // Customer no. is matched with customer master record
        // Policy master record is already exists
        // Policy type is matched with customer master record
        // Proposal record not found
        // Proposal record ID is matched with proposal master record
        // Value is EMPTY or not in API standard format YYYY-MM-DD
        // Commercement date is later than effective date
        // Check Commencement data and effective date with quotation record
        // Value is EMPTY or not in API standard format YYYY-MM-DD
        // Value is EMPTY or not in API standard format YYYY-MM-DD
        // Effective date is later than expiry date
        // Record status is valid
        // Possible areas to be used:
        // 1) Item 15 - Sync policy, schedule, endorsement details to legacy systems
        // 2) Item 21 - Save back the customer, policy, proposal, quotation records to the legacy system
        // 3) Item 30 - Sync policy, schedule, endorsement details to legacy systems
        // 4) Item 39 - Sync all these to legacy if policy commenced :
        // Customer details: PH name, address
        // Policy details e.g. policy period
        // S1 e.g. ML,indemnity, NQL
        // S2 e.g. primum rate, port of loading, etc.
        // Endorsements: Endorsement no
        // LA bank details: e.g. bank code, branch code, bank name & address, etc.
        // /api/services/policy/Policy/amend
        // Request META_DATA
        // Checking
        // Value is EMPTY or not in API standard format YYYY-MM-DD
        // Value is EMPTY or not in API standard format YYYY-MM-DD
        // Effective date is later than expiry date
        // Record status is valid
        // Record status is updated with correct status flow
        // Value is N or R
        // Can not found policy master record
        // Customer no. is matched with customer master record
        // Policy type is matched with customer master record
        // Proposal record ID is matched with proposal master record
        // Proposal record ID is matched with proposal master record
        // Value is EMPTY or not in API standard format YYYY-MM-DD
        // Commercement date is later than effective date
        // Check Commencement data and effective date with quotation record
        // /api/services/policy/Proposal/apply
        // Request META_DATA
        // To apply a proposal record Possible areas to be used:
        // 1) Item 4 - EC-Reach 2.0 sends a request to the legacy system for a customer number and a proposal reference number.
        // 2) Item 6 - EC-Reach 2.0 sends the customer data, policy data, proposal data, quotation data to the legacy system.
        // 3) Item 14 - Quotation - Sync proposal, quotation records to legacy (maybe multiple proposal, quotation records for one prospect)
        // 4) Item 21 - Save back the customer, policy, proposal, quotation records to the legacy system
        // Remarks:
        // To check whether company is
        // an existing PH for respective
        // policy type
        // Possible areas to be used:
        // 1) Item 17 - If the prospect has an outstanding non-OMBP / SBP / SUP proposal in the legacy system, then EC-Reach 2.0 shows an alert message on the
        // application case.
        // Remarks:
        // /api/services/policy/Policy/isExistPH
        // Request META_DATA
        // Checking
        // Can not found policy type
        // Length not equal to 8
        // To check whether company is
        // an existing PH in other policy
        // type and policyholder
        // termination has not been
        // proceeded yet.
        // Possible areas to be used:
        // 1) Item 2 - If the ex-policyholder previously had an offline policy, then there must be a termination record in the legacy system before the ex-policyholder can
        // proceed with the application. (EC-Reach 2.0 needs to send a request to the legacy system to check if a termination record exists.)
        // 2) Item 8 - Send a request to the legacy system, to check if the prospect has an offline policy or another quotation for an offline policy when he tries to accept
        // the quotation issued by EC-Reach 2.0
        // 3) Item 17 - If the prospect has an outstanding non-OMBP / SBP / SUP proposal in the legacy system, then EC-Reach 2.0 shows an alert message on the
        // Remarks:
        // /api/services/policy/Policy/isValidOthPcyPH
        // Request META_DATA
        // Checking
        // Can not found policy type
        // Length not equal to 8
        // To check whether company is
        // classified as problem
        // policyholder regardless of the
        // PH status
        // Possible areas to be used:
        // 1) Item 23 - Send a request to the legacy system for the problematic policyholder list
        // Remarks:
        // /api/services/policy/Policy/isProblemPH
        // Request META_DATA
        // Checking
        // Can not found policy type
        // Length not equal to 8
        // 5
        // STS String 2 O Yes
        // Status
        // O: O/S Proposal
        // Q: Quotation
        // R: Rejected
        // V: Void
        // 6 EXP_LAST_FY_TOT_TO Number 5000000 Yes [For Offshore trade] Total Exports in last 12 months
        // 7 EXP_LAST_FY_LC_TO Number 0 Yes [For Offshore trade] Export for LC/Payment in Advance in last 12 months
        // 8 EXP_LAST_FY_DP_DA_OA_TO Number 5000000 Yes [For Offshore trade] Export for DP, DA, OA in last 12 months
        // 9 EXP_NEXT_FY_TOT_TO Number 5000000 Yes [For Offshore trade] Total Exports in next 12 months
        // 10 EXP_NEXT_FY_LC_TO Number 0 Yes [For Offshore trade] Export for LC/Payment in Advance in next 12 months
        // 11 EXP_NEXT_FY_DP_DA_OA_TO Number 5000000 Yes [For Offshore trade] Export for DP, DA, OA in next 12 months
        // 12 BYR_CNT_UP_TO_1M Number 0 Yes [Buyer Profile] No of Buyers on estimated credit turnover for the next 12 months
        // (Up to HKD 1,000,000)
        // 13 BYR_CNT_1M_TO_5M Number 0 Yes [Buyer Profile] No of Buyers on estimated credit turnover for the next 12 months
        // (Over HKD 1,000,000 to HKD 5,000,000)
        // 14 BYR_CNT_OVER_5M Number 1 Yes [Buyer Profile] No of Buyers on estimated credit turnover for the next 12 months
        // (Over HKD 5,000,000)
        // 15 LAST_BYR_CNT_UP_TO_1M Number 0 Yes [Buyer Profile] No of Buyers on estimated credit turnover for the last 12 months
        // (Up to HKD 1,000,000)
        // 16 LAST_BYR_CNT_1M_TO_5M Number 0 Yes [Buyer Profile] No of Buyers on estimated credit turnover for the last 12 months
        // (Over HKD 1,000,000 to HKD 5,000,000)
        // 17 LAST_BYR_CNT_OVER_5M Number 0 Yes [Buyer Profile] No of Buyers on estimated credit turnover for the last 12 months
        // (Over HKD 5,000,000)
        // 18 LAST_2_YR_BAD_DEBT Number 1 Yes [Overdue Payments] Bad Debts in the last 2 years
        // 19 OVER_30_DAY_OD_AMT Number 1 Yes [Overdue Payments] Amount currently overdue for more than 30 days
        // 20 DOM_LAST_FY_TOT_TO Number 0 [For domestic export and re-export] Total Exports in last 12 months
        // 21 DOM_LAST_FY_LC_TO Number 0
        // [For domestic export and re-export] Export for LC/Payment in Advance in last 12
        // months
        // 22 DOM_LAST_FY_DP_DA_OA_TO Number 0 [For domestic export and re-export] Export for DP, DA, OA in last 12 months
        // 23 DOM_NEXT_FY_TOT_TO Number 0 [For domestic export and re-export] Total Exports in next 12 months
        // 24 DOM_NEXT_FY_LC_TO Number 0 [For domestic export and re-export] Export for LC/Payment in Advance in next 12
        // months
        // 25 DOM_NEXT_FY_DP_DA_OA_TO Number 0 [For domestic export and re-export] Export for DP, DA, OA in next 12 months
        // 26 IM_PCT Number 90 Indemnity (%)
        // 27 REF_BY_LIST String 60 Advertisement: MTR Yes Referred By
        // 28 BIZ_NATURE String 60 E Yes Business Nature
        // 29 BIZ_NATURE_OTH_DESC String 300 Business Nature Other Description
        // 30 BRK_CODE String 15 Broker code
        // 31 SUBM_MEANS String 50 Means of Proposal Submission
        // 32 MAJ_MKT_1 String 6 USA Major Market 1
        // 33 MAJ_MKT_2 String 6 HKG Major Market 2
        // 34 MAJ_MKT_3 String 6 CHN Major Market 3
        // 35 CAT_GRP_6_PRD_CODE String 6 03 Yes Product Code
        // 36 GOODS_DESC String 150 Description of goods
        // 37 GOODS_PCT Number Percentage
        // 38 RVW_EXP_DATE Date Yes Review Expiry Date
        // 39 PRM_RATE List List of Premium Rate
        // 39.1 CTRY_GDE String 5 A Premium Rate - Country Grade
        // 39.2 DP_PM_RATE Number 0.35 Premium Rate - DP Rate
        // 39.3 DA_UPTO_30_PM_RATE Number 0.63 Premium Rate - DA Rate (30 days)
        // 39.4 DA_UPTO_60_PM_RATE Number 0.7 Premium Rate - DA Rate (31 - 60 days)
        // 39.5 DA_UPTO_90_PM_RATE Number 0.84 Premium Rate - DA Rate (61 - 90 days)
        // 39.6 DA_UPTO_120_PM_RATE Number 1.12 Premium Rate - DA Rate (91 - 120 days)
        // 39.7 DA_UPTO_150_PM_RATE Number 1.12 Premium Rate - DA Rate (121 - 150 days)
        // 39.8 DA_UPTO_180_PM_RATE Number 1.12 Premium Rate - DA Rate (151 - 180 days)
        // 39.9 DA_UPTO_210_PM_RATE Number 0.35 Premium Rate - DA Rate (181 - 210 days)
        // 39.10 DA_UPTO_240_PM_RATE Number 0.63 Premium Rate - DA Rate (211 - 240 days)
        // 39.11 DA_UPTO_270_PM_RATE Number 0.7 Premium Rate - DA Rate (241 - 270 days)
        // 39.12 DA_UPTO_300_PM_RATE Number 0.84 Premium Rate - DA Rate (271 - 300 days)
        // 39.13 DA_UPTO_330_PM_RATE Number 1.12 Premium Rate - DA Rate (301 - 330 days)
        // 39.14 DA_UPTO_360_PM_RATE Number 1.12 Premium Rate - DA Rate (331 - 360 days)
        // 39.15 PRE_SHP_PM_RATE Number 0.3 Premium Rate - Pre-shipment Rate
        // 40 SP_RATE List List of Special Rate
        // 40.1 SP_BYR_CTRY String 3 USA Special Rate - Buyer Country
        // 40.2 SP_BYR_CODE String 6 123456 Special Rate - Buyer Code
        // 40.3 SP_EFF_DATE Date 2021-05-11 Special Rate - Effective Date
        // 40.4 SP_DP_PM_RATE Number 0.3 Special Rate - DP Rate
        // 40.5 SP_DA_UPTO_30_PM_RATE Number 0.3 Special Rate - DP Rate (30 days)
        // 40.6 SP_DA_UPTO_60_PM_RATE Number 0.3 Special Rate - DP Rate (31 - 60 days)
        // 40.7 SP_DA_UPTO_90_PM_RATE Number 0.3 Special Rate - DP Rate (61 - 90 days)
        // 40.8 SP_DA_UPTO_120_PM_RATE Number 0.3 Special Rate - DP Rate (91 - 120 days)
        // 40.9 SP_DA_UPTO_150_PM_RATE Number 0.3 Special Rate - DP Rate (121 - 150 days)
        // 40.10 SP_DA_UPTO_180_PM_RATE Number 0.3 Special Rate - DP Rate (151 - 180 days)
        // 40.11 SP_DA_UPTO_210_PM_RATE Number 0.3 Special Rate - DA Rate (181 - 210 days)
        // 40.12 SP_DA_UPTO_240_PM_RATE Number 0.3 Special Rate - DA Rate (211 - 240 days)
        // 40.13 SP_DA_UPTO_270_PM_RATE Number 0.3 Special Rate - DA Rate (241 - 270 days)
        // 40.14 SP_DA_UPTO_300_PM_RATE Number 0.3 Special Rate - DA Rate (271 - 300 days)
        // 40.15 SP_DA_UPTO_330_PM_RATE Number 0.3 Special Rate - DA Rate (301 - 330 days)
        // 40.16 SP_DA_UPTO_360_PM_RATE Number 0.3 Special Rate - DA Rate (331 - 360 days)
        // 40.17 SP_PRE_SHP_RM_RATE Number 0.3 Special Rate - Pre-Shipment Rate
        // 41 COMMENCE_DATE Date 2021-07-01 Commencement Date
        // 42 REVIEW_DATE Date 2022-06-30 Review Date
        // 45 ML Number 1500000 ML
        // 46 FACE_VALUE Number 5000000 Face Value
        // 47 PRM_LOADING Number 40 Premium Loading
        // 48 PCY_DEPOSIT Number 3000 Policy Deposit
        // 49 PCY_FEE Number 0 Policy Fee
        // 50 IM_PCT Number 90 Indemnity (%)
        // 51 PCY_ISS_DATE Date 2021-05-11 Policy Issue Date
        // 52 NQL Number 50000 NQL
        // 53 EX_RISK String 30 CTRY Exclusions of Repudiation risks, Exclusions of Country risks or Nil.
        // CTRY - exclusion of country risks
        // REPD - exclusion of repudiation risks
        // Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        // if()
        if(ECIC_API_v1.access_token_success){
            // if(proposalID != NULL && proposalID != ''){
                // objectAPIName = creditLimitID.getSobjectType().getDescribe().getName();
                // System.debug('objectAPIName ====>'+objectAPIName);
                Boolean testContent = False;
                String url_extension = '/api/services/policy/Proposal/apply';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
                // better send the case record it self rather than query. cause query limit.
                // query on case and check the record type
                // if(clList != NULL && clList.size()>0){
                    // for(case cl : clList){
                        
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
                                String msg = '';
                                for(String Key : respParserMap.keyset()){
                                    system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                                    msg +=  key +' == value ==>'+respParserMap.get(key);
                                }
                                return msg;
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

    // 6.10     Amend proposal record
    @AuraEnabled
    public static string amendProposalAura(Map<String, Object> jsonObject){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_API_PolicyMgmt.amendProposal(jsonObject);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
            // return NULL;
        }
        // return NULL;
    }
    public static String amendProposal(Map<String, Object> jsonObject){       //String proposalID
        // Possible areas to be used:
        // 1) Item 14 - Quotation - Sync proposal, quotation records to legacy (maybe multiple proposal, quotation records for one prospect)
        // Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            if(jsonObject != NULL && jsonObject.size()>0){
                // qur on proposal
                Boolean testContent = False;
                String url_extension = '/api/services/policy/Policy/isProblemPH';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
                /*
                jsonObject.put('PSL_REC_ID', '98997');             //      1 PSL_REC_ID String 15 98997 Yes Proposal record id
                jsonObject.put('CUS_NO', '372447');             //      2 CUS_NO String 6 372447 Yes Customer No.
                jsonObject.put('PCY_TYPE', '51');             //      3 PCY_TYPE String 2 51 Yes Policy type
                jsonObject.put('BR_NO', '12345678');             //      4 BR_NO String 8 12345678 Yes Business registration number
                jsonObject.put('STS', 'O/S');             //      5 STS String 2 O Status values O: O/S Proposal, Q: Quotation, R: Rejected, V: Void
                jsonObject.put('PROCESS_STS', 'Y');             //      6 PROCESS_STS String 2 Y Process Status
                jsonObject.put('RJ_DATE', '2021-05-01');             //      7 RJ_DATE Date 2021-05-01 Reject Date
                jsonObject.put('RJ_REASON', 'reject');             //      8 RJ_REASON String 8 Reject Reason
                jsonObject.put('RJ_OTHER_REASON', '300 char string');             //      9 RJ_OTHER_REASON String 300 Reject Other Reason
                jsonObject.put('RJ_CONT_PERSON', '45charname');             //      10 RJ_CONT_PERSON String 45 Reject Contact Person
                jsonObject.put('RJ_CONT_MEAN', '30charstr');             // 11 RJ_CONT_MEAN String 30 Reject Contact Mean
                jsonObject.put('TRNDWN_BY', '15charstr');             // 12 TRNDWN_BY String 15 Turndown By
                jsonObject.put('EXP_LAST_FY_TOT_TO', 5000000);             // 13 EXP_LAST_FY_TOT_TO Number 5000000 Yes [For Offshore trade] Total Exports in last 12 months
                jsonObject.put('EXP_LAST_FY_LC_TO', 0);             // 14 EXP_LAST_FY_LC_TO Number 0 Yes [For Offshore trade] Export for LC/Payment in Advance in last 12 months
                jsonObject.put('EXP_LAST_FY_DP_DA_OA_TO', 5000000);             // 15 EXP_LAST_FY_DP_DA_OA_TO Number 5000000 Yes [For Offshore trade] Export for DP, DA, OA in last 12 months
                jsonObject.put('EXP_NEXT_FY_TOT_TO', 5000000);             // 16 EXP_NEXT_FY_TOT_TO Number 5000000 Yes [For Offshore trade] Total Exports in next 12 months
                jsonObject.put('EXP_NEXT_FY_LC_TO', 0);             // 17 EXP_NEXT_FY_LC_TO Number 0 Yes [For Offshore trade] Export for LC/Payment in Advance in next 12 months
                jsonObject.put('EXP_NEXT_FY_DP_DA_OA_TO', 5000000);             // 18 EXP_NEXT_FY_DP_DA_OA_TO Number 5000000 Yes [For Offshore trade] Export for DP, DA, OA in next 12 months
                jsonObject.put('BYR_CNT_UP_TO_1M', 0);             // 19 BYR_CNT_UP_TO_1M Number 0 Yes [Buyer Profile] No of Buyers on estimated credit turnover for the next 12 months// (Up to HKD 1,000,000)
                jsonObject.put('BYR_CNT_1M_TO_5M', 0);             // 20 BYR_CNT_1M_TO_5M Number 0 Yes [Buyer Profile] No of Buyers on estimated credit turnover for the next 12 months// (Over HKD 1,000,000 to HKD 5,000,000)
                jsonObject.put('BYR_CNT_OVER_5M', 1);             // 21 BYR_CNT_OVER_5M Number 1 Yes [Buyer Profile] No of Buyers on estimated credit turnover for the next 12 months// (Over HKD 5,000,000)
                jsonObject.put('LAST_BYR_CNT_UP_TO_1M', 0);             // 22 LAST_BYR_CNT_UP_TO_1M Number 0 Yes [Buyer Profile] No of Buyers on estimated credit turnover for the last 12 months// (Up to HKD 1,000,000)
                jsonObject.put('LAST_BYR_CNT_1M_TO_5M', 0);             // 23 LAST_BYR_CNT_1M_TO_5M Number 0 Yes [Buyer Profile] No of Buyers on estimated credit turnover for the last 12 months// (Over HKD 1,000,000 to HKD 5,000,000)
                jsonObject.put('LAST_BYR_CNT_OVER_5M', 0);             // 24 LAST_BYR_CNT_OVER_5M Number 0 Yes [Buyer Profile] No of Buyers on estimated credit turnover for the last 12 months// (Over HKD 5,000,000)
                jsonObject.put('LAST_2_YR_BAD_DEBT', 1);             // 25 LAST_2_YR_BAD_DEBT Number 1 Yes [Overdue Payments] Bad Debts in the last 2 years
                jsonObject.put('OVER_30_DAY_OD_AMT', 1);             // 26 OVER_30_DAY_OD_AMT Number 1 Yes [Overdue Payments] Amount currently overdue for more than 30 days
                jsonObject.put('DOM_LAST_FY_TOT_TO', 0);             // 27 DOM_LAST_FY_TOT_TO Number 0 [For domestic export and re-export] Total Exports in last 12 months
                jsonObject.put('DOM_LAST_FY_LC_TO', 0);             // 28 DOM_LAST_FY_LC_TO Number 0// [For domestic export and re-export] Export for LC/Payment in Advance in last 12 months
                jsonObject.put('DOM_LAST_FY_DP_DA_OA_TO', 0);             // 29 DOM_LAST_FY_DP_DA_OA_TO Number 0 [For domestic export and re-export] Export for DP, DA, OA in last 12 months
                jsonObject.put('DOM_NEXT_FY_TOT_TO', 0);             // 30 DOM_NEXT_FY_TOT_TO Number 0 [For domestic export and re-export] Total Exports in next 12 months
                jsonObject.put('DOM_NEXT_FY_LC_TO', 0);             // 31 DOM_NEXT_FY_LC_TO Number 0 [For domestic export and re-export] Export for LC/Payment in Advance in next 12// months
                jsonObject.put('DOM_NEXT_FY_DP_DA_OA_TO', 0);             // 32 DOM_NEXT_FY_DP_DA_OA_TO Number 0 [For domestic export and re-export] Export for DP, DA, OA in next 12 months
                jsonObject.put('IM_PCT', 90);             // 33 IM_PCT Number 90 Indemnity (%)
                jsonObject.put('REF_BY_LIST', '60charstr');             // 34 REF_BY_LIST String 60 Advertisement: MTR Yes Referred By
                jsonObject.put('BIZ_NATURE', 'E60charstr');             // 35 BIZ_NATURE String 60 E Yes Business Nature
                jsonObject.put('BIZ_NATURE_OTH_DESC', '300charstr');             // 36 BIZ_NATURE_OTH_DESC String 300 Business Nature Other Description
                jsonObject.put('BRK_CODE', '15charstr');             // 37 BRK_CODE String 15 Broker code
                jsonObject.put('SUBM_MEANS', '50charstr');             // 38 SUBM_MEANS String 50 Means of Proposal Submission
                jsonObject.put('MAJ_MKT_1', '6chars');             // 39 MAJ_MKT_1 String 6 USA Major Market 1
                jsonObject.put('MAJ_MKT_2', '6chars');             // 40 MAJ_MKT_2 String 6 HKG Major Market 2
                jsonObject.put('MAJ_MKT_3', '6chars');             // 41 MAJ_MKT_3 String 6 CHN Major Market 3
                jsonObject.put('CAT_GRP_6_PRD_CODE', '6chars');             // 42 CAT_GRP_6_PRD_CODE String 6 03 Yes Product Code
                jsonObject.put('GOODS_DESC', '150charstr');             // 43 GOODS_DESC String 150 Description of goods
                jsonObject.put('GOODS_PCT', 22);             // 44 GOODS_PCT Number Percentage
                jsonObject.put('RVW_EXP_DATE', '2021-05-01');             // 45 RVW_EXP_DATE Date Yes Review Expiry Date
                jsonObject.put('PRM_RATE', '[1,2,3]');             // 46 PRM_RATE List List of Premium Rate
                jsonObject.put('CTRY_GDE', '5char');             // 46.1 CTRY_GDE String 5 A Premium Rate - Country Grade
                jsonObject.put('DP_PM_RATE', 0.35);             // 46.2 DP_PM_RATE Number 0.35 Premium Rate - DP Rate
                jsonObject.put('DA_UPTO_30_PM_RATE', 0.63);             // 46.3 DA_UPTO_30_PM_RATE Number 0.63 Premium Rate - DA Rate (30 days)
                jsonObject.put('DA_UPTO_60_PM_RATE', 0.7);             // 56.4 DA_UPTO_60_PM_RATE Number 0.7 Premium Rate - DA Rate (31 - 60 days)
                jsonObject.put('DA_UPTO_90_PM_RATE', 0.84);             // 46.5 DA_UPTO_90_PM_RATE Number 0.84 Premium Rate - DA Rate (61 - 90 days)
                jsonObject.put('DA_UPTO_120_PM_RATE', 1.12);             // 46.6 DA_UPTO_120_PM_RATE Number 1.12 Premium Rate - DA Rate (91 - 120 days)
                jsonObject.put('DA_UPTO_150_PM_RATE', 1.12);             // 46.7 DA_UPTO_150_PM_RATE Number 1.12 Premium Rate - DA Rate (121 - 150 days)
                jsonObject.put('DA_UPTO_180_PM_RATE', 1.12);             // 46.8 DA_UPTO_180_PM_RATE Number 1.12 Premium Rate - DA Rate (151 - 180 days)
                jsonObject.put('DA_UPTO_210_PM_RATE', 0.35);             // 46.9 DA_UPTO_210_PM_RATE Number 0.35 Premium Rate - DA Rate (181 - 210 days)
                jsonObject.put('DA_UPTO_240_PM_RATE', 0.63);             // 46.10 DA_UPTO_240_PM_RATE Number 0.63 Premium Rate - DA Rate (211 - 240 days)
                jsonObject.put('DA_UPTO_270_PM_RATE', 0.7);             // 46.11 DA_UPTO_270_PM_RATE Number 0.7 Premium Rate - DA Rate (241 - 270 days)
                jsonObject.put('DA_UPTO_300_PM_RATE', 0.84);             // 46.12 DA_UPTO_300_PM_RATE Number 0.84 Premium Rate - DA Rate (271 - 300 days)
                jsonObject.put('DA_UPTO_330_PM_RATE', 1.12);             // 46.13 DA_UPTO_330_PM_RATE Number 1.12 Premium Rate - DA Rate (301 - 330 days)
                jsonObject.put('DA_UPTO_360_PM_RATE', 1.12);             // 46.14 DA_UPTO_360_PM_RATE Number 1.12 Premium Rate - DA Rate (331 - 360 days)
                jsonObject.put('PRE_SHP_PM_RATE', 0.3);             // 46.15 PRE_SHP_PM_RATE Number 0.3 Premium Rate - Pre-shipment Rate
                jsonObject.put('SP_RATE', '[1,2,3]');             // 47 SP_RATE List List of Special Rate
                jsonObject.put('SP_BYR_CTRY', 'USA');             // 47.1 SP_BYR_CTRY String 3 USA Special Rate - Buyer Country
                jsonObject.put('SP_BYR_CODE', '123456');             // 47.2 SP_BYR_CODE String 6 123456 Special Rate - Buyer Code
                jsonObject.put('SP_EFF_DATE', '2021-05-11');             // 47.3 SP_EFF_DATE Date 2021-05-11 Special Rate - Effective Date
                jsonObject.put('SP_DP_PM_RATE', 0.3);             // 47.4 SP_DP_PM_RATE Number 0.3 Special Rate - DP Rate
                jsonObject.put('SP_DA_UPTO_30_PM_RATE', 0.3);             // 47.5 SP_DA_UPTO_30_PM_RATE Number 0.3 Special Rate - DP Rate (30 days)
                jsonObject.put('SP_DA_UPTO_60_PM_RATE', 0.3);             // 47.6 SP_DA_UPTO_60_PM_RATE Number 0.3 Special Rate - DP Rate (31 - 60 days)
                jsonObject.put('SP_DA_UPTO_90_PM_RATE', 0.3);             // 47.7 SP_DA_UPTO_90_PM_RATE Number 0.3 Special Rate - DP Rate (61 - 90 days)
                jsonObject.put('SP_DA_UPTO_120_PM_RATE', 0.3);             // 47.8 SP_DA_UPTO_120_PM_RATE Number 0.3 Special Rate - DP Rate (91 - 120 days)
                jsonObject.put('SP_DA_UPTO_150_PM_RATE', 0.3);             // 47.9 SP_DA_UPTO_150_PM_RATE Number 0.3 Special Rate - DP Rate (121 - 150 days)
                jsonObject.put('SP_DA_UPTO_180_PM_RATE', 0.3);             // 47.10 SP_DA_UPTO_180_PM_RATE Number 0.3 Special Rate - DP Rate (151 - 180 days)
                jsonObject.put('SP_DA_UPTO_210_PM_RATE', 0.3);             // 47.11 SP_DA_UPTO_210_PM_RATE Number 0.3 Special Rate - DA Rate (181 - 210 days)
                jsonObject.put('SP_DA_UPTO_240_PM_RATE', 0.3);             // 47.12 SP_DA_UPTO_240_PM_RATE Number 0.3 Special Rate - DA Rate (211 - 240 days)
                jsonObject.put('SP_DA_UPTO_270_PM_RATE', 0.3);             // 47.13 SP_DA_UPTO_270_PM_RATE Number 0.3 Special Rate - DA Rate (241 - 270 days)
                jsonObject.put('SP_DA_UPTO_300_PM_RATE', 0.3);             // 47.14 SP_DA_UPTO_300_PM_RATE Number 0.3 Special Rate - DA Rate (271 - 300 days)
                jsonObject.put('SP_DA_UPTO_330_PM_RATE', 0.3);             // 47.15 SP_DA_UPTO_330_PM_RATE Number 0.3 Special Rate - DA Rate (301 - 330 days)
                jsonObject.put('SP_DA_UPTO_360_PM_RATE', 0.3);             // 47.16 SP_DA_UPTO_360_PM_RATE Number 0.3 Special Rate - DA Rate (331 - 360 days)
                jsonObject.put('SP_PRE_SHP_RATE', 0.3);             // 47.17 SP_PRE_SHP_RATE Number 0.3 Special Rate - Pre-Shipment Rate
                jsonObject.put('COMMENCE_DATE', '2021-07-01');             // 48 COMMENCE_DATE Date 2021-07-01 Commencement Date
                jsonObject.put('REVIEW_DATE', '2022-06-30');             // 49 REVIEW_DATE Date 2022-06-30 Review Date
                jsonObject.put('ML', 1500000);             // 50 ML Number 1500000 ML
                jsonObject.put('FACE_VALUE', 5000000);             // 51 FACE_VALUE Number 5000000 Face Value
                jsonObject.put('PRM_LOADING', 40);             // 52 PRM_LOADING Number 40 Premium Loading
                jsonObject.put('PCY_DEPOSIT', 3000);             // 53 PCY_DEPOSIT Number 3000 Policy Deposit
                jsonObject.put('PCY_FEE', 0);             // 54 PCY_FEE Number 0 Policy Fee
                jsonObject.put('IM_PCT', 90);             // 55 IM_PCT Number 90 Indemnity (%)
                jsonObject.put('PCY_ISS_DATE', '2021-05-11');             // 56 PCY_ISS_DATE Date 2021-05-11 Policy Issue Date
                jsonObject.put('NQL', 50000);             // 57 NQL Number 50000 NQL
                jsonObject.put('EX_RISK', '30charstr');             // 58 EX_RISK String 30 CTRY Exclusions of Repudiation risks, Exclusions of Country risks or Nil.// CTRY - exclusion of country risks// REPD - exclusion of repudiation risks
                */
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
                        String msg = '';
                        for(String Key : respParserMap.keyset()){
                            system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                            msg +=  key +' == value ==>'+respParserMap.get(key);
                        }
                        return msg;
                    }
                }
            }
            return NULL;
        }
        else{
            return NULL;
        }
    }

    // 6.11     To apply quotation record
    @AuraEnabled
    public static string applyQuoteAura(Map<String, Object> jsonObject){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_API_PolicyMgmt.applyQuote(jsonObject);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
            // return NULL;
        }
        // return NULL;
    }
    public static String applyQuote(Map<String, Object> jsonObject){
        // Possible areas to be used:
        // 1) Item 14 - Quotation - Sync proposal, quotation records to legacy (maybe multiple proposal, quotation records for one prospect)
        // 2) Item 21 - Save back the customer, policy, proposal, quotation records to the legacy system
        // Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            // if(proposalID != NULL && proposalID != ''){
                // qur on proposal
                Boolean testContent = False;
                String url_extension = '/api/services/policy/Quotation/apply';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
                
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
                        String msg = '';
                        for(String Key : respParserMap.keyset()){
                            system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                            msg +=  key +' == value ==>'+respParserMap.get(key);
                        }
                        return msg;
                    }
                }
            // }
            return NULL;
        }
        else{
            return NULL;
        }
    }

    // 6.11     To apply quotation record in Bulk
    @AuraEnabled
    public static string applyQuoteAuraBulk(List<Map<String, Object>> jsonObjects){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_API_PolicyMgmt.applyQuoteBulk(jsonObjects);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
            // return NULL;
        }
        // return NULL;
    }
    public static String applyQuoteBulk(List<Map<String, Object>> jsonObjects){
        // Possible areas to be used:
        // 1) Item 14 - Quotation - Sync proposal, quotation records to legacy (maybe multiple proposal, quotation records for one prospect)
        // 2) Item 21 - Save back the customer, policy, proposal, quotation records to the legacy system
        // Map<String, Object> jsonObjects = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            // if(proposalID != NULL && proposalID != ''){
                // qur on proposal
                Boolean testContent = False;
                String url_extension = '/api/services/policy/Quotation/apply/batch';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
                
                // Map<String, String> respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObjects, url_extension, url_parameters, auth_header);
                Map<String, String> respParserMap = ECIC_API_v1.postBatchContentToECIC(jsonObjects, url_extension, url_parameters, auth_header);
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
                            system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                            msg +=  key +' == value ==>'+respParserMap.get(key);
                        }
                        return msg;
                    }
                }
            // }
            return NULL;
        }
        else{
            return NULL;
        }
    }
 

    // 6.12     Amend quotation record
    @AuraEnabled
    public static string ammendQuoteAura(Map<String, Object> jsonObject){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_API_PolicyMgmt.ammendQuote(jsonObject);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
            // return NULL;
        }
        // return NULL;
    }
    public static String ammendQuote(Map<String, Object> jsonObject){
        // Possible areas to be used:
        // 1) Item 14 - Quotation - Sync proposal, quotation records to legacy (maybe multiple proposal, quotation records for one prospect)
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            // if(proposalID != NULL && proposalID != ''){
                // qur on proposal
                Boolean testContent = False;
                String url_extension = '/api/services/policy/Quotation/amend';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
                
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
                        String msg = '';
                        for(String Key : respParserMap.keyset()){
                            system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                            msg +=  key +' == value ==>'+respParserMap.get(key);
                        }
                        return msg;
                    }
                }
            // }
            return NULL;
        }
        else{
            return NULL;
        }
    }

    // 6.13 /api/services/policy/Schedule1/add To apply a schedule 1 record
    @AuraEnabled
    public static string addPolicySchedule1Aura(Map<String, Object> jsonObject){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_API_PolicyMgmt.addPolicySchedule1(jsonObject);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static String addPolicySchedule1(Map<String, Object> jsonObject){
        
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            if(jsonObject != NULL && jsonObject.size()>0){
                // objectAPIName = creditLimitID.getSobjectType().getDescribe().getName();
                // System.debug('objectAPIName ====>'+objectAPIName);
                Boolean testContent = False;
                String url_extension = '/api/services/policy/Schedule1/add';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
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
                        String msg = '';
                        for(String Key : respParserMap.keyset()){
                            system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                            msg +=  key +' == value ==>'+respParserMap.get(key);
                        }
                        return msg;
                    }
                }            
            }
            return NULL;
        }
        else{
            return NULL;
        }
    }

    // 6.15 /api/services/policy/Schedule2/add To apply a schedule 2 record
    @AuraEnabled
    public static string addPolicySchedule2Aura(Map<String, Object> jsonObject){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_API_PolicyMgmt.addPolicySchedule2(jsonObject);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static String addPolicySchedule2(Map<String, Object> jsonObject){
        
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            if(jsonObject != NULL && jsonObject.size()>0){
                // objectAPIName = creditLimitID.getSobjectType().getDescribe().getName();
                // System.debug('objectAPIName ====>'+objectAPIName);
                Boolean testContent = False;
                String url_extension = '/api/services/policy/Schedule2/add';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
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
                        String msg = '';
                        for(String Key : respParserMap.keyset()){
                            system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                            msg +=  key +' == value ==>'+respParserMap.get(key);
                        }
                        return msg;
                    }
                }            
            }
            return NULL;
        }
        else{
            return NULL;
        }
    }

    // 6.17 /api/services/policy/Schedule3/add  To apply a schedule 3 record
    @AuraEnabled
    public static string addPolicySchedule3Aura(Map<String, Object> jsonObject){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_API_PolicyMgmt.addPolicySchedule3(jsonObject);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static String addPolicySchedule3(Map<String, Object> jsonObject){
        
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            if(jsonObject != NULL && jsonObject.size()>0){
                // objectAPIName = creditLimitID.getSobjectType().getDescribe().getName();
                // System.debug('objectAPIName ====>'+objectAPIName);
                Boolean testContent = False;
                String url_extension = '/api/services/policy/Schedule3/add';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
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
                        String msg = '';
                        for(String Key : respParserMap.keyset()){
                            system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                            msg +=  key +' == value ==>'+respParserMap.get(key);
                        }
                        return msg;
                    }
                }            
            }
            return NULL;
        }
        else{
            return NULL;
        }
    }




    // 6.22     policy/PolicyStatus/amend       
    public static String updatePolicyStatus(Set<String> policyIDset) {    
            // 35	
            // B22	Policy status	
            // Sync policy status to legacy??	
            // Nightly	ECIC				
            // Policy Management	
            // "From EC-Reach 2.0 to legacy system:
            // • Policyholder ID
            // • Policy ID
            // • Policy status"	"From legacy system to EC-Reach 2.0:
            // • N/A"	
            // Customer No.
            // 3 PCY_TYPE String 2 Yes Policy type
            // 4 STS String 1 Yes Record status
            // V - Void
            // C - Current policy record
            // W - Processing renewal or quotation
            // N - Accepted and waiting to commerce
            // E - Expired policy record
            // P - Previous policy record
            // Noted the follow flows could be accepted:
            // W => V
            // W => N
            // W => C
            // C => E
            // C => P
            // E => P
            // N => C
        Map<String, Object> jsonObject = new Map<String, Object>();
        List<Policy__c> policyList ;
        if( policyIDset != NULL && policyIDset.size()>0){
            policyList = [SELECT ID, Name, Status__c, Policy_Type__c, Exporter__c, Sync_with_Legacy__c 
                FROM Policy__c WHERE ID IN :policyIDset AND Sync_with_Legacy__c = False ORDER BY Exporter__c];
        }
        else{
            policyList = [SELECT ID, Name, Status__c, Policy_Type__c, Exporter__c, Sync_with_Legacy__c  
                FROM Policy__c WHERE Sync_with_Legacy__c = False ORDER BY Exporter__c];
        }
        String url_extension = '/api/services/policy/Policy/isTermOthPcyPH';
        String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
        String url_parameters = '';
        Boolean testContent = false;
        List<Policy__c> updatePolicyList = new List<Policy__c>();
        if(policyList != NULL && policyList.size()>0){
            for(Policy__c pol : policyList){
                jsonObject.put('PCY_REC_ID', pol.Name);
                jsonObject.put('CUS_NO', pol.Exporter__c);
                jsonObject.put('PCY_TYPE',pol.Policy_Type__c);
                jsonObject.put('STS', pol.Status__c);
                if(ECIC_API_v1.access_token_success){
                    Map<String, String> respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
                    if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('Exception')){
                        system.debug('Exception in response ====>'+respParserMap.get('Exception'));
                        return respParserMap.get('Exception');
                    }
                    else if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('ciphertext')){
                        system.debug('json response ====>'+respParserMap.get('ciphertext'));
                        return respParserMap.get('ciphertext');
                    }
                    else{
                        if(respParserMap != NULL && respParserMap.size()>0){
                            String msg = '';
                            for(String Key : respParserMap.keyset()){
                                system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                                msg +=  key +' == value ==>'+respParserMap.get(key);
                            }
                            return msg;
                        }
                    }
                    // return respParserMap;
                    return JSON.serialize(respParserMap);
                }
                else{
                    Map <String, String> respParserMap = new Map<String, String>();
                    respParserMap.put('Exception', 'Access Token call is not success');
                    // return respParserMap;
                    return JSON.serialize(respParserMap);
                }
            }
        }
        return 'Policy List is NULL.';
    }

    // 6.27     /api/services/policy/Ccf/update 
    @AuraEnabled
    public static string updatePolicyCCFAura(String policyID){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_API_PolicyMgmt.updatePolicyCCF(policyID);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }      
    public static String updatePolicyCCF(String policyID) {    
        Map<String, Object> jsonObject = new Map<String, Object>();
        List<Policy__c> policyList ;
        if( policyID != NULL && policyID != ''){
            policyList = [SELECT ID, Name, Available_Credit_Check__c, Free_Credit_Check__c, Paid_Credit_Check__c, Used_Credit_check__c, 
                    Free_Org_Credit_Check_Facility__c, Legacy_Policy_Type__c, Legacy_Customer_Number__c, Legacy_Policy_Record_Id__c  
                    FROM Policy__c WHERE ID = :policyID];
        }
        else{
            return 'policy id not defined.';
        }
        String url_extension = '/api/services/policy/Ccf/update';
            if(ECIC_API_V1.access_token_success == NULL || ECIC_API_V1.access_token_success == False){
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
        }
        String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
        String url_parameters = '';
        Boolean testContent = false;
        List<Policy__c> updatePolicyList = new List<Policy__c>();
        if(policyList != NULL && policyList.size()>0){
            
            for(Policy__c pol : policyList){
                // jsonObject.put('PCY_REC_ID', pol.Legacy_Policy_Record_Id__c);
                jsonObject.put('CUS_NO', pol.Legacy_Customer_Number__c);
                jsonObject.put('PCY_TYPE',pol.Legacy_Policy_Type__c);
                jsonObject.put('TOT_CCF', pol.Free_Credit_Check__c);
                jsonObject.put('POLICY_ID', pol.ID);
                jsonObject.put('REMAIN_CCF', pol.Available_Credit_Check__c);
                jsonObject.put('ORG_TOT_CCF', pol.Free_Credit_Check__c);
                if(ECIC_API_v1.access_token_success){
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
                            String msg = '';
                            for(String Key : respParserMap.keyset()){
                                system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                                msg +=  key +' == value ==>'+respParserMap.get(key);
                            }
                            return msg;
                        }
                    }
                    // return respParserMap;
                    return 'Some error occured, check logs.';
                }
                else{
                    Map <String, String> respParserMap = new Map<String, String>();
                    respParserMap.put('Exception', 'Access Token call is not success');
                    // return respParserMap;
                    return JSON.serialize(respParserMap);
                }
            }
        }
        return 'policy list is NULL';
    }


    // 7.1 de/De/add B29 42 Add shipment details 
    @AuraEnabled
    public static string addShipmentDetailsAura(Map<String, Object> jsonObject){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_API_PolicyMgmt.addShipmentDetails(jsonObject);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }      
    public static String addShipmentDetails(Map<String, Object> jsonObject) {    
        // Map<String, Object> jsonObject = new Map<String, Object>();
        // List<Policy__c> policyList ;
        // if( policyID != NULL && policyID != ''){
        //     policyList = [SELECT ID, Name, Available_Credit_Check__c, Free_Credit_Check__c, Paid_Credit_Check__c, Used_Credit_check__c, 
        //             Free_Org_Credit_Check_Facility__c, Legacy_Policy_Type__c, Legacy_Customer_Number__c, Legacy_Policy_Record_Id__c  
        //             FROM Policy__c WHERE ID = :policyID];
        // }
        // else{
        //     return 'policy id not defined.';
        // }
        String url_extension = '/api/services/de/De/add';
            if(ECIC_API_V1.access_token_success == NULL || ECIC_API_V1.access_token_success == False){
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
        }
        String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
        String url_parameters = '';
        Boolean testContent = false;
        List<Policy__c> updatePolicyList = new List<Policy__c>();
        // jsonObject.put('PCY_REC_ID', pol.Legacy_Policy_Record_Id__c);
        // jsonObject.put('CUS_NO', pol.Legacy_Customer_Number__c);
        // jsonObject.put('PCY_TYPE',pol.Legacy_Policy_Type__c);
        // jsonObject.put('TOT_CCF', 0);
        // jsonObject.put('REMAIN_CCF', pol.Available_Credit_Check__c);
        // jsonObject.put('ORG_TOT_CCF', pol.Free_Org_Credit_Check_Facility__c);
        if(ECIC_API_v1.access_token_success){
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
                    String msg = '';
                    for(String Key : respParserMap.keyset()){
                        system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                        msg +=  key +' == value ==>'+respParserMap.get(key);
                    }
                    return msg;
                }
            }
            // return respParserMap;
            return 'Some error occured, check logs.';
        }
        else{
            Map <String, String> respParserMap = new Map<String, String>();
            respParserMap.put('Exception', 'Access Token call is not success');
            // return respParserMap;
            return JSON.serialize(respParserMap);
        }
    
        // return 'Shipment map is NULL';
    }

    // 7.2 de/De/add B29 42 Amend shipment details 
    @AuraEnabled
    public static string amendShipmentDetailsAura(Map<String, Object> jsonObject){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_API_PolicyMgmt.addShipmentDetails(jsonObject);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }      
    public static String amendShipmentDetails(Map<String, Object> jsonObject) {    
        // Map<String, Object> jsonObject = new Map<String, Object>();
        // List<Policy__c> policyList ;
        // if( policyID != NULL && policyID != ''){
        //     policyList = [SELECT ID, Name, Available_Credit_Check__c, Free_Credit_Check__c, Paid_Credit_Check__c, Used_Credit_check__c, 
        //             Free_Org_Credit_Check_Facility__c, Legacy_Policy_Type__c, Legacy_Customer_Number__c, Legacy_Policy_Record_Id__c  
        //             FROM Policy__c WHERE ID = :policyID];
        // }
        // else{
        //     return 'policy id not defined.';
        // }
        String url_extension = '/api/services/de/De/amend';
            if(ECIC_API_V1.access_token_success == NULL || ECIC_API_V1.access_token_success == False){
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
        }
        String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
        String url_parameters = '';
        Boolean testContent = false;
        List<Policy__c> updatePolicyList = new List<Policy__c>();
        // jsonObject.put('PCY_REC_ID', pol.Legacy_Policy_Record_Id__c);
        // jsonObject.put('CUS_NO', pol.Legacy_Customer_Number__c);
        // jsonObject.put('PCY_TYPE',pol.Legacy_Policy_Type__c);
        // jsonObject.put('TOT_CCF', 0);
        // jsonObject.put('REMAIN_CCF', pol.Available_Credit_Check__c);
        // jsonObject.put('ORG_TOT_CCF', pol.Free_Org_Credit_Check_Facility__c);
        if(ECIC_API_v1.access_token_success){
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
                    String msg = '';
                    for(String Key : respParserMap.keyset()){
                        system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                        msg +=  key +' == value ==>'+respParserMap.get(key);
                    }
                    return msg;
                }
            }
            // return respParserMap;
            return 'Some error occured, check logs.';
        }
        else{
            Map <String, String> respParserMap = new Map<String, String>();
            respParserMap.put('Exception', 'Access Token call is not success');
            // return respParserMap;
            return JSON.serialize(respParserMap);
        }
    
        // return 'Shipment map is NULL';
    }


    // 8.1 /api/services/acct/Payment/settle  To settle the account payment
    @AuraEnabled
    public static string settleAccountPaymentAura(Map<String, Object> jsonObject){
        try {
            String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
            System.debug('ECIC Setting name ===>'+ecicset);
            String access_token_1=ECIC_API_V1.get_access_token();
            System.debug('access_token_1 ====>'+access_token_1);
            String response = ECIC_API_PolicyMgmt.settleAccountPayment(jsonObject);
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static String settleAccountPayment(Map<String, Object> jsonObject){
        
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            if(jsonObject != NULL && jsonObject.size()>0){
                Boolean testContent = False;
                String url_extension = '/api/services/acct/Payment/settle';
                String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
                String url_parameters = '';
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
                        String msg = '';
                        for(String Key : respParserMap.keyset()){
                            system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                            msg +=  key +' == value ==>'+respParserMap.get(key);
                        }
                        return msg;
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