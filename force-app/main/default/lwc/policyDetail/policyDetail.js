import { LightningElement ,  track , wire, api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import getPolicyHolderData from '@salesforce/apex/PolicyManagement.getPolicyHolderData';
import terminatePolicy from '@salesforce/apex/PolicyManagement.terminatePolicy'
import getAllEndorsements from '@salesforce/apex/PolicyManagement.fetchAllEndorsements'
import getAllSchedule from '@salesforce/apex/PolicyManagement.getAllSchedule'

import current_user from '@salesforce/user/Id';
import USERNAME_FIELD from '@salesforce/schema/User.Username';
import { getRecord } from 'lightning/uiRecordApi';
import getDomainBaseURL from '@salesforce/apex/PolicyManagement.getDomainBaseURL'
import autoRenwalDateChecking from '@salesforce/apex/PolicyManagement.autoRenwalDateChecking'
import Terminate_Policy from '@salesforce/label/c.Terminate_Policy';
import Renew_Policy from '@salesforce/label/c.Renew_Policy';
import Schedule from '@salesforce/label/c.Schedule';
import Endorsement from '@salesforce/label/c.Endorsement';
import LV from '@salesforce/label/c.LV';
import Company_Name from '@salesforce/label/c.Company_Name';
import Login_Account from '@salesforce/label/c.Login_Account';
import 	Policy_Number from '@salesforce/label/c.Policy_Number';
import Schedule1 from '@salesforce/label/c.Schedule1';
import Policyholder_name from '@salesforce/label/c.Policyholder_name';
import Policyholder_Address from '@salesforce/label/c.Policyholder_Address';
import Commencement_Date from '@salesforce/label/c.Commencement_Date';
import Issue_Date_of_1st_Credit_Limit from '@salesforce/label/c.Issue_Date_of_1st_Credit_Limit';
import This_schedule_takes_effect_from from '@salesforce/label/c.This_schedule_takes_effect_from';
import Maximum_Liability from '@salesforce/label/c.Maximum_Liability';
import Percentage_of_Indemnity from '@salesforce/label/c.Percentage_of_Indemnity';
import Policy_period from '@salesforce/label/c.Policy_period';
import Policy_deposit from '@salesforce/label/c.Policy_deposit';
import Policy_fee from '@salesforce/label/c.Policy_fee';
import Maximum_credit_period from '@salesforce/label/c.Maximum_credit_period';
import Amount_referred_to_in_Sub_clauses_1_2_and_69_2 from '@salesforce/label/c.Amount_referred_to_in_Sub_clauses_1_2_and_69_2';
import Non_qualifying_loss_amount from '@salesforce/label/c.Non_qualifying_loss_amount';
import Exclusion_of_risk from '@salesforce/label/c.Exclusion_of_risk';
import Countries_Markets_of_Shipments_Clause from '@salesforce/label/c.Countries_Markets_of_Shipments_Clause';
import Remark_The_Maximum_amount_shall_not_exceed_each_12_month from '@salesforce/label/c.Remark_The_Maximum_amount_shall_not_exceed_each_12_month';
import Schedule2 from '@salesforce/label/c.Schedule2';
import Schedule3 from '@salesforce/label/c.Schedule3';
import Schedule4 from '@salesforce/label/c.Schedule4';
import getWrapperPolicyHolderData from '@salesforce/apex/PolicyManagement.getWrapperPolicyHolderData';
import getOMBPClauseCountryList from '@salesforce/apex/GetCustomMetaData.getOMBPClauseCountryList';
import upDateAutoRenewalSetting from '@salesforce/apex/PolicyManagement.upDateAutoRenewalSetting';
import getWrapperAllSchedule from '@salesforce/apex/PolicyManagement.getWrapperAllSchedule';
import Cover from '@salesforce/label/c.Cover';
import Country_Market_of_Shipment from '@salesforce/label/c.Country_Market_of_Shipment';
import Code from '@salesforce/label/c.Code';
import Download_PDF from '@salesforce/label/c.Download_PDF';
import Acceptance_of_Policy_Renewal from '@salesforce/label/c.Acceptance_of_Policy_Renewal';
import Please_confirm_your_understanding_and_acceptance_of_the_terms_and_conditions_of from '@salesforce/label/c.Please_confirm_your_understanding_and_acceptance_of_the_terms_and_conditions_of';
import the_Schedules_and_any_endorsements_on_or_before from '@salesforce/label/c.the_Schedules_and_any_endorsements_on_or_before';
import Accept from '@salesforce/label/c.Accept';
import Variation_of_Cover from '@salesforce/label/c.Variation_of_Cover';
import Choice_of_optional_cover_to_better_suit_your_needs from '@salesforce/label/c.Choice_of_optional_cover_to_better_suit_your_needs';
import By_Selecting_different_options_the_renewal_offer_may_be_revised from '@salesforce/label/c.By_Selecting_different_options_the_renewal_offer_may_be_revised';
import Revise_Offer from '@salesforce/label/c.Revise_Offer';
import If_you_have_any_queries_please_contact_SME_team_at_2732_9988_or_via from '@salesforce/label/c.If_you_have_any_queries_please_contact_SME_team_at_2732_9988_or_via';
import Auto_Renewal from '@salesforce/label/c.Auto_Renewal';
import Please_Select_the_mode_of_renewal_for_your_policy from '@salesforce/label/c.Please_Select_the_mode_of_renewal_for_your_policy';
import This_Policy_is_terminated_with_immediate_effect_All_credit_limit_s_expire from '@salesforce/label/c.This_Policy_is_terminated_with_immediate_effect_All_credit_limit_s_expire';
import Reason_for_Termination from '@salesforce/label/c.Reason_for_Termination';
import Cancel from '@salesforce/label/c.Cancel';
import Confirm from '@salesforce/label/c.Confirm';
import LV_1 from '@salesforce/label/c.LV_1';
import LV_2 from '@salesforce/label/c.LV_2';
import Acceptance from '@salesforce/label/c.Acceptance';
import Automatic_Renewal from '@salesforce/label/c.Automatic_Renewal';
import Manual_Renewal from '@salesforce/label/c.Manual_Renewal';
import Case_of_Bussiness from '@salesforce/label/c.Case_of_Bussiness';
import Looking_for_larger_credit_limit from '@salesforce/label/c.Looking_for_larger_credit_limit';
import Claims_experience from '@salesforce/label/c.Claims_experience';
import No_export_Business from '@salesforce/label/c.No_export_Business';
import Premium_Rate from '@salesforce/label/c.Premium_Rate';
import Switch_to_other_HKECIC_Policy from '@salesforce/label/c.Switch_to_other_HKECIC_Policy';
import Switch_to_other_Insurance_Company from '@salesforce/label/c.Switch_to_other_Insurance_Company';
import Transfer_of_business_to_other_associate_company from '@salesforce/label/c.Transfer_of_business_to_other_associate_company';
import Issue_Date from '@salesforce/label/c.Issue_Date';
import Effective_Date from '@salesforce/label/c.Effective_Date';
import Schedule_Type from '@salesforce/label/c.Schedule_Type';
import Download from '@salesforce/label/c.Download';
import Number from '@salesforce/label/c.Number';
import Type from '@salesforce/label/c.Type';
import LV_No from '@salesforce/label/c.LV_No';
import Status from '@salesforce/label/c.Status';
import Schedule_Record from '@salesforce/label/c.Schedule_Record';
import checkCarryForwardEndorsement from '@salesforce/apex/PolicyManagement.checkCarryForwardEndorsement';



const scheduleColumns = [
    { label: 'Issue Date', fieldName: 'scheduleIssueDate' },
    { label: 'Effective Date', fieldName: 'scheduleEffectiveDate'},
    { label: 'Schedule Type', fieldName: 'scheduleType' }
];
const endorsementAction = [
    { label: 'Download', name: 'Download' }
];
const endorsementColumns = [
    { label: 'No.', fieldName: 'name'},
    { label: 'Issue Date', fieldName: 'issueDate' },
    { label: 'Type', fieldName: 'type' },
    {
        type: 'action',
        typeAttributes: { rowActions: endorsementAction },
    },
];

const lvColumns = [
    { label: 'Issue Date', fieldName: 'issueDate' },
    { label: 'LV No.', fieldName: 'lvNo'},
    { label: 'Status', fieldName: 'status' },
    { label: '', fieldName: 'action' }
];


export default class PolicyDetail extends NavigationMixin(LightningElement) {


    @track label = {

        Terminate_Policy,Renew_Policy,Schedule,Endorsement,LV,Company_Name,Login_Account,Policy_Number,Schedule1,LV_No,
        Policyholder_name,Policyholder_Address,Commencement_Date,Issue_Date_of_1st_Credit_Limit,This_schedule_takes_effect_from,
        Maximum_Liability,Percentage_of_Indemnity,Policy_period,Policy_deposit,Policy_fee,Maximum_credit_period,Number,
        Amount_referred_to_in_Sub_clauses_1_2_and_69_2,Non_qualifying_loss_amount,Exclusion_of_risk,Effective_Date,Type,Status,
        Countries_Markets_of_Shipments_Clause,Remark_The_Maximum_amount_shall_not_exceed_each_12_month,Schedule2,Schedule_Type,
        Schedule3,Schedule4,Cover,Country_Market_of_Shipment,Code,Download_PDF,Acceptance_of_Policy_Renewal,Issue_Date,Download,
        Please_confirm_your_understanding_and_acceptance_of_the_terms_and_conditions_of,the_Schedules_and_any_endorsements_on_or_before,
        Accept,Variation_of_Cover,Choice_of_optional_cover_to_better_suit_your_needs,By_Selecting_different_options_the_renewal_offer_may_be_revised,
        Revise_Offer,If_you_have_any_queries_please_contact_SME_team_at_2732_9988_or_via,Auto_Renewal,Please_Select_the_mode_of_renewal_for_your_policy,
        This_Policy_is_terminated_with_immediate_effect_All_credit_limit_s_expire,Reason_for_Termination,Cancel,Confirm,LV_1,LV_2,Acceptance,
        Schedule_Record,Manual_Renewal,Automatic_Renewal,Case_of_Bussiness,Claims_experience,Looking_for_larger_credit_limit,No_export_Business,Premium_Rate,
        Switch_to_other_HKECIC_Policy,Switch_to_other_Insurance_Company,Transfer_of_business_to_other_associate_company




    }

// @track scheduleColumns = [
//     { label: this.label.Issue_Date, fieldName: 'scheduleIssueDate' },
//     { label: this.label.Effective_Date, fieldName: 'policyCommenceDate'},
//     { label: this.label.Schedule_Type, fieldName: 'scheduleType' }
// ];
// @track endorsementAction = [
//     { label: this.label.Download, name: 'Download' }
// ];
// @track endorsementColumns = [
//     { label: this.label.Number, fieldName: 'name'},
//     { label: this.label.Issue_Date, fieldName: 'issueDate' },
//     { label: this.label.Type, fieldName: 'type' },
//     {
//         type: 'action',
//         typeAttributes: { rowActions: endorsementAction },
//     },
// ];

// @track lvColumns = [
//     { label: this.label.Issue_Date, fieldName: 'issueDate' },
//     { label: this.label.LV_No, fieldName: 'lvNo'},
//     { label: this.label.Status, fieldName: 'status' },
//     { label: '', fieldName: 'action' }
// ];

    @track companyName;
    @track currentPolicy;
    @track currentPolicyID;
    @track policyNumber;
    
    @track renewalDate;
    
    @track showScheduleSection;
    @track allSchedule;

    @track showEndorsement;
    @track allEndorsement;

    @track showLV;
    @track allLV;
    
    @track showPolicyRenewalSection;
    @track policyRenewalButtonStatefulState;
    @track terminateButtonStatefulState;
    @track endorsementButtonStatefulState;
    @track scheduleButtonStatefulState;
    @track laButtonStatefulState;
    @track scheduleColumns = scheduleColumns;
    @track endorsementColumns = endorsementColumns;
    @track lvColumns = lvColumns;
    @track userId = current_user;
    @track exceptionDetail;
    @track accInfo;
    @track isPolicyHolderAllowedToTerminatePolicy;
    @track policyTerminationPopUp;
    @track reasonForTermination;
    @track isLoading;

    @track currentPolicyHolderAddress;
    @track currentPolicyIssueDate;
    @track maximumLiabilty;
    @track commencementDate;
    @track percentageOfIndmenity;
    @track isPolicySchedule1Remarks;
    @track showReviseSection;
    @track currentPolicyName;
    @track isProductOMBP = false;
    @track isProductSBP = false;
    @track isProductSUP = false;
    @track isShowScheduleOne =  true;
    @track isShowScheduleTwo =  false;
    @track isShowScheduleThree =  false;
    @track isShowScheduleFour =  false;

    @track mapDataPassToSchedule = [];
    @track isProductId;
    
    @track policyHolderRegAdd;
    @track loadCover=false;

    @track policyPeriod;
    @track policyFee;
    @track policyDeposit;
    @track maxCreditPeriod;
    @track nonQualifyingLossAmt;
    @track exclusionRisk;
    @track buyerMarkets;
    @track amt_ref_in_sab_clause;


    @track error;
    @track logged_in_user;
    @track currentOpenTab;
    @track renewalMode;
    @track renewalModeList;
    @track isEnablePolicyRenewal=true;
    @track policyExpireyDate;
    @track domainBaseURL;

    @track Registered_Address_Line_1;
    @track Registered_Address_Line_2;
    @track Registered_Address_Line_3;
    @track Registered_District;
    @track Registered_Territory;
    @track Proposal_Submission_Date;
    @track policyHolderName;
    @track issueDate;
    @track dynamicSheduleOne;
    @track issueDateOfFirstCL;
    @track policyCommenceDate;

    @track Cover_PDF_Link;
    @track Schedule_1_Link;
    @track Schedule_2_Link;
    @track Schedule_3_Link;
    @track Schedule_4_Link;
    @track isCoverSigned;
    @track isSchedule1Signed;
    @track isSchedule2Signed;
    @track isSchedule3Signed;
    @track isSchedule4Signed;
    @track showPhEndorsement;
    @track isLimitedAccess;
    @track limitedAccessDate;
    @track isLimitedAccessWithinSixMonth;
    @track policyStatus;
    @track isPolicyValid;
    @track isPolTerminationWithinSixMonth;

    @wire(getRecord, {
        recordId: current_user,
        fields: [USERNAME_FIELD]
    }) wireuser({
        error,
        data
    }) {
        if (error) {
        this.error = error ; 
        } else if (data) {
            console.log('data.fields : '+JSON.stringify(data.fields));
            this.logged_in_user = data.fields.Username.value;
        }
    }
    
    connectedCallback(){
        this.isLoading = true;
        console.log('userId :: '+this.userId);
        this.currentOpenTab = 'Cover';
        this.policyRenewalButtonStatefulState = false;
        this.endorsementButtonStatefulState = false;
        this.scheduleButtonStatefulState = false;
        this.laButtonStatefulState = false;
        this.terminateButtonStatefulState = false
        this.showEndorsement = false;
        

        this.showLV = false;
        this.allLV = [
            { id: 'LV001',issueDate:'2021-05-21', lvNo: 'LV2020518', status:'EN49A',action:'Download' },
            { id: 'LV002',issueDate:'2021-05-21', lvNo: 'LV2021423', status:'EN49A',action:'Download' },
        ];

        this.showScheduleSection = true;
        
        this.isPolicyHolderAllowedToTerminatePolicy = false;
        this.getPolicyHolderData();
        this.getAllSchedule();
        this.isPolicySchedule1Remarks = true;
        this.renewalModeList = [
            { label: this.label.Automatic_Renewal, value: 'Automatic Renewal' },
            { label: this.label.Manual_Renewal, value: 'Manual Renewal' }
        ];
        this.getDomainBaseURLJS();
        this.getModifiedPolicyHolderData();
        
        this.getModifiedAllSchedule();
        this.isLoading = false;
        
    }
    get options() {
        return [
            { label: this.label.Case_of_Bussiness, value: 'Case of Bussiness' },
            { label: this.label.Claims_experience, value: 'Claims experiance' },
            { label: this.label.Looking_for_larger_credit_limit, value: 'Looking for larger credit limit' },
            { label: this.label.No_export_Business, value: 'No export Bussiness' },
            { label: this.label.Premium_Rate, value: 'Premium Rate' },
            { label: this.label.Switch_to_other_HKECIC_Policy, value: 'Switch to other HKECIC Policy' },
            { label: this.label.Switch_to_other_Insurance_Company, value: 'Switch to other Insurance Company' },
            { label: this.label.Transfer_of_business_to_other_associate_company, value: 'Transfer of bussiness to other assosiate company' },
        ];
    }
    getDomainBaseURLJS(){
        getDomainBaseURL({}).then(data => {
            console.log('getDomainBaseURL success :'+JSON.stringify(data));
            this.domainBaseURL = data;

        }).catch(error => {
            console.log('Error : '+error.toString()+' '+JSON.stringify(error));
        });
    }
    getAllSchedule(){
        console.log('getAllSchedule called.');
        getAllSchedule({
            usrId : this.userId
        }).then(data => {
            console.log('getAllSchedule success :'+JSON.stringify(data));
            try {
                //this.allSchedule = data;
                for(let sch in data){
                    if(data[sch].Type__c === 'Schedule 1'){
                        console.log('Schedule 1*********************x');
                        this.currentPolicyHolderAddress = data[sch].Policyholder_s_Address__c;
                        this.policyHolderRegAdd = this.currentPolicyHolderAddress;
                        this.policyHolderName = data[sch].Policy_Holder_Name__c
                        this.currentPolicyIssueDate = data[sch].Issue_Date__c;
                        this.maximumLiabilty = data[sch].Maximum_Liability__c;
                        //this.commencementDate =data[sch].Commencement_Date__c;
                        this.percentageOfIndmenity = data[sch].Percentage_of_Indemnity__c;
                        this.issueDate = data[sch].CreatedDate;
                        this.renewalDate = data[sch].Renewal_Date__c;
                        var effectiveDate = data[sch].Effective_Date__c;

                        //this.policyDeposit = data[sch].Policy_Deposit__c;
                        //this.policyFee = data[sch].Policy_Fee__c;
                        //this.policyPeriod = data[sch].Policy_Period__c;
                        this.maxCreditPeriod = data[sch].Maximum_Credit_Period__c;
                        this.nonQualifyingLossAmt = data[sch].Non_Qualifying_Loss_Amount__c;
                        if(data[sch].Buyer_Country_Market__c){
                            this.buyerMarkets = data[sch].Buyer_Country_Market__c.replaceAll(';','\n');
                        }
                        
                        if(data[sch].Exclusion_of_Risk__c){
                            this.exclusionRisk = data[sch].Exclusion_of_Risk__c.replaceAll(';',' and ');
                        }
                        this.amt_ref_in_sab_clause = data[sch].Amount_ref_to_in_Sub_cl_1_2_and_69_2__c;
                        
                        
                        var policyNumber  = data[sch].Policy__r.Name;
                        console.log('effectiveDate : '+effectiveDate+' policyNumber:'+policyNumber+' issueDate:'+this.issueDate)
                        this.mapDataPassToSchedule.push({key:'policyNumber',value:policyNumber}); 
                        this.mapDataPassToSchedule.push({key:'issueDate',value:this.issueDate}); 
                        this.mapDataPassToSchedule.push({key:'effectiveDate',value:effectiveDate}); 
                        console.log('mapDataPassToSchedule  both '+JSON.stringify(this.mapDataPassToSchedule));
                        this.loadCover=true;
                        this.companyName = this.policyHolderName;
                    }else if(data[sch].Type__c === 'Schedule 2'){
                        console.log('Schedule 2*********************');
                    }else if(data[sch].Type__c === 'Schedule 3'){
                        console.log('Schedule 3*********************');
                    }else if(data[sch].Type__c === 'Schedule 4'){
                        console.log('Schedule 4*********************');
                    }
                }
            } catch (error) {
               
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while fetching Policy Schedule',
                        message: error.toString(),
                        mode : 'sticky',
                        variant: 'warning'
                    })
                );
            }
            
        }).catch(error => {
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while fetching Schedule',
                    message: error.toString(),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
    
    getPolicyHolderData(){
        console.log('getPolicyHolderData called.');
        getPolicyHolderData({
            usrId : this.userId
        }).then(data => {
            console.log('getPolicyHolderData success :'+JSON.stringify(data));
            try {
                this.accInfo = data;
                //this.companyName = data.Current_Policy__r.Policy_Holders_Name__c;
                this.currentPolicyID = data.Current_Policy__c;
                this.currentPolicy = data.Current_Policy__r.Product__r.Name;
                this.policyNumber = data.Current_Policy__r.Name;
                this.currentPolicyName = data.Current_Policy__r.Product__r.Full_Name__c;
                this.isProductId = data.Current_Policy__r.Product__c;
                this.policyExpireyDate = data.Current_Policy__r.Expiry_Date__c;
                // if(data.Current_Policy__r.Status__c === 'Valid' && data.Current_Policy__r.Allow_Policy_Holder_To_Terminate__c){
                //     this.isPolicyHolderAllowedToTerminatePolicy  = true;
                // }
                if(data.Current_Policy__r.Allow_Policy_Holder_To_Terminate__c){
                         this.isPolicyHolderAllowedToTerminatePolicy  = true;
                }
                if(this.currentPolicy === 'OMBP'){
                    this.isProductOMBP = true;
                    this.isShowScheduleOne = true;
                    this.dynamicSheduleOne = this.label.Schedule;
                }else if(this.currentPolicy === 'SBP'){
                    this.isProductSBP = true;
                    this.isShowScheduleOne = true;
                    this.isShowScheduleTwo = true;
                    this.isShowScheduleThree = true;//It has some dependiecies
                    this.dynamicSheduleOne = this.label.Schedule1;
                }else if(this.currentPolicy === 'SUP'){
                    this.isProductSUP= true;
                    this.isShowScheduleOne = true;
                    this.isShowScheduleTwo = true;
                    this.isShowScheduleThree = true;//It has some dependiecies
                    this.isShowScheduleFour = true;//if DCL present then Schedule 4 available
                    this.dynamicSheduleOne = this.label.Schedule1;
                }
                this.commencementDate = data.Current_Policy__r.Commencement_Date__c;
                console.log('dynamicSheduleOne ==>>'+this.dynamicSheduleOne+' this.Schedule:'+this.label.Schedule+' this.Schedule1:'+this.label.Schedule1);
            } catch (error) {
               
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while fetching User data',
                        message: error.toString()+' '+JSON.stringify(error),
                        mode : 'sticky',
                        variant: 'warning'
                    })
                );
            }
            
        }).catch(error => {
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while fetching User data',
                    message: error.toString()+' '+JSON.stringify(error),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
    handleOnselect(event){
        console.log('handleOnselect called.'+event);
        this.scheduleButtonStatefulState = false;
        this.endorsementButtonStatefulState = false;
        this.laButtonStatefulState = false;
    }
    handleTerminate(event){
        console.log('handleTerminate called.'+event);
        this.policyTerminationPopUp = true;
    }
    handleReasonForChange(event){
        console.log('handleReasonForChange called.'+event.target.value);
        this.reasonForTermination = event.target.value;
        
    }
    policyPopCancel(event){
        console.log('policyPopCancel called.'+event);
        this.policyTerminationPopUp = false;
    }
    policyTerminationConfirm(event){
        this.isLoading = true;
        console.log('policyTerminationConfirm called.'+event+' ReasonForTermination :'+this.reasonForTermination);
        terminatePolicy({
            policyID : this.currentPolicyID,
            reasonForTermination : this.reasonForTermination
        }).then(data => {
            console.log('terminatePolicy success :'+JSON.stringify(data));
            try {
                this.isLoading = false;
                if(data){
                    this.policyTerminationPopUp = false;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Policy Termination',
                            message: 'Policy (NO. '+this.policyNumber+') has been terminated, please download the Termination Letter for your record.',
                            mode : 'sticky',
                            variant: 'success'
                        })
                    );
                }else{
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Policy (NO. '+this.policyNumber+') Termination Failed',
                            message: 'Please check with HKECIC',
                            mode : 'sticky',
                            variant: 'error'
                        })
                    );
                }
            } catch (error) {
                this.isLoading = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Policy (NO. '+this.policyNumber+') Termination Failed',
                        message: error.toString(),
                        mode : 'sticky',
                        variant: 'warning'
                    })
                );
            }
            
        }).catch(error => {
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while fetching User data',
                    message: error.toString(),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
    handleSchedule(event){
        console.log('handleSchedule called.');
        this.showScheduleSection = true;
        this.showEndorsement = false;
        this.showLV=false;
        this.scheduleButtonStatefulState = true;
        this.endorsementButtonStatefulState = false;
        this.laButtonStatefulState = false;
        this.showPolicyRenewalSection = false;
        this.showReviseSection = false;
    }
    handleEndorsement(event){
        console.log('handleEndorsement called.');
        this.showEndorsement = true;
        this.showScheduleSection = false;
        this.showLV=false;
        this.endorsementButtonStatefulState = true;
        this.scheduleButtonStatefulState = false;
        this.laButtonStatefulState = false;
        this.showPolicyRenewalSection = false;
        this.showReviseSection = false;
        this.getAllEndorsements();
    }
    getAllEndorsements(){
        getAllEndorsements({
            policyID : this.currentPolicyID
        }).then(data => {
            console.log(' fetchAllEndorsements success :'+JSON.stringify(data));
            try {
                this.allEndorsement = data;
           } catch (error) {
               console.log('1 error.toString() '+error.toString()+' '+JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while fetching Endorsement',
                        message: error.toString(),
                        mode : 'sticky',
                        variant: 'warning'
                    })
                );
            }
            
        }).catch(error => {
            console.log('2 error.toString() '+error.toString()+' '+JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while fetching Endorsement data',
                    message: error.toString(),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
    handleLV(event){
        console.log('handleLV called.');
        this.showLV = true;
        this.showScheduleSection = false;
        this.showEndorsement = false;
        this.laButtonStatefulState = true;
        this.endorsementButtonStatefulState = false;
        this.scheduleButtonStatefulState = false;
        this.showPolicyRenewalSection = false;
        this.showReviseSection = false;
    }
    handlePolicyRenewal(event){
        console.log('handlePolicyRenewal called.');
        this.showPolicyRenewalSection = true;
        this.showEndorsement = false;
        this.showScheduleSection = false;
        this.showLV=false;
        this.endorsementButtonStatefulState = false;
        this.scheduleButtonStatefulState = false;
        this.laButtonStatefulState = false;
        this.showReviseSection = false;
        this.handlePolicyRenewalMode();
    }
    acceptPolicyRenewal(event){
        this.getAllEndorsements();
        console.log('acceptPolicyRenewal show related endorsement : '+event);
        this.showPhEndorsement = true;
    }
    endorsementPopUpCancel(event){
        console.log('endorsementPopCancel called.'+event);
        this.showPhEndorsement = false;
    }
    removeFromNextYear(event){
        console.log('removeFromNextYear tar val : '+event.target.value+' checked : '+event.target.checked+' event.detail.value :'+event.detail.value+' event.detail.checked:'+event.detail.checked); 
        if(!event.target.checked){
            console.log('You want to cancel for the next policy year');
            let y = confirm('You want to cancel it for the next policy year?');
            console.log('y : '+y);
            if(y){
                //proceed with cancellation
                checkCarryForwardEndorsement({
                    relEndId : event.target.value,
                    isCarryForward : event.target.checked
                }).then(data => {
                    console.log('checkCarryForwardEndorsement success :'+JSON.stringify(data));
                    if(data){
                        this.getAllEndorsements();
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Successfully cancelled for next year.',
                                message: '',
                                mode : 'sticky',
                                variant: 'success'
                            })
                        );
                    }else{
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Exception Occurred Cancelling Endorsement For Next Year.',
                                message: '',
                                mode : 'sticky',
                                variant: 'error'
                            })
                        );
                    }
                }).catch(error => {
                    console.log('checkCarryForwardEndorsement error.toString() '+error.toString()+' '+JSON.stringify(error));
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Exception Occurred while fetching Endorsement data',
                            message: error.toString(),
                            mode : 'sticky',
                            variant: 'error'
                        })
                    );
                });
            }
        }
        // else{
        //     console.log('You want to keep this for the next policy year');
        //     let y = confirm('You want to keep this for the next policy year?');
        //     console.log('y : '+y);
        //     if(y){
        //        //proceed with addition
        //     }
        // }

    }
    reviseOffer(event){``
        console.log('reviseOffer called for product :  '+this.currentPolicy);
        console.log('reviseOffer isProductOMBP :'+this.isProductOMBP+'\n isProductSBP:'+this.isProductSBP+'\n isProductSUP : '+this.isProductSUP );
            this.showPolicyRenewalSection = false;
            this.showReviseSection = true;
        /*if(this.currentPolicy === 'SBP' || this.currentPolicy === 'SUP'){
            console.log('Found : '+this.currentPolicy);
            this.showPolicyRenewalSection = false;
            this.showReviseSection = true;
        }else{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Policy Renewala only applicable for SBP & SUP.',
                    message: 'Policy Renewal not applicable for '+this.currentPolicy,
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        }*/
        
    }
    handleActive(event) {
        const tab = event.target;
        console.log('handleActive tab =='+tab+' event.target.value=='+event.target.value+' this.currentOpenTab:'+this.currentOpenTab);
        if(this.domainBaseURL){
            this.currentOpenTab = event.target.value;
            if(this.currentOpenTab === 'Cover' ){
                //this.currentOpenTab = 'https://'+this.domainBaseURL+'/ECReach/apex/PolicyDocumentCover?policyID='+this.currentPolicyID;
            }else if(this.currentOpenTab === 'Schedule_1'){
                //this.currentOpenTab = 'https://'+this.domainBaseURL+'/ECReach/apex/PolicyScheduleOne?policyID='+this.currentPolicyID;
            }else if(this.currentOpenTab === 'Schedule_2'){
                //this.currentOpenTab = 'https://'+this.domainBaseURL+'/ECReach/apex/PolicyScheduleTwo?policyID='+this.currentPolicyID;
            }else if(this.currentOpenTab === 'Schedule_3'){
                //this.currentOpenTab = 'https://'+this.domainBaseURL+'/ECReach/apex/PolicyScheduleThree?policyID='+this.currentPolicyID;
            }else if(this.currentOpenTab === 'Schedule_4'){
                //this.currentOpenTab = 'https://'+this.domainBaseURL+'/ECReach/apex/PolicyScheduleFour?policyID='+this.currentPolicyID;
            }
        }
        if(event.target.value === 'Auto_Renewal'){
            this.handlePolicyRenewalMode();
        }
        
        console.log('open currentOpenTab : '+this.currentOpenTab);
        
    }
    downloadPdf(event){
        console.log("Current Policy ID" + this.currentPolicyID+' currentOpenTab :'+this.currentOpenTab);
        console.log("Cover_PDF_Link " + this.Cover_PDF_Link);
        console.log("Schedule_1_Link " + this.Schedule_1_Link);
        console.log("Schedule_2_Link " + this.Schedule_2_Link);
        console.log("Schedule_3_Link " + this.Schedule_3_Link);
        console.log("Schedule_4_Link " + this.Schedule_4_Link);
        var openUrl;
        
        if(this.currentOpenTab === 'Cover' ){
            if(this.isCoverSigned){
                const urlWithParameters = this.Cover_PDF_Link;
                console.log('urlWithParameters...'+urlWithParameters);
                this[NavigationMixin.Navigate]({
                    type: 'standard__webPage',
                        attributes: {
                        url: urlWithParameters
                    }
                }, false); //if you set true this will opens the new url in same window
            }else{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Policy Cover not signed.',
                        message: 'Policy Cover not signed.',
                        mode : 'sticky',
                        variant: 'error'
                    })
                );
            }
        }else if(this.currentOpenTab === 'Schedule_1' ){
            if(this.isSchedule1Signed){
                const urlWithParameters = this.Schedule_1_Link;
                console.log('urlWithParameters...'+urlWithParameters);
                this[NavigationMixin.Navigate]({
                    type: 'standard__webPage',
                        attributes: {
                        url: urlWithParameters
                    }
                }, false); //if you set true this will opens the new url in same window
            }else{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Policy Schedule 1 not signed.',
                        message: 'Policy Schedule 1 not signed.',
                        mode : 'sticky',
                        variant: 'error'
                    })
                );
            }

        }else if(this.currentOpenTab === 'Schedule_2' ){
            if(this.isSchedule2Signed){
                const urlWithParameters = this.Schedule_2_Link;
                console.log('urlWithParameters...'+urlWithParameters);
                this[NavigationMixin.Navigate]({
                    type: 'standard__webPage',
                        attributes: {
                        url: urlWithParameters
                    }
                }, false); //if you set true this will opens the new url in same window
            }else{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Policy Schedule 2 not signed.',
                        message: 'Policy Schedule 3 not signed.',
                        mode : 'sticky',
                        variant: 'error'
                    })
                );
            }
            
        }else if(this.currentOpenTab === 'Schedule_3' ){
            if(this.isSchedule3Signed){
                const urlWithParameters = this.Schedule_3_Link;
                console.log('urlWithParameters...'+urlWithParameters);
                this[NavigationMixin.Navigate]({
                    type: 'standard__webPage',
                        attributes: {
                        url: urlWithParameters
                    }
                }, false); //if you set true this will opens the new url in same window
            }else{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Policy Schedule 3 not signed.',
                        message: 'Policy Schedule 3 not signed.',
                        mode : 'sticky',
                        variant: 'error'
                    })
                );
            }
            
        }else if(this.currentOpenTab === 'Schedule_4' ){
            if(this.isSchedule4Signed){
                const urlWithParameters = this.Schedule_4_Link;
                console.log('urlWithParameters...'+urlWithParameters);
                this[NavigationMixin.Navigate]({
                    type: 'standard__webPage',
                        attributes: {
                        url: urlWithParameters
                    }
                }, false); //if you set true this will opens the new url in same window
            }else{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Policy Schedule 4 not signed.',
                        message: 'Policy Schedule 4 not signed.',
                        mode : 'sticky',
                        variant: 'error'
                    })
                );
            }
        } else{
        
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: this.currentOpenTab
                }
            },
            true // Replaces the current page in your browser history with the URL
            )
        } 
    }



    downloadPdfOLD(event) {
        console.log("Current Policy ID" + this.currentPolicyID+' currentOpenTab :'+this.currentOpenTab);
        /*const urlWithParameters = '/apex/policyDocumentVF?policyId='+this.currentPolicyID;
        console.log('urlWithParameters :'+urlWithParameters);
        window.open(urlWithParameters);
        if (this._isCommunity) {
            // Navigation to PageReference type standard__webPage not supported in communities.
            window.open(urlWithParameters);
        } else {
            console.log('urlWithParameters...' + urlWithParameters);
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: urlWithParameters
                }
            }, false); //if you set true this will opens the new url in same window
        }*/
        //this.currentOpenTab = 'https://'+this.domainBaseURL+'/ECReach/apex/PolicyDocumentCover?policyID='+this.currentPolicyID;
        if(this.currentOpenTab === 'Cover' ){
            this.currentOpenTab = 'https://'+this.domainBaseURL+'/ECReach/apex/PolicyDocumentCover?policyID='+this.currentPolicyID;
        }
        const urlWithParameters =this.currentOpenTab+'&renderAs=PDF';
        
        console.log('urlWithParameters...'+urlWithParameters);
        this[NavigationMixin.Navigate]({
        type: 'standard__webPage',
            attributes: {
            url: urlWithParameters
        }
        }, false); //if you set true this will opens the new url in same window

    }
    handlePolicyRenewalMode(){
        console.log('handlePolicyRenewalMode called.');
        const policyExpiryDate = new Date(this.policyExpireyDate);
        const currentDate = new Date();
        console.log('currentDate : '+currentDate+' policyExpiryDate:'+policyExpiryDate);
        console.log('currentDate Month : '+currentDate.getMonth()+' policyExpiryDate Month:'+policyExpiryDate.getMonth());
        console.log('currentDate getFullYear : '+currentDate.getFullYear()+' policyExpiryDate getFullYear:'+policyExpiryDate.getFullYear());

        /*const diffTime = Math.abs(policyExpiryDate - currentDate);
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
        console.log(diffTime + " milliseconds");
        console.log('Difference in Date Day Wise : '+diffDays);
        if (diffDays>60) {
            this.isEnablePolicyRenewal=false;
        }
        if ((policyExpiryDate.getMonth()-currentDate.getMonth())>2) {
            this.isEnablePolicyRenewal=false;
        }*/
        autoRenwalDateChecking({
            policyExpireyDate : this.policyExpireyDate
        }).then(data => {
            console.log('autoRenwalDateChecking success :'+JSON.stringify(data));
            this.isEnablePolicyRenewal = data;

        }).catch(error => {
            console.log('Error : '+error.toString()+' '+JSON.stringify(error));
        });
    }

    handlePolicyRenewalModeChange(event){
        console.log('handlePolicyRenewalMode called. '+event.target.value);
        this.renewalMode = event.target.value;
        upDateAutoRenewalSetting({
            settings : this.renewalMode,
            policyID : this.currentPolicyID
        }).then(data => {
            console.log(' upDateAutoRenewalSetting success :'+JSON.stringify(data));
            try {
                if(data.isSuccess){
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Auto Renewal Updated Successfully.',
                            message: '',
                            mode : 'sticky',
                            variant: 'success'
                        })
                    );
                }
           } catch (error) {
               console.log('1 error.toString() '+error.toString()+' '+JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while updating Auto Renewal',
                        message: error.toString(),
                        mode : 'sticky',
                        variant: 'warning'
                    })
                );
            }
            
        }).catch(error => {
            console.log('2 error.toString() '+error.toString()+' '+JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: '',
                    message:'Exception Occurred while updating Auto Renewal',
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
    
    getModifiedPolicyHolderData(){
        console.log('getWrapperPolicyHolderData called.');
        getWrapperPolicyHolderData({
            usrId : this.userId
        }).then(data => {
            console.log('getWrapperPolicyHolderData success :'+JSON.stringify(data));
            try {
                
               this.issueDate = data.issueDate;
               this.Proposal_Submission_Date = data.Proposal_Submission_Date;
               this.policyHolderName = data.phName;

               this.Registered_Address_Line_1=data.Registered_Address_Line_1;
               this.Registered_Address_Line_2=data.Registered_Address_Line_2;
               this.Registered_Address_Line_3=data.Registered_Address_Line_3;
               this.Registered_District=data.Registered_District;
               this.Registered_Territory=data.Registered_Territory;
               this.policyPeriod = data.policyPeriod;
               this.issueDateOfFirstCL = data.issueDateOfFirstCL;
               this.policyCommenceDate = data.policyCommenceDate;
               this.Cover_PDF_Link = data.Cover_PDF_Link;
               this.Schedule_1_Link = data.Schedule_1_Link;
               this.Schedule_2_Link = data.Schedule_2_Link;
               this.Schedule_3_Link = data.Schedule_3_Link;
               this.Schedule_4_Link = data.Schedule_4_Link;
               this.isLimitedAccess = data.isLimitedAccess;
               this.limitedAccessDate = data.limitedAccessDate;
               this.isLimitedAccessWithinSixMonth = data.isLimitedAccessWithinSixMonth;
               this.policyStatus = data.policyStatus;
               this.isPolicyValid = (data.policyStatus == 'Valid')? true:false; 
               this.isPolTerminationWithinSixMonth = data.isPolTerminationWithinSixMonth;

                
            } catch (error) {
               console.error(error.toString()+' '+JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while fetching User data',
                        message: error.toString()+' '+JSON.stringify(error),
                        mode : 'sticky',
                        variant: 'warning'
                    })
                );
            }
            
        }).catch(error => {
            console.error(error.toString()+' '+JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while fetching User data.',
                    message: error.toString()+' '+JSON.stringify(error),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }

    @track OMBPclauseCountryList = []
    @wire(getOMBPClauseCountryList, {})
    handlegetOMBPClauseCountryList({ error, data }) {
        if (data) {
            this.OMBPclauseCountryList = data.map(el => {
                return {
                    name: el.CTRY_CTRY_NAME__c,
                    code: el.CTRY_CTRY_CODE__c
                }
            })
            console.log('OMBPclauseCountryList::', JSON.stringify(this.OMBPclauseCountryList));
        } else if (error) {
            console.error('####handlegetOMBPClauseCountryList error=' + JSON.stringify(error))
        }
    }

    getModifiedAllSchedule(){
        console.log('getAllSchedule called.');
        getWrapperAllSchedule({
            usrId : this.userId
        }).then(data => {
            console.log('getWrapperAllSchedule success :'+JSON.stringify(data));
            try {
                //this.allSchedule = data;
                let allSchData=[];
                for(let sch in data){
                    
                    if(data[sch].scheduleType === 'Schedule 1'){
                        console.log('Schedule 1*********************x');
                        this.policyFee = data[sch].Policy_fee;
                        this.policyDeposit = data[sch].Policy_deposit;
                        this.isSchedule1Signed = data[sch].isScheduleSigned;
                        allSchData.push(data[sch]);
                       
                    }else if(data[sch].scheduleType === 'Schedule 2'){
                        console.log('Schedule 2*********************');
                        this.isSchedule2Signed = data[sch].isScheduleSigned;
                        allSchData.push(data[sch]);
                    }else if(data[sch].scheduleType === 'Schedule 3'){
                        console.log('Schedule 3*********************');
                        this.isSchedule3Signed = data[sch].isScheduleSigned;
                        allSchData.push(data[sch]);
                    }else if(data[sch].scheduleType === 'Schedule 4'){
                        console.log('Schedule 4*********************');
                        this.isSchedule4Signed = data[sch].isScheduleSigned;
                        allSchData.push(data[sch]);
                    }else if(data[sch].scheduleType === 'Policy Cover'){
                        console.log('Policy Cover*********************');
                        this.isCoverSigned = data[sch].isScheduleSigned;
                    }
                }
                this.allSchedule = allSchData;
                console.log('this.issueDate :'+this.issueDate+' this.effectiveDate:'+this.effectiveDate);
            } catch (error) {
               console.error(error.toString+'=='+JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while fetching Policy Schedule',
                        message: error.toString(),
                        mode : 'sticky',
                        variant: 'warning'
                    })
                );
            }
            
        }).catch(error => {
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while fetching Schedule',
                    message: error.toString(),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
}