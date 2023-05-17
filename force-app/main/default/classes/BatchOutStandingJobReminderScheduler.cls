global with sharing class BatchOutStandingJobReminderScheduler implements Schedulable {
    global void execute(SchedulableContext sc){
        BatchOutStandingJobReminder BOSJR = new BatchOutStandingJobReminder();
        ID batchprocessid = Database.executeBatch(BOSJR,1);   
    }
}