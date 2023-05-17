@isTest
public with sharing class HandleOnboardingAPIDataTest {
    public class VettedMeta{
        public VettedMeta(){
            name='';
            address='';
        }
        @AuraEnabled public String name;
        @AuraEnabled public String address;
        @AuraEnabled public Boolean vetted;
        @AuraEnabled public String dcl_ref;
    }
    
    @IsTest(SeeAllData=true) static void testvettedAddress(){
        Test.startTest();
        Map<String, String> inputData= new Map<String, String>();
        VettedMeta meta=  new VettedMeta();
        List<VettedMeta> metaList = new List<VettedMeta>();
        meta.name='test';
        meta.address='test address';
        meta.vetted=true;
        meta.dcl_ref='abcd';
        metaList.add(meta);
        String strSobjects = ' ';   
        for(VettedMeta obj : metaList){
            strSobjects = strSobjects  + ','+JSON.Serialize(obj);
        }

        inputData.put('op', 'u');
        inputData.put('api', 'onboarding');
        inputData.put('ver', '1');
        inputData.put('meta_data',strSobjects);
        Map<String, String> returnData= new Map<String, String>();

        try{
        	returnData= HandleOnboardingAPIData.vettedAddress(JSON.serialize(inputData));
            System.debug('::'+returnData);
        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }
        Test.stopTest();
        System.assertEquals(returnData.get('dcl_ref'),'abcd');
    }
}