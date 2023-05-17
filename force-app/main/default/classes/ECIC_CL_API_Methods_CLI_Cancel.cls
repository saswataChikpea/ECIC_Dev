public with sharing class ECIC_CL_API_Methods_CLI_Cancel implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    public List<Credit_Limit_Application__c> cla_list;
    public ECIC_CL_API_Methods_CLI_Cancel() {
        cla_list = new List<Credit_Limit_Application__c>();
    }
    @InvocableMethod (label='cl invoke')
    public static void invoke(List<String> cla_id) {
        System.debug('invoke param::'+cla_id);
        if(cla_id != null && cla_id.size()>0)
        cancelCLI(cla_id[0]);
    }
    // 1.8 cl/CLI/cancel invoke
    //cancle credit limit application
    public static void cancelCLI(String cla_id){
        System.debug('cancelCLI param::'+cla_id);
        //String response = ECIC_CL_API_Methods.cancelCLIndication(cla_id);//TODO
        //callCancelCLIndication(cla_id);
    }
    // @future(callout=true)
    // public static void callCancelCLIndication(String cla_id){
    //     // Perform a callout to an external service
    //     String response = cancelCLIndication(cla_id);
    //     System.debug('cancelCLI response::'+response);
    //     Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response);
    //     Object rtn_code = responseMap.get('rtn_code');
    //     System.debug('cancelCLI rtn_code::'+rtn_code);
    //     if(Integer.valueOf(rtn_code) == 1){
    //         System.debug('cancelCLI success::');
    //         //Credit Limit Application or Credit Limit Incation is calcelled in legacy system now 
    //         //update the same in salesforce
    //         Credit_Limit_Application__c cla = new Credit_Limit_Application__c(Id=cla_id, CL_Status__c='Cancelled');
    //         update cla;
    //         System.debug('CLI cancelled successfully::'+cla_id);
    //     }else{
    //         System.debug('cancelCLI failed::');
    //         //TODO remove the bellow 2 lines
    //         Credit_Limit_Application__c cla = new Credit_Limit_Application__c(Id=cla_id, CL_Status__c='Cancelled');
    //         update cla;
    //     }
    // }


    // 1.8 cl/CLI/cancel B33 45 Cancel CLI 16-Aug-2021
    public static String cancelCLIndication (ID CLApplicationID){
        System.debug('cancelCLIndication, CLApplicationID='+ CLApplicationID);
        // /api/services/cl/CLI/cancel
        // 1 CL_NO String 10 Yes CL no. needs to cancel
        // 2 CAN_DATE Date Yes Cancel Date (YYYY-MM-DD)
        // 1) Get record by "CL_NO" -- Can not found '"CL_NO" -11 CL master record not found
        //                          -- Check correct CL status, the CL should be in CLI status -18 Incorrect CL status
        //                          -- Check the cancel CLI request already exists -21 Record already exists
        // 2) Check CLI record cancelled Found CLI record, but record status is cancelled -23 CLI current status is cancelled
        // 3) Validate "CAN_DATE" Value is EMPTY or not in API standard format YYYY-MM-DD -20002 Invalid date format
        // item 45	use case B33	
        // Cancel a credit limit indication automatically (for OMBP)	
        // Update the CLI status to legacy system 	Real-time	
        // Policy Management	16-08-2021	
        // "From EC-Reach 2.0 to legacy system:
        // Policyholder ID
        // Policy ID
        // Credit limit indication ID
        // Status: ""Cancelled""
        // Cannellation Date"	"From legacy system to EC-Reach 2.0:
        // Status has been updated successfully or not"	
        try{
            if(!ECIC_API_V1.access_token_success){
                ECIC_API_V1.get_access_token();
            }
        }/*catch (AuraHandledException e) {
            throw new AuraHandledException(e.getMessage());
        }*/
        catch(Exception e){
            Map<String,String> msg = new Map<String, String>();
            msg.put('Exception','Exception ====>'+e.getMessage()+'==> line number ==>'+e.getLineNumber());
            System.debug('exception ===>'+msg);
        }
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_V1.access_token_success){
            if(CLApplicationID != NULL ){
                String query = 'SELECT ID, Name, Legacy_CL_No__c, Cancellation_Date__c '+     
                        'FROM Credit_Limit_Application__c WHERE ID = \'' + clApplicationID + '\'';
                List<Credit_Limit_Application__c> clalist = DataBase.query(query);       //ECIC_API_v1.get_all_fields_query(clApplicationID)
                System.debug('clalist ===>'+clalist);
                Boolean testContent = False;
                String url_extension = '/api/services/cl/CLI/cancel';
                String auth_header = ECIC_API_V1.token_type + ' ' + ECIC_API_V1.access_token;
                String url_parameters = '';
                
                if(clalist != NULL && clalist.size()>0){
                    try{
                    jsonObject.put('CL_NO', String.valueOf(clalist[0].Legacy_CL_No__c));
                    jsonObject.put('CAN_DATE', fieldMappingTranslation.date_format(clalist[0].Cancellation_Date__c));
                    Map<String, String> respParserMap = ECIC_API_v1.postContentToECIC(testContent, jsonObject, url_extension, url_parameters, auth_header);
                    if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('Exception')){
                        system.debug('Exception in response ====>'+respParserMap.get('Exception'));
                        return 'exception '+respParserMap.get('Exception');
                    }
                    else if(respParserMap != NULL && respParserMap.size()>0 && respParserMap.containsKey('ciphertext')){
                        system.debug('json response ====>'+respParserMap.get('ciphertext'));
                        return respParserMap.get('ciphertext');
                    }
                    else{
                        if(respParserMap != NULL && respParserMap.size()>0){
                            for(String Key : respParserMap.keyset()){
                                system.debug('response key =====>'+key +' == value ==>'+respParserMap.get(key));
                            }
                            return 'response received';
                        }
                    }
                    } Catch(Exception e) {
                        System.debug('Exception='+e.getMessage());
                    }
                }
                return NULL;
            }
            return NULL;
        }
        else{
            return NULL;
        }
    }
    // instance member to retain state across transactions
    public Integer recordsProcessed = 0;
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Name, Exporter__c, Hide_from_PH__c, CL_Status__c,Waiting_for_Payment_days__c from Credit_Limit_Application__c where CL_Status__c!=\'Invalid\' and CL_Status__c!=\'Cancelled\' and CL_Status__c!=\'Approved\' and CL_Type__c=\'CLI\' and Waiting_for_Payment_days__c!=null'
        );
    }
    public void execute(Database.BatchableContext bc, List<Credit_Limit_Application__c> records){
        // process each batch of records
        List<Credit_Limit_Application__c> update_list = new List<Credit_Limit_Application__c>();
        List<Task> newTask = new List<Task>();
        System.debug('records='+records);
        for (Credit_Limit_Application__c cla : records) {
            System.debug('CLA Name='+cla.Name+' Waiting_for_Payment_days__c='+cla.Waiting_for_Payment_days__c);
            String cla_id = cla.Id;
            if (cla.Waiting_for_Payment_days__c == 7){
                try{
                System.debug('7 days waiting for payment='+cla);
                cla_list.add(cla);
                // SendEmailApex.sendEmailAccount(cla.Exporter__c, cla_id, 'CL_Indication_Acceptance_Reminder_OMBP', false, null, null);
                String sub = 'Follow up for the payment.';
                String des = 'The policy holder did not make payment agains CLI. Please follow up.';
                // TaskManagement.createTask(subject, description, 'High', '', '', cla_id,'');
                newTask.add(new Task(Subject = sub,
                    Description = des,
                    Priority = 'High',
                    WhatId = cla_id));
                } catch(Exception e) {
                    System.debug('Exception in Email and Task'+e.getMessage());
                }
            } else if ((cla.Waiting_for_Payment_days__c > 14 ) && (cla.Waiting_for_Payment_days__c < 21)) {
                cla.Hide_from_PH__c = true;
                update_list.add(cla);
            } else {
                
                String response = cancelCLIndication(cla_id);
                System.debug('cancelCLI response::'+response);
                Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response);
                Object rtn_code = responseMap.get('rtn_code');
                System.debug('cancelCLI rtn_code::'+rtn_code);
                if(Integer.valueOf(rtn_code) == 1){
                    System.debug('cancelCLI success::');
                    //Credit Limit Application or Credit Limit Incation is calcelled in legacy system now 
                    //update the same in salesforce
                    cla.CL_Status__c = 'Invalid';
                    update_list.add(cla);
                    System.debug('CLI cancelled successfully::'+cla_id);
                }else{
                    System.debug('cancelCLI failed::');
                }
            }
        }
        //Credit Limit Application or Credit Limit Incation is calcelled in legacy system now 
        //update the same in salesforce
        update update_list;
        if(newTask.size()>0){
            insert newTask;
        }
    }
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        for(Credit_Limit_Application__c cla:cla_list) {
            SendEmailApex.sendEmailAccount(cla.Exporter__c, cla.Id, 'CL_Indication_Acceptance_Reminder_OMBP', false, null, null);
        }
        System.debug(recordsProcessed + ' records processed.');
    }
}