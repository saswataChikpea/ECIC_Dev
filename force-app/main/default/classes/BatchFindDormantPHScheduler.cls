global with sharing class BatchFindDormantPHScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        BatchFindDormantPH BCSBPI = new BatchFindDormantPH();
        ID batchprocessid = Database.executeBatch(BCSBPI,1);   
    }
}