global class SendEmailController {
    @InvocableMethod (label='Send Templated Email')
    public static void getAccountDetails(List<SendEmailRequest> emailRequest) {
        try {
            System.debug('emailRequest accId::'+emailRequest[0].accId);
            System.debug('templateName::'+emailRequest[0].templateName);
            System.debug('whatId::'+emailRequest[0].whatId);
            // List<Contact> contactDetails;
            // List<String> emailList = new List<String>();
            // List<String> contactList = new List<String>();
            // List<String> results = new List<String>();
            // String contactEmailIds;
            // String contactId;
            // contactDetails = [Select Id,Name,Email,Enable_Email_Notification__c from Contact where Enable_Email_Notification__c = true AND AccountId in :AccountIds];
            // for (Contact var : contactDetails) {
            //     contactEmailIds = var.Email;
            //     contactId = var.Id;
            //     emailList.add(contactEmailIds);
            //     contactList.add(contactId);
            // }
            // System.debug('Email List::'+emailList);
            // if (emailList != null && !emailList.isEmpty()) {
            //     results = sendTemplatedEmail(emailList,contactList,AccountIds);
            // }
        } catch (Exception e) {
            System.debug('Exception Occoured: '+e.getMessage());
        }
    }
    public static List<String> sendTemplatedEmail(List<String> emailList, List<String> contactList, List<String> AccountIds) {
        try {
            System.debug('Email List::'+emailList);
            System.debug('Contact List::'+contactList);
            String templateApiName = 'NotificationOnAmendment_P021';
            //Id whatId = '';
            EmailTemplate et;
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            et = [Select Id,Name from EmailTemplate where DeveloperName =:templateApiName];
            email.setToAddresses(emailList);
            email.setTargetObjectId(contactList[0]);
            //email.setWhatId(whatId);
            email.setTemplateId(et.Id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            System.debug('Email Sent Successfully!!');
        } catch (Exception e) {
            System.debug('The email failed to send:  '+e.getMessage());
        }
        return emailList;
    }
    // public static void getTemplateApiNameAndWhatId(String templateApiName,String customObjectName) {
    //     try {
    //         // String templateApiName;
    //         // String customObjectName;
    //         String templateDescription;
    //         // List<String> emailTemplateDesList = new List<String>();
    //         for (EmailTemplate var : [Select Id,Description from EmailTemplate where Description LIKE 'U%' order by Id]) {
    //             templateDescription = var.Description;
    //         }

    //         // System.debug('emailTemplateDesList::'+emailTemplateDesList);
    //         // for (String var : emailTemplateDesList) {
    //         //     templateDescription = var.Description;
    //         // }
    //         if (templateDescription == 'U001') {
    //             templateApiName = 'Credit_Limit_Approved_OMBP';
    //             customObjectName = 'Credit_Limit__c';
    //         }
            
    //     } catch (Exception e) {
    //         System.debug('Exception Occoured: '+e.getMessage());
    //     }
    // }

    public static void sendEmailAccount(Id accId, String whatId, String templateName, Boolean ccSME) {
        List<Contact> contacts = [Select Id,Name,Email,Enable_Email_Notification__c from Contact where Enable_Email_Notification__c = true AND AccountId = :accId];
        sendEmailContact(contacts, whatId, templateName, ccSME);
    }
    public static void sendEmailContact(List<Contact> contacts, String whatId, String templateName, Boolean ccSME) {

        EmailTemplate tmplt = [Select Id,Name from EmailTemplate where DeveloperName =:templateName];

        List<String> toEmails = new List<String>();
        List<Id> toContactIds = new List<Id>();
        for (Contact var : contacts) {
            toEmails.add(var.Email);
            toContactIds.add(var.Id);
        }

        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
        emailMessage.setToAddresses(toEmails);
        emailMessage.setTargetObjectId(toContactIds[0]);
        emailMessage.setTemplateId(tmplt.Id);

        emailMessage.setWhatId(whatId);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailMessage});
        System.debug('Email Sent Successfully!!');
    }


    global class SendEmailRequest {
        @InvocableVariable(label='accId')
        global ID accId;
    
        @InvocableVariable(label='templateName')
        global String templateName;
    
        @InvocableVariable(label='whatId')
        global ID whatId;
      }
}