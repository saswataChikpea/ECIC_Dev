public with sharing class clAndclaTriggerHandler {
    public static void checkCL_Condition(List<Credit_Limit__c> clList){
        System.debug('clAndclaTriggerHandler called: '+clList);
        try {
            boolean isCL_IssueDateIsBeforeEndorsCheckDate;
            List<Id> productIDList = new List<Id>();
            List<Id> clIdList = new List<Id>(); 
            String buyerName;
            String policyId;
            String parentEndosementID;
            String accountId;
            for(Credit_Limit__c cl : clList){
                System.debug('cl=====>>'+cl.Policy__c+' cl.CL_Condition__c:'+cl.CL_Condition__c);
                if(cl.CL_Condition__c!=null && !cl.CL_Condition__c.equals('')){
                    clIdList.add(cl.Policy__c);
                    buyerName = cl.Buyer_Name__c;
                    policyId = cl.Policy__c;
                    accountId = cl.Exporter__c;
                }
            } 
            System.debug('clIdList ==>>'+clIdList);
            if(clIdList != null && !clIdList.isEmpty()){
                for(Policy__c pol : [select Product__c from Policy__c where id in :clIdList]){
                    productIDList.add(pol.Product__c);
                }
                System.debug('productIDList ===>>'+productIDList);
                if(productIDList != null && !productIDList.isEmpty()){
                    
                    DateTime dT1 = System.now();
                    Date currentSystemDate = Date.newInstance(dT1.year(), dT1.month(), dT1.day());
                    for(Endorsement__c endorsement : [select id,name,Issue_Date__c,CL_Condition_Issued_Check_Date__c from Endorsement__c where ECIC_Product__r.Name='SBP' and Name in ('EN48A','EN49A')]){
                        if(endorsement.CL_Condition_Issued_Check_Date__c != null){
                            Integer dateDiffernce = currentSystemDate.daysBetween(endorsement.CL_Condition_Issued_Check_Date__c);
                            System.debug('dateDiffernce ::'+dateDiffernce);
                            if(dateDiffernce>0){
                                isCL_IssueDateIsBeforeEndorsCheckDate=true;
                                parentEndosementID=endorsement.id;
                            }
                        }
                    }
                    System.debug('isCL_IssueDateIsBeforeEndorsCheckDate : '+isCL_IssueDateIsBeforeEndorsCheckDate);
                    if(isCL_IssueDateIsBeforeEndorsCheckDate){
                        System.debug('buyerName : '+buyerName+' parentEndosementID:'+parentEndosementID+' policyId:'+policyId);
                        if(buyerName != null && !buyerName.equals('')){
                            List<Related_Endorsement__c> relEndorsementList = [select id,name from Related_Endorsement__c where Policy__c=:policyId and Buyer_Name__c =:buyerName];
                            System.debug('relEndorsementList : '+relEndorsementList);
                            if(relEndorsementList == null || relEndorsementList.isEmpty()){
                                Related_Endorsement__c relEndObj = new Related_Endorsement__c();
                                relEndObj.Policy__c=policyId;
                                relEndObj.Endorsement_Type__c=parentEndosementID;
                                relEndObj.Issue_Date__c=Date.valueOf(System.now());
                                relEndObj.Buyer_Name__c=buyerName;
                                insert relEndObj;
                                System.debug('Related Endorsement inserted succfully!!');
                                SendEmailApex.sendEmailAccount(accountId, relEndObj.id, 'Notification_For_Endorsement_Issued', false, null, null);
                            }
                        }
                    }
                }
            }
        } catch (Exception ex) {
            System.debug('Exception at clAndclaTriggerHandler Message '+ex.getMessage()+' Stack : '+ex.getStackTraceString());
        }
    }
}