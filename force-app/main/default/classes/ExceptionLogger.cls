/*-----------------------------------------------
    Desc : class for logging the exceptions
    created by : sayantan@chikpea.com
    created date 28-Sep-2021
------------------------------------------------*/
global with sharing class ExceptionLogger {
    
    global static String log(Exception e, String tag){
        String errorMsg = 'Exception ==> '+e.getMessage();
        errorMsg += ' ==> line number ==> '+String.valueOf(e.getLineNumber());
        errorMsg += ' ==> stack trace ==> '+String.valueOf(e.getStackTraceString());
        errorMsg += ' ==> type name ==> '+String.valueOf(e.getTypeName());
        errorMsg += ' ==> cause ==> '+String.valueOf(e.getCause());
        Error_Log__c el = new Error_Log__c();
        el.Details__c = errorMsg;
        el.Tag__c = tag;
        insert el;
        return 'success';
    }

    @AuraEnabled(Cacheable=false)
    global static String auraLog(String e, String tag){
        Error_Log__c el = new Error_Log__c();
        el.Details__c = e;
        el.Tag__c = tag;
        insert el;
        return 'success';
    }
    global static String email(Exception e){
        List<User> smeUsers = [select id,Email,profile.name FROM user where profile.name='SME Team Staff'];
        //EmailTemplate tmplt = [Select Id, Name, body, subject from EmailTemplate where DeveloperName = ''];

        String errorMsg = 'Exception: '+e.getMessage();
        errorMsg += '<br>Line number: '+String.valueOf(e.getLineNumber());
        errorMsg += '<br>Stack trace: '+String.valueOf(e.getStackTraceString());
        errorMsg += '<br>Type name: '+String.valueOf(e.getTypeName());
        errorMsg += '<br>Cause: '+String.valueOf(e.getCause());

        List<String> toEmails = new List<String>();
        List<Id> toContactIds = new List<Id>();
        for (User var : smeUsers) {
            toEmails.add(var.Email);
        }

        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
        emailMessage.setSubject('Developer script exception from EC-Reach');
        emailMessage.setToAddresses(toEmails);
        emailMessage.setHtmlBody(errorMsg);
        
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailMessage});
        System.debug('Email Sent Successfully!!');
        return 'success';
    }
    @AuraEnabled
    global static String auraEmail(String msg){
        List<User> smeUsers = [select id,Email,profile.name FROM user where profile.name='SME Team Staff'];
        //EmailTemplate tmplt = [Select Id, Name, body, subject from EmailTemplate where DeveloperName = ''];

        String errorMsg = msg;

        List<String> toEmails = new List<String>();
        List<Id> toContactIds = new List<Id>();
        for (User var : smeUsers) {
            toEmails.add(var.Email);
        }

        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
        emailMessage.setSubject('Developer script exception from EC-Reach');
        emailMessage.setToAddresses(toEmails);
        emailMessage.setHtmlBody(errorMsg);
        
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailMessage});
        System.debug('Email Sent Successfully!!');
        return 'success';
    }
    global static String emailAccount(Exception e, Id accId){
        
        List<Contact> contacts = [Select Id,Name,Email,Enable_Email_Notification__c from Contact where Enable_Email_Notification__c = true AND AccountId = :accId];
        List<User> smeUsers = [select id,Email,profile.name FROM user where profile.name='SME Team Staff'];
        
        List<String> toEmails = new List<String>();
        List<Id> toContactIds = new List<Id>();
        for (Contact var : contacts) {
            toEmails.add(var.Email);
            toContactIds.add(var.Id);
        }
        //toEmails.add('mehebub@chikpea.com');

        String errorMsg = 'Exception: '+e.getMessage();
        errorMsg += '<br>Line number: '+String.valueOf(e.getLineNumber());
        errorMsg += '<br>Stack trace: '+String.valueOf(e.getStackTraceString());
        errorMsg += '<br>Type name: '+String.valueOf(e.getTypeName());
        errorMsg += '<br>Cause: '+String.valueOf(e.getCause());

        List<String> ccEmails = new List<String>();
        for (User var : smeUsers) {
            ccEmails.add(var.Email);
        }

        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
        emailMessage.setSubject('Developer script exception from EC-Reach');
        emailMessage.setToAddresses(toEmails);
        emailMessage.setCcAddresses(ccEmails);
        emailMessage.setHtmlBody(errorMsg);
        
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailMessage});
        System.debug('Email Sent Successfully!!');
        return 'success';
    }
}