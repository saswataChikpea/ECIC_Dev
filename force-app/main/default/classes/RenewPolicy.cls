public with sharing class RenewPolicy {

    //@InvocableMethod(label='Create Policy and Schedules' description='')
    public static void renewAutoPolicy(List<ID> ids){
        //Create Policy with 
        Account accObj = [select id,name,Current_Policy__c from Account where id =:ids];//0015D00000jINPpQAO
        if(accObj != null){
            String policyID = accObj.Current_Policy__c;
            Policy__c pol = [select Exporter__c,Is_Active__c,Product__c,
                            (select Type__c,Policy__c,Payment_Type__c,Policyholder_s_Address__c,Quotation__c
                            from Policy_Schedules__r) 
                            from Policy__c where id =:policyID];
            Policy__c polCopy = pol.clone(false, true, false, false);
            insert polCopy;
        }
    }

    public static void renewPolicyAutomatically(List<id> policyIdList){
        System.debug('renewPolicyAutomatically : '+policyIdList);
        try {
            if(policyIdList!= null && !policyIdList.isEmpty()){
                Map<Id,Id> accIdVsPolicyIdMap = new Map<Id,Id>();
                Map<Id,List<Policy__c>> accIdvsPolicyListMap = new Map<Id,List<Policy__c>>();
                Map<Id,List<Policy_Schedule__c>> accIdvsPolicySchceduleListMap = new Map<Id,List<Policy_Schedule__c>>();
                List<Related_Endorsement__c> relEndorsementList = new List<Related_Endorsement__c>();
                Map<Id,List<Related_Endorsement__c>> accIdvsRelEndorsementListMap = new Map<Id,List<Related_Endorsement__c>>();
                List<Policy_Schedule__c> polSchList = new List<Policy_Schedule__c>();
                List<Policy__c> newPolicyList = new List<Policy__c>();
                for(Policy__c pol : [select id,name,Exporter__c,Commencement_Date__c,Expiry_Date__c,Contact__c,
                    Cover_PDF_Link__c,Schedule_1_Link__c,Schedule_2_Link__c,Schedule_3_Link__c,Schedule_4_Link__c,
                    Document_Link__c,Effective_Date__c,Free_Credit_Check__c,Free_Org_Credit_Check_Facility__c,Issue_Date__c,
                    Issue_Date_Of_First_Credit_Limit__c,Legacy_Policy_Record_Id__c,Paid_Credit_Check__c,Policy_Holder_Mail_ID__c,
                    Policy_Type__c,Policyholder_s_Address__c,Product__c,Quotation__c,Renewal_Settings__c,Status__c,Used_Credit_check__c,
                    (select id,name,Type__c,Amount_ref_to_in_Sub_cl_1_2_and_69_2__c,Base_Loading__c,Base_Rate_Per_Anum__c,Base_Rate_Per_Quarter__c,
                    Buyer_Country_Market__c,Commencement_Date__c,
                    DP__c,DA_OA_0_30__c,DA_OA_31_60__c,DA_OA_61_90__c,DA_OA_91_120__c,
                    DP_NonA__c,DA_OA_0_30_NonA__c,DA_OA_31_60_NonA__c,DA_OA_61_90_NonA__c,DA_OA_91_120_NonA__c,
                    Backup_DP__c,Backup_DA_OA_0_30__c,Backup_DA_OA_31_60__c,Backup_DA_OA_61_90__c,Backup_DA_OA_91_120__c,
                    Backup_DP_NonA__c,Backup_DA_OA_0_30_NonA__c,Backup_DA_OA_31_60_NonA__c,Backup_DA_OA_61_90_NonA__c,Backup_DA_OA_91_120_NonA__c,
                    Effective_Date__c,Exclusion_of_Risk__c,Expiry_Date__c,
                    Issue_Date__c,Maximum_Credit_Period__c,Maximum_Liability__c,Non_Qualifying_Loss_Amount__c,Payment_Type__c,Percentage_of_Indemnity__c,
                    Policy_Deposit__c,Policy_Fee__c,Policyholder_s_Address__c,Port_of_Loading__c,Pre_Shipment__c,Premium_Rate_On__c,Premium_Rebate__c,
                    Quotation__c,Registered_Address_Line_1__c,Registered_Address_Line_2__c,Registered_Address_Line_3__c,Registered_District__c,
                    Registered_Territory__c,Renewal_Date__c
                    from Policy_Schedules__r),
                    (select id,name,Buyer_Code__c,Buyer_Country__c,Buyer_Name__c,Carry_Forward_To_Next_Policy_Year__c,
                    Country__c,Description_of_Goods__c,ECIC_Endorsements_Type__c,Endorsement_Type__c,Effective_Date__c,
                    Policy__c,
                    Premium_Rate_DP__c,Premium_Rate_DA_OA_0_30__c,Premium_Rate_DA_OA_31_60__c,Premium_Rate_DA_OA_61_90__c,
                    Premium_Rate_DA_OA_91_180__c,Quotation__c,Status__c,Subsidiary_Country__c,Subsidiary_Name__c
                    from Related_Endorsements__r where Status__c='Approved' and  Carry_Forward_To_Next_Policy_Year__c=true) 
                    from Policy__c where id in : policyIdList]){
    
                    System.debug('policy name : '+pol.name+' Id : ' +pol.Exporter__c);
                    Policy__c polObj = pol.clone(false, false, false, false);//new Policy__c();
                    polObj.Commencement_Date__c = pol.Expiry_Date__c.addDays(1);
                    polObj.Expiry_Date__c = pol.Expiry_Date__c.addDays(1).addYears(1);
                    newPolicyList.add(polObj);
                    accIdvsPolicyListMap.put(pol.Exporter__c,newPolicyList);
    
                    for(Policy_Schedule__c sch : pol.Policy_Schedules__r){
                        System.debug('sch====>>>'+sch);
                        Policy_Schedule__c schObj = sch.clone(false, false, false, false); //new Policy_Schedule__c();
                        //schObj.Type__c=sch.Type__c;
                        if(sch.Type__c.equals('Schedule 2')){
                            sch.DP__c=sch.Backup_DP__c;
                            sch.DA_OA_0_30__c=sch.Backup_DA_OA_0_30__c;
                            sch.DA_OA_31_60__c=sch.Backup_DA_OA_31_60__c;
                            sch.DA_OA_61_90__c=sch.Backup_DA_OA_61_90__c;
                            sch.DA_OA_91_120__c=sch.Backup_DA_OA_91_120__c;
                            sch.DP_NonA__c=sch.Backup_DP_NonA__c;
                            sch.DA_OA_0_30_NonA__c=sch.Backup_DA_OA_0_30_NonA__c;
                            sch.Backup_DA_OA_31_60__c=sch.Backup_DA_OA_31_60_NonA__c;
                            sch.DA_OA_61_90_NonA__c=sch.Backup_DA_OA_61_90_NonA__c;
                            sch.Backup_DA_OA_91_120__c=sch.Backup_DA_OA_91_120_NonA__c;
                        }
                        polSchList.add(schObj);
                    }
                    accIdvsPolicySchceduleListMap.put(pol.Exporter__c,polSchList);
                    for(Related_Endorsement__c endorse : pol.Related_Endorsements__r){
                        System.debug('endorse==>>'+endorse);
                        Related_Endorsement__c relEnd = endorse.clone(false, false, false, false);
                        relEndorsementList.add(relEnd);
                    }
                    accIdvsRelEndorsementListMap.put(pol.Exporter__c,relEndorsementList);
                }
                System.debug('newPolicyList : '+newPolicyList);
                if(newPolicyList !=null && !newPolicyList.isEmpty()){
                    List<Account> accList = new List<Account>();
                    List<Policy_Schedule__c> insertNewPolicyScheduleList = new List<Policy_Schedule__c>();
                    List<Related_Endorsement__c> insertRelatedEndorsementList = new List<Related_Endorsement__c>();
                    Database.SaveResult[] newPolicyRecord = Database.insert(newPolicyList, false);
                    List<Id> createdPolicyIDList = new List<Id>();
                    for(Integer i=0;i<newPolicyRecord.size();i++){
                        System.debug('new policy id==>> '+newPolicyRecord[i]);
                        if(newPolicyRecord[i].isSuccess()){
                            createdPolicyIDList.add(newPolicyRecord[i].getId());
                        }
                    }
                    System.debug('createdPolicyIDList : '+createdPolicyIDList);
                    for(Policy__c polObj : [select id,name,Exporter__c,Exporter__r.id from Policy__c where id in : createdPolicyIDList] ){
                        accIdVsPolicyIdMap.put(polObj.Exporter__r.id,polObj.id);
                    }
                    System.debug('accIdVsPolicyIdMap : '+accIdVsPolicyIdMap);
                    for (String fieldName : accIdVsPolicyIdMap.keySet()){
                        System.debug('field name is ' + fieldName);
                        for(Policy_Schedule__c schObj : accIdvsPolicySchceduleListMap.get(fieldName)){
                            Policy_Schedule__c newSchObj = schObj.clone(false, false, false, false);
                            newSchObj.Policy__c = accIdVsPolicyIdMap.get(fieldName);
                            insertNewPolicyScheduleList.add(newSchObj);
                            System.debug('insertNewPolicyScheduleList======cd=======>>>'+insertNewPolicyScheduleList.size());
                        }
                        for(Related_Endorsement__c endObj : accIdvsRelEndorsementListMap.get(fieldName)){
                            Related_Endorsement__c newendObj = endObj.clone(false, false, false, false);
                            newendObj.Policy__c = accIdVsPolicyIdMap.get(fieldName);
                            insertRelatedEndorsementList.add(newendObj);
                            System.debug('insertRelatedEndorsementList======cd=======>>>'+insertRelatedEndorsementList.size());
                        }
                    }
                    System.debug('insertNewPolicyScheduleList : '+insertNewPolicyScheduleList);
                    if(insertNewPolicyScheduleList!= null && !insertNewPolicyScheduleList.isEmpty()){
                        insert insertNewPolicyScheduleList;
                        System.debug('Policy Schedule Created Successfully!!!');
                        if(insertRelatedEndorsementList!=null && !insertRelatedEndorsementList.isEmpty()){
                            insert insertRelatedEndorsementList;
                            System.debug('Related Endorsement Created Successfully.');
                        }
                        for(Account acc : [select id,name,Current_Policy__c from Account where id in : accIdVsPolicyIdMap.keySet() ]){
                            acc.Current_Policy__c = accIdVsPolicyIdMap.get(acc.id);
                            accList.add(acc);
                        }
                        System.debug('accList : '+accList);
                        if(accList!= null && !accList.isEmpty()){
                            update accList;
                            System.debug('Account updated successfully!!!');
                        }
                    }
                }
            }
        } catch (Exception ex) {
            System.debug('Excpetion at renewPolicyAutomatically : '+ex.getMessage()+' Stack :'+ex.getStackTraceString());
        }
        
    }
}