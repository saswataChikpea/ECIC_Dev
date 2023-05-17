global with sharing class BatchResetMaximumLiabilityScheduler implements Schedulable {
    global void execute(SchedulableContext sc){
        BatchResetMaximumLiability BCSBPI = new BatchResetMaximumLiability();
        ID batchprocessid = Database.executeBatch(BCSBPI,1);   
    }
}