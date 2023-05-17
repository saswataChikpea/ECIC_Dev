global with sharing class PG_Config {

    global Boolean testMode { get; set; }   
    global String paymentGatewayName { get; set; }
    global String accessKey { get; set; }
    global String secretKey { get; set; }
    global String profileID { get; set; }
    global String endPoint { get; set; }

    global PG_Config() {
        try {
            List<Gateway__c> gatewaysList = [Select id,Name,Is_Test__c,
            Test_Access_Key__c,Test_Secret_Key__c,Test_Profile_ID__c,Test_End_Point__c,
            Prod_Access_Key__c,Prod_Secret_Key__c,Prod_Profile_ID__c,Prod_End_Point__c
            from Gateway__c  limit 1];

            System.debug('gatewaysList : '+gatewaysList);
            if(gatewaysList != null && !gatewaysList.isEmpty()){
                this.testMode = gatewaysList[0].Is_Test__c;
                this.accessKey = this.testMode ? gatewaysList[0].Test_Access_Key__c : gatewaysList[0].Prod_Access_Key__c;
                this.secretKey = this.testMode ? gatewaysList[0].Test_Secret_Key__c : gatewaysList[0].Prod_Secret_Key__c;
                this.profileID = this.testMode ? gatewaysList[0].Test_Profile_ID__c : gatewaysList[0].Prod_Profile_ID__c;
                this.endPoint = this.testMode ? gatewaysList[0].Test_End_Point__c : gatewaysList[0].Prod_End_Point__c;
            }else{
                System.debug('PG Exception::Payment Gateway not found.');
            } 
        } catch (Exception e) {
            System.debug('PG Exception::Payment Gateway not found. '+e.getMessage()+' Stack : '+e.getStackTraceString()); 
        } 
        
    }
}