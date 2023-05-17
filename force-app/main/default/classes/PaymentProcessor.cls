public with sharing class PaymentProcessor {
    
    public class WrapperResponse{
        @AuraEnabled
        public boolean isSuccess{get;set;}
        @AuraEnabled
        public String responseMsg{get;set;}
        @AuraEnabled
        public String orderNumber{get;set;}
        @AuraEnabled
        public String reasonCode{get;set;}
        @AuraEnabled
        public String paidAmount{get;set;}
        @AuraEnabled
        public PaymentGatewayResponse gatewayResponse{get;set;}
        @AuraEnabled
        public List<Invoice_Line__c> invLine{get;set;} 
    }
    @AuraEnabled
    public static WrapperResponse callConvertCLItoCreditLimit(String cla_id){
        WrapperResponse wrapResponse = new WrapperResponse();
        wrapResponse.isSuccess = false;
        wrapResponse.responseMsg = '';
        System.debug('issueCreditLimit ====>'+cla_id);
        String response;
        if(!Test.isRunningTest()){
            response = ECIC_CL_API_Methods_CLI_Issue.convertCLItoCreditLimit(cla_id);
        }else{
            response = '{"meta_data":null,"rtn_msgs":"Success","rtn_code":1}';
        }
        
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response);
        Object rtn_code = responseMap.get('rtn_code');
        System.debug('cancelCLI rtn_code::'+rtn_code);
        if(Integer.valueOf(rtn_code) == 1){
            System.debug('cancelCLI success::');
            //Credit Limit Application or Credit Limit Incation is issue in legacy system now 
            //create credit limit in salesforce
            // and update the Credit Limit Incation as Approved
            Credit_Limit_Application__c cla = new Credit_Limit_Application__c();
            cla.Id = cla_id;
            cla.CL_Status__c = 'Confirmation of payment';
            update cla;
            System.debug('CLI aproved successfully::'+cla_id);
        }else{
            System.debug('cancelCLI failed::');
        }
        return wrapResponse;
    }
    @AuraEnabled
    public static WrapperResponse issueCreditLimit(String cla_id){
        WrapperResponse wrapResponse = new WrapperResponse();
        wrapResponse.isSuccess = false;
        wrapResponse.responseMsg = '';
        
        return wrapResponse;
    }
    @AuraEnabled
    public static WrapperResponse processPaymentTransaction(String response){
    WrapperResponse wrapResponse = new WrapperResponse();
    wrapResponse.isSuccess = false;
    wrapResponse.responseMsg = '';
    try {
            System.debug('processPaymentTransaction ====>'+response);
            PaymentGatewayResponse respObj = PaymentGatewayResponse.parse(response);
            System.debug('respObj ===>'+respObj.reason_code);
            wrapResponse.gatewayResponse = PaymentGatewayResponse.parse(response);
            Payment__c pay = new Payment__c();
            pay.Gateway_Raw_Response__c = response;
            pay.Payment_Date__c = System.now();
            if(respObj != null){
            pay.Amount__c = Decimal.valueOf(respObj.req_amount);
            pay.Remarks__c = respObj.message;
            pay.Currency__c = respObj.req_currency;
            pay.Salesforce_Generated_Transaction_Id__c = respObj.transaction_id;
            pay.Gateway_Transaction_Id__c = respObj.req_transaction_uuid;
            pay.Profile_Id__c = respObj.req_profile_id;
            pay.Reason_Code__c = respObj.reason_code;
            pay.Status__c = respObj.decision;
            pay.Order_Number__c = respObj.req_reference_number;
            pay.Card_Type__c = respObj.card_type_name;
            pay.Card_Number__c = respObj.req_card_number;
            wrapResponse.orderNumber = respObj.req_reference_number;
            wrapResponse.paidAmount = respObj.req_amount;
            wrapResponse.reasonCode = respObj.reason_code;
            String [] invoiceId = respObj.req_reference_number.split('_');
            System.debug(' invoiceId==> '+invoiceId+' Name=>'+invoiceId[0]+' ID=>'+invoiceId[1]);
            pay.Invoice__c = invoiceId[1];
            if(respObj.reason_code.equals('100') ){
                
                List<Invoice__c> updateInvList = new List<Invoice__c>();
                List<Invoice__c> invObjList = [select id,name,Payment__c,Status__c,Policy__c,
                (select id,name,Premium_Cycle__c,Gross_Invoice_Value__c,Line_Amount__c,Product__c,
                    Credit_Limit_Application__c
                 from Invoice_Lines__r where Credit_Limit_Application__c != null )  

                from Invoice__c where id = :invoiceId[1] and Status__c='UnPaid'];
                System.debug('invObjList ===>>>'+invObjList);
                wrapResponse.isSuccess = true;
                if(invObjList != null && !invObjList.isEmpty() ){
                    pay.Policy__c=invObjList[0].Policy__c;
                    insert pay;
                    System.debug('Payment Inserted Successfully!!!'+pay.id);
                    for(Invoice__c invRef : invObjList){
                        //invRef.Payment__c = pay.id;
                        invRef.Status__c = 'Paid';
                        updateInvList.add(invRef);
                    }
                    System.debug('updateInvList ===>>>'+updateInvList);
                    if(updateInvList != null && !updateInvList.isEmpty()){
                        update updateInvList;
                        System.debug(invoiceId[0]+' Invoice updated Successfully!!!');
                        wrapResponse.responseMsg = PaymentResponseCodeMsg.getPaymentResponseMsg(respObj.reason_code, respObj.req_locale, respObj.req_reference_number);//respObj.message;
                    }
                    wrapResponse.invLine = invObjList[0].Invoice_Lines__r;
                }/*else{
                    System.debug('No UnPaid Invoice is Found');
                    wrapResponse.isSuccess = false;
                    wrapResponse.responseMsg = 'Please select UnPaid Invoice For Payment.';
                }*/
            }else{
                insert pay;
                wrapResponse.responseMsg = PaymentResponseCodeMsg.getPaymentResponseMsg(respObj.reason_code, respObj.req_locale, respObj.req_reference_number); //'Payment Failed Reason : '+respObj.message;
                System.debug('Failed Payment Inserted!!!');
            }
        }else{
            insert pay;
            wrapResponse.responseMsg = 'Transaction unsuccessful. Reference Number: '+respObj.req_reference_number+' For assistance, please contact Ms. Lee (2732 9011).';
            System.debug('Failed Payment Inserted!!!');
        }

            
        } catch (Exception e) {
            System.debug('Exception at : '+e.getMessage()+ ' Stack :'+e.getStackTraceString());
            wrapResponse.responseMsg = 'Payment Failed Reason : '+e.getMessage()+ ' Stack :'+e.getStackTraceString();
            throw new AuraHandledException(e.getMessage());
        }
        return wrapResponse;
    }
}