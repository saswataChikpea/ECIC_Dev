/* ---------------------------------------------
    Desc :  class copied from sfdc panther https://www.sfdcpanther.com/jwt-demystifying/
            for creating the jwt payload. may not necessary in actual integration
    created by : sayantan@chikpea.com
    Created date : 24-may-2021
    THIS CLASS IS NOT REQUIRED ANY MORE. PLEASE DO NOT MOVE THIS CLASS. 
--------------------------------------------------*/

public with sharing class JWT_Class {
    public String alg {get;set;}
    public String iss {get;set;}
    public String sub {get;set;}
    public String aud {get;set;}
    public String exp {get;set;}
    public String iat {get;set;}
    public String cert {get;set;}
    public String pkcs8 {get;set;}
    public String privateKey {get;set;}
    public Map<String, String> claims{get;set;}
    public Integer validFor{get;set;}

    public static final String HS256 = 'HS256';
    public static final String RS256 = 'RS256';
    public static final String NONE = 'none';

    public JWT_Class() {
        system.debug('null constructor of jwt class ====>');
    }
    public JWT_Class(String alg) {
        system.debug('1 string parameter constructor of jwt class ====>');
        this.alg = alg;
        this.validFor = 3600; // can be taken for acces token call as well
    }
    public String assertion(){
        String jwt = '';
        JSONGenerator header = JSON.createGenerator(false);
        header.writeStartObject();
        header.writeStringField('alg', this.alg);
        header.writeEndObject();
        String encodedHeader = base64URLencode(Blob.valueOf(header.getAsString()));

        JSONGenerator body = JSON.createGenerator(false);
        body.writeStartObject();
        body.writeStringField('iss', this.iss);
        body.writeStringField('sub', this.sub);
        body.writeStringField('aud', this.aud);
        Long rightNow = (dateTime.now().getTime()/1000)+1;
        body.writeNumberField('iat', rightNow);
        body.writeNumberField('exp', (rightNow + validFor));
        if(claims != NULL){
            for(String claim : claims.Keyset()){
                body.writeStringField(claim, claims.get(claim));
            }
        }
        body.writeEndObject();
        jwt = encodedHeader+'.'+base64URLencode(Blob.valueOf(body.getAsString()));
        if (this.alg == HS256){
            Blob key = EncodingUtil.base64Decode(privateKey);
            Blob signature = Crypto.generateMac('hmacSHA256', Blob.valueOf(jwt), key);
            jwt += '.'+base64URLencode(signature);

        }else if(this.alg == RS256){
            Blob signature = NULL;
            if (cert != NULL){
                signature = Crypto.signWithCertificate('rsa-sha256', Blob.valueOf(jwt), cert);

            }else{
                Blob privateKey = EncodingUtil.base64Decode(pkcs8);
                signature = Crypto.sign('rsa-sha256', Blob.valueOf(jwt), privateKey);
            }
            jwt += '.' + base64URLencode(signature);
        }else if (this.alg == NONE){
            jwt +=  '.';
        }
        return jwt;
    }
    public String base64URLencode(Blob input){
        String output = EncodingUtil.base64Encode(input);
        output = output.replace('+', '-');
        output = output.replace('/', '_');
        while( output.endsWith('=')){
            output = output.subString(0, output.length()-1);
        }
        return output;
    }
}