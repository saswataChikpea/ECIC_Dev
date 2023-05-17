public with sharing class CreateSBPInvoice {

    public class WrapperResponse{
        @AuraEnabled
        public boolean isSuccess{get;set;}
        @AuraEnabled
        public String responseMsg{get;set;}
    }
    /*@AuraEnabled
    public static WrapperResponse createInvoiceForSBP(Id policyID){
        System.debug('createInvoiceForSUP :::'+policyID);
        WrapperResponse wresponseObj=new WrapperResponse();
        wresponseObj.isSuccess =false;
        Map<String,String> buyerCodeVsBuyerCountryMap = new Map<String,String>();
        Map<String,String> buyerCountrysGradeVMap = new Map<String,String>();
        String paymentTerm;
        Decimal finalLoading;
        Decimal exclusionRisk;
        String finalLoadingInText;
        List<Invoice__c> invList = new List<Invoice__c>();
        List<Invoice_Line__c> invLineList = new List<Invoice_Line__c>();
        List<Invoice_Line__c> insertInvLineList = new List<Invoice_Line__c>();
        List<Policy__c> updatePolicyList = new List<Policy__c>();
        Map<Id,List<Invoice_Line__c>> policyIdInvLineMap = new Map<Id,List<Invoice_Line__c>>();
        //Decimal nql;
        try {
            Policy_Schedule__c policySchedule = [select Base_Loading__c , Non_Qualifying_Loss_Amount__c, Exclusion_of_Risk__c,
            Percentage_of_Indemnity__c from Policy_Schedule__c where Policy__c =:policyID and Type__c='Schedule 1' ];
            if(policySchedule != null && policySchedule.Exclusion_of_Risk__c != null && policySchedule.Base_Loading__c != null && policySchedule.Percentage_of_Indemnity__c != null){
                exclusionRisk = policySchedule.Exclusion_of_Risk__c == 'Country Risk' ? -5 : policySchedule.Exclusion_of_Risk__c == 'Repudiation Risk	' ? -10 : 0;
                finalLoading = Integer.valueOf(policySchedule.Base_Loading__c) + policySchedule.Percentage_of_Indemnity__c  + exclusionRisk;
            }
            if(policySchedule.Non_Qualifying_Loss_Amount__c != null){
                System.debug('NQL is there');
                finalLoading = finalLoading + policySchedule.Non_Qualifying_Loss_Amount__c;
            }
             
            System.debug('exclusionRisk : '+exclusionRisk+' finalLoading:'+String.valueOf(finalLoading)+' finalLoadingInText:'+finalLoadingInText);
             
            List<Credit_Limit__c> creditLimitList = [select id,Buyer_Code__c,Buyer_Country__c from Credit_Limit__c where Policy__c =:policyID];
            if(creditLimitList != null && !creditLimitList.isEmpty()){
                for(Credit_Limit__c cl : creditLimitList){
                    buyerCodeVsBuyerCountryMap.put(cl.Buyer_Code__c,cl.Buyer_Country__c);
                }
            }else{
                System.debug('No Credit Limit Exist.');
                List<Credit_Limit_Application__c> claList = [select id,Buyer_Code__c,Buyer_Country__c from Credit_Limit_Application__c where Policy__c =:policyID];
                if(claList != null && !claList.isEmpty()){
                    for(Credit_Limit_Application__c cla : claList){
                        buyerCodeVsBuyerCountryMap.put(cla.Buyer_Code__c,cla.Buyer_Country__c);
                    }
                }else{
                    System.debug('No Credit Limit Application Exist.');
                }
            }
            System.debug('buyerCodeVsBuyerCountryMap : '+buyerCodeVsBuyerCountryMap);
            if(buyerCodeVsBuyerCountryMap != null && !buyerCodeVsBuyerCountryMap.isEmpty()){
                List<Country__mdt> countryList = GetCustomMetaData.getCountryList();
                for(Country__mdt c : countryList){
                    if(c.Grade__c!=null && c.Grade__c.equals('A')){
                        buyerCountrysGradeVMap.put(c.CTRY_CTRY_NAME__c,'GRADE_A');
                    }else if(c.Grade__c!=null && c.Grade__c.equals('B')){
                        buyerCountrysGradeVMap.put(c.CTRY_CTRY_NAME__c,'GRADE_BC');
                    }else if(c.Grade__c!=null && c.Grade__c.equals('C')){
                        buyerCountrysGradeVMap.put(c.CTRY_CTRY_NAME__c,'GRADE_BC');
                    }
                }
            }
            System.debug('buyerCountrysGradeVMap : '+buyerCountrysGradeVMap);
            System.debug('buyerCountrysGradeVMap check : '+buyerCountrysGradeVMap.containsKey('AUSTRALIA')+' Value :'+buyerCountrysGradeVMap.get('AUSTRALIA'));
            List<Dynamic_Price__c> priceList = new List<Dynamic_Price__c>();
            priceList= [select Id, Name, Base_Rate_Per_Anum__c, Base_Rate_Per_Quarter__c, Credit_Limit__c,
                Indemnity_Ratio__c, Maximum_Liability__c, Non_Qualify_Loss__c, Premium_Rate_On__c, Product__c,
                DP__c, DA_OA_0_30__c, DA_OA_31_60__c, DA_OA_61_90__c, DA_OA_91_180__c ,Loading__c,Country_Grade__c
                from Dynamic_Price__c where Price_Book__r.Active__c = true ];

            DateTime dT1 = System.now();
            Date FirstDayOfTheMonth = Date.newInstance(dT1.year(), dT1.month(), 1);
            Date TwentySixthDayOfTheMonth = Date.newInstance(dT1.year(), dT1.month(), 26);
            System.debug('FirstDayOfTheMonth : '+FirstDayOfTheMonth+' TwentySixthDayOfTheMonth:'+TwentySixthDayOfTheMonth);

            List<Policy__c> policyList = [select id,name, Exporter__c,Product__c,
                (select id,name,Buyer_Name__c,Buyer_Code__c,createdDate,Gross_Invoice_Value__c,Pre_Shipment_Declaration__c,
                Due_Date__c,Endorsement__c,Shipment_was_made_by_anoverseas_subsidia__c,Policyholder_Reference_No__c,
                Shipment_Date__c,Currency__c,Payment_Term_Type__c,Payment_Term_Days__c,Type__c,Harmonized_Code__c,
                Port_of_Loading_Ship_From__c,Destination_Country_Market_Ship_to__c,Country_of_Origin__c,Status__c,
                Invoice_Date__c from Shipment_Declarations__r  where CreatedDate >= :FirstDayOfTheMonth and 
                CreatedDate <= :TwentySixthDayOfTheMonth and Status__c = 'Settled' ) //where Status__c='Settled'
                from Policy__c where  id =:policyID];

            
            for(Policy__c pol : policyList){
                Invoice__c inserInvoice = new Invoice__c();
                inserInvoice.Account__c = pol.Exporter__c;
                inserInvoice.Policy__c = pol.id;
                inserInvoice.Status__c = 'UnPaid';
                invList.add(inserInvoice);

                pol.Invoiced__c=true;
                pol.Invoiced_Date__c = System.now();
                updatePolicyList.add(pol);

                for(Shipment_Declaration__c shipDec : pol.Shipment_Declarations__r){
                    Decimal preimumRate;
                    System.debug('shipDec id : '+shipDec.id+' name : '+shipDec.name+' Port '+shipDec.Port_of_Loading_Ship_From__c.toUpperCase());
                    if(shipDec.Payment_Term_Type__c.equals('DP')){
                        paymentTerm = shipDec.Payment_Term_Type__c;
                    }else if( (shipDec.Payment_Term_Type__c.equals('DA')) || (shipDec.Payment_Term_Type__c.equals('OA')) ){
                        if(shipDec.Payment_Term_Days__c >=0 && shipDec.Payment_Term_Days__c<31){
                            paymentTerm = 'DA-OA_0-30';
                        }else if(shipDec.Payment_Term_Days__c >30 && shipDec.Payment_Term_Days__c<61){
                            paymentTerm = 'DA-OA_31-60';
                        }else if(shipDec.Payment_Term_Days__c >60 && shipDec.Payment_Term_Days__c<91){
                            paymentTerm = 'DA-OA_61-90';
                        }else if(shipDec.Payment_Term_Days__c >90 && shipDec.Payment_Term_Days__c<91){
                            paymentTerm = 'DA-OA_91-180';
                        }
                    }
                    System.debug('paymentTerm :: '+paymentTerm);
                    if(buyerCountrysGradeVMap.get(shipDec.Port_of_Loading_Ship_From__c.toUpperCase())!=null && buyerCountrysGradeVMap.containsKey(shipDec.Port_of_Loading_Ship_From__c.toUpperCase()) ){
                        //System.debug('Found ======>>>dp.Loading__c : '+dp.Loading__c+' Match :'+dp.Loading__c.equals(String.valueOf(finalLoading.intValue()))+' dp.Country_Grade__c:'+dp.Country_Grade__c+' Key '+buyerCountrysGradeVMap.containsKey(shipDec.Port_of_Loading_Ship_From__c));
                        for(Dynamic_Price__c dp : priceList ){
                            //System.debug('dp.Country_Grade__c : -'+dp.Country_Grade__c+'- Map:'+buyerCountrysGradeVMap.get(shipDec.Port_of_Loading_Ship_From__c.toUpperCase())+'-');
                            if( (dp.Loading__c.equals(String.valueOf(finalLoading.intValue()))) 
                            && (dp.Country_Grade__c.equals(buyerCountrysGradeVMap.get(shipDec.Port_of_Loading_Ship_From__c.toUpperCase())))){
                            System.debug('Matched DPricing==******dp.DP__c : '+dp.DP__c+' dp.DA_OA_0_30__c:'+dp.DA_OA_0_30__c+' dp.DA_OA_31_60__c:'+dp.DA_OA_31_60__c+' dp.DA_OA_61_90__c:'+dp.DA_OA_61_90__c+' dp.DA_OA_91_180__c:'+dp.DA_OA_91_180__c);
                                if(paymentTerm.equals('DP')){
                                    preimumRate = dp.DP__c;
                                    break;
                                }else if(paymentTerm.equals('DA-OA_0-30')){
                                    preimumRate = dp.DA_OA_0_30__c;
                                    break;
                                }else if(paymentTerm.equals('DA-OA_31-60')){
                                    preimumRate = dp.DA_OA_31_60__c;
                                    break;
                                }else if(paymentTerm.equals('DA-OA_61-90')){
                                    preimumRate = dp.DA_OA_61_90__c;
                                    break;
                                }else if(paymentTerm.equals('DA-OA_91-180')){
                                    preimumRate = dp.DA_OA_91_180__c;
                                    break;
                                }
                            }
                        }
                        System.debug('shipDec.Gross_Invoice_Value__c : '+shipDec.Gross_Invoice_Value__c+ ' preimumRate : '+preimumRate);
                        if(preimumRate != null){
                            Decimal calculatePremium = shipDec.Gross_Invoice_Value__c * (preimumRate/100) ;
                            System.debug('calculatePremium : '+calculatePremium);

                            Invoice_Line__c invLine = new Invoice_Line__c();
                            DateTime dT = System.now().addMonths(1);
                            invLine.Premium_Due_Date__c = Date.newInstance(dT.year(), dT.month(), dT.day());
                            invLine.Product__c=pol.Product__c;
                            invLine.Gross_Invoice_Value__c=calculatePremium;
                            invLine.Net_Premium__c=calculatePremium;
                            System.debug('inserInvoice.id ::::'+inserInvoice.id);
                            invLine.Invoice__c=inserInvoice.id;
                            invLineList.add(invLine);
                            policyIdInvLineMap.put(pol.id,invLineList);
                        }
                    }
                    
                }
                if(invLineList != null && !invLineList.isEmpty()){
                    System.debug('invList : '+invList);
                    Database.SaveResult[] SR = Database.insert(invList, False);
                    Map<id,id> polIdVsInvIdMap = new Map<id,id>();
                    for(Invoice__c inv : invList){
                        polIdVsInvIdMap.put(inv.Policy__c,inv.id);
                    }
                    System.debug('polIdVsInvIdMap : '+polIdVsInvIdMap);
                    for(Integer i=0;i<SR.size();i++){
                        System.debug('sr '+SR[i]);
                        if(SR[i].isSuccess()){
                            System.debug('Invoice Created Succefully!!! ');
                            for(Policy__c policy : policyList){
                                for(Invoice_Line__c invLine : policyIdInvLineMap.get(policy.id)){
                                    invLine.Invoice__c = polIdVsInvIdMap.get(policy.id);
                                    insertInvLineList.add(invLine);
                                }
                            }
                            insert insertInvLineList;
                            System.debug('Invoice Line Created Succefully!!! ');
                            update updatePolicyList;
                            System.debug('Policy Updated Succefully!!! ');
                        }
                    }
                }
            }
        }catch(Exception e){
            System.debug('Exception at : '+e.getMessage()+' Stack :'+e.getStackTraceString());
        }
        return wresponseObj;
    }*/
    @AuraEnabled
    public static WrapperResponse createInvoiceForSBP(List<ID> processPolicyList){
        System.debug('createInvoiceForSBP :::'+processPolicyList);
        WrapperResponse wresponseObj=new WrapperResponse();
        wresponseObj.isSuccess =false;
        Map<String,String> buyerNameVsCountryMap = new Map<String,String>();
        Map<String,String> CountrysVsGradeVMap = new Map<String,String>();
        String paymentTerm='';
        Decimal finalLoading;
        Decimal exclusionRisk;
        String finalLoadingInText;
        List<Invoice__c> invList = new List<Invoice__c>();
        List<Invoice__c> cdInvList = new List<Invoice__c>();

        
        
        
        List<Policy__c> updatePolicyList = new List<Policy__c>();
        Map<Id,List<Invoice_Line__c>> policyIdInvLineMap = new Map<Id,List<Invoice_Line__c>>();
        Map<Id,List<Invoice_Line__c>> policyIdInvLineForChargeDepositMap = new Map<Id,List<Invoice_Line__c>>();
        Map<id,Decimal> policyVsFinalLoadingMap = new Map<id,Decimal>();
        List<Shipment_Declaration__c> shipmentList = new List<Shipment_Declaration__c>();
        // List<Invoice_Line__c> invLineForCharegDepositList = new List<Invoice_Line__c>();
        //Decimal nql;
        try {
            List<Policy_Schedule__c> policyScheduleList = [select Policy__c,
            Base_Loading__c, 
            Non_Qualifying_Loss_Amount__c, 
            Exclusion_of_Risk__c,
            Percentage_of_Indemnity__c,
            DP__c,DA_OA_0_30__c,DA_OA_31_60__c,DA_OA_61_90__c,DA_OA_91_120__c,
            DP_NonA__c,DA_OA_0_30_NonA__c,DA_OA_31_60_NonA__c,DA_OA_61_90_NonA__c,DA_OA_91_120_NonA__c

            from Policy_Schedule__c where Policy__c in :processPolicyList and Type__c='Schedule 1' ];
            System.debug('policyScheduleList ::'+policyScheduleList);
            for(Policy_Schedule__c sch :  policyScheduleList){
                if(sch.Base_Loading__c != null && sch.Percentage_of_Indemnity__c!= null && sch.Exclusion_of_Risk__c!=null){
                    exclusionRisk = sch.Exclusion_of_Risk__c == 'Country Risk' ? -5 : sch.Exclusion_of_Risk__c == 'Repudiation Risk' ? -10 : 0;
                    finalLoading = Integer.valueOf(sch.Base_Loading__c) + sch.Percentage_of_Indemnity__c  + exclusionRisk;
                    policyVsFinalLoadingMap.put(sch.Policy__c,finalLoading);
                    if(sch.Non_Qualifying_Loss_Amount__c != null){
                        System.debug('NQL is there');
                        finalLoading = finalLoading + sch.Non_Qualifying_Loss_Amount__c;
                        policyVsFinalLoadingMap.put(sch.Policy__c,finalLoading);
                    }
                }
            }

            System.debug('policyVsFinalLoadingMap : '+policyVsFinalLoadingMap);
            System.debug('exclusionRisk : '+exclusionRisk+' finalLoading:'+String.valueOf(finalLoading)+' finalLoadingInText:'+finalLoadingInText);
            Map<String,Decimal> policyIdVsDPValueMap = new Map<String,Decimal>();
            List<Policy_Schedule__c> policySchedule2List = [select Policy__c,
            Base_Loading__c, 
            Non_Qualifying_Loss_Amount__c, 
            Exclusion_of_Risk__c,
            Percentage_of_Indemnity__c,
            DP__c,DA_OA_0_30__c,DA_OA_31_60__c,DA_OA_61_90__c,DA_OA_91_120__c,
            DP_NonA__c,DA_OA_0_30_NonA__c,DA_OA_31_60_NonA__c,DA_OA_61_90_NonA__c,DA_OA_91_120_NonA__c

            from Policy_Schedule__c where Policy__c in :processPolicyList and Type__c='Schedule 2' ];
            System.debug('policySchedule2List ::'+policySchedule2List);

            for(Policy_Schedule__c sch :  policySchedule2List){
                policyIdVsDPValueMap.put(sch.Policy__c+'_DP',sch.DP__c);
                policyIdVsDPValueMap.put(sch.Policy__c+'_DA_OA_0_30',sch.DA_OA_0_30__c);
                policyIdVsDPValueMap.put(sch.Policy__c+'_DA_OA_31_60',sch.DA_OA_31_60__c);
                policyIdVsDPValueMap.put(sch.Policy__c+'_DA_OA_61_90',sch.DA_OA_61_90__c);
                policyIdVsDPValueMap.put(sch.Policy__c+'_DA_OA_91_120',sch.DA_OA_91_120__c);

                policyIdVsDPValueMap.put(sch.Policy__c+'_DP_NonA',sch.DP_NonA__c);
                policyIdVsDPValueMap.put(sch.Policy__c+'_DA_OA_0_30_NonA',sch.DA_OA_0_30_NonA__c);
                policyIdVsDPValueMap.put(sch.Policy__c+'_DA_OA_31_60_NonA',sch.DA_OA_31_60_NonA__c);
                policyIdVsDPValueMap.put(sch.Policy__c+'_DA_OA_61_90_NonA',sch.DA_OA_61_90_NonA__c);
                policyIdVsDPValueMap.put(sch.Policy__c+'_DA_OA_91_120_NonA',sch.DA_OA_91_120_NonA__c);
            }

            List<Credit_Limit__c> creditLimitList = [select id,Buyer_Name__c,Buyer_Code__c,Buyer_Country__c from Credit_Limit__c where Policy__c =:processPolicyList];
            if(creditLimitList != null && !creditLimitList.isEmpty()){
                for(Credit_Limit__c cl : creditLimitList){
                    buyerNameVsCountryMap.put(cl.Buyer_Name__c,cl.Buyer_Country__c);
                }
            }else{
                System.debug('No Credit Limit Exist.');
                List<Credit_Limit_Application__c> claList = [select id,Buyer_Name__c,Buyer_Code__c,Buyer_Country__c from Credit_Limit_Application__c where Policy__c =:processPolicyList];
                if(claList != null && !claList.isEmpty()){
                    for(Credit_Limit_Application__c cla : claList){
                        buyerNameVsCountryMap.put(cla.Buyer_Name__c,cla.Buyer_Country__c);
                    }
                }else{
                    System.debug('No Credit Limit Application Exist.');
                }
            }
            System.debug('buyerNameVsCountryMap : '+buyerNameVsCountryMap);
            if(buyerNameVsCountryMap != null && !buyerNameVsCountryMap.isEmpty()){
                List<List_Storage__c> countryList = GetCustomMetaData.getCountryList();
                for(List_Storage__c c : countryList){
                    if(c.CTRY_GRADE__c!=null && c.CTRY_GRADE__c.equals('A')){
                        CountrysVsGradeVMap.put(c.CTRY_CTRY_NAME__c,'GRADE_A');
                    }else if(c.CTRY_GRADE__c!=null && c.CTRY_GRADE__c.equals('B')){
                        CountrysVsGradeVMap.put(c.CTRY_CTRY_NAME__c,'GRADE_BC');
                    }else if(c.CTRY_GRADE__c!=null && c.CTRY_GRADE__c.equals('C')){
                        CountrysVsGradeVMap.put(c.CTRY_CTRY_NAME__c,'GRADE_BC');
                    }
                }
            }
            System.debug('CountrysVsGradeVMap : '+CountrysVsGradeVMap);
            //System.debug('buyerCountrysGradeVMap check : '+buyerCountrysGradeVMap.containsKey('ANDORRA')+' Value :'+buyerCountrysGradeVMap.get('AUSTRALIA'));
            List<Dynamic_Price__c> priceList = new List<Dynamic_Price__c>();
            priceList= [select Id, Name, Base_Rate_Per_Anum__c, Base_Rate_Per_Quarter__c, Credit_Limit__c,
                Indemnity_Ratio__c, Maximum_Liability__c, Non_Qualify_Loss__c, Premium_Rate_On__c, Product__c,
                DP__c, DA_OA_0_30__c, DA_OA_31_60__c, DA_OA_61_90__c, DA_OA_91_180__c ,Loading__c,Country_Grade__c
                from Dynamic_Price__c where Price_Book__r.Active__c = true ];

            // DateTime dT1 = System.now();
            // Date FirstDayOfTheMonth = Date.newInstance(dT1.year(), dT1.month(), 1);
            // Date TwentySixthDayOfTheMonth = Date.newInstance(dT1.year(), dT1.month(), 30);
            // System.debug('FirstDayOfTheMonth : '+FirstDayOfTheMonth+' TwentySixthDayOfTheMonth:'+TwentySixthDayOfTheMonth);

            Date firstRange;
            Date scondRange;
            DateTime dT1 = System.now();
            System.debug('dt1 :'+dT1.day());
            if(dT1.day()>26){
                firstRange = Date.newInstance(dT1.year(), dT1.month(), dT1.day());
                if(dT1.month()==1){
                    scondRange = Date.newInstance(dT1.addYears(-1).year(), dT1.addMonths(1).month(), 26);
                }else{
                    scondRange = Date.newInstance(dT1.year(), dT1.addMonths(1).month(), 26);
                }
                
            }else{
                if(dT1.month()==1){
                    firstRange = Date.newInstance(dT1.addYears(-1).year(), dT1.addMonths(-1).month(), 26);
                }else{
                    firstRange = Date.newInstance(dT1.year(), dT1.addMonths(-1).month(), 26);
                }
                scondRange = Date.newInstance(dT1.year(), dT1.month(), 26);
            }
            System.debug('firstRange : '+firstRange+' scondRange:'+scondRange);

            List<Policy__c> policyList = [select id,name, Exporter__c,Product__c,Commencement_Date__c,Is_Charge_Deposit_Applied__c,
                (select id,name,Buyer_Name__c,Buyer_Code__c,createdDate,Gross_Invoice_Value__c,Pre_Shipment_Declaration__c,
                Due_Date__c,Endorsement__c,Shipment_was_made_by_anoverseas_subsidia__c,Policyholder_Reference_No__c,
                Shipment_Date__c,Currency__c,Payment_Term_Type__c,Payment_Term_Days__c,Type__c,Harmonized_Code__c,
                Port_of_Loading_Ship_From__c,Destination_Country_Market_Ship_to__c,Country_of_Origin__c,Status__c,
                Shipment_Month__c,Shipment_Year__c,
                Invoice_Date__c,Policy__c,Invoiced__c,Invoice_Created_Date__c from Shipment_Declarations__r  where CreatedDate >= :firstRange and 
                CreatedDate <= :scondRange and Invoiced__c=false ) 
                from Policy__c where  id in :processPolicyList];

            
            for(Policy__c pol : policyList){
                List<Invoice_Line__c> invLineList = new List<Invoice_Line__c>();
                Invoice__c inserInvoice = new Invoice__c();
                inserInvoice.Account__c = pol.Exporter__c;
                inserInvoice.Policy__c = pol.id;
                inserInvoice.Status__c = 'UnPaid';
                invList.add(inserInvoice);

                /*pol.Invoiced__c=true;
                pol.Invoiced_Date__c = System.now();
                updatePolicyList.add(pol);*/

                for(Shipment_Declaration__c shipDec : pol.Shipment_Declarations__r){
                    Decimal preimumRate;
                    System.debug(pol.name+' shipDec id : '+shipDec.id+' name : '+shipDec.name+' Port '+shipDec.Buyer_Name__c);
                    if(shipDec.Payment_Term_Type__c.equals('DP')){
                        paymentTerm = shipDec.Payment_Term_Type__c;
                    }else if( (shipDec.Payment_Term_Type__c.equals('DA')) || (shipDec.Payment_Term_Type__c.equals('OA')) ){
                        if(shipDec.Payment_Term_Days__c >=0 && shipDec.Payment_Term_Days__c<31){
                            paymentTerm = 'DA-OA_0-30';
                        }else if(shipDec.Payment_Term_Days__c >30 && shipDec.Payment_Term_Days__c<61){
                            paymentTerm = 'DA-OA_31-60';
                        }else if(shipDec.Payment_Term_Days__c >60 && shipDec.Payment_Term_Days__c<91){
                            paymentTerm = 'DA-OA_61-90';
                        }else if(shipDec.Payment_Term_Days__c >90 && shipDec.Payment_Term_Days__c<120){
                            paymentTerm = 'DA-OA_91-120';
                        }
                    }
                    System.debug('paymentTerm :: '+paymentTerm+' buyerNameVsCountryMap:'+buyerNameVsCountryMap);
                    if(buyerNameVsCountryMap != null && buyerNameVsCountryMap.containsKey(shipDec.Buyer_Name__c)){
                        String checkForCountry = buyerNameVsCountryMap.get(shipDec.Buyer_Name__c).toUpperCase();
                        System.debug('checkForCountry ===>>'+checkForCountry);
                        if(CountrysVsGradeVMap.get(checkForCountry)!=null && CountrysVsGradeVMap.containsKey(checkForCountry) ) {
                            System.debug(checkForCountry+' Grade  ===>>'+CountrysVsGradeVMap.get(checkForCountry));
                            if(CountrysVsGradeVMap.get(checkForCountry).equals('GRADE_A')){
                                if(paymentTerm.equals('DP')){
                                    preimumRate = policyIdVsDPValueMap.get(pol.id+'_DP');
                                }else if(paymentTerm.equals('DA-OA_0-30')){
                                    preimumRate = policyIdVsDPValueMap.get(pol.id+'_DA_OA_0_30');
                                }else if(paymentTerm.equals('DA-OA_31-60')){
                                    preimumRate = policyIdVsDPValueMap.get(pol.id+'_DA_OA_31_60');
                                }else if(paymentTerm.equals('DA-OA_61-90')){
                                    preimumRate = policyIdVsDPValueMap.get(pol.id+'_DA_OA_61_90');
                                }else if(paymentTerm.equals('DA-OA_91-120')){
                                    preimumRate = policyIdVsDPValueMap.get(pol.id+'_DA_OA_91_120');
                                }
                            }else if(CountrysVsGradeVMap.get(checkForCountry).equals('GRADE_BC')){
                                if(paymentTerm.equals('DP')){
                                    preimumRate = policyIdVsDPValueMap.get(pol.id+'_DP_NonA');
                                }else if(paymentTerm.equals('DA-OA_0-30')){
                                    preimumRate = policyIdVsDPValueMap.get(pol.id+'_DA_OA_0_30_NonA');
                                }else if(paymentTerm.equals('DA-OA_31-60')){
                                    preimumRate = policyIdVsDPValueMap.get(pol.id+'_DA_OA_31_60_NonA');
                                }else if(paymentTerm.equals('DA-OA_61-90')){
                                    preimumRate = policyIdVsDPValueMap.get(pol.id+'_DA_OA_61_90_NonA');
                                }else if(paymentTerm.equals('DA-OA_91-120')){
                                    preimumRate = policyIdVsDPValueMap.get(pol.id+'_DA_OA_91_120_NonA');
                                }
                            }
                            System.debug('preimumRate==>>'+preimumRate);
                            // for(Dynamic_Price__c dp : priceList ){
                            //     System.debug('dp ==>>'+dp);
                            //     System.debug('policyVsFinalLoadingMap ==>>'+policyVsFinalLoadingMap+' shipDec.Buyer_Name__c:'+shipDec.Buyer_Name__c);
                            //     System.debug('CountrysVsGradeVMap ==>>'+CountrysVsGradeVMap);
                            //     if(policyVsFinalLoadingMap != null && policyVsFinalLoadingMap.containsKey(shipDec.Policy__c)){

                            //         if( (dp.Loading__c.equals(String.valueOf(policyVsFinalLoadingMap.get(shipDec.Policy__c).intValue()))) 
                            //         && (dp.Country_Grade__c.equals(CountrysVsGradeVMap.get(buyerNameVsCountryMap.get(shipDec.Buyer_Name__c).toUpperCase())))){
                            //         System.debug('Matched DPricing==******dp.DP__c : '+dp.DP__c+' dp.DA_OA_0_30__c:'+dp.DA_OA_0_30__c+' dp.DA_OA_31_60__c:'+dp.DA_OA_31_60__c+' dp.DA_OA_61_90__c:'+dp.DA_OA_61_90__c+' dp.DA_OA_91_180__c:'+dp.DA_OA_91_180__c);
                            //             if(paymentTerm.equals('DP')){
                            //                 preimumRate = dp.DP__c;
                            //                 break;
                            //             }else if(paymentTerm.equals('DA-OA_0-30')){
                            //                 preimumRate = dp.DA_OA_0_30__c;
                            //                 break;
                            //             }else if(paymentTerm.equals('DA-OA_31-60')){
                            //                 preimumRate = dp.DA_OA_31_60__c;
                            //                 break;
                            //             }else if(paymentTerm.equals('DA-OA_61-90')){
                            //                 preimumRate = dp.DA_OA_61_90__c;
                            //                 break;
                            //             }else if(paymentTerm.equals('DA-OA_91-180')){
                            //                 preimumRate = dp.DA_OA_91_180__c;
                            //                 break;
                            //             }
                            //         }
                            //     }
                            // }
                            System.debug('shipDec.Gross_Invoice_Value__c : '+shipDec.Gross_Invoice_Value__c+ ' preimumRate : '+preimumRate);
                            if(preimumRate != null){
                                Decimal calculatePremium = shipDec.Gross_Invoice_Value__c * (preimumRate/100) ;
                                System.debug('calculatePremium : '+calculatePremium);

                                Invoice_Line__c invLine = new Invoice_Line__c();
                                DateTime dT = System.now().addMonths(1);
                                invLine.Premium_Due_Date__c = Date.newInstance(dT.year(), dT.month(), dT.day());
                                invLine.Product__c=pol.Product__c;
                                invLine.Gross_Invoice_Value__c=calculatePremium;
                                invLine.Net_Premium__c=calculatePremium;
                                //System.debug('inserInvoice.id ::::'+inserInvoice.id);
                                invLine.Type__c='Shipment Declaration';
                                invLine.Shipment_Declaration__c = shipDec.id;
                                if(shipDec.Type__c.equals('Individual')){
                                    invLine.Shipment_Date__c=shipDec.Shipment_Date__c;
                                }else if(shipDec.Type__c.equals('Monthly lump sum')){
                                    invLine.Shipment_Month__c=shipDec.Shipment_Month__c;
                                    invLine.Shipment_Year__c=shipDec.Shipment_Year__c;

                                }
                                invLine.Payment_Terms__c = paymentTerm;
                                invLine.Currency_Code__c = shipDec.Currency__c;
                                invLineList.add(invLine);

                                shipDec.Invoiced__c=true;
                                shipDec.Invoice_Created_Date__c=System.now();
                                shipmentList.add(shipDec);
                            }
                        }
                    }
                } 
                System.debug('pol.name : '+pol.name+' line size '+invLineList);
                if(invLineList!= null && !invLineList.isEmpty()){
                    if(!pol.Is_Charge_Deposit_Applied__c && pol.Commencement_Date__c != null){
                        DateTime commDate = System.now();
                        Date todayDate = date.newinstance(commDate.year(), commDate.month(), commDate.day());
                        Integer daysBetween = pol.Commencement_Date__c.daysBetween(todayDate);
                        System.debug('daysBetween : '+daysBetween);
                        if(daysBetween<365){
                            //add the charge deposit
                            ECIC_Settings__c settings = ECIC_Settings.getEcicSettings();
                            if(settings!= null && settings.Charge_Deposit__c!=null && settings.Charge_Deposit__c>0){
                                List<Invoice_Line__c> invLineForCharegDepositList = new List<Invoice_Line__c>();
                                Invoice_Line__c invLine = new Invoice_Line__c();
                                //invLine.Premium_Cycle__c='Initial Payment';
                                DateTime cd = System.now().addMonths(1);
                                invLine.Premium_Due_Date__c = Date.newInstance(cd.year(), cd.month(), cd.day());
                                invLine.Product__c=pol.Product__c;
                                invLine.Gross_Invoice_Value__c=settings.Charge_Deposit__c;
                                invLine.Premium__c = settings.Charge_Deposit__c;
                                invLine.Net_Premium__c = settings.Charge_Deposit__c;
                                invLine.Description__c='Charge Deposit Amount';
                                invLine.Type__c='Charge Deposit';

                                invLineForCharegDepositList.add(invLine);
                                pol.Is_Charge_Deposit_Applied__c = true;
                                updatePolicyList.add(pol);
                                System.debug('Found a Charge Deposit');
                                Invoice__c cdInvoice = new Invoice__c();
                                cdInvoice.Account__c = pol.Exporter__c;
                                cdInvoice.Policy__c = pol.id;
                                cdInvoice.Status__c = 'UnPaid';
                                cdInvList.add(cdInvoice);
                                System.debug('pol.name : '+pol.name+' line size '+invLineForCharegDepositList.size());
                                policyIdInvLineForChargeDepositMap.put(pol.id,invLineForCharegDepositList);
                                
                            }
                        }
                    }
                }
                policyIdInvLineMap.put(pol.id,invLineList);
                
            }
            System.debug('policyIdInvLineMap '+policyIdInvLineMap);
            if(policyIdInvLineMap != null && !policyIdInvLineMap.isEmpty()){
                List<Invoice_Line__c> insertInvLineList = new List<Invoice_Line__c>();
                System.debug('shipment invList : '+invList);
                Database.SaveResult[] SR = Database.insert(invList, False);
                Map<id,id> polIdVsInvIdMap = new Map<id,id>();
                Map<id,id> invIdVsPolicyIdMap = new Map<id,id>();
                for(Invoice__c inv : invList){
                    polIdVsInvIdMap.put(inv.Policy__c,inv.id);
                    invIdVsPolicyIdMap.put(inv.id,inv.Policy__c);
                }
                System.debug('shipment dec Invoice  : '+polIdVsInvIdMap);
                for(Integer i=0;i<SR.size();i++){
                    System.debug('invoice for shipment dec  id==>> '+SR[i]);
                    if(SR[i].isSuccess()){
                        System.debug('Invoice Created Succefully!!! ');
                        for(String policyID : processPolicyList){
                            System.debug('policyID =====>>>'+policyID);
                            if(policyID.equals(invIdVsPolicyIdMap.get(SR[i].getId()))){
                                if(policyIdInvLineMap.containsKey(policyID)){
                                    for(Invoice_Line__c invLine1 : policyIdInvLineMap.get(policyID)){
                                        System.debug('invLine1 ******>>>'+invLine1);
                                        Invoice_Line__c newInvLine = invLine1.clone();
                                        newInvLine.Invoice__c = polIdVsInvIdMap.get(policyID);
                                        insertInvLineList.add(newInvLine);
                                        System.debug('insertInvLineList=============>>>'+insertInvLineList.size());
                                    }
                                }
                            }
                        }
                    }
                }
               
                if(policyIdInvLineForChargeDepositMap!= null && !policyIdInvLineForChargeDepositMap.isEmpty()){
                    System.debug('cdInvList : '+cdInvList);
                    Database.SaveResult[] cdSR = Database.insert(cdInvList, False);
                    Map<id,id> polIdVsInvIdCDMap = new Map<id,id>();
                    Map<id,id> invIdVsPolicyIdCDMap = new Map<id,id>();
                    for(Invoice__c inv : cdInvList){
                        polIdVsInvIdCDMap.put(inv.Policy__c,inv.id);
                        invIdVsPolicyIdCDMap.put(inv.id,inv.Policy__c);
                    }
                    System.debug('Charged Invoice : '+polIdVsInvIdCDMap);
                    System.debug('Charged Invoice policy : '+invIdVsPolicyIdCDMap);
                    for(Integer i=0;i<cdSR.size();i++){
                        System.debug('charge deposit invoice id==>>'+cdSR[i]);
                        if(cdSR[i].isSuccess()){
                            System.debug('Charge Depposit Invoice Created Succefully!!! ');
                            System.debug('policyIdInvLineForChargeDepositMap : '+policyIdInvLineForChargeDepositMap);
                            for(String policyID : processPolicyList){
                                System.debug('cd policyID:'+policyID+' invIdVsPolicyIdCDMap.get(cdSR[i].getId()) '+invIdVsPolicyIdCDMap.get(cdSR[i].getId()));
                                if(policyID.equals(invIdVsPolicyIdCDMap.get(cdSR[i].getId()))){
                                    System.debug('cd mathed policy');
                                    if(policyIdInvLineForChargeDepositMap.containsKey(policyID)){
                                        System.debug('policyID ==cd===>>>'+policyID+' line size : '+policyIdInvLineForChargeDepositMap.get(policyID).size());
                                        for(Invoice_Line__c invLine1 : policyIdInvLineForChargeDepositMap.get(policyID)){
                                            System.debug('invLine1******>>>cd='+invLine1);
                                            Invoice_Line__c newInvLine = invLine1.clone();
                                            newInvLine.Invoice__c = polIdVsInvIdCDMap.get(policyID);
                                            insertInvLineList.add(newInvLine);
                                            System.debug('insertInvLineList======cd=======>>>'+insertInvLineList.size());
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                System.debug('insertInvLineList : '+insertInvLineList);
                if(insertInvLineList!=null && !insertInvLineList.isEmpty()){
                    insert insertInvLineList;
                    System.debug('Invoice Line Created Succefully!!! '+insertInvLineList.size());
                }
                if(shipmentList !=null && !shipmentList.isEmpty()){
                    update shipmentList;
                    System.debug('Shipment Updated Succefully!!! ');
                }
                if(updatePolicyList!= null && !updatePolicyList.isEmpty()){
                    update updatePolicyList;
                    System.debug('Policy updated with Charge Deposit Applied.');
                }
            }
        }catch(Exception e){
            System.debug('Exception at : '+e.getMessage()+' Stack :'+e.getStackTraceString());
        }
        return wresponseObj;
    }
}