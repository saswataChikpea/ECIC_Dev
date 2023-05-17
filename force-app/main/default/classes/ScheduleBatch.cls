public with sharing class ScheduleBatch {
    
    @AuraEnabled
    public static ResponseData shceduleBatchConditionally(String isBatch){
        System.debug('ScheduleBatch shceduleBatchConditionally called'); 
      
        ResponseData respData= new ResponseData();
        ECIC_Settings__c ecicSettings = ECIC_Settings.getEcicSettings();
        System.debug('ScheduleBatch ecicSettings : '+ecicSettings);
        if(ecicSettings.Batch_To_Schedule__c.equals('Create SBP Invoice')){
            deleteJob('Create SBP Invoice');
            System.debug(ecicSettings.Batch_To_Schedule__c+' Called');
            try {
                BatchCreateSBPInvoiceRunScheduler.executeschedule();
                respData.isSuccess=true;
                respData.responseMsg = ecicSettings.Batch_To_Schedule__c+' Batch Scheduled Succesffully.';
            }catch(Exception e){
                System.debug('Exception At Executing shceduleBatchConditionally :'+e.getMessage()+' Stack:'+e.getStackTraceString());
                respData.isSuccess=false;
                respData.responseMsg = ecicSettings.Batch_To_Schedule__c+' Batch Scheduled Failed : '+e.getMessage();
            }
        }else if(ecicSettings.Batch_To_Schedule__c.equals('Change Payment Reminder Date')){
            System.debug(ecicSettings.Batch_To_Schedule__c+' Called');
            deleteJob('Change Payment Reminder Date');
            try {
                BatchSetPaymentReminder batch = new BatchSetPaymentReminder();
                ID batchprocessid = Database.executeBatch(batch); 
                System.debug('ScheduleBatch shcedulePaymentReminder :'+batchprocessid);
                respData.isSuccess=true;
                respData.responseMsg = ecicSettings.Batch_To_Schedule__c+' Batch Scheduled Succesffully.';
            } catch (Exception e) {
                System.debug('Exception At Executing shceduleBatchConditionally :'+e.getMessage()+' Stack:'+e.getStackTraceString());
                respData.isSuccess=false;
                respData.responseMsg = ecicSettings.Batch_To_Schedule__c+' Batch Scheduled Failed : '+e.getMessage();
            }
        }else if(ecicSettings.Batch_To_Schedule__c.equals('Reset Maximum Liability')){
            System.debug(ecicSettings.Batch_To_Schedule__c+' Called');
            deleteJob('Reset Maximum Liability');
            try {
                BatchResetMaximumLiabilityScheduler BRMLS = new BatchResetMaximumLiabilityScheduler();
                //ID batchprocessid = Database.executeBatch(BRML,1);
                String minute='00';String hour='10';String day='*';String month='*';String year='*';
                String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
                System.schedule(ecicSettings.Batch_To_Schedule__c,strSchedule, BRMLS); 
                respData.isSuccess=true;
                respData.responseMsg = ecicSettings.Batch_To_Schedule__c+' Batch Scheduled Succesffully.'; 
            } catch(Exception e) {
                System.debug('Exception At Executing shceduleBatchConditionally :'+e.getMessage()+' Stack:'+e.getStackTraceString());
                respData.isSuccess=false;
                respData.responseMsg = ecicSettings.Batch_To_Schedule__c+' Batch Scheduled Failed : '+e.getMessage();
            }
        }else if(ecicSettings.Batch_To_Schedule__c.equals('Three Days older Task Reminder')){
            System.debug(ecicSettings.Batch_To_Schedule__c+' Called');
            deleteJob('Three Days older Task Reminder');
            try {
                BatchOutStandingJobReminderScheduler BOSJRS = new BatchOutStandingJobReminderScheduler();
                //ID batchprocessid = Database.executeBatch(BRML,1);
                DateTime dt = ecicSettings.Time_To_Schedule_Task_Remider_Email__c;
                String minute=String.valueOf(dt.minute());
                String hour=String.valueOf(dt.hour());
                String day='*';//dt.day();
                String month='*';//dt.month(); 0 0 13 * * ?
                String year=String.valueOf(dt.year());
                //String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?';
                String strSchedule='0 '+minute.trim()+' '+hour.trim()+' * * ?';
                System.schedule(ecicSettings.Batch_To_Schedule__c,strSchedule, BOSJRS); 
                respData.isSuccess=true;
                respData.responseMsg = ecicSettings.Batch_To_Schedule__c+' Batch Scheduled Succesffully.'; 
            } catch(Exception e) {
                System.debug('Exception At Executing shceduleBatchConditionally :'+e.getMessage()+' Stack:'+e.getStackTraceString());
                respData.isSuccess=false;
                respData.responseMsg = ecicSettings.Batch_To_Schedule__c+' Batch Scheduled Failed : '+e.getMessage();
            }
        }else if(ecicSettings.Batch_To_Schedule__c.equals('BR Reminder')){
            System.debug(ecicSettings.Batch_To_Schedule__c+' Called');
            deleteJob('BR Reminder');
            try {
                BatchBR_ReminderScheduler BBRRS = new BatchBR_ReminderScheduler();
                //ID batchprocessid = Database.executeBatch(BRML,1);
                DateTime dt = ecicSettings.Time_To_Schedule_Task_Remider_Email__c;
                String minute=String.valueOf(dt.minute());
                String hour=String.valueOf(dt.hour());
                String day='*';//dt.day();
                String month='*';//dt.month(); 0 0 13 * * ?
                String year=String.valueOf(dt.year());
                //String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?';
                String strSchedule='0 '+minute.trim()+' '+hour.trim()+' * * ?';
                System.schedule(ecicSettings.Batch_To_Schedule__c,strSchedule, BBRRS); 
                respData.isSuccess=true;
                respData.responseMsg = ecicSettings.Batch_To_Schedule__c+' Batch Scheduled Succesffully.'; 
            } catch(Exception e) {
                System.debug('Exception At Executing shceduleBatchConditionally :'+e.getMessage()+' Stack:'+e.getStackTraceString());
                respData.isSuccess=false;
                respData.responseMsg = ecicSettings.Batch_To_Schedule__c+' Batch Scheduled Failed : '+e.getMessage();
            }
        }else if(ecicSettings.Batch_To_Schedule__c.equals('Daily Check For NFC Results')){
            System.debug(ecicSettings.Batch_To_Schedule__c+' Called');
            deleteJob('Daily Check For NFC Results');
            
            try {
                BatchApiNFC_CheckScheduler BAPINFC = new BatchApiNFC_CheckScheduler();
                //ID batchprocessid = Database.executeBatch(BRML,1);
                DateTime dt = ecicSettings.Time_To_Schedule_NFC_Checking_Batch__c;
                String minute=String.valueOf(dt.minute());
                String hour=String.valueOf(dt.hour());
                String day='*';//dt.day();
                String month='*';//dt.month(); 0 0 13 * * ?
                String year=String.valueOf(dt.year());
                String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?';
                //String strSchedule='0 0 * * * ?';//'0 '+minute.trim()+' '+hour.trim()+' * * ?';
                System.schedule(ecicSettings.Batch_To_Schedule__c,strSchedule, BAPINFC); 
                respData.isSuccess=true;
                respData.responseMsg = ecicSettings.Batch_To_Schedule__c+' Batch Scheduled Succesffully.'; 
            } catch(Exception e) {
                System.debug('Exception At Executing shceduleBatchConditionally :'+e.getMessage()+' Stack:'+e.getStackTraceString());
                respData.isSuccess=false;
                respData.responseMsg = ecicSettings.Batch_To_Schedule__c+' Batch Scheduled Failed : '+e.getMessage();
            }
        }else if(ecicSettings.Batch_To_Schedule__c.equals('Signed Policy Document')){
            System.debug(ecicSettings.Batch_To_Schedule__c+' Called');
            deleteJob('Signed Policy Document');
            
            try {
                BatchInitiateSigningOfTheDocScheduler BFSDS = new BatchInitiateSigningOfTheDocScheduler();
                //ID batchprocessid = Database.executeBatch(BRML,1);
                DateTime dt = ecicSettings.Time_To_Schedule_Policy_Document_Signed__c;
                String minute=String.valueOf(dt.minute());
                String hour=String.valueOf(dt.hour());
                String day='*';//dt.day();
                String month='*';//dt.month(); 0 0 13 * * ?
                String year=String.valueOf(dt.year());
                String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?';
                //String strSchedule='0 0 * * * ?';//'0 '+minute.trim()+' '+hour.trim()+' * * ?';
                System.schedule(ecicSettings.Batch_To_Schedule__c,strSchedule, BFSDS); 
                respData.isSuccess=true;
                respData.responseMsg = ecicSettings.Batch_To_Schedule__c+' Batch Scheduled Succesffully.'; 
            } catch(Exception e) {
                System.debug('Exception At Executing shceduleBatchConditionally :'+e.getMessage()+' Stack:'+e.getStackTraceString());
                respData.isSuccess=false;
                respData.responseMsg = ecicSettings.Batch_To_Schedule__c+' Batch Scheduled Failed : '+e.getMessage();
            }
        }else if(ecicSettings.Batch_To_Schedule__c.equals('Find Dormant Policy Holder')){
            System.debug(ecicSettings.Batch_To_Schedule__c+' Called');
            deleteJob('Find Dormant Policy Holder');
            
            try {
                BatchFindDormantPHScheduler BFSDS = new BatchFindDormantPHScheduler();
                //ID batchprocessid = Database.executeBatch(BRML,1);
                DateTime dt = ecicSettings.Time_To_Schedule_Dormant_PH_Batch__c;
                String minute=String.valueOf(dt.minute());
                String hour=String.valueOf(dt.hour());
                String day='*';//dt.day();
                String month='*';//dt.month(); 0 0 13 * * ?
                String year=String.valueOf(dt.year());
                String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?';
                //String strSchedule='0 0 * * * ?';//'0 '+minute.trim()+' '+hour.trim()+' * * ?';
                System.schedule(ecicSettings.Batch_To_Schedule__c,strSchedule, BFSDS); 
                respData.isSuccess=true;
                respData.responseMsg = ecicSettings.Batch_To_Schedule__c+' Batch Scheduled Succesffully.'; 
            } catch(Exception e) {
                System.debug('Exception At Executing shceduleBatchConditionally :'+e.getMessage()+' Stack:'+e.getStackTraceString());
                respData.isSuccess=false;
                respData.responseMsg = ecicSettings.Batch_To_Schedule__c+' Batch Scheduled Failed : '+e.getMessage();
            }
        }else if(ecicSettings.Batch_To_Schedule__c.equals('CLI Cancel')){
            System.debug(ecicSettings.Batch_To_Schedule__c+' Called');
            deleteJob('CLI Cancel');
            
            try {
                ECIC_CL_API_Methods_CLI_CancelScheduler BFSDS = new ECIC_CL_API_Methods_CLI_CancelScheduler();
                //ID batchprocessid = Database.executeBatch(BRML,1);
                DateTime dt = ecicSettings.Time_To_Schedule_CLI_Cancel_Batch__c;
                String minute=String.valueOf(dt.minute());
                String hour=String.valueOf(dt.hour());
                String day='*';//dt.day();
                String month='*';//dt.month(); 0 0 13 * * ?
                String year=String.valueOf(dt.year());
                String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?';
                //String strSchedule='0 0 * * * ?';//'0 '+minute.trim()+' '+hour.trim()+' * * ?';
                System.schedule(ecicSettings.Batch_To_Schedule__c,strSchedule, BFSDS); 
                respData.isSuccess=true;
                respData.responseMsg = ecicSettings.Batch_To_Schedule__c+' Batch Scheduled Succesffully.'; 
            } catch(Exception e) {
                System.debug('Exception At Executing shceduleBatchConditionally :'+e.getMessage()+' Stack:'+e.getStackTraceString());
                respData.isSuccess=false;
                respData.responseMsg = ecicSettings.Batch_To_Schedule__c+' Batch Scheduled Failed : '+e.getMessage();
            }
        }else if(ecicSettings.Batch_To_Schedule__c.equals('Deactivate Limited Access Account')){
            System.debug(ecicSettings.Batch_To_Schedule__c+' Called');
            deleteJob('Deactivate Limited Access Account');
            
            try {
                BatchDeactivateAccountSchedule BFSDS = new BatchDeactivateAccountSchedule();
                //ID batchprocessid = Database.executeBatch(BRML,1);
                DateTime dt = ecicSettings.Time_To_Schedule_Deactivate_Account__c;
                String minute=String.valueOf(dt.minute());
                String hour=String.valueOf(dt.hour());
                String day='*';//dt.day();
                String month='*';//dt.month(); 0 0 13 * * ?
                String year=String.valueOf(dt.year());
                String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?';
                //String strSchedule='0 0 * * * ?';//'0 '+minute.trim()+' '+hour.trim()+' * * ?';
                System.schedule(ecicSettings.Batch_To_Schedule__c,strSchedule, BFSDS); 
                respData.isSuccess=true;
                respData.responseMsg = ecicSettings.Batch_To_Schedule__c+' Batch Scheduled Succesffully.'; 
            } catch(Exception e) {
                System.debug('Exception At Executing shceduleBatchConditionally :'+e.getMessage()+' Stack:'+e.getStackTraceString());
                respData.isSuccess=false;
                respData.responseMsg = ecicSettings.Batch_To_Schedule__c+' Batch Scheduled Failed : '+e.getMessage();
            }
        }else if(ecicSettings.Batch_To_Schedule__c.equals('Expire CL')){
            System.debug(ecicSettings.Batch_To_Schedule__c+' Called');
            deleteJob('Expire CL');
            
            try {
                BatchExpireCLScheduler BFSDS = new BatchExpireCLScheduler();
                //ID batchprocessid = Database.executeBatch(BRML,1);
                DateTime dt = ecicSettings.Time_To_Schedule_Expire_CL__c;
                String minute=String.valueOf(dt.minute());
                String hour=String.valueOf(dt.hour());
                String day='*';//dt.day();
                String month='*';//dt.month(); 0 0 13 * * ?
                String year=String.valueOf(dt.year());
                String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?';
                //String strSchedule='0 0 * * * ?';//'0 '+minute.trim()+' '+hour.trim()+' * * ?';
                System.schedule(ecicSettings.Batch_To_Schedule__c,strSchedule, BFSDS); 
                respData.isSuccess=true;
                respData.responseMsg = ecicSettings.Batch_To_Schedule__c+' Batch Scheduled Succesffully.'; 
            } catch(Exception e) {
                System.debug('Exception At Executing shceduleBatchConditionally :'+e.getMessage()+' Stack:'+e.getStackTraceString());
                respData.isSuccess=false;
                respData.responseMsg = ecicSettings.Batch_To_Schedule__c+' Batch Scheduled Failed : '+e.getMessage();
            }
        }else if(ecicSettings.Batch_To_Schedule__c.equals('Automatic Create Quotation Job')){
            System.debug(ecicSettings.Batch_To_Schedule__c+' Called');
            deleteJob('Automatic Create Quotation Job');
            
            try {
                BatchCreateQuotationScheduler BFSDS = new BatchCreateQuotationScheduler();
                //ID batchprocessid = Database.executeBatch(BRML,1);
                DateTime dt = ecicSettings.Time_To_Schdule_Create_Quotation_Job__c;
                String minute=String.valueOf(dt.minute());
                String hour=String.valueOf(dt.hour());
                String day='*';//dt.day();
                String month='*';//dt.month(); 0 0 13 * * ?
                String year=String.valueOf(dt.year());
                String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?';
                //String strSchedule='0 0 * * * ?';//'0 '+minute.trim()+' '+hour.trim()+' * * ?';
                System.schedule(ecicSettings.Batch_To_Schedule__c,strSchedule, BFSDS); 
                respData.isSuccess=true;
                respData.responseMsg = ecicSettings.Batch_To_Schedule__c+' Batch Scheduled Succesffully.'; 
            } catch(Exception e) {
                System.debug('Exception At Executing shceduleBatchConditionally :'+e.getMessage()+' Stack:'+e.getStackTraceString());
                respData.isSuccess=false;
                respData.responseMsg = ecicSettings.Batch_To_Schedule__c+' Batch Scheduled Failed : '+e.getMessage();
            }
        }
        System.debug('respData : '+respData);
        return respData;
    }

    public static void deleteJob(String jobName){
        try {
            System.debug('Delete the job Name :'+jobName);
            List<CronTrigger> conJobList = [select Id, NextFireTime, CronJobDetail.Name from CronTrigger where CronJobDetail.Name=:jobName ];
            System.debug('conJobList ==>>'+conJobList);
            if(conJobList != null && !conJobList.isEmpty()){
                System.abortJob(conJobList[0].Id);
                System.debug(jobName+' Job Aborted Successfully!!');
            }
        } catch (Exception ex) {
            System.debug('Exception at ex: '+ex.getMessage()+' Stack :'+ex.getStackTraceString());
        }
    }
}