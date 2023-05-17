public with sharing class ContentVersionTriggerHandler {

    public static void createPublicLinkForFile(List<ContentVersion> contentVersions){
        System.debug('Trigger createPublicLinkForFile called');
        String title;
        ContentDistribution[] distributionsToInsert = new List<ContentDistribution>();
        ContentDistribution[] distributionsToInsert2 = new List<ContentDistribution>();
        ContentDistribution[] distributionsToInsert3 = new List<ContentDistribution>();
       	for(ContentVersion objContentVersion : contentVersions){
            //if pdf uploaded then only create public link
            System.debug('Trigger contentVersions===>>'+contentVersions);
            if(objContentVersion.FileType!= null && objContentVersion.FileType.toLowerCase()=='pdf'){
                if( objContentVersion.Title.contains('_Schedule1') ||
                    objContentVersion.Title.contains('_Schedule2') ||
                    objContentVersion.Title.contains('_Schedule3') ||
                    objContentVersion.Title.contains('_Schedule4') ||
                    objContentVersion.Title.contains('_Cover')    ||
                    objContentVersion.Title.contains('_Document') ){

                    distributionsToInsert.add(createContentDistribution(objContentVersion.Id,objContentVersion.Title));
                    title=objContentVersion.Title;
                } else if(objContentVersion.Title.contains('CL_') && objContentVersion.Title.contains('_signed')){
                    distributionsToInsert2.add(createContentDistribution(objContentVersion.Id,objContentVersion.Title));
                    title=objContentVersion.Title;
                } else if(objContentVersion.Title.contains('CLA_') && objContentVersion.Title.contains('_signed')){
                    distributionsToInsert3.add(createContentDistribution(objContentVersion.Id,objContentVersion.Title));
                    title=objContentVersion.Title;
                }
            }
        }
        if(distributionsToInsert!=null && !distributionsToInsert.isEmpty())
        {
        	insert distributionsToInsert;
            System.debug('Trigger ContentDistribution inserted successfully.'+distributionsToInsert[0].id);
            List<ContentDistribution> publicUrlList = [SELECT Id,Name, ContentDownloadUrl FROM ContentDistribution where id =:distributionsToInsert[0].id];
            System.debug('Trigger publicUrlList : '+publicUrlList);
            if(publicUrlList!=null && !publicUrlList.isEmpty()){
                if(title!=null && !title.equals('')){
                    try {
                        System.debug('Trigger title ::'+title);
                        String policyName = title.split('_')[0];
                        String docType = title.split('_')[1];
                        System.debug('Trigger policyName : '+policyName);
                        List<Policy__c> updatePolList=new List<Policy__c>();
                        if(policyName!=null && !policyName.equals('')){
                            for(Policy__c pol:[select id,name,
                                Schedule_1_Link__c,
                                Schedule_2_Link__c,
                                Schedule_3_Link__c,
                                Schedule_4_Link__c,
                                Cover_PDF_Link__c,
                                Document_Link__c
                                from Policy__c where name =:policyName]){
                                System.debug('Trigger pol===>>'+pol);
                                if(docType.equals('Schedule1')){
                                    pol.Schedule_1_Link__c = publicUrlList[0].ContentDownloadUrl;
                                }else if(docType.equals('Schedule2')){
                                    pol.Schedule_2_Link__c = publicUrlList[0].ContentDownloadUrl;
                                }else if(docType.equals('Schedule3')){
                                    pol.Schedule_3_Link__c = publicUrlList[0].ContentDownloadUrl;
                                }else if(docType.equals('Schedule4')){
                                    pol.Schedule_4_Link__c = publicUrlList[0].ContentDownloadUrl;
                                }else if(docType.equals('Cover')){
                                    pol.Cover_PDF_Link__c = publicUrlList[0].ContentDownloadUrl;
                                }else if(docType.equals('Document')){
                                    pol.Document_Link__c = publicUrlList[0].ContentDownloadUrl;
                                }
                                updatePolList.add(pol);
                            }
                            if(updatePolList!=null && !updatePolList.isEmpty()){
                                update updatePolList;
                                System.debug('Trigger updatePolList updated');
                            }
                        }
                    } catch (Exception ex) {
                        System.debug('Trigger Exception at ex:'+ex.getMessage()+' Stack:'+ex.getStackTraceString());
                    }
                }
            }
        }
        if(distributionsToInsert2!=null && !distributionsToInsert2.isEmpty())
        {
        	insert distributionsToInsert2;
            System.debug('Trigger ContentDistribution inserted successfully.'+distributionsToInsert2[0].id);
            List<ContentDistribution> publicUrlList = [SELECT Id,Name, ContentDownloadUrl FROM ContentDistribution where id =:distributionsToInsert2[0].id];
            System.debug('Trigger publicUrlList : '+publicUrlList);
            if(publicUrlList!=null && !publicUrlList.isEmpty()){
                if(title!=null && !title.equals('')){
                    try {
                        System.debug('Trigger title ::'+title);
                        String cl_no = title.split('_')[2];

                        System.debug('Trigger cl_no : '+cl_no);
                        List<Credit_Limit__c> updateCl=new List<Credit_Limit__c>();
                        if(cl_no!=null && !cl_no.equals('')){
                            for(Credit_Limit__c cl:[select id,name,
                                CL_Approve_Letter__c
                                from Credit_Limit__c where CL_No__c =:cl_no]){
                                System.debug('Trigger cl===>>'+cl);
                                if(title.contains('CL_Approve')){
                                    cl.CL_Approve_Letter__c = publicUrlList[0].ContentDownloadUrl;
                                }
                                updateCl.add(cl);
                            }
                            if(updateCl!=null && !updateCl.isEmpty()){
                                update updateCl;
                                System.debug('Trigger updateClList updated');
                            }
                        }
                    } catch (Exception ex) {
                        System.debug('Trigger Exception at ex:'+ex.getMessage()+' Stack:'+ex.getStackTraceString());
                    }
                }
            }
        }
        if(distributionsToInsert3!=null && !distributionsToInsert3.isEmpty())
        {
        	insert distributionsToInsert3;
            System.debug('Trigger ContentDistribution inserted successfully.'+distributionsToInsert3[0].id);
            List<ContentDistribution> publicUrlList = [SELECT Id,Name, ContentDownloadUrl FROM ContentDistribution where id =:distributionsToInsert3[0].id];
            System.debug('Trigger publicUrlList : '+publicUrlList);
            if(publicUrlList!=null && !publicUrlList.isEmpty()){
                if(title!=null && !title.equals('')){
                    try {
                        System.debug('Trigger title ::'+title);
                        String cla_name = title.split('_')[2];

                        System.debug('Trigger cla_name : '+cla_name);
                        List<Credit_Limit_Application__c> updateCla=new List<Credit_Limit_Application__c>();
                        if(cla_name!=null && !cla_name.equals('')){
                            for(Credit_Limit_Application__c cla:[select id,name,
                                CLA_Cancel_Letter__c
                                from Credit_Limit_Application__c where name =:cla_name]){
                                System.debug('Trigger cl===>>'+cla);
                                if(title.contains('CLA_Cancel')){
                                    cla.CLA_Cancel_Letter__c = publicUrlList[0].ContentDownloadUrl;
                                }
                                updateCla.add(cla);
                            }
                            if(updateCla!=null && !updateCla.isEmpty()){
                                update updateCla;
                                System.debug('Trigger updateClList updated');
                            }
                        }
                    } catch (Exception ex) {
                        System.debug('Trigger Exception at ex:'+ex.getMessage()+' Stack:'+ex.getStackTraceString());
                    }
                }
            }
        }
    }
    
    
    public static ContentDistribution createContentDistribution(Id contentVersionId,String title){
        ContentDistribution newDist = new ContentDistribution();
        newDist.ContentVersionId = contentVersionId;
        newDist.Name = title;// 'External Link';
        newDist.PreferencesNotifyOnVisit = false;
        newDist.PreferencesAllowViewInBrowser = true;
        newDist.PreferencesAllowOriginalDownload=true;
        system.debug('Trigger createContentDistribution prepared');
        return newDist;
    }
}