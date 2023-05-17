global with sharing class BatchCreateSBPInvoiceRunScheduler{

    Webservice static String executeschedule()
    {

        String error;
        String strSchedule;        
        BatchCreateSBPInvoiceScheduler BCSBPI=new BatchCreateSBPInvoiceScheduler();
        List<ECIC_Settings__c> ecicSettingList=[SELECT id,Batch_To_Schedule__c,Time_To_Schedule_SBP_Invoice_Batch__c from ECIC_Settings__c limit 1];
        if(ecicSettingList!=null && ecicSettingList.size()>0)
        {
            if(ecicSettingList[0].Time_To_Schedule_SBP_Invoice_Batch__c!=null)
            {
                
                Datetime dT1 = ecicSettingList[0].Time_To_Schedule_SBP_Invoice_Batch__c;
                String day = string.valueOf(dT1.day());
                String month = string.valueOf(dT1.month());
                String hour = string.valueOf(dT1.hour());
                String minute = string.valueOf(dT1.minute());
                String second = string.valueOf(dT1.year());
                String year = string.valueOf(dT1.year());
                strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
                
            }    
            try{
                system.schedule(ecicSettingList[0].Batch_To_Schedule__c,strSchedule, BCSBPI);
                error='success';
            }
            catch(Exception E)
            {
                error=E.getMessage();
            }
        }
        return error;  
    }
}