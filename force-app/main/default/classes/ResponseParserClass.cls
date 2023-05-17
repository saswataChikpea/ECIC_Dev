/*----------------------------------------------------------
    Desc:   class for parsing the jwt payload and return a map
    Created by : sayantan@chikpea.com
    created date : 03-Jun-2021
    Modified on : 13-Aug-2021 for using the ecic settings
-------------------------------------------------------------*/
public with sharing class ResponseParserClass {
    // public ResponseParserClass() {

    // }
    private static String ecic_public_key_string;     // = 'Gn4eB1ciYvofSIpiziYLtYoE2pplA7diCXgAwtdsB6k=';
    private static String ecic_hmac_key_string;       // = 'mt9c1Re4G6RiKUxnQawc9tBQ0k2WcWiKLTMuIl70aSA=';
    private static String sf_private_rsa_key;     // = 'MIIEpAIBAAKCAQEA0f2jdREL8hLt0CUbm5vTWOUNK2yWBWPAI6MLnn2JI22sMwfg'+ 
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
    private static String ecic_public_rsa_key;    // = 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAv0HO7JHzwJACDUlHowSI'+
                                                            // 'iNarDytbisV4QWBx6t9YPr7kJW2VoPEMRaTED2Qfja3pwqrowKq7j0Or5KLUeCf8'+
                                                            // '7Y7fo8vBjZTpcTiZcKZGnHFACsWUDLpn1MGtq4fDyCHEr9L6QNKqHd2psPBMSB37'+
                                                            // 'KSr+vpKT4bbrdD7qrkvbxddkB22P1juoVW7OlWfJxeecwacxiLd4HacskHxVW9Na'+
                                                            // 'Fw5kCrckVtINmDjEP0jHlEXcQTB6ekZsCxf1qJAJyadt9BumcSsm0D0nhJurzhXw'+
                                                            // 'QfUVysMGLZqBglu4zS8J6h4rK0Kr7or5V8VrfapHFRBiNo0NhLE+6PayyRajX8Xd'+
                                                            // 'kwIDAQAB';
                                                            // ''+//'-----BEGIN PUBLIC KEY-----'+
                                                            //'-----END PUBLIC KEY-----';
    private static String sf_public_rsa_key;      // = 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0f2jdREL8hLt0CUbm5vT'+
                                                            // 'WOUNK2yWBWPAI6MLnn2JI22sMwfgryFC3Id/F87UyfIuspgynTqH2gzjNAvJ0h8b'+
                                                            // 'Uk+LVF+gBNiyuOvJQclUlFfVVnFP8nZx/WkEJbsyY2nZ05SClxYqET8ceJLZsxt+'+
                                                            // 'kHdjN/sujG0z9+a/Sd9Uz8HuFZ+JGgFObi3PM3yKcTA19jb+zR16jpak1kEBMUOw'+
                                                            // '+buCLQT5FANr1ohyxshbEKkl5Rw4oFt9e5kNJIhU/j3q19JcLHQs34NgJhANVWNZ'+
                                                            // 'NU3zT8UQmi13hp9fJyW+rmffm3DREUlmkf+vYNR6iz/QvVx0gb3nyKqhFWJLYJvZ'+
                                                            // 'rQIDAQAB';   
    public static Map<String, String> responseParseMethod(list<String> splitResp){
        Integer i = 0;
        // Blob key = Crypto.generateAesKey(256); 
        Blob exampleIV;
        Blob payload;
        Blob encryptedpayload;
        Blob headerval;
        Blob aad;
        Map<String, String> decryptedKeyValue = new Map<String, String>();
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
    
        Blob key = EncodingUtil.base64Decode(ecic_public_key_string);
        for(String s : splitResp){
            System.debug('string s ====>'+s);
            try{
                if(i==0){
                    try{
                        Blob decodedstr = EncodingUtil.base64Decode(s);
                        System.debug('decodedstr header ====>'+decodedstr.toString());
                        decryptedKeyValue.put('header', decodedstr.toString());
                        headerval = decodedstr;
                    }
                    catch(Exception e){
                        //System.debug('base64 decode Exception e ===>'+e.getMessage()+'==>'+e.getLineNumber()+'==>'+e.getStackTraceString());
                        throw new Base64DecodeException('Base64 decode Exception', e);
                    }
                }
                else if(i == 2){
                    try{
                        String decodedstr  = CustomBase64EnCodeDecodeClass.base64URLDecode(s);
                        exampleIv = EncodingUtil.base64Decode(decodedstr);
                        System.debug('exampleIv ====>'+exampleIv);
                        decryptedKeyValue.put('exampleIV',decodedstr);
                    }
                    catch(Exception e){
                        //System.debug('base64 decode Exception e ===>'+e.getMessage()+'==>'+e.getLineNumber()+'==>'+e.getStackTraceString());
                        throw new Base64DecodeException('Base64 decode Exception', e);
                    }
                }
                else if (i == 3) {
                    
                    // decryption method
                    try{
                        String decodedstr = CustomBase64EnCodeDecodeClass.base64URLDecode(s);
                        // Blob encrypted = Blob.valueOf(decodedstr);
                        Blob encrypted = EncodingUtil.base64Decode(decodedstr);
                        encryptedpayload = encrypted;
                        System.debug(' encrypted ====>'+encrypted);
                        Blob decrypted1 = Crypto.decrypt('AES256', key, exampleIv, encrypted);
                        // after decrypt need to decrypt again for getting the string value.
                        String signedEncodedPayload = decrypted1.toString();
                        System.debug('signedEncodedPayload ====>'+signedEncodedPayload);
                        List<String> encodedPayloadList = signedEncodedPayload.split('\\.');
                        System.debug('encodedPayloadList ====>'+encodedPayloadList.size());
                        String payloadBodyHeaderURLDecode = CustomBase64EnCodeDecodeClass.base64URLDecode(encodedPayloadList[0]);
                        Blob payloadBodyHeaderBlob = EncodingUtil.base64Decode(payloadBodyHeaderURLDecode);
                        String payloadBodyHeader = payloadBodyHeaderBlob.toString();
                        System.debug('payloadBodyHeader ====>'+payloadBodyHeader);
                        String payloadBodyvalueURLDecode = CustomBase64EnCodeDecodeClass.base64URLDecode(encodedPayloadList[1]);
                        Blob payloadBodyvalueBlob = EncodingUtil.base64Decode(payloadBodyvalueURLDecode);
                        String payloadBodyvalue = payloadBodyvalueBlob.toString();
                        System.debug('payloadBodyvalue ====>'+payloadBodyvalue);
                        
                        Blob payloadinput = Blob.valueOf(encodedPayloadList[0]+'.'+encodedPayloadList[1]);
                        Blob rsaSignKey = EncodingUtil.base64Decode(ecic_public_rsa_key);
                        // Blob rsaSignKey = EncodingUtil.base64Decode(sf_public_rsa_key); // for testing purpose uncomment this line
                        String payloadSignatureURLencode = CustomBase64EnCodeDecodeClass.base64URLDecode(encodedPayloadList[2]);
                        // System.debug('payloadSignatureURLencode ---->'+payloadSignatureURLencode);
                        Blob payloadSignatureBlob = EncodingUtil.base64Decode(payloadSignatureURLencode);
                        Boolean verifiedpayloadValue = Crypto.verify('RSA-SHA512', payloadinput, payloadSignatureBlob, rsaSignKey);
                        System.debug('verifiedpayloadValue ---->'+verifiedpayloadValue);
                        decryptedKeyValue.put('ciphertext_verified', String.valueOf(verifiedpayloadValue));
                        payload = decrypted1;
                        System.debug('ciphertext payloadBodyvalue string ====>'+payloadBodyvalue);
                        decryptedKeyValue.put('ciphertext', payloadBodyvalue);  //decrypted2.toString());
                    }
                    catch(Exception e){
                        //System.debug('ciphertext Exception e ===>'+e.getMessage()+'==>'+e.getLineNumber()+'==>'+e.getStackTraceString());
                        throw new CiphertextException('ciphertext Exception', e);
                    }
                }
                else if (i == 4){
                    // verify the signature/authentication tag
                    String decodedstr = CustomBase64EnCodeDecodeClass.base64URLDecode(s);
                    Blob encrypted = EncodingUtil.base64Decode(decodedstr);
                    aad = encrypted;
                    
                    String headerHex = EncodingUtil.convertToHex(Blob.valueOf(splitResp[0]));
                    System.debug('headerHex ===========>'+headerHex);
                    // System.debug('headerHex ===========>'+headerHex.length());
                    String IVHex =EncodingUtil.convertToHex(exampleIV);
                    // String IVHex =EncodingUtil.convertToHex(Blob.valueOf(splitResp[2]));
                    System.debug('IVHex ===========>'+IVHex);
                    // System.debug('IVHex ===========>'+IVHex.length());
                    String payloadHex = EncodingUtil.convertToHex(encryptedpayload);
                    // String payloadHex = EncodingUtil.convertToHex(Blob.valueOf(splitResp[3]));
                    System.debug('payloadHex ===========>'+payloadHex);
                    // System.debug('payloadHex ===========>'+payloadHex.length());
                    Integer blobsize = (Blob.valueOf(splitResp[0]).size());
                    // String blobstrsize = String.valueOf(blobsize);
                    // string blobstrsize = String.fromCharArray(new Integer[]{blobsize});
                    // System.debug('blobstrsize in Hex ===>'+EncodingUtil.convertToHex(Blob.valueOf(blobstrsize)));
                    System.debug('splitResp[0] length ====>'+splitResp[0].length());
                    System.debug('custom hex length of string length ====>'+ConvertToHexCustom.convertToHex(splitResp[0].length()));
                    String headerLengthHex = ConvertToHexCustom.convertToHex(splitResp[0].length());
                    System.debug('headerLengthHex ===========>'+headerLengthHex);
                    String combinedHexSalt = headerHex + IVHex + payloadHex + headerLengthHex;
                    System.debug('combinedHexSalt ===========>'+combinedHexSalt);
                    // System.debug('combinedHexSalt ===========>'+combinedHexSalt.length());
                    Blob inputsalt = EncodingUtil.convertFromHex(combinedHexSalt);
                    System.debug('inputsalt string ====>'+inputsalt);
                    // System.debug('inputsalt string ====>'+inputsalt.size());
                    // Blob salt = inputSalt;      // EncodingUtil.base64Decode(CustomBase64EnCodeDecodeClass.base64URLDecode(inputsalt));
                    // System.debug('salt =====>'+salt);
                    // System.debug('salt =====>'+salt.size());
                    Blob hmacKey = EncodingUtil.base64Decode(ecic_hmac_key_string);
                    // Blob hmacKey = Blob.valueOf(ecic_hmac_key_string);
                    Blob mac = Crypto.generateMac('hmacSHA512',inputSalt, hmacKey);
                    String macHex = EncodingUtil.convertToHex(mac);
                    System.debug('macHex =====>'+macHex);
                    // System.debug('macHex =====>'+macHex.length());
                    String mac0Hex = macHex.subString(0, macHex.length()/2);
                    System.debug('mac0Hex ======>'+mac0Hex);
                    System.debug('aad ====>'+encrypted);
                    System.debug('aadhex ====>'+EncodingUtil.convertToHex(encrypted));
                    // System.debug('mac0Hex ======>'+mac0Hex.length());
                    // Blob mac0Blob = EncodingUtil.convertFromHex(mac0Hex);
                    // System.debug('mac0Blob =====>'+mac0Blob);
                    // System.debug('mac0Blob =====>'+mac0Blob.size());
                    // Boolean verified = Crypto.verifyHMac('hmacSHA512', mac0Blob, hmacKey, aad);
                    Boolean verified = false;
                    if(mac0Hex == EncodingUtil.convertToHex(encrypted))
                        verified = true;
                    // System.debug('mac ====>'+mac);
                    System.debug('verified ====>'+verified);
                    decryptedKeyValue.put('response_body_verified', String.valueOf(verified));
                }
                i++;
                System.debug('i--------------------------------------------->'+i);
            }
            catch(Exception e){
                //System.debug('Exception e ===>'+e.getMessage()+'==>'+e.getLineNumber()+'==>'+e.getStackTraceString());
                throw new ResponseParserException('Exception in parsing response', e);
            }
        }
        return decryptedKeyValue;
    }

    //DEPRICATED: Commented, no reference found - 2021/12/09 
    /*
    public static Map<String, Object> sfResponseParserMethod(String jwtString){
        System.debug('jwtString ====>'+jwtString);
        list<String> splitResp = jwtString.split('\\.');
        System.debug('splitResp ====>'+splitResp.size());
        Integer i = 0;
        // Blob key = Crypto.generateAesKey(256); 
        Blob exampleIV;
        Blob payload;
        Blob encryptedpayload;
        Blob headerval;
        Blob aad;
        Map<String, Object> decryptedKeyValue = new Map<String, Object>();
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
    
        Blob key = EncodingUtil.base64Decode(ecic_public_key_string);
        for(String s : splitResp){
            System.debug('string s ====>'+s);
            try{
                if(i==0){
                    try{
                        Blob decodedstr = EncodingUtil.base64Decode(s);
                        System.debug('decodedstr header ====>'+decodedstr.toString());
                        decryptedKeyValue.put('header', decodedstr.toString());
                        headerval = decodedstr;
                    }
                    catch(Exception e){
                        System.debug('base64 decode Exception e ===>'+e.getMessage()+'==>'+e.getLineNumber()+'==>'+e.getStackTraceString());
                    }
                }
                else if(i == 2){
                    try{
                        String decodedstr  = CustomBase64EnCodeDecodeClass.base64URLDecode(s);
                        exampleIv = EncodingUtil.base64Decode(decodedstr);
                        System.debug('exampleIv ====>'+exampleIv);
                        decryptedKeyValue.put('exampleIV',decodedstr);
                    }
                    catch(Exception e){
                        System.debug('base64 decode Exception e ===>'+e.getMessage()+'==>'+e.getLineNumber()+'==>'+e.getStackTraceString());
                    }
                }
                else if (i == 3) {
                    
                    // decryption method
                    try{
                        String decodedstr = CustomBase64EnCodeDecodeClass.base64URLDecode(s);
                        // Blob encrypted = Blob.valueOf(decodedstr);
                        Blob encrypted = EncodingUtil.base64Decode(decodedstr);
                        encryptedpayload = encrypted;
                        System.debug(' encrypted ====>'+encrypted);
                        Blob decrypted1 = Crypto.decrypt('AES256', key, exampleIv, encrypted);
                        // after decrypt need to decrypt again for getting the string value.
                        String signedEncodedPayload = decrypted1.toString();
                        System.debug('signedEncodedPayload ====>'+signedEncodedPayload);
                        List<String> encodedPayloadList = signedEncodedPayload.split('\\.');
                        System.debug('encodedPayloadList ====>'+encodedPayloadList.size());
                        String payloadBodyHeaderURLDecode = CustomBase64EnCodeDecodeClass.base64URLDecode(encodedPayloadList[0]);
                        Blob payloadBodyHeaderBlob = EncodingUtil.base64Decode(payloadBodyHeaderURLDecode);
                        String payloadBodyHeader = payloadBodyHeaderBlob.toString();
                        System.debug('payloadBodyHeader ====>'+payloadBodyHeader);
                        String payloadBodyvalueURLDecode = CustomBase64EnCodeDecodeClass.base64URLDecode(encodedPayloadList[1]);
                        Blob payloadBodyvalueBlob = EncodingUtil.base64Decode(payloadBodyvalueURLDecode);
                        String payloadBodyvalue = payloadBodyvalueBlob.toString();
                        System.debug('payloadBodyvalue ====>'+payloadBodyvalue);
                        
                        Blob payloadinput = Blob.valueOf(encodedPayloadList[0]+'.'+encodedPayloadList[1]);
                        Blob rsaSignKey = EncodingUtil.base64Decode(sf_public_rsa_key);
                        // Blob rsaSignKey = EncodingUtil.base64Decode(sf_public_rsa_key); // for testing purpose uncomment this line
                        String payloadSignatureURLencode = CustomBase64EnCodeDecodeClass.base64URLDecode(encodedPayloadList[2]);
                        // System.debug('payloadSignatureURLencode ---->'+payloadSignatureURLencode);
                        Blob payloadSignatureBlob = EncodingUtil.base64Decode(payloadSignatureURLencode);
                        Boolean verifiedpayloadValue = Crypto.verify('RSA-SHA512', payloadinput, payloadSignatureBlob, rsaSignKey);
                        System.debug('verifiedpayloadValue ---->'+verifiedpayloadValue);
                        decryptedKeyValue.put('ciphertext_verified', String.valueOf(verifiedpayloadValue));
                        payload = decrypted1;
                        System.debug('ciphertext payloadBodyvalue string ====>'+payloadBodyvalue);
                        decryptedKeyValue.put('ciphertext', payloadBodyvalue);  //decrypted2.toString());
                    }
                    catch(Exception e){
                        System.debug('ciphertext Exception e ===>'+e.getMessage()+'==>'+e.getLineNumber()+'==>'+e.getStackTraceString());
                        // base64URLDecode(s);
                    }
                }
                else if (i == 4){
                    // verify the signature/authentication tag
                    String decodedstr = CustomBase64EnCodeDecodeClass.base64URLDecode(s);
                    Blob encrypted = EncodingUtil.base64Decode(decodedstr);
                    aad = encrypted;
                    
                    String headerHex = EncodingUtil.convertToHex(Blob.valueOf(splitResp[0]));
                    System.debug('headerHex ===========>'+headerHex);
                    // System.debug('headerHex ===========>'+headerHex.length());
                    String IVHex =EncodingUtil.convertToHex(exampleIV);
                    // String IVHex =EncodingUtil.convertToHex(Blob.valueOf(splitResp[2]));
                    System.debug('IVHex ===========>'+IVHex);
                    // System.debug('IVHex ===========>'+IVHex.length());
                    String payloadHex = EncodingUtil.convertToHex(encryptedpayload);
                    // String payloadHex = EncodingUtil.convertToHex(Blob.valueOf(splitResp[3]));
                    System.debug('payloadHex ===========>'+payloadHex);
                    // System.debug('payloadHex ===========>'+payloadHex.length());
                    Integer blobsize = (Blob.valueOf(splitResp[0]).size());
                    // String blobstrsize = String.valueOf(blobsize);
                    // string blobstrsize = String.fromCharArray(new Integer[]{blobsize});
                    // System.debug('blobstrsize in Hex ===>'+EncodingUtil.convertToHex(Blob.valueOf(blobstrsize)));
                    System.debug('splitResp[0] length ====>'+splitResp[0].length());
                    System.debug('custom hex length of string length ====>'+ConvertToHexCustom.convertToHex(splitResp[0].length()));
                    String headerLengthHex = ConvertToHexCustom.convertToHex(splitResp[0].length());
                    System.debug('headerLengthHex ===========>'+headerLengthHex);
                    String combinedHexSalt = headerHex + IVHex + payloadHex + headerLengthHex;
                    System.debug('combinedHexSalt ===========>'+combinedHexSalt);
                    // System.debug('combinedHexSalt ===========>'+combinedHexSalt.length());
                    Blob inputsalt = EncodingUtil.convertFromHex(combinedHexSalt);
                    System.debug('inputsalt string ====>'+inputsalt);
                    // System.debug('inputsalt string ====>'+inputsalt.size());
                    // Blob salt = inputSalt;      // EncodingUtil.base64Decode(CustomBase64EnCodeDecodeClass.base64URLDecode(inputsalt));
                    // System.debug('salt =====>'+salt);
                    // System.debug('salt =====>'+salt.size());
                    Blob hmacKey = EncodingUtil.base64Decode(ecic_hmac_key_string);
                    // Blob hmacKey = Blob.valueOf(ecic_hmac_key_string);
                    Blob mac = Crypto.generateMac('hmacSHA512',inputSalt, hmacKey);
                    String macHex = EncodingUtil.convertToHex(mac);
                    System.debug('macHex =====>'+macHex);
                    // System.debug('macHex =====>'+macHex.length());
                    String mac0Hex = macHex.subString(0, macHex.length()/2);
                    System.debug('mac0Hex ======>'+mac0Hex);
                    System.debug('aad ====>'+encrypted);
                    System.debug('aadhex ====>'+EncodingUtil.convertToHex(encrypted));
                    // System.debug('mac0Hex ======>'+mac0Hex.length());
                    // Blob mac0Blob = EncodingUtil.convertFromHex(mac0Hex);
                    // System.debug('mac0Blob =====>'+mac0Blob);
                    // System.debug('mac0Blob =====>'+mac0Blob.size());
                    // Boolean verified = Crypto.verifyHMac('hmacSHA512', mac0Blob, hmacKey, aad);
                    Boolean verified = false;
                    if(mac0Hex == EncodingUtil.convertToHex(encrypted))
                        verified = true;
                    // System.debug('mac ====>'+mac);
                    System.debug('verified ====>'+verified);
                    decryptedKeyValue.put('response_body_verified', String.valueOf(verified));
                }
                i++;
                System.debug('i--------------------------------------------->'+i);
            }
            catch(Exception e){
                System.debug('Exception e ===>'+e.getMessage()+'==>'+e.getLineNumber()+'==>'+e.getStackTraceString());
            }
        }
        return decryptedKeyValue;
    }
    */

    // Exception in parsing response
    public class ResponseParserException extends Exception {}
    // Exception during Base64 Ddecode
    public class Base64DecodeException extends Exception {}
    // Exception ciphertext
    public class CiphertextException extends Exception {}

}