/*-----------------------------------------------------------
    Desc :  Custom class for generating the payload as per the ecic standard. 
            Salesforce JWT for authorization purpose but not for REST API. 
            This custom class takes a JSON string as input and then Sign it 
            and encrypt it using 256 aes key and returns a string as jwt 
            formatted payload.
            
    Created by :    sayantan@chikpea.com
    Create date :   02-Jun-2021
    Modified on:    17-Jun-2021 for takeing map as parameter instead of json string.
    modified on     13-Aug-2021 for using ecic settings
-----------------------------------------------------------*/

public with sharing class CustomJWTPayloadGenerator {
    // public CustomJWTPayloadGenerator() {

    // }
    private static String ecic_public_key_string;       // = 'Gn4eB1ciYvofSIpiziYLtYoE2pplA7diCXgAwtdsB6k=';
    private static String ecic_hmac_key_string;         // = 'mt9c1Re4G6RiKUxnQawc9tBQ0k2WcWiKLTMuIl70aSA=';
    private static String ecic_public_rsa_key;          // = 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAv0HO7JHzwJACDUlHowSI'+
                                                        // 'iNarDytbisV4QWBx6t9YPr7kJW2VoPEMRaTED2Qfja3pwqrowKq7j0Or5KLUeCf8'+
                                                        // '7Y7fo8vBjZTpcTiZcKZGnHFACsWUDLpn1MGtq4fDyCHEr9L6QNKqHd2psPBMSB37'+
                                                        // 'KSr+vpKT4bbrdD7qrkvbxddkB22P1juoVW7OlWfJxeecwacxiLd4HacskHxVW9Na'+
                                                        // 'Fw5kCrckVtINmDjEP0jHlEXcQTB6ekZsCxf1qJAJyadt9BumcSsm0D0nhJurzhXw'+
                                                        // 'QfUVysMGLZqBglu4zS8J6h4rK0Kr7or5V8VrfapHFRBiNo0NhLE+6PayyRajX8Xd'+
                                                        // 'kwIDAQAB';
                                                        // ''+//'-----BEGIN PUBLIC KEY-----'+
                                                        //'-----END PUBLIC KEY-----';
private static String sf_private_rsa_key;               // =  'MIIEpAIBAAKCAQEA0f2jdREL8hLt0CUbm5vTWOUNK2yWBWPAI6MLnn2JI22sMwfg'+ 
                                                        // -----BEGIN RSA PRIVATE KEY-----
                                                        // 'ryFC3Id/F87UyfIuspgynTqH2gzjNAvJ0h8bUk+LVF+gBNiyuOvJQclUlFfVVnFP'+
                                                        // '8nZx/WkEJbsyY2nZ05SClxYqET8ceJLZsxt+kHdjN/sujG0z9+a/Sd9Uz8HuFZ+J'+
                                                        // 'GgFObi3PM3yKcTA19jb+zR16jpak1kEBMUOw+buCLQT5FANr1ohyxshbEKkl5Rw4'+
                                                        // 'oFt9e5kNJIhU/j3q19JcLHQs34NgJhANVWNZNU3zT8UQmi13hp9fJyW+rmffm3DR'+
                                                        // 'EUlmkf+vYNR6iz/QvVx0gb3nyKqhFWJLYJvZrQIDAQABAoIBAHdNtTpjjvffjUE+'+
                                                        // 'c+r6ox7UM6FCNhGl1JnqnkVTaUC5pKXxidO1//iu+qQaHIcHk0RgeBEgGeLmg4ck'+
                                                        // 'U2uPxMQE8VHkalOWkiPBwjwgGG+XX1uXUSad6LFiorqVGlGk597vdypDq27U/mX6'+
                                                        // 'eLjrnAKT8cjyakXaHTZw4Kklu1e0/Ki8Z3408MED+QUlSPvqxnde/A5xJRO5hT6J'+
                                                        // '1PdKizCxOd9FM5q2GC0OCFhnr6uBI0Td7ZuR1wxA3UFNEK33kWOxHCxGwhsw4PdS'+
                                                        // 'fLzk9gEUNO+hs5YPk/xeOSuZ3ZhEGyq9cGhMqVxsQCldUUcHX3K3xbXY59kD3E/d'+
                                                        // '2SqxM4ECgYEA9MzmFWfcVA8nLnAzhVqjtB046cR2sbpEF8tJjkymzEAOflRfK68q'+
                                                        // '5q2ua6mWIufZM3d3/xj472K1VlgU5VuF2cJ/ho1HR/PtykxUtpxcoKTiXfEulttQ'+
                                                        // 'VZkAYcU4cKFIzcyC3KcztsCQBncknmam79q0knD11WV9OiAXgPQvRl0CgYEA25kM'+
                                                        // 'ucQgqtmms58QNtEUwxEnpCglgIj6MebSaEiLOGQPXwLa/5lVvkXWSqtIof3gY0ER'+
                                                        // 'EshHdiuJSqykmHf3QaSJFSQq20D060iGvcMmIrFvRMNSgqhjCcg0F/pZKJRH308u'+
                                                        // 'Ax2p7GysJVjdyI8wgYzJdbKR7830c2CIuzYbC5ECgYEAmJNoyGiuc5nqMtBt3Czt'+
                                                        // 'IWKhSVpRHF7a9/WVR+LQhzdZkTVnB+QqmhIgRywwzlqxDpnkqZNX/GQKX+GQTI+p'+
                                                        // 'slq+fw9pIRiQ2eiPWC3Gsb1y9VhQUGgq/t7Y1RdGITT1Goff/EUeP0ZvvgfeQ/f5'+
                                                        // 'Dj/DEg7jufiCf4rm+1G2cWUCgYALukS/twW3miAY/6myA8CEGmpvjeVS0/3opFcg'+
                                                        // 'Up98x3s6q8BeXiYCH2CuZC9g11ogct0ij6ehW/ndDxNLQTznOI5JnsDbLMDnv9vS'+
                                                        // 'TpW+zJMQrQ2/BJclcpe1oB0a2bBs8KGYcQEeKz+WTwSpLVx9zrMDoiHBGNKxRrqG'+
                                                        // 'pQEUwQKBgQCiIVNwRj5yaWPgUDm/LdxWyR4KwWbKtzHJiSvSTLR0BECfBZ6Vnrlm'+
                                                        // 'xt1E1h9/FTJNceuGtN8RzX0EhcD2kn2ZW7g3a0QJ5ahknrOMiLJhAi8OlnMXtSNm'+
                                                        // 'pr57bSHcYzfEg0byas4icuaq6Ss6ew9qYZzUwfnN7elYD43tML/Eug==';
                                                        // -----END RSA PRIVATE KEY-----
    private static String sf_public_rsa_key;            // = 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0f2jdREL8hLt0CUbm5vT'+
                                                        // 'WOUNK2yWBWPAI6MLnn2JI22sMwfgryFC3Id/F87UyfIuspgynTqH2gzjNAvJ0h8b'+
                                                        // 'Uk+LVF+gBNiyuOvJQclUlFfVVnFP8nZx/WkEJbsyY2nZ05SClxYqET8ceJLZsxt+'+
                                                        // 'kHdjN/sujG0z9+a/Sd9Uz8HuFZ+JGgFObi3PM3yKcTA19jb+zR16jpak1kEBMUOw'+
                                                        // '+buCLQT5FANr1ohyxshbEKkl5Rw4oFt9e5kNJIhU/j3q19JcLHQs34NgJhANVWNZ'+
                                                        // 'NU3zT8UQmi13hp9fJyW+rmffm3DREUlmkf+vYNR6iz/QvVx0gb3nyKqhFWJLYJvZ'+
                                                        // 'rQIDAQAB';        
    // need a place to store this key.
    public static String payloadgen(Boolean testContent, Map<String, Object> jsonObject){   //, String jsonString
        // System.debug('jsonString ====>'+jsonString);
        System.debug('payloadgen::jsonObject ====>'+jsonObject);
        String payloadString;
        
        if(ECIC_API_v1.ecic_setting == NULL){
            ECIC_API_v1.get_ecic_setting(NULL);
        }
        if(ECIC_API_v1.ecic_setting != NULL && ECIC_API_v1.ecic_setting.test_mode__c){
            ecic_public_key_string = ECIC_API_v1.ecic_setting.ecic_uat_public_key__c;
            ecic_hmac_key_string = ECIC_API_v1.ecic_setting.ecic_uat_hmac_key__c;
            ecic_public_rsa_key = ECIC_API_v1.ecic_setting.ecic_uat_public_rsa_key__c;
            sf_private_rsa_key = ECIC_API_v1.ecic_setting.sf_uat_private_rsa_key__c;
            sf_public_rsa_key = ECIC_API_v1.ecic_setting.sf_uat_public_rsa_key__c;
        }
        else if(ECIC_API_v1.ecic_setting != NULL && !ECIC_API_v1.ecic_setting.test_mode__c){
            ecic_public_key_string = ECIC_API_v1.ecic_setting.ecic_public_key__c;
            ecic_hmac_key_string = ECIC_API_v1.ecic_setting.ecic_hmac_key__c;
            ecic_public_rsa_key = ECIC_API_v1.ecic_setting.ecic_public_rsa_key__c;
            sf_private_rsa_key = ECIC_API_v1.ecic_setting.sf_private_rsa_key__c;
            sf_public_rsa_key = ECIC_API_v1.ecic_setting.sf_public_rsa_key__c;
        }
        String headerValue = '{"enc":"A256CBC-HS512","alg":"dir"}';
        String cek = NULL; // currently it is null
        Blob key = EncodingUtil.base64Decode(ecic_public_key_string);
        String IVString ;   //= 'Example of IV256';
        IVString = ECIC_API_v1.ecic_setting.Intialization_Vector__c;
        Blob exampleIv = Blob.valueOf(IVString);
        String b64URLEncodedHeader = CustomBase64EnCodeDecodeClass.base64URLencode(Blob.valueOf(headerValue));
        //System.debug('payloadgen::b64URLEncodedHeader ====>'+b64URLEncodedHeader);
        String b64URLEncodedIV = CustomBase64EnCodeDecodeClass.base64URLencode(exampleIV);
        //System.debug('payloadgen::b64URLEncodedIV ====>'+b64URLEncodedIV);
        String signedContent;
        Blob encryptedContent;
        payloadString = b64URLEncodedHeader + '.' +'.'; // since cek is null adding .
        // if(String.isNotBlank(jsonString) && String.isNotEmpty(jsonString)){
        
        // String IVURLEncoded = CustomBase64EnCodeDecodeClass.base64URLencode(Blob.valueOf(IVString));
        // if(jsonObject != NULL && jsonObject.size()>0){
            signedContent = CustomJWTPayloadGenerator.signContentJsonString(testContent, jsonObject);       // jsonString
            //System.debug('payloadgen::signedContent ====>'+signedContent);
            //System.debug('payloadgen::signedContentHex ====>'+EncodingUtil.convertToHex(Blob.valueOf(signedContent)));
            // String b64URLsignContent = CustomBase64EnCodeDecodeClass.base64URLencode(Blob.valueOf(signedContent));
            // System.debug('b64URLsignContent ====>'+b64URLsignContent);
            Blob data = Blob.valueOf(signedContent);
            encryptedContent = Crypto.encrypt('AES256', key, exampleIv, data);
            String b64URLEncryptedContent =  CustomBase64EnCodeDecodeClass.base64URLencode(encryptedContent);
            //System.debug('payloadgen::encryptedContent ====>'+encryptedContent);
            //System.debug('payloadgen::b64URLEncryptedContent ====>'+b64URLEncryptedContent);
            //System.debug('payloadgen::b64URLEncryptedContentHEX ====>'+EncodingUtil.convertToHex(Blob.valueOf(b64URLEncryptedContent)));
            payloadString += b64URLEncodedIV + '.' + b64URLEncryptedContent + '.';
            //System.debug('payloadgen::before hmac sign payloadstring ====>'+payloadString);
            String headerHex = EncodingUtil.convertToHex(Blob.valueOf(b64URLEncodedHeader));
            //System.debug('payloadgen::headerHex for payload ====>'+headerHex);
            String IVHex =EncodingUtil.convertToHex(exampleIV);
            //System.debug('payloadgen::IVHex for payload ====>'+IVHex);
            String payloadHex = EncodingUtil.convertToHex(encryptedContent);
            //System.debug('payloadgen::payloadHex for payload ====>'+payloadHex);
            String headerLengthHex = ConvertToHexCustom.convertToHex(b64URLEncodedHeader.length());
            //System.debug('payloadgen::headerLengthHex for payload ====>'+headerLengthHex);
            Blob hmacKey = EncodingUtil.base64Decode(ecic_hmac_key_string);
            String combinedHexSalt = headerHex + IVHex + payloadHex + headerLengthHex;
            //System.debug('payloadgen::combinedHexSalt payload ====>'+combinedHexSalt);
            Blob inputsalt = EncodingUtil.convertFromHex(combinedHexSalt);
            Blob mac = Crypto.generateMac('hmacSHA512',inputSalt, hmacKey);
            String macHex = EncodingUtil.convertToHex(mac);
            //System.debug('payloadgen::mac generated of payload ====>'+macHex);
            String mac0Hex = macHex.subString(0, macHex.length()/2);
            Blob mac0Blob = EncodingUtil.convertFromHex(mac0Hex);
            //System.debug('payloadgen::mac0hex ====>'+mac0Hex);
            String signature = CustomBase64EnCodeDecodeClass.base64URLencode(mac0Blob);
            //System.debug('payloadgen::b64urlencoded signature =====>'+signature);
            payloadString +=signature;
            //System.debug('payloadgen::payload String with hmac Signature =====>'+payloadString);
        // }        
        // else{
        //     signedContent = CustomJWTPayloadGenerator.signContentJsonString(testContent, NULL);
        //     // there is no payload so just add two dots
        //     payloadString +='..';
        // }

        return payloadString;
    }

    public static String signContentJsonString(Boolean testContent, Map<String, Object> jsonObject){        // String jsonString){
        System.debug('signJsonString jsonObject ====>'+jsonObject);
        String algo = '{"alg":"RS512"}';
        Blob algoBlob = Blob.valueOf(algo);
        // String b64algo = EncodingUtil.base64Encode(algoBlob);
        if(ECIC_API_v1.ecic_setting == NULL){
            ECIC_API_v1.get_ecic_setting(NULL);
        }
        if(ECIC_API_v1.ecic_setting != NULL && ECIC_API_v1.ecic_setting.test_mode__c){
            ecic_public_key_string = ECIC_API_v1.ecic_setting.ecic_uat_public_key__c;
            ecic_hmac_key_string = ECIC_API_v1.ecic_setting.ecic_uat_hmac_key__c;
            ecic_public_rsa_key = ECIC_API_v1.ecic_setting.ecic_uat_public_rsa_key__c;
            sf_private_rsa_key = ECIC_API_v1.ecic_setting.sf_uat_private_rsa_key__c;
            sf_public_rsa_key = ECIC_API_v1.ecic_setting.sf_uat_public_rsa_key__c;
        }
        else if(ECIC_API_v1.ecic_setting != NULL && !ECIC_API_v1.ecic_setting.test_mode__c){
            ecic_public_key_string = ECIC_API_v1.ecic_setting.ecic_public_key__c;
            ecic_hmac_key_string = ECIC_API_v1.ecic_setting.ecic_hmac_key__c;
            ecic_public_rsa_key = ECIC_API_v1.ecic_setting.ecic_public_rsa_key__c;
            sf_private_rsa_key = ECIC_API_v1.ecic_setting.sf_private_rsa_key__c;
            sf_public_rsa_key = ECIC_API_v1.ecic_setting.sf_public_rsa_key__c;
        }
        
        String b64URLalgo = CustomBase64EnCodeDecodeClass.base64URLencode(algoBlob);
        System.debug('b64URLalgo ====>'+b64URLalgo);
        // Map<String, String> contentMap = new Map<String, String>();
        Map<String, Object> contentMap = new Map<String, Object>();
        if(testContent)
            contentMap.put('content', ((jsonObject != NULL && jsonObject.size()>0)?jsonObject:NULL));
        else{
            contentMap.put('meta_data', ((jsonObject != NULL && jsonObject.size()>0)?jsonObject:NULL));
        }
        String payload = JSON.serialize(contentMap);
        System.debug('json payload ====>'+payload);
        Blob payloadBlob = Blob.valueOf(payload);
        String b64URLPayload = CustomBase64EnCodeDecodeClass.base64URLencode(payloadBlob);
        System.debug('b64URLPayload ====>'+b64URLPayload);
        String input4Sign = b64URLalgo + '.' + b64URLPayload;
        Blob inputblob4sign = Blob.valueOf(input4Sign);
        Blob rsaPrivateKey = EncodingUtil.base64Decode((sf_private_rsa_key));
        String rsaSign;
        Blob rsaSignBlob = Crypto.sign('RSA-SHA512', inputblob4sign, rsaPrivateKey);
        rsaSign = CustomBase64EnCodeDecodeClass.base64URLencode(rsaSignBlob); 
        System.debug('rsaSign ====>'+rsaSign);
        String contentBody = input4Sign + '.' + rsaSign;
        System.debug('contentBody ====>'+contentBody);
        return contentBody;
    }
    public static String batchPayloadgen(List<Map<String, Object>> jsonObjects){   //, String jsonString
        // System.debug('jsonString ====>'+jsonString);
        System.debug('payloadgen::jsonObject ====>'+jsonObjects);
        String payloadString;
        
        if(ECIC_API_v1.ecic_setting == NULL){
            ECIC_API_v1.get_ecic_setting(NULL);
        }
        if(ECIC_API_v1.ecic_setting != NULL && ECIC_API_v1.ecic_setting.test_mode__c){
            ecic_public_key_string = ECIC_API_v1.ecic_setting.ecic_uat_public_key__c;
            ecic_hmac_key_string = ECIC_API_v1.ecic_setting.ecic_uat_hmac_key__c;
            ecic_public_rsa_key = ECIC_API_v1.ecic_setting.ecic_uat_public_rsa_key__c;
            sf_private_rsa_key = ECIC_API_v1.ecic_setting.sf_uat_private_rsa_key__c;
            sf_public_rsa_key = ECIC_API_v1.ecic_setting.sf_uat_public_rsa_key__c;
        }
        else if(ECIC_API_v1.ecic_setting != NULL && !ECIC_API_v1.ecic_setting.test_mode__c){
            ecic_public_key_string = ECIC_API_v1.ecic_setting.ecic_public_key__c;
            ecic_hmac_key_string = ECIC_API_v1.ecic_setting.ecic_hmac_key__c;
            ecic_public_rsa_key = ECIC_API_v1.ecic_setting.ecic_public_rsa_key__c;
            sf_private_rsa_key = ECIC_API_v1.ecic_setting.sf_private_rsa_key__c;
            sf_public_rsa_key = ECIC_API_v1.ecic_setting.sf_public_rsa_key__c;
        }
        String headerValue = '{"enc":"A256CBC-HS512","alg":"dir"}';
        String cek = NULL; // currently it is null
        Blob key = EncodingUtil.base64Decode(ecic_public_key_string);
        String IVString ;   //= 'Example of IV256';
        IVString = ECIC_API_v1.ecic_setting.Intialization_Vector__c;
        Blob exampleIv = Blob.valueOf(IVString);
        String b64URLEncodedHeader = CustomBase64EnCodeDecodeClass.base64URLencode(Blob.valueOf(headerValue));
        //System.debug('payloadgen::b64URLEncodedHeader ====>'+b64URLEncodedHeader);
        String b64URLEncodedIV = CustomBase64EnCodeDecodeClass.base64URLencode(exampleIV);
        //System.debug('payloadgen::b64URLEncodedIV ====>'+b64URLEncodedIV);
        String signedContent;
        Blob encryptedContent;
        payloadString = b64URLEncodedHeader + '.' +'.'; // since cek is null adding .
        // if(String.isNotBlank(jsonString) && String.isNotEmpty(jsonString)){
        
        // String IVURLEncoded = CustomBase64EnCodeDecodeClass.base64URLencode(Blob.valueOf(IVString));
        // if(jsonObject != NULL && jsonObject.size()>0){
            signedContent = CustomJWTPayloadGenerator.signBatchContentJsonString(jsonObjects);       // jsonString
            //System.debug('payloadgen::signedContent ====>'+signedContent);
            //System.debug('payloadgen::signedContentHex ====>'+EncodingUtil.convertToHex(Blob.valueOf(signedContent)));
            // String b64URLsignContent = CustomBase64EnCodeDecodeClass.base64URLencode(Blob.valueOf(signedContent));
            // System.debug('b64URLsignContent ====>'+b64URLsignContent);
            Blob data = Blob.valueOf(signedContent);
            encryptedContent = Crypto.encrypt('AES256', key, exampleIv, data);
            String b64URLEncryptedContent =  CustomBase64EnCodeDecodeClass.base64URLencode(encryptedContent);
            //System.debug('payloadgen::encryptedContent ====>'+encryptedContent);
            //System.debug('payloadgen::b64URLEncryptedContent ====>'+b64URLEncryptedContent);
            //System.debug('payloadgen::b64URLEncryptedContentHEX ====>'+EncodingUtil.convertToHex(Blob.valueOf(b64URLEncryptedContent)));
            payloadString += b64URLEncodedIV + '.' + b64URLEncryptedContent + '.';
            //System.debug('payloadgen::before hmac sign payloadstring ====>'+payloadString);
            String headerHex = EncodingUtil.convertToHex(Blob.valueOf(b64URLEncodedHeader));
            //System.debug('payloadgen::headerHex for payload ====>'+headerHex);
            String IVHex =EncodingUtil.convertToHex(exampleIV);
            //System.debug('payloadgen::IVHex for payload ====>'+IVHex);
            String payloadHex = EncodingUtil.convertToHex(encryptedContent);
            //System.debug('payloadgen::payloadHex for payload ====>'+payloadHex);
            String headerLengthHex = ConvertToHexCustom.convertToHex(b64URLEncodedHeader.length());
            //System.debug('payloadgen::headerLengthHex for payload ====>'+headerLengthHex);
            Blob hmacKey = EncodingUtil.base64Decode(ecic_hmac_key_string);
            String combinedHexSalt = headerHex + IVHex + payloadHex + headerLengthHex;
            //System.debug('payloadgen::combinedHexSalt payload ====>'+combinedHexSalt);
            Blob inputsalt = EncodingUtil.convertFromHex(combinedHexSalt);
            Blob mac = Crypto.generateMac('hmacSHA512',inputSalt, hmacKey);
            String macHex = EncodingUtil.convertToHex(mac);
            //System.debug('payloadgen::mac generated of payload ====>'+macHex);
            String mac0Hex = macHex.subString(0, macHex.length()/2);
            Blob mac0Blob = EncodingUtil.convertFromHex(mac0Hex);
            //System.debug('payloadgen::mac0hex ====>'+mac0Hex);
            String signature = CustomBase64EnCodeDecodeClass.base64URLencode(mac0Blob);
            //System.debug('payloadgen::b64urlencoded signature =====>'+signature);
            payloadString +=signature;
            //System.debug('payloadgen::payload String with hmac Signature =====>'+payloadString);
        // }        
        // else{
        //     signedContent = CustomJWTPayloadGenerator.signContentJsonString(testContent, NULL);
        //     // there is no payload so just add two dots
        //     payloadString +='..';
        // }

        return payloadString;
    }
    public static String signBatchContentJsonString(List<Map<String, Object>> jsonObjects){        // String jsonString){
        System.debug('signJsonString jsonObjects ====>'+jsonObjects);
        String algo = '{"alg":"RS512"}';
        Blob algoBlob = Blob.valueOf(algo);
        // String b64algo = EncodingUtil.base64Encode(algoBlob);
        if(ECIC_API_v1.ecic_setting == NULL){
            ECIC_API_v1.get_ecic_setting(NULL);
        }
        if(ECIC_API_v1.ecic_setting != NULL && ECIC_API_v1.ecic_setting.test_mode__c){
            ecic_public_key_string = ECIC_API_v1.ecic_setting.ecic_uat_public_key__c;
            ecic_hmac_key_string = ECIC_API_v1.ecic_setting.ecic_uat_hmac_key__c;
            ecic_public_rsa_key = ECIC_API_v1.ecic_setting.ecic_uat_public_rsa_key__c;
            sf_private_rsa_key = ECIC_API_v1.ecic_setting.sf_uat_private_rsa_key__c;
            sf_public_rsa_key = ECIC_API_v1.ecic_setting.sf_uat_public_rsa_key__c;
        }
        else if(ECIC_API_v1.ecic_setting != NULL && !ECIC_API_v1.ecic_setting.test_mode__c){
            ecic_public_key_string = ECIC_API_v1.ecic_setting.ecic_public_key__c;
            ecic_hmac_key_string = ECIC_API_v1.ecic_setting.ecic_hmac_key__c;
            ecic_public_rsa_key = ECIC_API_v1.ecic_setting.ecic_public_rsa_key__c;
            sf_private_rsa_key = ECIC_API_v1.ecic_setting.sf_private_rsa_key__c;
            sf_public_rsa_key = ECIC_API_v1.ecic_setting.sf_public_rsa_key__c;
        }
        
        String b64URLalgo = CustomBase64EnCodeDecodeClass.base64URLencode(algoBlob);
        System.debug('b64URLalgo ====>'+b64URLalgo);
        List<Map<String, Object>> batch_data_list = new List<Map<String, Object>>();
        for(Integer i=0; i<jsonObjects.size(); i++){
            Map<String, Object> requestMap = new Map<String, Object>();
            Map<String, Object> jsonObject = jsonObjects[i];
            requestMap.put('SEQ_NO', i);
            requestMap.put('REQ_DATA', jsonObject);
            batch_data_list.add(requestMap);
        }
        Map<String, Object> contentMap = new Map<String, Object>();
        contentMap.put('BATCH_DATA', batch_data_list);
        String payload = JSON.serialize(contentMap);
        System.debug('json payload ====>'+payload);
        Blob payloadBlob = Blob.valueOf(payload);
        String b64URLPayload = CustomBase64EnCodeDecodeClass.base64URLencode(payloadBlob);
        System.debug('b64URLPayload ====>'+b64URLPayload);
        String input4Sign = b64URLalgo + '.' + b64URLPayload;
        Blob inputblob4sign = Blob.valueOf(input4Sign);
        Blob rsaPrivateKey = EncodingUtil.base64Decode((sf_private_rsa_key));
        String rsaSign;
        Blob rsaSignBlob = Crypto.sign('RSA-SHA512', inputblob4sign, rsaPrivateKey);
        rsaSign = CustomBase64EnCodeDecodeClass.base64URLencode(rsaSignBlob); 
        System.debug('rsaSign ====>'+rsaSign);
        String contentBody = input4Sign + '.' + rsaSign;
        System.debug('contentBody ====>'+contentBody);
        return contentBody;
    }

    /*
    public static String requestgen(Boolean testContent, Map<String, Object> jsonObject, String operation, String version, String apiname){   //, String jsonString
        // System.debug('jsonString ====>'+jsonString);
        System.debug('jsonObject ====>'+jsonObject);
        if(ECIC_API_v1.ecic_setting == NULL){
            ECIC_API_v1.get_ecic_setting(NULL);
        }
        String ecic_private_rsa_key ;
                                    // =   'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAv0HO7JHzwJACDUlHowSI'+
                                    //     'iNarDytbisV4QWBx6t9YPr7kJW2VoPEMRaTED2Qfja3pwqrowKq7j0Or5KLUeCf8'+
                                    //     '7Y7fo8vBjZTpcTiZcKZGnHFACsWUDLpn1MGtq4fDyCHEr9L6QNKqHd2psPBMSB37'+
                                    //     'KSr+vpKT4bbrdD7qrkvbxddkB22P1juoVW7OlWfJxeecwacxiLd4HacskHxVW9Na'+
                                    //     'Fw5kCrckVtINmDjEP0jHlEXcQTB6ekZsCxf1qJAJyadt9BumcSsm0D0nhJurzhXw'+
                                    //     'QfUVysMGLZqBglu4zS8J6h4rK0Kr7or5V8VrfapHFRBiNo0NhLE+6PayyRajX8Xd'+
                                    //     'kwIDAQAB';
        if(ECIC_API_v1.ecic_setting != NULL && ECIC_API_v1.ecic_setting.test_mode__c){
            ecic_public_key_string = ECIC_API_v1.ecic_setting.ecic_uat_public_key__c;
            ecic_hmac_key_string = ECIC_API_v1.ecic_setting.ecic_uat_hmac_key__c;
            ecic_public_rsa_key = ECIC_API_v1.ecic_setting.ecic_uat_public_rsa_key__c;
            ecic_private_rsa_key = ECIC_API_v1.ecic_setting.ecic_uat_private_rsa_key__c;
            sf_private_rsa_key = ECIC_API_v1.ecic_setting.sf_uat_private_rsa_key__c;
            sf_public_rsa_key = ECIC_API_v1.ecic_setting.sf_uat_public_rsa_key__c;
        }
        else if(ECIC_API_v1.ecic_setting != NULL && !ECIC_API_v1.ecic_setting.test_mode__c){
            ecic_public_key_string = ECIC_API_v1.ecic_setting.ecic_public_key__c;
            ecic_hmac_key_string = ECIC_API_v1.ecic_setting.ecic_hmac_key__c;
            ecic_public_rsa_key = ECIC_API_v1.ecic_setting.ecic_public_rsa_key__c;
            ecic_private_rsa_key = ECIC_API_v1.ecic_setting.ecic_private_rsa_key__c;
            sf_private_rsa_key = ECIC_API_v1.ecic_setting.sf_private_rsa_key__c;
            sf_public_rsa_key = ECIC_API_v1.ecic_setting.sf_public_rsa_key__c;
        }
        String payloadString;
        String headerValue = '{"enc":"A256CBC-HS512","alg":"dir"}';
        String cek = NULL; // currently it is null
        Blob key = EncodingUtil.base64Decode(ecic_public_key_string);
        String IVString;        // = 'Example of IV256';
        IVString = ECIC_API_v1.ecic_setting.Intialization_Vector__c;
        Blob exampleIv = Blob.valueOf(IVString);
        String b64URLEncodedHeader = CustomBase64EnCodeDecodeClass.base64URLencode(Blob.valueOf(headerValue));
        System.debug('b64URLEncodedHeader ====>'+b64URLEncodedHeader);
        String b64URLEncodedIV = CustomBase64EnCodeDecodeClass.base64URLencode(exampleIV);
        System.debug('b64URLEncodedIV ====>'+b64URLEncodedIV);
        String signedContent;
        Blob encryptedContent;
        payloadString = b64URLEncodedHeader + '.' +'.'; // since cek is null adding .
        // if(String.isNotBlank(jsonString) && String.isNotEmpty(jsonString)){
        if(jsonObject != NULL && jsonObject.size()>0){
            // String IVURLEncoded = CustomBase64EnCodeDecodeClass.base64URLencode(Blob.valueOf(IVString));
            signedContent = CustomJWTPayloadGenerator.signReqContentJson(testContent, jsonObject, operation, version, apiname);       // jsonString
            System.debug('signedContent ====>'+signedContent);
            System.debug('signedContentHex ====>'+EncodingUtil.convertToHex(Blob.valueOf(signedContent)));
            // String b64URLsignContent = CustomBase64EnCodeDecodeClass.base64URLencode(Blob.valueOf(signedContent));
            // System.debug('b64URLsignContent ====>'+b64URLsignContent);
            Blob data = Blob.valueOf(signedContent);
            encryptedContent = Crypto.encrypt('AES256', key, exampleIv, data);
            String b64URLEncryptedContent =  CustomBase64EnCodeDecodeClass.base64URLencode(encryptedContent);
            System.debug('encryptedContent ====>'+encryptedContent);
            System.debug('b64URLEncryptedContent ====>'+b64URLEncryptedContent);
            System.debug('b64URLEncryptedContentHEX ====>'+EncodingUtil.convertToHex(Blob.valueOf(b64URLEncryptedContent)));
            payloadString += b64URLEncodedIV + '.' + b64URLEncryptedContent + '.';
            System.debug('before hmac sign payloadstring ====>'+payloadString);
        }else{
            // there is no payload so just add two dots
            payloadString +='..';
        }

        String headerHex = EncodingUtil.convertToHex(Blob.valueOf(b64URLEncodedHeader));
        System.debug('headerHex for payload ====>'+headerHex);
        String IVHex =EncodingUtil.convertToHex(exampleIV);
        System.debug('IVHex for payload ====>'+IVHex);
        String payloadHex = EncodingUtil.convertToHex(encryptedContent);
        System.debug('payloadHex for payload ====>'+payloadHex);
        String headerLengthHex = ConvertToHexCustom.convertToHex(b64URLEncodedHeader.length());
        System.debug('headerLengthHex for payload ====>'+headerLengthHex);
        Blob hmacKey = EncodingUtil.base64Decode(ecic_hmac_key_string);
        String combinedHexSalt = headerHex + IVHex + payloadHex + headerLengthHex;
        System.debug('combinedHexSalt payload ====>'+combinedHexSalt);
        Blob inputsalt = EncodingUtil.convertFromHex(combinedHexSalt);
        Blob mac = Crypto.generateMac('hmacSHA512',inputSalt, hmacKey);
        String macHex = EncodingUtil.convertToHex(mac);
        System.debug('mac generated of payload ====>'+macHex);
        String mac0Hex = macHex.subString(0, macHex.length()/2);
        Blob mac0Blob = EncodingUtil.convertFromHex(mac0Hex);
        System.debug('mac0hex ====>'+mac0Hex);
        String signature = CustomBase64EnCodeDecodeClass.base64URLencode(mac0Blob);
        System.debug('b64urlencoded signature =====>'+signature);
        payloadString +=signature;
        System.debug('payload String with hmac Signature =====>'+payloadString);
        return payloadString;
    }
    public static String signReqContentJson(Boolean testContent, Map<String, Object> jsonObject, String operation, String version, String apiname){        // String jsonString){
        System.debug('signJsonString jsonObject ====>'+jsonObject);
        String algo = '{"alg":"RS512"}';
        Blob algoBlob = Blob.valueOf(algo);
        // String b64algo = EncodingUtil.base64Encode(algoBlob);
        if(ECIC_API_v1.ecic_setting == NULL){
            ECIC_API_v1.get_ecic_setting(NULL);
        }
        String ecic_private_rsa_key = '';
        if(ECIC_API_v1.ecic_setting != NULL && ECIC_API_v1.ecic_setting.test_mode__c){
            ecic_public_key_string = ECIC_API_v1.ecic_setting.ecic_uat_public_key__c;
            ecic_hmac_key_string = ECIC_API_v1.ecic_setting.ecic_uat_hmac_key__c;
            ecic_public_rsa_key = ECIC_API_v1.ecic_setting.ecic_uat_public_rsa_key__c;
            ecic_private_rsa_key = ECIC_API_v1.ecic_setting.ecic_uat_private_rsa_key__c;
            sf_private_rsa_key = ECIC_API_v1.ecic_setting.sf_uat_private_rsa_key__c;
            sf_public_rsa_key = ECIC_API_v1.ecic_setting.sf_uat_public_rsa_key__c;
        }
        else if(ECIC_API_v1.ecic_setting != NULL && !ECIC_API_v1.ecic_setting.test_mode__c){
            ecic_public_key_string = ECIC_API_v1.ecic_setting.ecic_public_key__c;
            ecic_hmac_key_string = ECIC_API_v1.ecic_setting.ecic_hmac_key__c;
            ecic_public_rsa_key = ECIC_API_v1.ecic_setting.ecic_public_rsa_key__c;
            ecic_private_rsa_key = ECIC_API_v1.ecic_setting.ecic_private_rsa_key__c;
            sf_private_rsa_key = ECIC_API_v1.ecic_setting.sf_private_rsa_key__c;
            sf_public_rsa_key = ECIC_API_v1.ecic_setting.sf_public_rsa_key__c;
        }
        
        String b64URLalgo = CustomBase64EnCodeDecodeClass.base64URLencode(algoBlob);
        System.debug('b64URLalgo ====>'+b64URLalgo);
        // Map<String, String> contentMap = new Map<String, String>();
        Map<String, Object> contentMap = new Map<String, Object>();
        // if(testContent)
        //     contentMap.put('content', jsonObject);
        // else
        //     contentMap.put('meta_data', jsonObject);
        contentMap.put('op',operation);
        contentMap.put('api',apiname);
        contentMap.put('ver',version);
        System.debug('json object serialized ====>'+JSON.serialize(jsonObject));
        contentMap.put('meta_data',JSON.serialize(jsonObject));
        String payload = JSON.serialize(contentMap);
        System.debug('json payload ====>'+payload);
        Blob payloadBlob = Blob.valueOf(payload);
        String b64URLPayload = CustomBase64EnCodeDecodeClass.base64URLencode(payloadBlob);
        System.debug('b64URLPayload ====>'+b64URLPayload);
        String input4Sign = b64URLalgo + '.' + b64URLPayload;
        Blob inputblob4sign = Blob.valueOf(input4Sign);
        System.debug('ecic_private_rsa_key====>'+ecic_private_rsa_key);
        Blob rsaPrivateKey = EncodingUtil.base64Decode((ecic_private_rsa_key));
        String rsaSign;
        Blob rsaSignBlob = Crypto.sign('RSA-SHA512', inputblob4sign, rsaPrivateKey);
        rsaSign = CustomBase64EnCodeDecodeClass.base64URLencode(rsaSignBlob); 
        System.debug('rsaSign ====>'+rsaSign);
        String contentBody = input4Sign + '.' + rsaSign;
        System.debug('contentBody ====>'+contentBody);
        return contentBody;
    }
    */
}