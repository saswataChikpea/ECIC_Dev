global with sharing class BatchApiNFC_CheckScheduler implements Schedulable {
    global void execute(SchedulableContext sc){
        BatchApiNFC_Check BANFC = new BatchApiNFC_Check();
        ID batchprocessid = Database.executeBatch(BANFC,1);   
    }
}