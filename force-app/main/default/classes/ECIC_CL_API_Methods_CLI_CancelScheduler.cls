global with sharing class ECIC_CL_API_Methods_CLI_CancelScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        ECIC_CL_API_Methods_CLI_Cancel BCSBPI = new ECIC_CL_API_Methods_CLI_Cancel();
        ID batchprocessid = Database.executeBatch(BCSBPI,3);   
    }
}