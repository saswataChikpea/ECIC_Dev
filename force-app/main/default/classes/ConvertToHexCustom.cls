/* -------------------------------------------------
    Desc :      class for custom conversion of integer or string to hexa decimal value and then retrun the string.
    created by :       Sayantan@chikpea.com
    Created date :      07-Jun-2021
------------------------------------------------*/
public with sharing class ConvertToHexCustom {
    // public ConvertToHexCustom() {

    // }
    public static String convertToHex(Integer input){
        String hexadecimalString='';
        List<String> hexUnits = new List<String>{'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
        Integer quotient = input *8; //converting bytes to bits only for hkecic purpose
        Integer remainder;
        while(quotient!=0){
            remainder = Math.mod(quotient,16);
            //To convert integer into character
            hexadecimalString = hexUnits[remainder] + hexadecimalString;
            quotient = quotient / 16;
        }
        // if(hexadecimalString.length()<16){
        //     while(hexadecimalString.length()<16){
        //         hexadecimalString = '0' + hexadecimalString;
        //     }
        // }
        if(Math.mod(hexadecimalString.length(),16) !=0){
            while (Math.mod(hexadecimalString.length(),16) !=0)
                hexadecimalString = '0' + hexadecimalString;
        }
        return hexadecimalString;        
    }
}