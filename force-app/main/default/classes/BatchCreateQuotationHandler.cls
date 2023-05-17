public with sharing class BatchCreateQuotationHandler implements Database.AllowsCallouts{
    public BatchCreateQuotationHandler() {

    }
    public static void handleQuoteCreation(List<Proposal__c> propList){
        System.debug('handleQuoteCreation: propList::'+propList);
        
        Map<Id, Proposal__c> quoteReadyProposals= new Map<Id, Proposal__c>();
        for (Proposal__c prop : propList) {
            if (prop.Product__r.Name == 'SUP') {
                Integer totalBuyerCount=prop?.Buyers_Vetted__r.size();
                if ( totalBuyerCount> 0) {
                    Integer c=0;
                    for (Buyer_Vetted__c buyer : prop.Buyers_Vetted__r) {
                        if (buyer.Status__c == 'Valid') {
                            c++;
                        }
                    }
                    System.debug('total buyer:'+totalBuyerCount+' valid buyer:'+c);
                    if (c >= Math.ceil(Decimal.valueOf(totalBuyerCount).divide(2, 1))) {
                        quoteReadyProposals.put(prop.Id, prop);                        
                    }
                }else{
                    quoteReadyProposals.put(prop.Id, prop);
                }
            }else{
                quoteReadyProposals.put(prop.Id, prop);
            }
        }
        System.debug('quoteReadyProposals::'+ quoteReadyProposals.size() + quoteReadyProposals);
        // /*
        if (quoteReadyProposals.keySet().size()>0) {
            QuotationManager.Response res= QuotationManager.createQuoteBatch(new List<Id>(quoteReadyProposals.keySet()), false);
            System.debug('CreatedQuotations in Salesforce::'+ res);
        }
    }
    // this method will be called on BatchCreateQuotation finish method
    public static void handleQuoteCreationAPI(){
        System.debug('handleQuoteCreationAPI::');
        List<Quote__c> quoteList= [Select id, name, Issue_Date__c, Expiry_Date__c, Account__c, Product__c,Product__r.Name, 
        Proposal__r.Policy_Commence_Date__c, Proposal__r.CUS_NO__c, Proposal__r.Policy_Type__c, Proposal__r.Master_Proposal__c
        from Quote__c where Status__c='In Progress'];
        
        System.debug('quoteList::'+quoteList);
        if (quoteList.size()>0) {
            
            Integer quotationAcceptPeriod=Integer.valueOf([select Id, Quotation_Acceptance_Period__c from Ecic_Settings__c].Quotation_Acceptance_Period__c);
            System.debug('quotationAcceptPeriod::'+quotationAcceptPeriod);
            
            List<Map<String,Object>> jsonObjects= new List<Map<String,Object>>();
            Map<Integer,Quote__c> quoteSequenceMap= new Map<Integer,Quote__c>();
            
            Integer i=0;
            for (Quote__c quote : quoteList) {
    
                Map<String,Object> req = new Map<String,Object>{
                'ACCOUNT_ID' => quote.Account__c,
                'PROPOSAL_ID' => quote.Proposal__r.Id,
                'QUOTATION_ID' => quote.Id,
                'CUS_NO' => quote?.Proposal__r?.CUS_NO__c,
                'PCY_TYPE' => quote?.Proposal__r?.Policy_Type__c,
                'ISS_DATE' => String.valueOf(quote.Issue_Date__c),
                'ACC_DATE' => String.valueOf(Date.today()),
                'STS' => 'A',
                'QUO_EXP_DATE' => String.valueOf(Date.valueOf(quote.Issue_Date__c).addDays(quotationAcceptPeriod))
                };
    
                jsonObjects.add(req);
                quoteSequenceMap.put(i, quote);
                i++;
            }
            System.debug('quoteSequenceMap::'+ quoteSequenceMap);
            
            System.debug('applyQuoteAura jsonObjects::'+ jsonObjects);
            String jsonstr= ECIC_API_PolicyMgmt.applyQuoteAuraBulk(jsonObjects);
            System.debug('applyQuoteAura success::'+ jsonstr);
            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
            System.debug('respMap::=>'+ respMap);
            List<Object> completeResponse1= (List<Object>) JSON.deserializeUntyped(JSON.serialize(respMap.get('batch_data')));
            System.debug('completeResponse1::=>'+ completeResponse1);
            // List<Map<String,Object>> completeResponse= (List<Map<String,Object>>) JSON.deserializeUntyped(JSON.serialize(completeResponse1));
            // System.debug('completeResponse::=>'+ completeResponse);
    
            List<Quote__c> updateQuotationList = new List<Quote__c>();
            for (Object obj : completeResponse1) {
                Map<String, Object> response= (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(obj));
                System.debug('response::=>'+ response);
                Map<String, Object> respData=(Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(response.get('res_data')));
                System.debug('respData::=>'+ respData);
                
                Quote__c q=quoteSequenceMap.get(Integer.valueOf(response.get('seq_no')));
                System.debug('seqno::'+response.get('seq_no')+'::'+Integer.valueOf(response.get('seq_no')));
                System.debug('quote::=>'+q);

                if (respData.get('rtn_code') == '1') {//success case
                    System.debug('API success:: sending email=>');
                    // too many future calls -- will handle this
                    
                    q.Status__c = 'Pending for acceptance';
                    q.Is_Legacy_Verified__c = true;
                }else {
                    SendEmailApex.sendEmailAccount(q.Account__c, q.Id, 'Quotation_Notification', false, null, null);
                    System.debug('API error:: not sending email=>');
                    q.Is_Legacy_Verified__c = false;
                }
                q.Legacy_Response__c= JSON.serialize(respData);
                updateQuotationList.add(q);
            }
            
            System.debug('updateQuotationList::=>'+ updateQuotationList);
            if (updateQuotationList.size()>0) {
                update updateQuotationList;
            }
        }
    }

   
}