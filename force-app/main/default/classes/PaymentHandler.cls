public with sharing class PaymentHandler {

    @future (callout=true)
    public static void settlePayment(String paymentID) {
        SettlePaymentResponseFromLegacy settlePayResponse;
        List<Payment__c> payList = [select id,
        name,
        Payment_Date__c,
        Amount__c,
        Invoice__c,
        Invoice__r.Installment_Type__c,
        Invoice__r.Total_Net_Premium_Amount__c,
        Invoice__r.Invoice_Date__c,
        Invoice__r.CreatedDate,
        Invoice__r.Due_Date__c,
        Invoice__r.Frist_Reminder_Date__c,
        Invoice__r.Second_Reminder_Date__c,
        Policy__c,
        Policy__r.Legacy_Customer_Number__c,
        Policy__r.Legacy_Policy_Type__c,
        Policy__r.Effective_Date__c
        from Payment__c where id = :paymentID];

        System.debug('payList====>>'+payList);
        Map<String,Object> jsonObject = new Map<String,Object>();
        if(payList != null && !payList.isEmpty()){
            System.debug('Pass checking');
            Map<String,Decimal> schVsMLValueMap = new Map<String,Decimal>();
            List<Policy_Schedule__c> polSchList = [select id,name,Policy__c,Maximum_Liability__c from Policy_Schedule__c where Policy__c = :payList[0].Policy__c and Type__c='Schedule 1' ];
            for(Policy_Schedule__c sch : polSchList){
                schVsMLValueMap.put(sch.Policy__c,sch.Maximum_Liability__c);
            }
            System.debug('schVsMLValueMap=====>>'+schVsMLValueMap);
            Map<String,Decimal> invoiceVsPremiumValueMap = new Map<String,Decimal>();
            Map<String,Decimal> invoiceVsPremiumRateValueMap = new Map<String,Decimal>();
            List<Invoice_Line__c> invLineList = [select id,name,Invoice__c,Premium_Rate__c,Premium__c,Net_Premium_With_Discount__c from Invoice_Line__c where Invoice__c = :payList[0].Invoice__c ];
            for(Invoice_Line__c invLine : invLineList){
                invoiceVsPremiumValueMap.put(invLine.Invoice__c,invLine.Net_Premium_With_Discount__c);
                invoiceVsPremiumRateValueMap.put(invLine.Invoice__c,invLine.Premium_Rate__c);
            }
            System.debug('invoiceVsPremiumValueMap=====>>'+invoiceVsPremiumValueMap);
            System.debug('invoiceVsPremiumRateValueMap=====>>'+invoiceVsPremiumRateValueMap);
            for(Payment__c pay : payList ){
                jsonObject.put('INVOICE_ID',pay.Invoice__c);//a0O0l00000HD4vqEAD //a0O0l00000HD4vqEAX
                System.debug(' pay.Invoice__r.CreatedDate==============>>>'+pay.Invoice__r.CreatedDate);
                DateTime dT = pay.Invoice__r.CreatedDate;
                String inv_date = String.valueOf(dT.year())+'-'+String.valueOf(dT.month())+'-'+String.valueOf(dT.day());
                jsonObject.put('INV_DATE',inv_date);
                jsonObject.put('CUS_NO', pay.Policy__r.Legacy_Customer_Number__c);//372527
                jsonObject.put('PCY_TYPE',pay.Policy__r.Legacy_Policy_Type__c);
                DateTime dT1 = pay.Invoice__r.Due_Date__c;
                String due_date = String.valueOf(dT1.year())+'-'+String.valueOf(dT1.month())+'-'+String.valueOf(dT1.day());
                jsonObject.put('DUE_DATE',due_date);
                System.debug(' pay.Invoice__r.Frist_Reminder_Date__c===>'+ pay.Invoice__r.Frist_Reminder_Date__c);
                DateTime dT2 = pay.Invoice__r.Frist_Reminder_Date__c;
                String first_reminder_date = String.valueOf(dT2.year())+'-'+String.valueOf(dT2.month())+'-'+String.valueOf(dT2.day());
                jsonObject.put('RMDR_DATE_1',first_reminder_date);
                DateTime dT3 = pay.Invoice__r.Second_Reminder_Date__c;
                String second_reminder_date = String.valueOf(dT3.year())+'-'+String.valueOf(dT3.month())+'-'+String.valueOf(dT3.day());
                jsonObject.put('RMDR_DATE_2',second_reminder_date);
                jsonObject.put('INSTL_TYPE', pay.Invoice__r.Installment_Type__c);
                jsonObject.put('SEQ_NO', 1);
                DateTime dT4 = pay.Payment_Date__c;
                String paid_date = String.valueOf(dT4.year())+'-'+String.valueOf(dT4.month())+'-'+String.valueOf(dT4.day());
                jsonObject.put('PAID_DATE', paid_date);
                System.debug(' pay.Policy__r.Effective_Date__c===>'+ pay.Policy__r.Effective_Date__c);
                DateTime dT5 = pay.Policy__r.Effective_Date__c;
                String effective_date = String.valueOf(dT5.year())+'-'+String.valueOf(dT5.month())+'-'+String.valueOf(dT5.day());
                jsonObject.put('PCY_EFF_DATE', effective_date);
                //jsonObject.put('POLICY_ID', pay.Policy__c);//a090l000009OyNFAA0
                
                if(schVsMLValueMap != null && schVsMLValueMap.containsKey(pay.Policy__c)){
                    System.debug('ML Exists');
                    jsonObject.put('ML',schVsMLValueMap.get(pay.Policy__c));
                }else{
                    System.debug('Missing ML');
                }
                if(invoiceVsPremiumRateValueMap != null && invoiceVsPremiumRateValueMap.containsKey(pay.Invoice__c)){
                    System.debug('PRM_RATE Exists');
                    jsonObject.put('PRM_RATE',invoiceVsPremiumRateValueMap.get(pay.Invoice__c));
                }else{
                    System.debug('Missing PRM');
                }
                if(invoiceVsPremiumValueMap != null && invoiceVsPremiumValueMap.containsKey(pay.Invoice__c)){
                    System.debug('PRM Exists');
                    jsonObject.put('PRM',invoiceVsPremiumValueMap.get(pay.Invoice__c));
                }else{
                    System.debug('Missing PRM');
                }
                //jsonObject.put('DIS_RATE', 100);//set when discount is available
                //jsonObject.put('DIS_AMT', 1000);//set when discount is available
                jsonObject.put('NET_PRM',pay.Invoice__r.Total_Net_Premium_Amount__c);
                jsonObject.put('PAID_AMT',pay.Amount__c);
                break;
               
            }
            System.debug('jsonObject===>>'+jsonObject+'<<===');
            try {
                List<Payment__c> updatePayList = new List<Payment__c>();
                String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
                System.debug('ECIC Setting name ===>'+ecicset);
                String access_token_1=ECIC_API_V1.get_access_token();
                System.debug('access_token_1 ====>'+access_token_1);
                String response;
                if(!Test.isRunningTest()){
                    response = ECIC_API_PolicyMgmt.settleAccountPayment(jsonObject);
                }else{
                    response = '{"rtn_code":"1","rtn_msgs":[{"msg_id":1,"msg_code":"-20000","msg_data":"prm (0 Decimal Place) != ml * 3 * prm_rate / 100","msg_desc":"Invalid input parameter"}],"meta_data":null}';
                }
                
                System.debug('response :'+response);
                settlePayResponse=SettlePaymentResponseFromLegacy.parse(response);
                
                System.debug('settlePayResponse Code ====>>>'+settlePayResponse.rtn_code+' whole :'+settlePayResponse);
                String respMsg;
                for(Payment__c pay: payList){ 
                    if(settlePayResponse.rtn_code.equals('1')){
                        System.debug('Synced with legacy successfully!!!');
                        pay.Is_Sync_With_Legacy__c= true;
                        respMsg='Payment sync Successfully with legacy.';
                    }else{
                        System.debug('Failed to Synced with legacy!!!');
                        pay.Legacy_Error_Msg__c = settlePayResponse.rtn_msgs.toString();
                        respMsg='Payment sync failed with legacy.';
                    }
                    pay.Legacy_Synced_Date_Time__c = System.now();
                    updatePayList.add(pay);
                }
                if(updatePayList!= null && !updatePayList.isEmpty()){
                    update updatePayList;
                    System.debug(respMsg);
                }
               

            } catch (Exception e) {
                System.debug('Exception at settlePayment :'+e.getMessage()+' Stack:'+e.getStackTraceString());
            }
        }
    }

    public static void linkPaymentToCLA(String paymentID){
        try {
            List<Payment__c> payList = [select id,name,Invoice__c,Payment_Date__c,Policy__c,Amount__c,
            Invoice__r.Installment_Type__c,Invoice__r.Total_Net_Premium_Amount__c,
            Policy__r.Legacy_Customer_Number__c,Policy__r.Legacy_Policy_Type__c
            from Payment__c where id = :paymentID and Policy__r.Legacy_Policy_Type__c = '70'];
            System.debug('payList====>>'+payList);
            if(payList != null && !payList.isEmpty()){
                DateTime dT =payList[0].Payment_Date__c;
                Date payDate = date.newinstance(dT.year(), dT.month(), dT.day());
                List<ID> claIdList=new List<ID>();
                Map<ID,Decimal> invLineVSPremiumMap = new Map<ID,Decimal>();
                Map<ID,Decimal> invLineVSPremiumRateMap = new Map<ID,Decimal>();
                Map<ID,Decimal> invLineVSDiscountMap = new Map<ID,Decimal>();
                Map<ID,Decimal> invLineVSDiscRateMap = new Map<ID,Decimal>();
                for(Invoice_Line__c invLine : [select id,name,Invoice__c,Premium_Rate__c,Premium__c,
                    Credit_Limit_Application__c,Discount__c,Discount_Rate__c 
                    from Invoice_Line__c where Invoice__c = :payList[0].Invoice__c ]){
                        claIdList.add(invLine.Credit_Limit_Application__c);
                        invLineVSPremiumMap.put(invLine.Credit_Limit_Application__c,invLine.Premium__c);
                        invLineVSPremiumRateMap.put(invLine.Credit_Limit_Application__c,invLine.Premium_Rate__c);
                        invLineVSDiscountMap.put(invLine.Credit_Limit_Application__c,invLine.Discount__c);
                        invLineVSDiscRateMap.put(invLine.Credit_Limit_Application__c,invLine.Discount_Rate__c);
                }
                System.debug('claIdList ==>>'+claIdList);
                List<Credit_Limit_Application__c> updateCLAList = new List<Credit_Limit_Application__c>();
                for(Credit_Limit_Application__c cla : [select Premium_Paid_Date__c,Premium_Rate__c,Premium__c,
                    Discount_Rate__c,Discount_Amount__c,Premium_Paid_Legacy__c
                    from Credit_Limit_Application__c where id in :claIdList]){
                        cla.Premium_Paid_Date__c = payDate;
                        cla.Premium_Paid_Legacy__c = payList[0].Amount__c;
                        cla.CL_Status__c = 'Confirmation of payment';
                        /*if(invLineVSPremiumMap!=null && invLineVSPremiumMap.containsKey(cla.id)){
                            cla.Premium__c = invLineVSPremiumMap.get(cla.id);
                        }
                        if(invLineVSPremiumRateMap!=null && invLineVSPremiumRateMap.containsKey(cla.id)){
                            cla.Discount_Rate__c = invLineVSPremiumRateMap.get(cla.id);
                        }
                        if(invLineVSDiscountMap!=null && invLineVSDiscountMap.containsKey(cla.id)){
                            cla.Discount_Amount__c = invLineVSDiscountMap.get(cla.id);
                        }
                        if(invLineVSDiscRateMap!=null && invLineVSDiscRateMap.containsKey(cla.id)){
                            cla.Discount_Rate__c = invLineVSDiscRateMap.get(cla.id);
                        }*/
                       
                        updateCLAList.add(cla);
                }
                System.debug('updateCLAList ==>>'+updateCLAList);
                if(updateCLAList != null && !updateCLAList.isEmpty()){
                    update updateCLAList;
                    System.debug('CLA updated successfully!!!');
                }
            }
        } catch (Exception e) {
            System.debug('Exception at payment trigger method linkPaymentToCLA : '+e.getMessage()+' Stack : '+e.getStackTraceString());
        } 
    }
}