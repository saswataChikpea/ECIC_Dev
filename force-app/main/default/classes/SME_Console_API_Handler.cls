/*-----------------------------------------------------
    Desc : Class for SME Console api request handling. 
    created by : sayantan@chikpea.com
    modified by : satya@chikpea.com
------------------------------------------------------*/

public with sharing class SME_Console_API_Handler {
    public static Map<String,Object> handler(String json_string) {
         Map<String,Object> my_map = new Map<String,Object>();
         //my_map.put('success',String.valueOf(true));
         Map<String, Object> parsedMap = new Map<String, Object>();
         Map<String, Object> parsedInnerMap = new Map<String, Object>();
         String function_name;
         String method_return_value = '';
         parsedMap = (Map<String, Object>)JSON.deserializeUntyped(json_string);
         try {    		
             System.debug('parsed json='+parsedMap);
             Object parsedInnerMap_obj = parsedMap.get('meta_data');
             parsedInnerMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(parsedInnerMap_obj));
             function_name = (String)parsedInnerMap.get('funcname');
             System.debug('function_name='+function_name);
             switch on function_name{
                 when 'nfc_details'{
                     System.debug('nfc nar search request from legacy ====>');
                 }
                 // Satya add other functions here.
                 when else{
                     System.debug('else block executed ====>');
                 }
             }
             //my_map.put(method_return_value,String.valueOf(true));
         } catch(Exception e) {
             // Not an object, must be an array
             
         }
         return my_map;
     }
}