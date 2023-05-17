/*---------------------------------------------------
Desc : Class for updating the access token from ecic api gateway.
created date : 27-Sep_2021
created by : sayantan@chikpea.com
----------------------------------------------------*/
global with sharing class ECIC_API_Token_Schdlr implements Schedulable {
    global void execute(SchedulableContext ctx) {
        try{
            ECIC_API_Token_Schdlr.calloutECICAPI();
            // schedule next job
            String msg = ECIC_API_Token_Schdlr.scheduleNext(System.now());
            System.debug('msg ====>'+msg);
            
        }
        catch(Exception e){
            String errorMsg = 'Exception e ===> '+e.getMessage()+'==> line number ==> '+e.getLineNumber()+' ==> '+e.getStackTraceString();
            system.debug(errorMsg);
            // return e.getMessage();
        }
    }
    global static String scheduleNext(DateTime dt){
        try{
            DateTime dtnext = dt.addMinutes(25);
            String sec = String.valueOf(dtnext.second());
            String min = String.valueOf(dtnext.minute());
            String hr = String.valueOf(dtnext.hour());
            String day = String.valueOf(dtnext.day());
            String mon = String.valueOf(dtnext.month());
            String yr = String.valueOf(dtnext.year());
            String CRON_EXP = sec+' '+min+' '+hr+' '+day+' '+mon+' ? '+yr;
            //'0 0 0 3 9 ? 2022';
            // clear the existing job first.
            List<CronTrigger> joblist = [SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType 
    				FROM CronTrigger WHERE CronJobDetail.Name LIKE '%Refresh Access Token%' LIMIT 1];
            if(joblist != NULL && joblist.size()>0)
                System.abortJob(joblist[0].id);
            ECIC_API_Token_Schdlr m = new ECIC_API_Token_Schdlr();
            String jobID = system.schedule('Refresh Access Token Job', CRON_EXP, m);
            return 'Successfully job scheduled.';
        }
        catch(Exception e){
            String errorMsg = 'Exception e ===> '+e.getMessage()+'==> line number ==> '+e.getLineNumber()+' ==> '+e.getStackTraceString();
            system.debug(errorMsg);
            return errorMsg;
        }
    }
    @future(callout=true)
    global static void calloutECICAPI(){
        String settingname = ECIC_API_v1.get_ecic_setting(NULL);
        System.debug('settingname ====> '+settingname);
        ECIC_Settings__c ecic_setting = ECIC_API_v1.ecic_setting;
        String access_token = ECIC_API_V1.get_access_token();
        if(ECIC_API_V1.access_token_success){
            ECIC_API_v1.ecic_setting.Access_Token__c = access_token;
            ECIC_API_v1.ecic_setting.Access_Token_Updated__c = System.Now();
            ECIC_API_v1.ecic_setting.Access_Token_Valid_Upto__c = System.Now().addMinutes(30);   // hard coded currently
            System.debug('ECIC_API_v1.ecic_setting ====>'+ECIC_API_v1.ecic_setting);
            update ECIC_API_v1.ecic_setting;
        }
    }
}