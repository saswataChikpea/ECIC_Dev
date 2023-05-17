public with sharing class TaskManagement {
    @AuraEnabled
    public static List<Task> getTasks(Id acc_id){
        // try{
            // System.debug('getTasks');
            // System.debug(acc_id);
            // Task tsk = new Task();
            // tsk.Subject = 'Apex task';
            // tsk.Status = 'Open';
            // tsk.Description = 'Task description';
            // tsk.WhatId = acc_id;
            // insert tsk;
            return[Select Id,Subject,Description,Status from Task where WhatId=:acc_id];

        // } catch (Exception e) {
        //     throw new AuraHandledException(e.getMessage());
        // }
    }
    @AuraEnabled
    public static Boolean createTask(String subject,
                                    String description,
                                    String priority,
                                    String type,
                                    String assignedTo,
                                    String relatedID,
                                    String assignToRole){
        System.debug('createTask  '+subject+' assignedTo :'+assignedTo+' relatedID:'+relatedID);
        boolean isTaskCreated = false;
        try {
            Task newTask = new Task();
            newTask.Subject = subject;
            newTask.Description = description;
            newTask.Priority = priority;
            newTask.WhatId = relatedID;
            if (assignToRole != null) {
                newTask.Custom_User_Assigned__c=assignToRole;
            }

            //newTask.Type = type;
            //newTask.OwnerId = UserInfo.getUserId();
            //newTask.ActivityDate = Date.today();//Due Date
            insert newTask;
            isTaskCreated = true;
            System.debug('Task Created Succes fully for SME Team');
        } catch (Exception e) {
            System.debug('Exception at createTask :'+e.getMessage()+' Stack '+e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
        return isTaskCreated;
    }

    public static void crateOutStandingJob(String subject,
                                        String description,
                                        String priority,
                                        String relatedID,
                                        String type,
                                        String assignedTo,
                                        String assignToRole){
        System.debug('crateOutStandingJob  '+subject+' assignedTo :'+assignedTo+' relatedID:'+relatedID);
        Task newTask = new Task();
        newTask.Subject = subject;
        newTask.Description = description;
        newTask.Priority = priority;
        newTask.WhatId = relatedID;
        newTask.Custom_User_Assigned__c=assignedTo;
        newTask.Type = type;
        insert newTask;
    }
}