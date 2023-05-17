/*---------------------------------------------------
    Desc :  Custom class for base 64 url encoding and decoding. The url enccoding and decoding 
            provided by salesforce is different than java based one. So have call this custom logic
            to match with ecic encoding and decoding.
    Created By : sayantan@chikpea.com
    Created date : 02-Jun-2021
------------------------------------------------------*/

public with sharing class CustomBase64EnCodeDecodeClass {
    // public CustomBase64EnCodeDecodeClass() {

    // }

    public static String base64URLDecode(String input){
        String output = input;
        output = output.replace('-', '+');
        output = output.replace('_', '/');
        System.debug('Base64URLDecode input replaced string ====>'+output);
        Boolean excep = false;
        Integer len = output.length();
        Integer remainder = Math.mod(len,4);
        System.debug('string length ====>'+len+'==> remainder ====>'+remainder);
        if (remainder >0){
            // if(output.contains ('.'))
            //     return 'a dot is there in the string. can not convert.';
            
            Integer addstrcount = 4 - remainder;
            for(Integer k=0; k<addstrcount;k++){
                output +='=';
            }
            system.debug('after adding padding bits output ====>'+output);
        }
        return output;
    }
    public static String base64URLencode(Blob input){
        String output = EncodingUtil.base64Encode(input);
        output = output.replace('+', '-');
        output = output.replace('/', '_');
        while( output.endsWith('=')){
            output = output.subString(0, output.length()-1);
        }
        return output;
    }
}