global with sharing class BatchForSigningTheDocumentScheduler implements Schedulable {
    global void execute(SchedulableContext sc){
        BatchForSigningTheDocument BFSD = new BatchForSigningTheDocument();
        ID batchprocessid = Database.executeBatch(BFSD,1);   
    }
}