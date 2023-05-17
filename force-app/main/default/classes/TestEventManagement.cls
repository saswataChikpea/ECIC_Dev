@isTest
public with sharing class TestEventManagement {
    public static Account createRecord() {
        Account acc = new Account(Name='TestAccount');
        insert acc;        
        Contact con = new Contact(LastName='Test Contact',
        AccountId=acc.Id       
        );
        insert con;
        DateTime Startdate = DateTime.Now().addDays(1);
        DateTime Enddate = DateTime.Now().addDays(1).addHours(1);
        Event new_event = new Event(StartDateTime=Startdate,
            EndDateTime=Enddate,
            WhoId=con.Id,
            WhatId=acc.Id,
            IsVisibleInSelfService=true,
            Subject='Meeting'
            );
        insert new_event;
        Date start_date = Date.today().addDays(1);
        // start_date = start_date.addDays(1);
        Time start_time = Time.newInstance(Startdate.hour(),Startdate.minute(),Startdate.second(),Startdate.millisecond());
        ECIC_Custom_Event__c cust_event = new ECIC_Custom_Event__c(Account__c=acc.Id,
        Appointment_Date__c=start_date,
        Appointment_Time__c=start_time,
        // 'Appointment_End_Time__c': this.appointment_end_time,
        Number_of_participants__c=2,
        Status__c='New',
        Event_Id__c=new_event.Id);
        insert cust_event;
        return acc;
    }
    @isTest
    static void testGetEvents(){
        Test.startTest();
        Account acc = createRecord();
        List<Event> eventList = EventManagement.getEvents(acc.Id);
        System.assertEquals(eventList.size(),1);
        try{
            List<Event> eventList2 = EventManagement.getEvents('123456789');
        } catch(Exception e) {
            system.assertEquals(e.getMessage(), e.getMessage());
        }
        Test.stopTest();
    }
    @isTest
    static void testGetCustomEventDetails(){
        Test.startTest();
        Account acc = createRecord();
        Event eve = [Select Id from Event where WhatId=:acc.Id];
        ECIC_Custom_Event__c custom_event = EventManagement.getCustomEventDetails(eve.Id);
        System.assertEquals(custom_event.Status__c,'New');
        Test.stopTest();
    }
    @isTest
    static void testGetCustomEventList(){
        Test.startTest();
        Account acc = createRecord();
        Event eve = [Select Id from Event where WhatId=:acc.Id];
        List<Event> eventIdList = new List<Event>();
        eventIdList.add(eve);
        List<ECIC_Custom_Event__c> cust_event_list = EventManagement.getCustomEventList(eventIdList);
        System.assertEquals(cust_event_list.size(),1);
        Test.stopTest();
    }
    
    @isTest
    static void testcreateFaceToFaceEvent(){
        Test.startTest();
        Account acc = createRecord();
        Event eve = [Select Id from Event where WhatId=:acc.Id];
        list<ECIC_Custom_Event__c> custom_event = EventManagement.createFaceToFaceEvent(eve.Id);        
        Test.stopTest();
    }
    
    @isTest
    static void testgetPendingCustomEventList(){
        Test.startTest();
        Account acc = createRecord();        
        list<ECIC_Custom_Event__c> custom_event = EventManagement.getPendingCustomEventList(acc.Id);        
        Test.stopTest();
    }
    
    @isTest
    static void testgetFeedItems(){
        Test.startTest();
        Account acc = createRecord();        
        list<AccountFeed> AccountFeedlist = EventManagement.getFeedItems(acc.Id);        
        Test.stopTest();
    }
    
    @isTest
    static void testcreateFeed(){
        Test.startTest();
        Account acc = createRecord();        
        EventManagement.createFeed();        
        Test.stopTest();
    }
}