public class callChatGPT_API {  
 
@InvocableMethod(label='Make POST Callout')  
    public static List<String> makePostCallout(List<String> searchString) {
        List<String> responses = new List<String>();
        for(String prompt : searchString) {
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://b4b-dynamic-chatbot.backend.b4b.ai/webhooks/rest/webhook');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            // Set the request body here if needed
            String reqBody = '{"message": "'+prompt+'","sender": "e4bcdf1d-0769-4a6c-ae1b-648204152186__asasdsad__642e9d581b417092b8d2d259"}';
            System.debug('String reqBody >>  '+reqBody);
            request.setBody(reqBody);

            Http http = new Http();
            HttpResponse response = http.send(request);
            if(response.getStatusCode() == 200) {
                responses.add(response.getBody());
            } else {
                responses.add('Error: ' + response.getStatusCode() + ' ' + response.getStatus());
            }
        }
        System.debug('String responses >>  '+responses);
        return responses;
    }

    //for chat bot
    @AuraEnabled(cacheable=true) 
    public static List<String> makePostCalloutLWC(List<String> searchString) {
        List<String> responses = new List<String>();
        for(String prompt : searchString) {
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://b4b-dynamic-chatbot.backend.b4b.ai/webhooks/rest/webhook');
            request.setMethod('POST');
            request.setTimeout(120000);
            request.setHeader('Content-Type', 'application/json');
            // Set the request body here if needed
            String reqBody = '{"message": "'+prompt+'","sender": "e4bcdf1d-0769-4a6c-ae1b-648204152186__asasdsad__642e9d581b417092b8d2d259"}';
            System.debug('String reqBody >>  '+reqBody);
            request.setBody(reqBody);

            Http http = new Http();
            HttpResponse response = http.send(request);
            if(response.getStatusCode() == 200) {
                System.debug('Response body: ' + response.getBody());
                String jsonstring = '[{\"recipient_id\":\"e4bcdf1d-0769-4a6c-ae1b-648204152186__asasdsad__642e9d581b417092b8d2d259\",\"text\":\"Hello! Is there something specific you need help with today?\"},{\"recipient_id\":\"e4bcdf1d-0769-4a6c-ae1b-648204152186__asasdsad__642e9d581b417092b8d2d259\",\"text\":\"Hello! Is there something specific you need help with today?\"}]';
                // Deserialize the JSON string into a list of maps
                List<Object> obj = (List<Object>)JSON.deserializeUntyped(response.getBody());
                System.debug('obj'+obj);
                for(Object fld : obj){    
    Map<String,Object> data = (Map<String,Object>)fld;
    
    //Magic!
    String dataResponse = json.serialize(data.get('text'));
    system.debug(data.get('text'));
    responses.add(dataResponse);
    
}
              //  List<Map<String, String>> jsonList = (List<Map<String, String>>) (obj);
            //  System.debug('jsonList'+jsonList);
                // Access the deserialized values
                /*for (Map<String, Object> jsonMap : jsonList) {
                    String recipientId = (String) jsonMap.get('recipient_id');
                    String text = (String) jsonMap.get('text');
                    responses.add('Recipient ID: ' + recipientId + ', Text: ' + text);
                }*/
                
            } else {
                responses.add('Error: ' + response.getStatusCode() + ' ' + response.getStatus());
            }
        }
        System.debug('String responses >>  '+responses);
        return responses;
    }
    
}