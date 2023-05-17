public with sharing class EventManagement {
    @AuraEnabled
    public static List<Event> getEvents(Id accid){
        try{
            DateTime rightnow = Datetime.now();
            List<Event> eventList = [select Id,Subject,Description,StartDateTime,EndDateTime,WhoId,WhatId from Event where WhatId=:accid and StartDateTime > :rightnow ORDER BY StartDateTime DESC];
            return eventList;
        } catch (Exception e) {
            System.debug('Exception='+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<ECIC_Custom_Event__c> createFaceToFaceEvent(Id cust_event_id){
        try {
            List<ECIC_Custom_Event__c> eventList = [select Id,Name,Account__c,Appointment_Date__c,Appointment_Time__c,Number_of_participants__c,Status__c from ECIC_Custom_Event__c where Id=:cust_event_id];
            return eventList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static ECIC_Custom_Event__c getCustomEventDetails(String eventId){
        try {
            ECIC_Custom_Event__c custEvent = [Select Id,Account__c,Appointment_Date__c,Appointment_End_Time__c,Appointment_Time__c,Number_of_participants__c,Name,Event_Id__c,SME_Team_Member__c,Status__c from ECIC_Custom_Event__c where Event_Id__c=:eventId];
            return custEvent;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<ECIC_Custom_Event__c> getCustomEventList(List<Event> eventList){
        try {
            List<Id> eventIds = new List<Id>();
            for(Event each_event:eventList){
                eventIds.Add(each_event.Id);
            }
            List<ECIC_Custom_Event__c> custom_event_list = [select Id,Name,Account__c,Appointment_Date__c,Appointment_Time__c,Number_of_participants__c,Status__c,Event_Id__c from ECIC_Custom_Event__c where Event_Id__c in :eventIds ORDER BY Appointment_Date__c DESC];
            return custom_event_list;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<ECIC_Custom_Event__c> getPendingCustomEventList(Id accid){
        try {
            Date rightnow = Date.today();
            List<ECIC_Custom_Event__c> custom_event_list = [select Id,Name,Account__c,Appointment_Date__c,Appointment_Time__c,Number_of_participants__c,Status__c,Event_Id__c from ECIC_Custom_Event__c where Account__c =:accid and Appointment_Date__c>=:Date.today() and ((Status__c='New') or (Status__c='Updated'))];
            return custom_event_list;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<AccountFeed> getFeedItems(Id accid){
        try{ 
            //List<FeedItem> feedItemList = FeedItemQueryUtils.feedItemQuery(accid);
            List<AccountFeed> feedItemList = [select Id,Body,Title,ParentId from AccountFeed where ParentId=:accid ORDER BY CreatedDate DESC ];
            return feedItemList;
        } catch (Exception e) {
            System.debug('Exception='+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static Id createFeed(){
        try {
            FeedItem feed=new FeedItem();
            feed.Body='Test FeedItem2nd';
            feed.ParentId='0015600000UaDUEAA3';
            feed.Visibility='AllUsers';
            
            insert feed;
            return feed.Id;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}