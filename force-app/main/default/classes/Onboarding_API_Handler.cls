/*-----------------------------------------------------
    Desc : Class for onboarding api request handling. 
    created by : sayantan@chikpea.com
    modified by : arindam@chikpea.com
------------------------------------------------------*/

public with sharing class Onboarding_API_Handler {
   public static Map<String,Object> handler(String json_string) {
        Map<String,Object> my_map = new Map<String,Object>{
            'rtn_code' => -1,
            'rtn_msgs' => '',
            'meta_data' => null
        };
        Map<String,Object> ret_map = new Map<String,Object>();
        Map<String, Object> parsedMap = new Map<String, Object>();
        Map<String, Object> parsedInnerMap = new Map<String, Object>();
        String function_name;

        parsedMap = (Map<String, Object>)JSON.deserializeUntyped(json_string);
		try {    		
            System.debug('parsed json='+parsedMap);
            Object parsedInnerMap_obj = parsedMap.get('meta_data');
            parsedInnerMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(parsedInnerMap_obj));
            function_name = (String)parsedInnerMap.get('funcname');
            System.debug('function_name='+function_name);
            switch on function_name{
                when 'policy_application'{
                    System.debug('policy application from legacy ====>');
                    // arindam implement the details
                    my_map.put('Success', 'Credit limit details updated.');
                }
                when 'buyer_vetting_status_update'{
                    ret_map = updateBuyerVettingStatus(parsedInnerMap, my_map);
                }
                when else{
                    ret_map.put('rtn_code', -1);
                    ret_map.put('rtn_msgs', 'Error: function '+function_name+' not found.');
                    ret_map.put('meta_data', null);
                }
            }
		} catch(Exception e) {
    		ret_map.put('rtn_code', -1);
            ret_map.put('rtn_msgs', 'Error: '+e.getMessage());
            ret_map.put('meta_data', new Map<String,Object>{
                'cause' => e.getCause()?.getMessage(),
                'type' => e.getTypeName(),
                'line' => e.getLineNumber(),
                'message' => e.getMessage(),
                'trace' => e.getStackTraceString()
            });    		
    	}
        return ret_map;
    }

    public static Map<String,Object> updateBuyerVettingStatus(Map<String, Object> meta_data, Map<String,Object> ret_map) {
        
        String bvId = String.valueOf(meta_data.get('Id'));
        String bvStatus = String.valueOf(meta_data.get('Status__c'));
        String bvBuyerCode = String.valueOf(meta_data.get('Buyer_Code__c'));
        String bvByerCountry = String.valueOf(meta_data.get('Buyer_Country__c'));
        String bvAddress1 = String.valueOf(meta_data.get('Buyer_Address_Line_1__c'));
        String bvAddress2 = String.valueOf(meta_data.get('Buyer_Address_Line_2__c'));
        String bvAddress3 = String.valueOf(meta_data.get('Buyer_Address_Line_3__c'));
        String bvAddress4 = String.valueOf(meta_data.get('Buyer_Address_Line_4__c'));

        List<Buyer_Vetted__c> bvList = [SELECT Id, Status__c, Buyer_Code__c, Buyer_Country__c, 
            Buyer_Address_Line_1__c, Buyer_Address_Line_2__c, Buyer_Address_Line_3__c, Buyer_Address_Line_4__c
            FROM Buyer_Vetted__c WHERE Id = :bvId];
        if (bvList.size() == 0) {
            ret_map.put('rtn_code', -1);
            ret_map.put('rtn_msgs', 'Error: Buyer Vetted record not found for Id '+bvId);
            ret_map.put('meta_data', null);
        } else {
            Buyer_Vetted__c bv = bvList[0];
            bv.Status__c = bvStatus;
            bv.Buyer_Code__c = bvBuyerCode;
            bv.Buyer_Country__c = fieldMappingTranslation.getCountryName(bvByerCountry);
            bv.Buyer_Address_Line_1__c = bvAddress1;
            bv.Buyer_Address_Line_2__c = bvAddress2;
            bv.Buyer_Address_Line_3__c = bvAddress3;
            bv.Buyer_Address_Line_4__c = bvAddress4;
            update bv;
            System.debug('Buyer Vetted Updated.');

            ret_map.put('rtn_code', 1);
            ret_map.put('rtn_msgs', 'Success');
            ret_map.put('meta_data', null);
        }
        
        return ret_map;

    }

}