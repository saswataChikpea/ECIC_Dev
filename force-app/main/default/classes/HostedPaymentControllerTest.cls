@isTest
public with sharing class HostedPaymentControllerTest {
    @isTest
    static void firstMethod() {
       Map<String,String> respMap = TestDataFactory.testDataSetupThree();
       Invoice__c invObj = [select id from Invoice__c where id =:respMap.get('invoiceID')];
       PageReference pageRef = Page.HostedPaymentPage;
       pageRef.getParameters().put('invoiceID', respMap.get('invoiceID'));
       pageRef.getParameters().put('language', 'en_US');
       Test.setCurrentPage(pageRef);
       ApexPages.StandardController sc = new ApexPages.standardController(invObj);
       HostedPaymentController hostedController = new HostedPaymentController(sc);
       hostedController.getParametersValues();
       hostedController.getParametersValuesHidden();
       hostedController.getSignedData();
    }
    @isTest
    static void secondMethod() {
       Map<String,String> respMap = TestDataFactory.testDataSetupThree();
       Invoice__c invObj = [select id from Invoice__c where id =:respMap.get('invoiceID')];
       PageReference pageRef = Page.HostedPaymentPage;
       pageRef.getParameters().put('invoiceID', respMap.get('invoiceID'));
       pageRef.getParameters().put('language', 'zh_CN');
       Test.setCurrentPage(pageRef);
       ApexPages.StandardController sc = new ApexPages.standardController(invObj);
       HostedPaymentController hostedController = new HostedPaymentController(sc);
       hostedController.getParametersValues();
       hostedController.getParametersValuesHidden();
       hostedController.getSignedData();

    }
    @isTest
    static void thirdMethod() {
       Map<String,String> respMap = TestDataFactory.testDataSetupThree();
       Invoice__c invObj = [select id from Invoice__c where id =:respMap.get('invoiceID')];
       PageReference pageRef = Page.HostedPaymentPage;
       pageRef.getParameters().put('invoiceID', respMap.get('invoiceID'));
       pageRef.getParameters().put('language', 'zh_TW');
       Test.setCurrentPage(pageRef);
       ApexPages.StandardController sc = new ApexPages.standardController(invObj);
       HostedPaymentController hostedController = new HostedPaymentController(sc);
       hostedController.getParametersValues();
       hostedController.getParametersValuesHidden();
       hostedController.getSignedData();

    }
}