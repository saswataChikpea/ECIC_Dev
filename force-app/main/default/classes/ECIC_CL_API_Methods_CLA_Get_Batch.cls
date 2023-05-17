public with sharing class ECIC_CL_API_Methods_CLA_Get_Batch implements
    Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    // instance member to retain state across transactions
    public Integer recordsProcessed = 0;
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Legacy_Ref_No__c, ' +
            'CL_No__c, CL_Progress_Step__c, Buyer_Country__c, Buyer_Code__c, Buyer_Name__c, ' +
            'Buyer_Address_Line_1__c, Buyer_Address_Line_2__c, Buyer_Address_Line_3__c, Buyer_Address_Line_4__c, ' +
            'CL_Status_Reason__c, Application_Date__c, CL_Effective_Date__c, Expiry_Date__c, CL_Amount__c, CL_Condition__c ' +
            'FROM Credit_Limit_Application__c ' +
            'WHERE CL_Status__c=\'Processing\''
            // + ' AND Legacy_Ref_No__c = \'CA00273909\''
        );
    }
    public void execute(Database.BatchableContext bc, List<Credit_Limit_Application__c> scope){
        // process each batch of records
        List<Credit_Limit_Application__c> clasUpdateList = new List<Credit_Limit_Application__c>();
        for (Credit_Limit_Application__c cla : scope) {
            if (cla.Legacy_Ref_No__c != NULL) {
                String res = getCLA(cla.Legacy_Ref_No__c);
                System.debug('getCLA response --> '+res);
                Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(res);
                if(resmap.get('rtn_code') == '1'){
                    String metadatastr = JSON.serialize(resmap.get('meta_data'));
                    Map<String, Object> meta = (Map<String, Object>)JSON.deserializeUntyped(metadatastr);
                    cla.CL_No__c = Integer.valueOf(meta.get('cl_no'));	
                    cla.CL_Progress_Step__c = String.valueOf(meta.get('step'));		
                    cla.Buyer_Country__c = fieldMappingTranslation.getCountryName(String.valueOf(meta.get('byr_ctry'))); 	
                    cla.Buyer_Code__c = String.valueOf(meta.get('byr_code')); 	
                    cla.Buyer_Name__c = String.valueOf(meta.get('byr_name')); 	
                    cla.Buyer_Address_Line_1__c = String.valueOf(meta.get('byr_addr_1')); 	
                    cla.Buyer_Address_Line_2__c = String.valueOf(meta.get('byr_addr_2')); 	
                    cla.Buyer_Address_Line_3__c = String.valueOf(meta.get('byr_addr_3')); 	
                    cla.Buyer_Address_Line_4__c = String.valueOf(meta.get('byr_addr_4')); 	
                    cla.CL_Status_Reason__c = String.valueOf(meta.get('sts_desc')); 
                    if (String.valueOf(meta.get('appl_date')) != NULL && String.valueOf(meta.get('appl_date')) != 'null') 
                        cla.Application_Date__c = Date.valueOf(String.valueOf(meta.get('appl_date'))); 	
                    if (String.valueOf(meta.get('cl_eff_date')) != NULL && String.valueOf(meta.get('cl_eff_date')) != 'null')
                        cla.CL_Effective_Date__c = Date.valueOf(String.valueOf(meta.get('cl_eff_date'))); 
                    if (String.valueOf(meta.get('cl_exp_date')) != NULL && String.valueOf(meta.get('cl_exp_date')) != 'null')
                        cla.Expiry_Date__c = Date.valueOf(String.valueOf(meta.get('cl_exp_date'))); 
                    if (String.valueOf(meta.get('cl_amt')) != NULL && String.valueOf(meta.get('cl_amt')) != 'null')
                        cla.CL_Amount__c = Decimal.valueOf(String.valueOf(meta.get('cl_amt'))); 		
                    cla.CL_Condition__c = String.valueOf(meta.get('cl_cond')); 
                    clasUpdateList.add(cla);
                    System.debug('CLA to update --> '+cla);
                }
            }
            // increment the instance member counter
            recordsProcessed = recordsProcessed + 1;
        }
        update clasUpdateList;
    }
    public void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed.');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
        // call some utility to send email
        //EmailUtils.sendMessage(job, recordsProcessed);
    }

    // API call to fetch CLA by REF_NO
    public static String getCLA(String refNo) {        
        if(!ECIC_API_V1.access_token_success){
            ECIC_API_V1.get_access_token();
        }        
        if (ECIC_API_v1.access_token_success) {
            return ECIC_CL_API_Methods.getCLApplication(refNo);
        } else {
            return NULL;
        }
    }
}