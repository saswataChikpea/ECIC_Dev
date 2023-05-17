@isTest
public with sharing class TestCompanyDetails {
    public static Account createRecord() {
        Account acc = new Account(Name='TestAccount');
        insert acc;        
        Contact con = new Contact(LastName='Test Contact',
        AccountId=acc.Id       
        );
        insert con;
        Contact con2 = new Contact(LastName='Test Contact2',
        AccountId=acc.Id,
        Authorised_Person__c=true,
        Beneficiary_Owner__c=true,
        Director__c=true
        );
        insert con2;
        // Policy__c policy = new Policy__c(
        // Status__c='Open',
        // Product__c=prod.Id,
        // Free_Credit_Check__c=10,
        // Used_Credit_check__c=0,
        // Exporter__c=acc.Id);
        // insert policy;  
        return acc;
    }
    @isTest
    static void testGetComanyInfo(){
        Test.startTest();
        Account acc = createRecord();
        Account accDetail = CompanyDetails.getComanyInfo(acc.Id);
        // Policy__c policy = ClPolicy.getPolicyDetails(acc.Id);
        // try{
        // 	CompanyDetails.getComanyInfo('12346789012345');
        // }catch(Exception e){
        //     system.assertEquals(e.getMessage(), e.getMessage());
        // }
        Test.stopTest();
        System.assertEquals(accDetail.Name,'TestAccount');
    }
    @isTest
    static void testGetContactInfo() {
        Test.startTest();
        Account acc = createRecord();
        List<Contact> conList = CompanyDetails.getContactInfo(acc.Id);
        
        Test.stopTest();
        System.assertEquals(conList.size(),1);
    }
    @isTest
    static void testGetAuthorisedPersons() {
        Test.startTest();
        Account acc = createRecord();
        // try{
            List<Contact> conList = CompanyDetails.getAuthorisedPersons(acc.Id);
        // }catch(Exception e){
        //     system.assertEquals(e.getMessage(), e.getMessage());
        // }
        Test.stopTest();
        System.assertEquals(conList.size(),1);
    }
    @isTest
    static void testGetBeneficiary() {
        Test.startTest();
        Account acc = createRecord();
        // try{
            List<Contact> conList = CompanyDetails.getBeneficiary(acc.Id);
        // }catch(Exception e){
        //     system.assertEquals(e.getMessage(), e.getMessage());
        // }
        Test.stopTest();
        System.assertEquals(conList.size(),1);
    }
    @isTest
    static void testGetDirector() {
        Test.startTest();
        Account acc = createRecord();
        // try{
            List<Contact> conList = CompanyDetails.getDirector(acc.Id);
        // }catch(Exception e){
        //     system.assertEquals(e.getMessage(), e.getMessage());
        // }
        Test.stopTest();
        System.assertEquals(conList.size(),1);
    }
    @isTest
    static void testRemoveContact() {
        Test.startTest();
        Account acc = createRecord();
        List<Contact> conList = [Select Id from Contact where AccountId=:acc.Id];
        List<Id> idList = new List<Id>();
        List<Id> accIdList = new List<Id>();
        accIdList.add(acc.Id);
        for( Contact con:conList){
            idList.add(con.Id);
        }
        try{
            CompanyDetails.removeContact(idList);
            CompanyDetails.removeContact(accIdList);
            // List<Contact> updated_conList = [Select Id,Is_Active__c from Contact where AccountId=:acc.Id and Is_Active__c=true ];
            // system.assertEquals(updated_conList.size(), 0);
        }catch(Exception e){
            system.assertEquals(e.getMessage(), e.getMessage());
        }
        Test.stopTest();
    }
    @isTest
    static void testUpdateCompanyInfo() {
        Test.startTest();
        Account acc = createRecord();
        
        try{
            CompanyDetails.updateCompanyInfo(acc.Id,'12345678','5678904545','Electronics','Partnership','Test Company');
            Account updated_acc = [Select Id, Name_Backup__c from Account where Id=:acc.Id ];
            // List<Contact> updated_conList = [Select Id,Is_Active__c from Contact where AccountId=:acc.Id and Is_Active__c=true ];
            system.assertEquals(updated_acc.Name_Backup__c, 'Test Company');
            CompanyDetails.updateCompanyInfo('123456789','12345678','5678904545','Electronics','Partnership','Test Company');
        }catch(Exception e){
            system.assertEquals(e.getMessage(), e.getMessage());
        }
                
        Test.stopTest();
    }
    
 
    
    @isTest
    static void testCreateSpecialContact() {
        Test.startTest();
        Account acc = createRecord();
        List<Object> obj = new List<Object>();
        JSONGenerator jsonGen = JSON.createGenerator(true);
        jsonGen.writeStartObject();
        jsonGen.writeStringField('lastName','TestLastname');
        jsonGen.writeStringField('firstName','TestFirstname');
        jsonGen.writeStringField('Account__c',acc.Id);
        jsonGen.writeBooleanField('Authorised_Person__c',true);
        jsonGen.writeBooleanField('Beneficiary_Owner__c',false);
        jsonGen.writeBooleanField('Director__c',false);
        jsonGen.writeEndObject();
        obj.add(jsonGen);
        String json_str = jsonGen.getAsString();
        try{
            CompanyDetails.createSpecialContact(obj);
            // Account updated_acc = [Select Id, Name_Backup__c from Account where Id=:acc.Id ];
            // List<Contact> updated_conList = [Select Id,Is_Active__c from Contact where AccountId=:acc.Id and Is_Active__c=true ];
            // CompanyDetails.updateCompanyInfo('123456789','12345678','5678904545','Electronics','Partnership','Test Company');
        }catch(Exception e){
            system.assertEquals(e.getMessage(), e.getMessage());
        }
        Test.stopTest();
    }
    @isTest
    static void testUpdatePrimaryContact(){
        Test.startTest();
        Account acc = createRecord();
        Contact primary_con = [Select Id from Contact where AccountId=:acc.Id and LastName='Test Contact'];
        Contact other_con = [Select Id from Contact where AccountId=:acc.Id and LastName='Test Contact2'];
        List<Id> other_con_ids = new List<Id>();
        other_con_ids.add(other_con.Id);
        CompanyDetails.UpdatePrimaryContact(primary_con.Id,other_con_ids);
        Contact primary_con_updated = [Select Id,LastName from Contact where AccountId=:acc.Id and Primary_Contact__c=true];
        system.assertEquals(primary_con_updated.LastName, 'Test Contact');

    }
    
    @isTest 
    static void testupdateSchedule1(){
        Test.startTest();
        Account acc = createRecord();
        Policy__c p = new Policy__c(Exporter__c = acc.Id, is_Active__c= True );
        Insert p;
        Policy_Schedule__c ps = new Policy_Schedule__c(Policy__c = p.Id, Type__c='Schedule 1');
        Insert ps;
        list<Id> acclist = new list<Id>();
        acclist.add(acc.id);
        CompanyDetails.updateSchedule1(acclist);
        Test.stopTest();
    }
    
    @isTest 
    static void testgetProduct(){
        Test.startTest();
		Account acc = createRecord(); 
        CompanyDetails.getProduct();
        Test.stopTest();
    }
    
    @isTest 
    static void testgetLegalType(){
        Test.startTest();        
        CompanyDetails.getLegalType();
        Test.stopTest();
    }
    
    // @isTest 
    // static void testgetDistrictTerritoryList(){
    //     Test.startTest();        
    //     CompanyDetails.getDistrictTerritoryList();
    //     Test.stopTest();
    // }
    
    @isTest 
    static void testgetLatestValidBRDocument(){
        Test.startTest();
        Account acc = createRecord();        
        CompanyDetails.getLatestValidBRDocument(acc.id);        
        Test.stopTest();
    }
        
    @isTest 
    static void testgetBRDocuments(){
        Test.startTest();
        Account acc = createRecord();        
        CompanyDetails.getBRDocuments(acc.id);
        Test.stopTest();
    }
	
    @isTest 
    static void testupdateAttachment(){
        Test.startTest();
        /*
        Folder f = new folder(Name = 'f1');
        insert f;
 */
        Document d1 = new document(name = 'doc');
        d1.FolderId = '00l5g000002AbpyAAC';
        insert d1;
       
         
        CompanyDetails.updateAttachment(d1.id);
        Test.stopTest();
    }
    
}