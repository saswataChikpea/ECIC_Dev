public with sharing class Helper {
    public static boolean accessChecking(Date limitedAccessDate) {
        boolean isLimitedAccessWithinSixMonth=false;
        System.debug('accessChecking called : '+limitedAccessDate);

        if(limitedAccessDate != null){
            System.debug('Day Difference :'+limitedAccessDate.addMonths(6).daysBetween(Date.today()) );
            if (limitedAccessDate.addMonths(6).daysBetween(Date.today()) >= 0 ) {
                isLimitedAccessWithinSixMonth=true;
            }
        }
        System.debug('isLimitedAccessWithinSixMonth ===>>'+isLimitedAccessWithinSixMonth);
        return isLimitedAccessWithinSixMonth;
    }

    @AuraEnabled
    public static Plan__c getProductDetails(Id usrId){
        System.debug('getProductDetails ===>'+usrId);
        try {
            Id accountId = [Select contact.AccountId from user where id =:usrId].contact.AccountId;
            Account acc = [Select Id, Name, Current_Policy__r.Product__c from Account where id =:accountId];
            Plan__c product = [select id,name,Default_Payment_Term_Type__c,Default_Payment_Term_Days__c
                                from Plan__c where id = :acc.Current_Policy__r.Product__c ];
            System.debug('product ==>'+product);
            return product;
        } catch (Exception e) {
            System.debug('Exception at getProductDetails : '+e.getMessage()+' Stack :'+e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }
}