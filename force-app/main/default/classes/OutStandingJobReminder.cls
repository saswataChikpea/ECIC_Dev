public with sharing class OutStandingJobReminder {
    public static void sendEmailToSme() {
        
        List<Task> taskList = [select id,CreatedDate from Task where  Is_Today_is_4th_Day_of_Task__c=true and X3rd_Day_Email_Reminder_Sent__c= false];
        System.debug('taskList ==>>'+taskList);
        if(taskList!= null && !taskList.isEmpty()){
           
            //Send email function
            String response=SendEmailApex.sendEmailSME('Outstanding_Task_Reminder', null);
            System.debug('response===>>'+response);
            if(response.equals('success')){
                List<Task> updateTaskList = new List<Task>();
                for(Task tt : taskList){
                    tt.X3rd_Day_Email_Reminder_Sent__c = true;
                    updateTaskList.add(tt);
                }
                System.debug('updateTaskList==>>'+updateTaskList);
                if(updateTaskList!= null && !updateTaskList.isEmpty()){
                    update updateTaskList;
                    System.debug('Task Updated Successfully!!!');
                }
            }
        }
    }
}