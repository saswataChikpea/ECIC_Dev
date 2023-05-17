global with sharing class TestPDFController {

    global Apexpages.StandardController stdcon;  
    
    global String recordID{ get; set {TestPDFController(value);} }
    
    /*     public InvoicePdfController(ApexPages.StandardController controller){
        this.stdcon = (Contact)controller.getRecord();
    }*/
    
    Public List<Account> ListAccount {get;set;}
    Public List<Contact> ListContact {get;set;}
    
    global String AccName {get;set;}
    public List<Integer> repeatnumber{get;set;}
    
    Public void TestPDFController(String accID){
        try{
            ListAccount = [Select Id,Name, AccountNumber, Bank_Account__c, Is_Active__c,Is_Email_Verified__c,
                    (SELECT ID, Name, FirstName, LastName, Email FROM Contacts) 
                    FROM Account ORDER BY Name limit 990];
            repeatnumber= new List<Integer>();
            AccName = ListAccount[0].Name;
            for(integer i=0; i<4;i++)
            	repeatnumber.add(i);
            system.debug('ListAccount ====> '+ListAccount);  
        }catch(exception e){
            System.debug('Exception Message===>' + e.getMessage() + '==>Line Number==>'+ e.getLineNumber()+'==>class==>>'+e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(APEXPAGES.SEVERITY.FATAL, 'Unable to generate values Properly.. Please try Again'));
        }
    }
    
}