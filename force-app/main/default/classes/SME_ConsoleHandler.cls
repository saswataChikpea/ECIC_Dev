public with sharing class SME_ConsoleHandler {

    /*
        ret_map.put('rtn_code', 1); // 1 Success, -1 failure
        ret_map.put('rtn_msgs', 'Success'); //  Return Message
        ret_map.put('meta_data', null); // Other information or Error details
    */
    public static Map<String,Object> handler(String json_string) {
        Map<String,Object> my_map = new Map<String,Object>{
            'rtn_code' => -1,
            'rtn_msgs' => '',
            'meta_data' => null
        };
        Map<String,Object> ret_map = new Map<String,Object>();
        //my_map.put('success',String.valueOf(true));
        Map<String, Object> parsedMap = new Map<String, Object>();
        Map<String, Object> parsedInnerMap = new Map<String, Object>();
        String function_name;
        String method_return_value = '';
        
        parsedMap = (Map<String, Object>)JSON.deserializeUntyped(json_string);
		try {    		
            System.debug('parsed json='+parsedMap);
            Object parsedInnerMap_obj = parsedMap.get('meta_data');
            parsedInnerMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(parsedInnerMap_obj));
            function_name = (String)parsedInnerMap.get('funcname');
            System.debug('function_name='+function_name);
            switch on function_name {
                when 'nfc_results_update' {
                    ret_map = updateCustomerNFC(parsedInnerMap, my_map);
                }
                when else {
                    ret_map.put('rtn_code', -1);
                    ret_map.put('rtn_msgs', 'Error: function '+function_name+' not found.');
                    ret_map.put('meta_data', null);
                }
            }
		} catch(Exception e) {
    		ret_map.put('rtn_code', -1);
            ret_map.put('rtn_msgs', 'Error: '+e.getMessage());
            ret_map.put('meta_data', new Map<String,Object>{
                'cause' => e.getCause()?.getMessage(),
                'type' => e.getTypeName(),
                'line' => e.getLineNumber(),
                'message' => e.getMessage(),
                'trace' => e.getStackTraceString()
            });
    		
    	}
        return ret_map;
    }
  
   
    /*
    "meta_data": {
        "funcname": "nfc_results_update",
        "Legacy_Customer_Number__c": "372527",
        "Negative_File_Check__c": [{
                "Report_Received_Date__c": "2021-11-12",
                "Review_Date__c": "",
                "Review_Officer__c": "",
                "Acknowledge_Status__c": "Y",
                "Case": [{
                        "Case_Type__c": "CRT",
                        "Legacy_Case_Id__c ": "50898",
                        "Status": "O",
                        "NFC_Case_Date__c": "2021-1-1",
                        "NFC_Case_Amount__c": "100",
                        "NFC_Case_Create_Remarks__c": "a",
                        "NFC_Case_Update_Remarks__c": ""
                    }
                ]
            }
        ]
    }
    */
    public static Map<String,Object> updateCustomerNFC(Map<String, Object> meta_data, Map<String,Object> ret_map) {
        /*
        System.debug('updateCustomerNFC called.'+meta_data);
        String legacyCustomerNumber = (String)meta_data.get('Legacy_Customer_Number__c');
        System.debug('legacyCustomerNumber : '+legacyCustomerNumber);
        for(Account acc : [select id,name,Current_Policy__c,Last_NFC_Retrieved_Date__c,Check_For_NFC__c 
            from Account  where Legacy_Customer_Number__c =:legacyCustomerNumber]){

                for(Object obj : (List<Object>) meta_data.get('Negative_File_Check__c')){
                    System.debug('obj ====>>>>>>>>'+obj);
                   // System.debug('obj ====>>>>>>>>'+obj.acknowledgeStatus);
                }
           
        }
        */
        List<Negative_File_Check__c> nfcCreateList = new List<Negative_File_Check__c>();
        List<Account> updateAccList = new List<Account>();
        String legacyCustomerNumber = (String)meta_data.get('Legacy_Customer_Number__c');
        System.debug('cust_no='+legacyCustomerNumber);
        List<Object> fileList = (List<Object>)meta_data.get('Negative_File_Check__c');
        String accId;
        Boolean isNfcCaseExists;
        for(Account acc : [select id,name,Current_Policy__c,Last_NFC_Retrieved_Date__c,Check_For_NFC__c,NFC_Check__c,NFC_Results__c from Account where Legacy_Customer_Number__c =:legacyCustomerNumber]){
            accId=acc.id;
            Map<String,Object> fMap;
            Map<String,Object> cMap;
            Integer counter=0;
            acc.NFC_Results__c='Clean';
            for (Object f: fileList) {
                fMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(f));
                String receivedDate = (String)fMap.get('Report_Received_Date__c');
                String reviewDate = (String)fMap.get('Review_Date__c');
                String reviewOfficer = (String)fMap.get('Review_Officer__c');
                String ackStatus = (String)fMap.get('Acknowledge_Status__c');
                System.debug('  '+receivedDate+', '+reviewDate+', '+reviewOfficer+', '+ackStatus);
                Negative_File_Check__c nfcObjInfo = new Negative_File_Check__c();
                nfcObjInfo.Account__c = acc.id;
                nfcObjInfo.Acknowledge_Status__c = (String)fMap.get('Acknowledge_Status__c');
                nfcObjInfo.Report_Received_Date__c = (String)fMap.get('Report_Received_Date__c');
                nfcObjInfo.Review_Date__c =  (String)fMap.get('Review_Date__c');
                nfcObjInfo.Review_Officer__c = (String)fMap.get('Review_Officer__c');
                nfcCreateList.add(nfcObjInfo);
                /*List<Object> caseList = (List<Object>)fMap.get('Case');
                for (Object c : caseList) {
                    cMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(c));
                    String type = (String)cMap.get('Case_Type__c');
                    String caseId = (String)cMap.get('Legacy_Case_Id__c');
                    String caseDate = (String)cMap.get('NFC_Case_Date__c');
                    String status = (String)cMap.get('Status');
                    String amount = (String)cMap.get('NFC_Case_Amount__c');
                    String createRemark = (String)cMap.get('NFC_Case_Create_Remarks__c');
                    String updateRemark = (String)cMap.get('NFC_Case_Update_Remarks__c');
                    System.debug('      '+type+', '+caseId+', '+caseDate+', '+status+', '+amount+', '+createRemark+', '+updateRemark);
                }*/
                List<Object> caseList = (List<Object>)fMap.get('Case');
                for (Object c : caseList) {
                    acc.NFC_Results__c='Un Clean';
                    break;
                }

            } 
            acc.Last_NFC_Retrieved_Date__c = System.now();
            acc.NFC_Check__c='Success';
            updateAccList.add(acc); 
        }
        Map<Integer,Id> counterVsNfcIdMap = new Map<Integer,Id>();
        List<Database.SaveResult> nfcInsertResults = Database.insert(nfcCreateList, false);
        for (Integer i = 0; i < nfcInsertResults.size(); i++) {
            if (nfcInsertResults[i].isSuccess()) {
                System.debug('NFC Successfully created ID: ' + nfcInsertResults[i].getId());
                counterVsNfcIdMap.put(i,nfcInsertResults[i].getId());
            } else {
                System.debug('Error: could not create NFC '+ 'for array element ' + i + '.');
                System.debug('The error reported was: '+ nfcInsertResults[i].getErrors()[0].getMessage() + '\n');
            }
        }
        System.debug('counterVsNfcIdMap 93===>>>'+counterVsNfcIdMap);
        if(counterVsNfcIdMap!= null && !counterVsNfcIdMap.isEmpty()){
            List<Case> nfcCaseCreateList = new List<Case>();
            Map<String,Object> fMap;
            Map<String,Object> cMap;
            Integer counterChecking=0;
            for (Object f: fileList) {
                System.debug('for insert completed loop1 fMap.');
                fMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(f));
                List<Object> caseList = (List<Object>)fMap.get('Case');
                for (Object c : caseList) {
                    System.debug('for insert completed loop2 fMap.');
                    
                    cMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(c));
                    String type = (String)cMap.get('Case_Type__c');
                    String caseId = (String)cMap.get('Legacy_Case_Id__c');
                    String caseDate = (String)cMap.get('NFC_Case_Date__c');
                    String status = (String)cMap.get('Status');
                    String amount = (String)cMap.get('NFC_Case_Amount__c');
                    String createRemark = (String)cMap.get('NFC_Case_Create_Remarks__c');
                    String updateRemark = (String)cMap.get('NFC_Case_Update_Remarks__c');
                    System.debug('      '+type+', '+caseId+', '+caseDate+', '+status+', '+amount+', '+createRemark+', '+updateRemark);
                    
                    Case caseObj = new Case();
                    caseObj.Legacy_Case_ID__c = (String)cMap.get('Legacy_Case_Id__c');
                    caseObj.Case_Type__c = (String)cMap.get('Case_Type__c');
                    caseObj.Status = (String)cMap.get('Status');
                    caseObj.NFC_Case_Date__c = (String)cMap.get('NFC_Case_Date__c');
                    caseObj.NFC_Case_Amount__c = Decimal.valueOf((String)cMap.get('NFC_Case_Amount__c'));
                    caseObj.NFC_Case_Create_Remarks__c =  (String)cMap.get('NFC_Case_Create_Remarks__c');
                    caseObj.NFC_Case_Update_Remarks__c = (String)cMap.get('NFC_Case_Update_Remarks__c');
                    caseObj.Negative_File_Check__c = counterVsNfcIdMap.get(counterChecking);
                    caseObj.AccountId = accId;
                    caseObj.Subject = 'Negative File Check';
                    caseObj.Type = 'NFC';
                    nfcCaseCreateList.add(caseObj);
                }
                counterChecking = counterChecking+1;
            } 
            System.debug('nfcCaseCreateList 127===>> '+nfcCaseCreateList);
            List<Database.SaveResult> nfcCaseInsertResults = Database.insert(nfcCaseCreateList, false);
            for (Integer i = 0; i < nfcCaseInsertResults.size(); i++) {
                if (nfcCaseInsertResults[i].isSuccess()) {
                    System.debug('NFC Case Successfully created ID: ' + nfcCaseInsertResults[i].getId());
                    isNfcCaseExists=true;
                } else {
                    System.debug('Error: could not create NFC Case '+ 'for array element ' + i + '.');
                    System.debug('The error reported was: '+ nfcCaseInsertResults[i].getErrors()[0].getMessage() + '\n');
                }
            } 
        }
        System.debug('isNfcCaseExists ==>>'+isNfcCaseExists);
        if(isNfcCaseExists){
            update updateAccList;
            System.debug('Account updated Successfully!!!');
            ret_map.put('rtn_code', 1);
            ret_map.put('rtn_msgs', 'Success');
            SME_RelatedTask.createTask(accId,'Review NFC Results','Legacy Provided the nfc results please verify.','High','Review NFC Results');
        }else{
            ret_map.put('rtn_code', -1);
            ret_map.put('rtn_msgs', 'Case not found.');
        }
        ret_map.put('meta_data', null);
        return ret_map;
    }

    /*public static void createTask(String accountID){
        List<user> smeUsers = [select id,Email,profile.name FROM user where profile.name='SME Team Staff'];
        try {
            Task newTask = new Task();
            newTask.Subject = 'Review NFC Results';
            newTask.Description = 'Legacy Provided the nfc results please verify.';
            newTask.Priority = 'High';
            newTask.WhatId = accountID;
            if (smeUsers != null && !smeUsers.isEmpty()) {
                newTask.OwnerId=smeUsers[0].id;
            }

            newTask.Type = 'Review NFC Results';
            insert newTask;
            System.debug('Task Created Succes fully for SME Team');
        } catch (Exception e) {
            System.debug('Exception at createTask :'+e.getMessage()+' Stack '+e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }*/

    //@InvocableMethod(callout=true label='Fetch NFC Results' description='')
    //public static void getNFCRecordFromLegacy(List<ID> ids) {
    //@future(callout=true)
    // @AuraEnabled
    // public static boolean getNFCRecordFromLegacyOld(String accID) {
    //     System.debug('getNFCRecordFromLegacy accID : '+accID);
    //     boolean isSuccess=false;
        
    //     try {
    //         //System.debug('SME_ConsoleHandler getNFCRecordFromLegacy :'+ids);
    //         //List<Account> accList = [select Legacy_Customer_Number__c from Account where id in :ids];
            
    //         List<Account> updateAccList = new List<Account>();
    //         List<Account> accList = [select Legacy_Customer_Number__c,NFC_Retrieve_Description__c,NFC_Check__c,Last_NFC_Retrieved_Date__c from Account where id = :accID];
    //         System.debug('accList : '+accList);
    //         if(accList != null && !accList.isEmpty()){
    //             string cus_no = accList[0].Legacy_Customer_Number__c;//'372527';
    //             String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
    //             System.debug('ECIC Setting name ===>'+ecicset);
    //             String access_token_1=ECIC_API_V1.get_access_token();
    //             System.debug('access_token_1 ====>'+access_token_1);
    //             String response = ECIC_CustomerAPI.getNFCRecord(cus_no);
    //             System.debug('response :'+response);
    //             NFC_ResponseFromLegacy nfcObj=NFC_ResponseFromLegacy.parse(response);
    //             System.debug('nfcObj Code ====>>>'+nfcObj.rtn_code+' whole :'+nfcObj);
    //             if(nfcObj.rtn_code.equals('1')){
    //                 System.debug('Get NFC Call success!!!');
    //                 isSuccess=true;
    //                 insertNFC(nfcObj,cus_no);
    //             }else if(nfcObj.rtn_code.equals('-1')){
    //                 //sendRequestForNfcResults(cus_no);
    //                 String errResponse='';
    //                 if(nfcObj.rtn_msgs!=null && nfcObj.rtn_msgs.size()>0){
    //                     for(Integer nfcRecord=0;nfcRecord<nfcObj.rtn_msgs.size();nfcRecord++){
    //                         System.debug('nfcRecord<nfcObj.rtn_msgs '+nfcObj.rtn_msgs[nfcRecord].msg_code);
    //                         errResponse = '\nCode : '+nfcObj.rtn_msgs[nfcRecord].msg_code+'\nData : '+nfcObj.rtn_msgs[nfcRecord].msg_data+'\nDescription :'+nfcObj.rtn_msgs[nfcRecord].msg_desc+'\n\n';
    //                     }
    //                     for(Account acc: accList){
    //                         acc.NFC_Retrieve_Description__c='Response '+errResponse;
    //                         acc.NFC_Check__c='Failed';
    //                         acc.Last_NFC_Retrieved_Date__c=System.now();
    //                         updateAccList.add(acc);
    //                     }
    //                     System.debug('updateAccList ==>>'+updateAccList);
    //                     if(updateAccList!= null && !updateAccList.isEmpty()){
    //                         update updateAccList;
    //                         System.debug('NFC Failed.');
    //                     }
    //                 }
    //             }
    //         }
    //     } catch (Exception ex) {
    //         System.debug('Exception while calling getNFCRecordAura : '+ex.getMessage()+' Stack : '+ex.getStackTraceString());
    //     } 
    //     System.debug('isSuccess==>>'+isSuccess);
    //     return isSuccess;
    // }

    public static void sendRequestForNfcResults(String cus_no) {
        System.debug('SME_ConsoleHandler sendRequestForNfcResults :'+cus_no);//372527
        try {
            String response = ECIC_CustomerAPI.createNFCRecordAura(cus_no);
            System.debug('sendRequestForNfcResults response  :'+response);
            System.debug('response :'+response);
            Account accObj = [select id,name,Current_Policy__c,Last_NFC_Retrieved_Date__c,Check_For_NFC__c,
                New_NFC_results_Request_Sent__c,New_NFC_results_Request_Sent_Date__c,
                New_NFC_results_Request_Sent_Legacy_Resp__c 
                from Account where Legacy_Customer_Number__c =:cus_no ];
                
            NFC_ResponseFromLegacy nfcObj=NFC_ResponseFromLegacy.parse(response);
            System.debug('nfcObj Code ====>>>'+nfcObj.rtn_code+' whole :'+nfcObj);
            System.debug('nfcObj Code  meta_data :'+nfcObj.meta_data);
            System.debug('nfcObj Code  meta_data :'+nfcObj.rtn_msgs);
            if(nfcObj.rtn_code.equals('1')){
                System.debug('Request Sent Successfully for NFC.');
                accObj.New_NFC_results_Request_Sent__c = 'Success';
                accObj.New_NFC_results_Request_Sent_Date__c = System.now();
                update accObj;
                System.debug('Account updated successfully.');

            }else{
                System.debug('Failed request for NFC results.');
                accObj.New_NFC_results_Request_Sent__c = 'Failed';
                accObj.New_NFC_results_Request_Sent_Date__c = System.now();
                accObj.New_NFC_results_Request_Sent_Legacy_Resp__c = String.valueOf(nfcObj.rtn_msgs);
                update accObj;
                System.debug('Account updated for failed nfc results request.');
            }
        } catch (Exception ex) {
            System.debug('Exception while calling createNFCRecordAura : '+ex.getMessage()+' Stack : '+ex.getStackTraceString());
        } 
    }

    // private static void insertNFC(NFC_ResponseFromLegacy nfcObj,String cus_no,String proposalId){
    //     System.System.debug('insertNFC called.');
    //     List<Account> updateAccList = new List<Account>();
    //     Map<Integer,List<Case>> nfcIdentiyVScaseListMap= new  Map<Integer,List<Case>>();
    //     Map<Integer,List<Negative_File_Check__c>> integerVSnfcMap= new  Map<Integer,List<Negative_File_Check__c>>();
    //     List<Negative_File_Check__c> nfcCreateList = new List<Negative_File_Check__c>();
    //     String accId;
    //     for(Account acc : [select id,name,Current_Policy__c,Last_NFC_Retrieved_Date__c,Check_For_NFC__c,NFC_Results__c from Account where Legacy_Customer_Number__c =:cus_no]){
    //         accId = acc.id;
    //         Integer counter=0;
    //         acc.NFC_Results__c='Clean';
    //         for(NFC_ResponseFromLegacy.nfc nfcData : nfcObj.meta_data.nfc){
    //             System.debug('for loop1 nfcData '+nfcData);
    //             Negative_File_Check__c nfcObjInfo = new Negative_File_Check__c();
    //             nfcObjInfo.Account__c = acc.id;
    //             nfcObjInfo.Acknowledge_Status__c = nfcData.ack_sts;
    //             nfcObjInfo.Report_Received_Date__c = nfcData.rpt_recv_date;
    //             nfcObjInfo.Review_Date__c = nfcData.rev_date;
    //             nfcObjInfo.Review_Officer__c = nfcData.rev_ofr;
    //             nfcCreateList.add(nfcObjInfo);
    //             for(NFC_ResponseFromLegacy.cases casesData : nfcData.cases ){
    //                 acc.NFC_Results__c='Un Clean';
    //                 break;
    //             }
    //         }
    //         acc.Last_NFC_Retrieved_Date__c = System.now();
    //         //acc.Check_For_NFC__c=false;
    //         acc.NFC_Check__c='Success';
    //         updateAccList.add(acc);
    //     }
    //     Map<Integer,Id> counterVsNfcIdMap = new Map<Integer,Id>();
    //     List<Database.SaveResult> nfcInsertResults = Database.insert(nfcCreateList, false);
    //     for (Integer i = 0; i < nfcInsertResults.size(); i++) {
    //         if (nfcInsertResults[i].isSuccess()) {
    //             System.debug('NFC Successfully created ID: ' + nfcInsertResults[i].getId());
    //             counterVsNfcIdMap.put(i,nfcInsertResults[i].getId());
    //         } else {
    //             System.debug('Error: could not create NFC '+ 'for array element ' + i + '.');
    //             System.debug('The error reported was: '+ nfcInsertResults[i].getErrors()[0].getMessage() + '\n');
    //         }
    //     }
    //     System.debug('counterVsNfcIdMap 93===>>>'+counterVsNfcIdMap);
    //     if(counterVsNfcIdMap!= null && !counterVsNfcIdMap.isEmpty()){
    //         List<Case> nfcCaseCreateList = new List<Case>();
    //         Integer counterChecking=0;
    //         for(NFC_ResponseFromLegacy.nfc nfcData : nfcObj.meta_data.nfc){
    //             System.debug('for insert completed loop1 nfcData '+nfcData);
    //             for(NFC_ResponseFromLegacy.cases casesData : nfcData.cases ){
    //                 System.debug('for loop2 casesData '+casesData);
    //                 if(counterVsNfcIdMap!= null && counterVsNfcIdMap.containsKey(counterChecking)){
    //                     Case caseObj = new Case();
    //                     caseObj.Case_Type__c = casesData.case_type;
    //                     //caseObj.Legacy_Case_Id__c = casesData.case_id;
    //                     caseObj.Status = casesData.case_sts;
    //                     caseObj.NFC_Case_Date__c = casesData.case_date;
    //                     caseObj.NFC_Case_Amount__c = Integer.valueOf(casesData.case_amt);
    //                     caseObj.NFC_Case_Create_Remarks__c = casesData.case_create_rmk;
    //                     caseObj.NFC_Case_Update_Remarks__c = casesData.case_update_rmk;
    //                     caseObj.Negative_File_Check__c = counterVsNfcIdMap.get(counterChecking);
    //                     caseObj.AccountId = accId;
    //                     caseObj.Subject='Negative File Check';
    //                     nfcCaseCreateList.add(caseObj);
                        
    //                 }
    //             }
    //             counterChecking = counterChecking+1;
    //         }
    //         System.debug('nfcCaseCreateList 127===>> '+nfcCaseCreateList);
            
    //         List<Database.SaveResult> nfcCaseInsertResults = Database.insert(nfcCaseCreateList, false);
    //         for (Integer i = 0; i < nfcCaseInsertResults.size(); i++) {
    //             if (nfcCaseInsertResults[i].isSuccess()) {
    //                 System.debug('NFC Case Successfully created ID: ' + nfcCaseInsertResults[i].getId());
    //             } else {
    //                 System.debug('Error: could not create NFC Case '+ 'for array element ' + i + '.');
    //                 System.debug('The error reported was: '+ nfcCaseInsertResults[i].getErrors()[0].getMessage() + '\n');
    //             }
    //         }
    //     }
    //     update updateAccList;
    //     SME_RelatedTask.createTask(accId,'Review NFC Results','Legacy Provided the nfc results please verify.','High','Review NFC Results');
    //     System.debug('Account updated Successfully!!!');
    // }

    @AuraEnabled
    public static boolean getNFCRecordFromLegacy(String recordId,String calledFrom) {
        System.debug('getNFCRecordFromLegacy calledFrom : '+calledFrom);
        boolean isSuccess=false;
        String accID;
        String proposalId;
        if(calledFrom.equals('Account')){
            accID = recordId;
            proposalId = SmeConsole.getLatestProposalOfAccount(recordId);
        }else if(calledFrom.equals('Proposal')){
            proposalId = recordId;
            accID = SmeConsole.getAccountFromProposal(recordId);
        }
        try {
            //System.debug('SME_ConsoleHandler getNFCRecordFromLegacy :'+ids);
            //List<Account> accList = [select Legacy_Customer_Number__c from Account where id in :ids];
            
            List<Account> updateAccList = new List<Account>();
            List<Account> accList = [select Legacy_Customer_Number__c,NFC_Retrieve_Description__c,NFC_Check__c,Last_NFC_Retrieved_Date__c from Account where id = :accID];
            System.debug('accList : '+accList);
            if(accList != null && !accList.isEmpty()){
                string cus_no = accList[0].Legacy_Customer_Number__c;//'372527';
                String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
                System.debug('ECIC Setting name ===>'+ecicset);
                String access_token_1=ECIC_API_V1.get_access_token();
                System.debug('access_token_1 ====>'+access_token_1);
                String response = ECIC_CustomerAPI.getNFCRecord(cus_no);
                System.debug('response :'+response);
                NFC_ResponseFromLegacy nfcObj=NFC_ResponseFromLegacy.parse(response);
                System.debug('nfcObj Code ====>>>'+nfcObj.rtn_code+' whole :'+nfcObj);
                if(nfcObj.rtn_code.equals('1')){
                    System.debug('Get NFC Call success!!!');
                    isSuccess=true;
                    insertNFC(nfcObj,cus_no,proposalId);
                }else if(nfcObj.rtn_code.equals('-1')){
                    //Api 4.8
                    sendRequestForNfcResults(cus_no);
                    String errResponse='';
                    if(nfcObj.rtn_msgs!=null && nfcObj.rtn_msgs.size()>0){
                        for(Integer nfcRecord=0;nfcRecord<nfcObj.rtn_msgs.size();nfcRecord++){
                            System.debug('nfcRecord<nfcObj.rtn_msgs '+nfcObj.rtn_msgs[nfcRecord].msg_code);
                            errResponse = '\nCode : '+nfcObj.rtn_msgs[nfcRecord].msg_code+'\nData : '+nfcObj.rtn_msgs[nfcRecord].msg_data+'\nDescription :'+nfcObj.rtn_msgs[nfcRecord].msg_desc+'\n\n';
                        }
                        for(Account acc: accList){
                            acc.NFC_Retrieve_Description__c='Response '+errResponse;
                            acc.NFC_Check__c='Failed';
                            acc.Last_NFC_Retrieved_Date__c=System.now();
                            updateAccList.add(acc);
                        }
                        System.debug('updateAccList ==>>'+updateAccList);
                        if(updateAccList!= null && !updateAccList.isEmpty()){
                            update updateAccList;
                            System.debug('NFC Failed.');
                        }
                    }
                    //Api 4.8
                    //sendRequestForNfcResults(cus_no);
                }
            }
        } catch (Exception ex) {
            System.debug('Exception while calling getNFCRecordAura : '+ex.getMessage()+' Stack : '+ex.getStackTraceString());
        } 
        System.debug('isSuccess==>>'+isSuccess);
        return isSuccess;
    }

    private static void insertNFC(NFC_ResponseFromLegacy nfcObj,String cus_no,String proposalId){
        System.System.debug('insertNFC called.');
        List<Account> updateAccList = new List<Account>();
        Map<Integer,List<Case>> nfcIdentiyVScaseListMap= new  Map<Integer,List<Case>>();
        Map<Integer,List<Negative_File_Check__c>> integerVSnfcMap= new  Map<Integer,List<Negative_File_Check__c>>();
        List<Negative_File_Check__c> nfcCreateList = new List<Negative_File_Check__c>();
        String accId;
        boolean isNfcUnClean;
        for(Account acc : [select id,name,Current_Policy__c,Last_NFC_Retrieved_Date__c,Check_For_NFC__c,NFC_Results__c from Account where Legacy_Customer_Number__c =:cus_no]){
            accId = acc.id;
            Integer counter=0;
            acc.NFC_Results__c='Clean';
            isNfcUnClean=false;
            for(NFC_ResponseFromLegacy.nfc nfcData : nfcObj.meta_data.nfc){
                System.debug('for loop1 nfcData '+nfcData);
                Negative_File_Check__c nfcObjInfo = new Negative_File_Check__c();
                nfcObjInfo.Account__c = acc.id;
                nfcObjInfo.Acknowledge_Status__c = nfcData.ack_sts;
                nfcObjInfo.Report_Received_Date__c = nfcData.rpt_recv_date;
                nfcObjInfo.Review_Date__c = nfcData.rev_date;
                nfcObjInfo.Review_Officer__c = nfcData.rev_ofr;
                nfcCreateList.add(nfcObjInfo);
                for(NFC_ResponseFromLegacy.cases casesData : nfcData.cases ){
                    acc.NFC_Results__c='Un Clean';
                    isNfcUnClean=true;
                    break;
                }
            }
            acc.Last_NFC_Retrieved_Date__c = System.now();
            //acc.Check_For_NFC__c=false;
            acc.NFC_Check__c='Success';
            updateAccList.add(acc);
        }
        Map<Integer,Id> counterVsNfcIdMap = new Map<Integer,Id>();
        List<Database.SaveResult> nfcInsertResults = Database.insert(nfcCreateList, false);
        for (Integer i = 0; i < nfcInsertResults.size(); i++) {
            if (nfcInsertResults[i].isSuccess()) {
                System.debug('NFC Successfully created ID: ' + nfcInsertResults[i].getId());
                counterVsNfcIdMap.put(i,nfcInsertResults[i].getId());
            } else {
                System.debug('Error: could not create NFC '+ 'for array element ' + i + '.');
                System.debug('The error reported was: '+ nfcInsertResults[i].getErrors()[0].getMessage() + '\n');
            }
        }
        System.debug('counterVsNfcIdMap 93===>>>'+counterVsNfcIdMap);
        if(counterVsNfcIdMap!= null && !counterVsNfcIdMap.isEmpty()){
            List<Case> nfcCaseCreateList = new List<Case>();
            Integer counterChecking=0;
            for(NFC_ResponseFromLegacy.nfc nfcData : nfcObj.meta_data.nfc){
                System.debug('for insert completed loop1 nfcData '+nfcData);
                for(NFC_ResponseFromLegacy.cases casesData : nfcData.cases ){
                    System.debug('for loop2 casesData '+casesData);
                    if(counterVsNfcIdMap!= null && counterVsNfcIdMap.containsKey(counterChecking)){
                        Case caseObj = new Case();
                        caseObj.Case_Type__c = casesData.case_type;
                        //caseObj.Legacy_Case_Id__c = casesData.case_id;
                        caseObj.Status = casesData.case_sts;
                        caseObj.NFC_Case_Date__c = casesData.case_date;
                        caseObj.NFC_Case_Amount__c = Integer.valueOf(casesData.case_amt);
                        caseObj.NFC_Case_Create_Remarks__c = casesData.case_create_rmk;
                        caseObj.NFC_Case_Update_Remarks__c = casesData.case_update_rmk;
                        caseObj.Negative_File_Check__c = counterVsNfcIdMap.get(counterChecking);
                        caseObj.AccountId = accId;
                        caseObj.Subject='Negative File Check';
                        caseObj.Type = 'NFC';
                        nfcCaseCreateList.add(caseObj);
                        
                    }
                }
                counterChecking = counterChecking+1;
            }
            System.debug('nfcCaseCreateList 127===>> '+nfcCaseCreateList);
            
            List<Database.SaveResult> nfcCaseInsertResults = Database.insert(nfcCaseCreateList, false);
            for (Integer i = 0; i < nfcCaseInsertResults.size(); i++) {
                if (nfcCaseInsertResults[i].isSuccess()) {
                    System.debug('NFC Case Successfully created ID: ' + nfcCaseInsertResults[i].getId());
                } else {
                    System.debug('Error: could not create NFC Case '+ 'for array element ' + i + '.');
                    System.debug('The error reported was: '+ nfcCaseInsertResults[i].getErrors()[0].getMessage() + '\n');
                }
            }
        }
        if(updateAccList!= null && !updateAccList.isEmpty()){
            List<Proposal__c> propList = new List<Proposal__c>();
            for(Proposal__c prop :[select id,NFC_Status__c,Last_NFC_Fetched_Date__c from Proposal__c where id=:proposalId]){
                prop.NFC_Status__c =isNfcUnClean?'UnClean':'Clean';
                prop.Last_NFC_Fetched_Date__c = System.now();
                propList.add(prop);
            }
            System.debug('propList : '+propList);
            if(propList!= null && !propList.isEmpty()){
                update propList;
            }
            update updateAccList;
        }
        
        
        SME_RelatedTask.createTask(accId,'Review NFC Results','Legacy Provided the nfc results please verify.','High','Review NFC Results');
        System.debug('Account updated Successfully!!!');
    }

    @future(Callout=true)
    public static void postNfcRequestByTrigger(String cus_no) {
        System.debug('SME_ConsoleHandler postNfcRequestByTrigger :'+cus_no);//372527
        try {
            
            String response = ECIC_CustomerAPI.createNFCRecordAura(cus_no);
            System.debug('postNfcRequestByTrigger response  :'+response);
            System.debug('response :'+response);
            Account accObj = [select id,name,Current_Policy__c,Last_NFC_Retrieved_Date__c,Check_For_NFC__c,
                New_NFC_results_Request_Sent__c,New_NFC_results_Request_Sent_Date__c,
                New_NFC_results_Request_Sent_Legacy_Resp__c 
                from Account where Legacy_Customer_Number__c =:cus_no ];
                
            NFC_ResponseFromLegacy nfcObj=NFC_ResponseFromLegacy.parse(response);
            System.debug('nfcObj Code ====>>>'+nfcObj.rtn_code+' whole :'+nfcObj);
            System.debug('nfcObj Code  meta_data :'+nfcObj.meta_data);
            System.debug('nfcObj Code  meta_data :'+nfcObj.rtn_msgs);
            if(nfcObj.rtn_code.equals('1')){
                System.debug('Request Sent Successfully for NFC.');
                accObj.New_NFC_results_Request_Sent__c = 'Success';
                accObj.New_NFC_results_Request_Sent_Date__c = System.now();
                update accObj;
                System.debug('Account updated successfully.');

            }else{
                System.debug('Failed request for NFC results.');
                accObj.New_NFC_results_Request_Sent__c = 'Failed';
                accObj.New_NFC_results_Request_Sent_Date__c = System.now();
                accObj.New_NFC_results_Request_Sent_Legacy_Resp__c = String.valueOf(nfcObj.rtn_msgs);
                update accObj;
                System.debug('Account updated for failed nfc results request.');
            }
        } catch (Exception ex) {
            System.debug('Exception while calling createNFCRecordAura : '+ex.getMessage()+' Stack : '+ex.getStackTraceString());
        } 
    }
}