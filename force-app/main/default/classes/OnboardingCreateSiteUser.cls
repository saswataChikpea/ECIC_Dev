global class OnboardingCreateSiteUser implements Auth.ConfigurableSelfRegHandler{
    // public OnboardingCreateSiteUser() {

    // }
    private boolean isValidPassword() {
        return true;
    }

    @AuraEnabled(cacheable = false)
	public static Response createAccount(Map<String,String> accDetail, Map<String,String> userDetail, String proposal, Map<String,String> brFile,String brNo){
        Response res = new Response();
        String accountId = ''; 
        String userName = '';
        System.Debug('#****--->createAccount userDetail='+userDetail);
        System.Debug('#****--->createAccount brFile='+brFile);

        //inserting File
        System.Debug('#****--->bfFile'+brFile);
        String base64File = EncodingUtil.urlDecode(brFile.get('file'), 'UTF-8');     
        String cvId=FileUploaderClass.uploadFile(base64File, brFile.get('filename'));
        System.Debug('#****--->content version id'+cvId);

        Account act = new Account(); 
        for(String key:accDetail.keySet()){
            act.put(key, accDetail.get(key));
        }
        //System.Debug('#****--->proposal'+JSON.serialize(proposal));
        System.Debug('#****--->proposal'+proposal);


        
        
    // after ECIC stopped working        
        try {
            act.Document_Id__c= cvId;
        } catch (Exception e) {
            //System.debug('document save error::'+e);
        }
        act.Registration_Number__c= brNo;
        act.Proposal_data__c = proposal;
        Database.insert(act);
        System.Debug('#****--->act'+act.Id);

        accountId = act.Id;
        res.ac = act;
        
        
        User u = new User();
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        u.Username = userDetail.get('Username');
        u.Email = userDetail.get('Email');
        u.FirstName = userDetail.get('FirstName');
        u.LastName = userDetail.get('LastName');
        u.CommunityNickname = userDetail.get('FirstName')+string.valueOf(math.random()).substring(0,6);
		//u.ProfileId = profileId;
        userName = userDetail.get('Username');
		
        String userId;
        
        String password = userDetail.get('Password');

        try {
            userId = Site.createExternalUser(u, accountId, password);
        } catch(Site.ExternalUserCreateException ex) {
            List<String> errors = ex.getDisplayMessages();
            for (String error : errors)  {
                System.debug('====>Exception: '+error);
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
            }
            
            // This message is used for debugging. Do not display this in the UI to the end user.
            // It has the information around why the user creation failed.
            System.debug('====>ExternalUserCreateException: '+ex.getMessage());
            res.message += ex.getDisplayMessages();
            if(!Test.isRunningTest())
                throw new AuraHandledException(ex.getMessage());
        }
        try {
            if (userId != null) { 
                if (password != null && password.length() > 1) {
                    System.PageReference pegRef = Site.login(userName, password, 'https://sandbox-fun-flow-2795-dev-ed-1790cea8d5c.cs95.force.com/');
                    System.debug('pegRef='+pegRef);
                    //createProposal(accountId);
                    res.siteUrl = pegRef.getUrl();
                }
                else {
                    // PageReference page = System.Page.CommunitiesSelfRegConfirm;
                    // page.setRedirect(true);
                    // return page;
                }
            }
        } catch(SecurityException ex) {
            res.message += ex.getMessage();
            throw new AuraHandledException(ex.getMessage());
        } catch(Exception ex) {
            res.message += ex.getMessage();
            throw new AuraHandledException(ex.getMessage());
        }

        return res;
    }
    @AuraEnabled(cacheable = false)
    public static Response initEmailVerify(String userId, String password){
        System.Debug('#****--->initEmailVerify');
        Response res = new Response();
        try {
            //if(userId != null) { 
               // if (password != null && password.length() > 1) {
                    System.Debug('#****--->initRegisterVerificationMethod');
                    UserManagement.initRegisterVerificationMethod(Auth.VerificationMethod.EMAIL);
                    System.Debug('#****--->initEmailVerify end');
                //}
                //else {
                    // PageReference page = System.Page.CommunitiesSelfRegConfirm;
                    // page.setRedirect(true);
                    // return page;
               // }
            //}
        } catch(SecurityException ex) {
            System.Debug('#****--->initEmailVerify Exception'+ex);
            res.message += ex.getMessage();
            throw new AuraHandledException(ex.getMessage());
        } catch(Exception ex) {
            System.Debug('#****--->initEmailVerify Exception'+ex);
            res.message += ex.getMessage();
            throw new AuraHandledException(ex.getMessage());
        }
        return res;
    }

    @AuraEnabled(cacheable = false)
    public static Response verifyEmail(String code) {//, String accoutId
        System.Debug('#****--->verifyEmail code='+code);
        Response res = new Response();
        // Take the user’s input for the code sent to their phone number
        String exceptionText = System.UserManagement.verifyRegisterVerificationMethod(code, Auth.VerificationMethod.EMAIL);
        
        if(exceptionText != null && exceptionText !=''){
            res.message += exceptionText;
            } else {
                //Success 
                res.statusCode=200;
                res.message='Verify email successful';
            }



        System.Debug('#****--->verifyEmail Exception='+exceptionText);
        /*System.Debug('#****--->update accoutId='+accoutId);
        accoutId = '0010l00001ID1HsAAL';
        if(accoutId != null){
            Account ac = new Account(Id = accoutId, Is_Email_Verified__c = true);
            update ac;
            System.Debug('#****--->update account success '+ ac);
        }*/
        return res;
    }

    @AuraEnabled(cacheable = false)
    public static Response initSMSVerify(String userId, String password){
        System.Debug('#****--->initSMSVerify');
        Response res = new Response();
        try {
            System.Debug('#****--->initRegisterVerificationMethod SMS');
            String res1 = UserManagement.initRegisterVerificationMethod(Auth.VerificationMethod.SMS);
            System.Debug('#****--->initSMSVerify end res = '+res1);
            res.message = res1;
        } catch(SecurityException ex) {
            System.Debug('#****--->initSMSVerify Exception'+ex);
            res.message += ex.getMessage();
            throw new AuraHandledException(ex.getMessage());
        } catch(Exception ex) {
            System.Debug('#****--->initSMSVerify Exception'+ex);
            res.message += ex.getMessage();
            throw new AuraHandledException(ex.getMessage());
        }
        return res;
    }

    // @AuraEnabled(cacheable = false)
    // public static Response verifySMS(String code) {//, String accoutId
    //     System.Debug('#****--->verifyEmail code='+code);
    //     Response res = new Response();
    //     // Take the user’s input for the code sent to their phone number
    //     String exceptionText = System.UserManagement.verifyRegisterVerificationMethod(code, Auth.VerificationMethod.SMS);
        
    //     res.message += exceptionText;
    //     System.Debug('#****--->verifyEmail Exception='+exceptionText);
    //     /*System.Debug('#****--->update accoutId='+accoutId);
    //     accoutId = '0010l00001ID1HsAAL';
    //     if(accoutId != null){
    //         Account ac = new Account(Id = accoutId, Is_Email_Verified__c = true);
    //         update ac;
    //         System.Debug('#****--->update account success '+ ac);
    //     }*/
    //     return res;
    // }
    // @AuraEnabled(cacheable = false)
    // public static String submitForApproval(){
    //     // Create an approval request for the Contact
    //     Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
    //     req1.setComments('Submitting request for approval automatically using Trigger');
    //     req1.setObjectId('0032100000tuC3xAAE');
    //     //req1.setNextApproverIds(new Id[] {opp.Next_Approver__c});

    //     // Submit the approval request for the Contact
    //     Approval.ProcessResult result = Approval.process(req1);
    //     return 'Success';
    // }

    @AuraEnabled(cacheable = false)
    public static String createProposal(Map<String, String> proposal){//, String accountId
		System.Debug('#****--->createProposal proposal='+proposal);
        try {
    
            Proposal__c p = new Proposal__c();
            Boolean isNewProposal=true;
            Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Proposal__c').getDescribe().fields.getMap();
            Map<String, String> dataTypeMap = new Map<String, String>();
            for(Schema.SObjectField ft : fieldMap.values()) {
                Schema.DescribeFieldResult fd = ft.getDescribe();
                dataTypeMap.put(fd.getName(), String.valueof((fd.getType())));
            }
            
            for(String key:proposal.keySet()){
                if (key=='Policy_Commence_Date_old' || key=='CreatedDate' )  {
                    continue;
                }
                if (key=='Id') {
                    if (proposal.get(key) != null) {
                        isNewProposal=false;
                    }
                    
                    Id masterProposal=[select Master_Proposal__c from Proposal__c WHERE id=:proposal.get(key)].Master_Proposal__c;
                    System.Debug('#masterProposal='+masterProposal);
                    
                    if(masterProposal != null){
                        p.Master_Proposal__c=masterProposal;
                    }else {
                        p.Master_Proposal__c=proposal.get(key);
                    }
                continue;
            }
            String dataType = dataTypeMap.get(key);
            if(dataType == null){
                p.put(key, String.valueOf(proposal.get(key)));
            }else if(dataType == 'BOOLEAN'){
                p.put(key, Boolean.valueOf(proposal.get(key)));
            }else if(dataType == 'CURRENCY'){
                p.put(key, Decimal.valueOf(proposal.get(key)));
            }else if(dataType == 'DOUBLE'){
                p.put(key, Double.valueOf(proposal.get(key)));
            }else if(dataType =='PERCENT'){
                p.put(key, Double.valueOf(proposal.get(key)));
                
            }else if(dataType =='DATE'){
                // p.put(key, Integer.valueOf(proposal.get(key)));
                try {
                    p.put(key, date.valueOf(proposal.get(key)));
                } catch (Exception error) {
                    System.Debug('#****--->createAccount proposal date create failed'+error);    
                }
                
            }
            
            else{
                p.put(key, String.valueOf(proposal.get(key)));
            }
            }
            insert p;
            System.Debug('#****--->createAccount proposal='+'proposalId='+p.id+''+proposal);
            //creating buyer vetted for SUP product and there are any buyer
            if (proposal.get('Buyer_List__c') != null || proposal.get('Buyer_List__c') != '') {
                saveBuyerVetted(proposal.get('Buyer_List__c'), p.Id, p.Account__c);
            }

            //creating task for SME Staff
            Account acc= [select id, (select id, phone,Primary_Contact__c from Contacts)  from Account where id=:p.Account__c];
            if (isNewProposal== true) {
                if (proposal.get('Benificiary_Owners__c') != null) {
                    saveAuthorizedPersons(proposal.get('Benificiary_Owners__c'), p.Account__c);
                }
                TaskManagement.createTask('New Proposal', 'A new proposal has been created. Please review.', 'Normal', null, null, p.id, 'SME Staff');
                
                if (acc.Contacts.size() >=1) {
                    Contact c= acc.Contacts[0];
                    c.Primary_Contact__c=true;
                    try {
                        c.Title = p.Title__c;
                        c.Position__c= p.Title__c;
                        c.LastName= p.Last_Name__c;
                        c.FirstName = p.First_Name__c;
                        c.Enable_Email_Notification__c = true;
                        c.Enable_SMS_Notification__c = p.Enable_SMS_Notification__c ? p.Enable_SMS_Notification__c : false;
                    } catch (Exception e) {
                        System.debug('create Contact error'+e);
                    }
                    try {
                        c.MobilePhone=p.Mobile_Number__c;
                        c.Phone = p.Company_Telephone_Number__c;
                    } catch (Exception e) {
                        System.debug('create Contact mobile error'+e);
                    }
                    
                    update c;
                }
            }
            try {
                acc.Mobile__c= p.Mobile_Number__c;
                acc.Phone = p.Company_Telephone_Number__c;
            } catch (Exception e) {
                System.debug('create account mobile error'+e);
            }
            
            acc.Registered_Address_Line_1__c = p.Registered_Address_Line_1__c;
            acc.Legacy_Customer_Number__c= p.CUS_NO__c;
            acc.Registered_Address_Line_2__c = p.Registered_Address_Line_2__c;
            acc.Registered_Address_Line_3__c = p.Registered_Address_Line_3__c;
            acc.Registered_Territory__c = p.Registered_Territory__c;
            acc.Registered_District__c = p.Registered_District__c;
            acc.Language_of_Correspondence__c = p.Language_of_Correspondence__c;
            acc.Legal_Type__c = p.Company_Legal_Type_Label__c;
            acc.Goods_or_Services__c = p.Goods_And_Service_Label__c;
            acc.Registration_Number__c = String.valueOf(p.BR_Number__c);
            acc.Correspondence_Address_Line_1__c = p.Correspondence_Address_Line_1__c;
            acc.Correspondence_Address_Line_2__c = p.Correspondence_Address_Line_2__c;
            acc.Correspondence_Address_Line_3__c = p.Correspondence_Address_Line_3__c;
            acc.Correspondence_Territory__c = p.Correspondence_Territory__c;
            acc.Correspondence_District__c = p.Correspondence_District__c;     
            update acc;       
            // sending email notification
            // try {
            //     SendEmailApex.sendEmailFuture(p.Account__c, p.Id, 'Proposal_Notification', false, null, null);
            // } catch (Exception e) {
            //     System.debug('proposal send email error =>'+e);
            // }
                
            return p.id;
        } catch (Exception e) {
            ExceptionLogger.log(e, 'OnboardingCreateSiteUser');
            // ExceptionLogger.email(e);//after ecic
            return null;
        }
    }
            
    @AuraEnabled
    public static void updateBRDocument(Id userId){
        try {
            Id accId = [Select contact.AccountId from user where id =:userId].contact.AccountId;
            ECIC_Document__c ed=[select id, Document_Id__c from ECIC_Document__c where Document_Type__c ='BR Document' and Account__c=:accId order by CreatedDate limit 1];
            System.debug('ecic document::'+ed);
            ContentVersion cv= [SELECT Id, ContentDocumentId,Title, FileExtension, VersionData FROM ContentVersion where Id = :ed.Document_Id__c];
            System.debug('content version::'+cv);
            ContentDocument cd=[select id,ownerId from ContentDocument where id=:cv.ContentDocumentId];
            System.debug(cd);
            ed.Document_Id__c= cd.Id;
            cd.ownerId= userId;
            update ed;
            update cd;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public static void saveBuyerVetted(String data, Id pId, Id accId){
        List<Buyer> objects = (List<Buyer>) JSON.deserialize(data, List<Buyer>.class);
        List<Buyer_Vetted__c> buyerList = new List<Buyer_Vetted__c>();
        for (Buyer obj : objects) {
            Buyer_Vetted__c buyer= new Buyer_Vetted__c();
            buyer.Proposal__c = pId;
            buyer.Exporter__c = accId;
            buyer.Buyer_Name__c = obj.name;
            buyer.Buyer_Country__c = obj.country;
            buyer.Buyer_Address_Line_1__c = obj.address;
            buyer.Status__c ='New';
            buyerList.add(buyer);
            System.debug('Vetting buyer ::'+obj);
        }
        System.debug('Vetting buyer list::'+buyerList);
        if(buyerList.size()>0){
            insert buyerList;

            //call vetting API in future method
            List<String> ids= new List<String>();
            for (Buyer_vetted__c obj : buyerList) {
                ids.add(String.valueOf(obj.Id));
            }
            OnboardingCreateSiteUser.callBuyerDCLAPI(ids);
        }
    }
    
    @future(callout=true)
    public static void callBuyerDCLAPI(List<String> ids){
        Map<Integer,Buyer_vetted__c> buyerSequenceMap= new Map<Integer,Buyer_vetted__c>();
        Integer i=0;
        for (Buyer_Vetted__c obj : [select Id, Buyer_Name__c, Buyer_Code__c, Buyer_Country__c,
        Buyer_Address_Line_1__c, Buyer_Address_Line_2__c, Buyer_Address_Line_3__c, Buyer_Address_Line_4__c,
         Status__c from Buyer_Vetted__c where id in :ids]) {
            buyerSequenceMap.put(i, obj);
            i++;
        }
        
        System.debug('buyerSequenceMap::'+ buyerSequenceMap);
        System.debug('createVettingDCLApplicationBulkAura Ids::'+ ids);

        String ecicset = ECIC_API_V1.get_ecic_setting(NULL);
        String access_token_1=ECIC_API_V1.get_access_token();
        System.debug('access_token_1 ====>'+access_token_1);
        if(ECIC_API_V1.access_token_success){
            String jsonstr= ECIC_CL_API_Methods.createVettingDCLApplicationBulk(ids);
            System.debug('buyervetting success::'+ jsonstr);
            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
            System.debug('respMap::=>'+ respMap);
            List<Object> completeResponse= (List<Object>) JSON.deserializeUntyped(JSON.serialize(respMap.get('batch_data')));
            System.debug('completeResponse::=>'+ completeResponse);

            List<Buyer_Vetted__c> updateBuyerList = new List<Buyer_Vetted__c>();
            for (Object obj : completeResponse) {
                Map<String, Object> response= (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(obj));
                System.debug('response::=>'+ response);
                Map<String, Object> respData=(Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(response.get('res_data')));
                System.debug('respData::=>'+ respData);

                Buyer_Vetted__c b=buyerSequenceMap.get(Integer.valueOf(response.get('seq_no')));
                System.debug('seqno::'+response.get('seq_no')+'::'+Integer.valueOf(response.get('seq_no')));
                System.debug('quote::=>'+b);

                if (respData.get('rtn_code') == '1') {//success case
                    System.debug('API success:: =>');
                    // store other values. Arindam----            
                    b.Status__c = 'Valid';
                }else {
                    System.debug('API error:: =>');
                }
                updateBuyerList.add(b);
            }
            System.debug('updateBuyerList::=>'+ updateBuyerList);
            if (updateBuyerList.size()>0) {
                update updateBuyerList;
            }
        }
    }

    @AuraEnabled
    public static void saveAuthorizedPersons(String data, Id accId){
        List<AuthPerson> authpersonList = (List<AuthPerson>) JSON.deserialize(data,List<AuthPerson>.class);
        System.debug('authpersonList::'+authpersonList+'  accid='+ accId);
        // Id accountId = [Select contact.AccountId from user where id =:accId].contact.AccountId;

        List<Custom_Contact__c> contacts = new List<Custom_Contact__c>();
        try {            
            for (AuthPerson ap : authpersonList) {
            if (ap.name!= '' && ap.type!= '' ) {
                Custom_Contact__c c= new Custom_Contact__c();
                List<String> nameList=ap.name.split(' ');
                String last_name= nameList[nameList.size()-1];
                namelist.remove(nameList.size()-1);
                c.Account__c= accId;
                // c.Is_Active__c= false;
                c.First_Name__c= String.join(nameList, ' ');
                c.Contact_Last_Name__c= last_name;
                if (ap.type=='Director') {
                    c.Director__c= true;
                }
                if (ap.type=='Sole Proprietor') {
                    c.Authorised_Person__c= true;
                }
                if (ap.type=='Shareholder') {
                    c.Beneficiary_Owner__c= true;
                }
                Contacts.add(c);
            }
        }
        insert contacts;
        System.debug('Custom_Contact__c s::'+contacts);
        } catch (Exception e) {
            System.debug('saveAuthorizedPersons Exception::'+e);
        }
    }
    
    
    @AuraEnabled(cacheable = true)
    public static Account getProposalData(Id usrId){
        try {
            Id accountId = [Select contact.AccountId from user where id =:usrId].contact.AccountId;
            Account ac = [Select Id, Name, Is_Email_Verified__c, Proposal_Data__c from Account where id =:accountId];
            return ac;
        }catch(Exception ex) {
            //res.message += ex.getMessage();
            throw new AuraHandledException(ex.getMessage());
        }
    }
    @AuraEnabled(cacheable = true)
    public static Proposal__c getLastProposal(Id usrId){
        Id accountId = [Select contact.AccountId from user where id =:usrId].contact.AccountId;
            // Account ac = [Select Id, Name, Is_Email_Verified__c, Proposal_Data__c from Account where id =:accountId];
            
            // System.debug('account'+ac);
            
            Proposal__c p =[select Name, Insurable_Turnover__c,
            Contact_Name__c, Title__c, Company_Email__c, Mobile_Number__c, Company_Telephone_Number__c, Product__c,
            Company_Name__c, Know_About_Hkecic__c,BR_Number__c,Account__c
              from Proposal__c where Account__c=:accountId order by id desc limit 1];    
            System.debug('proposal==>'+p);
            return p;
    }
    @AuraEnabled(cacheable = true)
    public static Proposal__c getProposal(Id usrId){
        //from proposal Object
        try {
            Id accountId = [Select contact.AccountId from user where id =:usrId].contact.AccountId;
            // Account ac = [Select Id, Name, Is_Email_Verified__c, Proposal_Data__c from Account where id =:accountId];
            
            // System.debug('account'+ac);
            
            Proposal__c p =[select Name, Insurable_Turnover__c,
            Contact_Name__c, Title__c, Company_Email__c, Mobile_Number__c, Company_Telephone_Number__c, Product__c,
            Company_Name__c, Know_About_Hkecic__c,BR_Number__c,Account__c
              from Proposal__c where Account__c=:accountId order by id desc limit 1];    
            System.debug('proposal==>'+p);


            // account ac = [Select Id, brDocumentId__c  from Account where id =:accountId];
            // system.debug('#cv id:'+ac.brDocumentId__c);
            // ContentDocumentLink cdl = new ContentDocumentLink();
            // cdl.ContentDocumentId = [
            // SELECT ContentDocumentId 
            // FROM ContentVersion 
            // WHERE Id = :ac.brDocumentId__c
            // ].ContentDocumentId;
            // cdl.LinkedEntityId = accountId;
            // // ShareType is either 'V', 'C', or 'I'
            // // V = Viewer, C = Collaborator, I = Inferred
            // cdl.ShareType = 'V';
            // insert cdl;
            // System.debug('#ContentDocumentLink'+ cdl);


            // return p;
            return getCompleteProposal(p.Id);
        }catch(Exception ex) {
            //res.message += ex.getMessage();
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static Verification_Method__c getVerificationStatus(Id usrId){
        try {
            Id accountId = [Select contact.AccountId from user where id =:usrId].contact.AccountId;
            return [Select Id, Name, Account__c, EMAIL__c, SMS__c from Verification_Method__c where Account__c=:accountId limit 1];
        }catch(Exception ex) {
            //res.message += ex.getMessage();
            throw new AuraHandledException(ex.getMessage());
        }
    }

    global Id createUser(Id accountId, Id profileId, Map<SObjectField, String> registrationAttributes, String password) {
        try {
            
            User u = new User();
            u.ProfileId = profileId;
            for (SObjectField field : registrationAttributes.keySet()) {
                String value = registrationAttributes.get(field);
                u.put(field, value);
            }
            u.languagelocalekey = UserInfo.getLocale();
            u.localesidkey = UserInfo.getLocale();
            u.emailEncodingKey = 'UTF-8';
            u.timeZoneSidKey = UserInfo.getTimezone().getID();
            if(!Test.isRunningTest()){
                Site.validatePassword(u, password, password);
                if (u.contactId == null) {
                    return Site.createExternalUser(u, accountId, password);
                }
                insert u;
                System.setPassword(u.Id, password);
            }
            return u.id;
        } catch (Exception e) {
            System.debug(e);
        }
        return null;

        }
        @AuraEnabled(cacheable = true)
        public static List<Proposal__c> getProposalList(Id usrId){
            System.debug('usrId::'+usrId);
            try {
                Id accountId = [Select contact.AccountId from user where id =:usrId].contact.AccountId;
                List<Proposal__c> p = [select id,name, Product__r.Name, CreatedDate, status__c from Proposal__c where Account__c =:accountId order by id];
                return p;
            }catch(Exception ex) {
            //res.message += ex.getMessage();
            throw new AuraHandledException(ex.getMessage());
        }
    }
    @AuraEnabled(cacheable = true)
    public static List<Quote__c> getQuotationList(Id usrId){
        try {
            System.debug('usrId::'+usrId);
            Id accountId = [Select contact.AccountId from user where id =:usrId].contact.AccountId;
            List<Quote__c> c = [select id,name, Product__r.Name, Issue_Date__c, status__c from Quote__c where Account__c =:accountId order by id];
            System.debug('list::'+c);

            return c;
        }catch(Exception ex) {
            //res.message += ex.getMessage();
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<Buyer_Vetted__c> getBuyerVettingList(Id usrId){
        try {
            System.debug('usrId::'+usrId);
            Id accountId = [Select contact.AccountId from user where id =:usrId].contact.AccountId;
            List<Buyer_Vetted__c> c = [select Id, Name,Exporter__r.Current_Policy__c, Buyer_Name__c, Buyer_Code__c, Buyer_Country__c,
            Buyer_Address_Line_1__c, Buyer_Address_Line_2__c, Buyer_Address_Line_3__c, Buyer_Address_Line_4__c,
            status__c,CreatedDate from Buyer_Vetted__c where Exporter__c =:accountId order by id];
            System.debug('getBuyerVettingList::'+c);
            if (c.size()>0) {
                if (c[0].Exporter__r?.Current_Policy__c != null) {
                    System.debug('policy created sendng blank::');
                    return new List<Buyer_Vetted__c>();
                }
            }
            return c;
        }catch(Exception ex) {
            //res.message += ex.getMessage();
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled(cacheable = true)
    public static Proposal__c getProposalForRejection(Id id){
        try {
          return [select id,Name, Status__c,BR_Number__c,CUS_NO__c,Policy_Type__c,Account__c, Proposal_Rejection_Reason__c from Proposal__c where id=:id];
        }catch(Exception ex) {
            //res.message += ex.getMessage();
            throw new AuraHandledException(ex.getMessage());
        }
    }


    @AuraEnabled(cacheable = true)
    public static Quote__c getQuotation(Id Id){
        try {
            System.debug('Quotation Id::'+Id);
            
            Quote__c c = [Select id, name, Issue_Date__c, Expiry_Date__c, Completed_Tutorial__c,
                Account__r.Id, Account__r.Name, Product__c,Product__r.Name, Product__r.Full_Name__c,
                Proposal__r.Contact_Name__c, Proposal__r.Br_Number__c, Proposal__r.Title__c, Proposal__r.Company_Email__c, Proposal__r.Mobile_Number__c, Proposal__r.Company_Telephone_Number__c,
                Proposal__r.Policy_Commence_Date__c, Proposal__r.Maximum_Liability__c, Proposal__r.Indemnity_Ratio__c, Proposal__r.NQL__c, 
                Proposal__r.CUS_NO__c, Proposal__r.Policy_Type__c, Proposal__r.Master_Proposal__c,
                Proposal__r.Registered_Address_Line_1__c,
                Proposal__r.Registered_Address_Line_2__c,
                Proposal__r.Registered_Address_Line_3__c,
                Proposal__r.Registered_Territory__c,
                Proposal__r.Registered_District__c,
                proposal__r.NQL_Amount__c,
                proposal__r.Country_Risks__c,
                proposal__r.Repudiation_Risks__c,
                proposal__r.Base_Rate_Per_Anum__c,
                proposal__r.First_Name__c,
                proposal__r.Last_Name__c,
                proposal__r.DP__c,
                proposal__r.DA_OA_0_30__c,
                proposal__r.DA_OA_31_60__c,
                proposal__r.DA_OA_61_90__c,
                proposal__r.DA_OA_91_180__c,
                proposal__r.DP_NonA__c,
                proposal__r.DA_OA_0_30_NonA__c,
                proposal__r.DA_OA_31_60_NonA__c,
                proposal__r.DA_OA_61_90_NonA__c,
                proposal__r.DA_OA_91_180_NonA__c,
                proposal__r.CreatedDate
                from Quote__c where id =:Id
            ];
            System.debug('quote::'+c);

            return c;
        }catch(Exception ex) {
            //res.message += ex.getMessage();
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String, Object>  getProposalFromQuote(Id id){
        System.debug('Quotation Id::'+Id);
        Map<String, Object> returnMap = new Map<String, Object>();

        Quote__c q= [select id, Proposal__c, CreatedDate from Quote__c WHERE id=:id];
        Id proposalId= q.Proposal__c;
        System.debug('proposalId Id::'+proposalId);

        Proposal__c p=getCompleteProposal(proposalId);
        returnMap.put('Quote__c', q);
        returnMap.put('Proposal__c', p);
        return returnMap;
    }

    @AuraEnabled
    public static Proposal__c getCompleteProposal(Id id){
        try {
            Proposal__c p= [select Company_Name__c,
            Country_Risks__c,
            Repudiation_Risks__c,
            Policy_Type__c,
            CUS_NO__c,
            Company_Legal_Type__c,
            Bank_Account__c,
            Policy_Commence_Date__c,
            Payment_Option__c,
            Auto_Renewal__c,
            Goods_And_Service__c,
            Language_of_Correspondence__c,
            Past_Turnover__c,
            Future_Turnover__c,
            Insurable_Turnover__c,
            Insurable_Buyers__c,
            Sales_Amount_Range__c,
            Country_Market_Of_Shipment__c,
            Destination_Country_Market__c,
            Country_Market_Of_Origin__c,
            Bad_Debt_Amount__c,
            Overdue_Amount__c,
            BR_Number__c,
            BR_Expiry_Date__c,
            BR_Document__c,
            Corporate_Incorporation_Date__c,
            Company_Address_Registered__c,
            Registered_Territory__c,
            Registered_District__c,
            Registered_Address_Line_1__c,
            Registered_Address_Line_2__c,
            Registered_Address_Line_3__c,
            Correspondence_Address_Line_1__c,
            Correspondence_Address_Line_2__c,
            Correspondence_Address_Line_3__c,
            Registered_Correspondence_Same__c,
            Company_Address_Correspondence__c,
            Correspondence_Territory__c,
            Correspondence_District__c,
            Application_Reason__c,
            Benificiary_Owners__c,
            Indemnity_Percentage__c,
            NQL__c,
            Buyer_List__c,
            Exclusions__c,
            Maximum_Liability__c,
            First_Name__c,
            Last_Name__c,
            Title__c,
            Company_Email__c,
            Company_Telephone_Number__c,
            Mobile_Number__c,
            Enable_SMS_Notification__c,
            Know_About_Hkecic__c,
            Promotion_Code__c,
            Account__c,
            Product__c,
            CreatedDate
            from Proposal__c where id=:id 
            ];
            return p;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static Response reviseQuotation(Map<String, String> proposal, Id quoteId ){
        try {
            System.debug('reviseQuotation::'+proposal);
            System.debug('quoteId::'+quoteId);
            Id pId=createProposal(proposal);
            System.debug('prposal id::'+pId);
            Quote__c qOld=[select id from Quote__c WHERE id=:quoteId];
            Response res=createQuote(pId, quoteId);
            res.prop=[select id from Proposal__c where id=:pId];
            qOld.Status__c='Void';
            update qOld;
            return res;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
            
        }
    }
    public static Response createQuote(Id proposalId, Id oldQuoteId ){
        Response res = new Response();
        Map<String, Schema.SObjectField> proposalFldObjMap = schema.SObjectType.Proposal__c.fields.getMap();
        System.debug('proposalFldObjMap.keyset()::'+proposalFldObjMap.keyset());
        // String soql='Select ';
        // List<String> proposal_field_set=new List<String>();
        // for(String key:proposalFldObjMap.keyset()){
        //     Schema.SObjectField sObject_field = proposalFldObjMap.get(key);
        //     schema.Describefieldresult dfr = sObject_field.getDescribe();
        //     if(dfr.isCreateable()){
        //         String field = key;
        //         soql+=field+', ';
        //         proposal_field_set.add(key);
        //     }
        // }
        // soql+='Id, Name, Account__c, Product__c from Proposal__c where Id =: '+proposalId;
        
        // System.debug('soql='+soql);

        Proposal__c prop = [Select Id, Name, Account__c, Product__c from Proposal__c where Id =:proposalId];//database.query(soql);

        System.debug('propoposal='+prop);

        // Map<String, Schema.SObjectField> quoteFldObjMap = schema.SObjectType.Quote__c.fields.getMap();
        // List<String> quote_field_set=new List<String>();
        // for(String key:quoteFldObjMap.keyset()){
        //     Schema.SObjectField sObject_field = quoteFldObjMap.get(key);
        //     schema.Describefieldresult dfr = sObject_field.getDescribe();
        //     if(dfr.isCreateable()){
        //         String field = key;
        //         quote_field_set.add(key);
        //     }
        // }
        // System.debug('quote_field_set='+soql);
        // List<Quote__c> qts = new List<Quote__c>();
        // List<Related_Endorsement__c> all_endorsements = new List<Related_Endorsement__c>();
        // List<Quote> qt_wraps = new List<Quote>();
        // List<Proposal__c> updateProposalList = new List<Proposal__c>();
        // for(Proposal__c prop:proplList){
            // Quote qt_wrap = new Quote();
            Quote__c qt = new Quote__c();
            // qt_wrap.quote = qt;

            qt.Proposal__c = prop.Id;

            //create quotes child records here
            //create endorsments not sure if have to create--Arindam
            // Related_Endorsement__c re = new Related_Endorsement__c();
            // qt_wrap.endorsements.add(re);
            // all_endorsements.add(re);

            //end quotes child records

            //copy fields from proposal
            // for(String field:quote_field_set){
            //     if(proposal_field_set.contains(field)){
            //         System.debug('match='+field);
            //         qt.put(field, prop.get(field));
            //         System.debug('qt='+qt);
            //     }
            // }
            if (oldQuoteId != null) {
                Id masterQuote=[select Master_Quotation__c from Quote__c WHERE id=:oldQuoteId].Master_Quotation__c;
                if(masterQuote != null){
                    qt.Master_Quotation__c=masterQuote;
                }else {
                    qt.Master_Quotation__c=oldQuoteId;
                }
            }
            qt.Account__c= prop.Account__c;
            qt.Product__c= prop.Product__c;
            qt.Status__c = 'Pending for acceptance'; //override Status__c
            qt.Issue_Date__c= Date.today();
            // qts.add(qt);
            // qt_wraps.add(qt_wrap);
            prop.Status__c = 'Approved';
            // updateProposalList.add(prop);

        // }
        insert qt;
        System.debug('::Quotation created');
        update prop;

        //link child objects with quote
        // for(Quote qt_wrap: qt_wraps){
        //     for(Related_Endorsement__c re: qt_wrap.endorsements){
        //         re.Quotation__c = qt_wrap.quote.Id;
        //     }
        // }
        
        // insert all_endorsements;

        System.debug('qt='+qt);
        res.statusCode = 100;
        res.quote= qt;

        return res;
    }
    public class Quote{
        Quote__c quote;
        List<Related_Endorsement__c> endorsements;
        public Quote(){
         endorsements = new List<Related_Endorsement__c>();
        }
    }
//     public static String inClausify(List<Id> ids) {
//         String inClause='(';                  
//         for(Id i:ids){
//            inClause += '\''+i+'\',';
//         }                  
//         inClause=inClause.removeEnd(','); 
//         inClause+=')';
//        return inClause;
//    }

   
    @AuraEnabled
    public static Account checkDupliateEmail(Id usrId){// not working in community
    // String email='arindam@chikpea.com';
    try {
        Id accountId = [Select contact.AccountId from user where id =:usrId].contact.AccountId;
        Account ac = [Select Id, Name, Is_Email_Verified__c from Account where id =:accountId];
        return ac;

    } catch (Exception ex) {
        throw new AuraHandledException(ex.getMessage());        
    }
   }
   @AuraEnabled
    public static Account EmailVerifySuccessful(Id usrId){// not working in community
    // String email='arindam@chikpea.com';
    try {
        Id accountId = [Select contact.AccountId from user where id =:usrId].contact.AccountId;
        Account ac = [Select Id, Name, Is_Email_Verified__c from Account where id =:accountId];
        ac.Is_Email_Verified__c=true;
        update ac;
        return ac;

    } catch (Exception ex) {
        throw new AuraHandledException(ex.getMessage());        
    }
   }

//    @AuraEnabled
//     public static List<Country__mdt> getCountryList(){
//         try {
//             List<Country__mdt> map_cn = [select Id,Country_Code__c,Full_Country_Name__c from Country__mdt];
//             return map_cn;
//         } catch (Exception e) {
//             throw new AuraHandledException(e.getMessage());
//         }
//     }

    @AuraEnabled
    public static void updateProposal(Map<String,String> data){
        System.debug('updating proposal::'+data);
        Proposal__c p= [select id, Account__c from Proposal__c WHERE id=:data.get('Id')];
        if (data.containsKey('CUS_NO__c')) {
            p.CUS_NO__c = data.get('CUS_NO__c');
            Account acc=[select id, Legacy_Customer_Number__c from Account where id=:p.Account__c];
            acc.Legacy_Customer_Number__c= data.get('CUS_NO__c');
            update acc;
        }
        if (data.containsKey('Is_Legacy_Verified__c')) {
            p.Is_Legacy_Verified__c=Boolean.valueOf(data.get('Is_Legacy_Verified__c'));
        }
        if (data.containsKey('Legacy_Response__c')) {
            p.Legacy_Response__c= data.get('Legacy_Response__c');
        }
        if (data.containsKey('Is_Error__c')) {
            p.Is_Error__c=Boolean.valueOf(data.get('Is_Error__c'));
        }
        if (data.containsKey('Status__c')) {
            p.Status__c=data.get('Status__c');
        }

        update p;
        // return true;
    }

    public class AuthPerson{
        public AuthPerson(){
            name = '';
            type = '';
        }
        @AuraEnabled public String name{ get; set; }
        @AuraEnabled public String type{ get; set; }
    }
    public class Buyer{
        public Buyer(){
            name = '';
            address = '';
            country = '';
        }
        @AuraEnabled public String name{ get; set; }
        @AuraEnabled public String address{ get; set; }
        @AuraEnabled public String country{ get; set; }
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
        @AuraEnabled public Quote__c quote;
    }
}