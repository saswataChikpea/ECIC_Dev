import { LightningElement ,  track , wire, api} from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import LA_FINANCER_OBJECT from '@salesforce/schema/LA_Financier__c';
import LA_FINANCER_TYPE from '@salesforce/schema/LA_Financier__c.Type__c';
import createLAFinancer from '@salesforce/apex/LetterOfAuthority.createLAFinancer';
import getPolicyHolderData from '@salesforce/apex/PolicyManagement.getPolicyHolderData';
import fetchAllLA from '@salesforce/apex/LetterOfAuthority.fetchAllLA';
import getAllSchedule from '@salesforce/apex/PolicyManagement.getAllSchedule'
import current_user from '@salesforce/user/Id';
import USERNAME_FIELD from '@salesforce/schema/User.Username';
import { getRecord } from 'lightning/uiRecordApi';
const laFormColumns = [
    { label: 'Issue Date', fieldName: 'Issue_Date__c' },
    { label: 'LA No.', fieldName: 'Name'},
    { label: 'Status', fieldName: 'Status__c' }
];
export default class PolicyLetterOfAuthority extends NavigationMixin(LightningElement)  {


    @wire(getObjectInfo, { objectApiName: LA_FINANCER_OBJECT })
    objectInfo;

    @track laFinancerType;
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: LA_FINANCER_TYPE})
    laFinancerTypePicklistValues({ data, error }) {
        if (data) this.laFinancerType = data.values;
    }
    @track userId = current_user;
    @track error;
    @track logged_in_user;
    @wire(getRecord, {
        recordId: current_user,
        fields: [USERNAME_FIELD]
    }) wireuser({
        error,
        data
    }) {
        if (error) {
        this.error = error ; 
        //this.name='alice.zzzz@ignatica.io';
        } else if (data) {
            console.log('data.fields : '+JSON.stringify(data.fields));
            this.logged_in_user = data.fields.Username.value;
        }
    }

    @track companyName;
    @track currentPolicy;
    @track policyNumber;
    @track issueDate;
    @track renewalDate;
    @track laFormColumns = laFormColumns;
    @track allLV;
    @track createLaForm;
    @track showBackButton;
    @track showCreateLAButton;
    @track policyHolderName;
    @track effectiveDate;
    @track bankName;
    @track banksAddress;
    @track isWholePolicy;
    @track isSpecificPolicy;
    @track isSelectBuyerPopUp;
    @track commencementDate;
    @track typeOfLA=[
        {label:'Whole Policy',value:'Whole Policy'},
        {label:'Specific Buyer',value:'Specific Buyer'},
    ];
    get options() {
        return [
            { label: 'Whole Policy', value: 'Whole Policy' },
            { label: 'Specific Buyer', value: 'Specific Buyer' }
        ];
    }
    connectedCallback(){
        //this.userId = '0051100000BarVxAAJ';
        console.log('userId :: '+this.userId);

        
        // this.allLV = [
        //     { id: 'LV001',issueDate:'2021-05-21', lvNo: 'LV2020518', status:'EN49A',cancel:'Cancel LA',download:'Download LA' },
        //     { id: 'LV002',issueDate:'2021-05-21', lvNo: 'LV2021423', status:'EN49A',cancel:'Cancel LA',download:'Download LA' },
        // ];
        this.createLaForm = false;
        this.showBackButton = false;
        this.showCreateLAButton = true;
        this.getPolicyHolderData();
        this.fetchAllLA();
        this.getAllSchedule();

    }
    getPolicyHolderData(){
        console.log('getPolicyHolderData called.');
        getPolicyHolderData({
            usrId : this.userId
        }).then(data => {
            console.log('getPolicyHolderData success :'+JSON.stringify(data));
            try {
                this.accInfo = data;
                this.companyName = data.Name;
                this.currentPolicyID = data.Current_Policy__c;
                this.policyNumber = data.Current_Policy__r.Name;
                this.currentPolicy = data.Current_Policy__r.Product__r.Name;

                //this.isPolicyHolderAllowedToTerminatePolicy = data.Current_Policy__r.Allow_Policy_Holder_To_Terminate__c;
            } catch (error) {
               
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while fetching User Data',
                        message: error.toString(),
                        mode : 'sticky',
                        variant: 'warning'
                    })
                );
            }
            
        }).catch(error => {
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while fetching User Data',
                    message: error.toString(),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
    getAllSchedule(){
        console.log('getAllSchedule called.');
        getAllSchedule({
            usrId : this.userId
        }).then(data => {
            console.log('getAllSchedule success :'+JSON.stringify(data));
            try {
                this.allSchedule = data;
                for(let sch in data){
                    if(data[sch].Type__c === 'Schedule 1'){
                        console.log('Schedule 1*********************x');
                        //this.currentPolicyHolderAddress = data[sch].Policyholder_s_Address__c;
                        //this.maximumLiabilty = data[sch].Maximum_Liability__c;
                        this.commencementDate =data[sch].Commencement_Date__c;
                        //this.percentageOfIndmenity = data[sch].Percentage_of_Indemnity__c;
                        this.issueDate = data[sch].Issue_Date__c;
                        this.renewalDate = data[sch].Renewal_Date__c;
                        this.effectiveDate = data[sch].Effective_Date__c;
                        
                        
                        /*var policyNumber  = data[sch].Policy__r.Name;
                        console.log('effectiveDate : '+effectiveDate+' policyNumber:'+policyNumber+' issueDate:'+this.issueDate)
                        this.mapDataPassToSchedule.push({key:'policyNumber',value:policyNumber}); 
                        this.mapDataPassToSchedule.push({key:'issueDate',value:this.issueDate}); 
                        this.mapDataPassToSchedule.push({key:'effectiveDate',value:this.effectiveDate}); 
                        console.log('mapDataPassToSchedule  both '+JSON.stringify(this.mapDataPassToSchedule));*/
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
    fetchAllLA(){
        console.log('fetchAllLA called.');
        fetchAllLA({
            usrId : this.userId
        }).then(data => {
            console.log('fetchAllLA success :'+JSON.stringify(data));
            try {
                this.allLV = data;
            } catch (error) {
               
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while fetching LA Data',
                        message: error.toString(),
                        mode : 'sticky',
                        variant: 'warning'
                    })
                );
            }
            
        }).catch(error => {
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while fetching LA Data',
                    message: error.toString(),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
    handleCreateLAForm(event){
        console.log('createLAForm called. '+event);
        this.createLaForm = true;
        this.showBackButton = true;
        this.showCreateLAButton = false;
    }
    handleBack(event){
        console.log('handleBack called. '+event);
        this.createLaForm = false;
        this.showBackButton = false;
        this.showCreateLAButton = true;
    }
    handleWholePolicy(event){
        console.log('handleWholePolicy called. '+event);
        const startSelect = this.template.querySelector('.select-type');
        if (startSelect) {
            startSelect.value = 'Whole Policy';
            this.typeOfLA = 'Whole Policy';
            this.isWholePolicy = true;
            this.isSpecificPolicy = false;
        }
    }
    handleSpecificBuyer(event){
        console.log('handleSpecificBuyer called. '+event);
        const startSelect = this.template.querySelector('.select-type');
        if (startSelect) {
            startSelect.value = 'Specific Policy';
            this.typeOfLA = 'Specific Policy';
            this.isSpecificPolicy = true;
            this.isWholePolicy = false;
        }
    }
    handleSelectTheBuyers(event){
        console.log('handleSelectTheBuyers called. '+event);
        this.isSelectBuyerPopUp = true;
    }
    buyerPopCancel(){
        console.log('buyerPopCancel called. '+event);
        this.isSelectBuyerPopUp = false;
    }
    
    handlePHName(event){
        console.log('handleChangeLAType called. '+event.target.value);
        this.policyHolderName = event.target.value;
        console.log('policyHolderName  : '+this.policyHolderName)
    }
    handleChangeLAType(event){
        console.log('handleChangeLAType called. '+event.target.value);
        this.typeOfLA = event.target.value;
    }
    handleEffectiveDate(event){
        console.log('handleEffectiveDate called. '+event.target.value);
        this.effectiveDate = event.target.value;
    }
    handleBankName(event){
        console.log('handleBankName called. '+event.target.value);
        this.bankName = event.target.value;
    }
    handleBankAddress(event){
        console.log('handleBankAddress called. '+event.target.value);
        this.bankAddress = event.target.value;
    }
    selectTheBuyers(event){
        console.log('selectTheBuyers called. '+event);

    }

    createLAFinancer(event){
        this.isLoading = true;
        console.log('createLAFinancer called!!!');
        console.log('policyHolderName : '+this.policyHolderName+'\ntypeOfLA :'+this.typeOfLA+' \neefectiveDate : '+this.effectiveDate+' \nBankName : '+this.bankName+' \n Address:'+this.bankAddress);
        createLAFinancer({
            policyID : this.currentPolicyID,
            policyHolderName  : this.policyHolderName,
            typeOfLA : this.typeOfLA,
            effectiveDate : this.effectiveDate,
            bankName : this.bankName,
            bankAddress : this.bankAddress
        }).then(response => {
            console.log('createLAFinancer success :'+JSON.stringify(response));
            if(response){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'LA Created Successfully',
                        message: 'Letter of Authority Financer created.',
                        mode : 'sticky',
                        variant: 'success'
                    })
                );
                this.fetchAllLA();
                this.handleBack();
            }
            this.isLoading = false;
            
        }).catch(error => {
            console.log('createLAFinancer error :'+JSON.stringify(error));
            this.isLoading = false;
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Occurred',
                    message: error.toString(),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
}