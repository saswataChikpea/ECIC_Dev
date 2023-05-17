public with sharing class BatchHandleOutstandingApplicationHandler implements Database.AllowsCallouts {
    public BatchHandleOutstandingApplicationHandler() {

    }

    public static void handleOutstandingProposal(List<Proposal__c> propList){
        System.debug('handleOutstandingProposal: propList::'+propList);

        ECIC_Settings__c settings=[select Id, Outstanding_Proposal_Reminder_Prospect__c,
        Outstanding_Proposal_Reminder_SME__c from Ecic_Settings__c];
        System.debug('settings::'+settings);

        Integer prospectReminderDayCount= Integer.valueOf(settings.Outstanding_Proposal_Reminder_Prospect__c);
        Integer SMEReminderDayCount= Integer.valueOf(settings.Outstanding_Proposal_Reminder_SME__c);

        List<Proposal__c> updatePropList = new List<Proposal__c>();
        for (Proposal__c prop : propList) {
            Date startDate= Date.valueOf(prop.createdDate);
            if ( prop.Under_Processing_Notification_Sent__c!= true && startDate.daysBetween(Date.today()) > prospectReminderDayCount) {
                SendEmailApex.sendEmailSME('Application_Under_Processing_Reminder', prop.Id);
                prop.Under_Processing_Notification_Sent__c= true;
                updatePropList.add(prop);
            }
            if ( prop.Policy_Application_SME_Reminder_Sent__c!= true && startDate.daysBetween(Date.today()) > SMEReminderDayCount) {
                SendEmailApex.sendEmailSME('Policy_Application_Reminder', prop.Id);
                prop.Under_Processing_Notification_Sent__c= true;
                updatePropList.add(prop);
            }
        }
        if (updatePropList.size()>0) {
            update updatePropList;
        }

    }


    
    
    // Under_Processing_Notification_Sent__c
    //Policy_Application_SME_Reminder_Sent__c
    // Policy_Application_Reminder //template 
}