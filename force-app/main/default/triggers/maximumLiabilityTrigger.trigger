trigger maximumLiabilityTrigger on Policy__c (before update,before insert) {
    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
            System.debug('checking maximumLiability annivarsary date !!!');
            for (Policy__c pol : Trigger.new) {
                // Access the "old" record by its ID in Trigger.oldMap
                Policy__c oldPolicy = Trigger.oldMap.get(pol.Id);
                boolean isOldMLChnagedFromZeroToNonZero = (oldPolicy.Maximum_Liability__c == 0 && pol.Maximum_Liability__c > 0 ) ? true : false;
                System.debug('isOldMLChnagedFromZeroToNonZero : '+isOldMLChnagedFromZeroToNonZero);
                if(isOldMLChnagedFromZeroToNonZero){
                    pol.ML_Changed_to_Non_Zero_Amount__c = System.now();
                }
            }
        }
        if (Trigger.isInsert) {
            //Exporter__c
			String acc_id;
            for (Policy__c pol : Trigger.new) {
                acc_id = pol.Exporter__c;
            }
			System.debug('acc_id : '+acc_id);
            if(!acc_id.equals('')){
                List<Policy__c> oldPolicyList = [select id,Status__c from Policy__c where Exporter__c =:acc_id  ];//and Status__c='Valid' 
				List<Policy__c> upPolicyList = new List<Policy__c>();
                if(oldPolicyList != null && !oldPolicyList.isEmpty()){
					System.debug('Found Old Policy Status');
                    for (Policy__c pol : oldPolicyList) {
                		pol.Status__c = 'Expired';
						upPolicyList.add(pol);
            		}
                    if(upPolicyList != null && !upPolicyList.isEmpty()){
                        update upPolicyList;
						System.debug('Old Policy Status Expired');
                    }
                }
            }
        }
    }
}