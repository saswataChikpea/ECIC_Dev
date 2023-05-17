public with sharing class CreateSUPInvoice {

    @AuraEnabled
    public static Policy__c getPolicyDetails(String policyID){
        System.debug('getPolicyDetails policyID : '+policyID);
        Policy__c polObj;
        try {
            polObj = [select id,name,Invoiced__c from Policy__c where id =:policyID];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        System.debug('polObj : '+polObj);
        return polObj;
    }

    public class WrapperResponse{
        @AuraEnabled
        public boolean isSuccess{get;set;}
        @AuraEnabled
        public String responseMsg{get;set;}
    }

    @AuraEnabled
    public static WrapperResponse createInvoiceForSUP(Id policyID){
        System.debug('createInvoiceForSUP :::'+policyID);
        WrapperResponse wresponseObj=new WrapperResponse();
        wresponseObj.isSuccess =false;
        Policy_Schedule__c polSch;
        List<Policy__c> updatePolicyList = new List<Policy__c>();
        List<Invoice__c> invList = new List<Invoice__c>();
        List<Invoice_Line__c> invLineList = new List<Invoice_Line__c>();
        List<Invoice_Line__c> insertInvLineList = new List<Invoice_Line__c>();
        Double calculatedPremium; 
        try {
            Policy__c polObj = [select id,name,Invoiced__c,Exporter__c,Product__c,Invoiced_Date__c,Commencement_Date__c,
            Is_Charge_Deposit_Applied__c
             from Policy__c where id =:policyID];
            System.debug('polObj : '+polObj.Invoiced__c+' '+!polObj.Invoiced__c+' '+polObj.Commencement_Date__c+' cd : '+polObj.Is_Charge_Deposit_Applied__c);
            if(!polObj.Invoiced__c){
                System.debug('Proceed to Create Invoice!!!');
                
                polSch = [select id,name,Payment_Type__c,Maximum_Liability__c,Base_Rate_Per_Anum__c,Percentage_of_Indemnity__c,
                Non_Qualifying_Loss_Amount__c
                 from  Policy_Schedule__c where Policy__c =:policyID  and Type__c='Schedule 1' ];
                System.debug('polSch ==>'+polSch);
                calculatedPremium = calculateThePremium(polSch);
                if(!polObj.Is_Charge_Deposit_Applied__c  && polObj.Commencement_Date__c!= null){
                    DateTime commDate = System.now();
                    Date todayDate = date.newinstance(commDate.year(), commDate.month(), commDate.day());
                    Integer daysBetween = polObj.Commencement_Date__c.daysBetween(todayDate);
                    System.debug('daysBetween : '+daysBetween);
                    if(daysBetween<365){
                        //add the charge deposit
                        ECIC_Settings__c settings = ECIC_Settings.getEcicSettings();
                        if(settings!= null && settings.Charge_Deposit__c!=null && settings.Charge_Deposit__c>0){
                            //Create  charge deposit invoice
                            Invoice__c chargeDepositInvoice = new Invoice__c();
                            chargeDepositInvoice.Account__c = polObj.Exporter__c;
                            chargeDepositInvoice.Policy__c = polObj.id;
                            chargeDepositInvoice.Premium__c = settings.Charge_Deposit__c;
                            chargeDepositInvoice.Invoice_Date__c = Date.valueOf(System.now());
                            DateTime dT = System.now();
                            chargeDepositInvoice.Due_Date__c = Date.valueOf(System.now().addYears(1));//Date.newInstance(dT.year(), dT.month(), dT.day());
                            chargeDepositInvoice.Status__c = 'UnPaid';
                            insert chargeDepositInvoice;
                            System.debug('chargeDepositInvoice inserted');

                            Invoice_Line__c invLine = new Invoice_Line__c();
                            //invLine.Premium_Cycle__c='Initial Payment';
                            DateTime cd = System.now().addMonths(3);
                            invLine.Premium_Due_Date__c = Date.newInstance(cd.year(), cd.month(), cd.day());
                            invLine.Product__c=polObj.Product__c;
                            invLine.Gross_Invoice_Value__c = settings.Charge_Deposit__c;
                            invLine.Premium__c = settings.Charge_Deposit__c;
                            invLine.Net_Premium__c = settings.Charge_Deposit__c;
                            invLine.Description__c='Charge Deposit Amount';
                            invLine.Type__c='Charge Deposit';
                            invLine.Invoice__c = chargeDepositInvoice.id;
                            insert invLine;
                            System.debug('Charge deposit in line inserted');
                            //invLineList.add(invLine);
                            if(!polObj.Is_Charge_Deposit_Applied__c){
                                polObj.Is_Charge_Deposit_Applied__c=true;
                                //updatePolicyList.add();
                            }
                        }
                    }
                }
               
                if(polSch.Payment_Type__c.equals('One-Off')){
                    //Create invoice
                    Invoice__c oneOffInvoice = new Invoice__c();
                    oneOffInvoice.Account__c = polObj.Exporter__c;
                    oneOffInvoice.Policy__c = polObj.id;
                    oneOffInvoice.Premium__c = calculatedPremium;
                    oneOffInvoice.Invoice_Date__c = Date.valueOf(System.now());
                    //DateTime dT1 = System.now();
                    oneOffInvoice.Due_Date__c = Date.valueOf(System.now().addYears(1));//Date.newInstance(dT.year(), dT.month(), dT.day());
                    oneOffInvoice.Status__c = 'UnPaid';
                    insert oneOffInvoice;
                    System.debug('oneOffInvoice inserted');
                    //end invoice
                    Invoice_Line__c invLine = new Invoice_Line__c();
                    //invLine.Premium_Cycle__c='Initial Payment';
                    DateTime dT = System.now().addMonths(3);
                    invLine.Premium_Due_Date__c = Date.newInstance(dT.year(), dT.month(), dT.day());
                    invLine.Product__c=polObj.Product__c;
                    invLine.Gross_Invoice_Value__c=calculatedPremium;
                    invLine.Net_Premium__c=calculatedPremium;
                    invLine.Invoice__c = oneOffInvoice.id;
                    insert invLine;
                    System.debug('one off invoice line created :');
                    //invLineList.add(invLine);
                    System.debug('InvoiceLine Created Succefully!!! ');
                    wresponseObj.isSuccess = true;
                    wresponseObj.responseMsg ='Invoice Created Successfully.';
                    polObj.Invoiced__c=true;
                    polObj.Invoiced_Date__c = System.now();
                    // if(!polObj.Is_Charge_Deposit_Applied__c){
                    //     polObj.Is_Charge_Deposit_Applied__c=true;
                    // }
                    //update polObj;
                    updatePolicyList.add(polObj);
                            
                }else if(polSch.Payment_Type__c.equals('Quarterly')){
                    if(polSch.Maximum_Liability__c !=null && polSch.Maximum_Liability__c>0){
                        //Create  first invoice
                        Invoice__c firstInstallmenetInvoice = new Invoice__c();
                        firstInstallmenetInvoice.Account__c = polObj.Exporter__c;
                        firstInstallmenetInvoice.Policy__c = polObj.id;
                        firstInstallmenetInvoice.Premium__c = calculatedPremium/4;
                        firstInstallmenetInvoice.Invoice_Date__c = Date.valueOf(System.now());
                        //DateTime dT = System.now();
                        firstInstallmenetInvoice.Due_Date__c = Date.valueOf(System.now().addYears(1));//Date.newInstance(dT.year(), dT.month(), dT.day());
                        firstInstallmenetInvoice.Status__c = 'UnPaid';
                        insert firstInstallmenetInvoice;
                        System.debug('firstInstallmenetInvoice inserted');
                        //end invoice
                        Invoice_Line__c invLine1 = new Invoice_Line__c();
                        invLine1.Premium_Cycle__c='Initial Payment';
                        invLine1.Gross_Invoice_Value__c=calculatedPremium/4;
                        invLine1.Line_Amount__c=calculatedPremium/4;
                        invLine1.Product__c=polObj.Product__c;
                        DateTime dT = System.now();
                        invLine1.Premium_Due_Date__c = Date.newInstance(dT.year(), dT.month(), dT.day());
                        invLine1.Net_Premium__c=calculatedPremium/4;
                        invLine1.Invoice__c = firstInstallmenetInvoice.id;
                        insert invLine1;
                        System.debug('invLine1 inserted');
                        
                        //invLineList.add(invLine1);
                        //Create second invoice
                        Invoice__c secondInstallmenetInvoice = new Invoice__c();
                        secondInstallmenetInvoice.Account__c = polObj.Exporter__c;
                        secondInstallmenetInvoice.Policy__c = polObj.id;
                        secondInstallmenetInvoice.Premium__c = calculatedPremium/4;
                        secondInstallmenetInvoice.Invoice_Date__c = Date.valueOf(System.now());
                        //DateTime dT = System.now();
                        secondInstallmenetInvoice.Due_Date__c = Date.valueOf(System.now().addYears(1));//Date.newInstance(dT.year(), dT.month(), dT.day());
                        secondInstallmenetInvoice.Status__c = 'UnPaid';
                        insert secondInstallmenetInvoice;
                        System.debug('secondInstallmenetInvoice inserted');
                        //end invoice

                        Invoice_Line__c invLine2 = new Invoice_Line__c();
                        invLine2.Premium_Cycle__c='2nd Payment';
                        invLine2.Gross_Invoice_Value__c=calculatedPremium/4;
                        invLine2.Line_Amount__c=calculatedPremium/4;
                        invLine2.Product__c=polObj.Product__c;
                        DateTime dT2 = System.now().addMonths(3);
                        invLine2.Premium_Due_Date__c = Date.newInstance(dT2.year(), dT2.month(), dT2.day());
                        invLine2.Net_Premium__c=calculatedPremium/4;
                        invLine2.Invoice__c = secondInstallmenetInvoice.id;
                        insert invLine2;
                        System.debug('invLine2 inserted');
                        //invLineList.add(invLine2);

                        //Create third invoice
                        Invoice__c thirdInstallmenetInvoice = new Invoice__c();
                        thirdInstallmenetInvoice.Account__c = polObj.Exporter__c;
                        thirdInstallmenetInvoice.Policy__c = polObj.id;
                        thirdInstallmenetInvoice.Premium__c = calculatedPremium/4;
                        thirdInstallmenetInvoice.Invoice_Date__c = Date.valueOf(System.now());
                        //DateTime dT = System.now();
                        thirdInstallmenetInvoice.Due_Date__c = Date.valueOf(System.now().addYears(1));//Date.newInstance(dT.year(), dT.month(), dT.day());
                        thirdInstallmenetInvoice.Status__c = 'UnPaid';
                        insert thirdInstallmenetInvoice;
                        System.debug('thirdInstallmenetInvoice inserted');
                        //end invoice

                        Invoice_Line__c invLine3 = new Invoice_Line__c();
                        invLine3.Premium_Cycle__c='3rd Payment';
                        invLine3.Gross_Invoice_Value__c=calculatedPremium/4;
                        invLine3.Line_Amount__c=calculatedPremium/4;
                        invLine3.Product__c=polObj.Product__c;
                        DateTime dT3 = System.now().addMonths(6);
                        invLine3.Premium_Due_Date__c = Date.newInstance(dT3.year(), dT3.month(), dT3.day());
                        invLine3.Net_Premium__c=calculatedPremium/4;
                        invLine3.Invoice__c = thirdInstallmenetInvoice.id;
                        insert invLine3;
                        System.debug('invLine3 inserted');
                        //invLineList.add(invLine3);

                        //Create third invoice
                        Invoice__c fourthInstallmenetInvoice = new Invoice__c();
                        fourthInstallmenetInvoice.Account__c = polObj.Exporter__c;
                        fourthInstallmenetInvoice.Policy__c = polObj.id;
                        fourthInstallmenetInvoice.Premium__c = calculatedPremium/4;
                        fourthInstallmenetInvoice.Invoice_Date__c = Date.valueOf(System.now());
                        //DateTime dT = System.now();
                        fourthInstallmenetInvoice.Due_Date__c = Date.valueOf(System.now().addYears(1));//Date.newInstance(dT.year(), dT.month(), dT.day());
                        fourthInstallmenetInvoice.Status__c = 'UnPaid';
                        insert fourthInstallmenetInvoice;
                        System.debug('fourthInstallmenetInvoice inserted');
                        //end invoice

                        Invoice_Line__c invLine4 = new Invoice_Line__c();
                        invLine4.Premium_Cycle__c='Final Payment';
                        invLine4.Gross_Invoice_Value__c=calculatedPremium/4;
                        invLine4.Line_Amount__c=calculatedPremium/4;
                        invLine4.Product__c=polObj.Product__c;
                        DateTime dT4 = System.now().addMonths(9);
                        invLine4.Premium_Due_Date__c = Date.newInstance(dT4.year(), dT4.month(), dT4.day());
                        invLine4.Net_Premium__c=calculatedPremium/4;
                        invLine4.Invoice__c = fourthInstallmenetInvoice.id;
                        insert invLine4;
                        System.debug('invLine4 inserted');
                        //invLineList.add(invLine4); 
                        wresponseObj.isSuccess = true;
                        wresponseObj.responseMsg ='Invoice Created Successfully.';
                        polObj.Invoiced__c=true;
                        polObj.Invoiced_Date__c = System.now(); 
                        updatePolicyList.add(polObj);
                    }
                }
            }else{
                System.debug('Invoice Aleady Exist ');
                wresponseObj.responseMsg ='Invoice Aleady Exist';
            }
            if(updatePolicyList !=null && !updatePolicyList.isEmpty()){
                update updatePolicyList;
                System.debug('Policy updated sucessfully.');

            }
            // if(invLineList != null && !invLineList.isEmpty()){
            //     Invoice__c inserInvoice = new Invoice__c();
            //     inserInvoice.Account__c = polObj.Exporter__c;
            //     inserInvoice.Policy__c = polObj.id;
            //     inserInvoice.Premium__c = calculatedPremium;
            //     inserInvoice.Invoice_Date__c = Date.valueOf(System.now());
            //     DateTime dT = System.now();
            //     inserInvoice.Due_Date__c = Date.valueOf(System.now().addYears(1));//Date.newInstance(dT.year(), dT.month(), dT.day());
            //     inserInvoice.Status__c = 'UnPaid';
            //     invList.add(inserInvoice);
            //     Database.SaveResult[] SR = Database.insert(invList, False);
            //     for(Integer i=0;i<SR.size();i++){
            //         System.debug('sr '+SR[i]);
            //         if(SR[i].isSuccess()){
            //             System.debug('Invoice Created Succefully!!! ');
            //             for(Invoice__c inv :invList){
            //                 for(Invoice_Line__c invLine :invLineList){
            //                     invLine.Invoice__c = inv.id;
            //                     insertInvLineList.add(invLine);
            //                 }
            //             }
            //             if(insertInvLineList != null && !insertInvLineList.isEmpty()){
            //                 insert insertInvLineList;
            //                 System.debug('InvoiceLine Created Succefully!!! ');
            //                 wresponseObj.isSuccess = true;
            //                 wresponseObj.responseMsg ='Invoice Created Successfully.';
            //                 polObj.Invoiced__c=true;
            //                 polObj.Invoiced_Date__c = System.now();
            //                 if(!polObj.Is_Charge_Deposit_Applied__c){
            //                     polObj.Is_Charge_Deposit_Applied__c=true;
            //                 }
            //                 update polObj;
                            
            //             }
            //         }
            //     }
            // }
        } catch (Exception e) {
            System.debug('Exception at : '+e.getMessage()+':'+e.getStackTraceString());
            wresponseObj.responseMsg =e.getMessage()+':'+e.getStackTraceString();
            throw new AuraHandledException(e.getMessage());
        }
        System.debug('wresponseObj ::'+wresponseObj);
        return wresponseObj;
    }

    public static Double calculateThePremium(Policy_Schedule__c polSch){
        System.debug('calculateThePremium the Priumum : Maximum Liability:'+polSch.Maximum_Liability__c+' Base Rate:'+polSch.Base_Rate_Per_Anum__c+' Percentage Of Idemnity : '+polSch.Percentage_of_Indemnity__c+' NQL :'+polSch.Non_Qualifying_Loss_Amount__c);
        Double calculatedPremium;
        if(polSch.Maximum_Liability__c != null && polSch.Maximum_Liability__c>0 && polSch.Base_Rate_Per_Anum__c>0){
            /*Double percentageOfIndemnityValue = 0;
            if(polSch.Percentage_of_Indemnity__c == 80.00){
                percentageOfIndemnityValue = 0;
            }else if(polSch.Percentage_of_Indemnity__c == 70.00){
                percentageOfIndemnityValue = 10;
            }else if(polSch.Percentage_of_Indemnity__c == 60.00){
                percentageOfIndemnityValue = 20;
            }else if(polSch.Percentage_of_Indemnity__c == 50.00){
                percentageOfIndemnityValue = 30;
            }*/

            
            //System.debug('percentageOfIndemnityValue : '+percentageOfIndemnityValue);
            /*Double nql;
            if(polSch.Non_Qualifying_Loss_Amount__c == 10000.00){
                nql = 5;
            }else if(polSch.Non_Qualifying_Loss_Amount__c == 30000.00){
                nql = 7.5;

            }*/
            //System.debug('nql : '+nql);
           
            
            calculatedPremium = polSch.Maximum_Liability__c * (polSch.Base_Rate_Per_Anum__c/100) * (1-(polSch.Percentage_of_Indemnity__c/100) - (polSch.Non_Qualifying_Loss_Amount__c/100));
            
        }
        System.debug('calculatedPremium '+calculatedPremium);
        return calculatedPremium;
    }
    
}