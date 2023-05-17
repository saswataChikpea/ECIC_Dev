trigger handleAccountTrigger on Account (before update) {

    if(Trigger.isUpdate){
        for(Account acc: Trigger.new){
            System.debug('Trigger update acc:'+acc.Is_Problem_Policy_Holder__c);
            Account accOld = Trigger.oldMap.get(acc.id);
            System.debug('accOld : '+accOld.Is_Problem_Policy_Holder__c);
            if(accOld.Is_Problem_Policy_Holder__c== null){
                if(acc.Is_Problem_Policy_Holder__c != null && acc.Is_Problem_Policy_Holder__c=='No'){
                    //SME_ConsoleHandler.getNFCRecordFromLegacy(acc.id);
                }
            }
        }
    }
}