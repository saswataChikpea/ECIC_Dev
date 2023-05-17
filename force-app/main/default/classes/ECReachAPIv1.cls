/*---------------------------------------------------------
    Desc :  class for accepting the request from legacy system and reply them.
    created by : sayantan@chikpea.com
    created date : 01-Jul-2021

     Apex REST Annotations
        Use these annotations to expose an Apex class as a RESTful Web service.
        @ReadOnly
        @RestResource(urlMapping='/yourUrl')
        @HttpDelete
        @HttpGet
        @HttpPatch
        @HttpPost
        @HttpPut


    These are some considerations when using this annotation:
    The URL mapping is relative to https://instance.salesforce.com/services/apexrest/.
    A wildcard character (*) may be used.
    The URL mapping is case-sensitive. 
    A URL mapping for my_url will only match a REST resource containing my_url and not My_Url.
    To use this annotation, your Apex class must be defined as global.
    URL Guidelines
    URL path mappings are as follows:

    The path must begin with a '/'
    If an '*' appears, it must be preceded by '/' and followed by '/', unless the '*' is the 
    last character, in which case it need not be followed by '/'
    The rules for mapping URLs are:

    An exact match always wins.
    If no exact match is found, find all the patterns with wildcards that match, and then 
    select the longest (by string length) of those.
    If no wildcard match is found, an HTTP response status code 404 is returned.
    The URL for a namespaced classes contains the namespace. For example, if your class is in 
    namespace abc and the class is mapped to your_url, then the API URL is modified as follows: 
    https://instance.salesforce.com/services/apexrest/abc/your_url/. 
    In the case of a URL collision, the namespaced class is always used.
-----------------------------------------------------------*/
@RestResource(urlMapping='/ecreachapi')
global with sharing class ECReachAPIv1 {

    @HttpPost
    global static void postMethodResponse() {
        Boolean isException = false;
        RestRequest req = RestContext.request;
        System.debug('req ====>'+req);
        RestResponse res = RestContext.response;
        System.debug('intial resp ====>'+res);
        Map<String, String> reqheaders = req.headers;
        String reqrestMethod = req.httpMethod;
        Map<String, String> reqParameters = req.params;
        String reqremoteAddress = req.remoteAddress;
        Blob reqBodyBlob = req.requestBody;
        // String reqBodyb64URLEncoded = CustomBase64EnCodeDecodeClass.base64URLencode(reqBodyBlob);
        String reqBodyb64URLEncoded = reqBodyBlob.toString();
        String requestURI = req.requestURI;
        String reqresourcePath = req.resourcePath;
        System.debug('reqheaders ====>'+reqheaders);
        System.debug('reqrestMethod ====>'+reqrestMethod);
        System.debug('reqParameters ====>'+reqParameters);
        System.debug('reqremoteAddress ====>'+reqremoteAddress);
        System.debug('reqBodyBlob ====>'+reqBodyBlob);
        System.debug('reqBodyb64URLEncoded ====>'+reqBodyb64URLEncoded);
        String api_name;
        String api_version;
        String api_operation;
        String api_metadata;
        String basic_resp_str;
        Map<String, Object> return_map = new Map<String, Object>();
        // String respstr = resp.getBody();
        
        list<String> splitResp = reqBodyb64URLEncoded.split('\\.');
        System.debug('splitResp ====>'+splitResp.size());
        Integer i = 0;
        // Blob key = Crypto.generateAesKey(256); 

        Map<String, String> respParserMap = new Map<String, String>() ;
        try{
            if(reqParameters != NULL && reqParameters.get('client')=='postman'){
                respParserMap.put('ciphertext', reqBodyb64URLEncoded);  // EncodingUtil.base64Decode(splitResp[0]).toString()
            }
            else{
                respParserMap = ResponseParserClass.responseParseMethod(splitResp);
            }
            for (String key1 : respParserMap.keyset()){
                system.debug('key1 ---->'+key1);
                system.debug('value ====>'+respParserMap.get(key1));
                if(key1 == 'ciphertext'){
                    Map<String, Object> tokenmap = (Map<String, Object>)JSON.deserializeUntyped(respParserMap.get(key1));
                    api_name = String.valueOf(tokenmap.get('api'));
                    api_version = String.valueOf(tokenmap.get('ver'));
                    api_operation = String.valueOf(tokenmap.get('op'));
                    api_metadata = String.valueOf(tokenmap.get('meta_data'));
                }
            }
        }
        catch(Exception e){
            /*
            System.debug('Exception e ====>'+e.getMessage()+'==> line number ==>'+e.getLineNumber()+
                '==> stack trace ==>'+e.getStackTraceString());
            basic_resp_str = (basic_resp_str!= NULL && basic_resp_str != ''?basic_resp_str+
                ', request body is null':'request body is null' ) ;*/
            isException = true;
            return_map.put('rtn_code', -1);
            return_map.put('rtn_msgs', 'Error: '+e.getMessage());
            return_map.put('meta_data', new Map<String,Object>{
                'cause' => e.getCause()?.getMessage(),
                'type' => e.getTypeName(),
                'line' => e.getLineNumber(),
                'message' => e.getMessage(),
                'trace' => e.getStackTraceString()
            });
            //System.debug('return_map='+return_map);
        }

        //String api_name='policy_management';
        // add a switch case here.
        if (!isException) {
            try{
                switch on api_name{
                    when 'policy_management'{
                        System.debug('policy_management api call ====>');
                        System.System.debug('api_metadata ===>'+api_metadata);
                        if(api_operation == 'c')
                            basic_resp_str = 'Policy successfully created =>'+api_metadata;
                        else if(api_operation == 'r')
                            basic_resp_str = 'Policy successfully returned =>'+api_metadata;
                        else if(api_operation == 'u')
                            basic_resp_str = 'Policy successfully updated =>'+api_metadata;
                        else if(api_operation == 'd')
                            basic_resp_str = 'Policy successfully deleted =>'+api_metadata;
                    }
                    when 'sme_console'{
                        System.debug('sme_console api call ====>');
                        System.System.debug('api_metadata ===>'+api_metadata);
                        if(api_operation == 'c')
                            basic_resp_str = 'sme console created =>'+api_metadata;
                        else if(api_operation == 'r')
                            basic_resp_str = 'sme console returned =>'+api_metadata;
                        else if(api_operation == 'u'){
                            return_map = SME_ConsoleHandler.handler(respParserMap.get('ciphertext'));
                            basic_resp_str = 'sme console updated =>'+api_metadata;
                        }
                        else if(api_operation == 'd')
                            basic_resp_str = 'sme console deleted =>'+api_metadata;
                    }
                    when 'onboarding'{
                        System.debug('onboarding api call ====>');
                        System.System.debug('api_metadata ===>'+api_metadata);
                        if(api_operation == 'c')
                            basic_resp_str = 'onboarding successfully created =>'+api_metadata;
                        else if(api_operation == 'r')
                            basic_resp_str = 'onboarding successfully returned =>'+api_metadata;
                        else if(api_operation == 'u'){
                            basic_resp_str = 'onboarding successfully updated =>'+api_metadata;
                            return_map = Onboarding_API_Handler.handler(respParserMap.get('ciphertext'));
                        }
                        else if(api_operation == 'd')
                            basic_resp_str = 'onboarding successfully deleted =>'+api_metadata;
                    }
                    when 'credit_limit'{
                        System.debug('credit_limit api call ====>');
                        System.System.debug('api_metadata ===>'+api_metadata);
                        if(api_operation == 'c'){
                            return_map = CLApiHandler.handler(respParserMap.get('ciphertext'));
                            basic_resp_str = 'credit limit successfully created =>'+api_metadata;
                        }
                        else if(api_operation == 'r'){
                            basic_resp_str = 'credit limit successfully returned =>'+api_metadata;
                            return_map = CLApiHandler.handler(respParserMap.get('ciphertext'));
                        }
                        else if(api_operation == 'u'){
                            basic_resp_str = 'credit limit successfully updated =>'+api_metadata;
                            return_map = CLApiHandler.handler(respParserMap.get('ciphertext'));
                        }
                        else if(api_operation == 'd'){
                            basic_resp_str = 'credit limit successfully deleted =>'+api_metadata;
                            return_map = CLApiHandler.handler(respParserMap.get('ciphertext'));
                        }                    
                    }
                    when 'risk_management'{
                        System.debug('risk_management api call ====>');
                        System.System.debug('api_metadata ===>'+api_metadata);
                        // if(api_operation == 'c')
                        //     basic_resp_str = 'risk management successfully created =>'+api_metadata;
                        // else if(api_operation == 'r')
                        //     basic_resp_str = 'risk management successfully returned =>'+api_metadata;
                        // else if(api_operation == 'u'){
                        //     return_map = RMAPIHandler.handler(respParserMap.get('ciphertext'));
                        //     basic_resp_str = 'risk management successfully updated =>'+api_metadata;
                        // }
                        // else if(api_operation == 'd')
                        //     basic_resp_str = 'risk management successfully deleted =>'+api_metadata;
                        // return_map = RMAPIHandler.handler(respParserMap.get('ciphertext'));
                        basic_resp_str = 'risk management successfully updated =>'+api_metadata;
                    }
                    when 'Declaration'{
                        System.debug('declaration api call ====>');
                        System.System.debug('api_metadata ===>'+api_metadata);
                        if(api_operation == 'c')
                            basic_resp_str = 'declaration successfully created =>'+api_metadata;
                        else if(api_operation == 'r')
                            basic_resp_str = 'declaration successfully returned =>'+api_metadata;
                        else if(api_operation == 'u')
                            basic_resp_str = 'declaration successfully updated =>'+api_metadata;
                        else if(api_operation == 'd')
                            basic_resp_str = 'declaration successfully deleted =>'+api_metadata;
                    }
                    when else{
                        return_map.put('rtn_code', -1);
                        return_map.put('rtn_msgs', 'Error: API '+api_name+' not found.');
                        return_map.put('meta_data', null);
                    }
                }
            }
            catch(Exception e){
                isException = true;
                return_map.put('rtn_code', -1);
                return_map.put('rtn_msgs', 'Error: '+e.getMessage());
                return_map.put('meta_data', new Map<String,Object>{
                    'cause' => e.getCause()?.getMessage(),
                    'type' => e.getTypeName(),
                    'line' => e.getLineNumber(),
                    'message' => e.getMessage(),
                    'trace' => e.getStackTraceString()
                });
            }
        }
        
        Map<String, Object> response = new Map<String, Object>();
        // Map<String, Object> jsonObject= new Map<String, Object>();
        String encryptedResp;
        // response.put('data', basic_resp_str);
        response.putAll(return_map);
        // response = ECReachAPIv1.generateresponse(jsonObject);    // for testing purpose
        try{
            if(reqParameters != NULL && reqParameters.get('client')=='postman'){
                System.debug('response ====>'+response);
                res.responseBody = Blob.valueOf(JSON.serialize(response));
            }
            else{
                encryptedResp = CustomJWTPayloadGenerator.payloadgen(false, response);
                System.debug('response ====>'+response);
                System.debug('encryptedResp ====>'+encryptedResp);
                res.responseBody = Blob.valueOf(encryptedResp);
            }
        }
        catch(Exception e){
            ExceptionLogger.log(e, 'ECReachAPIv1.class.postMethodResponse.responseBody');
        }
    }
    /*
    global static Map<String, Object> generateresponse (Map<String, Object> jsonObject){
        Map<String, Object> resbody= new Map<String, Object>();
        resbody.put('op','c');  // c = create, r = read, u = update, d = delete
        resbody.put('api','apiname');   // api_name
        resbody.put('ver',string.valueOf(1));   // api_version
        resbody.put('meta_data', NULL); // payload or request body and response body
        if(jsonObject != NULL && jsonObject.size()>0){
            resbody.put('meta_data', JSON.serialize(jsonObject));
        }
        else
            resbody.put('meta_data','no_payload_string');
        return resbody;
    }
    */
}