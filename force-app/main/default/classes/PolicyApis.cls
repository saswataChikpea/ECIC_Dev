@RestResource(urlMapping='/v1/getPolicy')
global with sharing class PolicyApis {

    // class GeneralRespons{
    //     Integer code;
    //     String message;
    //     String status;
    //     String id;
    //     String name;
    //     Product prod;
    //     class Product{
    //         String productId;
    //         String productName;
    //         String fullName;
    //         String description;

    //     }
    // }
    // @httpGet
    // global static void getPolicyDetails(){
    //     Map<String, String> params = RestContext.request.params;
    //     String policyNumber = params.get('policyNumber');
    //     String returnRespons;
    //     String policyDetails = '{'
    //         +'"code": "404",'
    //         +'"message": "Policy does not exist"'
    //     +'}';
    //     GeneralRespons genRes= new GeneralRespons();
    //     genRes.code=404;
    //     genRes.message = 'Policy does not exist';
    //     if(policyNumber!=null && !policyNumber.equals('')){
    //         for(Policy__c pol : [select id,name,Status__c from Policy__c where name =:policyNumber]){
    //             // policyDetails = '{'
    //             //     +'"code": 200,'
    //             //     +'"message": "Policy Exist",'
    //             //     +'"status": "'+pol.Status__c+'",'
    //             //     +'"id": "'+pol.id+'",'
    //             //     +'"name": "'+pol.name+'",'
    //             // +'}';
    //             genRes.code=200;
    //             genRes.message='Policy Exist';
    //             genRes.id=pol.id;
    //             genRes.status=pol.Status__c;
    //             genRes.name=pol.name;
    //         }
    //     }
    //     System.debug('genRes =>'+genRes+ '=>'+JSON.serialize(genRes));
    //     RestContext.response.addHeader('Content-Type', 'application/json');
    //     RestContext.response.responseBody = Blob.valueOf(JSON.serialize(genRes));   
    //     //return JSON.serialize(genRes);
    // }
    @httpGet
    global static void getPolicyDetails(){
        Map<String, String> params = RestContext.request.params;
        String policyNumber = params.get('policyNumber');
        
        PolicyResponseFormat genRes= new PolicyResponseFormat();
        genRes.code=404;
        genRes.message = 'Policy does not exist';
        if(policyNumber!=null && !policyNumber.equals('')){
            for(Policy__c pol : [select id,name,Status__c,Product__c,Product__r.name,Product__r.Full_Name__c,Product__r.Active__c,
                                Product__r.Description__c,Exporter__c,Exporter__r.name 
                                from Policy__c where name =:policyNumber]){
                genRes.code=200;
                genRes.id=pol.id;
                genRes.status=pol.Status__c;
                genRes.name=pol.name;
                genRes.message='Policy Exist';
                if(pol.Product__c != null){
                    PolicyResponseFormat.PlanObj pl  = new PolicyResponseFormat.PlanObj();
                    pl.id = pol.Product__c;
                    pl.name = pol.Product__r.name;
                    pl.fullName = pol.Product__r.Full_Name__c;
                    pl.description = pol.Product__r.Description__c;
                    genRes.plan = pl;
                }
                if(pol.Exporter__c!=null){
                    PolicyResponseFormat.CustomerDetails exporter  = new PolicyResponseFormat.CustomerDetails();
                    exporter.id = pol.Product__c;
                    exporter.policyHolderName = pol.Exporter__r.name;
                    // exporter.email = pol.Product__r.name;
                    // exporter.phone = pol.Product__r.name;
                    genRes.customer = exporter;
                } 
            }
        }
        System.debug('genRes =>'+genRes+ '=>'+JSON.serialize(genRes));
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(genRes));   
    }
}