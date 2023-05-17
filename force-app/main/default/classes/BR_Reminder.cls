public with sharing class BR_Reminder {
        public static void sendBRReminderToProspect() {
            String response;
            List<ECIC_Document__c> doc7thDayEmailReminderList = [select id,CreatedDate,Status__c,Account__c 
            from ECIC_Document__c 
            where  Status__c='Invalid' and 
            First_Rejection_Mail_Sent__c = true and 
            First_Reminder_Email_Sent__c = false and
            is_7th_Day_Email_Reminder_Req__c=true and 
            Second_Reminder_Email_Sent__c=false];
            System.debug('doc7thDayEmailReminderList ==>>'+doc7thDayEmailReminderList);
            if(doc7thDayEmailReminderList!= null && !doc7thDayEmailReminderList.isEmpty()){
               
                //Send email function
                response = SendEmailApex.sendEmailAccount(doc7thDayEmailReminderList[0].Account__c, 
                doc7thDayEmailReminderList[0].id, 
                'Unmatch_BR_number', 
                false, 
                null, 
                null);
                System.debug('response===>>'+response);
                if(response.equals('success')){
                    List<ECIC_Document__c> updatedoc7thDayEmailReminderList = new List<ECIC_Document__c>();
                    for(ECIC_Document__c tt : doc7thDayEmailReminderList){
                        tt.First_Reminder_Email_Sent__c = true;
                        tt.First_Reminder_Email_Sent_Date__c = System.now();
                        updatedoc7thDayEmailReminderList.add(tt);
                    }
                    System.debug('updatedoc7thDayEmailReminderList==>>'+updatedoc7thDayEmailReminderList);
                    if(updatedoc7thDayEmailReminderList!= null && !updatedoc7thDayEmailReminderList.isEmpty()){
                        update updatedoc7thDayEmailReminderList;
                        System.debug('ECIC_Document__c Updated Successfully!!!');
                    }
                }
            }else{
                /*List<ECIC_Document__c> doc21stDayEmailReminderList = [select id,CreatedDate,Status__c 
                from ECIC_Document__c 
                where  Status__c='Invalid' and 
                First_Rejection_Mail_Sent__c = true and 
                is_7th_Day_Email_Reminder_Req__c=false and 
                First_Reminder_Email_Sent__c=true and
                Second_Reminder_Email_Sent__c=false];
                System.debug('doc21stDayEmailReminderList ==>>'+doc21stDayEmailReminderList);*/
            }
        }
        public static void sendBrReminderAtSpecificInterval( List<ECIC_Document__c> sendReminderEmailTo){
            System.debug('sendBrReminderAtSpecificInterval called ');
            // List<ECIC_Document__c> sendReminderEmailTo = [select id,CreatedDate,Status__c,Account__c,
            // First_Rejection_Mail_Sent__c,First_Rejection_Mail_Sent_Date__c,
            // is_7th_Day_Email_Reminder_Req__c,
            // First_Reminder_Email_Sent__c,First_Reminder_Email_Sent_Date__c,
            // Second_Reminder_Email_Sent__c,Second_Reminder_Email_Sent_Date__c 
            // from ECIC_Document__c 
            // where Status__c='Invalid' and 
            // First_Rejection_Mail_Sent__c = true ];
            List<Task> insertTaskList =  new List<Task>();
            List<ECIC_Document__c> updateEcicDocList = new List<ECIC_Document__c>();
            String response;
            //S5
            for(ECIC_Document__c ec : sendReminderEmailTo){
                if(ec.is_7th_Day_Email_Reminder_Req__c){
                    //Send 7th Day Reminder Mail
                    //Send email function
                    response = SendEmailApex.sendEmailAccount(ec.Account__c, ec.id, 'Unmatch_BR_number', false, null, null);
                    System.debug('response===>>'+response);
                    if(response.equals('success')){
                        ec.First_Reminder_Email_Sent__c = true;
                        ec.First_Reminder_Email_Sent_Date__c = System.now();
                        updateEcicDocList.add(ec);
                    }
                }else{
                    if(ec.First_Reminder_Email_Sent__c && ec.First_Reminder_Email_Sent_Date__c!=null){
                        Datetime todayDateTime = System.now();
                        Integer dayDifference = Date.valueOf(ec.First_Reminder_Email_Sent_Date__c).daysBetween(Date.valueOf(todayDateTime));
                        System.debug('dayDifference===>>'+dayDifference);
                        if(dayDifference==21){
                            //Create Task for Rejection of the application
                            Task newTask = new Task();
                            newTask.Subject = 'Reject The Application';
                            newTask.Description = 'The prospect does not submitted a valid BR within 21 days after the reminder is sent out.';
                            newTask.Priority = 'High';
                            newTask.WhatId = ec.id;
                            newTask.Custom_User_Assigned__c='SME Staff';
                            newTask.Type = 'Reject Application Due To Invalid BR';
                            insertTaskList.add(newTask);
                        }
                    }
                }
            }

            //28a & 28b
            for(ECIC_Document__c ec : sendReminderEmailTo){
                System.debug('Product : '+ec.Product__c+' ec==>>'+ec);
                if(ec.Product__c.equals('OMBP')){
                    if(ec.First_Rejection_Mail_Sent__c && ec.First_Rejection_Mail_Sent_Date__c!=null){
                        if(!ec.Is_Email_Sent_At_30th_Day__c){
                            Datetime todayDateTime = System.now();
                            Integer dayDifference = Date.valueOf(ec.First_Rejection_Mail_Sent_Date__c).daysBetween(Date.valueOf(todayDateTime));
                            System.debug('dayDifference===>>'+dayDifference);
                            if(dayDifference==30){
                                //Send the Reminder at 30th day
                                response = SendEmailApex.sendEmailAccount(ec.Account__c, ec.id, 'Unmatch_BR_number', false, null, null);
                                System.debug('response===>>'+response);
                                if(response.equals('success')){
                                    ec.Is_Email_Sent_At_30th_Day__c = true;
                                    ec.Email_Sent_At_30th_Day_Date__c = Date.valueOf(System.now());
                                    updateEcicDocList.add(ec);
    
                                    Task newTask = new Task();
                                    newTask.Subject = 'Follow up on the expired BR';
                                    newTask.Description = 'Policyholder’s BR is expired for less than or equal to 30 days. SME to follow up.';
                                    newTask.Priority = 'High';
                                    newTask.WhatId = ec.id;
                                    newTask.Custom_User_Assigned__c='SME Staff';
                                    newTask.Type = 'Follow up on the expired BR';
                                    insertTaskList.add(newTask);
                                }
                            }
                        }else{
                            if(!ec.First_14th_Day_Reminder__c && !ec.Second_Reminder_Email_Sent__c){
                                //Send 14th Days Mail Reminder After 30th day
                                Datetime todayDateTime = System.now();
                                Integer dayDifference = Date.valueOf(ec.Email_Sent_At_30th_Day_Date__c).daysBetween(Date.valueOf(todayDateTime));
                                System.debug('dayDifference===>>'+dayDifference);
                                if(dayDifference==14){
                                    //Send the Reminder at 30th day
                                    response = SendEmailApex.sendEmailAccount(ec.Account__c, ec.id, 'Unmatch_BR_number', false, null, null);
                                    System.debug('response===>>'+response);
                                    if(response.equals('success')){
                                        ec.First_14th_Day_Reminder__c = true;
                                        ec.First_14th_Day_Reminder_Date__c = Date.valueOf(System.now());
                                        updateEcicDocList.add(ec);

                                    }
                                }
                            }else{
                                if(ec.First_14th_Day_Reminder__c && ec.First_14th_Day_Reminder_Date__c != null){
                                     //Send Second 14th Days Mail Reminder After 30th day
                                    Datetime todayDateTime = System.now();
                                    Integer dayDifference = Date.valueOf(ec.First_14th_Day_Reminder_Date__c).daysBetween(Date.valueOf(todayDateTime));
                                    System.debug('dayDifference===>>'+dayDifference);
                                    if(dayDifference==14){
                                        //Send the Reminder at 30th day
                                        response = SendEmailApex.sendEmailAccount(ec.Account__c, ec.id, 'Unmatch_BR_number', false, null, null);
                                        System.debug('response===>>'+response);
                                        if(response.equals('success')){
                                            ec.Second_Reminder_Email_Sent__c = true;
                                            ec.Second_Reminder_Email_Sent_Date__c = Date.valueOf(System.now());
                                            updateEcicDocList.add(ec);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }else if(ec.Product__c.equals('SBP') || ec.Product__c.equals('SUP')) {
                    if(ec.First_Reminder_Email_Sent__c){
                        //7th Days that use case S5
                        if(!ec.First_14th_Day_Reminder__c && !ec.Second_Reminder_Email_Sent__c){
                            //Send the Second Reminder
                            Datetime todayDateTime = System.now();
                            Integer dayDifference = Date.valueOf(ec.First_Reminder_Email_Sent_Date__c).daysBetween(Date.valueOf(todayDateTime));
                            System.debug('dayDifference===>>'+dayDifference);
                            if(dayDifference==14){
                                //Send the First 14th day Reminder Mail
                                ec.First_14th_Day_Reminder__c = true;
                                ec.First_14th_Day_Reminder_Date__c = Date.valueOf(System.now());
                                updateEcicDocList.add(ec);
                            }
                        }else{
                            if(ec.First_14th_Day_Reminder__c && ec.First_14th_Day_Reminder_Date__c != null){
                                //Send Second 14th Days Mail Reminder After 30th day
                               Datetime todayDateTime = System.now();
                               Integer dayDifference = Date.valueOf(ec.First_14th_Day_Reminder_Date__c).daysBetween(Date.valueOf(todayDateTime));
                               System.debug('dayDifference===>>'+dayDifference);
                               if(dayDifference==14){
                                   //Send the Reminder at 30th day
                                   response = SendEmailApex.sendEmailAccount(ec.Account__c, ec.id, 'Unmatch_BR_number', false, null, null);
                                   System.debug('response===>>'+response);
                                   if(response.equals('success')){
                                       ec.Second_Reminder_Email_Sent__c = true;
                                       ec.Second_Reminder_Email_Sent_Date__c = Date.valueOf(System.now());
                                       updateEcicDocList.add(ec);
                                   }
                               }
                           }
                        }
                    }
                }
            }
            System.debug('insertTaskList :'+insertTaskList);
            if(insertTaskList!= null && !insertTaskList.isEmpty()){
                insert insertTaskList;
                System.debug('Task is created succesfully');
            }
            System.debug('updateEcicDocList :'+updateEcicDocList);
            if(updateEcicDocList!= null && !updateEcicDocList.isEmpty()){
                update updateEcicDocList;
                System.debug('Ecic doc updated succesfully');
            }
        }
    }