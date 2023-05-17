public with sharing class CLInvoice {

    @AuraEnabled
    public static string createOMBPInvoice(Object json_ob){
        try {
            System.debug('createOMBPInvoice json_ob='+json_ob);
            Invoice__c inv1 = new Invoice__c();
            Invoice_Line__c invl = new Invoice_Line__c();
            String json_string = Json.serialize(json_ob);
            Map<String, Object> untyped_instance = (Map<String, Object>)JSON.deserializeUntyped(json_string);
            Date approve_date = Date.valueOf((String)untyped_instance.get('Approve_Date__c'));
            Date dueDate = approve_date.addDays(14);
            String acc_id = (String)untyped_instance.get('account');
            String buyer_code =  (String)untyped_instance.get('Buyer_Code__c');
            String buyer_country = (String)untyped_instance.get('Buyer_Country__c');
            List<List_Storage__c> ccodelist = fieldMappingTranslation.get_country_code_all();
            String byrctry;
            String legacy_ref_no = untyped_instance.containsKey('Legacy_Ref_No__c')?(String)untyped_instance.get('Legacy_Ref_No__c'):'';

            for (List_Storage__c ccode : ccodeList){
                if(ccode.List_Type__c == 'Buyer Country' && ccode.ByrCtry_Country_Name__c.equalsIgnoreCase(buyer_country)){
                    byrctry = ccode.ByrCtry_Country_Code__c;
                    break;
                }
            }
            buyer_code = byrctry + buyer_code;
            Decimal invlAmnt = Decimal.valueOf((String)untyped_instance.get('CL_Amount__c'));
            // Decimal prem_amnt = (invlAmnt*(0.64/100)).setScale(2);
            Decimal prem_amnt = 0;
            string premium = (String)untyped_instance.get('Premium__c');
            if(premium!=null){
                premium = premium.replace(',','');
                prem_amnt = Decimal.valueOf(premium);
            }
            String policy_id = (String)untyped_instance.get('policy_id');
            Policy__c policy_detail = [select Id,Is_Charge_Deposit_Applied__c,Product__c from Policy__c where Id=:policy_id];
            List<Invoice__c> inv = [select Id from Invoice__c where Account__c=:acc_id and (Status__c='Open' or Status__c='UnPaid') LIMIT 1];
            System.debug('inv='+inv);
            if(inv.size()>0) {                
                invl.Invoice__c = inv[0].Id;
                invl.Buyer_s_Code__c = buyer_code;
                invl.Credit_Limit_Application__c = (String)untyped_instance.get('Id');
                invl.Currency_Code__c = 'HKD';
                invl.Net_Premium__c = prem_amnt;
                invl.Premium__c = prem_amnt;
                invl.Premium_Due_Date__c = dueDate;
                invl.Legacy_Ref_No__c = legacy_ref_no;
                invl.Product__c=policy_detail.Product__c;
                insert invl;
                //-------Invoice line for charge deposit
                System.debug('Is_Charge_Deposit_Applied__c='+policy_detail.Is_Charge_Deposit_Applied__c);
                if(!policy_detail.Is_Charge_Deposit_Applied__c) {
                    ECIC_Settings__c settings = ECIC_Settings.getEcicSettings();
                        if(settings!= null && settings.Charge_Deposit__c!=null && settings.Charge_Deposit__c>0){
                            Invoice_Line__c invLine = new Invoice_Line__c();
                                //invLine.Premium_Cycle__c='Initial Payment';
                            DateTime cd = System.now().addMonths(1);
                            invLine.Premium_Due_Date__c = dueDate;
                            invLine.Product__c=policy_detail.Product__c;
                            invLine.Gross_Invoice_Value__c=settings.Charge_Deposit__c;
                            invLine.Net_Premium__c = settings.Charge_Deposit__c;
                            invLine.Premium__c = settings.Charge_Deposit__c;
                            invLine.Description__c='Charge Deposit Amount';
                            invLine.Type__c='Charge Deposit';
                            invLine.Invoice__c = inv[0].Id;   
                            insert invLine;
                            System.debug('charge deposit inv line='+invLine) ;
                            Policy__c policy = new Policy__c(
                                Id=policy_id,
                                Is_Charge_Deposit_Applied__c=true
                            );
                            update policy;
                        }
                }
            } else {
                System.debug('Else part');
                System.debug('account='+(String)untyped_instance.get('account'));
                System.debug('policy_id='+(String)untyped_instance.get('policy_id'));
                inv1.Account__c = (String)untyped_instance.get('account');
                inv1.Policy__c = (String)untyped_instance.get('policy_id');
                inv1.Due_Date__c = dueDate;            
                inv1.Invoice_Date__c = Date.today();
                inv1.Status__c = 'UnPaid';
                insert inv1;
                invl.Invoice__c = inv1.Id;
                invl.Buyer_s_Code__c = buyer_code;
                invl.Credit_Limit_Application__c = (String)untyped_instance.get('Id');
                invl.Currency_Code__c = 'HKD';
                invl.Net_Premium__c = prem_amnt;
                invl.Premium__c = prem_amnt;
                invl.Premium_Due_Date__c = dueDate;
                invl.Legacy_Ref_No__c = legacy_ref_no;
                invl.Product__c=policy_detail.Product__c;
                insert invl;
                //-------Invoice line for charge deposit
                System.debug('Is_Charge_Deposit_Applied__c='+policy_detail.Is_Charge_Deposit_Applied__c);
                if(!policy_detail.Is_Charge_Deposit_Applied__c) {
                    ECIC_Settings__c settings = ECIC_Settings.getEcicSettings();
                        if(settings!= null && settings.Charge_Deposit__c!=null && settings.Charge_Deposit__c>0){
                            Invoice_Line__c invLine = new Invoice_Line__c();
                            DateTime cd = System.now().addMonths(1);
                            invLine.Premium_Due_Date__c = dueDate;
                            invLine.Product__c=policy_detail.Product__c;
                            invLine.Gross_Invoice_Value__c=settings.Charge_Deposit__c;
                            invLine.Net_Premium__c = settings.Charge_Deposit__c;
                            invLine.Description__c='Charge Deposit Amount';
                            invLine.Type__c='Charge Deposit';
                            invLine.Invoice__c = inv1.Id;   
                            insert invLine;
                            Policy__c policy = new Policy__c(
                                Id=policy_id,
                                Is_Charge_Deposit_Applied__c=true
                            );
                            update policy;                     
                        }
                    }
            }
            Credit_Limit_Application__c cla = new Credit_Limit_Application__c(
                Id = (String)untyped_instance.get('Id'),
                CL_Status__c = 'Waiting for payment',
                CL_Effective_Date__c = Date.today(),
                Expiry_Date__c = Date.today().addDays(90)
            );
            update cla;
            return String.valueOf(invl.Id);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled    
    public static string createSBPInvoice(Object json_ob){
        try {
           
            Invoice__c inv1 = new Invoice__c();
            Invoice_Line__c invl = new Invoice_Line__c();
            Date dueDate = Date.today().addMonths(1);
            String json_string = Json.serialize(json_ob);
            System.debug('json_string='+json_string);
            Map<String, Object> untyped_instance = (Map<String, Object>)JSON.deserializeUntyped(json_string);
            String acc_id = (String)untyped_instance.get('account');
            List<Invoice__c> inv = [select Id from Invoice__c where Account__c=:acc_id and (Status__c='Open' or Status__c='UnPaid') LIMIT 1];
            if(inv.size() > 0) {
                Decimal invlAmnt = (Decimal)untyped_instance.get('amount');
                invl.Invoice__c = inv[0].Id;
                //invl.Buyer_s_Code__c = (String)untyped_instance.get('Buyer_Code__c');
                invl.Credit_Limit_Application__c = (String)untyped_instance.get('cla_id');
                invl.Currency_Code__c = 'HKD';
                invl.Net_Premium__c = invlAmnt;
                invl.Premium_Due_Date__c = dueDate;
                insert invl;
            } else {
                
                inv1.Account__c = (String)untyped_instance.get('account');
                inv1.Policy__c = (String)untyped_instance.get('policy_id');
                inv1.Due_Date__c = dueDate;            
                inv1.Invoice_Date__c = Date.today();
                inv1.Status__c = 'UnPaid';
                insert inv1;
                Decimal invlAmnt = (Decimal)untyped_instance.get('amount');
                invl.Invoice__c = inv1.Id;
                //invl.Buyer_s_Code__c = (String)untyped_instance.get('Buyer_Code__c');
                invl.Credit_Limit_Application__c = (String)untyped_instance.get('cla_id');
                invl.Currency_Code__c = 'HKD';
                invl.Net_Premium__c = invlAmnt;
                invl.Premium_Due_Date__c = dueDate;
                insert invl;
            }
            String policy_id = (String)untyped_instance.get('policy_id');
            Decimal used_credit_check = (Decimal)untyped_instance.get('Used_Credit_check__c');
            Policy__c policy = new Policy__c(Id=policy_id);
            policy.Used_Credit_check__c = used_credit_check + 1;
            policy.Paid_Credit_Check__c = 1;
            update policy;
            return String.valueOf(invl.Id);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public CLInvoice() {

    }
}