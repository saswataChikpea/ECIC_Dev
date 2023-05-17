public with sharing class PolicyManagement {
   
    /*@AuraEnabled
    public static ID getAccountID(Id usrId){
        try {
            Id accountId = [Select contact.AccountId from user where id =:usrId].contact.AccountId;
        } catch (Exception e) {
            throw new AuraHandledException(ex.getMessage());
        } 
        return accountId;
    }*/
    public static ID getAccountID(Id usrId){
        Id accountId = [Select contact.AccountId from user where id =:usrId].contact.AccountId;
        return accountId;
    }
    @AuraEnabled
    public static List<Policy__c> getAllPolicy(String accountID){
        System.debug('getAllPolicy accountID : '+accountID);
        List<Policy__c> policyList = new List<Policy__c>();
        try {
            policyList = [select id,name,Commencement_Date__c from Policy__c where Exporter__c =:accountID];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        System.debug('policyList : '+policyList);
        return policyList;
    }
    @AuraEnabled
    public static String getDomainBaseURL(){
        return String.valueOf(URL.getSalesforceBaseUrl().getHost());
    }

    @AuraEnabled
    public static Account getAccountDetails(String accountID){
        Account accObj = new Account();
        try {
             accObj = [select id,name,
             Current_Policy__c,
             Current_Policy__r.Name,
             Current_Policy__r.Commencement_Date__c,
             Current_Policy__r.Maximum_Liability__c,
             Current_Policy__r.Percentage_of_Indemnity__c,
             Current_Policy__r.Issue_Date__c,
             Current_Policy__r.Policyholder_s_Address__c,
             Current_Policy__r.Product__c, 
             Current_Policy__r.Product__r.name 
             from Account where id =:accountID];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return accObj;
    }

    @AuraEnabled
    public static List<Policy_Schedule__c> getAllSchedule(Id usrId){
        ID accountId = getAccountID(usrId);
        String policyName; 
        List<Policy_Schedule__c> policyScheduleList = new List<Policy_Schedule__c>();
        List<sObject> sobjList; 
        try {
            Account accObj = [select id,name,Current_Policy__c,Current_Policy__r.Product__r.Name from Account where id =:accountId];
             if(accObj != null && accObj.Current_Policy__c != null){
                policyName = accObj.Current_Policy__r.Product__r.Name;
                 System.debug('Current_Policy__r.name : '+policyName);
                if(policyName.equals('OMBP')){
                    policyScheduleList = [select id,name,Issue_Date__c,Expiry_Date__c,Effective_Date__c,Maximum_Liability__c,Type__c,
                    Commencement_Date__c,Percentage_of_Indemnity__c,Policyholder_s_Address__c,Renewal_Date__c,
                    Policy__c,Policy__r.Product__r.Name,Policy__r.Name,
                    Policy_Deposit__c,Policy_Fee__c,Policy_Period__c,Maximum_Credit_Period__c,
                    Non_Qualifying_Loss_Amount__c,Exclusion_of_Risk__c,Buyer_Country_Market__c,
                    Amount_ref_to_in_Sub_cl_1_2_and_69_2__c,
                    Premium_Rate_On__c,
                    Base_Rate_Per_Quarter__c,
                    Base_Rate_Per_Anum__c,
                    Pre_Shipment__c,
                    DP__c,
                    OA1_60__c,
                    OA61_120__c,
                    Base_Loading__c,Policy_Holder_Name__c,CreatedDate

                    from Policy_Schedule__c 
                    where Policy__c =:accObj.Current_Policy__c  and Type__c='Schedule 1' order by Type__c ];
                }else if(policyName.equals('SUP')){
                    policyScheduleList = [select id,name,Issue_Date__c,Expiry_Date__c,Effective_Date__c,Maximum_Liability__c,Type__c,
                    Commencement_Date__c,Percentage_of_Indemnity__c,Policyholder_s_Address__c,Renewal_Date__c,
                    Policy__c,Policy__r.Product__r.Name,Policy__r.Name,
                    Policy_Deposit__c,Policy_Fee__c,Policy_Period__c,Maximum_Credit_Period__c,
                    Non_Qualifying_Loss_Amount__c,Exclusion_of_Risk__c,Buyer_Country_Market__c,
                    Amount_ref_to_in_Sub_cl_1_2_and_69_2__c,
                    Premium_Rate_On__c,
                    Base_Rate_Per_Quarter__c,
                    Base_Rate_Per_Anum__c,
                    Pre_Shipment__c,
                    DP__c,
                    OA1_60__c,
                    OA61_120__c,
                    Base_Loading__c,Policy_Holder_Name__c,CreatedDate

                    from Policy_Schedule__c 
                    where Policy__c =:accObj.Current_Policy__c order by Type__c ];
                }else if(policyName.equals('SBP')){
                    policyScheduleList = [select id,name,Issue_Date__c,Expiry_Date__c,Effective_Date__c,Maximum_Liability__c,Type__c,
                    Commencement_Date__c,Percentage_of_Indemnity__c,Policyholder_s_Address__c,Renewal_Date__c,
                    Policy__c,Policy__r.Product__r.Name,Policy__r.Name,
                    Policy_Deposit__c,Policy_Fee__c,Policy_Period__c,Maximum_Credit_Period__c,
                    Non_Qualifying_Loss_Amount__c,Exclusion_of_Risk__c,Buyer_Country_Market__c,
                    Amount_ref_to_in_Sub_cl_1_2_and_69_2__c,
                    Premium_Rate_On__c,
                    Base_Rate_Per_Quarter__c,
                    Base_Rate_Per_Anum__c,
                    Pre_Shipment__c,
                    DP__c,
                    OA1_60__c,
                    OA61_120__c,
                    Base_Loading__c,Policy_Holder_Name__c,CreatedDate

                    from Policy_Schedule__c 
                    where Policy__c =:accObj.Current_Policy__c and Type__c !='Schedule 4' order by Type__c ];
                }
                
             }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return policyScheduleList;
    }

    @AuraEnabled(cacheable = true)
    public static Account getPolicyHolderData(Id usrId){
        try {
            Id accountId = [Select contact.AccountId from user where id =:usrId].contact.AccountId;
            System.debug('getPolicyHolderData accountId : '+accountId);
            Account acc = [Select Id, Name, Is_Email_Verified__c, Current_Policy__c,
                            Current_Policy__r.Name,
                            Current_Policy__r.Status__c,
                            Current_Policy__r.Product__c,
                            Current_Policy__r.Product__r.Name,
                            Current_Policy__r.Product__r.Full_Name__c,
                            Current_Policy__r.Allow_Policy_Holder_To_Terminate__c,
                            Current_Policy__r.Commencement_Date__c,
                            Current_Policy__r.Maximum_Liability__c,
                            Current_Policy__r.Percentage_of_Indemnity__c,
                            Current_Policy__r.Issue_Date__c,
                            Current_Policy__r.Policyholder_s_Address__c,
                            Current_Policy__r.Expiry_Date__c,
                            Current_Policy__r.Renewal_Settings__c,
                            Current_Policy__r.Policy_Period__c
                            from Account where id =:accountId];
            return acc;
        }catch(Exception ex) {
            //res.message += ex.getMessage();
            System.debug('getPolicyHolderData exception at : '+ex.getMessage()+' stack trace '+ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static Boolean terminatePolicy(Id policyID,String reasonForTermination){
        Boolean isPolicyTerminated;
        try {
            Policy__c policyObj = [select Status__c,Exporter__c,Policy_Terminated_Date__c
             from Policy__c where id =: policyID];
            if(policyObj != null ){
                policyObj.Status__c = 'Expired';
                policyObj.Policy_Terminated_Date__c = System.today();
                policyObj.Reason_For_Termination__c = reasonForTermination;
                update policyObj;
                System.debug('Terminate Policy called!!!.');
                isPolicyTerminated = true;

                SendEmailApex.sendEmailAccount(policyObj.Exporter__c, policyID, 'Policy_Termination', false, null, null);
                
                // TaskManagement.createTask('Policy Holder Terminated', 
                // 'This Task is created for SME team head to acknowledge the policy termination',
                // 'High', 
                // 'type', 
                // 'assignedTo', 
                // String.valueOf(policyID),
                // null);
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return isPolicyTerminated;
    }
    public class WrapperEndorsement{
        @AuraEnabled
        public String Id{get;set;}
        @AuraEnabled
        public String name{get;set;}
        @AuraEnabled
        public String type{get;set;}
        @AuraEnabled
        public String vfPageUrl{get;set;}
        @AuraEnabled
        public Date issueDate{get;set;}
        @AuraEnabled
        public boolean isCarryForwardToNextYear{get;set;}
        @AuraEnabled
        public String buyerName{get;set;}
        @AuraEnabled
        public String buyerCountry{get;set;}
        @AuraEnabled
        public String buyerCode{get;set;}
    }
    @AuraEnabled
    public static List<WrapperEndorsement> fetchAllEndorsements(Id policyID){
        System.debug('Current URL : '+URL.getCurrentRequestUrl()+' Domain '+URL.getOrgDomainUrl()+' Base'+URL.getSalesforceBaseUrl().getHost());
        List<WrapperEndorsement>  allEndorsementList = new List<WrapperEndorsement>();
        try {
            
            for(Related_Endorsement__c endorse : [select id,Name,Issue_Date__c,Type__c,Endorsement_Type__r.Name,Policy__c,
                Carry_Forward_To_Next_Policy_Year__c,Cancelled_Date__c,Buyer_Name__c,Buyer_Country__c,Buyer_Code__c 
                from Related_Endorsement__c
                where Policy__c =: policyID and Status__c='Approved']){

                WrapperEndorsement wendorse = new WrapperEndorsement();
                wendorse.Id = endorse.id;
                wendorse.name = endorse.Name;
                wendorse.type = endorse.Endorsement_Type__r.Name;
                wendorse.issueDate = endorse.Issue_Date__c;
                wendorse.vfPageUrl = 'https://'+String.valueOf(URL.getSalesforceBaseUrl().getHost())+'/ECReach/apex/Endorsement_'+endorse.Endorsement_Type__r.Name+'?policyID='+endorse.Policy__c+'&endorsementID='+endorse.id;
                wendorse.isCarryForwardToNextYear = endorse.Carry_Forward_To_Next_Policy_Year__c;
                wendorse.buyerName = endorse.Buyer_Name__c;
                wendorse.buyerCountry = endorse.Buyer_Country__c;
                wendorse.buyerCode = endorse.Buyer_Code__c;
                allEndorsementList.add(wendorse);
            }
            System.debug('allEndorsementList : '+allEndorsementList);
        } catch (Exception e) {
            System.debug('Exception');
            throw new AuraHandledException(e.getMessage());
        }
        return allEndorsementList;
    }


    @AuraEnabled
    public static Boolean saveDynamicPrice(Id policyId,
        boolean isProductSup,
        boolean isProductSbp,
        String premiumRateOn,
        Decimal basePremiumRate,
        Decimal preShipment,
        Decimal indemnityRatio,
        Decimal nQL,
        boolean isCountryRisk,
        boolean isRepudiationRisk,
        Decimal DP,
        Decimal DA_OA_0_30,
        Decimal DA_OA_31_60,
        Decimal DA_OA_61_90,
        Decimal DA_OA_91_120,
        Decimal DP_NonA,
        Decimal DA_OA_0_30_NonA,
        Decimal DA_OA_31_60_NonA,
        Decimal DA_OA_61_90_NonA,
        Decimal DA_OA_91_120_NonA

    ){
        //System.debug('isProductOmbp : '+isProductOmbp+' isProductSup : '+isProductSup+' isProductSbp :'+isProductSbp);
        System.debug('premiumRateOn : '+premiumRateOn+' basePremiumRate : '+basePremiumRate+' preShipment :'+preShipment);
        System.debug('indemnityRatio : '+indemnityRatio+' nQL : '+nQL+' isCountryRisk :'+isCountryRisk+' isRepudiationRisk :'+isRepudiationRisk);
        System.debug('******DP : '+DP+' DA_OA_0_30 : '+DA_OA_0_30+' DA_OA_31_60 :'+DA_OA_31_60+' DA_OA_61_90 :'+DA_OA_61_90);
        System.debug('******DP_NonA : '+DP_NonA+' DA_OA_0_30_NonA : '+DA_OA_0_30_NonA+' DA_OA_31_60_NonA :'+DA_OA_31_60_NonA+' DA_OA_61_90_NonA :'+DA_OA_61_90_NonA+' DA_OA_91_120_NonA:'+DA_OA_91_120_NonA);

        boolean isSuccess=false;
        List<Policy_Schedule__c> polSchList = new List<Policy_Schedule__c>();
        List<Policy_Schedule__c> upPolSchList = new List<Policy_Schedule__c>();
        try {
            polSchList = [select id,Premium_Rate_On__c,Base_Rate_Per_Quarter__c,Base_Rate_Per_Anum__c,
                Pre_Shipment__c,Type__c,
                Backup_DP__c,Backup_DA_OA_0_30__c,Backup_DA_OA_31_60__c,Backup_DA_OA_61_90__c,Backup_DA_OA_91_120__c,
                Backup_DP_NonA__c,Backup_DA_OA_0_30_NonA__c,Backup_DA_OA_31_60_NonA__c,Backup_DA_OA_61_90_NonA__c,Backup_DA_OA_91_120_NonA__c
                from Policy_Schedule__c where Policy__c  =:policyId ];
            for(Policy_Schedule__c polSch : polSchList){
                if(polSch.Type__c.equals('Schedule 1')){


                }else if(polSch.Type__c.equals('Schedule 2')){
                    polSch.Backup_DP__c=DP;
                    polSch.Backup_DA_OA_0_30__c=DA_OA_0_30;
                    polSch.Backup_DA_OA_31_60__c=DA_OA_31_60;
                    polSch.Backup_DA_OA_61_90__c=DA_OA_61_90;
                    polSch.Backup_DA_OA_91_120__c=DA_OA_91_120;
                    polSch.Backup_DP_NonA__c=DP_NonA;
                    polSch.Backup_DA_OA_0_30_NonA__c=DA_OA_0_30_NonA;
                    polSch.Backup_DA_OA_31_60_NonA__c=DA_OA_31_60_NonA;
                    polSch.Backup_DA_OA_61_90_NonA__c=DA_OA_61_90_NonA;
                    polSch.Backup_DA_OA_91_120_NonA__c=DA_OA_91_120_NonA;
                    upPolSchList.add(polSch);
                }
            }
            System.debug('upPolSchList : '+upPolSchList);
            if(upPolSchList != null && !upPolSchList.isEmpty()){
                update upPolSchList;
                isSuccess=true;
            }
            
            System.debug('isSuccess : '+isSuccess);
        } catch (Exception e) {
            System.debug('Exception at saveDynamicPrice:'+e.getMessage()+' Stack :'+e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
        return isSuccess;
    }

    public class WrapperInvoice{
        @AuraEnabled
        public String Id{get;set;}
        @AuraEnabled
        public String name{get;set;}
        @AuraEnabled
        public String status{get;set;}
        @AuraEnabled
        public Date invoiceDate{get;set;}
        @AuraEnabled
        public Date dueDate{get;set;}
        @AuraEnabled
        public String premium{get;set;}
        @AuraEnabled
        public boolean invoiceCheckBox{get;set;}
        @AuraEnabled
        public boolean payReceiptCheckBox{get;set;}
        @AuraEnabled
        public String paymentID{get;set;}
        @AuraEnabled
        public List<Invoice_Line__c> invLine{get;set;} 
    }

    @AuraEnabled
    public static List<WrapperInvoice> getInvoiceData(Id usrId){
        List<WrapperInvoice> wrapInvList=new List<WrapperInvoice>();
        Map<String,String> mapOfInvoiceVsPay = new Map<String,String>();
        String accountId = getAccountID(usrId);
        System.debug('accountId------->>'+accountId);
        Account accObj=[select id,Current_Policy__c from Account  where id=:accountId ];
        List<Payment__c> payList = [select id,Invoice__c from Payment__c where Account__c = :accObj.id] ;
        for(Payment__c pay : payList){
            mapOfInvoiceVsPay.put(pay.Invoice__c,pay.id);
        }
        for(Invoice__c inv: [select id,name,Status__c,Due_Date__c,CreatedDate,Premium__c,Total_Net_Premium_Amount__c,
            Policy__r.Product__r.Name,
            (select id,name,Premium_Cycle__c,Gross_Invoice_Value__c,Line_Amount__c,Product__c,Credit_Limit__c,
            Credit_Limit_Application__c
            from Invoice_Lines__r where Credit_Limit_Application__c != null ) 
            from  Invoice__c where  Policy__c=:accObj.Current_Policy__c   ]){
                System.debug('Product :'+inv.Policy__r.Product__r.Name+' inv.name '+inv.name+' inv.id'+inv.id);
                WrapperInvoice wrapInv = new WrapperInvoice();
                wrapInv.Id = inv.id;
                wrapInv.name = inv.name;
                wrapInv.dueDate = inv.Due_Date__c;
                DateTime dT2 = inv.CreatedDate;
                if(inv.CreatedDate != null){
                    wrapInv.invoiceDate = Date.newInstance(dT2.year(), dT2.month(), dT2.day());
                }
                wrapInv.status = inv.Status__c;
                wrapInv.premium = String.valueOf(inv.Total_Net_Premium_Amount__c);
                wrapInv.invoiceCheckBox = false;
                wrapInv.payReceiptCheckBox = false;
                if(mapOfInvoiceVsPay != null && mapOfInvoiceVsPay.containsKey(inv.id)){
                    wrapInv.paymentID = mapOfInvoiceVsPay.get(inv.id); 
                }
                wrapInv.invLine = inv.Invoice_Lines__r;
                if(inv.Policy__r.Product__r.Name.equals('SUP')){
                    System.debug('Day Difference : '+Date.today().daysBetween(inv.Due_Date__c));
                    if(Date.today().daysBetween(inv.Due_Date__c) <15){
                        wrapInvList.add(wrapInv);
                    }
                }else{
                    wrapInvList.add(wrapInv);
                }
                
        }
        System.debug('wrapInvList '+wrapInvList);
        return wrapInvList;

    }
    @AuraEnabled
    public static ResponseData acknowledgePolicyTermination(String policyID){
        System.debug('acknowledgePolicyTermination policyID:'+policyID);
        ResponseData respDate=new ResponseData();
        try {
            Policy__c policyObj = [select id,Termination_Acknowledge_By_SME_Team_Head__c,Termination_Acknowledge_Date__c,
            Status__c from Policy__c where id =: policyID];
            if(policyObj != null && policyObj.Status__c.equals('Invalid') && !policyObj.Termination_Acknowledge_By_SME_Team_Head__c){
                policyObj.Termination_Acknowledge_By_SME_Team_Head__c = true;
                policyObj.Termination_Acknowledge_Date__c = System.now();
                update policyObj;
                System.debug('Acknowledgement for Policy Termination.');
                respDate.isSuccess=true;
                respDate.responseMsg='Policy Termination Acknowledged Successfully';
            }else{
                respDate.isSuccess=false;
                if(!policyObj.Status__c.equals('Invalid')){
                    respDate.responseMsg='Policy Is Not Terminated Yet';
                }else if(policyObj.Termination_Acknowledge_By_SME_Team_Head__c){
                    respDate.responseMsg='Already Acknowledged by SME Team Head';
                }
                
               
            }
        } catch (Exception e) {
            System.debug('acknowledgePolicyTermination Exception at '+e.getMessage()+' '+e.getStackTraceString());
            respDate.isSuccess=false;
            respDate.responseMsg=e.getMessage();
            throw new AuraHandledException(e.getMessage());
        }
        System.debug('acknowledgePolicyTermination respDate:'+respDate);
        return respDate;
    }

    @AuraEnabled
    public static boolean autoRenwalDateChecking(Date policyExpireyDate){
        System.debug('autoRenwalDateChecking policyExpireyDate : '+policyExpireyDate);
        boolean isDisabled=true;
        DateTime dT1 = System.now();
        Date currentDate = Date.newInstance(dT1.year(), dT1.month(), dT1.day());
        if(policyExpireyDate  != null){
            Integer daysBetween = currentDate.daysBetween(policyExpireyDate);
            System.debug('daysBetween : '+daysBetween);
            if(daysBetween>60){
                isDisabled=false;
            }
        }
        return isDisabled;
    }

    @AuraEnabled
    public static ResponseData upDateAutoRenewalSetting(String settings,String policyID){
        System.debug('upDateAutoRenewalSetting policyID:'+policyID+' settings : '+settings);
        ResponseData respDate=new ResponseData();
        try {
            Policy__c policyObj = [select id,Renewal_Settings__c from Policy__c where id =: policyID   ];
            if(policyObj != null){
                policyObj.Renewal_Settings__c = settings;
                update policyObj;
                System.debug('Renwal Setting updated.');
                respDate.isSuccess=true;
                respDate.responseMsg='Renwal Setting updated Successfully';
            }
        } catch (Exception e) {
            System.debug('Renwal Setting Exception at '+e.getMessage()+' '+e.getStackTraceString());
            respDate.isSuccess=false;
            respDate.responseMsg=e.getMessage();
            throw new AuraHandledException(e.getMessage());
        }
        System.debug('upDateAutoRenewalSetting respDate:'+respDate);
        return respDate;
    }

    

    public class WrapperPolicyHolderData{
        @AuraEnabled
        public String id{get;set;}
        @AuraEnabled
        public String issueDate{get;set;}
        @AuraEnabled
        public String issueDateOfFirstCL{get;set;}
        @AuraEnabled
        public String phName{get;set;}
        @AuraEnabled
        public String Proposal_Submission_Date{get;set;}
        @AuraEnabled
        public String Registered_Address_Line_1{get;set;}
        @AuraEnabled
        public String Registered_Address_Line_2{get;set;}
        @AuraEnabled
        public String Registered_Address_Line_3{get;set;}
        @AuraEnabled
        public String Registered_District{get;set;}
        @AuraEnabled
        public String Registered_Territory{get;set;}
        @AuraEnabled
        public Decimal Number_of_credit_limit_applications{get;set;}
        @AuraEnabled
        public String policyPeriod{get;set;}
        @AuraEnabled
        public String policyCommenceDate{get;set;}
        @AuraEnabled
        public String Cover_PDF_Link{get;set;}
        @AuraEnabled
        public String Schedule_1_Link{get;set;}
        @AuraEnabled
        public String Schedule_2_Link{get;set;}
        @AuraEnabled
        public String Schedule_3_Link{get;set;}
        @AuraEnabled
        public String Schedule_4_Link{get;set;}
        @AuraEnabled
        public String Document_Link{get;set;}
        @AuraEnabled
        public boolean isLimitedAccess{get;set;}
        @AuraEnabled
        public String limitedAccessDate{get;set;}
        @AuraEnabled
        public boolean isLimitedAccessWithinSixMonth{get;set;}
        @AuraEnabled
        public String policyStatus{get;set;}
        @AuraEnabled
        public boolean isPolTerminationWithinSixMonth{get;set;}
        
    }

    @AuraEnabled(cacheable = true)
    public static WrapperPolicyHolderData getWrapperPolicyHolderData(Id usrId){
        try {
            
            WrapperPolicyHolderData wrapPolicyHolderData = new WrapperPolicyHolderData();
            Id accountId = [Select contact.AccountId from user where id =:usrId].contact.AccountId;
            System.debug('getWrapperPolicyHolderData accountId : '+accountId);
            Map<id,Policy_Schedule__c> policyIdVsPolSchMap = new Map<id,Policy_Schedule__c>();
            Account accObj = [Select Id,Current_Policy__c from Account where id =:accountId];

            for(Policy_Schedule__c sch : [select Policy__c, Policy_Holder_Name__c from Policy_Schedule__c where Type__c='Schedule 1' and Policy__c=: accObj.Current_Policy__c  ]){
                policyIdVsPolSchMap.put(sch.Policy__c,sch);
            }
            System.debug('policyIdVsPolSchMap ==>>'+policyIdVsPolSchMap);
            for(Account acc : [Select Id, Name,
                    Is_Email_Verified__c, 
                    Current_Policy__c,
                    Current_Policy__r.Name,
                    Current_Policy__r.Status__c,
                    Current_Policy__r.Policy_Terminated_Date__c,
                    Current_Policy__r.Issue_Date__c,
                    Current_Policy__r.Proposal_Submission_Date__c,
                    Current_Policy__r.Issue_Date_Of_First_Credit_Limit__c,
                    Current_Policy__r.Product__r.Number_of_credit_limit_applications__c,
                    Current_Policy__r.Policy_Period__c,
                    Current_Policy__r.Commencement_Date__c,
                    Current_Policy__r.Cover_PDF_Link__c,
                    Current_Policy__r.Schedule_1_Link__c,
                    Current_Policy__r.Schedule_2_Link__c,
                    Current_Policy__r.Schedule_3_Link__c,
                    Current_Policy__r.Schedule_4_Link__c,
                    Current_Policy__r.Document_Link__c,

                    Registered_Address_Line_1__c,
                    Registered_Address_Line_2__c,
                    Registered_Address_Line_3__c,
                    Registered_District__c,
                    Registered_Territory__c,
                    Limited_Access__c,
                    Limited_Access_Date__c
                    from Account where id =:accountId]){

                wrapPolicyHolderData.id=acc.id;
                if(acc.Current_Policy__r.Issue_Date__c != null){
                    Date iDate = acc.Current_Policy__r.Issue_Date__c; 
                    wrapPolicyHolderData.issueDate = iDate.year()+'-'+ iDate.month()+'-'+ iDate.day();
                }
                if(acc.Current_Policy__r.Proposal_Submission_Date__c != null){
                    Date pSubDate = acc.Current_Policy__r.Proposal_Submission_Date__c; 
                    wrapPolicyHolderData.Proposal_Submission_Date = pSubDate.year()+'-'+ pSubDate.month()+'-'+ pSubDate.day();
                }
                wrapPolicyHolderData.issueDateOfFirstCL='N/A';
                if(acc.Current_Policy__r.Issue_Date_Of_First_Credit_Limit__c!=null){
                    Date firtstCLDate = acc.Current_Policy__r.Issue_Date_Of_First_Credit_Limit__c; 
                    wrapPolicyHolderData.issueDateOfFirstCL = firtstCLDate.year()+'-'+ firtstCLDate.month()+'-'+ firtstCLDate.day();
                }else{
                    wrapPolicyHolderData.issueDateOfFirstCL='N/A';
                }
                wrapPolicyHolderData.Number_of_credit_limit_applications = acc.Current_Policy__r.Product__r.Number_of_credit_limit_applications__c;
                
                wrapPolicyHolderData.Registered_Address_Line_1 = acc.Registered_Address_Line_1__c;
                wrapPolicyHolderData.Registered_Address_Line_2 = acc.Registered_Address_Line_2__c;
                wrapPolicyHolderData.Registered_Address_Line_3 = acc.Registered_Address_Line_3__c;
                wrapPolicyHolderData.Registered_District = acc.Registered_District__c;
                wrapPolicyHolderData.Registered_Territory = acc.Registered_Territory__c;
                wrapPolicyHolderData.policyPeriod = acc.Current_Policy__r.Policy_Period__c;
                if(policyIdVsPolSchMap != null && policyIdVsPolSchMap.containsKey(acc.Current_Policy__c)){
                    Policy_Schedule__c sch = policyIdVsPolSchMap.get(acc.Current_Policy__c);
                    if(sch != null ){
                        wrapPolicyHolderData.phName=sch.Policy_Holder_Name__c;
                    }
                }
                if(acc.Current_Policy__r.Commencement_Date__c != null){
                    Date comDate = acc.Current_Policy__r.Commencement_Date__c; 
                    wrapPolicyHolderData.policyCommenceDate = comDate.year()+'-'+ comDate.month()+'-'+ comDate.day();
                }
                wrapPolicyHolderData.Cover_PDF_Link = acc.Current_Policy__r.Cover_PDF_Link__c;
                wrapPolicyHolderData.Schedule_1_Link = acc.Current_Policy__r.Schedule_1_Link__c;
                wrapPolicyHolderData.Schedule_2_Link = acc.Current_Policy__r.Schedule_2_Link__c;
                wrapPolicyHolderData.Schedule_3_Link = acc.Current_Policy__r.Schedule_3_Link__c;
                wrapPolicyHolderData.Schedule_4_Link = acc.Current_Policy__r.Schedule_4_Link__c;
                wrapPolicyHolderData.Document_Link = acc.Current_Policy__r.Document_Link__c;
                wrapPolicyHolderData.isLimitedAccess = acc.Limited_Access__c;
                wrapPolicyHolderData.limitedAccessDate = String.valueOf(acc.Limited_Access_Date__c);
                if(acc.Limited_Access__c){
                    wrapPolicyHolderData.isLimitedAccessWithinSixMonth = accessChecking(acc.Limited_Access_Date__c);
                }
                wrapPolicyHolderData.policyStatus = acc.Current_Policy__r.Status__c;
                if(acc.Current_Policy__r.Policy_Terminated_Date__c!=null){
                    wrapPolicyHolderData.isPolTerminationWithinSixMonth = accessChecking(acc.Current_Policy__r.Policy_Terminated_Date__c);

                }
                
            }
            System.debug('wrapPolicyHolderData ==>>'+wrapPolicyHolderData);
            return wrapPolicyHolderData;
        }catch(Exception ex) {
            //res.message += ex.getMessage();
            System.debug('getWrapperPolicyHolderData exception at : '+ex.getMessage()+' stack trace '+ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
    }
    

    public class WrapperPHScheduleData{
        @AuraEnabled
        public String id{get;set;}
        @AuraEnabled
        public String policyNumber{get;set;}
        @AuraEnabled
        public String scheduleType{get;set;}
        @AuraEnabled
        public String scheduleIssueDate{get;set;}
        @AuraEnabled
        public String scheduleEffectiveDate{get;set;}
        @AuraEnabled
        public String policyCommenceDate{get;set;}
        @AuraEnabled
        public Decimal baseRatePerAnnum{get;set;}

        @AuraEnabled
        public Decimal DP{get;set;}
        @AuraEnabled
        public Decimal DA_OA_0_30{get;set;}
        @AuraEnabled
        public Decimal DA_OA_31_60{get;set;}
        @AuraEnabled
        public Decimal DA_OA_61_90{get;set;}
        @AuraEnabled
        public Decimal DA_OA_91_120{get;set;}

        @AuraEnabled
        public Decimal DP_NonA{get;set;}
        @AuraEnabled
        public Decimal DA_OA_0_30_NonA{get;set;}
        @AuraEnabled
        public Decimal DA_OA_31_60_NonA{get;set;}
        @AuraEnabled
        public Decimal DA_OA_61_90_NonA{get;set;}
        @AuraEnabled
        public Decimal DA_OA_91_120_NonA{get;set;}

        @AuraEnabled
        public Decimal Policy_deposit{get;set;}
        @AuraEnabled
        public Decimal Policy_fee{get;set;}
        @AuraEnabled
        public Boolean isScheduleSigned{get;set;}
        //**
        @AuraEnabled
        public String scheduleOneIssueDate {get;set;} 
        @AuraEnabled
        public String scheduleOneEffectiveDate {get;set;} 
        @AuraEnabled
        public String scheduleTwoIssueDate {get;set;} 
        @AuraEnabled
        public String scheduleTwoEffectiveDate {get;set;} 
        @AuraEnabled
        public String scheduleThreeIssueDate {get;set;} 
        @AuraEnabled
        public String scheduleThreeEffectiveDate {get;set;}
        @AuraEnabled
        public String scheduleFourIssueDate {get;set;}
        @AuraEnabled 
        public String scheduleFourEffectiveDate {get;set;} 
        @AuraEnabled
        public String coverIssueDate {get;set;} 
        @AuraEnabled
        public String DocumentIssueDate {get;set;} 
    }


    @AuraEnabled
    public static List<WrapperPHScheduleData> getWrapperAllSchedule(Id usrId){
        List<WrapperPHScheduleData> wrapSchList = new List<WrapperPHScheduleData>();
        ID accountId = getAccountID(usrId);
        String policyName; 
        List<Policy_Schedule__c> policyScheduleList = new List<Policy_Schedule__c>();
        List<sObject> sobjList; 
        try {
            Account accObj = [select id,name,Current_Policy__c,Current_Policy__r.Product__r.Name from Account where id =:accountId];
            if(accObj != null && accObj.Current_Policy__c != null){
                policyName = accObj.Current_Policy__r.Product__r.Name;
                 System.debug('Current_Policy__r.name : '+policyName);
                String Schedule;
                String wherePart1='';
                String firstPartOfQuery = 'select id,name,CreatedDate,Issue_Date__c,Expiry_Date__c,Effective_Date__c,Maximum_Liability__c,'+
                'Commencement_Date__c,Percentage_of_Indemnity__c,Policyholder_s_Address__c,Renewal_Date__c,'+
                'Policy__c,Policy__r.Product__r.Name,Policy__r.Name,Type__c,'+
                'Policy_Deposit__c,Policy_Fee__c,Policy_Period__c,Maximum_Credit_Period__c,'+
                'Non_Qualifying_Loss_Amount__c,Exclusion_of_Risk__c,Buyer_Country_Market__c,'+
                'DP__c,DA_OA_0_30__c,DA_OA_31_60__c,DA_OA_61_90__c,DA_OA_91_120__c,'+
                'DP_NonA__c,DA_OA_0_30_NonA__c,DA_OA_31_60_NonA__c,DA_OA_61_90_NonA__c,DA_OA_91_120_NonA__c';
                String secondPartOfQuery =
                ',Amount_ref_to_in_Sub_cl_1_2_and_69_2__c,Premium_Rate_On__c,Base_Rate_Per_Quarter__c,Base_Rate_Per_Anum__c,'+
                'Pre_Shipment__c,OA1_60__c,OA61_120__c,Base_Loading__c,Policy_Holder_Name__c,Policy__r.Commencement_Date__c'+
                ',Is_Schedule_Signed__c from Policy_Schedule__c where Policy__c =\''+accObj.Current_Policy__c+ '\'';
                System.Debug('firstPartOfQuery : '+firstPartOfQuery);
                System.Debug('secondPartOfQuery : '+secondPartOfQuery);
                if(policyName.equals('OMBP')){
                //    Schedule='Schedule 1';
                //    wherePart1=' and Type__c = \'' + Schedule + '\' order by Type__c ';
                Schedule = '(\'Schedule 1\',\'Policy Cover\',\'Policy Document\')';
                wherePart1=' and Type__c in ' + Schedule + ' order by Type__c ';
                }else if(policyName.equals('SUP')){
                   wherePart1=' order by Type__c ';
                }else if(policyName.equals('SBP')){
                    Schedule='Schedule 4';
                   wherePart1=' and Type__c!= \'' + Schedule + '\' order by Type__c ';
                }
                String mainQuery = firstPartOfQuery+' '+secondPartOfQuery+' '+wherePart1;
                System.debug('mainQuery===>>'+mainQuery);
                System.debug('wherePart1===>>'+wherePart1);
                policyScheduleList = Database.query(mainQuery);

                for(Policy_Schedule__c psch : policyScheduleList){
                    Datetime cDate = psch.CreatedDate;
                    WrapperPHScheduleData wrap = new WrapperPHScheduleData();
                    wrap.id = psch.id;
                    wrap.policyNumber=psch.Policy__r.Name;
                    wrap.isScheduleSigned = psch.Is_Schedule_Signed__c;

                    if(psch.Type__c!=null){
                        System.debug('psch.Type__c ==>>'+psch.Type__c);
                        wrap.scheduleType=psch.Type__c;
                        if(psch.Type__c.equals('Schedule 1')){
                            wrap.baseRatePerAnnum=psch.Base_Rate_Per_Anum__c;
                            wrap.Policy_fee = psch.Policy_Deposit__c !=null ? psch.Policy_Deposit__c : 0;
                            wrap.Policy_deposit = psch.Policy_Fee__c !=null ? psch.Policy_Fee__c : 0;
                            //wrap.scheduleOneIssueDate = cDate.year()+'-'+cDate.month()+'-'+cDate.day();
                            wrap.scheduleIssueDate = cDate.year()+'-'+cDate.month()+'-'+cDate.day();

                            if(psch.Policy__r.Commencement_Date__c != null){
                                Datetime comeDate = psch.Policy__r.Commencement_Date__c;
                                wrap.policyCommenceDate=comeDate.year()+'-'+comeDate.month()+'-'+comeDate.day();
                            }
                            if(psch.Effective_Date__c != null){
                                DateTime effDate = psch.Effective_Date__c;//.addDays(8);
                                //wrap.scheduleOneEffectiveDate = effDate.year()+'-'+effDate.month()+'-'+effDate.day();
                                wrap.scheduleEffectiveDate = effDate.year()+'-'+effDate.month()+'-'+effDate.day();
                            }
                        }else if(psch.Type__c.equals('Schedule 2')){
                            wrap.DP=psch.DP__c;
                            wrap.DA_OA_0_30=psch.DA_OA_0_30__c;
                            wrap.DA_OA_31_60=psch.DA_OA_31_60__c;
                            wrap.DA_OA_61_90=psch.DA_OA_61_90__c;
                            wrap.DA_OA_91_120=psch.DA_OA_91_120__c;

                            wrap.DP_NonA=psch.DP_NonA__c;
                            wrap.DA_OA_0_30_NonA=psch.DA_OA_0_30_NonA__c;
                            wrap.DA_OA_31_60_NonA=psch.DA_OA_31_60_NonA__c;
                            wrap.DA_OA_61_90_NonA=psch.DA_OA_61_90_NonA__c;
                            wrap.DA_OA_91_120_NonA=psch.DA_OA_91_120_NonA__c;

                            wrap.scheduleIssueDate = cDate.year()+'-'+cDate.month()+'-'+cDate.day();
                            if(psch.Effective_Date__c != null){
                                DateTime effDate = psch.Effective_Date__c;//.addDays(8);
                                wrap.scheduleEffectiveDate = effDate.year()+'-'+effDate.month()+'-'+effDate.day();
                            }
                        }else if(psch.Type__c.equals('Schedule 3')){
                            wrap.scheduleIssueDate = cDate.year()+'-'+cDate.month()+'-'+cDate.day();
                            if(psch.Effective_Date__c != null){
                                DateTime effDate = psch.Effective_Date__c;//.addDays(8);
                                wrap.scheduleEffectiveDate = effDate.year()+'-'+effDate.month()+'-'+effDate.day();
                            }
                        }else if(psch.Type__c.equals('Schedule 4')){
                            wrap.scheduleIssueDate = cDate.year()+'-'+cDate.month()+'-'+cDate.day();
                            if(psch.Effective_Date__c != null){
                                DateTime effDate = psch.Effective_Date__c;//.addDays(8);
                                wrap.scheduleEffectiveDate = effDate.year()+'-'+effDate.month()+'-'+effDate.day();
                            }
                        }else if(psch.Type__c.equals('Policy Cover')){
                            wrap.coverIssueDate = cDate.year()+'-'+cDate.month()+'-'+cDate.day();
                        }else if(psch.Type__c.equals('Policy Document')){
                            wrap.DocumentIssueDate = cDate.year()+'-'+cDate.month()+'-'+cDate.day();
                        }
                    }
                   
                    // if(psch.CreatedDate != null){
                    //     Datetime cDate = psch.CreatedDate;//
                    //     wrap.scheduleIssueDate=cDate.year()+'-'+cDate.month()+'-'+cDate.day();
                    // }

                    
                    // if(psch.CreatedDate != null){
                    //     Datetime effDate = psch.CreatedDate.addDays(9);
                    //     wrap.scheduleEffectiveDate=effDate.year()+'-'+effDate.month()+'-'+effDate.day();
                    // }
                    wrapSchList.add(wrap);
                }
                System.debug('wrapSchList====>>'+wrapSchList);
            }
        } catch (Exception e) {
            System.debug('Exception at : '+e.getMessage()+' Stack : '+e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
        return wrapSchList;
    }

    
    @AuraEnabled
    public static List<Dynamic_Price__c> getDynmaicPricing(String policyId,String productId){
        List<Dynamic_Price__c> priceList = new List<Dynamic_Price__c>();
        Decimal finalLoading;
        Decimal exclusionRisk;
        String finalLoadingInText;
        Map<id,Decimal> policyVsFinalLoadingMap = new Map<id,Decimal>();
        try {
            List<Policy_Schedule__c> policyScheduleList = [select Policy__c,Base_Loading__c , Non_Qualifying_Loss_Amount__c, Exclusion_of_Risk__c,
            Percentage_of_Indemnity__c from Policy_Schedule__c where Policy__c =:policyId and Type__c='Schedule 1' ];
            for(Policy_Schedule__c sch :  policyScheduleList){

                if(sch.Base_Loading__c != null && sch.Percentage_of_Indemnity__c!= null && sch.Exclusion_of_Risk__c!=null){
                    exclusionRisk = sch.Exclusion_of_Risk__c == 'Country Risk' ? -5 : sch.Exclusion_of_Risk__c == 'Repudiation Risk' ? -10 : 0;
                    finalLoading = Integer.valueOf(sch.Base_Loading__c) + sch.Percentage_of_Indemnity__c  + exclusionRisk;
                    policyVsFinalLoadingMap.put(sch.Policy__c,finalLoading);
                    if(sch.Non_Qualifying_Loss_Amount__c != null){
                        System.debug('NQL is there');
                        finalLoading = finalLoading + sch.Non_Qualifying_Loss_Amount__c;
                        policyVsFinalLoadingMap.put(sch.Policy__c,finalLoading);
                    }
                }
            }
            System.debug('policyVsFinalLoadingMap : '+policyVsFinalLoadingMap);

            priceList= [select Id, Name, Base_Rate_Per_Anum__c, Base_Rate_Per_Quarter__c, Credit_Limit__c,
                Indemnity_Ratio__c, Maximum_Liability__c, Non_Qualify_Loss__c, Premium_Rate_On__c, Product__c,
                DP__c, DA_OA_0_30__c, DA_OA_31_60__c, DA_OA_61_90__c, DA_OA_91_180__c ,Loading__c,Country_Grade__c
                from Dynamic_Price__c where Price_Book__r.Active__c = true and Product__c=:productId and 
                Loading__c=:String.valueOf(policyVsFinalLoadingMap.get(policyId))];
        } catch (Exception e) {
            System.debug('Exception at getDynmaicPricing : '+e.getMessage()+' Stack : '+e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
        System.debug('priceList==>>'+priceList);
        return priceList;
    }

    @AuraEnabled
    public static boolean checkCarryForwardEndorsement(Id relEndId,boolean isCarryForward){
        System.debug('checkCarryForwardEndorsement relEndId : '+relEndId);
        boolean isSuccess=false;
        try {
            List<Related_Endorsement__c> relEndList = new List<Related_Endorsement__c>();
            for(Related_Endorsement__c relEnd : [select Carry_Forward_To_Next_Policy_Year__c,Cancelled_Date__c from Related_Endorsement__c where id=:relEndId]){
                relEnd.Carry_Forward_To_Next_Policy_Year__c = isCarryForward;
                if(!isCarryForward){
                    relEnd.Cancelled_Date__c=Date.valueOf(System.now());
                }
                relEndList.add(relEnd);
            }
            if(relEndList !=null && !relEndList.isEmpty()){
                update relEndList;
                System.debug('Related Endorsement updated');
                isSuccess=true;
            }
        } catch (Exception ex) {
            System.debug('Exception at checkCarryForwardEndorsement :'+ex.getMessage()+' stack : '+ex.getStackTraceString());
        }
        System.debug('isSuccess ==>>'+isSuccess);
        return isSuccess;
        
    }
    @AuraEnabled
    public static Plan__c getProductDetails(Id usrId){
        System.debug('getProductDetails ===>'+usrId);
        try {
            Id accountId = [Select contact.AccountId from user where id =:usrId].contact.AccountId;
            Account acc = [Select Id, Name, Current_Policy__r.Product__c from Account where id =:accountId];
            Plan__c product = [select id,name,Default_Payment_Term_Type__c,Default_Payment_Term_Days__c
                                from Plan__c where id = :acc.Current_Policy__r.Product__c ];
            System.debug('product ==>'+product);
            return product;
        } catch (Exception e) {
            System.debug('Exception at getProductDetails : '+e.getMessage()+' Stack :'+e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static boolean accessChecking(Date limitedAccessDate) {
        boolean isLimitedAccessWithinSixMonth=false;
        System.debug('accessChecking called : '+limitedAccessDate);

        if(limitedAccessDate != null){
            System.debug('Day Difference :'+Date.today().daysBetween(limitedAccessDate.addMonths(6)) );
            if (Date.today().daysBetween(limitedAccessDate.addMonths(6)) >= 0 ) {
                isLimitedAccessWithinSixMonth=true;
            }
        }
        System.debug('isLimitedAccessWithinSixMonth ===>>'+isLimitedAccessWithinSixMonth);
        return isLimitedAccessWithinSixMonth;
    }
}