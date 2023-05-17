public with sharing class ShipmentDeclaration {
    public static ID getAccountID(Id usrId){
        Id accountId = [Select contact.AccountId from user where id =:usrId].contact.AccountId;
        System.debug('accountId '+accountId);
        return accountId;
    }
   

    public class WrapperBuyerInformation{
        @AuraEnabled
        public String id{get;set;}
        @AuraEnabled
        public String buyerName{get;set;}
        @AuraEnabled
        public String buyerCode{get;set;}
        @AuraEnabled
        public String harmonizeCode{get;set;}
        @AuraEnabled
        public String paymentTermType{get;set;}
        @AuraEnabled
        public Decimal refNo{get;set;}
        @AuraEnabled
        public String destinationMarket{get;set;}
        @AuraEnabled
        public String portOfLoading{get;set;}
        @AuraEnabled
        public boolean isSuccess{get;set;}
        @AuraEnabled
        public ID policyID{get;set;}
        @AuraEnabled
        public boolean isClientRelatedToEN68{get;set;}
    }

    @AuraEnabled
    public static WrapperBuyerInformation getBuyerInformation(Id usrId,String buyerName, String buyerCode){
        WrapperBuyerInformation buyerInfoObj = new WrapperBuyerInformation();
        buyerInfoObj.isSuccess = false;
        boolean isCreditLimitChecked=false;
        String accountID = getAccountID(usrId);
        Account accDetailsObj = PolicyManagement.getAccountDetails(accountID);
        String mainQuery;
        String wherePart1=' ';
        String buyerChecking;
        //boolean isClientRelatedToEN68=false;
        Map<String,boolean> buyerNameVsEn68Map = new Map<String,boolean>();
        for(Related_Endorsement__c relEnd : [select id,Buyer_Name__c from Related_Endorsement__c where Policy__c  =: accDetailsObj.Current_Policy__c and Endorsement_Type__r.name in ('EN68','EN67')  ]){
            buyerNameVsEn68Map.put(relEnd.Buyer_Name__c,true);
        }
        System.debug('buyerNameVsEn68Map : '+buyerNameVsEn68Map);

        if( (buyerName !=null && buyerName.length()>0) && (buyerCode !=null && buyerCode.length()>0) ){
            wherePart1 =' where CL_Status__c =  \''+'valid'+ '\''+' and Buyer_Name__c LIKE \'%' + buyerName + '%\' and Buyer_Code__c LIKE \'%' + buyerCode + '%\'';
            
        }else if(buyerName !=null && buyerName.length()>0){
            wherePart1=' where CL_Status__c =  \''+'valid'+ '\''+' and Buyer_Name__c LIKE \'%' + buyerName + '%\'';
            
        }else if(buyerCode !=null && buyerCode.length()>0){
            wherePart1=' where CL_Status__c =  \''+'valid'+ '\''+' and Buyer_Code__c LIKE \'%' + buyerCode + '%\'';
            
        }else{
            wherePart1 = 'where CL_Status__c =  \''+'valid'+ '\''+'';
        }
        System.Debug('wherePart1 : '+wherePart1);
        mainQuery = 'Select Id,name,'+
            '(select id,Buyer_Name__c,Buyer_Code__c,Harmonized_Code__c,Payment_Term_Type__c,Ref_No__c,Destination_Market__c,Port_Of_Loading__c,Policy__c from Credit_Limits__r '+wherePart1+' ),'+
            '(select id,Buyer_Name__c,Buyer_Code__c,Harmonized_Code__c,Payment_Term_Type__c,Ref_No__c,Destination_Market__c,Port_Of_Loading__c,Policy__c from Credit_Limit_Applications__r '+wherePart1+' )'+
            ' FROM Account WHERE Id = \'' + accountID + '\'';
        System.Debug('mainQuery : '+mainQuery);
        Account accObj = Database.query(mainQuery);
        
        for(Credit_Limit__c cl : accObj.Credit_Limits__r){
            buyerInfoObj.id = cl.id;
            buyerInfoObj.buyerName = cl.Buyer_Name__c;
            buyerInfoObj.buyerCode = cl.Buyer_Code__c;
            buyerInfoObj.harmonizeCode = cl.Harmonized_Code__c;
            buyerInfoObj.paymentTermType = cl.Payment_Term_Type__c;
            buyerInfoObj.refNo = cl.Ref_No__c;
            buyerInfoObj.destinationMarket = cl.Destination_Market__c;
            buyerInfoObj.portOfLoading = cl.Port_Of_Loading__c;
            buyerInfoObj.policyID = accDetailsObj.Current_Policy__c;//cl.Policy__c;
            buyerInfoObj.isSuccess = true;
            System.debug('CL Buyer : '+cl.Buyer_Name__c);
            if(buyerNameVsEn68Map!=null && buyerNameVsEn68Map.containsKey(cl.Buyer_Name__c)){
                buyerInfoObj.isClientRelatedToEN68 = buyerNameVsEn68Map.get(cl.Buyer_Name__c);
            }
            isCreditLimitChecked = true;
            break;
        }
        
        if(!isCreditLimitChecked){
            for(Credit_Limit_Application__c cl : accObj.Credit_Limit_Applications__r){
                buyerInfoObj.id = cl.id;
                buyerInfoObj.buyerName = cl.Buyer_Name__c;
                buyerInfoObj.buyerCode = cl.Buyer_Code__c;
                buyerInfoObj.harmonizeCode = cl.Harmonized_Code__c;
                buyerInfoObj.paymentTermType = cl.Payment_Term_Type__c;
                buyerInfoObj.refNo = cl.Ref_No__c;
                buyerInfoObj.destinationMarket = cl.Destination_Market__c;
                buyerInfoObj.portOfLoading = cl.Port_Of_Loading__c;
                buyerInfoObj.policyID = accDetailsObj.Current_Policy__c;//cl.Policy__c;
                buyerInfoObj.isSuccess = true;
                System.debug('CLA Buyer : '+cl.Buyer_Name__c); 
                if(buyerNameVsEn68Map!=null && buyerNameVsEn68Map.containsKey(cl.Buyer_Name__c)){
                    buyerInfoObj.isClientRelatedToEN68 = buyerNameVsEn68Map.get(cl.Buyer_Name__c);
                }
            break;
            }
        }
        System.Debug('buyerInfoObj : '+buyerInfoObj);
        return buyerInfoObj;

    }
    @AuraEnabled
    public static List<Related_Endorsement__c> fetchAllEndorsements(Id userId){
        System.debug('fetchAllEndorsements : '+userId);
        List<Related_Endorsement__c>  allEndorsementList = new List<Related_Endorsement__c>();
        try {
            String policyId = getPolicyId(userId);
            for(Related_Endorsement__c endorse : [select id,Name,Issue_Date__c,Type__c,Endorsement_Type__r.Name,Policy__c,
                                                Carry_Forward_To_Next_Policy_Year__c,Cancelled_Date__c,Buyer_Name__c,
                                                Buyer_Country__c,Buyer_Code__c 
                                                from Related_Endorsement__c
                                                where Policy__c =:policyId  and Status__c='Approved']){
                allEndorsementList.add(endorse);
            }
            System.debug('allEndorsementList : '+allEndorsementList);
        } catch (Exception e) {
            System.debug('Exception :'+e.getMessage()+' Stack :');
            throw new AuraHandledException(e.getMessage());
        }
        return allEndorsementList;
    }
    public static String getPolicyId(Id userId){
        Id accountId = [Select contact.AccountId from user where id =:userId].contact.AccountId;
        Account accObj = [select Current_Policy__c from Account where id =:accountId ];
        System.debug('accountId ==>>'+accountId+' accObj :'+accObj.Current_Policy__c);
        return accObj.Current_Policy__c;
    }
    public static Date getDateFromString(String dateInString){
        Date formatedDate;
        try {
            System.debug('dateInString '+dateInString);
            if(dateInString != null && dateInString.length()>0){
                String[] actuaDateFull = dateInString.split(' ');
                System.debug('actuaDateFull isEmpty '+actuaDateFull.isEmpty());
                if(actuaDateFull != null && !actuaDateFull.isEmpty()){
                    String[] actuaDate =  actuaDateFull[0].split('-');
                    formatedDate = date.newinstance(Integer.valueOf(actuaDate[0]), Integer.valueOf(actuaDate[1]), Integer.valueOf(actuaDate[2]));

                }
            }
        } catch (Exception e) {
            System.debug('Exception while parsing date '+e.getMessage()+' Stack '+e.getStackTraceString());
        } 
        System.debug('formatedDate '+formatedDate);
        return  formatedDate;
        
    }
    public static String getDateTimeFromString(String dateInString){
        String formatedDate;
        try {
            System.debug('dateInString '+dateInString);
            if(dateInString != null && dateInString.length()>0){
                String[] actuaDateFull = dateInString.split(' ');
                System.debug('actuaDateFull isEmpty '+actuaDateFull.isEmpty());
                if(actuaDateFull != null && !actuaDateFull.isEmpty()){
                    String[] actuaDate =  actuaDateFull[0].split('-');
                    //formatedDate = datetime.newinstance(Integer.valueOf(actuaDate[0]), Integer.valueOf(actuaDate[1]), Integer.valueOf(actuaDate[2]));
                    formatedDate = actuaDate[0]+'-'+actuaDate[1]+'-'+ actuaDate[2]+'T00:00:00Z';

                }
            }
        } catch (Exception e) {
            System.debug('Exception while parsing date '+e.getMessage()+' Stack '+e.getStackTraceString());
        } 
        System.debug('formatedDate '+formatedDate);
        return  formatedDate;
        
    }
    @AuraEnabled
    public static List<WrapperShipmentDeclaration> getDeclaredBuyerInfo(Id usrId,
                                                                String selecetdBuyerName, 
                                                                String typedBuyerName,
                                                                String shipStart,
                                                                String shipEnd,
                                                                String createdFrom,
                                                                String createdTo,
                                                                String policyID){

        
        System.debug('shipEnd :  '+shipEnd+' typedBuyerName : '+typedBuyerName+' shipStart:'+shipStart+' createdFrom :'+createdFrom+' createdTo:'+createdTo );
        WrapperBuyerInformation buyerInfoObj = new WrapperBuyerInformation();
        buyerInfoObj.isSuccess = false;
        boolean isCreditLimitChecked=false;
        //String accountID = getAccountID(usrId);
        //Account accDetailsObj = PolicyManagement.getAccountDetails(accountID);
        //String poicyID=accDetailsObj.Current_Policy__c;
        String mainQuery;
        String wherePart1=' ';
        String buyerChecking;
        Boolean isNameAddedInWhere = false;
        Boolean isShipmentIsInWhere = false;
        List<Shipment_Declaration__c> shipDecist = new List<Shipment_Declaration__c>();
        List<WrapperShipmentDeclaration> wrapShipDecist = new List<WrapperShipmentDeclaration>();
        String createdFromDate;
        String createdToDate;
        if(createdFrom != null){
            createdFromDate = getDateTimeFromString(createdFrom);
        }
        if(createdTo != null){
            createdToDate = getDateTimeFromString(createdTo);
        }
        
        System.debug('createdFromDate :  '+createdFromDate+' createdToDate : '+createdToDate );
        if(selecetdBuyerName !=null && selecetdBuyerName.length()>0){
            wherePart1=' and Buyer_Name__c = \'' + selecetdBuyerName + '\'';
            isNameAddedInWhere=true;
        }else {
            if(typedBuyerName !=null && typedBuyerName.length()>0){
                wherePart1=' and Buyer_Name__c = \'' + typedBuyerName + '\'';
                isNameAddedInWhere=true;
            }
        }

        if( (shipStart != null ) && (shipEnd != null)){
            wherePart1=wherePart1+' and Shipment_Date__c >= '+ shipStart+' and Shipment_Date__c <= '+shipEnd ;
        }else if(shipStart != null){
            wherePart1=wherePart1+' and Shipment_Date__c >= '+ shipStart ;
        }else if(shipEnd != null){
            wherePart1=wherePart1+' and Shipment_Date__c <= '+ shipEnd ;
        }


        if( (createdFromDate != null ) && (createdToDate != null)){
            wherePart1=wherePart1+' and CreatedDate >= '+ createdFromDate+' and CreatedDate <= '+createdToDate ;
        }else if(createdFromDate != null){
            wherePart1=wherePart1+' and CreatedDate >= '+ createdFromDate ;
        }else if(createdToDate != null){
            wherePart1=wherePart1+' and CreatedDate <= '+ createdToDate ;
        }
        //System.debug('isNameAddedInWhere : '+isNameAddedInWhere);
        /*if(isNameAddedInWhere){
            if( (shipStart != null ) && (shipEnd != null)){
                wherePart1=wherePart1+' and Shipment_Date__c >= '+ shipStart+' and Shipment_Date__c <= '+shipEnd ;
            }else if(shipStart != null){
                wherePart1=wherePart1+' and Shipment_Date__c >= '+ shipStart ;
            }else if(shipEnd != null){
                wherePart1=wherePart1+' and Shipment_Date__c <= '+ shipEnd ;
            }


            if( (createdFromDate != null ) && (createdToDate != null)){
                wherePart1=wherePart1+' and CreatedDate >= '+ createdFromDate+' and CreatedDate <= '+createdToDate ;
            }else if(createdFromDate != null){
                wherePart1=wherePart1+' and CreatedDate >= '+ createdFromDate ;
            }else if(createdToDate != null){
                wherePart1=wherePart1+' and CreatedDate <= '+ createdToDate ;
            }
            
        }else{
            if( (shipStart != null) && (shipEnd != null)){
                wherePart1=' and Shipment_Date__c >= '+ shipStart+' and Shipment_Date__c <= '+shipEnd ;
                isShipmentIsInWhere = true;
            }else if(shipStart != null){
                wherePart1=' and Shipment_Date__c >= '+ shipStart ;
                isShipmentIsInWhere = true;
            }else if(shipEnd != null){
                wherePart1=' and Shipment_Date__c <= '+ shipEnd ;
                isShipmentIsInWhere = true;
            }
            if(isShipmentIsInWhere){
                if( (createdFromDate != null ) && (createdToDate != null)){
                    wherePart1=wherePart1+' and CreatedDate >= '+ createdFromDate+' and CreatedDate <= '+createdToDate ;
                }else if(createdFromDate != null){
                    wherePart1=wherePart1+' and CreatedDate >= '+ createdFromDate ;
                }else if(createdToDate != null){
                    wherePart1=wherePart1+' and CreatedDate <= '+ createdToDate ;
                }
            }else{
                if( (createdFromDate != null ) && (createdToDate != null)){
                    wherePart1=wherePart1+' and CreatedDate >= '+ createdFromDate+' and CreatedDate <= '+createdToDate ;
                }else if(createdFromDate != null){
                    wherePart1=wherePart1+' and CreatedDate >= '+ createdFromDate ;
                }else if(createdToDate != null){
                    wherePart1=wherePart1+' and CreatedDate <= '+ createdToDate ;
                }
            }
            
        }*/
        System.Debug('wherePart1 : '+wherePart1);
        mainQuery = 'select id,name,Buyer_Name__c,Buyer_Code__c,Gross_Invoice_Value__c,createdDate,Pre_Shipment_Declaration__c,'+
        'Due_Date__c,Endorsement__c,Shipment_was_made_by_anoverseas_subsidia__c,Harmonized_Code__c,Policyholder_Reference_No__c,'+
        'Shipment_Date__c,Currency__c,Payment_Term_Type__c,Port_of_Loading_Ship_From__c,Destination_Country_Market_Ship_to__c,'+
        'Country_of_Origin__c,Status__c,Invoice_Date__c,Policy__c from Shipment_Declaration__c where Policy__c =\''+policyID+'\' '+wherePart1+' order by name desc ';
        System.Debug('mainQuery : '+mainQuery);
        shipDecist = Database.query(mainQuery);
        for(Shipment_Declaration__c sd : shipDecist ){
            
                WrapperShipmentDeclaration wsd = new WrapperShipmentDeclaration();
                wsd.id = sd.id;
                wsd.name = sd.name;
                wsd.buyerName = sd.Buyer_Name__c;
                wsd.buyerCode = sd.Buyer_Code__c;
                wsd.grossInvoiceValue = sd.Gross_Invoice_Value__c;
                DateTime dT = sd.createdDate;
                wsd.createdDate = Date.newInstance(dT.year(), dT.month(), dT.day());
                wsd.isShowDetais = false;
                wsd.preShipmentDeclaration = sd.Pre_Shipment_Declaration__c;
                wsd.premium =210000.000; //sd.Pre_Shipment_Declaration__c;
                DateTime dT1 = sd.Due_Date__c;
                if(sd.Due_Date__c != null){
                    wsd.dueDate = Date.newInstance(dT1.year(), dT1.month(), dT1.day());
                }
                if(sd.Shipment_Date__c != null){
                    wsd.shipMentDate =sd.Shipment_Date__c; //Date.newInstance(dT1.year(), dT1.month(), dT1.day());
                }
                
                wsd.endorsement = sd.Endorsement__c;
                wsd.subsYesNo = sd.Shipment_was_made_by_anoverseas_subsidia__c;
                wsd.harmonizedCode = sd.Harmonized_Code__c;
                wsd.phRefNo = sd.Policyholder_Reference_No__c;
                wsd.ecicCurrency = sd.Currency__c;
                wsd.paymentTerm = sd.Payment_Term_Type__c;
                wsd.portOfLoading = sd.Port_of_Loading_Ship_From__c;
                wsd.destinationCountry = sd.Destination_Country_Market_Ship_to__c;
                wsd.countryOrigin = sd.Country_of_Origin__c;
                wsd.status = sd.Status__c;
                wsd.usedForSpace = '';
                wrapShipDecist.add(wsd);
            
            
        }
        System.Debug('wrapShipDecist : '+wrapShipDecist);
        return wrapShipDecist;

    }
    public class WrapperShipmentDeclaration{
        @AuraEnabled
        public String usedForSpace{get;set;}
        @AuraEnabled
        public String id{get;set;}
        @AuraEnabled
        public String name{get;set;}
        @AuraEnabled
        public String buyerName{get;set;}
        @AuraEnabled
        public String buyerCode{get;set;}
        @AuraEnabled
        public Decimal grossInvoiceValue{get;set;}
        @AuraEnabled
        public Boolean isShowDetais{get;set;}
        @AuraEnabled
        public Date createdDate{get;set;}
        @AuraEnabled
        public Boolean preShipmentDeclaration{get;set;}
        @AuraEnabled
        public Decimal premium{get;set;}
        @AuraEnabled
        public Date dueDate{get;set;}
        @AuraEnabled
        public Date shipMentDate{get;set;}
        @AuraEnabled
        public Date invoiceDate{get;set;}
        @AuraEnabled
        public String endorsement{get;set;}
        @AuraEnabled
        public Boolean subsYesNo{get;set;}
        @AuraEnabled
        public String harmonizedCode{get;set;}
        @AuraEnabled
        public String phRefNo{get;set;}
        @AuraEnabled
        public String ecicCurrency{get;set;}

        @AuraEnabled
        public String paymentTerm{get;set;}
        @AuraEnabled
        public Decimal paymentTermDay{get;set;}
        @AuraEnabled
        public String portOfLoading{get;set;}
        @AuraEnabled
        public String destinationCountry{get;set;}
        @AuraEnabled
        public String countryOrigin{get;set;}
        @AuraEnabled
        public String status{get;set;}
        @AuraEnabled
        public String shipmentType{get;set;}
        @AuraEnabled
        public String isSettled{get;set;}
        @AuraEnabled
        public String shipmentMonth{get;set;}
        @AuraEnabled
        public String shipmentYearValue{get;set;}
    }
    @AuraEnabled
    public static List<WrapperShipmentDeclaration> fetchAllShipDec(Id userId){
        System.debug('fetchAllShipDec userId : '+userId);
        List<Shipment_Declaration__c> shipDecist = new List<Shipment_Declaration__c>();
        List<WrapperShipmentDeclaration> wrapShipDecist = new List<WrapperShipmentDeclaration>();
        try {
            Account accObj = PolicyManagement.getPolicyHolderData(userId);
            if(accObj.Current_Policy__c != null){//Gross_Invoice_Value__c
                shipDecist = [select id,name,Buyer_Name__c,Buyer_Code__c,createdDate,Gross_Invoice_Value__c,
                Pre_Shipment_Declaration__c,Due_Date__c,Endorsement__c,Shipment_was_made_by_anoverseas_subsidia__c,
                Policyholder_Reference_No__c,Shipment_Date__c,Currency__c,Payment_Term_Type__c,
                Port_of_Loading_Ship_From__c,Destination_Country_Market_Ship_to__c,Country_of_Origin__c,Status__c,
                Invoice_Date__c,Payment_Term_Days__c,Type__c,Harmonized_Code__c,Is_Settled__c,Final_Satus__c,Shipment_Month__c,
                Shipment_Year__c
                 from Shipment_Declaration__c where Policy__c =:accObj.Current_Policy__c order by name desc ];
                for(Shipment_Declaration__c sd : shipDecist ){
                    WrapperShipmentDeclaration wsd = new WrapperShipmentDeclaration();
                    wsd.id = sd.id;
                    wsd.name = sd.name;
                    wsd.buyerName = sd.Buyer_Name__c;
                    wsd.buyerCode = sd.Buyer_Code__c;
                    wsd.isSettled = sd.Final_Satus__c;
                    wsd.grossInvoiceValue = sd.Gross_Invoice_Value__c;
                    DateTime dT = sd.createdDate;
                    wsd.createdDate = Date.newInstance(dT.year(), dT.month(), dT.day());
                    wsd.isShowDetais = false;
                    wsd.preShipmentDeclaration = sd.Pre_Shipment_Declaration__c;
                    wsd.premium =210000.000; //sd.Pre_Shipment_Declaration__c;
                    DateTime dT1 = sd.Due_Date__c;
                    if(sd.Due_Date__c != null){
                        wsd.dueDate = Date.newInstance(dT1.year(), dT1.month(), dT1.day());
                    }
                    wsd.invoiceDate = sd.Invoice_Date__c;
                    if(sd.Shipment_Date__c != null){
                        wsd.shipMentDate =sd.Shipment_Date__c; //Date.newInstance(dT1.year(), dT1.month(), dT1.day());
                    }
                    
                    wsd.endorsement = sd.Endorsement__c;
                    wsd.subsYesNo = sd.Shipment_was_made_by_anoverseas_subsidia__c;
                    wsd.harmonizedCode = sd.Harmonized_Code__c;
                    wsd.phRefNo = sd.Policyholder_Reference_No__c;
                    wsd.ecicCurrency = sd.Currency__c;
                    wsd.paymentTerm = sd.Payment_Term_Type__c;
                    wsd.paymentTermDay = sd.Payment_Term_Days__c;
                    wsd.portOfLoading = sd.Port_of_Loading_Ship_From__c;
                    wsd.destinationCountry = sd.Destination_Country_Market_Ship_to__c;
                    wsd.countryOrigin = sd.Country_of_Origin__c;
                    wsd.status = sd.Status__c;
                    wsd.usedForSpace = '';
                    wsd.shipmentMonth = sd.Shipment_Month__c;
                    wsd.shipmentYearValue = sd.Shipment_Year__c;
                    wrapShipDecist.add(wsd);
                }
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        System.debug('wrapShipDecist : '+wrapShipDecist);
        return wrapShipDecist;
       
    }

    @AuraEnabled
    public static Boolean createShipmentDecalaration(String policyID,
                                                    String buyerName,
                                                    String buyerCode,
                                                    Decimal givValue,
                                                    String shipmentType,
                                                    Boolean preShipYes,
                                                    Boolean shipOverSubYes,
                                                    String shipmentDate,
                                                    String invoiceDate,
                                                    String contractDate,
                                                    String ecic_currency,
                                                    String paymentTermType,
                                                    String paymentTermDay,
                                                    String refNo,
                                                    String destinationMarket,
                                                    String portOfLoading,
                                                    String countryOfOrigin,
                                                    String harmonizeCode,
                                                    String lateDecOtherReason,
                                                    String endorsementValue,
                                                    String shipmentMonthValue,
                                                    String shipmentYearValue,
                                                    String contractualSeller
                                                    ){
        
        System.debug('policyID :'+policyID+' buyerName : '+buyerName+'\nbuyerCode :'+buyerCode+' givValue:'+givValue+' shipmentType:'+shipmentType+' invoiceDate:'+invoiceDate+' endorsementValue:'+endorsementValue);
        System.debug('preShipYes :'+preShipYes+' shipOverSubYes : '+shipOverSubYes+'\nshipmentDate :'+shipmentDate+' contractDate:'+contractDate+' ecic_currency:'+ecic_currency+' harmonizeCode:'+harmonizeCode);
        System.debug('paymentTermType :'+paymentTermType+' refNo : '+refNo+'\ndestinationMarket :'+destinationMarket+' portOfLoading:'+portOfLoading+' paymentTermDay:'+paymentTermDay+' contractualSeller:'+contractualSeller);

        Boolean isShipmentDecalarationCreated;
        try {
            Shipment_Declaration__c shipDecObj = new Shipment_Declaration__c();
            shipDecObj.Buyer_Name__c = buyerName;
            shipDecObj.Buyer_Code__c = buyerCode;
            shipDecObj.Gross_Invoice_Value__c = givValue;
            shipDecObj.Policy__c = policyID;
            shipDecObj.Type__c = shipmentType;
            if(preShipYes){
                shipDecObj.Pre_Shipment_Declaration__c = preShipYes;
                
            }else{
                shipDecObj.Invoice_Date__c =  getDateFromString(invoiceDate);
                shipDecObj.Shipment_Date__c = getDateFromString(shipmentDate);
            }
            if(shipOverSubYes){
                shipDecObj.Shipment_was_made_by_anoverseas_subsidia__c = shipOverSubYes;
            }
            shipDecObj.Currency__c = ecic_currency;
            shipDecObj.Payment_Term_Type__c = paymentTermType;
            shipDecObj.Policyholder_Reference_No__c = refNo;
            shipDecObj.Destination_Country_Market_Ship_to__c = destinationMarket;
            shipDecObj.Port_of_Loading_Ship_From__c = portOfLoading;
            shipDecObj.Country_of_Origin__c = countryOfOrigin;
            shipDecObj.Payment_Term_Days__c = Integer.valueOf(paymentTermDay);
            shipDecObj.Harmonized_Code__c = harmonizeCode;
            shipDecObj.Reason_For_Late_Declaration__c = lateDecOtherReason;
            shipDecObj.Endorsement__c = endorsementValue;
            if(!checkSchedule2ForPortOfLoading(policyID,portOfLoading)){
                System.debug('Need to Review the Port of Loading.');
                shipDecObj.Review_Port_of_Loading__c=true;
            }
            shipDecObj.Status__c='Submitted';
            shipDecObj.Shipment_Month__c = shipmentMonthValue;
            shipDecObj.Shipment_Year__c = shipmentYearValue;
            if(contractualSeller!=null && !contractualSeller.equals('')){
                shipDecObj.Who_is_the_contractual_seller__c = contractualSeller;
            }
             
            insert shipDecObj;
            isShipmentDecalarationCreated = true;
        } catch (Exception e) {
            System.debug('Exception while inserting Shipment Declatation : '+e.getMessage()+' Stack : '+e.getStackTraceString());
            ExceptionLogger.log(e, 'Exception at createShipmentDecalaration of class ShipmentDeclaration');  
            ExceptionLogger.email(e);  //send email to SME

            throw new AuraHandledException(e.getMessage());
        }
        return isShipmentDecalarationCreated;
    }

    @AuraEnabled
    public static Date  addJustInvoice(String addToInvoiceDate){
        return System.today().addDays(Integer.valueOf(addToInvoiceDate));

    }
    @AuraEnabled
    public static List<WrapperShipmentDeclaration> fetchShipDecById(Id shipmentId){
        System.debug('fetchShipDecById shipmentId : '+shipmentId);
        List<Shipment_Declaration__c> shipDecist = new List<Shipment_Declaration__c>();
        List<WrapperShipmentDeclaration> wrapShipDecist = new List<WrapperShipmentDeclaration>();
        try {
                //Gross_Invoice_Value__c
                shipDecist = [select id,name,Buyer_Name__c,Buyer_Code__c,createdDate,Gross_Invoice_Value__c,
                Pre_Shipment_Declaration__c,Due_Date__c,Endorsement__c,Shipment_was_made_by_anoverseas_subsidia__c,
                Policyholder_Reference_No__c,Shipment_Date__c,Currency__c,Payment_Term_Type__c,
                Payment_Term_Days__c,Type__c,Harmonized_Code__c,
                Port_of_Loading_Ship_From__c,Destination_Country_Market_Ship_to__c,Country_of_Origin__c,Status__c,
                Invoice_Date__c,Shipment_Month__c,Shipment_Year__c
                 from Shipment_Declaration__c where id =:shipmentId order by name desc ];
                for(Shipment_Declaration__c sd : shipDecist ){
                    WrapperShipmentDeclaration wsd = new WrapperShipmentDeclaration();
                    wsd.id = sd.id;
                    wsd.name = sd.name;
                    wsd.buyerName = sd.Buyer_Name__c;
                    wsd.buyerCode = sd.Buyer_Code__c;
                    wsd.shipmentType = sd.Type__c;
                    wsd.grossInvoiceValue = sd.Gross_Invoice_Value__c;
                    DateTime dT = sd.createdDate;
                    wsd.createdDate = Date.newInstance(dT.year(), dT.month(), dT.day());
                    wsd.isShowDetais = false;
                    wsd.preShipmentDeclaration = sd.Pre_Shipment_Declaration__c;
                    wsd.premium =210000.000; //sd.Pre_Shipment_Declaration__c;
                    DateTime dT1 = sd.Due_Date__c;
                    if(sd.Due_Date__c != null){
                        wsd.dueDate = Date.newInstance(dT1.year(), dT1.month(), dT1.day());
                    }
                    if(sd.Shipment_Date__c != null){
                        wsd.shipMentDate =sd.Shipment_Date__c; //Date.newInstance(dT1.year(), dT1.month(), dT1.day());
                    }
                    if(sd.Invoice_Date__c != null){
                        wsd.invoiceDate =sd.Invoice_Date__c; //Date.newInstance(dT1.year(), dT1.month(), dT1.day());
                    }
                    
                    wsd.endorsement = sd.Endorsement__c;
                    wsd.subsYesNo = sd.Shipment_was_made_by_anoverseas_subsidia__c;
                    wsd.harmonizedCode = sd.Harmonized_Code__c;
                    wsd.phRefNo = sd.Policyholder_Reference_No__c;
                    wsd.ecicCurrency = sd.Currency__c;
                    wsd.paymentTerm = sd.Payment_Term_Type__c;
                    wsd.paymentTermDay = sd.Payment_Term_Days__c;
                    wsd.portOfLoading = sd.Port_of_Loading_Ship_From__c;
                    wsd.destinationCountry = sd.Destination_Country_Market_Ship_to__c;
                    wsd.countryOrigin = sd.Country_of_Origin__c;
                    wsd.status = sd.Status__c;
                    wsd.shipmentMonth = sd.Shipment_Month__c;
                    wsd.shipmentYearValue = sd.Shipment_Year__c;
                    wrapShipDecist.add(wsd);
                }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        System.debug('wrapShipDecist : '+wrapShipDecist);
        return wrapShipDecist;
       
    }
    @AuraEnabled
    public static Boolean updateShipmentDecalaration(String policyID,
                                                    String buyerName,
                                                    String buyerCode,
                                                    Decimal givValue,
                                                    String shipmentType,
                                                    Boolean preShipYes,
                                                    Boolean shipOverSubYes,
                                                    String shipmentDate,
                                                    String invoiceDate,
                                                    String contractDate,
                                                    String ecic_currency,
                                                    String paymentTermType,
                                                    String paymentTermDay,
                                                    String refNo,
                                                    String destinationMarket,
                                                    String portOfLoading,
                                                    String countryOfOrigin,
                                                    String shipmentId,
                                                    String harmonizeCode,
                                                    String ReasonForAmendment,
                                                    String lateDecOtherReason,
                                                    String endorsementValue,
                                                    String shipmentMonthValue,
                                                    String shipmentYearValue,
                                                    String contractualSeller
                                                    ){
        
        System.debug('policyID :'+policyID+' shipmentMonthValue : '+shipmentMonthValue+'\nbuyerCode :'+buyerCode+' givValue:'+givValue+' shipmentType:'+shipmentType+' invoiceDate:'+invoiceDate+' harmonizeCode:'+harmonizeCode);
        System.debug('preShipYes :'+preShipYes+' shipOverSubYes : '+shipOverSubYes+'\nshipmentDate :'+shipmentDate+' contractDate:'+contractDate+' ecic_currency:'+ecic_currency+' ReasonForAmendment:'+ReasonForAmendment);
        System.debug('paymentTermType :'+paymentTermType+' refNo : '+refNo+'\ndestinationMarket :'+destinationMarket+' portOfLoading:'+portOfLoading+' paymentTermDay:'+paymentTermDay+' countryOfOrigin:'+countryOfOrigin+' contractualSeller:'+contractualSeller);

        Boolean isShipmentDecalarationCreated;
        try {
            Shipment_Declaration__c shipDecObj = [select id,name from Shipment_Declaration__c where id =:shipmentId ];
            if(ReasonForAmendment!=null && ReasonForAmendment.equals('Typing Mistake')){
                shipDecObj.Buyer_Name__c = buyerName;
                shipDecObj.Buyer_Code__c = buyerCode;
                shipDecObj.Gross_Invoice_Value__c = givValue;
                shipDecObj.Type__c = shipmentType;
                if(preShipYes){
                    shipDecObj.Pre_Shipment_Declaration__c = preShipYes;
                    
                }else{
                    shipDecObj.Invoice_Date__c =  getDateFromString(invoiceDate);
                    shipDecObj.Shipment_Date__c = getDateFromString(shipmentDate);
                }
                if(shipOverSubYes){
                    shipDecObj.Shipment_was_made_by_anoverseas_subsidia__c = shipOverSubYes;
                }
                shipDecObj.Currency__c = ecic_currency;
                shipDecObj.Payment_Term_Type__c = paymentTermType;
                shipDecObj.Policyholder_Reference_No__c = refNo;
                shipDecObj.Destination_Country_Market_Ship_to__c = destinationMarket;
                shipDecObj.Port_of_Loading_Ship_From__c = portOfLoading;
                System.debug('countryOfOrigin : '+countryOfOrigin);
                shipDecObj.Country_of_Origin__c = countryOfOrigin;
                
                shipDecObj.Payment_Term_Days__c = Integer.valueOf(paymentTermDay);
                shipDecObj.Harmonized_Code__c = harmonizeCode;
                shipDecObj.Reason_For_Late_Declaration__c = lateDecOtherReason;
                shipDecObj.Endorsement__c = endorsementValue;
                shipDecObj.Shipment_Month__c = shipmentMonthValue;
                shipDecObj.Shipment_Year__c = shipmentYearValue;
                if(contractualSeller!=null && !contractualSeller.equals('')){
                    shipDecObj.Who_is_the_contractual_seller__c = contractualSeller;
                }
            }else {
                shipDecObj.Backup_Shipment_Month__c= shipmentMonthValue;
                shipDecObj.Backup_Shipment_Year__c = shipmentYearValue;
                shipDecObj.Reason_For_Amendment__c = ReasonForAmendment;
                shipDecObj.Backup_Buyer_Name__c = buyerName;
                shipDecObj.Backup_Buyer_Code__c = buyerCode;
                shipDecObj.Backup_Gross_Invoice_Value__c = givValue;
                shipDecObj.Backup_Type__c = shipmentType;
                if(preShipYes){
                    shipDecObj.Backup_Pre_Shipment_Declaration__c = preShipYes;
                    
                }else{
                    shipDecObj.Backup_Invoice_Date__c =  getDateFromString(invoiceDate);
                    shipDecObj.Backup_Shipment_Date__c = getDateFromString(shipmentDate);
                }
                if(shipOverSubYes){
                    shipDecObj.Backup_Over_Seas__c = shipOverSubYes;
                }
                shipDecObj.Backup_Currency__c = ecic_currency;
                shipDecObj.Backup_Payment_Term_Days__c = Integer.valueOf(paymentTermDay);
                shipDecObj.Backup_Payment_Term_Type__c = paymentTermType;
                shipDecObj.Backup_Policyholder_s_Reference_No_if__c = refNo;
                shipDecObj.Backup_Destination_Country_Market_Sh__c = destinationMarket;
                shipDecObj.Backup_Port_of_Loading_Ship_From__c = portOfLoading;
                shipDecObj.Backup_Country_of_Origin__c = countryOfOrigin;

                shipDecObj.Backup_Harmonized_Code__c = harmonizeCode;
                shipDecObj.Reason_For_Late_Declaration__c = lateDecOtherReason;
                shipDecObj.Backup_Endorsement__c = endorsementValue;
                shipDecObj.Status__c = 'Amendment pending for SME team staff approval';
                if(contractualSeller!=null && !contractualSeller.equals('')){
                    shipDecObj.Backup_Who_is_the_contractual_seller__c = contractualSeller;
                }
            }
            update shipDecObj;

            isShipmentDecalarationCreated = true;
            if (isShipmentDecalarationCreated ) {
                Shipment_Declaration_History__c sdhObj = new Shipment_Declaration_History__c(); 
                sdhObj.Buyer_Name__c = buyerName;
                sdhObj.Buyer_Code__c = buyerCode;
                sdhObj.Gross_Invoice_Value__c = givValue;
                sdhObj.Policy__c = policyID;
                sdhObj.Type__c = shipmentType;
                if(preShipYes){
                    sdhObj.Pre_Shipment_Declaration__c = preShipYes;
                    
                }else{
                    sdhObj.Invoice_Date__c =  getDateFromString(invoiceDate);
                    sdhObj.Shipment_Date__c = getDateFromString(shipmentDate);
                }
                if(shipOverSubYes){
                    sdhObj.Shipment_was_made_by_anoverseas_subsidia__c = shipOverSubYes;
                }
                sdhObj.Currency__c = ecic_currency;
                sdhObj.Payment_Term_Type__c = paymentTermType;
                sdhObj.Policyholder_Reference_No__c = refNo;
                sdhObj.Destination_Country_Market_Ship_to__c = destinationMarket;
                sdhObj.Port_of_Loading_Ship_From__c = portOfLoading;
                sdhObj.Country_of_Origin__c = countryOfOrigin;

                sdhObj.Payment_Term_Days__c = Integer.valueOf(paymentTermDay);
                sdhObj.Harmonized_Code__c = harmonizeCode;  
                sdhObj.Shipment_Declaration__c= shipmentId;
                sdhObj.Reason_For_Amendment__c= ReasonForAmendment;
                sdhObj.Endorsement__c = endorsementValue;
                if(contractualSeller!=null && !contractualSeller.equals('')){
                    sdhObj.Who_is_the_contractual_seller__c = contractualSeller;
                }
                insert sdhObj;
                System.debug('Shipment Declaration History is created successfully');
            }
        } catch (Exception e) { 
            System.debug('Exception while parsing date '+e.getMessage()+' Stack '+e.getStackTraceString());
            throw new AuraHandledException(e.getMessage()); 
            
        }
        return isShipmentDecalarationCreated;
    }
    @AuraEnabled
    public static Boolean  validateShipmentDate(String shipmentDate){
        System.debug('shipmentDate :'+shipmentDate);
        Boolean isValidated=false;
        if(shipmentDate != null){
            String[] actuaDateFull = shipmentDate.split('-');
            Integer shipmentYear = Integer.valueOf(actuaDateFull[0]);
            Integer shipmentMonth = Integer.valueOf(actuaDateFull[1]);
            Integer shipmentDayOfTheMonth = Integer.valueOf(actuaDateFull[2]);
            System.debug('shipmentYear :'+shipmentYear+' shipmentMonth:'+shipmentMonth+' shipmentDayOfTheMonth:'+shipmentDayOfTheMonth);
            if (shipmentDayOfTheMonth>0) {
                Date d =date.today();
                Integer currentDayOfTheMonth = Integer.valueOf(d.day());
                System.debug(' currentDayOfTheMonth:'+currentDayOfTheMonth);

                Integer currentMonth = Integer.valueOf(d.month());

                Integer currentYear = Integer.valueOf(d.year());
                System.debug('currentYear :'+currentYear+' currentMonth:'+currentMonth+' currentDayOfTheMonth:'+currentDayOfTheMonth);
                if (currentYear == shipmentYear) {
                    if (currentDayOfTheMonth <= 14) {
                        if ( (shipmentMonth == currentMonth) || (shipmentMonth == (currentMonth-1)) ) {
                            isValidated = true;
                        }
                    }else  if(currentDayOfTheMonth > 14) {
                        if ( shipmentMonth == currentMonth ) {
                            isValidated = true;
                        }
                    }
                }
            }
        }
        System.debug('isValidated :'+isValidated);
        return isValidated;
    }


    @AuraEnabled
    public static ECIC_Settings__c  getEcicSettings(String msg){
        ECIC_Settings__c settingOBJ =new ECIC_Settings__c();
        settingOBJ = [select Enable_Monthy_Lump_Sum__c,Allowed_Port_of_Loading__c from ECIC_Settings__c limit 1 ];
        System.debug('settingOBJ :'+settingOBJ);
        return settingOBJ;
    }

    @AuraEnabled
    public static Boolean updateSettlement(List <String> shipIDList){
        System.debug('shipIDList :'+shipIDList);
        Boolean isUpdated=false;
        List<Shipment_Declaration__c> sdList;
        List<Shipment_Declaration__c> updateSdList = new List<Shipment_Declaration__c>();
        try {
            if (shipIDList != null && !shipIDList.isEmpty()) {
                for(Shipment_Declaration__c shipObj : [select Status__c from Shipment_Declaration__c where id in :shipIDList ]){
                    shipObj.Status__c='Submitted';
                    shipObj.Final_Satus__c='Settled';
                    updateSdList.add(shipObj);
                }
                if(updateSdList != null && !updateSdList.isEmpty()){
                    update updateSdList;
                    System.debug('Shipment Updated Succesfully!!!');
                    isUpdated=true;
                } 
                
            }
        } catch (Exception e) {
            System.debug('Exception at updateSettlement Msg :'+e.getMessage()+' Stack :'+e.getStackTraceString());
        }
       
        return isUpdated;
    }

    public class WrapperShipmentDeclarationHistory{
        @AuraEnabled
        public Boolean isShowDetais{get;set;}
        @AuraEnabled
        public Date createdDate{get;set;}

        @AuraEnabled
        public Boolean preShipmentDeclaration{get;set;}
        @AuraEnabled
        public String Id{get;set;}
        @AuraEnabled
        public String name{get;set;}
        @AuraEnabled
        public String buyerName{get;set;}
        @AuraEnabled
        public String buyerCode{get;set;}

        @AuraEnabled
        public Date shipMentDate{get;set;}

        @AuraEnabled
        public String ecicCurrency{get;set;}
        @AuraEnabled
        public Decimal grossInvoiceValue{get;set;}
        @AuraEnabled
        public Decimal grossInvoiceValueHKD{get;set;}
        @AuraEnabled
        public Decimal premiumHKD{get;set;}
        @AuraEnabled
        public String paymentTerm{get;set;}
        @AuraEnabled
        public Date dueDate{get;set;}

        @AuraEnabled
        public String endorsement{get;set;}

        @AuraEnabled
        public Boolean subsYesNo{get;set;}
        @AuraEnabled
        public String portOfLoading{get;set;}

        @AuraEnabled
        public String countryOrigin{get;set;}
        @AuraEnabled
        public String destinationCountry{get;set;}
        @AuraEnabled
        public Date invoiceDate{get;set;}
        @AuraEnabled
        public String harmonizedCode{get;set;}
        @AuraEnabled
        public String phRefNo{get;set;}
        @AuraEnabled
        public Decimal paymentTermDay{get;set;}
        @AuraEnabled
        public String status{get;set;}
        @AuraEnabled
        public String shipmentType{get;set;}
        @AuraEnabled
        public String coverButtonIcon{get;set;}
    }
    @AuraEnabled
    public static List<WrapperShipmentDeclarationHistory> fetchAllShipDecHistory(Id shipmentID){
        System.debug('fetchAllShipDecHistory shipmentID : '+shipmentID);
        List<WrapperShipmentDeclarationHistory> wrapShipDecist = new List<WrapperShipmentDeclarationHistory>();
        try {
            //Gross_Invoice_Value__c
                
            for(Shipment_Declaration_History__c sdh : [select id,name,Buyer_Name__c,Buyer_Code__c,CreatedDate,Gross_Invoice_Value__c,
                                                        Pre_Shipment_Declaration__c,Due_Date__c,Endorsement__c,Shipment_was_made_by_anoverseas_subsidia__c,
                                                        Policyholder_Reference_No__c,Shipment_Date__c,Currency__c,Payment_Term_Type__c,
                                                        Port_of_Loading_Ship_From__c,Destination_Country_Market_Ship_to__c,Country_of_Origin__c,Status__c,
                                                        Invoice_Date__c,Payment_Term_Days__c,Type__c,Harmonized_Code__c
                                                        from Shipment_Declaration_History__c where Shipment_Declaration__c =:shipmentID order by CreatedDate desc ])
            {
                WrapperShipmentDeclarationHistory wsdh = new WrapperShipmentDeclarationHistory();//
                wsdh.Id = sdh.id;
                
                wsdh.isShowDetais = false;
                wsdh.name = sdh.name;
                wsdh.buyerName = sdh.Buyer_Name__c;
                wsdh.buyerCode = sdh.Buyer_Code__c;
                wsdh.grossInvoiceValue = sdh.Gross_Invoice_Value__c;
                DateTime dT = sdh.createdDate;
                wsdh.createdDate = Date.newInstance(dT.year(), dT.month(), dT.day());
                wsdh.preShipmentDeclaration = sdh.Pre_Shipment_Declaration__c;
                //wsdh.premium =210000.000; //sd.Pre_Shipment_Declaration__c;
                DateTime dT1 = sdh.Due_Date__c;
                if(sdh.Due_Date__c != null){
                    wsdh.dueDate = Date.newInstance(dT1.year(), dT1.month(), dT1.day());
                }
                if(sdh.Shipment_Date__c != null){
                    wsdh.shipMentDate =sdh.Shipment_Date__c; //Date.newInstance(dT1.year(), dT1.month(), dT1.day());
                }
                
                wsdh.endorsement = sdh.Endorsement__c;
                wsdh.subsYesNo = sdh.Shipment_was_made_by_anoverseas_subsidia__c;
                wsdh.harmonizedCode = sdh.Harmonized_Code__c;
                wsdh.phRefNo = sdh.Policyholder_Reference_No__c;
                wsdh.ecicCurrency = sdh.Currency__c;
                wsdh.paymentTerm = sdh.Payment_Term_Type__c;
                wsdh.paymentTermDay = sdh.Payment_Term_Days__c;
                wsdh.portOfLoading = sdh.Port_of_Loading_Ship_From__c;
                wsdh.destinationCountry = sdh.Destination_Country_Market_Ship_to__c;
                wsdh.countryOrigin = sdh.Country_of_Origin__c;
                wsdh.status = sdh.Status__c;
                wsdh.coverButtonIcon = 'utility:up';
                wrapShipDecist.add(wsdh);
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        System.debug('wrapShipDecist : '+wrapShipDecist);
        return wrapShipDecist;
       
    }
    public static Boolean checkSchedule2ForPortOfLoading(String policyID,String portOfLoading){
        System.debug('checkSchedule2ForPortOfLoading :'+portOfLoading);
        Boolean addAuto=true;
        List<Policy_Schedule__c> schList = [select Port_of_Loading__c from Policy_Schedule__c where Port_of_Loading__c INCLUDES(:portOfLoading) and Type__c='Schedule 2' and Policy__c=:policyID];
        System.debug('Schedule schList :'+schList);
        if(schList == null || schList.isEmpty()){
            List<ECIC_Settings__c> settingList =[select Allowed_Port_of_Loading__c from ECIC_Settings__c where Allowed_Port_of_Loading__c INCLUDES(:portOfLoading) limit 1 ];
            System.debug('settingList :'+settingList);
            if(settingList == null || settingList.isEmpty()){
                System.debug('Not Allowed');
                addAuto = false;
            }else{
                List<Policy_Schedule__c> polSchList = new List<Policy_Schedule__c>();
                for(Policy_Schedule__c polSch : [select Port_of_Loading__c from Policy_Schedule__c where Policy__c =:policyID and Type__c = 'Schedule 2']){
                    //Policy_Schedule__c schUpdate = new Policy_Schedule__c();
                    polSch.Port_of_Loading__c = polSch.Port_of_Loading__c+';'+ portOfLoading;
                    polSchList.add(polSch);
                }
                if(polSchList != null && !polSchList.isEmpty()){
                    update polSchList;
                    System.debug('Schedule 2 update successfully!!!.');
                }

            }
        }
        System.debug('addAuto : '+addAuto);
        return addAuto;
    }
    @AuraEnabled
    public static Boolean changeStatusForApproval(String shipmentDecId,
                                                String actionFor,
                                                String reasonForCancellation){
        System.debug('changeStatusForApproval : '+shipmentDecId+' actionFor :'+actionFor+' reasonForCancellation:'+reasonForCancellation);
        Boolean isSuccess=false;
        try {
            List<Shipment_Declaration__c> sdList = new List<Shipment_Declaration__c>();
            
            for(Shipment_Declaration__c sd : [select Status__c from Shipment_Declaration__c where id = :shipmentDecId]){
                //Shipment_Declaration__c sdObj = new Shipment_Declaration__c();
                if(actionFor.equals('Amend')){
                    sd.Status__c = 'Amendment pending for SME team staff approval';
                }else if(actionFor.equals('Cancel')){
                    sd.Status__c = 'Cancellation pending for SME team staff approval';
                    sd.Reason_For_Cancellation__c = reasonForCancellation;
                }
                
                sdList.add(sd);
            }
            if(sdList != null && !sdList.isEmpty()){
                update sdList;
                isSuccess = true;
                System.debug('Shipment Declaration Update!!!');
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return isSuccess;
    }

    @InvocableMethod(label='Add Port Of Loading' description='')
    public static void addPortOfLoadingToSchedule2(List<ID> ids){
        List<Policy_Schedule__c> polSchList = new List<Policy_Schedule__c>();
        List<Shipment_Declaration__c> sdList = [select Policy__c,Port_of_Loading_Ship_From__c from Shipment_Declaration__c where id in :ids];
        System.debug('sdList : '+sdList);
        if(sdList != null && !sdList.isEmpty()){
            for(Policy_Schedule__c polSch : [select Port_of_Loading__c from Policy_Schedule__c where Policy__c =:sdList[0].Policy__c and Type__c = 'Schedule 2']){
                //Policy_Schedule__c schUpdate = new Policy_Schedule__c();
                polSch.Port_of_Loading__c = polSch.Port_of_Loading__c+';'+ sdList[0].Port_of_Loading_Ship_From__c;
                polSchList.add(polSch);
            }

        }
        if(polSchList != null && !polSchList.isEmpty()){
            update polSchList;
            System.debug('Schedule 2 update successfully!!!.');
        }
    }

    @AuraEnabled
    public static Date  adjustInvoiceDate(String shipmentDate,
                                        String paymentTermType,
                                        String paymentTermDay){
        System.debug('shipmentDate :'+shipmentDate);
        Boolean isValidated=false;
        Date newInvoiceDate;
        if(shipmentDate != null){
            String[] actuaDateFull = shipmentDate.split('-');
            Integer shipmentYear = Integer.valueOf(actuaDateFull[0]);
            Integer shipmentMonth = Integer.valueOf(actuaDateFull[1]);
            Integer shipmentDayOfTheMonth = Integer.valueOf(actuaDateFull[2]);
            System.debug('shipmentYear :'+shipmentYear+' shipmentMonth:'+shipmentMonth+' shipmentDayOfTheMonth:'+shipmentDayOfTheMonth);
            /*if (shipmentDayOfTheMonth>0) {
                Date d =date.today();
                Integer currentDayOfTheMonth = Integer.valueOf(d.day());
                System.debug(' currentDayOfTheMonth:'+currentDayOfTheMonth);

                Integer currentMonth = Integer.valueOf(d.month());

                Integer currentYear = Integer.valueOf(d.year());
                System.debug('currentYear :'+currentYear+' currentMonth:'+currentMonth+' currentDayOfTheMonth:'+currentDayOfTheMonth);
                if (currentYear == shipmentYear) {
                    if (currentDayOfTheMonth <= 14) {
                        if ( (shipmentMonth == currentMonth) || (shipmentMonth == (currentMonth-1)) ) {
                            isValidated = true;
                        }
                    }else  if(currentDayOfTheMonth > 14) {
                        if ( shipmentMonth == currentMonth ) {
                            isValidated = true;
                        }
                    }
                }
            }*/
            Date myDate = Date.newInstance(shipmentYear, shipmentMonth, shipmentDayOfTheMonth);
            newInvoiceDate = mydate.addDays(Integer.valueOf(paymentTermDay));
            System.debug('Invoice Date : '+newInvoiceDate);
        }
        return newInvoiceDate;
    }
    
}