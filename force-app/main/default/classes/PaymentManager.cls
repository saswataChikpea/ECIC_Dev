@RestResource(urlMapping='/v1/CreatePayment')
global with sharing class PaymentManager {

    @httpPost
    global static String insertPayment(){
        PG_Config pgConfig = new PG_Config();
        
        try {
           
            RestRequest req = RestContext.request;
            System.debug('req ====>'+req);
            RestResponse res = RestContext.response;
            System.debug('intial resp ====>'+res);
            Map<String, String> reqheaders = req.headers;
            
            String reqrestMethod = req.httpMethod;
            Map<String, String> reqParameters = req.params;
            String reqremoteAddress = req.remoteAddress;
            Blob reqBodyBlob = req.requestBody;
            // String reqBodyb64URLEncoded = CustomBase64EnCodeDecodeClass.base64URLencode(reqBodyBlob);
            String reqBodyb64URLEncoded = reqBodyBlob.toString();
            System.debug('reqheaders ====>'+reqheaders);
            System.debug('reqrestMethod ====>'+reqrestMethod);
            System.debug('reqParameters ====>'+reqParameters);
            System.debug('reqremoteAddress ====>'+reqremoteAddress);
            System.debug('reqBodyBlob ====>'+reqBodyBlob);
            System.debug('reqBodyb64URLEncoded ====>'+reqBodyb64URLEncoded);
            System.debug('Amount : '+reqParameters.get('auth_amount')+'\n req_reference_number : '+reqParameters.get('req_reference_number'));
           
            /*List<String> invoiceIDList= new List<String>(); 
            ECIC_Settings__c ecicObj = [select Submitted_to_Gateway_For_Payment__c from ECIC_Settings__c limit 1];
            if(ecicObj != null && ecicObj.Submitted_to_Gateway_For_Payment__c != null){
                System.debug('ecicObj.Submitted_to_Gateway_For_Payment__c : '+ecicObj.Submitted_to_Gateway_For_Payment__c);
                if(ecicObj.Submitted_to_Gateway_For_Payment__c.length()>0){
                    invoiceIDList = ecicObj.Submitted_to_Gateway_For_Payment__c.split(';');
                }
                System.debug('invoiceIDList ======>>'+invoiceIDList);
            }
           
           

            Payment__c pay = new Payment__c();
            pay.Gateway_Raw_Response__c = String.valueOf(System.RestContext.request);
            pay.Payment_Date__c = System.today();
            pay.Amount__c = Decimal.valueOf(reqParameters.get('auth_amount'));
            pay.Remarks__c = reqParameters.get('message');
            pay.Status__c = reqParameters.get('decision');
            pay.Currency__c = reqParameters.get('req_currency');
            pay.Salesforce_Generated_Transaction_Id__c = reqParameters.get('transaction_id');
            pay.Gateway_Transaction_Id__c = reqParameters.get('req_transaction_uuid');
            pay.Profile_Id__c = reqParameters.get('req_profile_id');
            
            
            insert pay;
            System.debug('Payment Created Successfully!!!!'+pay.id);*/
            
        } catch (Exception ex) {
            System.debug('Exception at ex:'+ex.getMessage()+ ' St:'+ex.getStackTraceString());
        }
        return 'Yes'+'paymentResponse';
    }
    /*public static String sign(Map<string, string> paramsArray)  {
        PG_Config pgConfig = new PG_Config();
        //String result = sign(buildDataToSign(paramsArray), pgConfig.secretKey);
       return result;

    }
    private static String buildDataToSign() {
        List<String> signedFieldNames = new List<String>();
        signedFieldNames.add('transaction_id');
        signedFieldNames.add('decision');
        signedFieldNames.add('req_access_key');
        signedFieldNames.add('req_profile_id');
        signedFieldNames.add('req_transaction_uuid');
        signedFieldNames.add('req_transaction_type');
        signedFieldNames.add('req_reference_number');
        signedFieldNames.add('req_amount');
        signedFieldNames.add('req_currency');
        signedFieldNames.add('req_locale');
        signedFieldNames.add('req_payment_method');
        signedFieldNames.add('req_bill_to_forename');
        signedFieldNames.add('req_bill_to_surname');
        signedFieldNames.add('req_bill_to_email');
        signedFieldNames.add('req_bill_to_address_line1');
        signedFieldNames.add('req_bill_to_address_line2');
        signedFieldNames.add('req_bill_to_address_city');
        signedFieldNames.add('req_bill_to_address_country');
        signedFieldNames.add('req_card_number');
        signedFieldNames.add('req_card_type');
        signedFieldNames.add('req_card_type_selection_indicator');
        signedFieldNames.add('req_card_expiry_date');
        signedFieldNames.add('card_type_name');
        signedFieldNames.add('message');
        signedFieldNames.add('reason_code');
        signedFieldNames.add('auth_avs_code');
        signedFieldNames.add('auth_avs_code_raw');
        signedFieldNames.add('auth_response');
        signedFieldNames.add('auth_amount');
        signedFieldNames.add('auth_code');
        signedFieldNames.add('auth_cavv_result');
        signedFieldNames.add('auth_cavv_result_raw');
        signedFieldNames.add('auth_cv_result');
        signedFieldNames.add('auth_cv_result_raw');
        signedFieldNames.add('auth_trans_ref_no');
        signedFieldNames.add('auth_time');
        signedFieldNames.add('request_token');
        signedFieldNames.add('bill_trans_ref_no');
        signedFieldNames.add('payer_authentication_enroll_veres_enrolled');
        signedFieldNames.add('payer_authentication_xid');
        signedFieldNames.add('payer_authentication_proof_xml');
        signedFieldNames.add('payer_authentication_eci');
        signedFieldNames.add('payer_authentication_cavv');
        signedFieldNames.add('payer_authentication_pares_status');
        signedFieldNames.add('payer_authentication_validate_result');
        signedFieldNames.add('payer_authentication_reason_code');
        signedFieldNames.add('payer_authentication_validate_e_commerce_indicator');
        signedFieldNames.add('signed_field_names');
        signedFieldNames.add('signed_date_time');
        System.debug('signedFieldNames : '+signedFieldNames);
        List<string> dataToSign = new List<string>();

        for (String oSignedFieldName : signedFieldNames){
            //System.debug('build::'+oSignedFieldName+ '=' + paramsArray.get(oSignedFieldName));
            //dataToSign.Add(oSignedFieldName + '=' + paramsArray.get(oSignedFieldName));
        }
        System.debug('buildDataToSign : '+dataToSign);
        return commaSeparate(dataToSign);
    }
    private static String sign(String data, String secretKey) {//hmacSHA256
        String result = EncodingUtil.base64Encode(Crypto.generateMac('hmacSHA256', Blob.valueOf(data), Blob.valueOf(secretKey)));
        return result;

    }*/
}