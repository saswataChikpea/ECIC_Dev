trigger CreateContact on Custom_Contact__c (after insert) {
    List<Contact> contactList = new List<Contact>();

    for(Custom_Contact__c con:Trigger.New) {
        if ((con.Authorised_Person__c == false) && (con.Beneficiary_Owner__c == false) && (con.Director__c == false)){
            contactList.add(new Contact(AccountId=con.Account__c,
            Beneficiary_Owner__c=false,
            Authorised_Person__c=false,
            Director__c=false,
            Email=con.Email__c,
            Is_Active__c=true,
            Phone=con.Contact_No__c,
            LastName=con.Contact_Last_Name__c,
            FirstName=con.Name,
            Position__c=con.Position__c
            ));
        }
    }
    if(contactList.size() > 0) {
        insert contactList;        
    }
}