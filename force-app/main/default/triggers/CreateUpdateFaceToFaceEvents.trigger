trigger CreateUpdateFaceToFaceEvents on ECIC_Custom_Event__c (after update) {
	List<Event> new_event_list = new List<Event>();
    Event new_event;
    Event update_event;
    Event delete_event;
    ECIC_Custom_Event__c updated_custom_event;
    String date_str;
    String time_str;
    String date_time_str;
    DateTime start_date_time; 
    DateTime end_date_time;
    Id cust_event_id;
    for (ECIC_Custom_Event__c cust_event : Trigger.New) {
        System.debug('cust_event='+cust_event);
        cust_event_id = cust_event.Id;
        if ((cust_event.Event_Id__c == null) && (cust_event.Status__c == 'Accepted')){
            
            date_str = string.valueOf(cust_event.Appointment_Date__c);
            time_str = string.valueOf(cust_event.Appointment_Time__c);
            date_time_str = date_str + ' ' + time_str;
            start_date_time = DateTime.valueOf(date_time_str);
            end_date_time = start_date_time.addHours(2);
            new_event = new Event(StartDateTime=start_date_time,
            EndDateTime=end_date_time,
            WhoId=cust_event.SME_Team_Member__c,
            WhatId=cust_event.Account__c,
            IsVisibleInSelfService=true,
            Subject='Meeting'
            );                        
        } else if ((cust_event.Event_Id__c == null) && (cust_event.Status__c == 'Cancelled')){

        } else if ((cust_event.Event_Id__c != null) && (cust_event.Status__c == 'Updated')){
            delete_event = new Event(Id=cust_event.Event_Id__c);
        } else if ((cust_event.Event_Id__c != null) && (cust_event.Status__c == 'Cancelled')){
            delete_event = new Event(Id=cust_event.Event_Id__c);
        } else {
            System.debug('Update trigger');
            date_str = string.valueOf(cust_event.Appointment_Date__c);
            time_str = string.valueOf(cust_event.Appointment_Time__c);
            date_time_str = date_str + ' ' + time_str;
            start_date_time = DateTime.valueOf(date_time_str);
            end_date_time = start_date_time.addHours(2);
            update_event = new Event(Id=cust_event.Event_Id__c,
            StartDateTime=start_date_time,
            EndDateTime=end_date_time,
            WhoId=cust_event.SME_Team_Member__c,
            WhatId=cust_event.Account__c,
            IsVisibleInSelfService=true,
            Subject='Meeting'
            );
        }
    }
    try{
    if(new_event!=null){
        System.debug('new_event------->'+new_event);
        insert new_event;
        updated_custom_event = new ECIC_Custom_Event__c(Id=cust_event_id,
        Event_Id__c=new_event.Id              
        );
        update updated_custom_event;
        
        SendEmailApex.sendEmailAccount(new_event.WhatId, cust_event_id, 'Face_to_Face_appointment_Registration', false, null, null);
    }
    if(update_event != null) {
        update update_event;
    }
    if(delete_event != null) {
        delete delete_event;
        updated_custom_event = new ECIC_Custom_Event__c(Id=cust_event_id,
        Event_Id__c=''             
        );
        update updated_custom_event;
    }
    }catch(Exception e) {
        System.debug('Exception:'+e.getMessage());
    }
}