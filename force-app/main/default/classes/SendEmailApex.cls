global class SendEmailApex {
    @InvocableMethod (label='Send Email From Process Buider')
    public static void sendEmailFromProcessBuider(List<SendEmailRequest> emailRequests) {
            for(SendEmailRequest emailRequest: emailRequests){
                try {
                //SendEmailRequest emailRequest = emailRequests[0];
                System.debug('emailRequest accId::'+emailRequest.accId);
                System.debug('templateName::'+emailRequest.templateName);
                System.debug('whatId::'+emailRequest.whatId);
                if(emailRequest.ccSME == null ){
                    emailRequest.ccSME = false;
                }
                if(emailRequest.useFuture != null && emailRequest.useFuture)
                    sendEmailFuture(emailRequest.accId, emailRequest.whatId, 
                    emailRequest.templateName, emailRequest.ccSME,
                    emailRequest.attachmentIds, emailRequest.runtimeAttachmentUrls);
                else
                    sendEmailAccount(emailRequest.accId, emailRequest.whatId, 
                    emailRequest.templateName, emailRequest.ccSME,
                    emailRequest.attachmentIds, emailRequest.runtimeAttachmentUrls);
                } catch (Exception e) {
                    System.debug('Exception Occoured: '+e.getMessage());
                    ExceptionLogger.log(e, emailRequest.templateName);
                }
            }
    }
    global class SendEmailRequest {
        @InvocableVariable(label='accId')
        global ID accId;
    
        @InvocableVariable(label='templateName')
        global String templateName;
    
        @InvocableVariable(label='whatId')
        global ID whatId;

        @InvocableVariable(label='ccSME' required=false)
        global Boolean ccSME;

        // @InvocableVariable(label='onlySME' required=false)
        // global Boolean onlySME;

        // @InvocableVariable(label='hasAttachments' required=false)
        // global Boolean hasAttachments;

        // @InvocableVariable(label='attachmentParentId' required=false)
        // global ID attachmentParentId;
        @InvocableVariable(label='attachmentIds' required=false)
        global String attachmentIds;

        @InvocableVariable(label='runtimeAttachmentUrls' required=false)
        global String runtimeAttachmentUrls;

        @InvocableVariable(label='useFuture' required=false)
        global Boolean useFuture;
        
    }
    
    @AuraEnabled
    public static String sendEmailAccount(Id accId, Id whatId, String templateName,
         Boolean ccSME, String attachmentIds, String runtimeAttachmentUrls) {
        Account account = [Select Id, Name, Language_of_Correspondence__c, (Select Id,Name,Email,Enable_Email_Notification__c from Contacts where Enable_Email_Notification__c = true) from Account where Id = :accId];
        return sendEmailContact(account.contacts, account.Language_of_Correspondence__c, whatId, templateName, ccSME, null, attachmentIds, runtimeAttachmentUrls);
    }

    @AuraEnabled
    public static String sendEmailAccountAditionalCC(Id accId, Id whatId, String templateName,
         Boolean ccSME, List<String> ccAditional, String attachmentIds, String runtimeAttachmentUrls) {
        Account account = [Select Id, Name, Language_of_Correspondence__c, (Select Id,Name,Email,Enable_Email_Notification__c from Contacts where Enable_Email_Notification__c = true) from Account where Id = :accId];
        return sendEmailContact(account.contacts, account.Language_of_Correspondence__c, whatId, templateName, ccSME, ccAditional, attachmentIds, runtimeAttachmentUrls);
    }

    @future(callout=true)
    public static void sendEmailFuture(Id accId, Id whatId, String templateName,
    Boolean ccSME, String attachmentIds, String runtimeAttachmentUrls){   
        Account account = [Select Id, Name, Language_of_Correspondence__c, (Select Id,Name,Email,Enable_Email_Notification__c from Contacts where Enable_Email_Notification__c = true) from Account where Id = :accId];
        sendEmailContact(account.contacts, account.Language_of_Correspondence__c, whatId, templateName, ccSME, null, attachmentIds, runtimeAttachmentUrls);
    }
    public static String sendEmailContact(List<Contact> contacts, String language ,String whatId, String templateName, 
    Boolean ccSME, List<String> ccAditional, String attachmentIds, String runtimeAttachmentUrls) {
        List<EmailTemplate> tmplts = new List<EmailTemplate>();
        EmailTemplate tmplt;
        if(contacts.size() > 0){
            if(language == 'Chinese'){
                String chinese_template = templateName + '_zh_hk';
                tmplts = [Select Id,Name from EmailTemplate where DeveloperName =:chinese_template];
            }
            if(tmplts.size() == 0){
                tmplts = [Select Id,Name from EmailTemplate where DeveloperName =:templateName];
            }
            if(tmplts.size() > 0){
                tmplt = tmplts[0];
            }
            if(tmplt != null){
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

                List<String> ccSMEEmails = new List<String>();
                if(ccSME){
                    //List<user> smeUsers = [select id,Email,profile.name FROM user where profile.name='SME Team Staff'];
                    List<ECIC_Settings__c> smeUsers = [select Id, SME_Email_Id__c from ECIC_Settings__c];
                    // for (User var : smeUsers) {
                    //     ccSMEEmails.add(var.Email);
                    // }
                    for (ECIC_Settings__c var : smeUsers) {
                        if(var.SME_Email_Id__c != null && var.SME_Email_Id__c != '')
                        ccSMEEmails.add(var.SME_Email_Id__c);
                    }
                }
                if(ccAditional!=null){
                    ccSMEEmails.addAll(ccAditional);
                }
                if(ccSMEEmails.size() > 0){
                    emailMessage.setCcAddresses(ccSMEEmails);
                }

                emailMessage.setWhatId(whatId);
                Messaging.EmailFileAttachment[] efas = new List<Messaging.EmailFileAttachment>();
                if(attachmentIds != null){
                    List<ContentVersion> docAttachments = Database.query('SELECT Id, Title, FileExtension, VersionData FROM ContentVersion WHERE IsLatest = true and ContentDocumentId in ('+attachmentIds+')');
                    for(ContentVersion docAttachment :docAttachments){
                        // Take the document content
                        Blob b = docAttachment.VersionData;

                        // Create the email attachment
                        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                        efa.setFileName(docAttachment.Title+'.'+docAttachment.FileExtension);
                        efa.setBody(b);
                        efas.add(efa);
                    } 
                }

                if(runtimeAttachmentUrls != null){
                    Integer counter = 1;
                    for(String pdfUrl: runtimeAttachmentUrls.split(',')){
                        PageReference pdfAttachment = new PageReference(pdfUrl.trim());
                        pdfAttachment.setRedirect(true);
                        // Take the PDF content
                        Blob b = pdfAttachment.getContent();

                        // Create the email attachment
                        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                        efa.setFileName('attachment'+counter+'.pdf');
                        efa.setBody(b);
                        efas.add(efa);
                        counter++;
                    } 
                }
                if(efas.size()>0){
                    emailMessage.setFileAttachments(efas);  
                }
                
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailMessage});
                System.debug('Email Sent Successfully!!');
                return 'success';
            }else{
                return 'Email template not found';
            }
        }else{
            return 'No contact with "Enable Email Notificaton" found';
        }
    }

    public static String sendEmailSME(String templateName, Id whatId) {
        //List<User> smeUsers = [select id,Email,profile.name FROM user where profile.name='SME Team Staff'];
        List<ECIC_Settings__c> smeUsers = [select Id, SME_Email_Id__c from ECIC_Settings__c];
        EmailTemplate tmplt = [Select Id, Name, body, subject from EmailTemplate where DeveloperName =:templateName];
        List<String> toEmails = new List<String>();
        List<Id> toContactIds = new List<Id>();
        // for (User var : smeUsers) {
        //     toEmails.add(var.Email);
        // }
        for (ECIC_Settings__c var : smeUsers) {
            if(var.SME_Email_Id__c != null && var.SME_Email_Id__c != '')
            toEmails.add(var.SME_Email_Id__c);
        }
        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
        emailMessage.setSubject(tmplt.subject);
        emailMessage.setToAddresses(toEmails);
        //emailMessage.setTargetObjectId(toContactIds[0]);
        //emailMessage.setTemplateId(tmplt.Id);
        emailMessage.setHtmlBody(tmplt.body);
        if(whatId != null)
        emailMessage.setWhatId(whatId);
        
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailMessage});
        System.debug('Email Sent Successfully!!');
        return 'success';
        // }else{
        //     return 'No contact with "Enable Email Notificaton" found';
        // }
    }
    // public static void testEmail(){
    //     String documents = '\'0690l000001kp2YAAQ\', \'0690l000001kp7nAAA\'';
    //     System.debug(documents);
    //     Id a = '0010l00001LKJ5sAAH';
    //     Id b = 'a090l000009MjAAAA0';
    //     sendEmailAccount(a, b, 'testCaseMail', false, documents, null);
    // }
}