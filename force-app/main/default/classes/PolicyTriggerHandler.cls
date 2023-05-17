public with sharing class PolicyTriggerHandler {

    public static void checkEachTask(List<Policy__c> polList,Map<Id, Policy__c> oldValuesMap){
        //Check List 
        //1. Maximum Liabilty
        boolean isCheckingMaximuLiabilty;
        boolean initiateNfcReq=false;
        boolean threeMonthBeforeExpDate=false;
        boolean twoMonthBeforeExpDate=false;
        boolean isAllowedToCreateTaskAtTwoMonth=false;
        List<ID> accIdList = new List<ID>();
        Map<ID,String> accIdVsNfcStatusMap = new Map<Id,String>();
        String accountId;
        System.debug('checking maximumLiability annivarsary date !!!');
        for (Policy__c pol : polList) {
            // Access the "old" record by its ID in Trigger.oldMap
            Policy__c oldPolicy = oldValuesMap.get(pol.Id);
            boolean isOldMLChnagedFromZeroToNonZero = (oldPolicy.Maximum_Liability__c == 0 && pol.Maximum_Liability__c > 0 ) ? true : false;
            System.debug('isOldMLChnagedFromZeroToNonZero : '+isOldMLChnagedFromZeroToNonZero);
            if(isOldMLChnagedFromZeroToNonZero){
                pol.ML_Changed_to_Non_Zero_Amount__c = System.now();
            }else{
                isCheckingMaximuLiabilty=false;
            }
            System.debug('Five month Check old='+oldPolicy.Is_Five_Month_Left_For_Expiry__c+' New='+pol.Is_Five_Month_Left_For_Expiry__c);
            if(!oldPolicy.Is_Five_Month_Left_For_Expiry__c && pol.Is_Five_Month_Left_For_Expiry__c){
                initiateNfcReq=true;
            }
            if(!oldPolicy.Is_Three_Month_Left_For_Expiry__c && pol.Is_Three_Month_Left_For_Expiry__c){
                threeMonthBeforeExpDate=true;
                System.debug('NFC status at acc level : '+pol.Exporter__c);
                accIdList.add(pol.Exporter__c);
            }
            if(!oldPolicy.Is_Two_Month_Left_For_Expiry__c && pol.Is_Two_Month_Left_For_Expiry__c){
                if(pol.AML_Check__c!=null && pol.AML_Check__c.equals('Approved') && 
                   pol.NFC_Check__c!=null && pol.NFC_Check__c.equals('Approved')){
                    twoMonthBeforeExpDate=true;
                }
            }
            if(!oldPolicy.Status__c.equals('Invalid') && pol.Status__c.equals('Invalid')){
                pol.Is_Active__c=false;
                TaskManagement.crateOutStandingJob(
                        'Policy Terminated', 
                        'SME team head to acknowledge the policy termination.', 
                        'High', 
                         pol.id,
                        'Policy Terminated By SME', 
                        'SME Head',
                        null);
            }
            accountId = pol.Exporter__c;
            //Check both AML & NFC
            System.debug('AML==>>:Old='+oldPolicy.AML_Check__c+'>>New='+pol.AML_Check__c+'====>>> NFC=>Old='+oldPolicy.NFC_Check__c+'>New='+pol.NFC_Check__c);
            if(pol.AML_Check__c!=null && pol.AML_Check__c.equals('Approved') && 
               pol.NFC_Check__c!=null && pol.NFC_Check__c.equals('Approved')){

                if((oldPolicy.AML_Check__c ==null || !oldPolicy.AML_Check__c.equals('Approved')) || 
                   (oldPolicy.NFC_Check__c ==null || !oldPolicy.NFC_Check__c.equals('Approved'))){
                    //isAllowedToCreateTaskAtTwoMonth = true;
                    //check Any open task for endorsement or policy term
                    System.debug('proceed');
                    List<Task> taskList = [select id from Task where Type='Endorsement'];
                    System.debug('taskList : '+taskList);
                    if(taskList!=null && !taskList.isEmpty()){
                        //Create Task for SME to complete all the pending task related to enodorsement or poliy term
                        String taskId;
                        Integer counter=0;
                        for(Task tt : taskList){
                            if(counter ==0){
                                taskId = tt.id;
                            }else{
                                taskId = taskId +','+ tt.id;
                            }
                            counter = counter+1;
                        }
                        TaskManagement.crateOutStandingJob(
                            'Please Check all the Pending Task Related to Endorsement or Policy Term', 
                            'Please Check '+taskId, 
                            'High', 
                             pol.id,
                            'Endorsement Or Polcy Term', 
                            'SME Team',
                            null);
                    }
                }
            }
        }
        if(accIdList!=null && !accIdList.isEmpty()){
            for(Account acc : [select id,NFC_Results__c from Account where id in : accIdList and NFC_Results__c!=null  ] ){
                
                accIdVsNfcStatusMap.put(acc.id,acc.NFC_Results__c);
            }
        }
        System.debug('initiateNfcReq : '+initiateNfcReq+' threeMonthBeforeExpDate :'+threeMonthBeforeExpDate+' isCheckingMaximuLiabilty:'+isCheckingMaximuLiabilty+' twoMonthBeforeExpDate :'+twoMonthBeforeExpDate+' isAllowedToCreateTaskAtTwoMonth:'+isAllowedToCreateTaskAtTwoMonth);
        if(initiateNfcReq){
            sendReqToLegacyForNFC(polList);
        }
        if(threeMonthBeforeExpDate){
            System.debug('Check NFC Status : '+accIdVsNfcStatusMap);
            if(accIdVsNfcStatusMap!=null && accIdVsNfcStatusMap.containsKey(accountId)){
                if(accIdVsNfcStatusMap.get(accountId).equals('Un Clean')){
                    //Create OutStanding job
                    TaskManagement.crateOutStandingJob(
                        'Review NFC Results For Policy Renewal', 
                        'Unclean nfc checking since three month left for policy expiry date.', 
                        'High', 
                         polList[0].id, 
                        'Review Un Clean NFC Results For Policy Renewal', 
                        'SME Staff', 
                        null);
                    TaskManagement.crateOutStandingJob(
                        'Please do the AML Checking For Policy Renewal', 
                        'Please do the AML Checking since three month left for policy expiry date.', 
                        'High', 
                         polList[0].id, 
                        'AML Checking For Policy Renewal', 
                        'SME Staff', 
                        null);
                }
            }
        }
        if(twoMonthBeforeExpDate){
            TaskManagement.crateOutStandingJob(
                        'Give Premium Rebate to policy holder', 
                        'SME team to decide whether to give the policyholder a premium rebate after the end of the next policy year.', 
                        'High', 
                        'Premium Rebate', 
                        'SME Staff', 
                        polList[0].id, 
                        null);
        }
    }

    public static void inActivatePreviousPolicies(List<Policy__c> polList){
        String acc_id;
        for (Policy__c pol : polList) {
            acc_id = pol.Exporter__c;
        }
        System.debug('acc_id : '+acc_id);
        if(!acc_id.equals('')){
            List<Policy__c> oldPolicyList = [select id,Status__c from Policy__c where Exporter__c =:acc_id  ];//and Status__c='Valid' 
            List<Policy__c> upPolicyList = new List<Policy__c>();
            if(oldPolicyList != null && !oldPolicyList.isEmpty()){
                System.debug('Found Old Policy Status');
                for (Policy__c pol : oldPolicyList) {
                    pol.Status__c = 'Expired';
                    upPolicyList.add(pol);
                }
                if(upPolicyList != null && !upPolicyList.isEmpty()){
                    update upPolicyList;
                    System.debug('Old Policy Status Expired');
                }
            }
        }
    }

    public static void sendReqToLegacyForNFC(List<Policy__c> polList){
        //check for nfc api 4.7
        System.debug('Trigger Legacy_Customer_Number__c : '+polList[0].Legacy_Customer_Number__c);
        SME_ConsoleHandler.postNfcRequestByTrigger(polList[0].Legacy_Customer_Number__c);
    }
}