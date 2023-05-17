global with sharing class BatchDeactivateAccountSchedule implements Schedulable{
    global void execute(SchedulableContext sc){
        BatchDeactivateLimitedAccessAccount BCSBPI = new BatchDeactivateLimitedAccessAccount();
        ID batchprocessid = Database.executeBatch(BCSBPI,3);   
    }
}