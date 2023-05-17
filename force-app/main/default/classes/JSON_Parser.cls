/*------------------------------------------------
    Desc :  class for parsing a JSON string and return a map of string vs String
    Created By : sayantan@chikpea.com
    Created on : 
------------------------------------------------*/
public with sharing class JSON_Parser {
    public static Map<String, String> json_parsing_method(String resp_body)
    {
        Map<String, String> returnMap = new Map<String, String>();
        System.debug('in json parsing method resp_body ====>'+resp_body);
        
        JSONParser parser = JSON.createParser(resp_body);
        // Integer counter = 1;
        // if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
            while (parser.nextToken() != null) {
                // if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    // system.debug('counter ====>'+counter);
                    // counter++;
                    // system.debug('parser.getCurrentToken() ===>'+parser.getCurrentToken());
                    if (parser.getCurrentToken() == JSONToken.FIELD_NAME){
                        system.debug('parser.getText()====>'+parser.getText());
                        String Key = parser.getText();
                        system.debug('parser.nextToken()===>'+parser.nextToken());
                        system.debug('parser.getText() ====>'+parser.getText());
                        String value = parser.getText();
                        returnMap.put(key, value);
                    }
                    // system.debug('JSONToken.FIELD_NAME ====>'+JSONToken.FIELD_NAME); 
                    
                    // system.debug('parser.getText() ====>'+parser.getText());
                    
                // }
            }
        // }
        return returnMap;
    }
    // 
}