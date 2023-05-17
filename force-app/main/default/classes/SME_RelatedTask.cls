public with sharing class SME_RelatedTask {
    public static void createTask(String accountID,String subject, String dec, string priority,String type){
        List<user> smeUsers = [select id,Email,profile.name FROM user where profile.name='SME Team Staff'];
        try {
            Task newTask = new Task();
            newTask.Subject = subject;
            newTask.Description = dec;
            newTask.Priority = priority;
            newTask.WhatId = accountID;
            if (smeUsers != null && !smeUsers.isEmpty()) {
                newTask.OwnerId=smeUsers[0].id;
            }

            newTask.Type = type;
            insert newTask;
            System.debug('Task Created Succes fully for SME Team');
        } catch (Exception e) {
            System.debug('Exception at createTask :'+e.getMessage()+' Stack '+e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }
}