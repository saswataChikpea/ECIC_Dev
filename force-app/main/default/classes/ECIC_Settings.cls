public with sharing class ECIC_Settings {
    @AuraEnabled
    public static ECIC_Settings__c getEcicSettings(){
        ECIC_Settings__c ecicSettings;
        try {
            ecicSettings = [Select id,Batch_To_Schedule__c,Time_To_Schedule_SBP_Invoice_Batch__c,
            Time_To_Schedule_Task_Remider_Email__c,Time_To_Schedule_BR_Reminder_Batch__c,Charge_Deposit__c,
            Time_To_Schedule_NFC_Checking_Batch__c,Time_To_Schedule_Policy_Document_Signed__c,
            Time_To_Schedule_Dormant_PH_Batch__c,Period_of_Inactivity__c,Time_To_Schedule_CLI_Cancel_Batch__c,
            Time_To_Schedule_Deactivate_Account__c,Time_To_Schedule_Expire_CL__c, Time_To_Schdule_Create_Quotation_Job__c
             from ECIC_Settings__c limit 1];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        System.debug('ecicSettings : '+ecicSettings);
        return ecicSettings;
    }

    public static string getAccountUserName(String accountID){
        System.debug('getAccountUserName called.');
        String userName;
        List<User> userList = [select id, name,Username from user where contact.AccountId=:accountID];
        System.debug('userList : '+userList);
        if(userList!= null && !userList.isEmpty()){
            userName=userList[0].Username.split('@')[0];
        }
        System.debug('userName ====>>'+userName);
        return userName;
    }

}