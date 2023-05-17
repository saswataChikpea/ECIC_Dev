public with sharing class CLApiHandler {
    public static Map<String,Object> handler(String json_string) {
        Map<String,Object> my_map = new Map<String,Object>();
        //my_map.put('success',String.valueOf(true));
        Map<String, Object> parsedMap = new Map<String, Object>();
        Map<String, Object> parsedInnerMap = new Map<String, Object>();
        String function_name;
        String method_return_value = '';
        /*JSONParser parser = JSON.createParser(json_string);
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME){
                String Key = parser.getText();
				parser.nextToken();
                String value = parser.getText();
                parsedMap.put(key, value);
            }                
        }
        system.debug('parsedMap='+parsedMap);
        //System.debug('meta_data='+parsedMap.get('meta_data'));*/
        parsedMap = (Map<String, Object>)JSON.deserializeUntyped(json_string);
		try {    		
            System.debug('parsed json='+parsedMap);
            Object parsedInnerMap_obj = parsedMap.get('meta_data');
            parsedInnerMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(parsedInnerMap_obj));
            function_name = (String)parsedInnerMap.get('funcname');
            System.debug('function_name='+function_name);
            if (function_name == 'dclamend'){
                my_map = DCLAmend(parsedInnerMap);
            } /*else if (function_name == 'dclcancel'){
                my_map = DCLCancel(parsedInnerMap);
            }*/ else if (function_name == 'rejectreapply'){
                my_map = UpdateRejectCLA(parsedInnerMap);
            } else if (function_name == 'reject_cancel_cla'){
                my_map = UpdateRejectCLA(parsedInnerMap);
            } else if (function_name == 'reject_cancel_cl'){
                my_map = UpdateRejectCL(parsedInnerMap);
            } else if (function_name == 'cl_approve'){
                my_map = ApproveCL(parsedInnerMap);
            }
            //my_map.put(method_return_value,String.valueOf(true));
		} catch(TypeException e) {
    		// Not an object, must be an array
    		
    	}
        return my_map;
    }
     //-----------------------cl clarification
    //public static Map<String,Object> ClClarification(Map<String, Object> meta_data) {
    public static Map<String,Object> ClClarification(Map<String, Object> meta_data) {
        Map<String,Object> ret_map = new Map<String,Object>();
        for(String key_str:meta_data.keySet()){
            String small_key = key_str.toLowercase();
            meta_data.put(small_key,meta_data.get(key_str));
        }
        //Id acc_id = '0010l00001IGyYnAAL';
        Id acc_id = (string)meta_data.get('account__c');
        try{
            List<Contact> con = [select Email from Contact where Enable_Email_Notification__c=true and Is_Active__c=true and AccountId=:acc_id];
            System.debug('contact email='+con);
            List<string> email_ids = new List<string>();
            for(Contact each_con:con){
                email_ids.add(each_con.Email);
            }
            System.debug('email_ids='+email_ids);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = email_ids;
            message.optOutPolicy = 'FILTER';
            message.subject = 'ECIC CL clarification';
            message.plainTextBody = 'This is the message body.';
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else 
            {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }
            
        }catch(Exception e) {
            System.debug('Exception='+e.getMessage());
        }
        return null;
    }
    
    public static Map<String,Object> ApproveCL(Map<String, Object> meta_data) {
        Map<String,Object> ret_map = new Map<String,Object>();
        for(String key_str:meta_data.keySet()){
            String small_key = key_str.toLowercase();
            meta_data.put(small_key,meta_data.get(key_str));
        }
        try{
            String cla_id = (String)meta_data.get('id');
            List<String> cla_fields = fieldMappingTranslation.get_all_fields_from_APIName('Credit_Limit_Application__c');
            String cla_query = 'SELECT ' + String.join(cla_fields, ', ') + ',(select Id,Name,Subsidiary__c,Subsidiary__r.Name,Subsidiary__r.Subsidiary_Country__c from Subsidiary_Related_To_CL__r) FROM Credit_Limit_Application__c WHERE ID = \'' + cla_id + '\' and cl_Status__c != \'Approved\'';
            System.debug('cla_query='+cla_query);
            List<Credit_Limit_Application__c> clapplication = DataBase.query(cla_query);
            if (clapplication.size() > 0) {
            
                String msg = '';
                Date Cancellation_Date,Approve_Date,Pre_Approve_Date,CL_Effective_Date,Expiry_Date,Pre_Expiry_Date,Application_Date,Application_Completion_Date;
                
                List<Credit_Limit__c> cl_list = new List<Credit_Limit__c>();
                Credit_Limit__c cl = new Credit_Limit__c();
                if(meta_data.containsKey('cancellation_date__c') && meta_data.get('cancellation_date__c')!=NULL && meta_data.get('cancellation_date__c')!='')
                Cancellation_Date = Date.valueOf((string)meta_data.get('cancellation_date__c'));
                if(meta_data.containsKey('approve_date__c') && meta_data.get('approve_date__c')!=NULL && meta_data.get('approve_date__c')!='')
                Approve_Date = Date.valueOf((string)meta_data.get('approve_date__c'));
                System.debug('Approve_Date='+Approve_Date);
                if(meta_data.containsKey('Pre_Approve_Date') && meta_data.get('Pre_Approve_Date')!=NULL && meta_data.get('Pre_Approve_Date')!='')
                Pre_Approve_Date = Date.valueOf((string)meta_data.get('Pre_Approve_Date'));
                
                if(meta_data.containsKey('cl_effective_date__c') && meta_data.get('cl_effective_date__c')!=NULL && meta_data.get('cl_effective_date__c')!='')
                CL_Effective_Date = Date.valueOf((string)meta_data.get('cl_effective_date__c'));
                if(meta_data.containsKey('expiry_date__c') && meta_data.get('expiry_date__c')!=NULL && meta_data.get('expiry_date__c')!='')            
                Expiry_Date = Date.valueOf((string)meta_data.get('expiry_date__c'));
                if(meta_data.containsKey('pre_expiry_date__c') && meta_data.get('pre_expiry_date__c')!=NULL && meta_data.get('pre_expiry_date__c')!='')            
                Pre_Expiry_Date = Date.valueOf((string)meta_data.get('pre_expiry_date__c'));
                if(meta_data.containsKey('Application_Date__c') && meta_data.get('Application_Date__c')!=NULL && meta_data.get('Application_Date__c')!='')
                Application_Date = Date.valueOf((string)meta_data.get('Application_Date__c'));
                if(meta_data.containsKey('Application_Completion_Date__c') && meta_data.get('Application_Completion_Date__c')!=NULL && meta_data.get('Application_Completion_Date__c')!='')
                Application_Completion_Date = Date.valueOf((string)meta_data.get('Application_Completion_Date__c'));
                
                String status = (string)meta_data.get('CL_Status__c');
                if(status.equalsIgnoreCase('valid') && ((string)meta_data.get('export_type__c') == 'Export of Goods (Pre-shipment and post-shipment risk)') && !Boolean.valueOf(meta_data.get('is_dcl__c'))){
                    //Post shipment cl
                    cl.Export_Type__c = 'Export of Goods (Post-shipment risk only)';
                    if(meta_data.containsKey('remarks__c') && meta_data.get('remarks__c')!=NULL)
                    cl.Remarks__c = (string)meta_data.get('remarks__c');
                    if(meta_data.containsKey('specific_goods_involved__c') && meta_data.get('specific_goods_involved__c')!=NULL)
                    cl.Specific_Goods_Involved__c = (string)meta_data.get('specific_goods_involved__c');
                    if(meta_data.containsKey('goods_or_services_involved__c') && meta_data.get('goods_or_services_involved__c')!=NULL)
                    cl.Goods_or_Services_Involved__c = (string)meta_data.get('goods_or_services_involved__c');
                    
                    cl.CL_No__c = (string)meta_data.get('cl_no__c');
                    if(meta_data.containsKey('harmonized_code__c') && meta_data.get('harmonized_code__c')!=NULL)
                    cl.Harmonized_Code__c = (string)meta_data.get('harmonized_code__c');
                    if(meta_data.containsKey('port_of_loading__c') && meta_data.get('port_of_loading__c')!=NULL)
                    cl.Port_Of_Loading__c = (string)meta_data.get('port_of_loading__c');
                    if(meta_data.containsKey('market_of_origin__c') && meta_data.get('market_of_origin__c')!=NULL)
                    cl.Market_of_Origin__c = (string)meta_data.get('market_of_origin__c');
                    if(meta_data.containsKey('destination_market__c') && meta_data.get('destination_market__c')!=NULL)
                    cl.Destination_Market__c = (string)meta_data.get('destination_market__c');
                    cl.CL_Effective_Date__c = CL_Effective_Date;
                    cl.Expiry_Date__c = Expiry_Date;
                    if(meta_data.containsKey('buyer_registration_number__c') && meta_data.get('buyer_registration_number__c')!=NULL)
                    cl.Buyer_Registration_Number__c = (string)meta_data.get('buyer_registration_number__c');
                    cl.Approve_Date__c = Approve_Date;                   
                    if(meta_data.containsKey('cl_amount__c') && meta_data.get('cl_amount__c')!=NULL)
                    cl.CL_Amount__c = (Decimal)meta_data.get('cl_amount__c');
                    cl.CL_Application_Amount__c = clapplication[0].CL_Application_Amount__c;
                    if(meta_data.containsKey('payment_term_days__c') && meta_data.get('payment_term_days__c')!=NULL)
                    cl.Payment_Term_Days__c = (Decimal)meta_data.get('payment_term_days__c');
                    if(meta_data.containsKey('payment_term_type__c') && meta_data.get('payment_term_type__c')!=NULL)
                    cl.Payment_Term_Type__c = (string)meta_data.get('payment_term_type__c');
                    cl.Buyer_Code__c = (string)meta_data.get('buyer_code__c');
                    cl.Buyer_Address_Line_1__c = (string)meta_data.get('buyer_address_line_1__c');
                    cl.Buyer_Address_Line_2__c = (string)meta_data.get('buyer_address_line_2__c');
                    cl.Buyer_Address_Line_3__c = (string)meta_data.get('buyer_address_line_3__c');
                    cl.Buyer_Address_Line_4__c = (string)meta_data.get('buyer_address_line_4__c');
                    cl.Buyer_Name__c = (string)meta_data.get('buyer_name__c');
                    cl.Buyer_Country__c = (string)meta_data.get('buyer_country__c');
                    if(meta_data.containsKey('cl_condition__c') && meta_data.get('cl_condition__c')!=NULL && meta_data.get('cl_condition__c')!='')
                    cl.CL_Condition__c = (string)meta_data.get('cl_condition__c');
                    cl.CL_Status__c = 'Valid';
                    cl.Credit_Limit_Application__c = (string)meta_data.get('id');
                    cl.Policy__c = clapplication[0].Policy__c;
                    cl.Exporter__c = clapplication[0].Exporter__c;
                    cl.Application_Date__c = clapplication[0].Application_Date__c;
                    cl_list.add(cl);
                    Credit_Limit__c cl1 = new Credit_Limit__c();
                    // pre shipment

                    cl1.Export_Type__c = 'Export of Goods (Pre-shipment risk)';
                    if(meta_data.containsKey('pre_remarks__c') && meta_data.get('pre_remarks__c')!=NULL)
                    cl1.Remarks__c = (string)meta_data.get('pre_remarks__c');
                    if(meta_data.containsKey('specific_goods_involved__c') && meta_data.get('specific_goods_involved__c')!=NULL)
                    cl1.Specific_Goods_Involved__c = (string)meta_data.get('specific_goods_involved__c');
                    if(meta_data.containsKey('goods_or_services_involved__c') && meta_data.get('goods_or_services_involved__c')!=NULL)
                    cl1.Goods_or_Services_Involved__c = (string)meta_data.get('goods_or_services_involved__c');
                    
                    cl1.CL_No__c = (string)meta_data.get('pre_cl_no__c');
                    if(meta_data.containsKey('harmonized_code__c') && meta_data.get('harmonized_code__c')!=NULL)
                    cl1.Harmonized_Code__c = (string)meta_data.get('harmonized_code__c');
                    if(meta_data.containsKey('port_of_loading__c') && meta_data.get('port_of_loading__c')!=NULL)
                    cl1.Port_Of_Loading__c = (string)meta_data.get('port_of_loading__c');
                    if(meta_data.containsKey('market_of_origin__c') && meta_data.get('market_of_origin__c')!=NULL)
                    cl1.Market_of_Origin__c = (string)meta_data.get('market_of_origin__c');
                    if(meta_data.containsKey('destination_market__c') && meta_data.get('destination_market__c')!=NULL)
                    cl1.Destination_Market__c = (string)meta_data.get('destination_market__c');
                    cl1.CL_Effective_Date__c = CL_Effective_Date;
                    cl1.Expiry_Date__c = Pre_Expiry_Date;
                    if(meta_data.containsKey('buyer_registration_number__c') && meta_data.get('buyer_registration_number__c')!=NULL)
                    cl1.Buyer_Registration_Number__c = (string)meta_data.get('buyer_registration_number__c');
                    cl1.Approve_Date__c = Pre_Approve_Date;                   
                    if(meta_data.containsKey('pre_cl_amount__c') && meta_data.get('pre_cl_amount__c')!=NULL)
                    cl1.CL_Amount__c = (Decimal)meta_data.get('pre_cl_amount__c');
                    cl1.CL_Application_Amount__c = clapplication[0].CL_Pre_Shipment_Application_AMount__c;
                    if(meta_data.containsKey('pre_payment_term_days__c') && meta_data.get('pre_payment_term_days__c')!=NULL)
                    cl1.Payment_Term_Days__c = (Decimal)meta_data.get('pre_payment_term_days__c');
                    if(meta_data.containsKey('pre_payment_term_type__c') && meta_data.get('pre_payment_term_type__c')!=NULL)
                    cl1.Payment_Term_Type__c = (string)meta_data.get('pre_payment_term_type__c');
                    cl1.Buyer_Code__c = (string)meta_data.get('buyer_code__c');
                    cl1.Buyer_Address_Line_1__c = (string)meta_data.get('buyer_address_line_1__c');
                    cl1.Buyer_Address_Line_2__c = (string)meta_data.get('buyer_address_line_2__c');
                    cl1.Buyer_Address_Line_3__c = (string)meta_data.get('buyer_address_line_3__c');
                    cl1.Buyer_Address_Line_4__c = (string)meta_data.get('buyer_address_line_4__c');
                    cl1.Buyer_Name__c = (string)meta_data.get('buyer_name__c');
                    cl1.Buyer_Country__c = (string)meta_data.get('buyer_country__c');
                    if(meta_data.containsKey('cl_condition__c') && meta_data.get('cl_condition__c')!=NULL && meta_data.get('cl_condition__c')!='')
                    cl1.CL_Condition__c = (string)meta_data.get('cl_condition__c');
                    cl1.CL_Status__c = 'Valid';
                    cl1.Credit_Limit_Application__c = (string)meta_data.get('id');
                    cl1.Policy__c = clapplication[0].Policy__c;
                    cl1.Exporter__c = clapplication[0].Exporter__c;
                    cl1.Application_Date__c = clapplication[0].Application_Date__c;
                    cl_list.add(cl1);

                    insert cl_list;
                    System.debug('cl inserted='+cl_list);
                    Credit_Limit_Application__c cla = new Credit_Limit_Application__c(Id=cla_id,
                                                    cl_Status__c = 'Approved',
                                                    ECIC_Internal_System_Status__c = 'CL_NEW (Credit Limit Approved)'
                                                    );
                    update cla;
                    string policy_id = clapplication[0].Policy__c;
                    CalculateMLSBP(policy_id,clapplication[0].Exporter__c);
                    msg = 'Successfully Created record-' + cl_list;
                    
                } else if( status.equalsIgnoreCase('valid') && !Boolean.valueOf(meta_data.get('is_dcl__c'))) {
                    cl.Export_Type__c = (string)meta_data.get('export_type__c');
                    if(meta_data.containsKey('remarks__c') && meta_data.get('remarks__c')!=NULL)
                    cl.Remarks__c = (string)meta_data.get('remarks__c');
                    if(meta_data.containsKey('specific_goods_involved__c') && meta_data.get('specific_goods_involved__c')!=NULL)
                    cl.Specific_Goods_Involved__c = (string)meta_data.get('specific_goods_involved__c');
                    if(meta_data.containsKey('goods_or_services_involved__c') && meta_data.get('goods_or_services_involved__c')!=NULL)
                    cl.Goods_or_Services_Involved__c = (string)meta_data.get('goods_or_services_involved__c');
                    
                    cl.CL_No__c = (string)meta_data.get('cl_no__c');
                    if(meta_data.containsKey('harmonized_code__c') && meta_data.get('harmonized_code__c')!=NULL)
                    cl.Harmonized_Code__c = (string)meta_data.get('harmonized_code__c');
                    if(meta_data.containsKey('port_of_loading__c') && meta_data.get('port_of_loading__c')!=NULL)
                    cl.Port_Of_Loading__c = (string)meta_data.get('port_of_loading__c');
                    if(meta_data.containsKey('market_of_origin__c') && meta_data.get('market_of_origin__c')!=NULL)
                    cl.Market_of_Origin__c = (string)meta_data.get('market_of_origin__c');
                    if(meta_data.containsKey('destination_market__c') && meta_data.get('destination_market__c')!=NULL)
                    cl.Destination_Market__c = (string)meta_data.get('destination_market__c');
                    cl.CL_Effective_Date__c = CL_Effective_Date;
                    cl.Expiry_Date__c = Expiry_Date;
                    if(meta_data.containsKey('buyer_registration_number__c') && meta_data.get('buyer_registration_number__c')!=NULL)
                    cl.Buyer_Registration_Number__c = (string)meta_data.get('buyer_registration_number__c');
                    cl.Approve_Date__c = Approve_Date;                   
                    if(meta_data.containsKey('cl_amount__c') && meta_data.get('cl_amount__c')!=NULL)
                    cl.CL_Amount__c = (Decimal)meta_data.get('cl_amount__c');
                    cl.CL_Application_Amount__c = clapplication[0].CL_Application_Amount__c;
                    if(meta_data.containsKey('payment_term_days__c') && meta_data.get('payment_term_days__c')!=NULL)
                    cl.Payment_Term_Days__c = (Decimal)meta_data.get('payment_term_days__c');
                    if(meta_data.containsKey('payment_term_type__c') && meta_data.get('payment_term_type__c')!=NULL)
                    cl.Payment_Term_Type__c = (string)meta_data.get('payment_term_type__c');
                    cl.Buyer_Code__c = (string)meta_data.get('buyer_code__c');
                    cl.Buyer_Address_Line_1__c = (string)meta_data.get('buyer_address_line_1__c');
                    cl.Buyer_Address_Line_2__c = (string)meta_data.get('buyer_address_line_2__c');
                    cl.Buyer_Address_Line_3__c = (string)meta_data.get('buyer_address_line_3__c');
                    cl.Buyer_Address_Line_4__c = (string)meta_data.get('buyer_address_line_4__c');
                    cl.Buyer_Name__c = (string)meta_data.get('buyer_name__c');
                    cl.Buyer_Country__c = (string)meta_data.get('buyer_country__c');
                    if(meta_data.containsKey('cl_condition__c') && meta_data.get('cl_condition__c')!=NULL && meta_data.get('cl_condition__c')!='')
                    cl.CL_Condition__c = (string)meta_data.get('cl_condition__c');
                    cl.CL_Status__c = 'Valid';
                    cl.Credit_Limit_Application__c = (string)meta_data.get('id');
                    cl.Policy__c = clapplication[0].Policy__c;
                    cl.Exporter__c = clapplication[0].Exporter__c;
                    cl.Application_Date__c = clapplication[0].Application_Date__c;
                    
                    insert cl;
                    System.debug('cl inserted='+cl);
                    Credit_Limit_Application__c cla = new Credit_Limit_Application__c(Id=cla_id,
                                                    cl_Status__c = 'Approved',
                                                    ECIC_Internal_System_Status__c = 'CL_NEW (Credit Limit Approved)'
                                                    );
                    update cla;
                    System.debug('updated cla='+cla);                    
                    // SendEmailApex.sendEmailAccount(cl.Exporter__c, cl.Id, 'CLA_Approved', false, null, null);
                    if ((string)meta_data.get('product_type__c') == 'OMBP') {
                        string policy_id = clapplication[0].Policy__c;
                        Decimal cl_amount = (Decimal)meta_data.get('cl_amount__c');
                        CalculateML(policy_id,cl_amount,Approve_Date,clapplication[0].Exporter__c);
                        CLCreateAttachments.linkDocToParent(cl, 'CLApproveOMBP');
                    } else if ((string)meta_data.get('product_type__c') == 'SBP'){
                        System.debug('policy_type SBP');
                        string policy_id = clapplication[0].Policy__c;
                        Boolean buyer_sub_cntry_match = false;
                        CalculateMLSBP(policy_id,clapplication[0].Exporter__c);
                        CLCreateAttachments.linkDocToParent(cl, 'CLApproveSBP');
                        //------------- Endorsement----------
                        List<Subsidiary_Related_To_CL__c> sub_ref_cl_list = new List<Subsidiary_Related_To_CL__c>();
                        List<Subsidiary_Related_To_CL__c> updated_sub_ref_cl_list = new List<Subsidiary_Related_To_CL__c>();
                        List<Id> sub_matched_country = new List<Id>();
                        String sub_names = '';
                        System.debug('before clapplication[0].Subsidiary_Related_To_CL__r');
                        for(Subsidiary_Related_To_CL__c ref : clapplication[0].Subsidiary_Related_To_CL__r){
                            System.debug(ref.Name);
                            sub_ref_cl_list.add(ref);
                            sub_names = ref.Subsidiary__r.Name + ',';
                            if(ref.Subsidiary__r.Subsidiary_Country__c == cl.Buyer_Country__c){
                                sub_matched_country.add(ref.Subsidiary__r.Id);
                                buyer_sub_cntry_match = true;
                            }                            
                        }
                        System.debug('buyer_sub_cntry_match'+buyer_sub_cntry_match);
                        System.debug('sub_ref_cl_list'+sub_ref_cl_list);
                        string export_type = clapplication[0].Export_Type__c;
                        System.debug('export_type='+export_type);
                        Boolean is_service = export_type == 'Export of Services' ? true : false;
                        System.debug('is_service='+is_service);
                        if (sub_ref_cl_list.size()>0) {
                            if(is_service){
                                if(buyer_sub_cntry_match){
                                    System.debug('If condition satisfied');
                                    List<Related_Endorsement__c> rel_end = [select Id,Name,Endorsement_Name__c,Buyer_Country__c,Buyer_Code__c,Subsidiary__c from Related_Endorsement__c where Policy__c=:cl.Policy__c and Endorsement_Name__c='EN68'];
                                    List<Related_Endorsement__c> new_end = new List<Related_Endorsement__c>();
                                    System.debug('rel_end='+rel_end);
                                    if (rel_end.size() > 0) {
                                        List<Endorsement__c> endorsement = [select Id,Name,Allowed_Discount_On_Premium__c from Endorsement__c where Name='EN68'];
                                        System.debug('endorsement='+endorsement);
                                        for(Subsidiary_Related_To_CL__c sub_ref:sub_ref_cl_list) { 
                                            Boolean buyer_sub_match = false;                                  
                                            for(Related_Endorsement__c each_end:rel_end) {
                                                if((each_end.Buyer_Code__c != null) && (each_end.Subsidiary__c != null)){
                                                    if((each_end.Buyer_Code__c == cl.Buyer_Code__c) && (each_end.Subsidiary__c == sub_ref.Subsidiary__c)){
                                                        buyer_sub_match = true;
                                                    }
                                                }                                    
                                            }
                                            if(!buyer_sub_match){
                                                new_end.add(new Related_Endorsement__c(
                                                    Endorsement_Type__c = endorsement[0].Id,
                                                    Allowed_Discount_On_Premium__c = endorsement[0].Allowed_Discount_On_Premium__c,
                                                    Buyer_Code__c = cl.Buyer_Code__c,
                                                    Buyer_Country__c = cl.Buyer_Country__c,
                                                    Buyer_Name__c = cl.Buyer_Name__c,
                                                    Effective_Date__c = Date.today(),
                                                    Policy__c = cl.Policy__c,
                                                    Subsidiary__c = sub_ref.Subsidiary__c,
                                                    Issue_Date__c = Date.today()
                                                ));
                                            }
                                        }
                                        System.debug('new_end='+new_end);
                                        if(new_end.size() > 0) {
                                            insert new_end;
                                        }
                                    } else {
                                        System.debug('Task created');
                                        Task newTask = new Task();
                                        string des = 'Please create EN68 endorsement with buyer code ' + cl.Buyer_Code__c+ ' and subsidiary '+sub_names;
                                        newTask.Subject = 'Create EN68';
                                        newTask.Description = des;
                                        newTask.Priority = 'High';
                                        newTask.WhatId = cl.Policy__c;
                                        insert newTask;
                                    }
                                    //Subsidiary_Related_To_CL__c> sub_ref_cl_list
                                    for(Subsidiary_Related_To_CL__c srtc:sub_ref_cl_list){
                                        updated_sub_ref_cl_list.add(new Subsidiary_Related_To_CL__c(
                                            Id=srtc.Id,
                                            Credit_Limit__c=cl.Id
                                        ));
                                    }
                                    update updated_sub_ref_cl_list;
                                } else {
                                    System.debug('else condition satisfied');
                                    List<Related_Endorsement__c> rel_end = [select Id,Name,Endorsement_Name__c,Buyer_Country__c,Buyer_Code__c,Subsidiary__c from Related_Endorsement__c where Policy__c=:cl.Policy__c and Endorsement_Name__c='EN70'];
                                    List<Related_Endorsement__c> new_end = new List<Related_Endorsement__c>();
                                    System.debug('rel_end='+rel_end);
                                    if (rel_end.size() > 0) {
                                        List<Endorsement__c> endorsement = [select Id,Name,Allowed_Discount_On_Premium__c from Endorsement__c where Name='EN70'];
                                        System.debug('endorsement='+endorsement);
                                        for(Subsidiary_Related_To_CL__c sub_ref:sub_ref_cl_list) { 
                                            Boolean buyer_sub_match = false;                                  
                                            for(Related_Endorsement__c each_end:rel_end) {
                                                if((each_end.Buyer_Code__c != null) && (each_end.Subsidiary__c != null)){
                                                    if((each_end.Buyer_Code__c == cl.Buyer_Code__c) && (each_end.Subsidiary__c == sub_ref.Subsidiary__c)){
                                                        buyer_sub_match = true;
                                                    }
                                                }                                    
                                            }
                                            if(!buyer_sub_match){
                                                new_end.add(new Related_Endorsement__c(
                                                    Endorsement_Type__c=endorsement[0].Id,
                                                    Allowed_Discount_On_Premium__c = endorsement[0].Allowed_Discount_On_Premium__c,
                                                    Buyer_Code__c = cl.Buyer_Code__c,
                                                    Buyer_Country__c = cl.Buyer_Country__c,
                                                    Buyer_Name__c = cl.Buyer_Name__c,
                                                    Effective_Date__c = Date.today(),
                                                    Policy__c = cl.Policy__c,
                                                    Subsidiary__c = sub_ref.Subsidiary__c,
                                                    Issue_Date__c = Date.today()
                                                ));
                                            }
                                        }
                                        System.debug('new_end='+new_end);
                                        if(new_end.size() > 0) {
                                            insert new_end;
                                        }
                                    } else {
                                        System.debug('Task created');
                                        Task newTask = new Task();
                                        string des = 'Please create EN70 endorsement with buyer code ' + cl.Buyer_Code__c+ ' and subsidiary '+sub_names;
                                        newTask.Subject = 'Create EN70';
                                        newTask.Description = des;
                                        newTask.Priority = 'High';
                                        newTask.WhatId = cl.Policy__c;
                                        insert newTask;
                                    }
                                    //Subsidiary_Related_To_CL__c> sub_ref_cl_list
                                    for(Subsidiary_Related_To_CL__c srtc:sub_ref_cl_list){
                                        updated_sub_ref_cl_list.add(new Subsidiary_Related_To_CL__c(
                                            Id=srtc.Id,
                                            Credit_Limit__c=cl.Id
                                        ));
                                    }
                                    update updated_sub_ref_cl_list;
                                }
                            } else {
                                if(buyer_sub_cntry_match){
                                    System.debug('If condition satisfied for buyer');
                                    List<Related_Endorsement__c> rel_end = [select Id,Name,Endorsement_Name__c,Buyer_Country__c,Buyer_Code__c,Subsidiary__c from Related_Endorsement__c where Policy__c=:cl.Policy__c and Endorsement_Name__c='EN67'];
                                    List<Related_Endorsement__c> new_end = new List<Related_Endorsement__c>();
                                    System.debug('rel_end='+rel_end);
                                    if (rel_end.size() > 0) {
                                        List<Endorsement__c> endorsement = [select Id,Name,Allowed_Discount_On_Premium__c from Endorsement__c where Name='EN67'];
                                        System.debug('endorsement='+endorsement);
                                        for(Subsidiary_Related_To_CL__c sub_ref:sub_ref_cl_list) { 
                                            Boolean buyer_sub_match = false;                                  
                                            for(Related_Endorsement__c each_end:rel_end) {
                                                if((each_end.Buyer_Code__c != null) && (each_end.Subsidiary__c != null)){
                                                    if((each_end.Buyer_Code__c == cl.Buyer_Code__c) && (each_end.Subsidiary__c == sub_ref.Subsidiary__c)){
                                                        buyer_sub_match = true;
                                                    }
                                                }                                    
                                            }
                                            if(!buyer_sub_match){
                                                new_end.add(new Related_Endorsement__c(
                                                    Endorsement_Type__c=endorsement[0].Id,
                                                    Allowed_Discount_On_Premium__c = endorsement[0].Allowed_Discount_On_Premium__c,
                                                    Buyer_Code__c = cl.Buyer_Code__c,
                                                    Buyer_Country__c = cl.Buyer_Country__c,
                                                    Buyer_Name__c = cl.Buyer_Name__c,
                                                    Effective_Date__c = Date.today(),
                                                    Policy__c = cl.Policy__c,
                                                    Subsidiary__c = sub_ref.Subsidiary__c,
                                                    Issue_Date__c = Date.today()
                                                ));
                                            }
                                        }
                                        System.debug('new_end='+new_end);
                                        if(new_end.size() > 0) {
                                            insert new_end;
                                        }
                                    } else {
                                        System.debug('Task created');
                                        Task newTask = new Task();
                                        string des = 'Please create EN67 endorsement with buyer code ' + cl.Buyer_Code__c+ ' and subsidiary '+sub_names;
                                        newTask.Subject = 'Create EN67';
                                        newTask.Description = des;
                                        newTask.Priority = 'High';
                                        newTask.WhatId = cl.Policy__c;
                                        insert newTask;
                                    }
                                    //Subsidiary_Related_To_CL__c> sub_ref_cl_list
                                    for(Subsidiary_Related_To_CL__c srtc:sub_ref_cl_list){
                                        updated_sub_ref_cl_list.add(new Subsidiary_Related_To_CL__c(
                                            Id=srtc.Id,
                                            Credit_Limit__c=cl.Id
                                        ));
                                    }
                                    update updated_sub_ref_cl_list;
                                } else {
                                    System.debug('else condition satisfied for buyer');
                                    List<Related_Endorsement__c> rel_end = [select Id,Name,Endorsement_Name__c,Buyer_Country__c,Buyer_Code__c,Subsidiary__c from Related_Endorsement__c where Policy__c=:cl.Policy__c and Endorsement_Name__c='EN69'];
                                    List<Related_Endorsement__c> new_end = new List<Related_Endorsement__c>();
                                    System.debug('rel_end='+rel_end);
                                    if (rel_end.size() > 0) {
                                        List<Endorsement__c> endorsement = [select Id,Name,Allowed_Discount_On_Premium__c from Endorsement__c where Name='EN69'];
                                        System.debug('endorsement='+endorsement);
                                        for(Subsidiary_Related_To_CL__c sub_ref:sub_ref_cl_list) { 
                                            Boolean buyer_sub_match = false;                                  
                                            for(Related_Endorsement__c each_end:rel_end) {
                                                if((each_end.Buyer_Code__c != null) && (each_end.Subsidiary__c != null)){
                                                    if((each_end.Buyer_Code__c == cl.Buyer_Code__c) && (each_end.Subsidiary__c == sub_ref.Subsidiary__c)){
                                                        buyer_sub_match = true;
                                                    }
                                                }                                    
                                            }
                                            if(!buyer_sub_match){
                                                new_end.add(new Related_Endorsement__c(
                                                    Endorsement_Type__c=endorsement[0].Id,
                                                    Allowed_Discount_On_Premium__c = endorsement[0].Allowed_Discount_On_Premium__c,
                                                    Buyer_Code__c = cl.Buyer_Code__c,
                                                    Buyer_Country__c = cl.Buyer_Country__c,
                                                    Buyer_Name__c = cl.Buyer_Name__c,
                                                    Effective_Date__c = Date.today(),
                                                    Policy__c = cl.Policy__c,
                                                    Subsidiary__c = sub_ref.Subsidiary__c,
                                                    Issue_Date__c = Date.today()
                                                ));
                                            }
                                        }
                                        System.debug('new_end='+new_end);
                                        if(new_end.size() > 0) {
                                            insert new_end;
                                        }
                                    } else {
                                        System.debug('Task created');
                                        Task newTask = new Task();
                                        string des = 'Please create EN69 endorsement with buyer code ' + cl.Buyer_Code__c+ ' and subsidiary '+sub_names;
                                        newTask.Subject = 'Create EN69';
                                        newTask.Description = des;
                                        newTask.Priority = 'High';
                                        newTask.WhatId = cl.Policy__c;
                                        insert newTask;
                                    }
                                    //Subsidiary_Related_To_CL__c> sub_ref_cl_list
                                    for(Subsidiary_Related_To_CL__c srtc:sub_ref_cl_list){
                                        updated_sub_ref_cl_list.add(new Subsidiary_Related_To_CL__c(
                                            Id=srtc.Id,
                                            Credit_Limit__c=cl.Id
                                        ));
                                    }
                                    update updated_sub_ref_cl_list;
                                }
                            }
                        }
                    } else {
                        CLCreateAttachments.linkDocToParent(cl, 'CLApproveSUP');
                    }
                    if (((string)meta_data.get('product_type__c') == 'SBP') || ((string)meta_data.get('product_type__c') == 'SUP')){
                        List<Credit_Limit__c> existing_cl_list = [select Id from Credit_Limit__c where policy__c=:clapplication[0].Policy__c];
                        if(existing_cl_list.size() == 1){
                            Policy__c policy = new Policy__c(Id = clapplication[0].Policy__c,
                                Issue_Date_Of_First_Credit_Limit__c = Approve_Date
                            );
                            update policy;
                        }
                    }
                    
                    msg = 'Successfully Created record-' + cl;
                } else if (((string)meta_data.get('product_type__c') == 'OMBP') && (status.equalsIgnoreCase('Application_Approved')) && !Boolean.valueOf(meta_data.get('is_dcl__c'))) {
                    List<Policy_Schedule__c> ps = [select Id,Base_Rate_Per_Quarter__c from Policy_Schedule__c where Policy__c=:clapplication[0].Policy__c and Type__c='Schedule 1'];
                    Decimal base_rate = 0, discount = 15, prem_amnt = 0, approve_amount = 0;
                    approve_amount = (meta_data.containsKey('cl_amount__c')?(Decimal)meta_data.get('cl_amount__c'):0);
                    if (ps[0].Base_Rate_Per_Quarter__c != null)
                    base_rate = ps[0].Base_Rate_Per_Quarter__c/100;

                    if(base_rate>0){
                        prem_amnt = approve_amount * base_rate;
                        if(discount > 0){
                            prem_amnt = prem_amnt * (100-discount)/100;
                        }
                        prem_amnt = prem_amnt.round(System.RoundingMode.HALF_UP);
                    }
                    System.debug('prem_amnt='+prem_amnt);

                    Credit_Limit_Application__c cla = new Credit_Limit_Application__c();
                    cla.Id=cla_id;
                    cla.cl_Status__c = 'Pending for acceptance';
                    cla.Premium__c = prem_amnt;
                    cla.Premium_Rate__c = ps[0].Base_Rate_Per_Quarter__c;
                    cla.CL_Amount__c = (meta_data.containsKey('cl_amount__c')?(Decimal)meta_data.get('cl_amount__c'):cla.CL_Amount__c);
                    cla.CL_Application_Amount__c = clapplication[0].CL_Application_Amount__c;
                    cla.Approve_Date__c = Approve_Date;
                    cla.Buyer_Country__c = (string)meta_data.get('buyer_country__c');
                    cla.Buyer_Code__c = (string)meta_data.get('buyer_code__c');
                    if(meta_data.containsKey('cl_amount__c') && meta_data.get('cl_amount__c')!=NULL)
                    cla.CL_Amount__c = (Decimal)meta_data.get('cl_amount__c');
                    cla.Legacy_CL_No__c = (string)meta_data.get('cl_no__c');
                    cla.Payment_Term_Days__c = (Decimal)meta_data.get('payment_term_days__c');
                    cla.Payment_Term_Type__c = (string)meta_data.get('payment_term_type__c');
                    cla.Buyer_Address_Line_1__c = (string)meta_data.get('buyer_address_line_1__c');
                    cla.Buyer_Address_Line_2__c = (string)meta_data.get('buyer_address_line_2__c');
                    cla.Buyer_Address_Line_3__c = (string)meta_data.get('buyer_address_line_3__c');
                    cla.Buyer_Address_Line_4__c = (string)meta_data.get('buyer_address_line_4__c');
                    cla.Buyer_Name__c = (string)meta_data.get('buyer_name__c');   
                    if(meta_data.containsKey('cl_condition__c') && meta_data.get('cl_condition__c')!=NULL && meta_data.get('cl_condition__c')!='')
                    cla.CL_Condition__c = (string)meta_data.get('cl_condition__c');
                    cla.Harmonized_Code__c = (string)meta_data.get('harmonized_code__c');
                    cla.Port_Of_Loading__c = (string)meta_data.get('port_of_loading__c');
                    cla.Market_of_Origin__c = (string)meta_data.get('market_of_origin__c');
                    cla.Destination_Market__c = (string)meta_data.get('destination_market__c');
                    cla.Export_Type__c = (string)meta_data.get('export_type__c');
                    cla.Remarks__c = (string)meta_data.get('remarks__c'); 
                    cla.CL_Type__c = 'CLI';
                                    
                    update cla;
                    System.debug('updated cla='+cla);     
                    msg = 'Successfully updated record-' + cla;
                } else if (Boolean.valueOf(meta_data.get('is_dcl__c'))) {
                    cl.Buyer_Code__c = (string)meta_data.get('buyer_code__c');
                    cl.Buyer_Address_Line_1__c = (string)meta_data.get('buyer_address_line_1__c');
                    cl.Buyer_Address_Line_2__c = (string)meta_data.get('buyer_address_line_2__c');
                    cl.Buyer_Address_Line_3__c = (string)meta_data.get('buyer_address_line_3__c');
                    cl.Buyer_Address_Line_4__c = (string)meta_data.get('buyer_address_line_4__c');
                    cl.Buyer_Name__c = (string)meta_data.get('buyer_name__c');
                    cl.Buyer_Country__c = (string)meta_data.get('buyer_country__c');
                    if(meta_data.containsKey('cl_condition__c') && meta_data.get('cl_condition__c')!=NULL && meta_data.get('cl_condition__c')!='')
                    cl.CL_Condition__c = (string)meta_data.get('cl_condition__c');
                    cl.CL_Status__c = 'Valid';
                    cl.Credit_Limit_Application__c = (string)meta_data.get('id');
                    cl.Policy__c = clapplication[0].Policy__c;
                    cl.Exporter__c = clapplication[0].Exporter__c;
                    cl.Application_Date__c = Application_Date;
                    if(meta_data.containsKey('ref_no__c') && meta_data.get('ref_no__c')!=NULL)
                    cl.Legacy_Ref_No__c = (String)meta_data.get('ref_no__c');
                    if(meta_data.containsKey('cl_no__c') && meta_data.get('cl_no__c')!=NULL)
                    cl.CL_No__c = (String)meta_data.get('cl_no__c');
                    cl.Application_Completion_Date__c = Application_Completion_Date;
                    cl.Expiry_Date__c = Expiry_Date;
                    cl.Is_DCL__c = true;
                    insert cl;
                    msg = 'Successfully created record-' + cl;
                    Credit_Limit_Application__c cla = new Credit_Limit_Application__c(Id=(string)meta_data.get('id'),
                                                    cl_Status__c = 'Approved'
                                                    );
                    update cla;
                    System.debug('updated cla='+cla); 
                    // SendEmailApex.sendEmailAccount(cl.Exporter__c, cl.Id, 'DCL Application Accepted(New Buyer Application) - SUP', false, null, null);
                }            
                ret_map.put('Status',msg);
            } else {
                ret_map.put('Exception:',' No records found.');
            }
        }catch (Exception e) {
            System.debug('Exception='+e.getMessage());
            ExceptionLogger.log(e, 'CL Approval');
            ret_map.put('Exception',e.getMessage()+' Line no:'+e.getLineNumber());           
        }
        return ret_map;                
    }
   
    //------------------- Maximum Liability calculation -----------------
    @AuraEnabled    
    public static void CalculateMLSBP(Id policy_id,Id accId) {
        Decimal max_eog_post = 0,max_eog_pre = 0,max_eog_ser = 0,greatest_amt = 0;
        Policy_Schedule__c policy_schedule1 = [Select Id, Name, Effective_Date__c, Expiry_Date__c, Issue_Date__c, Maximum_Liability__c, Policy__r.Id, Policy__r.Name, Policy__r.Commencement_Date__c, Policy__r.Issue_Date__c from Policy_Schedule__c where Policy__c=:policy_id and Type__c='Schedule 1'];
        System.debug('policy_schedule1='+policy_schedule1);
        Integer policy_duration = policy_schedule1.Policy__r.Commencement_Date__c.daysBetween(Date.today());
        System.debug('policy_duration='+policy_duration);
        if (policy_duration > 365){
            AggregateResult[] groupedResults  = [select MAX(CL_Amount__C),Export_Type__c from Credit_Limit__c where Policy__c =:policy_id and CL_Status__c='Valid' GROUP BY Export_Type__c ];
            for (AggregateResult ar : groupedResults)  {
                string export_type = String.valueOf(ar.get('Export_Type__c'));
                if (export_type.equalsIgnoreCase('Export of Goods (Post-shipment risk only)')) {
                    max_eog_post = (Decimal)ar.get('expr0');
                }
                if (export_type.equalsIgnoreCase('Export of Goods (Pre-shipment risk)')) {
                    max_eog_pre = (Decimal)ar.get('expr0');
                }
                if (export_type.equalsIgnoreCase('Export of Services')) {
                    max_eog_ser = (Decimal)ar.get('expr0');
                }
            }        
            greatest_amt = (max_eog_post + max_eog_pre) > max_eog_ser ? (max_eog_post + max_eog_pre) : max_eog_ser;
            System.debug('max_eog_post='+max_eog_post+'  max_eog_pre='+max_eog_pre+'  max_eog_ser='+max_eog_ser+'  greatest_amt='+greatest_amt);
            System.debug('current max liability='+policy_schedule1.Maximum_Liability__c);
            if(greatest_amt < policy_schedule1.Maximum_Liability__c) {
                policy_schedule1.Maximum_Liability__c = greatest_amt;
                update policy_schedule1;
                // SendEmailApex.sendEmailAccount(accId, policy_schedule1.Id, 'Revised ML', false, null, null);
            }
        }
    }
    public static void CalculateML(Id policy_id,Decimal cl_amount,Date approve_date,Id accId) {
        Policy_Schedule__c policy_schedule1 = [Select Id, Name, Effective_Date__c, Expiry_Date__c, Issue_Date__c, Maximum_Liability__c, Policy__r.Id, Policy__r.Name, Policy__r.Commencement_Date__c, Policy__r.Issue_Date__c from Policy_Schedule__c where Policy__c=:policy_id and Type__c='Schedule 1'];
        if((policy_schedule1.Maximum_Liability__c == 0) || (policy_schedule1.Maximum_Liability__c == NULL)){
			policy_schedule1.Maximum_Liability__c = cl_amount;
            update policy_schedule1;
            Policy__c policy = new Policy__c(Id=policy_id,
            ML_Changed_to_Non_Zero_Amount__c=approve_date,
            Issue_Date_Of_First_Credit_Limit__c=approve_date
            );
            update policy;
            // SendEmailApex.sendEmailAccount(accId, policy_schedule1.Id, 'Revised ML', false, null, null);
        } else {
            Decimal max_l = 0;
            AggregateResult[] groupedResults  = [select MAX(CL_Amount__C), Buyer_code__c from Credit_Limit__c where Policy__c =:policy_id and CL_Status__c='Valid' GROUP BY Buyer_code__c ];
            for (AggregateResult ar : groupedResults)  {
                                
                if((Decimal)ar.get('expr0') > 800000) {
                    max_l += 800000;
                } else {
                    max_l += (Decimal)ar.get('expr0');
                }                
            }
            if(max_l > 3000000)
                max_l = 3000000;
            if(max_l != policy_schedule1.Maximum_Liability__c) {
                policy_schedule1.Maximum_Liability__c = max_l;            
                update policy_schedule1;
                // SendEmailApex.sendEmailAccount(accId, policy_schedule1.Id, 'Revised ML', false, null, null);
            }
            System.debug('max_l='+max_l);   
            
        }
    }
    
    public static Map<String,Object> UpdateRejectCLA(Map<String, Object> meta_data) {
        Map<String,Object> ret_map = new Map<String,Object>();
        try{
            String msg;
            List<Object> dataList = (List<Object>)meta_data.get('data') ;
            List<Credit_Limit_Application__c> cla_list = new List<Credit_Limit_Application__c>();
            System.debug('dataList='+dataList);
            for(Object each_data:dataList) {
                Map<String,Object> each_data_map = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(each_data));
                for(String key_str:each_data_map.keySet()){
                    String small_key = key_str.toLowercase();
                    each_data_map.put(small_key,each_data_map.get(key_str));
        		}
                Credit_Limit_Application__c cla = new Credit_Limit_Application__c();
                Date Cancellation_Date = Date.valueOf((string)each_data_map.get('cancellation_date__c'));
                cla.Id=(String)each_data_map.get('id');
                String status = (String)each_data_map.get('cl_status__c');
                if (status.equalsIgnoreCase('cancelled'))
                    cla.CL_Status__c='Invalid';
                if (status.equalsIgnoreCase('rejected'))
                    cla.CL_Status__c='Invalid';
                cla.CL_Amount__c = 0;  
                cla.Is_DCL__c = Boolean.valueOf(each_data_map.get('is_dcl__c'));
                cla.Cancellation_Date__c = Cancellation_Date;
                if(each_data_map.containsKey('cl_condition__c') && each_data_map.get('cl_condition__c')!=NULL && each_data_map.get('cl_condition__c')!='')
                    cla.CL_Condition__c = (string)each_data_map.get('cl_condition__c');
                cla_list.add(cla);
            }
            update cla_list;
            //CLCreateAttachments.linkDocToParent(cl, 'CLApproveSBP');
            System.debug('cla_list='+cla_list);
            msg = 'Successfully updated record-' + cla_list;
            ret_map.put('Success',msg);
            for(Credit_Limit_Application__c cla:cla_list){
                List<Credit_Limit_Application__c> new_cla = [select Id,Name,Exporter__c,policy__r.Product__r.Name from Credit_Limit_Application__c where Id=:cla.Id];
                if(new_cla != null && new_cla.size() > 0) {
                    if(new_cla[0].policy__r.Product__r.Name == 'OMBP') {
                        // SendEmailApex.sendEmailAccount(new_cla[0].Exporter__c, new_cla[0].Id, 'Credit_Limit_Not_Approved_for_goods_services_OMBP', false, null, null);
                        CLCreateAttachments.linkCLADocToParent(new_cla[0], 'CLACancelOMBP');
                    } else if(new_cla[0].policy__r.Product__r.Name == 'SBP') {
                        // SendEmailApex.sendEmailAccount(new_cla[0].Exporter__c, new_cla[0].Id, 'Credit_Limit_Not_Approved_for_goods_services_SBP', false, null, null);
                        CLCreateAttachments.linkCLADocToParent(new_cla[0], 'CLACancelSBP');
                    } else {
                        // SendEmailApex.sendEmailAccount(new_cla[0].Exporter__c, new_cla[0].Id, 'Credit_Limit_Not_Approved_for_goods_SUP', false, null, null);
                        CLCreateAttachments.linkCLADocToParent(new_cla[0], 'CLACancelSUP');
                    }
                }
            }
            
        }catch(Exception e){
            System.debug('Exception='+e.getMessage());
            ExceptionLogger.log(e, 'CLA Rejection');
            ret_map.put('Exception',e.getMessage()+' Line no:'+e.getLineNumber());           
        }        
        return ret_map;
    }
    
    public static Map<String,Object> UpdateRejectCL(Map<String, Object> meta_data) {
        Map<String,Object> ret_map = new Map<String,Object>();
        try{
            List<Object> dataList = (List<Object>)meta_data.get('data') ;
            List<Credit_Limit__c> cl_list = new List<Credit_Limit__c>();
            System.debug('dataList='+dataList);
            for(Object each_data:dataList) {
                Map<String,Object> each_data_map = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(each_data));
                for(String key_str:each_data_map.keySet()){
                    String small_key = key_str.toLowercase();
                    each_data_map.put(small_key,each_data_map.get(key_str));
        		}
                Credit_Limit__c cl = new Credit_Limit__c();
                Date Cancellation_Date = Date.valueOf((string)each_data_map.get('cancellation_date__c'));
                cl.Id=(String)each_data_map.get('id');
                String status = (String)each_data_map.get('cl_status__c');
                if (status.equalsIgnoreCase('cancelled'))
                    cl.CL_Status__c='Invalid';
                if (status.equalsIgnoreCase('rejected'))
                    cl.CL_Status__c='Invalid';  
                cl.Is_DCL__c = Boolean.valueOf(each_data_map.get('is_dcl__c'));
                cl.Cancellation_Date__c = Cancellation_Date;
                if(each_data_map.containsKey('cl_condition__c') && each_data_map.get('cl_condition__c')!=NULL && each_data_map.get('cl_condition__c')!='')
                    cl.CL_Condition__c = (string)each_data_map.get('cl_condition__c');
                cl_list.add(cl);
            }
            update cl_list;
            List<Id> cl_id_list;
            for(Credit_Limit__c cl:cl_list){
                cl_id_list.add(cl.Id);
            }
            List<Credit_Limit__c> new_cl_list = [select id,cl_amount__c,name,Approve_Date__c,Exporter__c,policy__c,policy__r.name,policy__r.Product__r.Name from credit_limit__c where id in :cl_id_list];
            for(Credit_Limit__c each_cl:new_cl_list) {
                if(each_cl.policy__r.Product__r.Name == 'OMBP') {
                    CalculateML(each_cl.policy__c,each_cl.cl_amount__c,each_cl.Approve_Date__c,each_cl.Exporter__c);
                } else if (each_cl.policy__r.Product__r.Name == 'SBP') {
                    CalculateMLSBP(each_cl.policy__c,each_cl.Exporter__c);
                }
            }
            System.debug('cla_list='+cl_list);
            String msg = 'Successfully updated record-' + cl_list;
            ret_map.put('Success',msg);
            
        }catch(Exception e){
            System.debug('Exception='+e.getMessage());
            ExceptionLogger.log(e, 'CL Rejection');
            ret_map.put('Exception',e.getMessage()+' Line no:'+e.getLineNumber());           
            
        }        
        return ret_map;
    }
    
    public static Map<String,Object> RejectReapply(Map<String, Object> meta_data) {
        Map<String,Object> ret_map = new Map<String,Object>();
        for(String key_str:meta_data.keySet()){
            String small_key = key_str.toLowercase();
            meta_data.put(small_key,meta_data.get(key_str));
        }
        try{            
            
            String cla_id = (String)meta_data.get('id');
            String CL_Status = String.valueof(meta_data.get('status__c'));
                        
            Credit_Limit_Application__c cla = new Credit_Limit_Application__c(Id=cla_id,
                cl_Status__c = 'Rejected'
            );
        	update cla;
            String msg = 'Successfully updated record-' + cla_id;
            ret_map.put('Status',msg);
        }catch (Exception e) {
            System.debug('Exception='+e.getMessage());
            ExceptionLogger.log(e, 'CLA Rejection');
            return ret_map;
        }
        return ret_map;
    }
    public static Map<String,Object> DCLCancel(Map<String, Object> meta_data) {
        Map<String,Object> ret_map = new Map<String,Object>();
        for(String key_str:meta_data.keySet()){
            String small_key = key_str.toLowercase();
            meta_data.put(small_key,meta_data.get(key_str));
        }
        try{
            Boolean is_dcl = (Boolean)meta_data.get('is_dcl__c');  
            String can_date = (string)meta_data.get('cancellation_date__c');
            System.debug('can_date='+can_date);
            Date Cancellation_Date = Date.valueOf((string)meta_data.get('cancellation_date__c'));
            String cl_id = (String)meta_data.get('id');
            String CL_Status = String.valueof(meta_data.get('cl_Status__c'));
            String Policy = (String)meta_data.get('policy__c');
            string cl_condition = '';
            if(meta_data.containsKey('cl_condition__c') && meta_data.get('cl_condition__c')!=NULL && meta_data.get('cl_condition__c')!='')
            cl_condition = (string)meta_data.get('cl_condition__c');
            
            Credit_Limit__c cl = new Credit_Limit__c(Id=cl_id,
                cl_Status__c = 'Cancelled',
                cancellation_date__c = Cancellation_Date,
                is_dcl__c = is_dcl,
                cl_condition__c = cl_condition                                                
            );
        	update cl;
            String msg = 'Successfully updated record-' + cl_id;
            ret_map.put('Status',msg);
        }catch (Exception e) {
            System.debug('Exception='+e.getMessage());
            ExceptionLogger.log(e, 'DCL Cancel');
            return ret_map;
        }
        return ret_map;
    }
    public static Map<String,Object> DCLAmend(Map<String, Object> meta_data) {
        Map<String,Object> ret_map = new Map<String,Object>();
        for(String key_str:meta_data.keySet()){
            String small_key = key_str.toLowercase();
            meta_data.put(small_key,meta_data.get(key_str));
        }
        String msg;
        try{
            Credit_Limit__c cl = new Credit_Limit__c();
            
            cl.Id = (String)meta_data.get('discretionary_credit_limit_id__c');

            List<String> cl_fields = fieldMappingTranslation.get_all_fields_from_APIName('Credit_Limit__c');
            String cl_query = 'SELECT ' + String.join(cl_fields, ', ') + ' FROM Credit_Limit__c WHERE ID = \'' + cl.Id ;
            List<Credit_Limit__c> cl_records = DataBase.query(cl_query);

            if(meta_data.containsKey('buyer_name__c') && meta_data.get('buyer_name__c')!=NULL && meta_data.get('buyer_name__c')!='')
                cl.Buyer_Name__c = (String)meta_data.get('buyer_name__c');
            if(meta_data.containsKey('buyer_address_line_1__c') && meta_data.get('buyer_address_line_1__c')!=NULL && meta_data.get('buyer_address_line_1__c')!='')
                cl.buyer_address_line_1__c = (String)meta_data.get('buyer_address_line_1__c');
            if(meta_data.containsKey('buyer_address_line_2__c') && meta_data.get('buyer_address_line_2__c')!=NULL && meta_data.get('buyer_address_line_2__c')!='')
                cl.buyer_address_line_2__c = (String)meta_data.get('buyer_address_line_2__c');
            if(meta_data.containsKey('buyer_address_line_3__c') && meta_data.get('buyer_address_line_3__c')!=NULL && meta_data.get('buyer_address_line_3__c')!='')
                cl.buyer_address_line_3__c = (String)meta_data.get('buyer_address_line_3__c');
            if(meta_data.containsKey('buyer_address_line_4__c') && meta_data.get('buyer_address_line_4__c')!=NULL && meta_data.get('buyer_address_line_4__c')!='')
                cl.buyer_address_line_4__c = (String)meta_data.get('buyer_address_line_4__c');
            if(meta_data.containsKey('buyer_code__c') && meta_data.get('buyer_code__c')!=NULL && meta_data.get('buyer_code__c')!='')
                cl.buyer_code__c = (String)meta_data.get('buyer_code__c');
            if(meta_data.containsKey('legacy_ref_no__c') && meta_data.get('legacy_ref_no__c')!=NULL && meta_data.get('legacy_ref_no__c')!='')
                cl.legacy_ref_no__c = (String)meta_data.get('legacy_ref_no__c');
            
        	update cl;
            
            msg = 'Successfully updated record-' + cl;
            ret_map.put('Status',msg);
            // SendEmailApex.sendEmailAccount(cl_records[0].Exporter__c, cl.Id, 'DCL_Application_Accepted_Revise_Buyer_Name_Address_SUP', false, null, null);
        	
        }catch (Exception e) {
            System.debug('Exception='+e.getMessage());
            ExceptionLogger.log(e, 'DCL Amend');
            ret_map.put('Exception',e.getMessage()+' Line no:'+e.getLineNumber());           
            
        }
        return ret_map;
        
    }
    /*@InvocableMethod (label='Create CL') 
    public static void ApproveCLDummy(List<Id> cla_id) {
        Credit_Limit__c cl = new Credit_Limit__c();
        List<Credit_Limit__c> clList = new List<Credit_Limit__c>();
        for (Credit_Limit_Application__c cla : [Select Id,Application_Date__c,Application_Type__c,Buyer_Address_Line_1__c,Buyer_Address_Line_2__c,Buyer_Address_Line_3__c,Buyer_Address_Line_4__c,Buyer_Code__c,Buyer_Country__c,Buyer_Name__c,Buyer_Registration_Number__c,Buyer_Trading_Time__c,CL_Application_Amount__c,CL_Pre_Shipment_Application_AMount__c,CL_Type__c,Destination_Market__c,DNB_DUNS__c,Existing_valid_Credit_Limit_on_Buyer__c,Export_Type__c,Goods_or_Services_Involved__c,Harmonized_Code__c,Is_New_Buyer__c,Is_Unpaid_Amount__c,Is_Unpaid_Shipment__c,Market_of_Origin__c,Order_Confirmed_or_Negotiation__c,Order_Payment_Term_Amount__c,Order_Payment_Term_Type__c,Overseas_Goods_or_Services__c,Payment_Term_Days__c,Payment_Term_Type__c,Policy__c,
        Port_Of_Loading__c,Pre_Shipment_Payment_Term_Days__c,Pre_Shipment_Payment_Term_Type__c,Previously_Cancelled_Order_Unilaterally__c,Received_Order_Amount__c,Received_Order_Payment_Type__c,Received_Order_Payment_Term_Method1__c,Received_Order_Payment_Term_Method2__c,Ref_No__c,Remarks__c,Shipment_Commence_Month__c,Shipment_Commence_Year__c,Shipment_Payment_Term_Amount_12_Months__c,Shipment_Payment_Term_Type_12_Months__c,Shipment_Payment_Term_Method_12_Months1__c,Shipment_Payment_Term_Days_12_Months__c,Shipment_Payment_Term_Method_12_Months2__c,Shipment_Payment_Term_Method_12_Months3__c,Shipment_Payment_Term_Method_12_Months4__c,Shipment_Payment_Term_Method_12_Months5__c,Order_Payment_Term_Days__c,Order_Payment_Term_Amount_12_Months__c,Order_Payment_Term_Days_12_Months__c,Order_Payment_Term_Method_12_Months1__c,Order_Payment_Term_Method_12_Months2__c,Order_Payment_Term_Method_12_Months3__c,Order_Payment_Term_Method_12_Months4__c,Order_Payment_Term_Method_12_Months5__c,Confirm_Order_Payment_Terms_Method1__c,Confirm_Order_Payment_Terms_Method2__c,Confirm_Order_Payment_Terms_Method3__c,Confirm_Order_Payment_Terms_Method4__c,Confirm_Order_Payment_Terms_Method5__c,Specific_Goods_Involved__c,Unpaid_Overdue_Order__c,Exporter__c,Is_DCL__c,(select Due_Date__c,Gross_Invoice_Amount__c,Gross_Invoice_Currency__c,Payment_Term_Days__c,Payment_Term_Type__c,Shipment_Or_Invoice_Date__c,Remarks__c from Outstanding_Payments__r) from Credit_Limit_Application__c where Id in :cla_id]) {
                    
            cl.Application_Date__c = cla.Application_Date__c;
            cl.Approve_Date__c = Date.today();
            cl.Buyer_Address_Line_1__c = cla.Buyer_Address_Line_1__c;
            cl.Buyer_Address_Line_2__c = cla.Buyer_Address_Line_2__c;
            cl.Buyer_Address_Line_3__c = cla.Buyer_Address_Line_3__c;
            cl.Buyer_Address_Line_4__c = cla.Buyer_Address_Line_4__c;
            cl.Buyer_Code__c = cla.Buyer_Code__c;
            cl.Buyer_Country__c = cla.Buyer_Country__c;
            cl.Buyer_Name__c = cla.Buyer_Name__c;
            cl.Buyer_Registration_Number__c = cla.Buyer_Registration_Number__c;
            cl.CL_Amount__c = cla.CL_Application_Amount__c;
            cl.CL_Application_Amount__c = cla.CL_Application_Amount__c;
            cl.CL_Effective_Date__c = Date.today();
            cl.CL_No__c = 'cl-1234';
            cl.CL_Status__c = 'Valid';
            cl.Credit_Limit_Application__c = cla.Id;
            cl.Destination_Market__c = cla.Destination_Market__c;
            cl.Export_Type__c = cla.Export_Type__c;
            cl.Exporter__c = cla.Exporter__c;
            cl.Goods_or_Services_Involved__c = cla.Goods_or_Services_Involved__c;
            cl.Harmonized_Code__c = cla.Harmonized_Code__c;
            cl.Is_DCL__c = cla.Is_DCL__c;
            cl.Market_of_Origin__c = cla.Market_of_Origin__c;
            cl.Port_Of_Loading__c = cla.Port_Of_Loading__c;
            cl.Policy__c = cla.Policy__c;
            clList.add(cl);
        }
        insert clList;

    }
    public CLApiHandler() {

    }*/
}