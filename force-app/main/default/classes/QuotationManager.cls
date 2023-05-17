public with sharing class QuotationManager {
    @AuraEnabled(cacheable = false)
    public static Response createQuote(Id id){
        return createQuoteBatch(new List<Id> {id}, true);
    }
    public static Response createQuoteBatch(List<Id> ids, Boolean shouldSendEmail){
        Response res = new Response();
        Map<String, Schema.SObjectField> proposalFldObjMap = schema.SObjectType.Proposal__c.fields.getMap();
        String soql='Select ';
        List<String> proposal_field_set=new List<String>();
        for(String key:proposalFldObjMap.keyset()){
            Schema.SObjectField sObject_field = proposalFldObjMap.get(key);
            schema.Describefieldresult dfr = sObject_field.getDescribe();
            if(dfr.isCreateable()){
                String field = key;
                soql+=field+', ';
                proposal_field_set.add(key);
            }
        }
        soql+='Id, Name from Proposal__c where Id IN '+inClausify(ids);

        System.debug('soql='+soql);

        List<Proposal__c> proplList = database.query(soql);

        System.debug('proplList='+proplList);

        Map<String, Schema.SObjectField> quoteFldObjMap = schema.SObjectType.Quote__c.fields.getMap();
        List<String> quote_field_set=new List<String>();
        for(String key:quoteFldObjMap.keyset()){
            Schema.SObjectField sObject_field = quoteFldObjMap.get(key);
            schema.Describefieldresult dfr = sObject_field.getDescribe();
            if(dfr.isCreateable()){
                String field = key;
                if (key=='Is_Legacy_Verified__c' || key=='Legacy_Response__c') {
                    continue;
                }
                quote_field_set.add(key);
            }
        }
        System.debug('quote_field_set='+soql);
        List<Quote__c> qts = new List<Quote__c>();
        List<Related_Endorsement__c> all_endorsements = new List<Related_Endorsement__c>();
        List<Quote> qt_wraps = new List<Quote>();
        List<Proposal__c> updateProposalList = new List<Proposal__c>();
        for(Proposal__c prop:proplList){
            Quote qt_wrap = new Quote();
            Quote__c qt = new Quote__c();
            qt_wrap.quote = qt;

            qt.Proposal__c = prop.Id;

            //create quotes child records here
            //create endorsments not sure if have to create--Arindam
            // Related_Endorsement__c re = new Related_Endorsement__c();
            // qt_wrap.endorsements.add(re);
            // all_endorsements.add(re);

            //end quotes child records

            //copy fields from proposal
            for(String field:quote_field_set){
                if(proposal_field_set.contains(field)){
                    System.debug('match='+field);
                    qt.put(field, prop.get(field));
                    System.debug('qt='+qt);
                }
            }
            qt.Account__c= prop.Account__c;
            qt.Product__c= prop.Product__c;
            // qt.Status__c = 'In Progress'; //override Status__c
            qt.Status__c = 'Pending for acceptance'; //override after ecic
            qt.Issue_Date__c= Date.today();
            qts.add(qt);
            qt_wraps.add(qt_wrap);
            prop.Status__c = 'Approved';
            updateProposalList.add(prop);

        }
        System.debug('qts='+qts);
        insert qts;
        System.debug('::Quotation created');
        update updateProposalList;

        //link child objects with quote
        for(Quote qt_wrap: qt_wraps){
            for(Related_Endorsement__c re: qt_wrap.endorsements){
                re.Quotation__c = qt_wrap.quote.Id;
            }
        }
        
        // insert all_endorsements;

        //send email notification to prospect
        if (shouldSendEmail == true) {// For batches it will be false. batch handles email sending itself. 
            for (Quote__c q : qts) {
                // SendEmailApex.sendEmailAccount(q.Account__c, q.Id, templateName, false)
                // Quotation_Notification Quotation_P001
                // String url= 'https://kennychun--dev2--c.visualforce.com/apex/PolicyScheduleOne?policyId=a090l000009OyMlAAK,https://kennychun--dev2--c.visualforce.com/apex/PolicyScheduleFour?policyId=a090l000009OyNFAA0';
                // sendEmailFuture(q.Account__c, q.Id, 'Quotation_Notification', false, false,  true, null, url);   
                //Policy_Notification
                SendEmailApex.sendEmailFuture(q.Account__c, q.Id, 'Quotation_Notification', false, null, null);
            }
        }

        res.quotations=qts;
        res.statusCode = 100;

        return res;
    }
    @AuraEnabled
    public static Response createPolicy(Id quoteId){
        try {
            Quote__c quote=[select id,name, Account__c, Product__c, Proposal__c from Quote__c WHERE id=:quoteId];
            System.debug('quote::'+quote);

            Proposal__c proposal= [select CUS_NO__c, Policy_Commence_Date__c, Maximum_Liability__c, Payment_Option__c, Base_Rate_Per_Anum__c, Indemnity_Percentage__c, NQL__c,
            Correspondence_Address_Line_1__c, Correspondence_Address_Line_2__c, Correspondence_Address_Line_3__c,
            Registered_Address_Line_1__c, Registered_Address_Line_2__c, Registered_Address_Line_3__c,
            Language_of_Correspondence__c, Registered_Territory__c, Correspondence_Territory__c,
            Bank_Account__c, Correspondence_District__c, Registered_District__c,
            BR_Number__c, Goods_And_Service__c, Company_Legal_Type__c, Company_Telephone_Number__c, Number_of_Free_Credit_Check__c,
            Base_Loading__c,Base_Rate_Per_Quarter__c,Enable_Pre_Shipment_Endorsement__c,
            DP__c,
            DA_OA_0_30__c,
            DA_OA_31_60__c,
            DA_OA_61_90__c,
            DA_OA_91_180__c,
            DP_NonA__c,
            DA_OA_0_30_NonA__c,
            DA_OA_31_60_NonA__c,
            DA_OA_61_90_NonA__c,
            DA_OA_91_180_NonA__c,
            Auto_Renewal__c
            from Proposal__c where id=:quote.Proposal__c];
            // Registration_Number__c
            // Phone
            // Legal_Type__c
            List<Policy__c> activePolicyList= [select id, name from Policy__c where Exporter__c=:quote.Account__c and Is_Active__c=true]; 
            System.debug('previous Active policy::'+activePolicyList);

            String productName= [select Name from Plan__c where id=:quote.Product__c].Name;
            // String paymentOption= quote.get('Proposal__c').Payment_Option__c;
            // String ml= quote.get('Proposal__c').Maxium_Liability__c;
            System.debug('productName::'+productName);

            Date commDate= proposal.Policy_Commence_Date__c == null? Date.today() : proposal.Policy_Commence_Date__c;

            Policy__c p= new Policy__c();
            p.Quotation__c=quote.Id;
            p.Is_Active__c=true;
            p.Exporter__c=quote.Account__c;
            p.Commencement_Date__c= commDate;
            p.Effective_Date__c= commDate;
            p.Product__c=quote.Product__c;
            p.Expiry_Date__c = Date.valueOf(commDate.addYears(1));
            p.Free_Credit_Check__c =20;// proposal.Number_of_Free_Credit_Check__c != null ? proposal.Number_of_Free_Credit_Check__c: 20;
            p.Renewal_Settings__c=proposal.Auto_Renewal__c;
            p.Status__c = 'N';
            insert p;

            Policy_Schedule__c ps1= new Policy_Schedule__c();
            ps1.Type__c='Schedule 1';
            ps1.Policy__c= p.Id;
            ps1.Payment_Type__c = proposal.Payment_Option__c!=null ? proposal.Payment_Option__c : null;
            if (productName == 'SUP') {
                ps1.Non_Qualifying_Loss_Amount__c = proposal.NQL__c !=null ? Decimal.valueOf(proposal.NQL__c) : 0;
                ps1.Base_Rate_Per_Anum__c = proposal.Base_Rate_Per_Anum__c!=null ? proposal.Base_Rate_Per_Anum__c : null;
                ps1.Maximum_Liability__c = proposal.Maximum_Liability__c!=null ? proposal.Maximum_Liability__c : null;
                ps1.Enable_Pre_Shipment_Endorsement__c = proposal.Enable_Pre_Shipment_Endorsement__c!=null ? proposal.Enable_Pre_Shipment_Endorsement__c : null;
            }
            else if (productName == 'SBP') {
                ps1.Non_Qualifying_Loss_Amount__c = proposal.NQL__c !=null ? Decimal.valueOf(proposal.NQL__c) : 0;
                ps1.Base_Loading__c= proposal.Base_Loading__c!=null? String.valueOf(proposal.Base_Loading__c): null;         
            }else if (productName == 'OMBP') {
                ps1.Base_Rate_Per_Quarter__c = proposal.Base_Rate_Per_Quarter__c!=null ? proposal.Base_Rate_Per_Quarter__c : 0;
            }

            ps1.Percentage_of_Indemnity__c = proposal.Indemnity_Percentage__c!=null ? proposal.Indemnity_Percentage__c : null;
            ps1.Payment_Type__c = proposal.Payment_Option__c!=null ? proposal.Payment_Option__c : null;
            insert ps1;
            if (productName == 'SBP') {
                Policy_Schedule__c ps2= new Policy_Schedule__c();
                ps2.Type__c='Schedule 2';
                ps2.Policy__c= p.Id;
                ps2.DP__c= proposal.DP__c;
                ps2.DA_OA_0_30__c= proposal.DA_OA_0_30__c;
                ps2.DA_OA_31_60__c= proposal.DA_OA_31_60__c;
                ps2.DA_OA_61_90__c= proposal.DA_OA_61_90__c;
                ps2.DA_OA_91_120__c= proposal.DA_OA_91_180__c;
                ps2.DP_NonA__c= proposal.DP_NonA__c;
                ps2.DA_OA_0_30_NonA__c= proposal.DA_OA_0_30_NonA__c;
                ps2.DA_OA_31_60_NonA__c= proposal.DA_OA_31_60_NonA__c;
                ps2.DA_OA_61_90_NonA__c= proposal.DA_OA_61_90_NonA__c;
                ps2.DA_OA_91_120_NonA__c= proposal.DA_OA_91_180_NonA__c;

                ps2.Backup_DP__c= proposal.DP__c;
                ps2.Backup_DA_OA_0_30__c= proposal.DA_OA_0_30__c;
                ps2.Backup_DA_OA_31_60__c= proposal.DA_OA_31_60__c;
                ps2.Backup_DA_OA_61_90__c= proposal.DA_OA_61_90__c;
                ps2.Backup_DA_OA_91_120__c= proposal.DA_OA_91_180__c;
                ps2.Backup_DP_NonA__c= proposal.DP_NonA__c;
                ps2.Backup_DA_OA_0_30_NonA__c= proposal.DA_OA_0_30_NonA__c;
                ps2.Backup_DA_OA_31_60_NonA__c= proposal.DA_OA_31_60_NonA__c;
                ps2.Backup_DA_OA_61_90_NonA__c= proposal.DA_OA_61_90_NonA__c;
                ps2.Backup_DA_OA_91_120_NonA__c= proposal.DA_OA_91_180_NonA__c;

                insert  ps2;

                Policy_Schedule__c ps3= new Policy_Schedule__c();
                ps3.Type__c='Schedule 3';
                ps3.Policy__c= p.Id;
                insert  ps3;
            }else if (productName == 'SUP') {
                Policy_Schedule__c ps2= new Policy_Schedule__c();
                ps2.Type__c='Schedule 2';
                ps2.Policy__c= p.Id;
                insert  ps2;

                Policy_Schedule__c ps3= new Policy_Schedule__c();
                ps3.Type__c='Schedule 3';
                ps3.Policy__c= p.Id;
                insert  ps3;

                Policy_Schedule__c ps4= new Policy_Schedule__c();
                ps4.Type__c='Schedule 4';
                ps4.Policy__c= p.Id;
                insert  ps4;
            }
            //Create policy schedule record for policy cover & policy Document
            Policy_Schedule__c psCover= new Policy_Schedule__c();
            psCover.Type__c='Policy Cover';
            psCover.Policy__c= p.Id;
            insert psCover;

            Policy_Schedule__c psDraftDocument= new Policy_Schedule__c();
            psDraftDocument.Type__c='Policy Document';
            psDraftDocument.Policy__c= p.Id;
            insert psDraftDocument;

            //end
            Account acc= [select id, (select id, phone,Primary_Contact__c from Contacts) from Account where id=:quote.Account__c];
            // if (acc.Contacts.size() >=1) {
            //     Contact c= acc.Contacts[0];
            //     c.Primary_Contact__c=true;
            //     update c;
            // }
            acc.Current_Policy__c = p.Id;
            acc.Legacy_Customer_Number__c= proposal.CUS_NO__c;
            // acc.Registered_Address_Line_1__c = proposal.Registered_Address_Line_1__c;
            // acc.Registered_Address_Line_2__c = proposal.Registered_Address_Line_2__c;
            // acc.Registered_Address_Line_3__c = proposal.Registered_Address_Line_3__c;
            // acc.Registered_Territory__c = proposal.Registered_Territory__c;
            // acc.Registered_District__c = proposal.Registered_District__c;
            // acc.Language_of_Correspondence__c = proposal.Language_of_Correspondence__c;
            // acc.Legal_Type__c = proposal.Company_Legal_Type__c;
            // acc.Goods_or_Services__c = proposal.Goods_And_Service__c;
            // acc.Registration_Number__c = String.valueOf(proposal.BR_Number__c);
            // acc.Correspondence_Address_Line_1__c = proposal.Correspondence_Address_Line_1__c;
            // acc.Correspondence_Address_Line_2__c = proposal.Correspondence_Address_Line_2__c;
            // acc.Correspondence_Address_Line_3__c = proposal.Correspondence_Address_Line_3__c;
            // acc.Correspondence_Territory__c = proposal.Correspondence_Territory__c;
            // acc.Correspondence_District__c = proposal.Correspondence_District__c;

            
            if (activePolicyList.size()>=1) {
               for (Policy__c plcy : activePolicyList) {
                   plcy.Is_Active__c= false;
               }
               update activePolicyList;
            }
            try {
                acc.Phone = proposal.Company_Telephone_Number__c;
            } catch (Exception e) {
                System.debug('invalid phone::'+e);
            }

            
            
            update acc;
            quote.Status__c= 'Accepted';
            quote.Acceptence_Date__c=Date.today();
            update quote;
            if (productName == 'SUP') {//as it is not created yet
                // CreateSUPInvoice.createInvoiceForSUP(p.Id); //To Create Invoice at the time of quotation accept
            }
            List<Quote__c> alreadyActiveQuotations = new List<Quote__c>();
            alreadyActiveQuotations=[Select id,Name, Status__c, Proposal__r.Id, Proposal__r.CUS_NO__c, Proposal__r.Policy_Type__c from Quote__c where Status__c='Pending for acceptance' AND Account__c=:quote.Account__c];
            System.debug('alreadyActiveQuotations::'+alreadyActiveQuotations);
            if (alreadyActiveQuotations.size()>0) {
                for (Quote__c q : alreadyActiveQuotations) {
                    q.Status__c='Void';
                }
                update alreadyActiveQuotations;
            }

            //create Task
            // TaskManagement.createTask
            SendEmailApex.sendEmailFuture(p.Exporter__c, p.Id, 'Policy_Notification', false, null, null);


            Response r=new Response();
            r.policy=p;
            r.quotations=alreadyActiveQuotations;
            r.statusCode=200;
            return r;

        } catch (Exception ex) {   
            if (!Test.isRunningTest()) {
                throw new AuraHandledException(ex.getMessage());
            }
            return null;
        }
    }
    // @AuraEnabled
    // public static string createInvoice(Object json_ob){
    //     try {
    //         Invoice__c inv = new Invoice__c();
    //         Invoice_Line__c invl = new Invoice_Line__c();
    //         String json_string = Json.serialize(json_ob);
    //         Map<String, Object> untyped_instance = (Map<String, Object>)JSON.deserializeUntyped(json_string);
    //         Date dueDate = Date.today().addDays(7);
    //         // inv.Account__c = (String)untyped_instance.get('account');
    //         // inv.Policy__c = (String)untyped_instance.get('policy_id');
            
    //         inv.Due_Date__c = dueDate;            
    //         inv.Invoice_Date__c = Date.today();
    //         inv.Status__c = 'UnPaid';
    //         insert inv;
    //         Decimal invlAmnt = Decimal.valueOf((String)untyped_instance.get('CL_Amount__c'));
    //         invl.Invoice__c = inv.Id;
    //         invl.Buyer_s_Code__c = (String)untyped_instance.get('Buyer_Code__c');
    //         invl.Credit_Limit_Application__c = (String)untyped_instance.get('Id');
    //         invl.Currency_Code__c = 'HKD';
    //         invl.Net_Premium__c = invlAmnt;
    //         invl.Premium_Due_Date__c = dueDate;
    //         insert invl;
    //         Credit_Limit_Application__c cla = new Credit_Limit_Application__c(
    //             Id = (String)untyped_instance.get('Id'),
    //             CL_Status__c = 'Waiting for payment'
    //         );
    //         update cla;
    //         return String.valueOf(inv.Id);
    //     } catch (Exception e) {
    //         throw new AuraHandledException(e.getMessage());
    //     }
    // }

    @AuraEnabled
    public static List<ConnectApi.ManagedContentVersion> getPublishedContentIds(String productId){
        System.debug('productId ::'+productId);
        List<ConnectApi.ManagedContentVersion> results;
        List<Id> cmsPubConIdList=new List<Id>();
        for(CMS_Content__c cms : [select Content_Id__c from CMS_Content__c  where Product__c =:productId and  Status__c='Published']){
            cmsPubConIdList.add(cms.Content_Id__c);
        }
        if(cmsPubConIdList !=null && !cmsPubConIdList.isEmpty()){
            results = getCMSontentByContentIds(cmsPubConIdList);
        }
        return results;
    }
    public static List<ConnectApi.ManagedContentVersion> getCMSontentByContentIds(List<String> contentIds) {
        //List<String> contentIds = new List<String>();
        System.debug('contentIds :'+contentIds);
        String communityId;
        List<ConnectApi.ManagedContentVersion> results;
        try {
            Network netObj = [select id from Network];
            communityId = netObj.id;
            System.debug('communityId :'+communityId);
        } catch (Exception e) {
            System.debug('Exception at ContentController constructor : '+e.getMessage()+' Stack : '+e.getStackTraceString());
        }
        try{
            
            String language = 'en_US';
            String managedContentType = 'news';
            Integer pageParam= 0;
            Integer pageSize = 50;
            //Note: "news" is the contenttype of the content value hard coded in the code here.
            if (!Test.isRunningTest()) {
                ConnectApi.ManagedContentVersionCollection contentList 
                      = ConnectApi.ManagedContent.getManagedContentByIds(communityId, contentIds, pageParam, pageSize, language, managedContentType);
    
                      results = contentList.items;  
                      System.debug('results : '+results);   
                    //   return results;      
            }
        }
        catch(ConnectApi.ConnectApiException e){
            System.debug('Exception at CMS : '+e.getMessage()+' Stack : '+e.getStackTraceString());
            results = new List<ConnectApi.ManagedContentVersion>();
        }  
        return results;         
    }

    public static String inClausify(List<Id> ids) {
        String inClause='(';                  
        for(Id i:ids){
           inClause += '\''+i+'\',';
        }                  
        inClause=inClause.removeEnd(','); 
        inClause+=')';
       return inClause;
   }
   public class Quote{
       Quote__c quote;
       List<Related_Endorsement__c> endorsements;
       public Quote(){
        endorsements = new List<Related_Endorsement__c>();
       }
   }
    public class Response{
        public Response(){
            statusCode = 0; 
            message = '';
        }
        public Exception e;
        @AuraEnabled public Integer statusCode{ get; set; }
        @AuraEnabled public String message{ get; set; }
        //@AuraEnabled public List<ChikPeaTOM__Order_Config__c> orderConfigs{get;set;}
        @AuraEnabled public Account ac;
        @AuraEnabled public String siteUrl;
        @AuraEnabled public Proposal__c prop;
        @AuraEnabled public Policy__c policy;
        @AuraEnabled public List<Quote__c> quotations = new List<Quote__c>();
    }
}