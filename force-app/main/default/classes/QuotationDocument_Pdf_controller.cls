public with sharing class QuotationDocument_Pdf_controller {
    public String accountId {get;set;}
    public String Registered_Address_Line_1 {get;set;}
    public String Registered_Address_Line_2 {get;set;}
    public String Registered_Address_Line_3 {get;set;}
    public String Registered_District {get;set;}
    public String Registered_Territory {get;set;}
    public String Policy_Holder_Name {get;set;}
    public String Policy_Holder_Address {get;set;}
    public String Policy_Number {get;set;}
    public String Policy_Period {get;set;}
    public String Policy_Exclusion_of_Risk {get;set;}
    public String Quote_Id {get;set;}
    public String Cover_Issue_Date {get;set;}
    public String Cover_Phone_Number {get;set;}
    public String OMBP_Quote_Id {get;set;}
    public String SBP_Quote_Id {get;set;}
    public String SUP_Quote_Id {get;set;}
    public String Policy_Heading {get;set;}
    public String Policy_Type {get;set;}
    public String Point_a {get;set;}
    public String Point_b {get;set;}
    public String Point_c {get;set;}
    public String Point_d {get;set;}
    public String Policy_Credit_Period {get;set;}
    public Decimal Policy_Maximum_Liability {get;set;}
    public Decimal Policy_Deposit {get;set;}
    public Decimal Policy_Fee {get;set;}
    public Decimal Policy_Percentage_of_Indemnity {get;set;}
    public Decimal Policy_Loss_Amount {get;set;}
    public Decimal Policy_AOL {get;set;}
    public Date Policy_Schedule {get;set;}
    public Date Policy_Commencement_Date {get;set;}
    public Date Policy_Issue_Date {get;set;}   
    public Boolean is_Product_Ombp {get;set;}
    public Boolean is_Product_Sbp {get;set;}
    public Boolean is_Product_Sup {get;set;}
    // -----------------------------------------------
    public String Policy_Account_Name {get;set;}
    public String Policy_Invoice_Number {get;set;}
    public String Policyholder_s_Ref {get;set;}
    public String Buyer_s_Code {get;set;}
    public String Payment_Terms {get;set;}
    public String Currency_Code {get;set;}
    public String Premium_Cycle {get;set;}
    public Date Policy_Invoice_Issue_Date {get;set;}
    public Date Policy_Invoice_Due_Date {get;set;}
    public Date Transaction_Date {get;set;}
    public Date Shipment_Date {get;set;}
    public Date Premium_Due_Date {get;set;}
    public Decimal Gross_Invoice_Value {get;set;}
    public Decimal Exchange_Rate {get;set;}
    public Decimal Premium_Rate {get;set;}
    public Decimal Premium {get;set;}
    public Decimal Discount {get;set;}
    public Decimal Net_Premium {get;set;}
    public Decimal Line_Amount {get;set;}
    public Decimal Invoice_Total {get;set;}
    public Decimal Invoice_Total_SD {get;set;}
    public Decimal Invoice_Total_CCF {get;set;}
    public Decimal Total_Premium {get;set;}
    public String renderAs {get;set;}
    public String Invoice_Id {get;set;}
    public String Loading_Value {get;set;}
    public DateTime Payment_Date {get;set;}
    public String Payment_Message {get;set;}
    public String Previous_Balence {get;set;}
    public Decimal Payment_Amount {get;set;}
    public Decimal Remaining_Amount {get;set;}


    public List<AggregateResult> Invoice_Total_list {get;set;}
    public List<AggregateResult> Invoice_Total_list_SD {get;set;}
    public List<AggregateResult> Invoice_Total_list_CCF {get;set;}
    public List<Invoice_Line__c> invoiceLinesList {get;set;}
    public List<Invoice_Line__c> invoiceLinesSUPList {get;set;}
    public List<Invoice_Line__c> invoiceLinesCCFList {get;set;}
    public List<Dynamic_Price__c> dynamicPriceList {get;set;}
    // --------------------------------------------------------
    List<Related_Endorsement__c>  allEndorsementList = new List<Related_Endorsement__c>();
    public String Endorsement_P_N {get;set;}
    public String Endorsement_P_A {get;set;}
    public Date Endorsement_Eff_Date {get;set;}
    public Date Endorsement_Issue_Date {get;set;}
    // -----------------------------------------------------------
    
    public String endorsementID {get;set;}
    public String contentFromCMS {get;set;}
    //Added by satya
    public String Subsidiary_Name  {get;set;}
    public String Subsidiary_Country  {get;set;}
    public String Buyer_Name {get;set;}
    public String Buyer_Code {get;set;}
    public String Buyer_Country {get;set;}
    public String Premium_Rate_DP {get;set;}
    public String Premium_Rate_DA_OA_0_30 {get;set;}
    public String Premium_Rate_DA_OA_31_60 {get;set;}
    public String Premium_Rate_DA_OA_61_90 {get;set;}
    public String Premium_Rate_DA_OA_91_180 {get;set;}
    public String legacyCustomerNumber{get;set;}//6 -digit customer no
    public String user_id{get;set;}
    public Decimal Number_of_credit_limit_applications{get;set;}
    public String Proposal_Submission_Date{get;set;}
    public String issueDateOfFirstCL{get;set;}
    public String scheduleOneIssueDate {get;set;} 
    public String scheduleTwoIssueDate {get;set;} 
    public String scheduleTwoEffectiveDate {get;set;} 
    public String scheduleThreeIssueDate {get;set;} 
    public String scheduleThreeEffectiveDate {get;set;}
    public String scheduleFourIssueDate {get;set;} 
    public String scheduleFourEffectiveDate {get;set;} 
    public String coverIssueDate {get;set;} 
    public String DocumentIssueDate {get;set;} 
    public String policyCommencementDate {get;set;} 
    public String effectiveDate{get;set;}
    public List<WrapperOmbpCountryClause> OMBPclauseCountryList{get;set;}
    public class WrapperOmbpCountryClause{
        public String id{get;set;}
        public String name{get;set;}
        public String code{get;set;}
    }
    public String headerTitle{get;set;}
    public Decimal baseRatePerAnnum{get;set;}

    public Decimal DP{get;set;}
    public Decimal DA_OA_0_30{get;set;}
    public Decimal DA_OA_31_60{get;set;}
    public Decimal DA_OA_61_90{get;set;}
    public Decimal DA_OA_91_120{get;set;}

    public Decimal DP_NonA{get;set;}
    public Decimal DA_OA_0_30_NonA{get;set;}
    public Decimal DA_OA_31_60_NonA{get;set;}
    public Decimal DA_OA_61_90_NonA{get;set;}
    public Decimal DA_OA_91_120_NonA{get;set;}
    public class WrapperSchedule2CountryList{
        public String id{get;set;}
        public String name{get;set;}
        public String code{get;set;}
        public String countryGroup{get;set;}
        public String condition{get;set;}
    }
    public List<WrapperSchedule2CountryList> leftCountryList{get;set;}
    public List<WrapperSchedule2CountryList> rightCountryList{get;set;}
    
    public class WrapperSBPClause70CountryList{
        public String id{get;set;}
        public String name{get;set;}
        public String code{get;set;}
    }
    public List<WrapperSBPClause70CountryList> wrapSbpClause70CountryList{get;set;}
    

    public QuotationDocument_Pdf_controller() {
        try {

            // Reading Policy Id from Url
            Quote_Id = ApexPages.currentPage().getParameters().get('qId');
            // Invoice_Id = ApexPages.currentPage().getParameters().get('invoiceId');
            renderAs = ApexPages.currentPage().getParameters().get('renderAs');
            // endorsementID =  ApexPages.currentPage().getParameters().get('endorsementID');
            System.debug('Quote_Id ==>>'+Quote_Id);
            // Initializing values to variables
            //Cover_Issue_Date = '2021-07-08';
            //Cover_Phone_Number = 'PH000001';
            //Previous_Balence = '100';
            // SOQL Query
            
            for ( Quote__c quote : [select Product__r.Name,
                Product__r.Number_of_credit_limit_applications__c,
                Account__c,
                Account__r.Name,
                Proposal__r.Registered_Address_Line_1__c,
                Proposal__r.Registered_Address_Line_2__c,
                Proposal__r.Registered_Address_Line_3__c,
                Proposal__r.Registered_District__c,
                Proposal__r.Registered_Territory__c,
                Proposal__r.CUS_NO__c,
                // Proposal_Submission_Date__c,
                // Issue_Date_Of_First_Credit_Limit__c,
                // Policy_Commence_Date__c,
                Proposal__r.Base_Loading__c,

                // added jan16: Ari
                Proposal__r.Maximum_Liability__c,
                Proposal__r.Indemnity_Ratio__c,
                Proposal__r.DP__c, Proposal__r.DA_OA_0_30__c, Proposal__r.DA_OA_31_60__c, Proposal__r.DA_OA_61_90__c,
                Proposal__r.DA_OA_91_180__c, Proposal__r.DP_NonA__c, Proposal__r.DA_OA_0_30_NonA__c,
                Proposal__r.DA_OA_31_60_NonA__c, Proposal__r.DA_OA_61_90_NonA__c, Proposal__r.DA_OA_91_180_NonA__c,
                // Proposal__r.OA1_60__c, Proposal__r.OA61_120__c,
                Proposal__r.NQL_Amount__c, 
                // Proposal__r.Exclusion_of_Risk__c,
                Proposal__r.Base_Rate_Per_Quarter__c,
                Proposal__r.Base_Rate_Per_Anum__c,

                Issue_Date__c,
                Expiry_Date__c,
                // Effective_Date__c,
                // Type__c,
                Commencement_Date__c,
                // Renewal_Date__c,
                
                // Policy_Deposit__c,Policy_Fee__c,Policy_Period__c,Maximum_Credit_Period__c,
                // ,Buyer_Country_Market__c,
                
                // Proposal__r.Premium_Rate_On__c,
                // Pre_Shipment__c,
                CreatedDate


                from Quote__c where Id =: Quote_Id]) {

                Policy_Type = quote.Product__r.Name;
                Registered_Address_Line_1 = quote.Proposal__r.Registered_Address_Line_1__c;
                Registered_Address_Line_2 = quote.Proposal__r.Registered_Address_Line_2__c; 
                Registered_Address_Line_3 = quote.Proposal__r.Registered_Address_Line_3__c;
                Registered_District = quote.Proposal__r.Registered_District__c;
                Registered_Territory = quote.Proposal__r.Registered_Territory__c;
                legacyCustomerNumber = quote.Proposal__r.CUS_NO__c;
                Number_of_credit_limit_applications = quote.Product__r.Number_of_credit_limit_applications__c;

                // if(quote.Proposal_Submission_Date__c!=null){
                //     Date pSubDate = quote.Proposal_Submission_Date__c; 
                //     Proposal_Submission_Date = pSubDate.year()+'-'+ pSubDate.month()+'-'+ pSubDate.day();
                  
                // }
                 issueDateOfFirstCL='N/A';
                // if(quote.Issue_Date_Of_First_Credit_Limit__c!=null){
                //     Date firtstCLDate = quote.Issue_Date_Of_First_Credit_Limit__c; 
                //     issueDateOfFirstCL = firtstCLDate.year()+'-'+ firtstCLDate.month()+'-'+ firtstCLDate.day();
                // }
            Date comDate= quote.Commencement_Date__c == null? Date.today() : quote.Commencement_Date__c;
            // Date comDate = quote.Commencement_Date__c;
                if(quote.Commencement_Date__c!=null){
                    policyCommencementDate= comDate.year()+'-'+comDate.month()+'-'+comDate.day();
                }
                accountId = quote.Account__c;
                Loading_Value = String.valueOf(quote.Proposal__r.Base_Loading__c);


                //schdule 1
                Policy_Holder_Name = quote.Account__r.Name;
                Policy_Holder_Address = Registered_Address_Line_1 + '\n'+ Registered_Address_Line_2 + '\n'+ Registered_Address_Line_3;
                // Policy_Period = p_details.Policy_Period__c;
                    Policy_Maximum_Liability = quote.Proposal__r.Maximum_Liability__c;
                    // Policy_Deposit = p_details.Policy_Deposit__c;
                    // Policy_Fee = p_details.Policy_Fee__c;
                    Policy_Percentage_of_Indemnity = quote.Proposal__r.Indemnity_Ratio__c;
                    Policy_Schedule = comDate;
                    Policy_Loss_Amount = quote.Proposal__r.NQL_Amount__c;
                    // Policy_Credit_Period  = p_details.Maximum_Credit_Period__c;
                    Policy_Commencement_Date = quote.Commencement_Date__c;
                    //Policy_Issue_Date = p_details.Issue_Date__c;
                    // Policy_Exclusion_of_Risk = p_details.Exclusion_of_Risk__c;
                    // Policy_AOL = p_details.Amount_ref_to_in_Sub_cl_1_2_and_69_2__c;

                    
                    Datetime cDate = quote.CreatedDate;
                    Cover_Issue_Date=cdate.year()+'-'+cdate.month()+'-'+cdate.day();

                    scheduleOneIssueDate = cdate.year()+'-'+cdate.month()+'-'+cdate.day();
                    // if(quote.Effective_Date__c != null){
                        DateTime effDate = comDate;//quote.Effective_Date__c;//.addDays(8);
                        //effectiveDate = effDate.year()+'-'+effDate.month()+'-'+effDate.day();
                    // }
                    
                    baseRatePerAnnum = quote.Proposal__r.Base_Rate_Per_Anum__c;

                // schedule 2
                DP=quote.Proposal__r.DP__c;
                DA_OA_0_30=quote.Proposal__r.DA_OA_0_30__c;
                DA_OA_31_60=quote.Proposal__r.DA_OA_31_60__c;
                DA_OA_61_90=quote.Proposal__r.DA_OA_61_90__c;
                DA_OA_91_120=quote.Proposal__r.DA_OA_91_180__c;

                DP_NonA=quote.Proposal__r.DP_NonA__c;
                DA_OA_0_30_NonA=quote.Proposal__r.DA_OA_0_30_NonA__c;
                DA_OA_31_60_NonA=quote.Proposal__r.DA_OA_31_60_NonA__c;
                DA_OA_61_90_NonA=quote.Proposal__r.DA_OA_61_90_NonA__c;
                DA_OA_91_120_NonA=quote.Proposal__r.DA_OA_91_180_NonA__c;
                scheduleTwoIssueDate = cDate.year()+'-'+cDate.month()+'-'+cDate.day();
                scheduleTwoEffectiveDate = String.valueOf(comDate);

                //schdule 3
                scheduleThreeIssueDate = cDate.year()+'-'+cDate.month()+'-'+cDate.day();
                scheduleThreeEffectiveDate = comDate.year()+'-'+comDate.month()+'-'+comDate.day();

                //     Schedule 4
                scheduleFourIssueDate = cDate.year()+'-'+cDate.month()+'-'+cDate.day();
                scheduleFourEffectiveDate = comDate.year()+'-'+comDate.month()+'-'+comDate.day();
            }
            System.debug('Policy Type: '+Policy_Type);
            System.debug('Registered_Address_Line_1::'+Registered_Address_Line_1);
            System.debug('Registered_Address_Line_2::'+Registered_Address_Line_2);
            System.debug('Registered_Address_Line_3::'+Registered_Address_Line_3);
            System.debug('Registered_District::'+Registered_District);
            System.debug('Registered_Territory::'+Registered_Territory);
            System.debug('Number_of_credit_limit_applications::'+Number_of_credit_limit_applications);
            if (Policy_Type.equals('OMBP')) {
                // Cover
                Policy_Type = 'OMBP';
                Policy_Heading = 'Online Micro-Business Policy» (“OMBP”)';
                Point_a = '(a)	OMBP,and';
                Point_b = '(b)	Schedule';
                Point_c = '';
                Point_d = '';
                headerTitle = 'Online Micro-Business Policy (OMBP) -Schedule';
            } else if (Policy_Type.equals('SBP')) {
                // Cover
                Policy_Type = 'SBP';
                Policy_Heading = 'Small Business Policy (“SBP”)';
                Point_a = '(a)	SBP;';
                Point_b = '(b)	Schedule I ,  Schedule II and Schedule III;';
                Point_c = '(c)	Endorsement(s) to the Policy, if any; and';
                Point_d = '(d)  Personal Information Collection Statement';
                headerTitle = 'SMALL BUSINESS POLICY - SCHEDULE I';
            } else if (Policy_Type.equals('SUP')) {
                // Cover
                Policy_Type = 'SUP';
                Policy_Heading = 'Self Underwritten Policy (“SUP”)';
                Point_a = '(a)	SUP;';
                Point_b = '(b)	Schedule I, Schedule II, Schedule III and Schedule IV;';
                Point_c = '(c)	Endorsement(s) to the Policy, if any; and';
                Point_d = '(d)	Personal Information Collection Statement';
                headerTitle = 'SELF-UNDERWRITTEN POLICY - SCHEDULE I';
            }
          
            // ----------commented: Ari-----------
            // List<Invoice__c> invoiceList = new List<Invoice__c>();
            // invoiceList = [Select Id,Name,Account__r.Name,Invoice_Date__c,Due_Date__c,Policy__r.Name,Policy__r.Policyholder_s_Address__c,Total_Net_Premium_Amount__c,CreatedDate from Invoice__c where Id =: Invoice_Id];
            // System.debug('Invoice_Id::'+Invoice_Id);
            // for (Invoice__c Idetails : invoiceList) {
            //     Policy_Account_Name = Idetails.Account__r.Name;
            //     Policy_Invoice_Number = Idetails.Name;
            //     DateTime dT3 = Idetails.CreatedDate;
            //     Policy_Invoice_Issue_Date = Date.newInstance(dT3.year(), dT3.month(), dT3.day());
            //     //Policy_Invoice_Issue_Date = Idetails.CreatedDate;
            //     Policy_Invoice_Due_Date = Idetails.Due_Date__c;
            //     Total_Premium = Idetails.Total_Net_Premium_Amount__c;
            //     System.debug('Total_Premium:: '+Total_Premium);
            // }
            // // List<Invoice_Line__c> invoiceLinesList = new List<Invoice_Line__c>();
            // // invoiceLinesList = new List<Invoice_Line__c>();
            // // List<Invoice_Line__c> soqlList = new List<Invoice_Line__c>();
            // invoiceLinesSUPList = [Select Id, Name,Transaction_Date_SBP__c,Buyer_s_Code__c,Shipment_Date__c,Policyholder_s_Ref__c,Payment_Terms__c,Currency_Code__c,Gross_Invoice_Value__c,Exchange_Rate__c,Premium_Rate__c,Premium__c,Discount__c,Net_Premium__c,Line_Amount__c,Premium_Cycle__c,Premium_Due_Date__c,Description__c,Item__c,CL_application_no__c from Invoice_Line__c where Invoice__r.Id =: Invoice_Id ORDER BY Id  ];
            // invoiceLinesList = [Select Id, Name,Transaction_Date_SBP__c,Buyer_s_Code__c,Shipment_Date__c,Policyholder_s_Ref__c,Payment_Terms__c,Currency_Code__c,Gross_Invoice_Value__c,Exchange_Rate__c,Premium_Rate__c,Premium__c,Discount__c,Net_Premium__c,Line_Amount__c,Premium_Cycle__c,Premium_Due_Date__c,Description__c,Item__c,CL_application_no__c from Invoice_Line__c where Type__c = 'Shipment Declaration' AND Invoice__r.Id =: Invoice_Id ORDER BY Id  ];

            // invoiceLinesCCFList = [Select Id, Name,Transaction_Date_SBP__c,Buyer_s_Code__c,Shipment_Date__c,Policyholder_s_Ref__c,Payment_Terms__c,Currency_Code__c,Gross_Invoice_Value__c,Exchange_Rate__c,Premium_Rate__c,Premium__c,Discount__c,Net_Premium__c,Line_Amount__c,Premium_Cycle__c,Premium_Due_Date__c,Description__c,Item__c,CL_application_no__c from Invoice_Line__c where Type__c = 'Credit Check Facility' AND Invoice__r.Id =: Invoice_Id ORDER BY Id  ];
            // // for (Invoice_Line__c var : soqlList) {
            // //     soqlList.add(var)
            // // }
            // System.debug('invoiceLinesList::'+invoiceLinesList);
            // Invoice_Total_List = [Select SUM(Net_Premium__c) Premium from Invoice_Line__c where Invoice__r.Id =: Invoice_Id];
            // // Invoice__c inObj = [select Premium__c from Invoice__c where id =:Policy_Invoice_Number ];
            // // Total_Premium = inObj.Premium__c;

            // for (AggregateResult var : Invoice_Total_List) {
            //     Invoice_Total = (Decimal)var.get('Premium');
            // }
            // Invoice_Total_List_SD = [Select SUM(Net_Premium__c) Premium from Invoice_Line__c where Type__c = 'Shipment Declaration' AND Invoice__r.Id =: Invoice_Id];
            // // Invoice__c inObj = [select Premium__c from Invoice__c where id =:Policy_Invoice_Number ];
            // // Total_Premium = inObj.Premium__c;

            // for (AggregateResult var : Invoice_Total_List_SD) {
            //     Invoice_Total_SD = (Decimal)var.get('Premium');
            // }
            // System.debug('Invoice_Total_SD::'+Invoice_Total_SD);
            // Invoice_Total_List_CCF = [Select SUM(Net_Premium__c) Premium from Invoice_Line__c where Type__c = 'Credit Check Facility' AND Invoice__r.Id =: Invoice_Id];
            // // Invoice__c inObj = [select Premium__c from Invoice__c where id =:Policy_Invoice_Number ];
            // // Total_Premium = inObj.Premium__c;

            // for (AggregateResult var : Invoice_Total_List_CCF) {
            //     Invoice_Total_CCF = (Decimal)var.get('Premium');
            // }

            // System.debug('Invoice_Total_CCF::'+Invoice_Total_CCF);

            // for (Invoice_Line__c Ildetails : invoiceLinesList) {
            // //     Transaction_Date = Ildetails.Transaction_Date_SBP__c;
            //     Buyer_s_Code = Ildetails.Buyer_s_Code__c;
            // //     Shipment_Date = Ildetails.Shipment_Date__c;
            // //     Policyholder_s_Ref = Ildetails.Policyholder_s_Ref__c;
            // //     Payment_Terms = Ildetails.Payment_Terms__c;
            // //     Currency_Code = Ildetails.Currency_Code__c;
            // //     Gross_Invoice_Value = Ildetails.Gross_Invoice_Value__c;
            // //     Exchange_Rate = Ildetails.Exchange_Rate__c;
            // //     Premium_Rate = Ildetails.Premium_Rate__c;
            // //     Premium = Ildetails.Premium__c;
            // //     Discount = Ildetails.Discount__c;
            // //     Net_Premium = Ildetails.Net_Premium__c;
            // //     Line_Amount = Ildetails.Line_Amount__c;
            // //     Premium_Cycle = Ildetails.Premium_Cycle__c;
            // //     Premium_Due_Date = Ildetails.Premium_Due_Date__c;
            // }
           

            // for (Payment__c var : [Select Id,Payment_Date__c,Description__c,Amount__c from Payment__c where Invoice__c =: Invoice_Id]) {
            //     System.debug('var::'+var);
            //     DateTime dT4 = var.Payment_Date__c;
            //     Payment_Date = Date.newInstance(dT4.year(), dT4.month(), dT4.day());
            //     Payment_Message = var.Description__c;
            //     Payment_Amount = var.Amount__c;
            // }
            // if (Payment_Amount != null && Payment_Amount > 0) {
            //     Remaining_Amount = Total_Premium - Payment_Amount;
            // }else {
            //     Remaining_Amount = Total_Premium;
                
            // }
            // allEndorsementList = [select id,Name,Issue_Date__c,Type__c,Effective_Date__c,Endorsement_Type__r.Name,
            // Endorsement_Type__r.Description__c ,Buyer_Name__c,Buyer_Country__c,Buyer_Code__c,Country__c,Subsidiary_Name__c,
            // Subsidiary_Country__c
            // from Related_Endorsement__c
            // where Policy__c =: Quote_Id and id=:endorsementID];
            // System.debug('allEndorsementList : '+allEndorsementList);
            // Boolean isEN67=false;
            // for (Related_Endorsement__c var : allEndorsementList) {
            //     System.debug('var====>>'+var);
            //     if(var.Endorsement_Type__r.Name != null &&  var.Endorsement_Type__r.Name.equals('EN67')){
            //         isEN67=true;
            //     }
            //     Endorsement_P_N = var.Name;
            //     // Endorsement_P_A = var.;
            //     Endorsement_Eff_Date = var.Effective_Date__c;
            //     Endorsement_Issue_Date = var.Issue_Date__c;
            //     Subsidiary_Name = var.Subsidiary_Name__c;
            //     Buyer_Name = var.Buyer_Name__c;
            //     Subsidiary_Country = var.Subsidiary_Country__c;
            //     Buyer_Code = var.Buyer_Code__c;
            //     Buyer_Country = var.Buyer_Country__c;

            // }
            // System.debug('isEN67 ==>'+isEN67);
            // if(isEN67){
            //     List<ConnectApi.ManagedContentVersion> results;
            //     List<Id> cmsPubConIdList=new List<Id>();
            //     for(CMS_Content__c cms : [select Content_Id__c from CMS_Content__c where Type__c='EN67' and Status__c='Published']){
            //         cmsPubConIdList.add(cms.Content_Id__c);
            //     }
            //     System.debug('cmsPubConIdList ===>>'+cmsPubConIdList);
            //     if(cmsPubConIdList !=null && !cmsPubConIdList.isEmpty()){
            //         contentFromCMS = ContentManagementSystem.getCMSontentByContentIdsV1(cmsPubConIdList);
            //     }

            // }

            // comment Ari---
            // for (Policy_Schedule__c var : [Select Id,Name,Base_Loading__c,Type__c,Policy__c from Policy_Schedule__c where Type__c='Schedule 1' AND Policy__c=:Quote_Id ]) {
            //     Loading_Value = var.Base_Loading__c;
            // }
            // System.debug('Loading_Value::'+Loading_Value);
            if (Policy_Type == 'SBP') {
                dynamicPriceList = [select Id, Name, Base_Rate_Per_Anum__c, Base_Rate_Per_Quarter__c, Credit_Limit__c, Indemnity_Ratio__c,
                 Maximum_Liability__c, Non_Qualify_Loss__c, Premium_Rate_On__c, Product__c, DP__c, DA_OA_0_30__c, DA_OA_31_60__c, 
                 DA_OA_61_90__c, DA_OA_91_180__c, Loading__c, Country_Grade__c 
                 from Dynamic_Price__c 
                 where 
                 Price_Book__r.Active__c = true 
                 AND Loading__c = :Loading_Value 
                 AND Country_Grade__c = 'GRADE_A' 
                 order by Name  ];
            }
            //contentFromCMS='<table><thead>Test Head</thead><tbody>Test Body</tbody></table>';

            // comment : Ari
            // for (Policy_Schedule__c p_details : [select id,name,Issue_Date__c,Expiry_Date__c,Effective_Date__c,Maximum_Liability__c,Type__c,
            //     Policy_Commence_Date__c,Percentage_of_Indemnity__c,Policyholder_s_Address__c,Renewal_Date__c,
            //     Policy__c,Policy__r.Product__r.Name,Policy__r.Name,Policy_Holder_Name__c,
            //     Policy_Deposit__c,Policy_Fee__c,Policy_Period__c,Maximum_Credit_Period__c,
            //     Non_Qualifying_Loss_Amount__c,Exclusion_of_Risk__c,Buyer_Country_Market__c,
            //     Amount_ref_to_in_Sub_cl_1_2_and_69_2__c,
            //     Premium_Rate_On__c,
            //     Base_Rate_Per_Quarter__c,
            //     Base_Rate_Per_Anum__c,
            //     Pre_Shipment__c,
            //     DP__c,DA_OA_0_30__c,DA_OA_31_60__c,DA_OA_61_90__c,DA_OA_91_120__c,
            //     DP_NonA__c,DA_OA_0_30_NonA__c,DA_OA_31_60_NonA__c,DA_OA_61_90_NonA__c,DA_OA_91_120_NonA__c,
            //     OA1_60__c,OA61_120__c,CreatedDate,
            //     Policy__r.Policy_Commence_Date__c
            //     from Policy_Schedule__c 
            //     where Policy__c =:Quote_Id  order by Type__c]){

            //     Policy_Holder_Name = p_details.Policy_Holder_Name__c;
            //     Policy_Holder_Address = p_details.Policy_Holder_Name__c;
            //     Policy_Number = p_details.Policy__r.Name;

            //     Datetime cDate = p_details.CreatedDate;
            //     if(p_details.Type__c.equals('Schedule 1')){
            //         Policy_Period = p_details.Policy_Period__c;
            //         Policy_Maximum_Liability = p_details.Maximum_Liability__c;
            //         Policy_Deposit = p_details.Policy_Deposit__c;
            //         Policy_Fee = p_details.Policy_Fee__c;
            //         Policy_Percentage_of_Indemnity = p_details.Percentage_of_Indemnity__c;
            //         Policy_Schedule = p_details.Effective_Date__c;
            //         Policy_Loss_Amount = p_details.Non_Qualifying_Loss_Amount__c;
            //         Policy_Credit_Period  = p_details.Maximum_Credit_Period__c;
            //         Policy_Commencement_Date = p_details.Policy__r.Commencement_Date__c;
            //         //Policy_Issue_Date = p_details.Issue_Date__c;
            //         Policy_Exclusion_of_Risk = p_details.Exclusion_of_Risk__c;
            //         Policy_AOL = p_details.Amount_ref_to_in_Sub_cl_1_2_and_69_2__c;

                    
            //         Cover_Issue_Date=cDate.year()+'-'+cDate.month()+'-'+cDate.day();

            //         //Datetime cDate = p_details.CreatedDate;
            //         scheduleOneIssueDate = cDate.year()+'-'+cDate.month()+'-'+cDate.day();
            //         if(p_details.Effective_Date__c != null){
            //             DateTime effDate = p_details.Effective_Date__c;//.addDays(8);
            //             //effectiveDate = effDate.year()+'-'+effDate.month()+'-'+effDate.day();
            //         }
                    
            //         baseRatePerAnnum = p_details.Base_Rate_Per_Anum__c;
            //     }else if(p_details.Type__c.equals('Schedule 2')){
            //         DP=p_details.DP__c;
            //         DA_OA_0_30=p_details.DA_OA_0_30__c;
            //         DA_OA_31_60=p_details.DA_OA_31_60__c;
            //         DA_OA_61_90=p_details.DA_OA_61_90__c;
            //         DA_OA_91_120=p_details.DA_OA_91_120__c;

            //         DP_NonA=p_details.DP_NonA__c;
            //         DA_OA_0_30_NonA=p_details.DA_OA_0_30_NonA__c;
            //         DA_OA_31_60_NonA=p_details.DA_OA_31_60_NonA__c;
            //         DA_OA_61_90_NonA=p_details.DA_OA_61_90_NonA__c;
            //         DA_OA_91_120_NonA=p_details.DA_OA_91_120_NonA__c;
            //         scheduleTwoIssueDate = cDate.year()+'-'+cDate.month()+'-'+cDate.day();
            //         if(p_details.Effective_Date__c != null){
            //             DateTime effDate = p_details.Effective_Date__c;//.addDays(8);
            //             scheduleTwoEffectiveDate = effDate.year()+'-'+effDate.month()+'-'+effDate.day();
            //         }
            //     }else if(p_details.Type__c.equals('Schedule 3')){
            //         scheduleThreeIssueDate = cDate.year()+'-'+cDate.month()+'-'+cDate.day();
            //         if(p_details.Effective_Date__c != null){
            //             DateTime effDate = p_details.Effective_Date__c;//.addDays(8);
            //             scheduleThreeEffectiveDate = effDate.year()+'-'+effDate.month()+'-'+effDate.day();
            //         }
            //     }else if(p_details.Type__c.equals('Schedule 4')){
            //         scheduleFourIssueDate = cDate.year()+'-'+cDate.month()+'-'+cDate.day();
            //         if(p_details.Effective_Date__c != null){
            //             DateTime effDate = p_details.Effective_Date__c;//.addDays(8);
            //             scheduleFourEffectiveDate = effDate.year()+'-'+effDate.month()+'-'+effDate.day();
            //         }
            //     }else if(p_details.Type__c.equals('Policy Cover')){
            //         Cover_Issue_Date = cDate.year()+'-'+cDate.month()+'-'+cDate.day();
            //     }else if(p_details.Type__c.equals('Policy Document')){
            //         DocumentIssueDate = cDate.year()+'-'+cDate.month()+'-'+cDate.day();
            //     }
            // }
        }catch (Exception e) {
            System.debug('Error::'+e.getMessage()+'Stack '+e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
        // if(UserInfo.getUserName() !=null && UserInfo.getUserName().contains('@')){
        //     user_id = UserInfo.getUserName().split('@')[0];
        // }
        user_id = ECIC_Settings.getAccountUserName(accountID);
        OMBPclauseCountryList = new List<WrapperOmbpCountryClause>();
        for(List_Storage__c ls : GetCustomMetaData.getOMBPClauseCountryList()){
            WrapperOmbpCountryClause wp=new WrapperOmbpCountryClause();
            wp.name = ls.CTRY_CTRY_NAME__c;
            wp.code = ls.CTRY_CTRY_CODE__c;
            OMBPclauseCountryList.add(wp);
        }

        wrapSbpClause70CountryList = new List<WrapperSBPClause70CountryList>();
        List<List_Storage__c> sbpClause70CountryList = GetCustomMetaData.getClause70CountryList();
        System.debug('sbpClause70CountryList =>'+sbpClause70CountryList);
        if(sbpClause70CountryList!= null && !sbpClause70CountryList.isEmpty()){
            for(List_Storage__c ls : sbpClause70CountryList){
                WrapperSBPClause70CountryList wp=new WrapperSBPClause70CountryList();
                wp.name = ls.CTRY_CTRY_NAME__c;
                wp.code = ls.CTRY_CTRY_CODE__c;
                wrapSbpClause70CountryList.add(wp);
            }
        }
        

        List<List_Storage__c> sbpCountryList = GetCustomMetaData.getSchdule2CountryList();
        System.debug('sbpCountryList :'+sbpCountryList);
        if(sbpCountryList != null && !sbpCountryList.isEmpty()){
            Integer listSize=sbpCountryList.size();
            System.debug('listSize===>>'+listSize+' listSize/2::'+Integer.valueOf(listSize/2));
            if(listSize>1){
                leftCountryList = new List<WrapperSchedule2CountryList>();
                rightCountryList = new List<WrapperSchedule2CountryList>();
                for(Integer left=0;left<Integer.valueOf(listSize/2);left++){
                   
                    WrapperSchedule2CountryList wpCountryLeft=new WrapperSchedule2CountryList();
                    wpCountryLeft.id = sbpCountryList[left].id;
                    wpCountryLeft.name = sbpCountryList[left].CTRY_CTRY_NAME__c;
                    wpCountryLeft.code = sbpCountryList[left].CTRY_CTRY_CODE__c;
                    wpCountryLeft.countryGroup = sbpCountryList[left].CTRY_GRADE__c;
                    wpCountryLeft.condition = sbpCountryList[left].Special_Condition__c;
                    leftCountryList.add(wpCountryLeft);
                }
                for(Integer right=Integer.valueOf(listSize/2);right<listSize;right++){
                   
                    WrapperSchedule2CountryList wpCountryRight=new WrapperSchedule2CountryList();
                    wpCountryRight.id = sbpCountryList[right].id;
                    wpCountryRight.name = sbpCountryList[right].CTRY_CTRY_NAME__c;
                    wpCountryRight.code = sbpCountryList[right].CTRY_CTRY_CODE__c;
                    wpCountryRight.countryGroup = sbpCountryList[right].CTRY_GRADE__c;
                    wpCountryRight.condition = sbpCountryList[right].Special_Condition__c;
                    rightCountryList.add(wpCountryRight);
                }
            }else{
                if(listSize==1){
                    System.debug('Found only one country');
                    WrapperSchedule2CountryList wpCountry=new WrapperSchedule2CountryList();
                    wpCountry.name = sbpCountryList[0].CTRY_CTRY_NAME__c;
                    wpCountry.code = sbpCountryList[0].CTRY_CTRY_CODE__c;
                    wpCountry.countryGroup = sbpCountryList[0].CTRY_GRADE__c;
                    wpCountry.condition = sbpCountryList[0].Special_Condition__c;
                    leftCountryList.add(wpCountry);
                }
            }
        }
        System.debug('leftCountryList=='+leftCountryList);
        System.debug('rightCountryList=='+rightCountryList);
    }
}