public without sharing class SendContactCreateEmailToSME {
    public SendContactCreateEmailToSME() {

    }
    @InvocableMethod (label='Send Contact Email To SME From Process Builder')
    public static void sendEmailSME(List<Id> whatId){
        // SendEmailApex.sendEmailSME(template, Id);
        try{
        List<ECIC_Settings__c> smeUsers = [select id,SME_Email_Id__c FROM ECIC_Settings__c LIMIT 1];
        System.debug('smeUsers in sendEmail class='+smeUsers);
        EmailTemplate tmplt = [Select Id, Name, body, subject from EmailTemplate where DeveloperName ='Contact_Person_Updated'];
        Contact cont = [SELECT AccountId FROM Contact WHERE Id = :whatId[0]];
        System.debug('accountid='+cont.AccountId);
        List<String> toEmails = new List<String>();
        List<Id> toContactIds = new List<Id>();
        System.debug('ToEmailAddress='+smeUsers[0].sme_email_id__c);
        toEmails.add(smeUsers[0].sme_email_id__c);   

        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
        emailMessage.setSubject(tmplt.subject);
        // emailMessage.setSubject('Contact Added');
        emailMessage.setToAddresses(toEmails);
        emailMessage.setTargetObjectId(whatId[0]);
        emailMessage.setTemplateId(tmplt.Id);
        emailMessage.setHtmlBody(tmplt.body);
        if(whatId != null)
        emailMessage.setWhatId(cont.AccountId);
        
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailMessage});
        System.debug('Email Sent Successfully!!');
        } catch(Exception e) {
            System.debug('Exception sendEmailSME='+e.getMessage());
            ExceptionLogger.log(e, 'SendContactCreateEmailToSME');
        }
        // return 'success';
    }
}