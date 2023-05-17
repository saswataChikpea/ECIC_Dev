global class ECIC_CL_BatchSchedule implements Schedulable{
    global void execute(SchedulableContext sc){
        // Implement any logic to be scheduled
       
        // We now call the batch class to be scheduled
        ECIC_CL_API_Methods_CLI_Cancel b = new ECIC_CL_API_Methods_CLI_Cancel();
       
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(b,50);
    }
}