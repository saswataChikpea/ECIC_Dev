/*----------------------------------------------------
    Desc:   class for testing bearer flow with jwt. connecte with JWT_Class.
    Created by :    sayantan@chikpea.com
    Created date :  24-May-2021
    NOT REQUIRED ANY MORE. PLEASE DO NOT MOVE THIS CLASS AND DELETE IT.
--------------------------------------------------------*/

public with sharing class JWTBeaterFlow {
    // public JWTBeaterFlow() {

    // }

    public static String getAccessToken(String tokenEndPoint, JWT_Class jwt){
        String grantType = 'urn:ietf:params:oauth:grant-type:jwt-bearer';
        String access_token = NULL;
        String body = 'grant_type='+EncodingUtil.urlEncode(grantType, 'UTF-8')+'assertion='+jwt.assertion();
        HTTPRequest req = new HTTPRequest();
        req.setMethod('POST');
        req.setEndpoint(tokenEndPoint);
        req.setHeader('Content-type','application/x-www-form-urlEncoded');
        req.setBody(body);
        HTTP http = new HTTP();
        try{
            HTTPResponse res = http.send(req);
            if(res.getStatusCode() == 200){
                System.debug('res getbody ====>'+res.getBody());
            }
            else{
                System.debug('response not 200 ====>'+res.getBody());
            }
        }catch(Exception ex){
            System.debug('exception ====>'+ex.getMessage());
        }
        return access_token;
    }
}