global with sharing class BatchCreateSBPInvoiceScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        BatchCreateSBPInvoice BCSBPI = new BatchCreateSBPInvoice();
        ID batchprocessid = Database.executeBatch(BCSBPI,1);   
    }
}