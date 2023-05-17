public with sharing class ShipmentDeclarationBulk {
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
    }
   
    

    @AuraEnabled
    public static Boolean createShipmentDecalaration(String policyID,
                                                    String buyerName,
                                                    String buyerCode,
                                                    Decimal givValue,
                                                    String shipmentType,
                                                    Boolean preShipYes,
                                                    Boolean shipOverSubYes,
                                                    Date shipmentDate,
                                                    Date contractDate,
                                                    String ecic_currency,
                                                    String paymentTermType,
                                                    String refNo,
                                                    String destinationMarket,
                                                    String portOfLoading,
                                                    String paymentTermDay,
                                                    Date invoiceDate
                                                    ){
        
        System.debug('policyID :'+policyID+' buyerName : '+buyerName+'\nbuyerCode :'+buyerCode+' givValue:'+givValue+' shipmentType:'+shipmentType+' invoiceDate:'+invoiceDate);
        System.debug('preShipYes :'+preShipYes+' shipOverSubYes : '+shipOverSubYes+'\nshipmentDate :'+shipmentDate+' contractDate:'+contractDate+' ecic_currency:'+ecic_currency);
        System.debug('paymentTermType :'+paymentTermType+' refNo : '+refNo+'\ndestinationMarket :'+destinationMarket+' portOfLoading:'+portOfLoading+' paymentTermDay:'+paymentTermDay);

        Boolean isShipmentDecalarationCreated;
        try {
            Shipment_Declaration__c shipDecObj = new Shipment_Declaration__c();
            shipDecObj.Buyer_Name__c = buyerName;
            shipDecObj.Buyer_Code__c = buyerCode;
            // shipDecObj.Gross_Invoice_Value__c = givValue;
            shipDecObj.Policy__c = policyID;
            shipDecObj.Type__c = shipmentType;
            if(preShipYes){
                shipDecObj.Pre_Shipment_Declaration__c = preShipYes;
            }
            if(shipOverSubYes){
                shipDecObj.Shipment_was_made_by_anoverseas_subsidia__c = shipOverSubYes;
            }
            shipDecObj.Currency__c = ecic_currency;
            shipDecObj.Payment_Term_Type__c = paymentTermType;
            shipDecObj.Policyholder_Reference_No__c = refNo;
            shipDecObj.Destination_Country_Market_Ship_to__c = destinationMarket;
            shipDecObj.Port_of_Loading_Ship_From__c = portOfLoading;
            shipDecObj.Payment_Term_Days__c = Integer.valueOf(paymentTermDay);

            insert shipDecObj;
            isShipmentDecalarationCreated = true;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return isShipmentDecalarationCreated;
    }

    @AuraEnabled
    public static Date  addJustInvoice(String addToInvoiceDate){
        return System.today().addDays(Integer.valueOf(addToInvoiceDate));

    }

    @AuraEnabled(cacheable = true)
    public static List<WrapperBuyerInformation> getBuyerInformationBulk(Id usrId){

        List<WrapperBuyerInformation> buyerInfoObjList = new List<WrapperBuyerInformation>();
    
        boolean isCreditLimitChecked=false;
        String accountID = getAccountID(usrId);
        
        //queryAll
        String queryAll='Select Id,name,(select id,Buyer_Name__c,Buyer_Code__c, Payment_Term_Type__c,Ref_No__c,Destination_Market__c,Port_Of_Loading__c,Policy__c from Credit_Limits__r   ),'+
        +'(select id,Buyer_Name__c,Buyer_Code__c, Payment_Term_Type__c,Ref_No__c,Destination_Market__c,Port_Of_Loading__c,Policy__c from Credit_Limit_Applications__r  )'
        + 'FROM Account WHERE Id = \'' +accountID + '\'';

        System.Debug('queryAll :: '+ queryAll);

        List<Account> accObjList = Database.query(queryAll);
        
        for (Account accObj : accObjList) {
            
            for(Credit_Limit__c cl : accObj.Credit_Limits__r){
                WrapperBuyerInformation buyerInfoObj = new WrapperBuyerInformation();
                buyerInfoObj.id = cl.id;
                buyerInfoObj.buyerName = cl.Buyer_Name__c;
                buyerInfoObj.buyerCode = cl.Buyer_Code__c;
                // buyerInfoObj.harmonizeCode = String.valueOf(cl.Harmonized_Code__c);
                buyerInfoObj.paymentTermType = cl.Payment_Term_Type__c;
                buyerInfoObj.refNo = cl.Ref_No__c;
                buyerInfoObj.destinationMarket = cl.Destination_Market__c;
                buyerInfoObj.portOfLoading = cl.Port_Of_Loading__c;
                buyerInfoObj.policyID = cl.Policy__c;
                buyerInfoObj.isSuccess = true;
                // isCreditLimitChecked = true;
                buyerInfoObjList.add(buyerInfoObj);
                // break;
            }
            
            // if(!isCreditLimitChecked){
                for(Credit_Limit_Application__c cl : accObj.Credit_Limit_Applications__r){
                    WrapperBuyerInformation buyerInfoObj = new WrapperBuyerInformation();
                    buyerInfoObj.id = cl.id;
                    buyerInfoObj.buyerName = cl.Buyer_Name__c;
                    buyerInfoObj.buyerCode = cl.Buyer_Code__c;
                    // buyerInfoObj.harmonizeCode = String.valueOf(cl.Harmonized_Code__c);
                    buyerInfoObj.paymentTermType = cl.Payment_Term_Type__c;
                    buyerInfoObj.refNo = cl.Ref_No__c;
                    buyerInfoObj.destinationMarket = cl.Destination_Market__c;
                    buyerInfoObj.portOfLoading = cl.Port_Of_Loading__c;
                    buyerInfoObj.policyID = cl.Policy__c;
                    buyerInfoObj.isSuccess = true;
                    buyerInfoObjList.add(buyerInfoObj);
                    // break;
                }
            // }
        }
        System.Debug('buyerInfoObjList : '+buyerInfoObjList);
        return buyerInfoObjList;

    }

    @AuraEnabled
    public static Boolean createShipmentDecalarationBulk(List<Map<String,String>> shipDecList,
                                                    Id policyId){
        
        // System.debug('policyID :'+policyID+' buyerName : '+buyerName+'\nbuyerCode :'+buyerCode+' givValue:'+givValue+' shipmentType:'+shipmentType+' invoiceDate:'+invoiceDate);
        // System.debug('preShipYes :'+preShipYes+' shipOverSubYes : '+shipOverSubYes+'\nshipmentDate :'+shipmentDate+' contractDate:'+contractDate+' ecic_currency:'+ecic_currency);
        // System.debug('paymentTermType :'+paymentTermType+' refNo : '+refNo+'\ndestinationMarket :'+destinationMarket+' portOfLoading:'+portOfLoading+' paymentTermDay:'+paymentTermDay);
        System.debug('shipDecist::'+shipDecList);
        Boolean isShipmentDecalarationCreated;
        List<Shipment_Declaration__c> shipDecObjList = new List<Shipment_Declaration__c>();

        try {
            for (Map<String,String> shipDec : shipDecList) {
                Shipment_Declaration__c shipDecObj = new Shipment_Declaration__c();
                shipDecObj.Buyer_Name__c = shipDec.get('Buyer_Name__c');
                shipDecObj.Buyer_Code__c = shipDec.get('Buyer_Code__c');
                // shipDecObj.Gross_Invoice_Value__c = Decimal.valueOf(shipDec.get('Gross_Invoice_Value__c'));
                shipDecObj.Policy__c = policyId;
                shipDecObj.Type__c = 'Individual';//shipDec.get('Type__c');
                shipDecObj.Reason_For_Late_Declaration__c = shipDec.get('Reason_For_Late_Declaration__c');
                shipDecObj.Currency__c = shipDec.get('Currency__c');
                shipDecObj.Payment_Term_Type__c = shipDec.get('Payment_Term_Type__c');
                shipDecObj.Policyholder_Reference_No__c = shipDec.get('Policyholder_Reference_No__c');
                shipDecObj.Destination_Country_Market_Ship_to__c = shipDec.get('Destination_Country_Market_Ship_to__c');
                shipDecObj.Port_of_Loading_Ship_From__c = shipDec.get('Port_of_Loading_Ship_From__c');
                shipDecObj.Overseas_Subsidiary_Name__c = shipDec.get('Overseas_Subsidiary_Name__c');
                // shipDecObj.Harmonized_Code__c = shipDec.get('Harmonized_Code__c');
                
                try {
                    shipDecObj.Endorsement__c=shipDec.get('Endorsement__c');
                } catch (Exception e) {
                    System.debug('invalid Endorsement__c::'+e.getMessage());
                }
                try {
                    shipDecObj.Country_of_Origin__c=shipDec.get('Country_of_Origin__c');
                } catch (Exception e) {
                    System.debug('invalid Country_of_Origin__c::'+e.getMessage());
                }
                
                try {
                    shipDecObj.Shipment_Date__c=Date.valueOf(shipDec.get('Shipment_Date__c'));
                } catch (Exception e) {
                    System.debug('invalid ship date::'+e.getMessage());
                }
                try {
                    shipDecObj.Due_Date__c=Date.valueOf(shipDec.get('Due_Date__c'));
                } catch (Exception e) {
                    System.debug('invalid due date::'+e.getMessage());
                }
                try {
                    shipDecObj.Payment_Term_Days__c = Integer.valueOf(shipDec.get('Payment_Term_Days__c'));
                } catch (Exception e) {
                    shipDecObj.Payment_Term_Days__c = 0;
                }

                if(shipDec.get('Pre_Shipment_Declaration__c').toLowercase()== 'yes'){
                    shipDecObj.Pre_Shipment_Declaration__c = true;
                }
                if(shipDec.get('Shipment_was_made_by_anoverseas_subsidia__c').toLowercase()== 'yes'){
                    shipDecObj.Shipment_was_made_by_anoverseas_subsidia__c = true;
                }
                shipDecObjList.add(shipDecObj);    
            }
            insert shipDecObjList;
            isShipmentDecalarationCreated = true;
        } catch (Exception e) {
            System.debug('create ShipmentDeclaration bulk err::'+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
        return isShipmentDecalarationCreated;
    }

    @AuraEnabled
    public static string getBulkUploadTemplateUrl(){
        try {
            return [select Content_Id__c, Name, Content_URL__c from CMS_Content__c  where Name ='Shimpemt Declaration Bulk Template'].Content_URL__c;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}