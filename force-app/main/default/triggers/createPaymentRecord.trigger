trigger createPaymentRecord on Invoice__c (before update,before insert) {
    
    if (Trigger.isBefore) {
        //List<Payment__c> payList = new List<Payment__c>();
        /*if (Trigger.isInsert) {
            for (Invoice__c inv : Trigger.new) {
                if(inv.Status__c.equals('Paid')){
                    Payment__c pay = new Payment__c();
                    pay.Status__c='Approved';
                    pay.Account__c=inv.Account__c;
                    pay.Invoice__c=inv.id;
                    pay.Amount__c=inv.Total_Net_Premium_Amount__c;
                    pay.Payment_Date__c = System.now();
                    insert pay;
                    System.debug('Payment Record Created SuccessFully!!! ');
                }
            }
        }*/
        if (Trigger.isUpdate) {
            
            for (Invoice__c inv : Trigger.new) {
                Invoice__c invObj = Trigger.oldMap.get(inv.id);
                if(inv.Status__c.equals('Paid') && (invObj.Status__c.equals('UnPaid'))){
                    Payment__c pay = new Payment__c();
                    pay.Status__c='Approved';
                    pay.Account__c=inv.Account__c;
                    pay.Invoice__c=inv.id;
                    pay.Amount__c=inv.Total_Net_Premium_Amount__c;
                    pay.Payment_Date__c = System.now();
                    //payList.add(pay);
                    insert pay;
                    System.debug('Payment Record Created SuccessFully!!! ');
                }
            }
        }
        /*if(payList != null && !payList.isEmpty()){
            insert payList;
            System.debug('Payment Record Created SuccessFully!!! ');
        }*/
    }
    
}