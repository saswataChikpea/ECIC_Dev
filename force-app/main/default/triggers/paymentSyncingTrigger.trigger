trigger paymentSyncingTrigger on Payment__c (after insert,after update) {

    /*if (Trigger.isBefore) {

    }*/
    if (Trigger.isAfter) {
        List<Id> paymentIDList = new List<ID>();
        for (Payment__c pay : Trigger.new) {
            if(Trigger.isUpdate){
                Payment__c payOld = Trigger.oldMap.get(pay.id);
                if(!payOld.Status__c.equals('ACCEPT')){
                    if(pay.Status__c.equals('ACCEPT')){
                        paymentIDList.add(pay.id);
                    }
                }
            }else if(Trigger.isInsert){
                if(pay.Status__c !=null && pay.Status__c.equals('ACCEPT')){
                    paymentIDList.add(pay.id);
                }
            }
        }
        System.debug('paymentIDList ===>>'+paymentIDList);
        if(paymentIDList!= null && !paymentIDList.isEmpty()){
            List<Payment__c> updatePayList = new List<Payment__c>();
            PaymentHandler.linkPaymentToCLA(paymentIDList[0]);
            PaymentHandler.settlePayment(paymentIDList[0]);
            /*if(!Test.isRunningTest()){
                PaymentHandler.linkPaymentToCLA(paymentIDList[0]);
                PaymentHandler.settlePayment(paymentIDList[0]);
            }*/
            
        }
    }
}