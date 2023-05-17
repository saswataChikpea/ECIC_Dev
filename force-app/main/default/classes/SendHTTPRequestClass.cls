/*-----------------------------------------------
    Desc:      Class for sending http request and receive http response.
    Created By : sayantan@chikpea.com
    Created date : 11-May-2021

    Currently using named credentials instead of hard coded url mentioned in the class.
-------------------------------------------------*/

public with sharing class SendHTTPRequestClass {
    // public SendHTTPRequestClass() {

    // }
    // private static final String basic_url = 'https://api-uat.ec-reach.com.hk:9444';// this is  for uat purpose only. need to set in settings
    private static final String request_method = 'POST';
    
    public static HTTPResponse sendRequest(String url_extension, String url_parameters, String auth_header, String jsonbody){
        // the default method will be post only.
        HttpRequest req = new HttpRequest();
        HttpResponse res = NULL;
        Http http = new Http();
        String extension;
        // system.debug('basic_url ====>'+basic_url);
        String url ;
        if(String.isNotBlank(url_extension) && String.isNotEmpty(url_extension)){
            extension  = String.escapeSingleQuotes(url_extension);   // may have to add other escape methods if required.
            url = (url !=NULL && url != ''?url+extension:extension);
        }
        if(String.isNotBlank(url_parameters) && String.isNotEmpty(url_parameters)){
            extension  = String.escapeSingleQuotes(url_parameters);   // may have to add other escape methods if required.
            url = (url !=NULL && url != ''?url+extension:extension);
        }
        req.setMethod(request_method);
        // req.setClientCertificateName('ecic_self_signed_uat_v1');
        system.debug('sendRequest::url ====>'+url);
        // req.setEndpoint(url);
        if(ECIC_API_v1.ecic_setting != NULL && ECIC_API_v1.ecic_setting.test_mode__c){
            req.setEndpoint('callout:ECIC_API_UAT_v1'+url);
        }
        else if(ECIC_API_v1.ecic_setting != NULL && !ECIC_API_v1.ecic_setting.test_mode__c){
            req.setEndpoint('callout:ECIC_API_v1'+url);
        }
        if(String.isNotBlank(auth_header) && String.isNotEmpty(auth_header)){
            req.setHeader('Authorization', auth_header);
            req.setHeader('Content-Type', 'application/json');
        }
        if(String.isNotBlank(jsonbody) && String.isNotEmpty(jsonbody))
            req.setBody(jsonbody);
        
        req.setTimeout(120000);    // hard coded 120 seconds
        system.debug('sendRequest::http request req ====>'+req +'==> body ==>'+req.getBody()+ '==> endpoint ==>'+
                req.getEndpoint()+' ==> method ==>'+req.getMethod());
        try{
            res = http.send(req);
            system.debug('sendRequest::http response res =====>'+res);
        }
        catch(Exception ex){
            system.debug('sendRequest::exception ====>'+ex.getMessage()+'==line number ==>'+ex.getLineNumber()+'==get cause ==>'+ex.getCause()+
            '==get type name ==>'+ex.getTypeName()+'== stack trace string ==>'+ex.getStackTraceString());
        }
        return res;
    }
    // another send request method for sending document for signing. this call is little bit differernet than the earlier.  
    // created on 23-Jun-2021 for sending blob values, and also takes a map  as header.
    public static HTTPResponse sendBlobRequest(Boolean testMode, String url_extension, String url_parameters, Map<String, String> headersmap, Blob reqBlobBody){
        HttpRequest req = new HttpRequest();
        HttpResponse res = NULL;
        Http http = new Http();
        String extension;        
        System.debug('sendBlobRequest.param::url_extension ---'+url_extension);
        System.debug('sendBlobRequest.param::url_parameters ---'+url_parameters);
        System.debug('sendBlobRequest.param::headersmap ---'+headersmap);
        System.debug('sendBlobRequest.param::reqblobbodysize ---'+reqBlobBody?.size());
        System.debug('sendBlobRequest.param::reqblobbody ---'+reqBlobBody);
        String url ;
        if(String.isNotBlank(url_extension) && String.isNotEmpty(url_extension)){
            extension  = String.escapeSingleQuotes(url_extension);   // may have to add other escape methods if required.
            url = (url !=NULL && url != ''?url+extension:extension);
        }
        if(String.isNotBlank(url_parameters) && String.isNotEmpty(url_parameters)){
            extension  = String.escapeSingleQuotes(url_parameters);   // may have to add other escape methods if required.
            url = (url !=NULL && url != ''?url+extension:extension);
        }
        req.setMethod(request_method);
        // req.setClientCertificateName('ecic_self_signed_uat_v1');
        system.debug('url ====>'+url);
        // req.setEndpoint(url);
        //if(ECIC_API_v1.ecic_setting != NULL && ECIC_API_v1.ecic_setting.test_mode__c){
        if(testMode){
            req.setEndpoint('callout:ECIC_API_UAT_v1'+url);
        }
        //else if(ECIC_API_v1.ecic_setting != NULL && !ECIC_API_v1.ecic_setting.test_mode__c){
        else {
            req.setEndpoint('callout:ECIC_API_v1'+url);
        }
        req.setTimeout(120000);    // hard coded 120 seconds

        if(headersmap != NULL && headersmap.size()>0){
            for(String key : headersmap.keyset()){
                req.setHeader(key, headersmap.get(key));
                System.debug('header ====>'+key+ ' ==> value ====>'+ headersmap.get(key));
            }
        }
        if (reqBlobBody != NULL && reqBlobBody.size()>0){
            req.setBodyAsBlob(reqBlobBody);
        }
        system.debug('http blob request req ====>'+req +'==> body ==>'+req.getBodyAsBlob() + '==> endpoint ==>' + req.getEndpoint());
        try{
            res = http.send(req);
            system.debug('http blob response res =====>'+res);
        }
        catch(Exception ex){
            system.debug('exception ====>'+ex.getMessage()+'==line number ==>'+ex.getLineNumber()+'==get cause ==>'+ex.getCause()+
            '==get type name ==>'+ex.getTypeName()+'== stack trace string ==>'+ex.getStackTraceString());
        }
        return res;
    }
}