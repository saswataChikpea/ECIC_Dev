@isTest
public with sharing class TestPolicyDocument_Pdf_controller {
    @isTest
    static void testMethodFirst() {
        Map<String,String> respMap = TestDataFactory.testDataSetupThree();
        Invoice__c invObj = [select id from Invoice__c where id =:respMap.get('invoiceID')];
        PageReference pageRef = Page.PolicyInvoice;
        pageRef.getParameters().put('invoiceId', respMap.get('invoiceID'));
        pageRef.getParameters().put('policyId', respMap.get('policyID'));
        pageRef.getParameters().put('endorsementID', respMap.get('endorsementID'));
        
        pageRef.getParameters().put('renderAs', 'PDF');
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.standardController(invObj);
        PolicyDocument_Pdf_controller policyInv = new PolicyDocument_Pdf_controller();
    }

    @isTest
    static void testMethodSecond() {
        Map<String,String> respMap = TestDataFactory.testDataSetupThree();
        Plan__c prodSBP= new Plan__c();
        prodSBP.name='SBP';
        prodSBP.Max_Authorised_Person_Count__c=10;
        prodSBP.Max_Beneficiary_Count__c=10;
        prodSBP.Max_Director_Count__c=10;
        insert prodSBP;
        Invoice__c invObj = [select id from Invoice__c where id =:respMap.get('invoiceID')];
        Policy__c pol = [select name,Product__c from Policy__c where id = :respMap.get('policyID')];
        pol.Product__c=prodSBP.id;
        update pol;
        PageReference pageRef = Page.PolicyInvoice;
        pageRef.getParameters().put('invoiceId', respMap.get('invoiceID'));
        pageRef.getParameters().put('policyId', respMap.get('policyID'));
        pageRef.getParameters().put('endorsementID', respMap.get('endorsementID'));
        pageRef.getParameters().put('renderAs', 'PDF');
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.standardController(invObj);
        PolicyDocument_Pdf_controller policyInv = new PolicyDocument_Pdf_controller();
        
        
    }
    @isTest
    static void testMethodThree() {
        Map<String,String> respMap = TestDataFactory.testDataSetupThree();
        Plan__c prodSBP= new Plan__c();
        prodSBP.name='SUP';
        prodSBP.Max_Authorised_Person_Count__c=10;
        prodSBP.Max_Beneficiary_Count__c=10;
        prodSBP.Max_Director_Count__c=10;
        insert prodSBP;
        Invoice__c invObj = [select id from Invoice__c where id =:respMap.get('invoiceID')];
        Policy__c pol = [select name,Product__c from Policy__c where id = :respMap.get('policyID')];
        pol.Product__c=prodSBP.id;
        update pol;
        PageReference pageRef = Page.PolicyInvoice;
        pageRef.getParameters().put('invoiceId', respMap.get('invoiceID'));
        pageRef.getParameters().put('policyId', respMap.get('policyID'));
        pageRef.getParameters().put('endorsementID', respMap.get('endorsementID'));
        pageRef.getParameters().put('renderAs', 'PDF');
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.standardController(invObj);
        PolicyDocument_Pdf_controller policyInv = new PolicyDocument_Pdf_controller();
        
        
    }
}