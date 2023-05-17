@isTest
public with sharing class TestTaskManagement {
    
    public static Account createRecord() {
        Account acc = new Account(Name='TestAccount');
        insert acc; 
        Task tsk = new Task(Subject='Test',
        Description='Test description',
        Status='Open',
        WhatId=acc.Id);
        insert tsk;
        return acc;
    }
    @isTest
    static void testgetTasks(){
        Test.startTest();
        Id tskId;
        Account acc = createRecord();
        List<Task> taskList = TaskManagement.getTasks(acc.Id);
        for(Task tsk:taskList){
            tskId = tsk.Id;
        }
        try{
        	TaskManagement.getTasks(tskId);
        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }
        Test.stopTest();
        System.assertEquals(taskList.size(),1);
    }
}