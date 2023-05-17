/*-------------------------------------------
    Created by : sayantan@chikpea.com
    Created on : 18-Jun-2021
    Desc       : this class is for payment controller. the first stage is working it as a 
                vf page controller and then need to update for lwc component. also there few things
                which are currently hardcoded and will convert to some settings or objects.
--------------------------------------------*/
public with sharing class GlobalPaymentController {
    public String transaction_uuid {get;set;}
    public String signDate {get;set;}
    public GlobalPaymentController() {
        System.debug('null constructor ====>');
        generateTranUUID();
        generateDateTime();
    }
    public GlobalPaymentController(ApexPages.StandardController std) {
        System.debug('parameterised controller ===>');
        generateTranUUID();
        generateDateTime();
    }
    private void generateTranUUID (){
        // Blob blobKey = crypto.generateAesKey(256);
        // transaction_uuid = EncodingUtil.base64encode(blobKey);
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        Integer len = 20;
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        transaction_uuid = randStr;
        System.debug('transaction_uuid ====>'+transaction_uuid);
    }
    private void generateDateTime(){
        Datetime GMTDate = System.now();
        System.debug('GMTDate ===>'+String.valueOf(GMTDate));
        signDate = GMTDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'', 'Asia/Hong_Kong');   //2005-08-15T15:52:01+00:00
        System.debug('signDate ====>'+signDate);
    }
    // @AuraEnabled
    // public static string methodName(){
    //     try {
            
    //     } catch (Exception e) {
    //         throw new AuraHandledException(e.getMessage());
    //     }
    // }
}