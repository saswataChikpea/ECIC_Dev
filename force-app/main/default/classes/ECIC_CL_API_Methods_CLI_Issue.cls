public with sharing class ECIC_CL_API_Methods_CLI_Issue implements Database.Batchable<sObject>{
    // 1.2 cl/CL/issue B6, U1, U2 53 CLI changed to CL after payment
    public static String convertCLItoCreditLimit(String clApplicationID){
        // 1) Item 53 - After the policyholder makes a payment for the credit limit indication, 
        // EC-Reach 2.0 sends data of the credit limit indication to the legacy system.
        // The legacy system converts the credit limit indication into a credit limit, 
        // then sends the data of the credit limit to EC-Reach 2.0.
        // 1 CUS_NO String 6 234678 Yes Customer No.
        // 2 PCY_TYPE String 2 70 Yes Policy type
        // 3 CL_NO String 10 344556 Yes CL No.
        // 4 CL_EFF_DATE Date 2021-10-01 Yes CL effective date (YYYY-MM-DD)
        // 5 SUBM_TYPE String 1 N Yes Submission type ( N - new , U - uplift , R - renew )
        // 6 PRM_PAID Number 500.00 Yes Premium Paid (HKD)
        // 7 PRM_PAID_DATE Date 2021-10-01 Yes Premium payment date (YYYY-MM-DD)
        try{
            if(!ECIC_API_V1.access_token_success){
                ECIC_API_V1.get_access_token();
            }
        }catch (AuraHandledException e) {
            throw new AuraHandledException(e.getMessage());
        }
        catch(Exception e){
            Map<String,String> msg = new Map<String, String>();
            msg.put('Exception','Exception ====>'+e.getMessage()+'==> line number ==>'+e.getLineNumber());
            System.debug('exception ===>'+msg);
        }
        Map<String, Object> jsonObject = new Map<String, Object>();
        String objectAPIName;
        if(ECIC_API_V1.access_token_success){
            if(clApplicationID != NULL ){
                // objectAPIName = creditLimitID.getSobjectType().getDescribe().getName();
                // System.debug('objectAPIName ====>'+objectAPIName);
                Boolean testContent = False;
                String url_extension = '/api/services/cl/CL/issue';
                String auth_header = ECIC_API_V1.token_type + ' ' + ECIC_API_V1.access_token;
                String url_parameters = '';
                String query = 'SELECT ID, Name, Legacy_Application_Type__c, Exporter__r.Legacy_Customer_Number__c, Policy__r.Legacy_Policy_Type__c, CL_No__c, '+
                        'Legacy_CL_No__c, Legacy_CL_EFF_DATE__c, Premium_Paid_Legacy__c, Legacy_Premium_Paid_Date__c '+
                        'FROM Credit_Limit_Application__c WHERE ID = \'' + clApplicationID + '\'';
                List<Credit_Limit_Application__c> clalist = DataBase.query(query);       //ECIC_API_v1.get_all_fields_query(clApplicationID)
                System.debug('clalist ===>'+clalist);
                if(clalist != NULL && clalist.size()>0){
                    jsonObject.put('CUS_NO', clalist[0].Exporter__r.Legacy_Customer_Number__c);
                    jsonObject.put('PCY_TYPE', clalist[0].Policy__r.Legacy_Policy_Type__c);
                    jsonObject.put('CL_NO', clalist[0].Legacy_CL_No__c);
                    jsonObject.put('CL_EFF_DATE', clalist[0].Legacy_CL_EFF_DATE__c);
                    jsonObject.put('SUBM_TYPE', clalist[0].Legacy_Application_Type__c);
                    jsonObject.put('PRM_PAID', clalist[0].Premium_Paid_Legacy__c);
                    jsonObject.put('PRM_PAID_DATE', clalist[0].Legacy_Premium_Paid_Date__c);
                    system.debug('convertCLItoCreditLimit request body jsonObject ====>'+jsonObject);
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
                }
            }
        }
        return NULL;
    }

    // instance member to retain state across transactions
    public Integer recordsProcessed = 0;
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Name, CL_Status__c from Credit_Limit_Application__c where CL_Status__c=\'Confirmation of payment\''
        );
    }
    public void execute(Database.BatchableContext bc, List<Credit_Limit_Application__c> records){
        // process each batch of records
        List<Credit_Limit_Application__c> update_list = new List<Credit_Limit_Application__c>();
        List<Credit_Limit__c> insert_list = new List<Credit_Limit__c>();
        for (Credit_Limit_Application__c cla : records) {
            String cla_id = cla.Id;
            String response = convertCLItoCreditLimit(cla_id);
            System.debug('cancelCLI response::'+response);
            Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response);
            Object rtn_code = responseMap.get('rtn_code');
            System.debug('cancelCLI rtn_code::'+rtn_code);
            if(Integer.valueOf(rtn_code) == 1){
                System.debug('cancelCLI success::');
                //Credit Limit Application or Credit Limit Incation is issue in legacy system now 
                //create credit limit in salesforce
                // and update the Credit Limit Incation as Approved
                insert_list.add(newCreditLimit());
                cla.CL_Status__c = 'Approved';
                update_list.add(cla);
                System.debug('CLI aproved successfully::'+cla_id);
            }else{
                System.debug('cancelCLI failed::');
            }
        }
        //Credit Limit Application or Credit Limit Incation is calcelled in legacy system now 
        //update the same in salesforce
        update update_list;
        insert insert_list;
    }
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        System.debug(recordsProcessed + ' records processed.');
    }
    private static Credit_Limit__c newCreditLimit(){
        Credit_Limit__c cl = new Credit_Limit__c();
        return cl;
    }
}