/*-----------------------------------------------------------
Desc : class for calling out to ecic api and handling responses.
    there are few strings which are currently hard coded for testing purposes only. Please follow the comments.
created by : sayantan@chikpea.com
created date : 20-apr-2021
Modified on  : 17-Jun-2021 for taking json object map as parameter instead json string.
Modifeid on : 2-Aug-2021 for new API given for submit pdf for signning.
Modified on : 13-Aug-2021 for update of ecic settings.
Modified on : 10-Sep-2021 for breaking up the class based on API modules.

-------------------------------------------------------------*/

public with sharing class ECIC_API_v1 {
    // this below key is .pem file. need to store somewhere rather than hardcoded.
    // for testing purpose it is hard coded now.
    // private static final String basic_url = 'https://api-uat.ec-reach.com.hk:9444';// this is  for uat purpose only. need to set in settings
    private static final String request_method = 'POST';
    public static Boolean testMode = False; 
    public static String access_token;
    public static Integer access_token_validity_second;
    public static String token_type;
    public static String encryptionAlgo;
    public static Boolean access_token_success = false;
    public static DateTime access_token_call_time;
    public static ECIC_Settings__c ecic_setting;
    // public static ECIC_Settings__c prod_setting;
    // public ECIC_API_v1() {
    
    // }
    public static String get_ecic_setting( String settingName){
        if(ecic_setting == NULL ){
            if(settingName != NULL && settingName != ''){
                String name = '%' + settingName + '%';
                ecic_setting = [SELECT ID, Name, Access_Token__c, Access_Token_Updated__c, Access_Token_Valid_Upto__c, 
                        ecic_hmac_key__c,ecic_public_key__c, ecic_public_rsa_key__c, ecic_uat_hmac_key__c, ecic_uat_public_key__c, 
                        ecic_uat_public_rsa_key__c, ecic_private_rsa_key__c, ecic_uat_private_rsa_key__c, Intialization_Vector__c, 
                        sf_private_rsa_key__c, sf_public_rsa_key__c, 
                        sf_uat_private_rsa_key__c, sf_uat_public_rsa_key__c, test_mode__c, ECIC_API_Client_ID__c, 
                        ECIC_API_Client_Secret__c, ECIC_API_Password__c, ECIC_API_Username__c, ECIC_UAT_API_Client_ID__c, 
                        ECIC_UAT_API_Client_Secret__c, ECIC_UAT_API_Password__c, ECIC_UAT_API_Username__c  	 
                        FROM ECIC_Settings__c WHERE Name LIKE :name LIMIT 1];
            }
            else {
                ecic_setting = [SELECT ID, Name, Access_Token__c, Access_Token_Updated__c, Access_Token_Valid_Upto__c, 
                        ecic_hmac_key__c,ecic_public_key__c, ecic_public_rsa_key__c, ecic_uat_hmac_key__c, ecic_uat_public_key__c, 
                        ecic_uat_public_rsa_key__c, ecic_private_rsa_key__c, ecic_uat_private_rsa_key__c, Intialization_Vector__c, 
                        sf_private_rsa_key__c, sf_public_rsa_key__c, 
                        sf_uat_private_rsa_key__c, sf_uat_public_rsa_key__c, test_mode__c, ECIC_API_Client_ID__c, 
                        ECIC_API_Client_Secret__c, ECIC_API_Password__c, ECIC_API_Username__c, ECIC_UAT_API_Client_ID__c, 
                        ECIC_UAT_API_Client_Secret__c, ECIC_UAT_API_Password__c, ECIC_UAT_API_Username__c  	 
                        FROM ECIC_Settings__c LIMIT 1]; //WHERE Name Like '%ECIC%' 
            }
            System.debug('ecic_setting.Name ====>'+ecic_setting.Name);
            System.debug('ecic_setting.ECIC_API_Username__c ====>'+ecic_setting.ECIC_API_Username__c);
            // System.debug('ecic_setting.ECIC_API_Password__c ====>'+ecic_setting.ECIC_API_Password__c);
            System.debug('ecic_setting.ECIC_API_Client_ID__c ====>'+ecic_setting.ECIC_API_Client_ID__c);
            // System.debug('ecic_setting.ECIC_API_Client_Secret__c ====>'+ecic_setting.ECIC_API_Client_Secret__c);
            return ecic_setting.Name;
        }
        return NULL;
    }


 /*    public static String get_country_code(String cname){
        Country__mdt ccode = Country__mdt.getInstance(cname);
        System.debug('countery code ====>'+ccode);
        return ccode.Country_Code__c;
    }
    */

    public static String get_access_token(){
        // method for getting the access token.
        // currently the user name and password is hard coded here. need a setting where we can store them in encrypted method.
        String url_extension = '/api/services/oauth2/token';
        String url_parameters = '?';
        String username;
        String password;
        String client_id;
        String client_secret;
        // currently hard coded for testing purpose. please update.
        if(ecic_setting == NULL){
            ECIC_API_v1.get_ecic_setting(NULL);
        }
        if(ecic_setting != NULL && ecic_setting.test_mode__c){
            username = ecic_setting.ECIC_UAT_API_Username__c;
            password = ecic_setting.ECIC_UAT_API_Password__c;
            client_id = ecic_setting.ECIC_UAT_API_Client_ID__c;
            client_secret = ecic_setting.ECIC_UAT_API_Client_Secret__c;
        }
        else if(ecic_setting != NULL && !ecic_setting.test_mode__c){
            username = ecic_setting.ECIC_API_Username__c;
            password = ecic_setting.ECIC_API_Password__c;
            client_id = ecic_setting.ECIC_API_Client_ID__c;
            client_secret = ecic_setting.ECIC_API_Client_Secret__c;
        }
        System.debug('username ====>'+username);
        System.debug('client_id ====>' +client_id);
        url_parameters+='username='+username+'&password='+password+'&client_id='+client_id+'&client_secret='+client_secret;
        try{
            HTTPResponse resp = SendHTTPRequestClass.sendRequest(url_extension, url_parameters, NULL, NULL);
            System.debug('get_access_token response='+resp);
            System.debug('get_access_token status code='+resp.getStatusCode());
            if(resp.getStatusCode() == 200){
                system.debug('access token response ===>'+resp.getBody());
                Map<String, String> resp_map = JSON_Parser.json_parsing_method(resp.getBody());
                system.debug('resp_map ============>'+resp_map);
                access_token = resp_map.get('access_token');
                system.debug('access_token ====>'+access_token);
                token_type = resp_map.get('token_type');
                access_token_validity_second = 1800; // it can be taken out from access token string.
                access_token_call_time = DateTime.now();
                access_token_success = true;
                // List<String> split_access_token_list = access_token.split('\\.');
                // Blob key = Crypto.generateAesKey(256);
                // Blob key = EncodingUtil.base64Decode(ecic_public_key_string);
                // system.debug('key ====>'+key);
                // Blob exampleIv= Blob.valueOf('Example of IV123');
                return access_token;
            }
            else {
                access_token_success = false;
                return NULL;
            }
        }
        catch(Exception e){
            system.debug('Exception e ===>'+e.getMessage()+'==>'+e.getLineNumber()+'==>'+e.getStackTraceString());
            return e.getMessage();
        }
        // return NULL;
    }
    
    public static Map<String, String> postContentToECIC(Boolean testContent, Map<String, Object> jsonObject, String url_extension, String url_parameters, String auth_header){  // String jsonString,
        Map<String, String> respParserMap = new Map<String, String>();      
        try{
            String jwtparambody;
            jwtparambody = CustomJWTPayloadGenerator.payloadgen(testContent, jsonObject);   // jsonString
            system.debug('postContentToECIC::jwtparambody token ====>'+jwtparambody);
            
            HTTPResponse resp = SendHTTPRequestClass.sendRequest(url_extension, url_parameters, auth_header, jwtparambody );
            system.debug('postContentToECIC::http response ===>'+resp.getBody());
            //Blob encrypted = resp.getBodyAsBlob();
            if(resp.getStatusCode() == 200){
                String respstr = resp.getBody();
                list<String> splitResp = respstr.split('\\.');
                System.debug('postContentToECIC::splitResp ====>'+splitResp.size());
                Integer i = 0;
                // Blob key = Crypto.generateAesKey(256); 
                respParserMap = ResponseParserClass.responseParseMethod(splitResp);
                for (String key1 : respParserMap.keyset()){
                    system.debug('key1 ---->'+key1);
                    system.debug('value ====>'+respParserMap.get(key1));
                }
            }
            else{
                // need a batchlog record creation here
                String calloutexception = 'Exception occured ====>'+' status code ==>'+resp.getStatusCode() +
                '==> response status ==>'+resp.getStatus() +'==> response body ==>'+resp.getBody();
                system.debug('postContentToECIC::Call out exception ===>'+calloutexception);
                respParserMap.put('call_out_exception', calloutexception);
            }
            return respParserMap;
        }
        catch(Exception e){
            String excepmsg = 'Exception e ===>'+e.getMessage()+'==>'+e.getLineNumber()+'==>'+e.getStackTraceString();
            system.debug('postContentToECIC::Exception ====>'+excepmsg);
            respParserMap.put('Exception', excepmsg);
            return respParserMap;
        }
        // return respParserMap;
    }
    public static Map<String, String> postBatchContentToECIC(List<Map<String, Object>> jsonObjects, String url_extension, String url_parameters, String auth_header){  // String jsonString,
        Map<String, String> respParserMap = new Map<String, String>();      
        try{
            String jwtparambody;
            jwtparambody = CustomJWTPayloadGenerator.batchPayloadgen(jsonObjects);   // jsonString
            system.debug('postContentToECIC::jwtparambody token ====>'+jwtparambody);
            
            HTTPResponse resp = SendHTTPRequestClass.sendRequest(url_extension, url_parameters, auth_header, jwtparambody );
            system.debug('postContentToECIC::http response ===>'+resp.getBody());
            //Blob encrypted = resp.getBodyAsBlob();
            if(resp.getStatusCode() == 200){
                String respstr = resp.getBody();
                list<String> splitResp = respstr.split('\\.');
                System.debug('postContentToECIC::splitResp ====>'+splitResp.size());
                Integer i = 0;
                // Blob key = Crypto.generateAesKey(256); 
                respParserMap = ResponseParserClass.responseParseMethod(splitResp);
                for (String key1 : respParserMap.keyset()){
                    system.debug('key1 ---->'+key1);
                    system.debug('value ====>'+respParserMap.get(key1));
                }
            }
            else{
                // need a batchlog record creation here
                String calloutexception = 'Exception occured ====>'+' status code ==>'+resp.getStatusCode() +
                '==> response status ==>'+resp.getStatus() +'==> response body ==>'+resp.getBody();
                system.debug('postContentToECIC::Call out exception ===>'+calloutexception);
                respParserMap.put('call_out_exception', calloutexception);
            }
            return respParserMap;
        }
        catch(Exception e){
            String excepmsg = 'Exception e ===>'+e.getMessage()+'==>'+e.getLineNumber()+'==>'+e.getStackTraceString();
            system.debug('postContentToECIC::Exception ====>'+excepmsg);
            respParserMap.put('Exception', excepmsg);
            return respParserMap;
        }
        // return respParserMap;
    }
    
    public static void test_connection(){
        string url_extension = '/api/services/res1/v1/testConnection';
        // String url_extension = '/api/services/res1/v1/testConnectionContent';
        String auth_header = token_type+' '+access_token;
        if (access_token_success){
            try{
                HTTPResponse resp = SendHTTPRequestClass.sendRequest(url_extension, NULL, auth_header, NULL );
                system.debug('testConnection response ===>'+resp.getBody());
                // Blob exampleIv = Blob.valueOf('Example of IV123');
                Blob exampleIv ;
                if(resp.getStatusCode() == 200){
                    String respstr = resp.getBody();
                    list<String> splitResp = respstr.split('\\.');
                    System.debug('splitResp ====>'+splitResp.size());
                    Integer i = 0;
                    // Blob key = Crypto.generateAesKey(256); 
                    // Blob key = EncodingUtil.base64Decode(ecic_public_key_string);
                    Map<String, String> respParserMap = ResponseParserClass.responseParseMethod(splitResp);
                    for (String key1 : respParserMap.keyset()){
                        system.debug('key1 ---->'+key1);
                        system.debug('value ====>'+respParserMap.get(key1));
                    }
                }
                else{
                    // need a batchlog record creation here
                    system.debug('Exception occured ====>'+' status code ==>'+resp.getStatusCode() +
                            '==> response status ==>'+resp.getStatus() +'==> response body ==>'+resp.getBody());
                }
            }
            catch(Exception e){
                system.debug('Exception e ===>'+e.getMessage()+'==>'+e.getLineNumber()+'==>'+e.getStackTraceString());
            }
        }
    }
    public static void test_connection_content(Map<String, Object> jsonObject){     
        // string url_extension = '/api/services/res1/v1/testConnection';       //String jsonString
        String url_extension = '/api/services/res1/v1/testConnectionContent';
        String auth_header = token_type+' '+access_token;
        String url_parameters = '';
        Boolean testContent = true;
        if(access_token_success){
            Map<String, String> respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
            if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('Exception'))
                system.debug('Exception in response ====>'+respParserMap.get('Exception'));
            else if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('ciphertext'))
                system.debug('json response ====>'+respParserMap.get('ciphertext'));
            else{
                if(respParserMap != NULL && respParserMap.size()>0){
                    for(String Key : respParserMap.keyset()){
                        system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                    }
                }
            }
        }
    }

    /* 
    Method for query a document/ file/ attachment  and send it for doc sign api. 
    first need to get the size of the file 
    then need to call the token 
    and then need to send the file for signature.
    method for getting token for doccument signature. 
    Req:
    {
    "meta_data": {
        "DIV_CODE": "CRD",
        "PASSWORD": "ecic1234",
        "FILENAME": "DOC_A.pdf",
        "FILESIZE": "5242880",
        "UID": "1asw23Zxb3"
        }
    }
    Res:
    {
        "rtn_code": "1",
        "rtn_msgs": null,
        "meta_data": {
            "signing_token": "K2tXtSImQG",
            "time_expired": "2021-12-02 17:16:51",
            "retry_sec": null
        }
    }
    */
    //9.1 /api/services/docsign/token Obtain document signing token
    public static Map<String, String> docSignToken(Map<String, Object> jsonObject) {         

        String url_extension = '/api/services/docsign/token';
        String auth_header = token_type+' '+access_token;
        String url_parameters = '';
        Boolean testContent = false;
        if(ECIC_API_V1.access_token_success){
            Map<String, String> respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
            if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('Exception')){
                system.debug('Exception in response ====>'+respParserMap.get('Exception'));
            }
            else if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('ciphertext')){
                system.debug('json response ====>'+respParserMap.get('ciphertext'));
            }
            else{
                if(respParserMap != NULL && respParserMap.size()>0){
                    for(String Key : respParserMap.keyset()){
                        system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                    }
                }
            }
            return respParserMap;
        }
        else{
            Map <String, String> respParserMap = new Map<String, String>();
            respParserMap.put('Exception', 'Access Token call failed.');
            return respParserMap;
        }
        
    } 

    //TODO: Uncomment after Day1 2021/12/08
    /*
    public static void docSign(String fileName, Boolean isDocument){
        // testConnectionAttachment API, for submitting the pdf there is another API
        // if(file.size() == 0 && fileName == NULL){
        //     return ;
        // }
        // // SELECT ID, Name, Body, BodyLength, ContentType, Description, IsPrivate, OwnerId, ParentId FROM Attachment
        // if(isDocument){
        //     // query on te document.
        //     Document d = [SELECT AuthorId, body, bodylength, contenttype, description, developername, folderid, isdeleted, 
        //             isinternaluseonly, ispublic, name, namespaceprefix, type, url 
        //             FROM document limit 1];

        // }
        // else{
        if(true){
            // query on the file
            // contentdocument doc = [SELECT id, Title, SharingOption, PublishStatus, ParentId, OwnerId, LatestPublishedVersionId, IsArchived, 
            //         FileType, FileExtension, Description, ContentSize, ContentModifiedDate, ContentAssetId, ArchivedDate, ArchivedById  
            //         FROM contentdocument WHERE Title = :fileName limit 1];
            List<ContentVersion> cvList = [SELECT ID, ContentDocumentId, ContentLocation, ContentModifiedById, ContentModifiedDate, ContentSize, 
                    ContentUrl, Description,  ExternalDataSourceId, ExternalDocumentInfo1, ExternalDocumentInfo2, FeaturedContentBoost, 
                    FeaturedContentDate, FileExtension, FileType, FirstPublishLocationId, IsAssetEnabled, IsLatest, IsMajorVersion, 
                    NegativeRatingCount, NetworkId, Origin, OwnerId, PathOnClient, PublishStatus, RatingCount, ReasonForChange, 
                    SharingOption, SharingPrivacy, TextPreview, Title, VersionData, VersionNumber 
                    FROM ContentVersion WHERE Title = :fileName and IsLatest = true LIMIT 1];
            if(cvList != NULL && cvList.size()>0){
                System.debug('Content Document size ====>'+cvList[0].ContentSize);
                Map<String, String> contentsizeMap = new Map<String, String>();
                Map<String, String> contentDocMap = new Map<String, String>();
                // Blob blobKey = crypto.generateAesKey(128);
                // String key = EncodingUtil.base64encode(blobKey);
                String uid_id = ECIC_API_v1.generateRandomString(10);// key.substring(0,10);
                String docToken;
                String TIME_EXPIRED;
                DateTime time_of_expire;
                contentsizeMap.put('uid', uid_id);
                contentsizeMap.put('filesize', String.valueOf(cvList[0].ContentSize));
                contentsizeMap.put('div_code', 'BD');
                // The division in which should sign on 
                // this document. Available div_code 
                // are:
                // “BD” – Business Division
                // “UD” – Underwriting Division
                // “CRD” – Claims and Recoveries 
                // Division
                // contentsizeMap.put('password','');   // this field is optional need a settings for that.
                String IVString = 'Example of IV256';
                Blob exampleIv = Blob.valueOf(IVString);
                String b64URLEncodedIV = CustomBase64EnCodeDecodeClass.base64URLencode(exampleIV);
                System.debug('b64URLEncodedIV ====>'+b64URLEncodedIV);
                contentsizeMap.put('iv', b64URLEncodedIV);
                contentsizeMap.put('filename', cvList[0].Title);
                System.debug('document uid ====>'+contentsizeMap.get('uid'));
                System.debug('document filesize ====>'+contentsizeMap.get('filesize'));
                
                if(access_token_success){
                    Map<String, String> respParserMap = ECIC_API_v1.docSignToken(contentsizeMap);
                    String resJson = respParserMap.get('ciphertext');
                    // {"RTN_CODE":"1","RTN_MSGS":{},"META_DATA":{"SIGNING_TOKEN":"QWqsL4CJ40","TIME_EXPIRED":"2021-06-17 21:12:03"}}
                    System.debug('doc sign token json ====>'+resJson);
                    Map<String, Object> tokenmap = (Map<String, Object>)JSON.deserializeUntyped(resJson);
                    System.debug('doc sign tokenmap ====>'+tokenmap); 
                    if(tokenmap.get('RTN_CODE') == '1'){
                        String metadatastr = JSON.serialize(tokenmap.get('META_DATA'));
                        Map<String, Object> metadatamap = (Map<String, Object>)JSON.deserializeUntyped(metadatastr);
                        docToken = String.valueOf(metadatamap.get('SIGNING_TOKEN'));
                        System.debug('doc sign docToken ====>'+docToken); 
                        TIME_EXPIRED =  (String) metadatamap.get('TIME_EXPIRED');
                        time_of_expire = DateTime.valueOf(TIME_EXPIRED);
                        System.debug('doc sign time_of_expire ====>'+time_of_expire); 
                        // String url_extension = '/api/services/docsign/sign';
                        String url_extension = '/api/services/docsign/testConnectionAttachment';
                        String auth_header = token_type+' '+access_token;
                        String url_parameters = '';
                        Boolean testContent = false;
                        // ---------- this below process has changed ---------------------------------
                        // contentDocMap.put('token', docToken);
                        // contentDocMap.put('div_code', 'BD');    // currently it is hardcoded.
                        // The division in which should sign on this document. Available div_code are:
                        // “BD” – Business Division
                        // “UD” – Underwriting Division
                        // “CRD” – Claims and Recoveries Division
                        // contentDocMap.put('password', 'password');   // since this is optional, not including.
                        // contentDocMap.put('filename', cvList[0].Title);
                        // contentDocMap.put('file', EncodingUtil.base64Encode(cvList[0].VersionData));
                        // System.debug('before doc sign callout ====>'+contentDocMap);
                        // ----------------------------------------------------------------------------
                        Map<String, String> headersmap = new Map<String, String>();
                        headersmap.put('Authorization', auth_header);
                        headersmap.put('Content-Type', 'application/pdf');
                        headersmap.put('sign_token', docToken);
                        Blob reqBlobBody = cvList[0].VersionData;
                        if(cvList[0].ContentSize <5000000){
                            HTTPResponse resp = SendHTTPRequestClass.sendBlobRequest(url_extension, url_parameters, headersmap, reqBlobBody );
                            System.debug('resp ====>'+resp);
                            System.debug('resp body ====>'+resp.getBody());
                        }
                        else{
                            ECIC_API_v1.docSignFutureMethod(auth_header, fileName, docToken, isDocument);
                        }
                        
                        // Map<String, String> respParserMap1 = ECIC_API_v1.postContentToECIC(testContent, contentDocMap, url_extension, url_parameters, auth_header);
                        // if(respParserMap1 != NULL && respParserMap1.size()>0 && respParserMap1.containsKey('Exception')){
                        //     system.debug('Exception in response ====>'+respParserMap1.get('Exception'));
                        // }
                        // else if(respParserMap1 != NULL && respParserMap1.size()>0 && respParserMap1.containsKey('ciphertext')){
                        //     system.debug('json response ====>'+respParserMap1.get('ciphertext'));
                        // }
                        // else{
                        //     if(respParserMap1 != NULL && respParserMap1.size()>0){
                        //         for(String Key2 : respParserMap1.keyset()){
                        //             system.debug('response key =====>'+key2 +' == value ==>'+respParserMap1.get(key2));
                        //         }
                        //     }
                        // }
                    }  
                }
                else{
                    Map <String, String> respParserMap = new Map<String, String>();
                    respParserMap.put('Exception', 'Access Token call is not success');
                    // return respParserMap;
                }
            }
        }
    }
    */

    
    /**
     * // 9.2 
     * Submit pdf document for signing
     */
    public static void submitDocForSign(String recordId,String fileName, String divCode, String password){

        Boolean testMode = ECIC_API_v1.ecic_setting?.test_mode__c;

        List<ContentVersion> cvList = [SELECT ID, ContentDocumentId, ContentLocation, ContentModifiedById, ContentModifiedDate, ContentSize, 
                ContentUrl, Description,  ExternalDataSourceId, ExternalDocumentInfo1, ExternalDocumentInfo2, FeaturedContentBoost, 
                FeaturedContentDate, FileExtension, FileType, FirstPublishLocationId, IsAssetEnabled, IsLatest, IsMajorVersion, 
                NegativeRatingCount, NetworkId, Origin, OwnerId, PathOnClient, PublishStatus, RatingCount, ReasonForChange, 
                SharingOption, SharingPrivacy, TextPreview, Title, VersionData, VersionNumber 
                FROM ContentVersion WHERE Title = :fileName and IsLatest = true LIMIT 1];
        if(cvList != NULL && cvList.size()>0){
            System.debug('Content Document size ====>'+cvList[0].ContentSize);
            Map<String, String> contentsizeMap = new Map<String, String>();
            Map<String, String> contentDocMap = new Map<String, String>();

            String uid_id = ECIC_API_v1.generateRandomString(10);
            String docToken;
            String TIME_EXPIRED;
            String fileNameFull = cvList[0].Title + '.' + cvList[0].FileExtension;
            DateTime time_of_expire;
            contentsizeMap.put('UID', uid_id);
            contentsizeMap.put('FILESIZE', String.valueOf(cvList[0].ContentSize));
            contentsizeMap.put('FILENAME', fileNameFull);
            if (String.isNotBlank(password))
                contentsizeMap.put('PASSWORD', password); // Optional, For signed document
            contentsizeMap.put('DIV_CODE', divCode); //“BD”-Business Division, “UD”–Underwriting Division, “CRD” – Claims and Recoveries 
            System.debug('submitDocForSign::contentsizeMap ====>'+contentsizeMap);
            
            if(ECIC_API_v1.access_token_success){
                if (Test.isRunningTest()) {
                    String resp_body = 'eyJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwiYWxnIjoiZGlyIn0..8Sp-y2wYwrfSI8V5WBj7ag.zMvCNBuVLp8MZ0zCDcQDBgHtzew7jsQWI-h4EGwjhFTUR9BS9LHhcSS7vyCtB2beDepmfZ2CxnO6lVfU_weY4FlHIU7M1I_96xoO2AOEXC9kEjSOsBr_hsJJxPWqfozEvUCc0mE7ktyDjUwK-b5hv_cDyRxOaknv_L0enHVlOXcm8jRHyXTnS7p3ak0w8krT_m_8jRvA45or49dn4hnQfVKucux6Uvy9HwDxD9aniWSaEwXt6w2vY3Wbsv3iWz3CYt1r4BJgGJXpr20R9bF5KqqeWMMG-95HpQbfz7olPKx3gvJsveWXYLmW5UbzWZfnW62YC68ArDzsDlRaaB8uhrUvq1EfcnTUfPqLwMaMiqrQG1FwGvILFQgoXHjv5mEQJkv8I6qqyjUVd9ozMIfgMiSpL3T1afWzmSMKXgUQksrLuQr3_rO18xFQFrAIEQEqNiJ8SfWAudxg8ZTnvL7DGpGjGSM3qdzbdlke8gTz-0twnF9auuahd0fs7xlLVRbi1RlTV-xZKD8PSI7X-1T54tATfEYaaEsmjAr3EY6IoqNN3vdQNflNYA0ahMDDZVTHeq6TOJERqULRyv8l51hBmi8dbeIAMYIx33_lxcjruhDhji9ndi7EtJvYqkjzkRNavPWruULZHzbZT1SWtCcdI5kcYsIQ0TJQZry_kpW5bBtmkpizUwvEaiB-RURhk3e1MgSiUf3o81vvJzeALhKcpw.6WWzlUDf_x148A3eMrm8wBZQAvjLE5q0Fez2DOP3lqE';
                    TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
                    Test.setMock(HttpCalloutMock.class, httpmock);
                } 
                Map<String, String> respParserMap = ECIC_API_v1.docSignToken(contentsizeMap);
                String resJson = respParserMap.get('ciphertext');
                // {"rtn_code":"1","rtn_msgs":null,"meta_data":{"signing_token":"Cc4BHqbKAc","time_expired":"2021-12-02 17:31:33","retry_sec":null}}
                System.debug('submitDocForSign::doc sign token json ====>'+resJson);
                Map<String, Object> tokenmap = (Map<String, Object>)JSON.deserializeUntyped(resJson);
                System.debug('submitDocForSign::doc sign tokenmap ====>'+tokenmap); 
                if(tokenmap.get('rtn_code') == '1'){
                    String metadatastr = JSON.serialize(tokenmap.get('meta_data'));
                    Map<String, Object> metadatamap = (Map<String, Object>)JSON.deserializeUntyped(metadatastr);
                    docToken = String.valueOf(metadatamap.get('signing_token'));
                    //System.debug('doc sign docToken ====>'+docToken); 
                    TIME_EXPIRED =  (String) metadatamap.get('time_expired');
                    time_of_expire = DateTime.valueOf(TIME_EXPIRED);
                    //System.debug('doc sign time_of_expire ====>'+time_of_expire); 
                    String url_extension = '/api/services/docsign/sign';
                    String auth_header = token_type+' '+access_token;
                    String url_parameters = '';
                    
                    Map<String, String> headersmap = new Map<String, String>();
                    headersmap.put('Authorization', auth_header);
                    headersmap.put('Content-Type', 'application/pdf');
                    //headersmap.put('Connection', 'keep-alive');
                    headersmap.put('SIGNING_TOKEN', docToken);
                    Blob reqBlobBody = cvList[0].VersionData;
                    if(cvList[0].ContentSize <5000000){
                        if (Test.isRunningTest()) {
                            TestHTTPBlobMockFactory httblobpmock = new TestHTTPBlobMockFactory(200, 'OK', Blob.toPdf('PDF Content.'), new Map<String,String>());
                            Test.setMock(HttpCalloutMock.class, httblobpmock);                            
                        }
                        HTTPResponse resp = SendHTTPRequestClass.sendBlobRequest(testMode, url_extension, url_parameters, headersmap, reqBlobBody );
                        System.debug('resp ====>'+resp);
                        Blob respBlobBody = resp?.getBodyAsBlob();
                        //System.debug('resp body ====>'+resp.getBodyAsBlob());

                        ContentVersion cv = new ContentVersion();
                        cv.Title= fileName + '_signed';
                        cv.PathOnClient = fileName + '_signed' + '.' + cvList[0].FileExtension;
                        cv.VersionData = respBlobBody;
                        cv.origin = 'C';

                        insert cv;
                        System.debug('ContentVersion inserted successfully id:'+cv.Id);
                        
                    }else{
                        ECIC_API_v1.submitDocForSignFutureMethod(auth_header, fileName, docToken, testMode, recordId);
                    }
                }  
            }
            else{
                Map <String, String> respParserMap = new Map<String, String>();
                respParserMap.put('Exception', 'Access Token call is not success');
            }
        }
    }

    // future method for submitting the pdf document.
    @future(callout=true)
    public static void submitDocForSignFutureMethod(String auth_header, String fileName, String doctoken, Boolean testMode, String recordId){

        List<ContentVersion> cvList = [SELECT ID, ContentDocumentId, ContentLocation, ContentModifiedById, ContentModifiedDate, ContentSize, 
                        ContentUrl, Description,  ExternalDataSourceId, ExternalDocumentInfo1, ExternalDocumentInfo2, FeaturedContentBoost, 
                        FeaturedContentDate, FileExtension, FileType, FirstPublishLocationId, IsAssetEnabled, IsLatest, IsMajorVersion, 
                        NegativeRatingCount, NetworkId, Origin, OwnerId, PathOnClient, PublishStatus, RatingCount, ReasonForChange, 
                        SharingOption, SharingPrivacy, TextPreview, Title, VersionData, VersionNumber 
                        FROM ContentVersion WHERE Title = :fileName and IsLatest = true LIMIT 1];
        if(cvList != NULL && cvList.size()>0){
            System.debug('Content Document size ====>'+cvList[0].ContentSize);
            Map<String, String> headersmap = new Map<String, String>();
            headersmap.put('Authorization', auth_header);
            headersmap.put('Content-Type', 'application/pdf');
            headersmap.put('SIGNING_TOKEN', docToken);
            Blob reqBlobBody = cvList[0].VersionData;
            String url_extension = '/api/services/docsign/sign';
            String url_parameters = '';
            HTTPResponse resp = SendHTTPRequestClass.sendBlobRequest(testMode, url_extension, url_parameters, headersmap, reqBlobBody );
            system.debug('submitDocForSignFutureMethod::response ====>'+resp.getBody());
            // Save document
            ContentVersion cv = new ContentVersion();
            cv.Title= fileName + '_signed';
            cv.PathOnClient = fileName + '_signed' + '.' + cvList[0].FileExtension;
            cv.VersionData = resp.getBodyAsBlob();
            cv.origin = 'C';

            insert cv;
            System.debug('ContentVersion inserted successfully id:'+cv.Id);
            
        }
    }   
    
    //Added By Satya for Policy Document Signing
    public static void submitPolicyDocForSign(String recordId,String fileName, String divCode, String password){

        Boolean testMode = ECIC_API_v1.ecic_setting?.test_mode__c;

        List<ContentVersion> cvList = [SELECT ID, ContentDocumentId, ContentLocation, ContentModifiedById, ContentModifiedDate, ContentSize, 
                ContentUrl, Description,  ExternalDataSourceId, ExternalDocumentInfo1, ExternalDocumentInfo2, FeaturedContentBoost, 
                FeaturedContentDate, FileExtension, FileType, FirstPublishLocationId, IsAssetEnabled, IsLatest, IsMajorVersion, 
                NegativeRatingCount, NetworkId, Origin, OwnerId, PathOnClient, PublishStatus, RatingCount, ReasonForChange, 
                SharingOption, SharingPrivacy, TextPreview, Title, VersionData, VersionNumber 
                FROM ContentVersion WHERE Title = :fileName and IsLatest = true LIMIT 1];
        if(cvList != NULL && cvList.size()>0){
            System.debug('Content Document size ====>'+cvList[0].ContentSize);
            Map<String, String> contentsizeMap = new Map<String, String>();
            Map<String, String> contentDocMap = new Map<String, String>();

            String uid_id = ECIC_API_v1.generateRandomString(10);
            String docToken;
            String TIME_EXPIRED;
            String fileNameFull = cvList[0].Title + '.' + cvList[0].FileExtension;
            DateTime time_of_expire;
            contentsizeMap.put('UID', uid_id);
            contentsizeMap.put('FILESIZE', String.valueOf(cvList[0].ContentSize));
            contentsizeMap.put('FILENAME', fileNameFull);
            if (String.isNotBlank(password))
                contentsizeMap.put('PASSWORD', password); // Optional, For signed document
            contentsizeMap.put('DIV_CODE', divCode); //“BD”-Business Division, “UD”–Underwriting Division, “CRD” – Claims and Recoveries 
            System.debug('submitDocForSign::contentsizeMap ====>'+contentsizeMap);
            
            if(ECIC_API_v1.access_token_success){
                if (Test.isRunningTest()) {
                    String resp_body = 'eyJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwiYWxnIjoiZGlyIn0..8Sp-y2wYwrfSI8V5WBj7ag.zMvCNBuVLp8MZ0zCDcQDBgHtzew7jsQWI-h4EGwjhFTUR9BS9LHhcSS7vyCtB2beDepmfZ2CxnO6lVfU_weY4FlHIU7M1I_96xoO2AOEXC9kEjSOsBr_hsJJxPWqfozEvUCc0mE7ktyDjUwK-b5hv_cDyRxOaknv_L0enHVlOXcm8jRHyXTnS7p3ak0w8krT_m_8jRvA45or49dn4hnQfVKucux6Uvy9HwDxD9aniWSaEwXt6w2vY3Wbsv3iWz3CYt1r4BJgGJXpr20R9bF5KqqeWMMG-95HpQbfz7olPKx3gvJsveWXYLmW5UbzWZfnW62YC68ArDzsDlRaaB8uhrUvq1EfcnTUfPqLwMaMiqrQG1FwGvILFQgoXHjv5mEQJkv8I6qqyjUVd9ozMIfgMiSpL3T1afWzmSMKXgUQksrLuQr3_rO18xFQFrAIEQEqNiJ8SfWAudxg8ZTnvL7DGpGjGSM3qdzbdlke8gTz-0twnF9auuahd0fs7xlLVRbi1RlTV-xZKD8PSI7X-1T54tATfEYaaEsmjAr3EY6IoqNN3vdQNflNYA0ahMDDZVTHeq6TOJERqULRyv8l51hBmi8dbeIAMYIx33_lxcjruhDhji9ndi7EtJvYqkjzkRNavPWruULZHzbZT1SWtCcdI5kcYsIQ0TJQZry_kpW5bBtmkpizUwvEaiB-RURhk3e1MgSiUf3o81vvJzeALhKcpw.6WWzlUDf_x148A3eMrm8wBZQAvjLE5q0Fez2DOP3lqE';
                    TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
                    Test.setMock(HttpCalloutMock.class, httpmock);
                } 
                Map<String, String> respParserMap = ECIC_API_v1.docSignToken(contentsizeMap);
                String resJson = respParserMap.get('ciphertext');
                // {"rtn_code":"1","rtn_msgs":null,"meta_data":{"signing_token":"Cc4BHqbKAc","time_expired":"2021-12-02 17:31:33","retry_sec":null}}
                System.debug('submitDocForSign::doc sign token json ====>'+resJson);
                Map<String, Object> tokenmap = (Map<String, Object>)JSON.deserializeUntyped(resJson);
                System.debug('submitDocForSign::doc sign tokenmap ====>'+tokenmap); 
                if(tokenmap.get('rtn_code') == '1'){
                    String metadatastr = JSON.serialize(tokenmap.get('meta_data'));
                    Map<String, Object> metadatamap = (Map<String, Object>)JSON.deserializeUntyped(metadatastr);
                    docToken = String.valueOf(metadatamap.get('signing_token'));
                    //System.debug('doc sign docToken ====>'+docToken); 
                    TIME_EXPIRED =  (String) metadatamap.get('time_expired');
                    time_of_expire = DateTime.valueOf(TIME_EXPIRED);
                    //System.debug('doc sign time_of_expire ====>'+time_of_expire); 
                    String url_extension = '/api/services/docsign/sign';
                    String auth_header = token_type+' '+access_token;
                    String url_parameters = '';
                    
                    Map<String, String> headersmap = new Map<String, String>();
                    headersmap.put('Authorization', auth_header);
                    headersmap.put('Content-Type', 'application/pdf');
                    //headersmap.put('Connection', 'keep-alive');
                    headersmap.put('SIGNING_TOKEN', docToken);
                    Blob reqBlobBody = cvList[0].VersionData;
                    if(cvList[0].ContentSize <5000000){
                        if (Test.isRunningTest()) {
                            TestHTTPBlobMockFactory httblobpmock = new TestHTTPBlobMockFactory(200, 'OK', Blob.toPdf('PDF Content.'), new Map<String,String>());
                            Test.setMock(HttpCalloutMock.class, httblobpmock);                            
                        }
                        HTTPResponse resp = SendHTTPRequestClass.sendBlobRequest(testMode, url_extension, url_parameters, headersmap, reqBlobBody );
                        System.debug('resp ====>'+resp);
                        Blob respBlobBody = resp?.getBodyAsBlob();
                        //System.debug('resp body ====>'+resp.getBodyAsBlob());

                        ContentVersion cv = new ContentVersion();
                        cv.Title= fileName + '_signed';
                        cv.PathOnClient = fileName + '_signed' + '.' + cvList[0].FileExtension;
                        cv.VersionData = respBlobBody;
                        cv.origin = 'C';

                        insert cv;
                        System.debug('ECIC ContentVersion inserted successfully id:'+cv.Id);
                        //added by satya
                        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
                        System.debug('conDocId==>>'+conDocId);
                        //Create ContentDocumentLink 
                        ContentDocumentLink cdlSchedule = new ContentDocumentLink();
                        cdlSchedule.LinkedEntityId = recordId;
                        cdlSchedule.ContentDocumentId = conDocId;
                        cdlSchedule.shareType = 'V';
                        Insert cdlSchedule;
                        System.debug('ECIC ContentDocumentLink inserted successfully');
                        List<Policy_Schedule__c> pSchList = new List<Policy_Schedule__c>();
                        for(Policy_Schedule__c pschedule :  [select id,name,Is_Schedule_Signed__c from Policy_Schedule__c where id =:recordId]){
                            pschedule.Is_Schedule_Signed__c=true;
                            pSchList.add(pschedule);
                        }
                        if(pSchList!=null && !pSchList.isEmpty()){
                            update pSchList;
                            System.debug('updated policy schedule successfully!!!.');
                        }
                    }else{
                        ECIC_API_v1.submitPolicyDocForSignFutureMethod(auth_header, fileName, docToken, testMode, recordId);
                    }
                }  
            }
            else{
                Map <String, String> respParserMap = new Map<String, String>();
                respParserMap.put('Exception', 'Access Token call is not success');
            }
        }
    }
    

    @future(callout=true)
    public static void submitPolicyDocForSignFutureMethod(String auth_header, String fileName, String doctoken, Boolean testMode, String recordId){
        System.debug('submitPolicyDocForSignFutureMethod called.');
        List<ContentVersion> cvList = [SELECT ID, ContentDocumentId, ContentLocation, ContentModifiedById, ContentModifiedDate, ContentSize, 
                        ContentUrl, Description,  ExternalDataSourceId, ExternalDocumentInfo1, ExternalDocumentInfo2, FeaturedContentBoost, 
                        FeaturedContentDate, FileExtension, FileType, FirstPublishLocationId, IsAssetEnabled, IsLatest, IsMajorVersion, 
                        NegativeRatingCount, NetworkId, Origin, OwnerId, PathOnClient, PublishStatus, RatingCount, ReasonForChange, 
                        SharingOption, SharingPrivacy, TextPreview, Title, VersionData, VersionNumber 
                        FROM ContentVersion WHERE Title = :fileName and IsLatest = true LIMIT 1];
        if(cvList != NULL && cvList.size()>0){
            System.debug('Content Document size ====>'+cvList[0].ContentSize);
            Map<String, String> headersmap = new Map<String, String>();
            headersmap.put('Authorization', auth_header);
            headersmap.put('Content-Type', 'application/pdf');
            headersmap.put('SIGNING_TOKEN', docToken);
            Blob reqBlobBody = cvList[0].VersionData;
            String url_extension = '/api/services/docsign/sign';
            String url_parameters = '';
            HTTPResponse resp = SendHTTPRequestClass.sendBlobRequest(testMode, url_extension, url_parameters, headersmap, reqBlobBody );
            system.debug('submitDocForSignFutureMethod::response ====>'+resp.getBody());
            // Save document
            ContentVersion cv = new ContentVersion();
            cv.Title= fileName + '_signed';
            cv.PathOnClient = fileName + '_signed' + '.' + cvList[0].FileExtension;
            cv.VersionData = resp.getBodyAsBlob();
            cv.origin = 'C';

            insert cv;
            System.debug('ContentVersion inserted successfully id:'+cv.Id);

            System.debug('ECIC ContentVersion inserted successfully id:'+cv.Id);
            //added by satya
            Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
            System.debug('conDocId==>>'+conDocId);
            //Create ContentDocumentLink 
            ContentDocumentLink cdlSchedule = new ContentDocumentLink();
            cdlSchedule.LinkedEntityId = recordId;
            cdlSchedule.ContentDocumentId = conDocId;
            cdlSchedule.shareType = 'V';
            Insert cdlSchedule;
            System.debug('ECIC ContentDocumentLink inserted successfully');
            List<Policy_Schedule__c> pSchList = new List<Policy_Schedule__c>();
            for(Policy_Schedule__c pschedule :  [select id,name,Is_Schedule_Signed__c from Policy_Schedule__c where id =:recordId]){
                pschedule.Is_Schedule_Signed__c=true;
                pSchList.add(pschedule);
            }
            if(pSchList!=null && !pSchList.isEmpty()){
                update pSchList;
                System.debug('updated policy schedule successfully!!!.');
            }
            
        }
    }  
    //End here
    // added by Pratik to sign cl document
    public static void submitCLDocForSign(String recordId,String fileName, String divCode, String password){

        Boolean testMode = ECIC_API_v1.ecic_setting?.test_mode__c;

        List<ContentVersion> cvList = [SELECT ID, ContentDocumentId, ContentLocation, ContentModifiedById, ContentModifiedDate, ContentSize, 
                ContentUrl, Description,  ExternalDataSourceId, ExternalDocumentInfo1, ExternalDocumentInfo2, FeaturedContentBoost, 
                FeaturedContentDate, FileExtension, FileType, FirstPublishLocationId, IsAssetEnabled, IsLatest, IsMajorVersion, 
                NegativeRatingCount, NetworkId, Origin, OwnerId, PathOnClient, PublishStatus, RatingCount, ReasonForChange, 
                SharingOption, SharingPrivacy, TextPreview, Title, VersionData, VersionNumber 
                FROM ContentVersion WHERE Title = :fileName and IsLatest = true LIMIT 1];
        if(cvList != NULL && cvList.size()>0){
            System.debug('Content Document size ====>'+cvList[0].ContentSize);
            Map<String, String> contentsizeMap = new Map<String, String>();
            Map<String, String> contentDocMap = new Map<String, String>();

            String uid_id = ECIC_API_v1.generateRandomString(10);
            String docToken;
            String TIME_EXPIRED;
            String fileNameFull = cvList[0].Title + '.' + cvList[0].FileExtension;
            DateTime time_of_expire;
            contentsizeMap.put('UID', uid_id);
            contentsizeMap.put('FILESIZE', String.valueOf(cvList[0].ContentSize));
            contentsizeMap.put('FILENAME', fileNameFull);
            if (String.isNotBlank(password))
                contentsizeMap.put('PASSWORD', password); // Optional, For signed document
            contentsizeMap.put('DIV_CODE', divCode); //“BD”-Business Division, “UD”–Underwriting Division, “CRD” – Claims and Recoveries 
            System.debug('submitDocForSign::contentsizeMap ====>'+contentsizeMap);
            // System.debug();
            
            if(ECIC_API_v1.access_token_success){
                if (Test.isRunningTest()) {
                    String resp_body = 'eyJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwiYWxnIjoiZGlyIn0..8Sp-y2wYwrfSI8V5WBj7ag.zMvCNBuVLp8MZ0zCDcQDBgHtzew7jsQWI-h4EGwjhFTUR9BS9LHhcSS7vyCtB2beDepmfZ2CxnO6lVfU_weY4FlHIU7M1I_96xoO2AOEXC9kEjSOsBr_hsJJxPWqfozEvUCc0mE7ktyDjUwK-b5hv_cDyRxOaknv_L0enHVlOXcm8jRHyXTnS7p3ak0w8krT_m_8jRvA45or49dn4hnQfVKucux6Uvy9HwDxD9aniWSaEwXt6w2vY3Wbsv3iWz3CYt1r4BJgGJXpr20R9bF5KqqeWMMG-95HpQbfz7olPKx3gvJsveWXYLmW5UbzWZfnW62YC68ArDzsDlRaaB8uhrUvq1EfcnTUfPqLwMaMiqrQG1FwGvILFQgoXHjv5mEQJkv8I6qqyjUVd9ozMIfgMiSpL3T1afWzmSMKXgUQksrLuQr3_rO18xFQFrAIEQEqNiJ8SfWAudxg8ZTnvL7DGpGjGSM3qdzbdlke8gTz-0twnF9auuahd0fs7xlLVRbi1RlTV-xZKD8PSI7X-1T54tATfEYaaEsmjAr3EY6IoqNN3vdQNflNYA0ahMDDZVTHeq6TOJERqULRyv8l51hBmi8dbeIAMYIx33_lxcjruhDhji9ndi7EtJvYqkjzkRNavPWruULZHzbZT1SWtCcdI5kcYsIQ0TJQZry_kpW5bBtmkpizUwvEaiB-RURhk3e1MgSiUf3o81vvJzeALhKcpw.6WWzlUDf_x148A3eMrm8wBZQAvjLE5q0Fez2DOP3lqE';
                    TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
                    Test.setMock(HttpCalloutMock.class, httpmock);
                } 
                Map<String, String> respParserMap = ECIC_API_v1.docSignToken(contentsizeMap);
                String resJson = respParserMap.get('ciphertext');
                // {"rtn_code":"1","rtn_msgs":null,"meta_data":{"signing_token":"Cc4BHqbKAc","time_expired":"2021-12-02 17:31:33","retry_sec":null}}
                System.debug('submitDocForSign::doc sign token json ====>'+resJson);
                Map<String, Object> tokenmap = (Map<String, Object>)JSON.deserializeUntyped(resJson);
                System.debug('submitDocForSign::doc sign tokenmap ====>'+tokenmap); 
                if(tokenmap.get('rtn_code') == '1'){
                    String metadatastr = JSON.serialize(tokenmap.get('meta_data'));
                    Map<String, Object> metadatamap = (Map<String, Object>)JSON.deserializeUntyped(metadatastr);
                    docToken = String.valueOf(metadatamap.get('signing_token'));
                    //System.debug('doc sign docToken ====>'+docToken); 
                    TIME_EXPIRED =  (String) metadatamap.get('time_expired');
                    time_of_expire = DateTime.valueOf(TIME_EXPIRED);
                    //System.debug('doc sign time_of_expire ====>'+time_of_expire); 
                    String url_extension = '/api/services/docsign/sign';
                    String auth_header = token_type+' '+access_token;
                    String url_parameters = '';
                    
                    Map<String, String> headersmap = new Map<String, String>();
                    headersmap.put('Authorization', auth_header);
                    headersmap.put('Content-Type', 'application/pdf');
                    //headersmap.put('Connection', 'keep-alive');
                    headersmap.put('SIGNING_TOKEN', docToken);
                    Blob reqBlobBody = cvList[0].VersionData;
                    if(cvList[0].ContentSize <5000000){
                        if (Test.isRunningTest()) {
                            TestHTTPBlobMockFactory httblobpmock = new TestHTTPBlobMockFactory(200, 'OK', Blob.toPdf('PDF Content.'), new Map<String,String>());
                            Test.setMock(HttpCalloutMock.class, httblobpmock);                            
                        }
                        HTTPResponse resp = SendHTTPRequestClass.sendBlobRequest(testMode, url_extension, url_parameters, headersmap, reqBlobBody );
                        System.debug('resp ====>'+resp);
                        Blob respBlobBody = resp?.getBodyAsBlob();
                        //System.debug('resp body ====>'+resp.getBodyAsBlob());

                        ContentVersion cv = new ContentVersion();
                        cv.Title= fileName + '_signed';
                        cv.PathOnClient = fileName + '_signed' + '.' + cvList[0].FileExtension;
                        cv.VersionData = respBlobBody;
                        cv.origin = 'C';

                        insert cv;
                        System.debug('ECIC ContentVersion inserted successfully id:'+cv.Id);
                        //added by satya
                        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
                        System.debug('conDocId==>>'+conDocId);
                        //Create ContentDocumentLink 
                        ContentDocumentLink cdlSchedule = new ContentDocumentLink();
                        cdlSchedule.LinkedEntityId = recordId;
                        cdlSchedule.ContentDocumentId = conDocId;
                        cdlSchedule.shareType = 'V';
                        Insert cdlSchedule;
                        System.debug('ECIC ContentDocumentLink inserted successfully');
                        /*List<Policy_Schedule__c> pSchList = new List<Policy_Schedule__c>();
                        for(Policy_Schedule__c pschedule :  [select id,name,Is_Schedule_Signed__c from Policy_Schedule__c where id =:recordId]){
                            pschedule.Is_Schedule_Signed__c=true;
                            pSchList.add(pschedule);
                        }
                        if(pSchList!=null && !pSchList.isEmpty()){
                            update pSchList;
                            System.debug('updated policy schedule successfully!!!.');
                        }*/
                    }else{
                        // ECIC_API_v1.submitCLDocForSignFutureMethod(auth_header, fileName, docToken, testMode, recordId);
                    }
                }  
            }
            else{
                Map <String, String> respParserMap = new Map<String, String>();
                respParserMap.put('Exception', 'Access Token call is not success');
            }
        }
    }

    @future(callout=true)
    public static void submitCLDocForSignFutureMethod(String recordId,String fileName, String divCode, String password){

        Boolean testMode = ECIC_API_v1.ecic_setting?.test_mode__c;

        List<ContentVersion> cvList = [SELECT ID, ContentDocumentId, ContentLocation, ContentModifiedById, ContentModifiedDate, ContentSize, 
                ContentUrl, Description,  ExternalDataSourceId, ExternalDocumentInfo1, ExternalDocumentInfo2, FeaturedContentBoost, 
                FeaturedContentDate, FileExtension, FileType, FirstPublishLocationId, IsAssetEnabled, IsLatest, IsMajorVersion, 
                NegativeRatingCount, NetworkId, Origin, OwnerId, PathOnClient, PublishStatus, RatingCount, ReasonForChange, 
                SharingOption, SharingPrivacy, TextPreview, Title, VersionData, VersionNumber 
                FROM ContentVersion WHERE Title = :fileName and IsLatest = true LIMIT 1];
        if(cvList != NULL && cvList.size()>0){
            System.debug('Content Document size ====>'+cvList[0].ContentSize);
            Map<String, String> contentsizeMap = new Map<String, String>();
            Map<String, String> contentDocMap = new Map<String, String>();

            String uid_id = ECIC_API_v1.generateRandomString(10);
            String docToken;
            String TIME_EXPIRED;
            String fileNameFull = cvList[0].Title + '.' + cvList[0].FileExtension;
            DateTime time_of_expire;
            contentsizeMap.put('UID', uid_id);
            contentsizeMap.put('FILESIZE', String.valueOf(cvList[0].ContentSize));
            contentsizeMap.put('FILENAME', fileNameFull);
            if (String.isNotBlank(password))
                contentsizeMap.put('PASSWORD', password); // Optional, For signed document
            contentsizeMap.put('DIV_CODE', divCode); //“BD”-Business Division, “UD”–Underwriting Division, “CRD” – Claims and Recoveries 
            System.debug('submitDocForSign::contentsizeMap ====>'+contentsizeMap);
            
            if(ECIC_API_v1.access_token_success){
                if (Test.isRunningTest()) {
                    String resp_body = 'eyJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwiYWxnIjoiZGlyIn0..8Sp-y2wYwrfSI8V5WBj7ag.zMvCNBuVLp8MZ0zCDcQDBgHtzew7jsQWI-h4EGwjhFTUR9BS9LHhcSS7vyCtB2beDepmfZ2CxnO6lVfU_weY4FlHIU7M1I_96xoO2AOEXC9kEjSOsBr_hsJJxPWqfozEvUCc0mE7ktyDjUwK-b5hv_cDyRxOaknv_L0enHVlOXcm8jRHyXTnS7p3ak0w8krT_m_8jRvA45or49dn4hnQfVKucux6Uvy9HwDxD9aniWSaEwXt6w2vY3Wbsv3iWz3CYt1r4BJgGJXpr20R9bF5KqqeWMMG-95HpQbfz7olPKx3gvJsveWXYLmW5UbzWZfnW62YC68ArDzsDlRaaB8uhrUvq1EfcnTUfPqLwMaMiqrQG1FwGvILFQgoXHjv5mEQJkv8I6qqyjUVd9ozMIfgMiSpL3T1afWzmSMKXgUQksrLuQr3_rO18xFQFrAIEQEqNiJ8SfWAudxg8ZTnvL7DGpGjGSM3qdzbdlke8gTz-0twnF9auuahd0fs7xlLVRbi1RlTV-xZKD8PSI7X-1T54tATfEYaaEsmjAr3EY6IoqNN3vdQNflNYA0ahMDDZVTHeq6TOJERqULRyv8l51hBmi8dbeIAMYIx33_lxcjruhDhji9ndi7EtJvYqkjzkRNavPWruULZHzbZT1SWtCcdI5kcYsIQ0TJQZry_kpW5bBtmkpizUwvEaiB-RURhk3e1MgSiUf3o81vvJzeALhKcpw.6WWzlUDf_x148A3eMrm8wBZQAvjLE5q0Fez2DOP3lqE';
                    TestHTTPMockFactory httpmock = new TestHTTPMockFactory(200, 'OK', resp_body, new Map<String,String>());
                    Test.setMock(HttpCalloutMock.class, httpmock);
                } 
                Map<String, String> respParserMap = ECIC_API_v1.docSignToken(contentsizeMap);
                String resJson = respParserMap.get('ciphertext');
                // {"rtn_code":"1","rtn_msgs":null,"meta_data":{"signing_token":"Cc4BHqbKAc","time_expired":"2021-12-02 17:31:33","retry_sec":null}}
                System.debug('submitDocForSign::doc sign token json ====>'+resJson);
                Map<String, Object> tokenmap = (Map<String, Object>)JSON.deserializeUntyped(resJson);
                System.debug('submitDocForSign::doc sign tokenmap ====>'+tokenmap); 
                if(tokenmap.get('rtn_code') == '1'){
                    String metadatastr = JSON.serialize(tokenmap.get('meta_data'));
                    Map<String, Object> metadatamap = (Map<String, Object>)JSON.deserializeUntyped(metadatastr);
                    docToken = String.valueOf(metadatamap.get('signing_token'));
                    //System.debug('doc sign docToken ====>'+docToken); 
                    TIME_EXPIRED =  (String) metadatamap.get('time_expired');
                    time_of_expire = DateTime.valueOf(TIME_EXPIRED);
                    //System.debug('doc sign time_of_expire ====>'+time_of_expire); 
                    String url_extension = '/api/services/docsign/sign';
                    String auth_header = token_type+' '+access_token;
                    String url_parameters = '';
                    
                    Map<String, String> headersmap = new Map<String, String>();
                    headersmap.put('Authorization', auth_header);
                    headersmap.put('Content-Type', 'application/pdf');
                    //headersmap.put('Connection', 'keep-alive');
                    headersmap.put('SIGNING_TOKEN', docToken);
                    Blob reqBlobBody = cvList[0].VersionData;
                    if(cvList[0].ContentSize <5000000){
                        if (Test.isRunningTest()) {
                            TestHTTPBlobMockFactory httblobpmock = new TestHTTPBlobMockFactory(200, 'OK', Blob.toPdf('PDF Content.'), new Map<String,String>());
                            Test.setMock(HttpCalloutMock.class, httblobpmock);                            
                        }
                        HTTPResponse resp = SendHTTPRequestClass.sendBlobRequest(testMode, url_extension, url_parameters, headersmap, reqBlobBody );
                        System.debug('resp ====>'+resp);
                        Blob respBlobBody = resp?.getBodyAsBlob();
                        //System.debug('resp body ====>'+resp.getBodyAsBlob());

                        ContentVersion cv = new ContentVersion();
                        cv.Title= fileName + '_signed';
                        cv.PathOnClient = fileName + '_signed' + '.' + cvList[0].FileExtension;
                        cv.VersionData = respBlobBody;
                        cv.origin = 'C';

                        insert cv;
                        System.debug('ECIC ContentVersion inserted successfully id:'+cv.Id);
                        //added by satya
                        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
                        System.debug('conDocId==>>'+conDocId);
                        //Create ContentDocumentLink 
                        ContentDocumentLink cdlSchedule = new ContentDocumentLink();
                        cdlSchedule.LinkedEntityId = recordId;
                        cdlSchedule.ContentDocumentId = conDocId;
                        cdlSchedule.shareType = 'V';
                        Insert cdlSchedule;
                        System.debug('ECIC ContentDocumentLink inserted successfully');
                        /*List<Policy_Schedule__c> pSchList = new List<Policy_Schedule__c>();
                        for(Policy_Schedule__c pschedule :  [select id,name,Is_Schedule_Signed__c from Policy_Schedule__c where id =:recordId]){
                            pschedule.Is_Schedule_Signed__c=true;
                            pSchList.add(pschedule);
                        }
                        if(pSchList!=null && !pSchList.isEmpty()){
                            update pSchList;
                            System.debug('updated policy schedule successfully!!!.');
                        }*/
                    }else{
                        ECIC_API_v1.submitPolicyDocForSignFutureMethod(auth_header, fileName, docToken, testMode, recordId);
                    }
                }  
            }
            else{
                Map <String, String> respParserMap = new Map<String, String>();
                respParserMap.put('Exception', 'Access Token call is not success');
            }
        }
    }

    // this method is for generating uid for document signature
    public static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }

    //TODO: Uncomment after Day1 2021/12/08
    /*
    @future(callout=true)
    public static void docSignFutureMethod(String auth_header, String fileName, String doctoken, Boolean isDocument){
        // if(isDocument){
        //     // query on te document.
        //     Document d = [SELECT AuthorId, body, bodylength, contenttype, description, developername, folderid, isdeleted, 
        //             isinternaluseonly, ispublic, name, namespaceprefix, type, url 
        //             FROM document limit 1];

        // }
        // else{
            if(true){
                // query on the file
                // contentdocument doc = [SELECT id, Title, SharingOption, PublishStatus, ParentId, OwnerId, LatestPublishedVersionId, IsArchived, 
                //         FileType, FileExtension, Description, ContentSize, ContentModifiedDate, ContentAssetId, ArchivedDate, ArchivedById  
                //         FROM contentdocument WHERE Title = :fileName limit 1];
                List<ContentVersion> cvList = [SELECT ID, ContentDocumentId, ContentLocation, ContentModifiedById, ContentModifiedDate, ContentSize, 
                        ContentUrl, Description,  ExternalDataSourceId, ExternalDocumentInfo1, ExternalDocumentInfo2, FeaturedContentBoost, 
                        FeaturedContentDate, FileExtension, FileType, FirstPublishLocationId, IsAssetEnabled, IsLatest, IsMajorVersion, 
                        NegativeRatingCount, NetworkId, Origin, OwnerId, PathOnClient, PublishStatus, RatingCount, ReasonForChange, 
                        SharingOption, SharingPrivacy, TextPreview, Title, VersionData, VersionNumber 
                        FROM ContentVersion WHERE Title = :fileName and IsLatest = true LIMIT 1];
                if(cvList != NULL && cvList.size()>0){
                    System.debug('Content Document size ====>'+cvList[0].ContentSize);
                    Map<String, String> headersmap = new Map<String, String>();
                        headersmap.put('Authorization', auth_header);
                        headersmap.put('Content-Type', 'application/pdf');
                        headersmap.put('sign_token', docToken);
                        Blob reqBlobBody = cvList[0].VersionData;
                        String url_extension = '/api/services/docsign/testConnectionAttachment';
                        // String auth_header = token_type+' '+access_token;
                        String url_parameters = '';
                        HTTPResponse resp = SendHTTPRequestClass.sendBlobRequest(url_extension, url_parameters, headersmap, reqBlobBody );
                        system.debug('future call response ====>'+resp.getBody());
                }
            }
        // }    
    }
    */
        
    /*
    //DEPRICATED - No reference found
    // 3.2 validate Harmonized code
    public static String validateHMCode(String harmonizedCode){
        // 1) Item 59 - Retrieve and show the harmonised code list stored on the legacy system while 
        // the prospect is filling in the "Harmonised Code" field on the credit limit application form.
        
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(access_token_success){
            if(harmonizedCode != NULL ){
                // objectAPIName = creditLimitID.getSobjectType().getDescribe().getName();
                // System.debug('objectAPIName ====>'+objectAPIName);
                Boolean testContent = False;
                String url_extension = '/api/services/common/HrmCode/validate';
                String auth_header = token_type+' '+access_token;
                String url_parameters = '';
                
                jsonObject.put('HRM_CODE', '12345678');
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
    */
    
    
    //TODO: Need to move from here 2021/12/08
    // 3.3 Retrieve exchange rate 
    @AuraEnabled(Cacheable=true)
    public static Map<String, String> retrieveExchngRate(String CUR_DATE, String CUR_CODE, String IS_EXACT_DATE, String ROW_INDEX){
        // /api/services/common/ExchRate/get
        // Request META_DATA 
        // 1 CUR_DATE Date Yes Date of exchange rate YYYY-MM-DD
        // 2 CUR_CODE String 3 Yes Currency Code USD
        // 3 IS_EXACT_DATE String 1 Yes Is exact date for exchange rate (Y/N) N
        // response data
        // Response META_DATA 1 EXCH_RATE Number Exchange rate from HKD to requested currency
        Map<String, Object> jsonObject = new Map<String, Object>();
        Map<String, String> returnMap = new Map<String, String>();
        try{
            if(!access_token_success){
                ECIC_API_V1.get_access_token();
            }
        }catch (AuraHandledException e) {
            throw new AuraHandledException(e.getMessage());
        }
        catch(Exception e){
            Map<String,String> msg = new Map<String, String>();
            msg.put('Exception','Exception ====>'+e.getMessage()+'==> line number ==>'+e.getLineNumber());
            System.debug('exception ===>'+msg);
            return msg;
        }

        if(access_token_success){
            // objectAPIName = creditLimitID.getSobjectType().getDescribe().getName();
            // System.debug('objectAPIName ====>'+objectAPIName);
            Boolean testContent = False;
            String url_extension = '/api/services/common/ExchRate/get';
            String auth_header = token_type+' '+access_token;
            String url_parameters = '';
            // better send the case record it self rather than query. cause query limit.
            // query on case and check the record type
            jsonObject.put('CUR_DATE', CUR_DATE);
            jsonObject.put('CUR_CODE', CUR_CODE);
            jsonObject.put('IS_EXACT_DATE', IS_EXACT_DATE);
            returnMap.put('CUR_DATE', CUR_DATE);
            returnMap.put('CUR_CODE', CUR_CODE);
            returnMap.put('IS_EXACT_DATE', IS_EXACT_DATE);
            returnMap.put('ROW_INDEX', ROW_INDEX);
            Map<String, String> respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
            if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('Exception')){
                system.debug('Exception in response ====>'+respParserMap.get('Exception'));
                // return 'exception '+respParserMap.get('Exception');
                returnMap.put('exception', String.valueOf(respParserMap.get('Exception')));
                return returnMap;
            }
            else if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('ciphertext')){
                system.debug('json response ====>'+respParserMap.get('ciphertext'));
                // return respParserMap.get('ciphertext');
                returnMap.put('ciphertext', respParserMap.get('ciphertext'));
                return returnMap;
            }
            else{
                if(respParserMap != NULL && respParserMap.size()>0){
                    for(String Key : respParserMap.keyset()){
                        system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                        returnMap.put(key, respParserMap.get(key));
                    }
                    // returnMap.putAll(jsonObject);
                    // returnMap.put('response', JSON.serialize(respParserMap));
                    // return 'response received';
                    return returnMap;
                }
            }
            return returnMap;
        }
        else{
            return NULL;
        }
    }


    //10.1 /api/services/sms/Sms/send Send SMS
    /**
     * Request MOBILE_NO Mobile Number
     *          MSG      SMS Content
     * Response SMS_REF SMS Reference
     * 
     */
    public static String sendSMS(Map<String, Object> jsonObject) {         

        String url_extension = '/api/services/sms/Sms/send';
        String auth_header = ECIC_API_v1.token_type+' '+ECIC_API_v1.access_token;
        String url_parameters = '';
        Boolean testContent = false;
        if(ECIC_API_V1.access_token_success){
            Map<String, String> respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
            if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('Exception')){
                system.debug('Exception in response ====>'+respParserMap.get('Exception'));
                return 'exception '+respParserMap.get('Exception');
            }
            else if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('ciphertext')){                
                // {"rtn_code":"1","rtn_msgs":null,"meta_data":{"sms_ref":"776240275"}}
                String resJson = respParserMap.get('ciphertext');
                return respParserMap.get('ciphertext');
                // Map<String, Object> smsResMap = (Map<String, Object>)JSON.deserializeUntyped(resJson);
                // if(smsResMap.get('rtn_code') == '1'){
                //     String metadatastr = JSON.serialize(tokenmap.get('meta_data'));
                //     Map<String, Object> metadatamap = (Map<String, Object>)JSON.deserializeUntyped(metadatastr);
                //     String smsRef = String.valueOf(metadatamap.get('SMS_REF'));
                // }
            }
            else{
                if(respParserMap != NULL && respParserMap.size()>0){
                    for(String Key : respParserMap.keyset()){
                        system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                    }
                    return JSON.serialize(respParserMap);
                }
            }
            return JSON.serialize(respParserMap);
        } else {
            Map <String, String> respParserMap = new Map<String, String>();
            respParserMap.put('Exception', 'Access Token call failed.');
            return JSON.serialize(respParserMap);
        }
        
    } 
    
  
}