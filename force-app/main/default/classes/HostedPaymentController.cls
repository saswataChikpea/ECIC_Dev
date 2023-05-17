public with sharing class HostedPaymentController {
    private Map<String,String> oPassedParams = new Map<String,String>();
    public String amount {get;set;}
    public String renderAs {get;set;}
    public String invoiceID {get;set;}
    public String orderNumber {get;set;}
    public Invoice__c invObj {get;set;}
    public String  submissionURL {get;set;}
    public String language {get;set;}


    public HostedPaymentController(ApexPages.StandardController Controller)
    {
        System.debug('===>>'+ApexPages.currentPage().getParameters().get('invoiceID'));
        invoiceID = ApexPages.currentPage().getParameters().get('invoiceID');
        language = ApexPages.currentPage().getParameters().get('language');
        System.debug('language ===>>'+language);
        if(language != null && language.equals('en_US')){
            language='en-us';
        }else if(language != null && language.equals('zh_CN')){
            language='zh-cn';
        }else if(language != null && language.equals('zh_TW')){
            language='zh-tw';
        }
        if(invoiceID != null & !invoiceID.equals('')){
             invObj = [select id,name,Total_Net_Premium_Amount__c from Invoice__c where id =:invoiceID];
             System.debug('invObj : '+invObj);
             orderNumber = invObj.name+'_'+invObj.id;
             System.debug('orderNumber : '+orderNumber);
             amount = String.valueOf(invObj.Total_Net_Premium_Amount__c);
        }
        //System.debug('===>>renderAs'+ApexPages.currentPage().getParameters().get('renderAs'));
        //amount = ApexPages.currentPage().getParameters().get('amount');
        if(amount.contains('.')){
            amount = amount.substringBefore('.')+'.00';
            System.debug('substringBefore amount : '+amount);
        }
        PG_Config config=new PG_Config();
        submissionURL = config.endPoint;
        System.debug('submissionURL====>'+submissionURL+' language : '+language);
        
        renderAs='';
    }


    public static String sign(Map<string, string> paramsArray)  {
        String result = sign(buildDataToSign(paramsArray), HostedPaymentController.recover());
       return result;

    }


     public String getUUID(){
        Blob b = Crypto.generateAesKey(128);
        String h = EncodingUtil.convertToHex(b);
        String guid = h.substring(0,8) + '-' + h.substring(8,12) + '-' + h.substring(12,16) + '-' + h.substring(16,20) + '-' + h.substring(20);
        return guid;

    }

    public static String getUTCDateTime() {
        //System.now()=2021-09-21 11:03:42;;;;DebugLog= 2021-09-21, 7:06 p.m.;;;;Dev Console=2021-09-21 11:06:04
        
        datetime oUTSDateTime = System.now();//.addHours(-8);
       //String strUTCDateTime = oUTSDateTime.format('YYYY-MM-DD\'T\'hh:mm:ss\'Z\'');//YYYY-MM-DDThh:mm:ssZ this is UTC format mention in document
        String strUTCDateTime = oUTSDateTime.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        System.debug('System.now() ::'+System.now()+' strUTCDateTime:'+strUTCDateTime);
        return strUTCDateTime;

    }





    public String getParametersValues(){
        PG_Config config=new PG_Config();
        String result = '';
        //oPassedParams.put('access_key','d697528c3de53236999c61dff8d41f03');
        //oPassedParams.put('profile_id','64E0B430-A40D-45CD-A586-D91F5E28431B');
        oPassedParams.put('access_key',config.accessKey);
        oPassedParams.put('profile_id',config.profileID);
        oPassedParams.put('transaction_uuid',getUUID());
        oPassedParams.put('signed_field_names','access_key,profile_id,transaction_uuid,signed_field_names,unsigned_field_names,signed_date_time,locale,transaction_type,reference_number,amount,currency,payment_method');

        oPassedParams.put('unsigned_field_names','');
        //oPassedParams.put('merchant_defined_data1','test_mdd1');
        //oPassedParams.put('merchant_defined_data2','test_mdd2');
        oPassedParams.put('signed_date_time',getUTCDateTime());
        oPassedParams.put('locale',language);//'en'
        oPassedParams.put('transaction_type','sale');
        oPassedParams.put('reference_number',orderNumber);
        oPassedParams.put('amount',amount);
        oPassedParams.put('currency','hkd');
        oPassedParams.put('payment_method','card');

       for (String oKey : oPassedParams.KeySet()){
            result += '<div>';
            result += '<input type="hidden" id="'+oKey+'" name="'+oKey+'" value="'+oPassedParams.get(oKey)+'"/>';
            result += '</div>';
        }

        system.debug('--ParametersValues-->>' +result+'<<--End');
        return result;

    }
    public String getParametersValuesHidden(){
        String result = '';
        for (String oKey : oPassedParams.KeySet()){
            result += '<input type="hidden" id="' + oKey + '" name="' + oKey + '" value="' + oPassedParams.get(oKey) + '"/>';
        }
        system.debug('--ParametersValuesHidden-->>' + result+'<<<--');
        return result;

    }

    public String getSignedData(){
        String result = '';
        result += '<div>';
        result += '<input type="hidden" id="signature" name="signature" value="' + HostedPaymentController.sign(oPassedParams) + '"/>';
        result += '</div>';
        system.debug('-->>> getSignedData' + result);
        return result;
    }


    private Static String recover(){
        //String secretKey='570f6264b25f4e1dbf8d642481735e065744caab8449498fa3a6732d1511b8d7a5eb8c17903d4b879c853a13aa6dcaf4d2845e395ca343b5892e1a35ab7d5fac9bb7761bec76499e956b1d8961fa39ecbdaa444e51624acc942ca81b48c0c23be1793d25c6df45d98b60ea04185169aaa829cc91f8d04f61962bef9c3918e300';  //secret key
       //String secretKey = '37a205a6f26347f1baa00e48d8d2f75db9963390912741978a375a14f93a27b182330e59eea84741a0de3a5c2570cad63596e71a7c5e4810bf3a60cb0777b65211736655c4a948ed8231bf7f436821c5e160cecded0d4e77a384139c1a87bbef8be01a3cb25140d78f969efbbdb6d9def043f74d500c4da0bd89a2d24ad7bbc7';
       PG_Config config=new PG_Config();
       return config.secretKey;

    }



    private static String commaSeparate(List<string> dataToSign) {
        String result = '';
        for(String Str : dataToSign) {
            result += (result==''?'':',')+Str;
        }
        System.debug('commaSeparate : '+result);
        return result;

    }


    private static String buildDataToSign(Map<string,string> paramsArray) {
        String[] signedFieldNames = paramsArray.get('signed_field_names').Split(',');
        System.debug('signedFieldNames : '+signedFieldNames);
        List<string> dataToSign = new List<string>();

        for (String oSignedFieldName : signedFieldNames){
            System.debug('build::'+oSignedFieldName+ '=' + paramsArray.get(oSignedFieldName));
             dataToSign.Add(oSignedFieldName + '=' + paramsArray.get(oSignedFieldName));
        }
        System.debug('buildDataToSign : '+dataToSign);
        return commaSeparate(dataToSign);
    }

     private static String sign(String data, String secretKey) {//hmacSHA256
        String result = EncodingUtil.base64Encode(Crypto.generateMac('hmacSHA256', Blob.valueOf(data), Blob.valueOf(secretKey)));
        return result;

    }

}