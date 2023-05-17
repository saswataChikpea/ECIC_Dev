/*-----------------------------------------------------
    Desc : class for calling the master product, country, legal type, currency,
        district etc. related apis of ECIC legacy system. 
            created from ecic_api_v1 class
    created by : sayantan@chikpea.com
    created date : 13-Sep-2021
------------------------------------------------------*/

public with sharing class ECIC_GetMasterListAPI {
    
    // 5.1       Get the master list of district for company address
    public static String getMasterAddressList(){
        // 1) Item 11 - Retrieve and show the district list stored on the legacy system while the prospect 
        // is filling in the "Company address (registered / correspondence)
        // - District" field on the proposal form
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            Boolean testContent = False;
            String url_extension = '/api/services/mst/AddrDistList/get';
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
                        msg += key +' == value ==>'+respParserMap.get(key);
                        system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                    }
                    return msg;
                }
            }
            return NULL;
        }
        else{
            return NULL;
        }
    }

    // 5.2       Get the master list of country
    public static String getMasterCountryList(){
        // 1) Item 11 - Retrieve and show the district list stored on the legacy system while the prospect 
        // is filling in the "Company address (registered / correspondence)
        // - District" field on the proposal form
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            Boolean testContent = False;
            String url_extension = '/api/services/mst/CtryList/get';
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
                        msg += key +' == value ==>'+respParserMap.get(key);
                        system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                    }
                    return msg;
                }
            }
            return NULL;
        }
        else{
            return NULL;
        }
    }

    // 5.3       Get the master list of legal type
    public static String getMasterLegalTypeList(){
        // 1) Item 11 - Retrieve and show the district list stored on the legacy system while the prospect 
        // is filling in the "Company address (registered / correspondence)
        // - District" field on the proposal form
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            Boolean testContent = False;
            String url_extension = '/api/services/mst/LegalTypeList/get';
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
                        msg += key +' == value ==>'+respParserMap.get(key);
                        system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                    }
                    return msg;
                }
            }
            return NULL;
        }
        else{
            return NULL;
        }
    }

    // 5.4       Get the master list of product category
    public static String getMasterProductCategoryList(){
        // 1) Item 11 - Retrieve and show the district list stored on the legacy system while the prospect 
        // is filling in the "Company address (registered / correspondence)
        // - District" field on the proposal form
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            Boolean testContent = False;
            String url_extension = '/api/services/mst/PrdList/get';
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
                        msg += key +' == value ==>'+respParserMap.get(key);
                        system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                    }
                    return msg;
                }
            }
            return NULL;
        }
        else{
            return NULL;
        }
    }

    // 5.5       Get the master list of terminate reject reason
    public static String getMasterTerminationList(){
        // 1) Item 11 - Retrieve and show the district list stored on the legacy system while the prospect 
        // is filling in the "Company address (registered / correspondence)
        // - District" field on the proposal form
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            Boolean testContent = False;
            String url_extension = '/api/services/mst/RjTermReasonList/get';
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
                        msg += key +' == value ==>'+respParserMap.get(key);
                        system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                    }
                    return msg;
                }
            }
            return NULL;
        }
        else{
            return NULL;
        }
    }

    // 5.6      Get the master list of currency
    public static String getMasterCurrencyList(){
        // 1) Item 11 - Retrieve and show the district list stored on the legacy system while the prospect 
        // is filling in the "Company address (registered / correspondence)
        // - District" field on the proposal form
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            Boolean testContent = False;
            String url_extension = '/api/services/mst/CcyList/get';
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
                        msg += key +' == value ==>'+respParserMap.get(key);
                        system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                    }
                    return msg;
                }
            }
            return NULL;
        }
        else{
            return NULL;
        }
    }

    // 5.7     Get the master list of payment method
    public static String getMasterPayMethodList(){
        // 1) Item 11 - Retrieve and show the district list stored on the legacy system while the prospect 
        // is filling in the "Company address (registered / correspondence)
        // - District" field on the proposal form
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            Boolean testContent = False;
            String url_extension = '/api/services/mst/PaymentMethodList/get';
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
                        msg += key +' == value ==>'+respParserMap.get(key);
                        system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                    }
                    return msg;
                }
            }
            return NULL;
        }
        else{
            return NULL;
        }
    }

    // 5.8     Get the master list of origin country
    public static String getMasterOriginCountryList(){
        // 1) Item 57 - Retrieve and show the state list stored on the legacy system while the prospect is filling in the "Buyer Country", "Country / Market of Shipment (Port
        // of Loading)", "Destination Country / Market", Country / Market of Origin" fields on the credit limit application form.
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            Boolean testContent = False;
            String url_extension = '/api/services/mst/OrgCtryList/get';
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
                        msg +=key +' == value ==>'+respParserMap.get(key);
                        system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                    }
                    return msg;
                }
            }
            return NULL;
        }
        else{
            return NULL;
        }
    }

    // 5.9     Get the master list of destination country
    public static String getMasterDestinCountryList(){
        // 1) Item 57 - Retrieve and show the state list stored on the legacy system while the prospect is filling in the "Buyer Country", "Country / Market of Shipment (Port
        // of Loading)", "Destination Country / Market", Country / Market of Origin" fields on the credit limit application form.
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            Boolean testContent = False;
            String url_extension = '/api/services/mst/DestCtryList/get';
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
                        msg +=key +' == value ==>'+respParserMap.get(key);
                        system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                    }
                    return msg;
                }
            }
            return NULL;
        }
        else{
            return NULL;
        }
    }

    // 5.10     Get the master list of port of loading
    public static String getMasterPortOfLdngList(){
        // 1) Item 57 - Retrieve and show the state list stored on the legacy system while the prospect is filling in the "Buyer Country", "Country / Market of Shipment (Port
        // of Loading)", "Destination Country / Market", Country / Market of Origin" fields on the credit limit application form.
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            Boolean testContent = False;
            String url_extension = '/api/services/mst/PortOfLdgList/get';
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
                        msg +=key +' == value ==>'+respParserMap.get(key);
                        system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                    }
                    return msg;
                }
            }
            return NULL;
        }
        else{
            return NULL;
        }
    }

    // 5.11     Get the master list of user for internal memo
    public static String getMasterInternalMemoList(){
        // 1) Item 57 - Retrieve and show the state list stored on the legacy system while the prospect is filling in the "Buyer Country", "Country / Market of Shipment (Port
        // of Loading)", "Destination Country / Market", Country / Market of Origin" fields on the credit limit application form.
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            Boolean testContent = False;
            String url_extension = '/api/services/mst/UserListIM/get';
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
                        msg +=key +' == value ==>'+respParserMap.get(key);
                        system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                    }
                    return msg;
                }
            }
            return NULL;
        }
        else{
            return NULL;
        }
    }

    // 5.12     Get the master list of buyer country
    public static String getMasterBuyerCountryList(){
        // 1) Item 57 - Retrieve and show the state list stored on the legacy system while the prospect is filling in the "Buyer Country", "Country / Market of Shipment (Port
        // of Loading)", "Destination Country / Market", Country / Market of Origin" fields on the credit limit application form.
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            Boolean testContent = False;
            String url_extension = '/api/services/mst/ByrCtryList/get';
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
                        msg +=key +' == value ==>'+respParserMap.get(key);
                        system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                    }
                    return msg;
                }
            }
            return NULL;
        }
        else{
            return NULL;
        }
    }

    // 5.13     Get the master list of RM reason
    public static String getMasterRMReasonList(){
        
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            Boolean testContent = False;
            String url_extension = '/api/services/mst/RmReasonList/get';
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
                        msg +=key +' == value ==>'+respParserMap.get(key);
                        system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                    }
                    return msg;
                }
            }
            return NULL;
        }
        else{
            return NULL;
        }
    }

    // 5.14     Get the master list of Proposal Refer List
    public static String getMasterProposalReferList(){
        
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            Boolean testContent = False;
            String url_extension = '/api/services/mst/PslReferList/get';
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
                        msg +=key +' == value ==>'+respParserMap.get(key);
                        system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                    }
                    return msg;
                }
            }
            return NULL;
        }
        else{
            return NULL;
        }
    }

    // 5.15     Get the master list of industry
    public static String getMasterIndustryList(){
        //Possible areas to be used:
        // 1) Item 9 - Retrieve and show the product list stored on the legacy system while the prospect is filling in the "Goods / Service" field on the proposal form
        // 2) Item 60 - Send a request to the legacy system for the list of goods involved
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_v1.access_token_success){
            Boolean testContent = False;
            String url_extension = '/api/services/mst/IndList/get';
            String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
            String url_parameters = '';
            jsonObject.put('PCY_TYPE', '51');
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
            return NULL;
        }
        else{
            return NULL;
        }
    }

}