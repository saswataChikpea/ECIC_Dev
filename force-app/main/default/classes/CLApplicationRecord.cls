public with sharing class CLApplicationRecord {

    public class ClClaWrapper {
        @AuraEnabled
        public List<Credit_Limit__c> clList{get;set;}
        @AuraEnabled
        public List<Credit_Limit_Application__c> claList{get;set;}
        public ClClaWrapper(){
            this.clList = new list<Credit_Limit__c>();
            this.claList = new list<Credit_Limit_Application__c>();
        }
    }

    @AuraEnabled
    public static ClClaWrapper getCLCLAListByPolicy(Id policy_id){
        try {
            ClClaWrapper clwrapper = new ClClaWrapper();
            clwrapper.clList = [Select Id,Name,CL_Amount__c,CL_Status__c,CL_No__c,Application_Date__c,Buyer_Address_Line_1__c,Buyer_Address_Line_2__c,Buyer_Address_Line_3__c,Buyer_Address_Line_4__c,Buyer_Code__c,Buyer_Country__c,Buyer_Name__c,CL_Effective_Date__c,CL_Application_Amount__c,Premium__c,Ref_No__c,Remarks__c,Expiry_Date__c,ECIC_Internal_System_Status__c,Harmonized_Code__c,Payment_Term_Days__c,Payment_Term_Type__c,Port_Of_Loading__c,Market_of_Origin__c,Destination_Market__c,Export_Type__c,Buyer_Registration_Number__c,Is_Uplifted__c,Goods_or_Services_Involved__c,Specific_Goods_Involved__c,CL_Progress_Step__c,Legacy_Ref_No__c,CL_Approve_Letter__c from Credit_Limit__c where Policy__c=:policy_id and Is_DCL__c=false];
            clwrapper.claList = [Select Id,Name,CL_Amount__c,CL_Status__c,CL_No__c,Application_Date__c,Buyer_Address_Line_1__c,Buyer_Address_Line_2__c,Buyer_Address_Line_3__c,Buyer_Address_Line_4__c,Buyer_Code__c,Buyer_Country__c,Buyer_Name__c,CL_Effective_Date__c,CL_Application_Amount__c,Premium__c,Ref_No__c,Remarks__c,Expiry_Date__c,ECIC_Internal_System_Status__c,Application_Type__c,Credit_Limit_Id__c,CL_Progress_Step__c,Legacy_Ref_No__c,CLA_Cancel_Letter__c from Credit_Limit_Application__c where Policy__c=:policy_id and is_draft__c=false and Is_DCL__c=false];
            return clwrapper;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static ClClaWrapper getDCLDCLAListByPolicy(Id policy_id){
        try {
            ClClaWrapper clwrapper = new ClClaWrapper();
            clwrapper.clList = [Select Id,Name,CL_Amount__c,CL_Status__c,CL_No__c,Application_Date__c,Buyer_Address_Line_1__c,Buyer_Address_Line_2__c,Buyer_Address_Line_3__c,Buyer_Address_Line_4__c,Buyer_Code__c,Buyer_Country__c,Buyer_Name__c,CL_Effective_Date__c,CL_Application_Amount__c,Premium__c,Ref_No__c,Remarks__c,Expiry_Date__c,ECIC_Internal_System_Status__c,Harmonized_Code__c,Payment_Term_Days__c,Payment_Term_Type__c,Port_Of_Loading__c,Market_of_Origin__c,Destination_Market__c,Export_Type__c,Buyer_Registration_Number__c,Is_Uplifted__c,Goods_or_Services_Involved__c,Specific_Goods_Involved__c,Legacy_Ref_No__c from Credit_Limit__c where Policy__c=:policy_id and Is_DCL__c=true];
            clwrapper.claList = [Select Id,Name,CL_Amount__c,CL_Status__c,CL_No__c,Application_Date__c,Buyer_Address_Line_1__c,Buyer_Address_Line_2__c,Buyer_Address_Line_3__c,Buyer_Address_Line_4__c,Buyer_Code__c,Buyer_Country__c,Buyer_Name__c,CL_Effective_Date__c,CL_Application_Amount__c,Premium__c,Ref_No__c,Remarks__c,Expiry_Date__c,ECIC_Internal_System_Status__c,Application_Type__c,Credit_Limit_Id__c,Legacy_Ref_No__c from Credit_Limit_Application__c where Policy__c=:policy_id and Is_DCL__c=true and cl_Status__c!='Approved'];
            return clwrapper;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    
    @AuraEnabled
    public static ClClaWrapper getCreditLimitRecord(String buyer_name,String buyer_code,String status,String from_date,String to_date,Id policy_id){
        System.debug('getCreditLimitRecord');
        try{
            String base_q = 'Select Id,CL_Amount__c,CL_Status__c,CL_No__c,Ref_No__c,Remarks__c,CL_Application_Amount__c,Application_Date__c,CL_Effective_Date__c,Premium__c,Expiry_Date__c,Policy_Fee__c,Buyer_Name__c,Buyer_Address_Line_1__c,Buyer_Address_Line_2__c,Buyer_Address_Line_3__c,Buyer_Address_Line_4__c,Buyer_Code__c,Buyer_Country__c,ECIC_Internal_System_Status__c,Harmonized_Code__c,Payment_Term_Days__c,Payment_Term_Type__c,Port_Of_Loading__c,Market_of_Origin__c,Destination_Market__c,Export_Type__c,Buyer_Registration_Number__c,Is_Uplifted__c,Goods_or_Services_Involved__c,Specific_Goods_Involved__c,CL_Progress_Step__c,Legacy_Ref_No__c,CL_Approve_Letter__c from Credit_Limit__c where Policy__c=\''+policy_id+'\' and Is_DCL__c=false and ';
            String base_q2 = 'Select Id,Name,CL_Amount__c,CL_Status__c,CL_No__c,Application_Date__c,Buyer_Address_Line_1__c,Buyer_Address_Line_2__c,Buyer_Address_Line_3__c,Buyer_Address_Line_4__c,Buyer_Code__c,Buyer_Country__c,Buyer_Name__c,CL_Effective_Date__c,CL_Application_Amount__c,Ref_No__c,Remarks__c,Expiry_Date__c,ECIC_Internal_System_Status__c,Application_Type__c,Credit_Limit_Id__c,CL_Progress_Step__c,Legacy_Ref_No__c,Discount_Amount__c,Discount_Rate__c,Premium_Rate__c,Premium__c,CLA_Cancel_Letter__c from Credit_Limit_Application__c where Policy__c=\''+policy_id+'\' and is_draft__c=false and Hide_from_PH__c!=true and Is_DCL__c=false and ';
            Boolean add_and = false;
            if ((buyer_name!=null) && (buyer_name!='null') && (buyer_name!='')){
                // buyer_name = '%' + buyer_name + '%';
                base_q = base_q + 'Buyer_Name__c LIKE \'%' + buyer_name +'%\'';
                base_q2 = base_q2 + 'Buyer_Name__c LIKE \'%' + buyer_name +'%\'';
                add_and = true;
            }
            if ((buyer_code!=null) && (buyer_code!='null') && (buyer_code!='')){
                // buyer_name = '%' + buyer_name + '%';
                if(add_and){
                    base_q = base_q + 'and Buyer_Code__c LIKE \'%' + buyer_code +'%\'';
                    base_q2 = base_q2 + 'and Buyer_Code__c LIKE \'%' + buyer_code +'%\'';
                } else {
                    base_q = base_q + 'Buyer_Code__c LIKE \'%' + buyer_code +'%\'';
                    base_q2 = base_q2 + 'Buyer_Code__c LIKE \'%' + buyer_code +'%\'';
                }
                add_and = true;
            }
            if ((status!=null) && (status!='null') && (status!='')){
                // buyer_name = '%' + buyer_name + '%';
                if(add_and){
                    base_q = base_q + 'and CL_Status__c LIKE \'%' + status +'%\'';
                    base_q2 = base_q2 + 'and CL_Status__c LIKE \'%' + status +'%\'';
                } else {
                    base_q = base_q + 'CL_Status__c LIKE \'%' + status +'%\'';
                    base_q2 = base_q2 + 'CL_Status__c LIKE \'%' + status +'%\'';
                }
                add_and = true;
            }
            /*if ((from_date!=null) && (from_date!='null') && (from_date!='')){
                // buyer_name = '%' + buyer_name + '%';
                if(add_and){
                    base_q = base_q + 'and CL_Effective_Date__c ='  + from_date ;
                } else {
                    base_q = base_q + 'CL_Effective_Date__c = ' + from_date ;
                }
                add_and = true;
            }*/
            if ((from_date!=null) && (from_date!='null') && (from_date!='')){
                // buyer_name = '%' + buyer_name + '%';
                if(add_and){
                    base_q = base_q + 'and CL_Effective_Date__c >='  + from_date ;
                    base_q2 = base_q2 + 'and CL_Effective_Date__c >='  + from_date ;
                } else {
                    base_q = base_q + 'CL_Effective_Date__c >= ' + from_date ;
                    base_q2 = base_q2 + 'CL_Effective_Date__c >= ' + from_date ;
                }
                add_and = true;
            }
            if ((to_date!=null) && (to_date!='null') && (to_date!='')){
                // buyer_name = '%' + buyer_name + '%';
                if(add_and){
                    base_q = base_q + 'and CL_Effective_Date__c <='  + to_date ;
                    base_q2 = base_q2 + 'and CL_Effective_Date__c <='  + to_date ;
                } else {
                    base_q = base_q + 'CL_Effective_Date__c <= ' + to_date ;
                    base_q2 = base_q2 + 'CL_Effective_Date__c <= ' + to_date ;
                }
                add_and = true;
            }
                
            base_q = base_q + 'order by Application_Date__c desc';
            base_q2 = base_q2 + 'order by Application_Date__c desc';
            System.debug(base_q);
            List <Credit_Limit__c> clList = Database.query(base_q);
            ClClaWrapper clwrapper = new ClClaWrapper();
            clwrapper.clList = Database.query(base_q);
            clwrapper.claList = Database.query(base_q2);
            return clwrapper;
            
            //System.debug('clList'+clList[0].Policy_Fee__c);
            // List<Credit_Limit__c> new_cl_list = new List<Credit_Limit__c>();
            // String json_string = JSON.serialize(clList,false);
            // System.debug(json_string);
            // return clList;
        } catch (Exception e) {
            System.debug('Error::'+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
        
    }
//-----------------------DCL search
@AuraEnabled
    public static ClClaWrapper getDiscretionaryCreditLimitRecord(String buyer_name,String buyer_code,String status,String from_date,String to_date,Id policy_id){
        System.debug('getCreditLimitRecord');
        try{
            String base_q = 'Select Id,CL_Amount__c,CL_Status__c,CL_No__c,Ref_No__c,Remarks__c,CL_Application_Amount__c,Application_Date__c,CL_Effective_Date__c,Premium__c,Expiry_Date__c,Policy_Fee__c,Buyer_Name__c,Buyer_Address_Line_1__c,Buyer_Address_Line_2__c,Buyer_Address_Line_3__c,Buyer_Address_Line_4__c,Buyer_Code__c,Buyer_Country__c,ECIC_Internal_System_Status__c,Harmonized_Code__c,Payment_Term_Days__c,Payment_Term_Type__c,Port_Of_Loading__c,Market_of_Origin__c,Destination_Market__c,Export_Type__c,Buyer_Registration_Number__c,Is_Uplifted__c,Goods_or_Services_Involved__c,Specific_Goods_Involved__c,CL_Progress_Step__c,Legacy_Ref_No__c from Credit_Limit__c where Policy__c=\''+policy_id+'\' and Is_DCL__c=true and ';
            String base_q2 = 'Select Id,Name,CL_Amount__c,CL_Status__c,CL_No__c,Application_Date__c,Buyer_Address_Line_1__c,Buyer_Address_Line_2__c,Buyer_Address_Line_3__c,Buyer_Address_Line_4__c,Buyer_Code__c,Buyer_Country__c,Buyer_Name__c,CL_Effective_Date__c,CL_Application_Amount__c,Premium__c,Ref_No__c,Remarks__c,Expiry_Date__c,ECIC_Internal_System_Status__c,Application_Type__c,Credit_Limit_Id__c,CL_Progress_Step__c,Legacy_Ref_No__c from Credit_Limit_Application__c where Policy__c=\''+policy_id+'\' and Is_DCL__c=true and ';
            Boolean add_and = false;
            if ((buyer_name!=null) && (buyer_name!='null') && (buyer_name!='')){
                // buyer_name = '%' + buyer_name + '%';
                base_q = base_q + 'Buyer_Name__c LIKE \'%' + buyer_name +'%\'';
                base_q2 = base_q2 + 'Buyer_Name__c LIKE \'%' + buyer_name +'%\'';
                add_and = true;
            }
            if ((buyer_code!=null) && (buyer_code!='null') && (buyer_code!='')){
                // buyer_name = '%' + buyer_name + '%';
                if(add_and){
                    base_q = base_q + 'and Buyer_Code__c LIKE \'%' + buyer_code +'%\'';
                    base_q2 = base_q2 + 'and Buyer_Code__c LIKE \'%' + buyer_code +'%\'';
                } else {
                    base_q = base_q + 'Buyer_Code__c LIKE \'%' + buyer_code +'%\'';
                    base_q2 = base_q2 + 'Buyer_Code__c LIKE \'%' + buyer_code +'%\'';
                }
                add_and = true;
            }
            if ((status!=null) && (status!='null') && (status!='')){
                // buyer_name = '%' + buyer_name + '%';
                if(add_and){
                    base_q = base_q + 'and CL_Status__c LIKE \'%' + status +'%\'';
                    base_q2 = base_q2 + 'and CL_Status__c LIKE \'%' + status +'%\'';
                } else {
                    base_q = base_q + 'CL_Status__c LIKE \'%' + status +'%\'';
                    base_q2 = base_q2 + 'CL_Status__c LIKE \'%' + status +'%\'';
                }
                add_and = true;
            }
            /*if ((from_date!=null) && (from_date!='null') && (from_date!='')){
                // buyer_name = '%' + buyer_name + '%';
                if(add_and){
                    base_q = base_q + 'and CL_Effective_Date__c ='  + from_date ;
                } else {
                    base_q = base_q + 'CL_Effective_Date__c = ' + from_date ;
                }
                add_and = true;
            }*/
            if ((from_date!=null) && (from_date!='null') && (from_date!='')){
                // buyer_name = '%' + buyer_name + '%';
                if(add_and){
                    base_q = base_q + 'and CL_Effective_Date__c >='  + from_date ;
                    base_q2 = base_q2 + 'and CL_Effective_Date__c >='  + from_date ;
                } else {
                    base_q = base_q + 'CL_Effective_Date__c >= ' + from_date ;
                    base_q2 = base_q2 + 'CL_Effective_Date__c >= ' + from_date ;
                }
                add_and = true;
            }
            if ((to_date!=null) && (to_date!='null') && (to_date!='')){
                // buyer_name = '%' + buyer_name + '%';
                if(add_and){
                    base_q = base_q + 'and CL_Effective_Date__c <='  + to_date ;
                    base_q2 = base_q2 + 'and CL_Effective_Date__c <='  + to_date ;
                } else {
                    base_q = base_q + 'CL_Effective_Date__c <= ' + to_date ;
                    base_q2 = base_q2 + 'CL_Effective_Date__c <= ' + to_date ;
                }
                add_and = true;
            }
                
            base_q = base_q + 'order by Application_Date__c desc';
            base_q2 = base_q2 + 'order by Application_Date__c desc';
            System.debug(base_q);
            List <Credit_Limit__c> clList = Database.query(base_q);
            ClClaWrapper clwrapper = new ClClaWrapper();
            clwrapper.clList = Database.query(base_q);
            clwrapper.claList = Database.query(base_q2);
            return clwrapper;
            
            //System.debug('clList'+clList[0].Policy_Fee__c);
            // List<Credit_Limit__c> new_cl_list = new List<Credit_Limit__c>();
            // String json_string = JSON.serialize(clList,false);
            // System.debug(json_string);
            // return clList;
        } catch (Exception e) {
            System.debug('Error::'+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
        
    }
//-----------------------DCL search

    @AuraEnabled
    public static ClClaWrapper getExistingDCL(Id policy_id,string buyer_code){
        try {
            ClClaWrapper clwrapper = new ClClaWrapper();
            clwrapper.clList = [Select Id,Name,CL_Amount__c,CL_Status__c,CL_No__c,Application_Date__c,Buyer_Address_Line_1__c,Buyer_Address_Line_2__c,Buyer_Address_Line_3__c,Buyer_Address_Line_4__c,Buyer_Code__c,Buyer_Country__c,Buyer_Name__c,CL_Effective_Date__c,CL_Application_Amount__c,Premium__c,Ref_No__c,Remarks__c,Expiry_Date__c,ECIC_Internal_System_Status__c,Harmonized_Code__c,Payment_Term_Days__c,Payment_Term_Type__c,Port_Of_Loading__c,Market_of_Origin__c,Destination_Market__c,Export_Type__c,Buyer_Registration_Number__c,Is_Uplifted__c,Goods_or_Services_Involved__c,Specific_Goods_Involved__c,Is_DCL__c from Credit_Limit__c where Policy__c=:policy_id and Buyer_Code__c=:buyer_code];
            clwrapper.claList = [Select Id,Name,CL_Amount__c,CL_Status__c,CL_No__c,Application_Date__c,Buyer_Address_Line_1__c,Buyer_Address_Line_2__c,Buyer_Address_Line_3__c,Buyer_Address_Line_4__c,Buyer_Code__c,Buyer_Country__c,Buyer_Name__c,CL_Effective_Date__c,CL_Application_Amount__c,Premium__c,Ref_No__c,Remarks__c,Expiry_Date__c,ECIC_Internal_System_Status__c,Application_Type__c,Credit_Limit_Id__c,Is_DCL__c from Credit_Limit_Application__c where Policy__c=:policy_id and Buyer_Code__c=:buyer_code];
            return clwrapper;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Credit_Limit_Application__c getCreditLimitApplicationRecordByID(Id cla_id){
        try{
            Credit_Limit_Application__c credit_limit_application = [Select Id,Application_Date__c,Application_Type__c,Buyer_Address_Line_1__c,Buyer_Address_Line_2__c,Buyer_Address_Line_3__c,Buyer_Address_Line_4__c,Buyer_Code__c,Buyer_Country__c,Buyer_Name__c,Buyer_Registration_Number__c,Buyer_Trading_Time__c,CL_Application_Amount__c,CL_Pre_Shipment_Application_AMount__c,CL_Type__c,Destination_Market__c,Discount_Rate__c,Discount_Amount__c,DNB_DUNS__c,Existing_valid_Credit_Limit_on_Buyer__c,Export_Type__c,Goods_or_Services_Involved__c,Harmonized_Code__c,Is_New_Buyer__c,Is_Unpaid_Amount__c,Is_Unpaid_Shipment__c,Market_of_Origin__c,Order_Confirmed_or_Negotiation__c,Order_Payment_Term_Amount__c,Order_Payment_Term_Type__c,Overseas_Goods_or_Services__c,Payment_Term_Days__c,Payment_Term_Type__c,Premium__c,Premium_Rate__c,Policy__c,
            Port_Of_Loading__c,Pre_Shipment_Payment_Term_Days__c,Pre_Shipment_Payment_Term_Type__c,Previously_Cancelled_Order_Unilaterally__c,Received_Order_Amount__c,Received_Order_Payment_Type__c,Received_Order_Payment_Term_Method1__c,Received_Order_Payment_Term_Method2__c,Ref_No__c,Remarks__c,Shipment_Commence_Month__c,Shipment_Commence_Year__c,Shipment_Payment_Term_Amount_12_Months__c,Shipment_Payment_Term_Type_12_Months__c,Shipment_Payment_Term_Method_12_Months1__c,Shipment_Payment_Term_Days_12_Months__c,Shipment_Payment_Term_Method_12_Months2__c,Shipment_Payment_Term_Method_12_Months3__c,Shipment_Payment_Term_Method_12_Months4__c,Shipment_Payment_Term_Method_12_Months5__c,Order_Payment_Term_Days__c,Order_Payment_Term_Amount_12_Months__c,Order_Payment_Term_Days_12_Months__c,Order_Payment_Term_Method_12_Months1__c,Order_Payment_Term_Method_12_Months2__c,Order_Payment_Term_Method_12_Months3__c,Order_Payment_Term_Method_12_Months4__c,Order_Payment_Term_Method_12_Months5__c,Confirm_Order_Payment_Terms_Method1__c,Confirm_Order_Payment_Terms_Method2__c,Confirm_Order_Payment_Terms_Method3__c,Confirm_Order_Payment_Terms_Method4__c,Confirm_Order_Payment_Terms_Method5__c,Specific_Goods_Involved__c,Unpaid_Overdue_Order__c,Legacy_Ref_No__c,(select Due_Date__c,Gross_Invoice_Amount__c,Gross_Invoice_Currency__c,Payment_Term_Days__c,Payment_Term_Type__c,Shipment_Or_Invoice_Date__c,Remarks__c from Outstanding_Payments__r) from Credit_Limit_Application__c where Id=:cla_id];
            return credit_limit_application;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static Credit_Limit__c getCreditLimitRecordByID(Id cl_id){
        try{
            return [Select Id,Exporter__c,Policy__c,policy__r.Product__r.Name,CL_Amount__c,CL_Status__c,CL_No__c,Ref_No__c,Remarks__c,CL_Application_Amount__c,Application_Date__c,CL_Effective_Date__c,Premium__c,Expiry_Date__c from Credit_Limit__c where Id=:cl_id];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    // @AuraEnabled
    // public static List<Credit_Limit__c> getCLByPolicy(Id policy_id){
    //     try{
    //         List<Credit_Limit__c> credit_limit = [Select Id,Name,CL_Amount__c,CL_Status__c,CL_No__c,Application_Date__c,Buyer__r.Buyer_Code__c,Buyer__r.Name,CL_Effective_Date__c from Credit_Limit__c where Policy__c=:policy_id];
    //         return credit_limit;
    //     } catch (Exception e) {
    //         throw new AuraHandledException(e.getMessage());
    //     }
    // }
    
    @AuraEnabled
    public static List<Credit_Limit__c> getCLListByPolicy(Id policy_id){
        try{
            List<Credit_Limit__c> credit_limit = [Select Id,Name,Approve_Date__c,CL_Amount__c,CL_Status__c,CL_No__c,Application_Date__c,Buyer_Address_Line_1__c,Buyer_Address_Line_2__c,Buyer_Address_Line_3__c,Buyer_Address_Line_4__c,Buyer_Code__c,Buyer_Country__c,Buyer_Name__c,CL_Effective_Date__c,CL_Application_Amount__c,Premium__c,Ref_No__c,Remarks__c,Expiry_Date__c,ECIC_Internal_System_Status__c,Harmonized_Code__c,Payment_Term_Days__c,Payment_Term_Type__c,Port_Of_Loading__c,Market_of_Origin__c,Destination_Market__c,Export_Type__c,Buyer_Registration_Number__c,Is_Uplifted__c,Goods_or_Services_Involved__c,Specific_Goods_Involved__c,CL_Progress_Step__c,Legacy_Ref_No__c,CL_Approve_Letter__c from Credit_Limit__c where Policy__c=:policy_id and Is_DCL__c=false];
            return credit_limit;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Credit_Limit_Application__c> getCLAListByPolicy(Id policy_id){
        try{
            List<Credit_Limit_Application__c> credit_limit_application = [Select Id,Name,CL_Amount__c,CL_Status__c,CL_No__c,Application_Date__c,Buyer_Address_Line_1__c,Buyer_Address_Line_2__c,Buyer_Address_Line_3__c,Buyer_Address_Line_4__c,Buyer_Code__c,Buyer_Country__c,Buyer_Name__c,CL_Effective_Date__c,CL_Application_Amount__c,Premium__c,Ref_No__c,Remarks__c,Expiry_Date__c,ECIC_Internal_System_Status__c,Application_Type__c,Credit_Limit_Id__c,CL_Progress_Step__c,Legacy_Ref_No__c,Approve_Date__c,CLA_Cancel_Letter__c from Credit_Limit_Application__c where Policy__c=:policy_id and is_draft__c=false and Is_DCL__c=false and CL_Status__c!='Approved' and Hide_from_PH__c!=true];
            return credit_limit_application;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Credit_Limit_Application__c> getCLADraftListByPolicy(Id policy_id){
        try{
            List<Credit_Limit_Application__c> credit_limit_application = [Select Id,Agency_Ref__c,Application_Date__c,Application_Type__c,Buyer_Address_Line_1__c,Buyer_Address_Line_2__c,Buyer_Address_Line_3__c,Buyer_Address_Line_4__c,Buyer_Code__c,Buyer_Country__c,Buyer_Name__c,Buyer_Registration_Number__c,Buyer_Source__c,Buyer_Trading_Time__c,CL_Application_Amount__c,CL_Pre_Shipment_Application_AMount__c,CL_Type__c,Destination_Market__c,DNB_DUNS__c,Existing_valid_Credit_Limit_on_Buyer__c,Export_Type__c,Goods_or_Services_Involved__c,Harmonized_Code__c,Is_New_Buyer__c,Is_Unpaid_Amount__c,Is_Unpaid_Shipment__c,Market_of_Origin__c,Order_Confirmed_or_Negotiation__c,Order_Payment_Term_Amount__c,Order_Payment_Term_Type__c,Overseas_Goods_or_Services__c,Payment_Term_Days__c,Payment_Term_Type__c,Policy__c,
            Port_Of_Loading__c,Pre_Shipment_Payment_Term_Days__c,Pre_Shipment_Payment_Term_Type__c,Previously_Cancelled_Order_Unilaterally__c,Received_Order_Amount__c,Received_Order_Payment_Type__c,Received_Order_Payment_Term_Method1__c,Received_Order_Payment_Term_Method2__c,Ref_No__c,Remarks__c,Shipment_Commence_Month__c,Shipment_Commence_Year__c,Shipment_Payment_Term_Amount_12_Months__c,Shipment_Payment_Term_Type_12_Months__c,Shipment_Payment_Term_Method_12_Months1__c,Shipment_Payment_Term_Days_12_Months__c,Shipment_Payment_Term_Method_12_Months2__c,Shipment_Payment_Term_Method_12_Months3__c,Shipment_Payment_Term_Method_12_Months4__c,Shipment_Payment_Term_Method_12_Months5__c,Order_Payment_Term_Days__c,Order_Payment_Term_Amount_12_Months__c,Order_Payment_Term_Days_12_Months__c,Order_Payment_Term_Method_12_Months1__c,Order_Payment_Term_Method_12_Months2__c,Order_Payment_Term_Method_12_Months3__c,Order_Payment_Term_Method_12_Months4__c,Order_Payment_Term_Method_12_Months5__c,Confirm_Order_Payment_Terms_Method1__c,Confirm_Order_Payment_Terms_Method2__c,Confirm_Order_Payment_Terms_Method3__c,Confirm_Order_Payment_Terms_Method4__c,Confirm_Order_Payment_Terms_Method5__c,Specific_Goods_Involved__c,Unpaid_Overdue_Order__c,(select Due_Date__c,Gross_Invoice_Amount__c,Gross_Invoice_Currency__c,Payment_Term_Days__c,Payment_Term_Type__c,Shipment_Or_Invoice_Date__c,Remarks__c from Outstanding_Payments__r) from Credit_Limit_Application__c where Policy__c=:policy_id and Is_DCL__c=false and is_draft__c=true order by Application_Date__c desc];
            return credit_limit_application;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    
    @AuraEnabled
    public static List<Credit_Limit__c> getExistingBuyers(Id policy_id){
        try {
            List<Credit_Limit__c> distinct_cl = new List<Credit_Limit__c>();
            List<Credit_Limit__c> credit_limit = [Select Id,Buyer_Address_Line_1__c,Buyer_Address_Line_2__c,Buyer_Address_Line_3__c,Buyer_Address_Line_4__c,Buyer_Code__c,Buyer_Country__c,Buyer_Name__c,CL_Application_Amount__c,Buyer_Registration_Number__c,Application_Date__c,Is_Uplifted__c,CL_Effective_Date__c,Expiry_Date__c from Credit_Limit__c where Policy__c=:policy_id and CL_Status__c='Valid' ORDER BY Application_Date__c desc];
            /*for(Credit_Limit__c cl:credit_limit){
                Boolean found = false;
                for(Integer i=0; i< distinct_cl.size(); i++){
                //Check if current cl has been added yet
                    if(cl.Buyer_Code__c == distinct_cl[i].Buyer_Code__c){ 
                        found=true;
                        break;
                    }
                }
                if(!found)
                distinct_cl.add(cl);
                }
                return distinct_cl;*/
                return credit_limit;
            }  catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static void DeleteDraft(Id cla_id){
        try {
            Credit_Limit_Application__c cla = new Credit_Limit_Application__c(Id=cla_id);
            delete cla;            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void createOutstandingPaymentBuyer(List<Object> op_json,Id cla_id) {
        List<Outstanding_Payment__c> payments = new List<Outstanding_Payment__c>();
        
        try{
            for(Object op_obj:op_json) {
                System.debug('op_obj='+op_obj);
                
                //Map<String,Object> ind = (Map<String,Object> )cont_obj;
                String json_instance = Json.serialize(op_obj);
                Map<String, Object> untyped_instance = (Map<String, Object>)JSON.deserializeUntyped(json_instance);
                Date dueDate = Date.valueOf((String)untyped_instance.get('InvoiceDueDate'));
                Date invDate = Date.valueOf((String)untyped_instance.get('InvoiceDate'));
                Decimal invAmnt = Decimal.valueOf((String)untyped_instance.get('InvoiceAmount'));
                Decimal pTermDays = Decimal.valueOf((String)untyped_instance.get('PaymentTermsDays'));
                payments.add(new Outstanding_Payment__c(Credit_Limit_Application__c=cla_id,
                Due_Date__c=dueDate,
                Gross_Invoice_Amount__c=invAmnt,
                Gross_Invoice_Currency__c=(String)untyped_instance.get('InvoiceCurrency'),
                Payment_Term_Days__c=pTermDays,
                Payment_Term_Type__c=(String)untyped_instance.get('PaymentTermsType'),
                Shipment_Or_Invoice_Date__c=invDate,
                Remarks__c=(String)untyped_instance.get('InvoiceRemark')));
            }
            if(payments.size()>0) {
                insert payments;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }  
    }
    /*@AuraEnabled
    public static List<Country__mdt> getCountryList(){
        try {
            List<Country__mdt> map_cn = [select Id,Country_Code__c,Full_Country_Name__c from Country__mdt];
            return map_cn;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }*/
    @AuraEnabled
    public static ECIC_Settings__c getSettings(){
        try {
            ECIC_Settings__c settings = [select OMBP_Allow_Extra_CCF__c,OMBP_CCF_Price__c,SBP_Allow_Extra_CCF__c,SBP_CCF_Price__c,SUP_Allow_Extra_CCF__c,SUP_CCF_Price__c from ECIC_Settings__c LIMIT 1];
            return settings;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}