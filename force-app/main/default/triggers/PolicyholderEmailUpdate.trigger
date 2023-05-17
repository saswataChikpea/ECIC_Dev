trigger PolicyholderEmailUpdate on Contact (after insert, after update) {
    
    Set <String> accID = New Set <String> (); 
    Map<String,String> primaryContactMap = New Map <String,String> ();
    For (Contact con: Trigger.new) { 
        if (con.Primary_Contact__c) {
            if (con.AccountId != Null ) { 
                accID.add (con.AccountId); 
                primaryContactMap.put(con.AccountId, con.Email);
            } 
        }
    } 
    If (accID.size ()> 0) { 
        List <Policy__c> upAccList = new List <Policy__c> (); 
        For (Policy__c ac: 
             [SELECT Id, Policy_Holder_Mail_ID__c , Exporter__c FROM Policy__c WHERE  Exporter__c in: AccID ]) { 
                 ac.Policy_Holder_Mail_ID__c = primaryContactMap.get(ac.Exporter__c); 
                 UpAccList.add (ac); 
             } 
        If (upAccList.size ()> 0) 
            update upAccList; 
    } 
    
    
}