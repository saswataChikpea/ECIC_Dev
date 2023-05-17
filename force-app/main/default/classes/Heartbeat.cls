@RestResource(urlMapping='/heartbeat')
global with sharing class Heartbeat {

  @HttpPost
    global static String doPost() {
        return 'PONG -  heartbeat received.';
    }
}