public with sharing class SmeConsole {
    //Api 4.7
    @InvocableMethod(label='Get NFC Record' description='Get NFC from the leagcy')
    public static void getNFCFromTheLegacy(List<ID> ids){
        System.debug('getNFCFromTheLegacy cus_no ids :'+ids);
        //ECIC_CustomerAPI.getNFCRecord(String.valueOf(ids[0]));
    }

    public static String getLatestProposalOfAccount(String accountId){
        System.debug('getLatestProposalOfAccount : '+accountId);
        String proposalId;
        Account accObj = [select id,name,(select id,name,createdDate from Proposals__r order by name desc limit 1) 
        from Account where id=:accountId];
        if(accObj!= null){
            for(Proposal__c prop : accObj.Proposals__r ){
                System.debug('prop =:'+prop.name+' prop id:'+prop.id);
                proposalId=prop.id;
            }
        }
        System.debug('proposalId =>'+proposalId);
        return proposalId;
    }
    public static String getAccountFromProposal(String proposalId){
        System.debug('getAccountFromProposal : '+proposalId);
        String accountId;
        Proposal__c propObj = [select id,name,Account__c from Proposal__c where id=:proposalId];
        System.debug('propObj =>'+propObj);
        if(propObj!= null){
            accountId = propObj.Account__c;
        }
        System.debug('accountId =>'+accountId);
        return accountId;
    }
}