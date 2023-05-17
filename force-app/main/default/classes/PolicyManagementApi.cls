public with sharing class PolicyManagementApi {
    /*@future(callout=true)
    public static void problemPolicyHolder(String recordId,String br_number,String accountID) {
        Map<String, Object> parsedMap = new Map<String, Object>();
        Map<String, Object> parsedInnerMap = new Map<String, Object>();
        String isProblemPH='';
        try {
            //br_number='33333317';
            String response;
            if(!Test.isRunningTest()){
                response = ECIC_API_PolicyMgmt.checkProblemPHCompAura(br_number);
            }else{
                response = '{"rtn_code":"1","rtn_msgs":null,"meta_data":{"result":"Y"}}';
            }
            parsedMap = (Map<String, Object>)JSON.deserializeUntyped(response);
            System.debug('parsedMap : '+parsedMap);
            Object parsedInnerMap_obj = parsedMap.get('meta_data');
            System.debug('parsedInnerMap_obj ==>'+parsedInnerMap_obj);
            String rtn_code = (String)parsedMap.get('rtn_code');
            System.debug('rtn_code ==>'+rtn_code);
            if(rtn_code != null && rtn_code.equals('1')){
               
                parsedInnerMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(parsedInnerMap_obj));
                System.debug('parsedInnerMap ==>'+parsedInnerMap);
                String results = (String) parsedInnerMap.get('result');
                System.debug('rtn_code =>'+rtn_code+' results = '+results);
                List<Account> updateAccDocList = new List<Account>();
                Account accObj = [select id,Is_Problem_Policy_Holder__c from Account where id =:accountID];
                if(results!= null && results.equals('Y')){
                    accObj.Is_Problem_Policy_Holder__c='Yes';
                    updateAccDocList.add(accObj);
                    //Problem_Policyholder_notification_To_SME_team
                    String emailSentMsg=SendEmailApex.sendEmailSME('Problem_Policyholder_notification_To_SME_team', accountID);
                    System.debug('emailSentMsg ==>>'+emailSentMsg);
                    if(emailSentMsg.equals('success')){
                        //Do the after task
                    }
                    //Create Task
                    SME_RelatedTask.createTask(accObj.id, 'Found a Problem Policy Holder', 'This is Problem Policy Holder', 'High', 'Problem Policy Holder');
                }else if(results!= null && results.equals('N')){
                    accObj.Is_Problem_Policy_Holder__c='No';
                    
                    updateAccDocList.add(accObj);
                    //SME_ConsoleHandler.getNFCRecordFromLegacy(accObj.id);
                }
                System.debug('updateAccDocList ===>>'+updateAccDocList);
                if(updateAccDocList != null && !updateAccDocList.isEmpty()){
                    update updateAccDocList;
                    System.debug('Account Ecic Doc is updated.');
                }
            }
        } catch (Exception ex) {
            System.debug('problemPolicyHolder==='+ex.getMessage()+' Stack :'+ex.getStackTraceString());
        }
        //return isProblemPH;
    }*/

    @future(callout=true)
    public static void problemPolicyHolder(String recordId,String br_number,String accountID) {
        Map<String, Object> parsedMap = new Map<String, Object>();
        Map<String, Object> parsedInnerMap = new Map<String, Object>();
        String isProblemPH='';
        try {
            //br_number='33333317';
            String response;
            if(!Test.isRunningTest()){
                response = ECIC_API_PolicyMgmt.checkProblemPHCompAura(br_number);
            }else{
                response = '{"rtn_code":"1","rtn_msgs":null,"meta_data":{"result":"Y"}}';
            }
            parsedMap = (Map<String, Object>)JSON.deserializeUntyped(response);
            System.debug('parsedMap : '+parsedMap);
            Object parsedInnerMap_obj = parsedMap.get('meta_data');
            System.debug('parsedInnerMap_obj ==>'+parsedInnerMap_obj);
            String rtn_code = (String)parsedMap.get('rtn_code');
            System.debug('rtn_code ==>'+rtn_code);
            if(rtn_code != null && rtn_code.equals('1')){
               
                parsedInnerMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(parsedInnerMap_obj));
                System.debug('parsedInnerMap ==>'+parsedInnerMap);
                String results = (String) parsedInnerMap.get('result');
                System.debug('rtn_code =>'+rtn_code+' results = '+results);
                List<Proposal__c> propList =new List<Proposal__c>();
                Account accObj = [select id,name,(select id,name,createdDate,Is_Problem_Policy_Holder__c from Proposals__r order by name desc limit 1) 
                                    from Account where id=:accountId];
                if(accObj!= null){
                    for(Proposal__c prop : accObj.Proposals__r ){
                        System.debug('prop =:'+prop.name);
                        if(results!= null && results.equals('Y')){
                            prop.Is_Problem_Policy_Holder__c='Yes';
                            //Problem_Policyholder_notification_To_SME_team
                            String emailSentMsg=SendEmailApex.sendEmailSME('Problem_Policyholder_notification_To_SME_team', accountID);
                            System.debug('emailSentMsg ==>>'+emailSentMsg);
                            
                            //Create Task
                            SME_RelatedTask.createTask(prop.id, 'Found a Problem Policy Holder', 'This is Problem Policy Holder', 'High', 'Problem Policy Holder');
                        }else if(results!= null && results.equals('N')){
                            prop.Is_Problem_Policy_Holder__c='No';
                        }
                        propList.add(prop);
                    }
                }
                System.debug('propList ===>>'+propList);
                if(propList != null && !propList.isEmpty()){
                    update propList;
                    System.debug('Proposal updated.');
                }
            }
        } catch (Exception ex) {
            System.debug('problemPolicyHolder==='+ex.getMessage()+' Stack :'+ex.getStackTraceString());
        }
        //return isProblemPH;
    }
    public static void updateEcicDocStatus(List<ID> accList){
        System.debug('updateEcicDocStatus accList==>>'+accList);
        List<ECIC_Document__c> ecicDocList = new List<ECIC_Document__c>();
        if(accList!= null && !accList.isEmpty() ){
            for(ECIC_Document__c ecicDoc : [select Status__c 
                from 
                ECIC_Document__c 
                where Account__c in :accList and 
                Status__c != 'Valid' and 
                Document_Type__c='BR Document']){

                    ecicDoc.Status__c='Valid';
                    ecicDocList.add(ecicDoc);
            }
            if(ecicDocList !=null && !ecicDocList.isEmpty()){
                update ecicDocList;
                System.debug('updated status ecicDocList.');
            }
        }
    }
}