public with sharing class HandleOnboardingAPIData {

    //sample
// '{"op":"u","api":"onboarding","ver":"1","meta_data":"[{
//     'name': '',
//     'address': '',
//     'vetted':true,
//     'dcl_ref':''
// }]"}'
    public static Map<String, String> vettedAddress(String data) {
        Map<String, String> returnData= new Map<String, String>();

        try {
            System.debug('data::'+data);

            Map<String, String> jsonInput= (Map<String, String>) JSON.deserializeUntyped(data);
            System.debug('jsonInput::'+jsonInput);

            List<VettedMeta>  meta= (List<VettedMeta>) JSON.deserializeUntyped(jsonInput.get('meta_data'));
            //do saving and all

            List<Map<String, String>> result =  new List<Map<String, String>>();
            String dclRef='';
            for (VettedMeta rec : meta){
                dclRef= rec.dcl_ref;
                // result.add(new Map<String, String>{'dcl_ref' => dclRef});
            }
            returnData.put('dcl_ref', dclRef);
            returnData.put('statusCode', '200');
            returnData.put('message', 'Data saved successfully');
            return returnData;
        } catch (Exception e) {
			throw new AuraHandledException(e.getMessage());          
        }

    }
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
}