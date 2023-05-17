public with sharing class CompanyDetails {
    @AuraEnabled
    public static Account getComanyInfo(Id acc_id) {
        // try{
            return[ Select Id,Name,Registration_Number__c,Phone,Goods_or_Services__c,Legal_Type__c,Bank_Account__c,Language_of_Correspondence__c,Registered_Address_Line_1__c,Registered_Address_Line_2__c,Registered_Address_Line_3__c,Registered_District__c,Registered_Territory__c,Correspondence_Address_Line_1__c,Correspondence_Address_Line_2__c,Correspondence_Address_Line_3__c,Correspondence_District__c,Correspondence_Territory__c,Is_Under_Review__c,Completed_Tutorial__c,Mobile__c from Account where Id=:acc_id];
        // } catch (Exception e) {
        //     System.debug('Exception='+e.getMessage());
        //     throw new AuraHandledException(e.getMessage());
        // }
    }
    @AuraEnabled
    public static string getPolicyType(Id acc_id) {
        try{
            List<Policy__c> policy = [ Select Id,Name,Legacy_Policy_Type__c from Policy__c where Exporter__c = :acc_id and Is_Active__c=true];
            if(policy.size()>0) {
                return policy[0].Legacy_Policy_Type__c;
            } else {
                List<Proposal__c> proposal = [ Select Id,Policy_Type__c from Proposal__c where Account__c = :acc_id order by CreatedDate desc];
                if(proposal.size()>0) {
                    return proposal[0].Policy_Type__c;
                }
            }
            return '';
        } catch (Exception e) {
            System.debug('Exception='+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<Contact> getContactInfo(Id acc_id) {
        // try{
            return[ Select Id,FirstName,LastName,Phone,Email,Position__c,Primary_Contact__c,Enable_Email_Notification__c,Enable_SMS_Notification__c from Contact where AccountId=:acc_id and Authorised_Person__c=:false and Beneficiary_Owner__c=:false and Director__c=:false and Is_Active__c=:true];
        // } catch (Exception e) {
        //     throw new AuraHandledException(e.getMessage());
        // }
    }
    @AuraEnabled
    public static List<Contact> getAuthorisedPersons(Id acc_id) {
        // try{
            return[ Select Id,Name,Phone,Email,Position__c,Primary_Contact__c,Enable_Email_Notification__c,Enable_SMS_Notification__c,Nationality__c,Birthdate,MobilePhone from Contact where AccountId=:acc_id and Authorised_Person__c=:true and Is_Active__c=:true];
        // } catch (Exception e) {
        //     throw new AuraHandledException(e.getMessage());
        // }
    }
    @AuraEnabled
    public static List<Contact> getBeneficiary(Id acc_id) {
        // try{
            return[ Select Id,Name,Phone,Email,Position__c,Primary_Contact__c,Enable_Email_Notification__c,Enable_SMS_Notification__c,Nationality__c,Birthdate,MobilePhone from Contact where AccountId=:acc_id and Beneficiary_Owner__c=:true and Is_Active__c=:true];
        // } catch (Exception e) {
        //     throw new AuraHandledException(e.getMessage());
        // }
    }
    @AuraEnabled
    public static List<Contact> getDirector(Id acc_id) {
        // try{
            return[ Select Id,Name,Phone,Email,Position__c,Primary_Contact__c,Enable_Email_Notification__c,Enable_SMS_Notification__c,Nationality__c,Birthdate,MobilePhone from Contact where AccountId=:acc_id and Director__c=:true and Is_Active__c=:true];
        // } catch (Exception e) {
        //     throw new AuraHandledException(e.getMessage());
        // }
    }
    @AuraEnabled
    public static void removeContact(List<Id> contact_id){
        List<Contact> contactList = new List<Contact>();
        Contact con;
        try {
            for(Id each_id:contact_id) {
                con = new Contact(Id=each_id,
                Is_Active__c=false
                );
                contactList.add(con);
            }
            if(contactList.size()>0) {
                update contactList;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static Boolean updateCompanyInfo(Id acc_id,string reg_no,string phone,string goods,string legal_type,String name){
        Account acc = new Account();
        try{
            acc.Id = acc_id;
            acc.Name_Backup__c = name;
            acc.Registration_Number_Backup__c = reg_no;
            acc.Phone_Backup__c = phone;
            acc.Goods_or_Services_Backup__c = goods;
            acc.Legal_Type_Backup__c = legal_type;
            update acc;
            return true;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static void createSpecialContact(List<Object> cust_json) {
        List<Custom_Contact__c> contact = new List<Custom_Contact__c>();
        System.debug('createSpecialContact');
        try{
            for(Object cont_obj:cust_json) {
                System.debug('cont_obj='+cont_obj);
                
                //Map<String,Object> ind = (Map<String,Object> )cont_obj;
                String json_instance = Json.serialize(cont_obj);
                Map<String, Object> untyped_instance = (Map<String, Object>)JSON.deserializeUntyped(json_instance);
                System.debug('lastname='+untyped_instance.get('lastName'));
                System.debug('Authorised_Person__c='+untyped_instance.get('Authorised_Person__c'));
                contact.add(new Custom_Contact__c(Contact_Last_Name__c=(String)untyped_instance.get('lastName'),
                First_Name__c=(String)untyped_instance.get('firstName'),
                Account__c=(String)untyped_instance.get('Account__c'),
                Authorised_Person__c=(Boolean)untyped_instance.get('Authorised_Person__c'),
                Beneficiary_Owner__c=(Boolean)untyped_instance.get('Beneficiary_Owner__c'),
                Director__c=(Boolean)untyped_instance.get('Director__c')));
            }
            if(contact.size()>0) {
                insert contact;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }  
    }
    @AuraEnabled
    public static string UpdatePrimaryContact(Id primary_contact_id,List<Id> other_contacts){
        List<Contact> contactList = new List<Contact>();
        try {
            contactList.add(New Contact(Id=primary_contact_id,
            Primary_Contact__c=true,
            Enable_Email_Notification__c=true
            ));
            For(Id each_id:other_contacts){
                contactList.add(New Contact(Id=each_id,
                Primary_Contact__c=false,
                Enable_SMS_Notification__c=false
                ));           
            }
            if(contactList.size()>0){
                update contactList;
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return 'Contact updated successfully';
    }
    @AuraEnabled
    public static void updateAttachment(Id doc_id){
        try {
            ContentDocument attch = new ContentDocument(Id=doc_id);
            attch.Description='TEST';
            update attch;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<ECIC_Document__c> getBRDocuments(Id acc_id){
        try {
            List<ECIC_Document__c> br_docs = [Select Id,Name,Expiry_Date__c,Received_Date__c,BR_Number__c,Document_Id__c,Document_Link__c,Status__c from ECIC_Document__c where Account__c=:acc_id and Document_Type__c='BR Document' ];
            return br_docs;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<ECIC_Document__c> getLatestValidBRDocument(Id acc_id){
        try {
            List<ECIC_Document__c> ecic_docs = [Select Id,Name,Expiry_Date__c,Received_Date__c,BR_Number__c,Document_Id__c,Status__c from ECIC_Document__c where Account__c=:acc_id and Document_Type__c='BR Document' and Status__c='Valid' Order by Name desc limit 1];
            return ecic_docs;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<District__mdt> getDistrictTerritoryList(){
        try {
            List<District__mdt> map_cn = [select Id,District__c,District_Region__c,Sub_District__c,District_Territory__c from District__mdt];
            return map_cn;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<Legal_Type__mdt> getLegalType(){
        try {
            List<Legal_Type__mdt> map_cn = [select Id,code__c,code_desc__c,code_group__c,code_value__c from Legal_Type__mdt];
            return map_cn;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<Product__mdt> getProduct(){
        try {
            List<Product__mdt> map_cn = [select Id,PRD_CODE__c,PRD_DESC__c from Product__mdt];
            return map_cn;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @InvocableMethod (label='Update Schedule1')
    public static void updateSchedule1(List<Id> acc_ids) {
        try{
            // String acc_id = acc_list[0].Id;
            Account acc = [select Id,Registered_Address_Line_1__c,Registered_Address_Line_2__c,Registered_Address_Line_3__c,Registered_District__c,Registered_Territory__c from Account where id=:acc_ids[0]];
            Policy_Schedule__c schedule1 = [select Id from Policy_Schedule__c where Policy__c in (select Id from Policy__c where Exporter__c=:acc_ids[0] and Is_Active__c=true) and Type__c='Schedule 1'];
            System.debug('schedule1='+schedule1);
            Policy_Schedule__c new_schedule1 = new Policy_Schedule__c(Id=schedule1.Id,
                Registered_Address_Line_1__c = acc.Registered_Address_Line_1__c,
                Registered_Address_Line_2__c = acc.Registered_Address_Line_2__c,
                Registered_Address_Line_3__c = acc.Registered_Address_Line_3__c,
                Registered_Territory__c = acc.Registered_Territory__c,
                Registered_District__c = acc.Registered_District__c
            );
            update new_schedule1;
        } catch (Exception e) {
            System.debug('Exception'+e.getMessage());
        }
    }
}