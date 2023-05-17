global with sharing class BatchInitiateSigningOfTheDocScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        BatchInitiateSigningOfTheDocument BOSJR = new BatchInitiateSigningOfTheDocument();
        ID batchprocessid = Database.executeBatch(BOSJR,1);   
    }
}