global with sharing class BatchBR_ReminderScheduler implements Schedulable {
        global void execute(SchedulableContext sc){
            BatchBR_Reminder BBRR = new BatchBR_Reminder();
            ID batchprocessid = Database.executeBatch(BBRR,1);   
        }
    }