public without sharing class OnboardingCheckValidation {
  @AuraEnabled
  public static Boolean BRExist(String brNumber) {
    List<AggregateResult> result = [
      SELECT count(Id) total
      FROM Proposal__c
      WHERE BR_Number__c = :brNumber
    ];
    return Integer.valueOf(result[0].get('total')) > 0;
  }

  @AuraEnabled
  public static Boolean emailExist(String email) {
    List<AggregateResult> result = [
      SELECT count(Id) total
      FROM Proposal__c
      WHERE Company_Email__c = :email
    ];
    return Integer.valueOf(result[0].get('total')) > 0;
  }

  @AuraEnabled
  public static Boolean promoCodeExist(String promoCode) {
    List<AggregateResult> result = [
      SELECT count(Id) total
      FROM Promotion_Code__c
      WHERE Promo_Code__c = :promoCode and Is_Active__c=true
    ];
    return Integer.valueOf(result[0].get('total')) > 0;
  }
}