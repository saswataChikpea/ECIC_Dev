import { LightningElement ,  track , wire, api} from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAllPolicy from '@salesforce/apex/PolicyManagement.getAllPolicy';
import getAccountDetails from '@salesforce/apex/PolicyManagement.getAccountDetails';
//import getAllSchedule from '@salesforce/apex/PolicyManagement.getAllSchedule';

export default class PolicyManagmentContainer extends NavigationMixin(LightningElement) {
    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.currentPageReference = currentPageReference;
    }
    @track accountID;
    @track selectedItemValue;
    @track showPolicyIntroductionAndRelatedDocument;
    @track showPolicySchedule;
    @track showPolicyDetail;
    @track showPolicyTermination;
    @track companyName;
    @track currentPolicy;
    @track currentPolicyIssueDate;
    @track currentPolicyHolderAddress;
    @track policyNumber;
    @track allPolicy;
    @track allPolicySchedule;
    @track policyTerminationButtonVariant;
    @track policyTerminationPopUp;
    @track reasonForTermination;
    @track maximumLiabilty;
    @track commencementDate;
    @track percentageOfIndmenity;
    //Child
    @api selectedPolicyScreen;
    connectedCallback(){
        console.log("URL Parameters => ", JSON.stringify(this.currentPageReference.state));
        console.log("URL Parameters => ", this.currentPageReference.state.c__id);
        this.accountID = this.currentPageReference.state.c__id;
        this.policyTerminationButtonVariant = 'Neutral';
        this.policyTerminationPopUp = false;
        //this.showPolicyIntroductionAndRelatedDocument=true;
        this.fetchAllPolicy();
        this.getAccountInfo();
        //this.fetchAllPolicySchedule();
        console.log('selectedPolicyScreen : '+this.selectedPolicyScreen);
        const event1 = new CustomEvent('handlepagechange', {
            // detail contains only primitives
            detail: {
                value: this.selectedPolicyScreen
            }
        });
        this.handleOnselect(event1);
    }
    get options() {
        return [
            { label: 'Case of Bussiness', value: 'Case of Bussiness' },
            { label: 'Claims experiance', value: 'Claims experiance' },
            { label: 'Looking for larger credit limit', value: 'Looking for larger credit limit' },
            { label: 'No export Bussiness', value: 'No export Bussiness' },
            { label: 'Premium Rate', value: 'Premium Rate' },
            { label: 'Switch to other HKECIC Policy', value: 'Switch to other HKECIC Policy' },
            { label: 'Switch to other Insurance Company', value: 'Switch to other Insurance Company' },
            { label: 'Transfer of bussiness to other assosiate company', value: 'Transfer of bussiness to other assosiate company' },
        ];
    }
    getAccountInfo(){
        console.log('getAccountInfo called');
        getAccountDetails({
            accountID : this.accountID
        }).then(data => {
            console.log('getAccountInfo success :'+JSON.stringify(data));
            this.companyName = data.Name;
            this.currentPolicy = data.Current_Policy__r.Product__r.Name;
            this.policyNumber = data.Current_Policy__r.Name;
            this.currentPolicyHolderAddress = data.Current_Policy__r.Policyholder_s_Address__c;
            this.currentPolicyIssueDate = data.Current_Policy__r.Issue_Date__c;
            this.maximumLiabilty = data.Current_Policy__r.Maximum_Liability__c;;
            this.commencementDate = data.Current_Policy__r.Commencement_Date__c;
            this.percentageOfIndmenity = data.Current_Policy__r.Percentage_of_Indemnity__c;
        }).catch(error => {
            console.log('Cannot fetch getAccountInfo : '+error);
        });
    }
    fetchAllPolicy(){
        console.log('fetchAllPolicy called');
        getAllPolicy({
            accountID : this.accountID
        }).then(data => {
            console.log('fetchAllPolicy success :'+JSON.stringify(data));
            this.allPolicy = data;
            
        }).catch(error => {
            console.log('Cannot fetch fetchAllPolicy : '+error);
        });
    }
    /*fetchAllPolicySchedule(){
        console.log('fetchAllPolicySchedule called');
        getAllSchedule({
            accountID : this.accountID
        }).then(data => {
            console.log('fetchAllPolicySchedule success :'+JSON.stringify(data));
            this.allPolicySchedule = data;
            
        }).catch(error => {
            console.log('Cannot fetch fetchAllPolicySchedule : '+error);
        });
    }*/
    handleOnselect(event) {
        try {
            this.selectedItemValue = event.detail.value;
            console.log('this.selectedItemValue : '+this.selectedItemValue);
            if(this.selectedItemValue === 'PolicyIntroductionAndRelatedDocument'){
                this.showPolicyIntroductionAndRelatedDocument=true;
                this.showPolicySchedule=false;
                this.showPolicyDetail=false;
                this.showPolicyTermination=false;
    
            }else if(this.selectedItemValue === 'PolicySchedule'){
                this.showPolicyIntroductionAndRelatedDocument=false;
                this.showPolicySchedule=true;
                this.showPolicyDetail=false;
                this.showPolicyTermination=false;
    
            }else if(this.selectedItemValue === 'PolicyDetail'){
                this.showPolicyIntroductionAndRelatedDocument=false;
                this.showPolicySchedule=false;
                this.showPolicyDetail=true;
                this.showPolicyTermination=false;
            }else if(this.selectedItemValue === 'PolicyTermination'){
                this.showPolicyIntroductionAndRelatedDocument=false;
                this.showPolicySchedule=false;
                this.showPolicyDetail=false;
                this.showPolicyTermination=true;
            }
            console.log('--->>>');
        } catch (error) {
            console.error('Exception : '+error.toString());
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: error.toString(),
                    variant: 'error',
                    mode: 'sticky'
                })
            );
        }
    }
    
    @api customHandleOnselect1(selectedItemValue){
        alert('Child customHandleOnselect called. '+selectedItemValue);
        
    }
    @api customHandleOnselect(selectedItemValue) {
        //alert('Child customHandleOnselect called. '+selectedItemValue);
        console.log('customHandleOnselect called : '+selectedItemValue);
        try {
            this.selectedItemValue = selectedItemValue;
            console.log('this.selectedItemValue : '+this.selectedItemValue);
            if(this.selectedItemValue === 'PolicyIntroductionAndRelatedDocument'){
                this.showPolicyIntroductionAndRelatedDocument=true;
                this.showPolicySchedule=false;
                this.showPolicyDetail=false;
                this.showPolicyTermination=false;
    
            }else if(this.selectedItemValue === 'PolicySchedule'){
                this.showPolicyIntroductionAndRelatedDocument=false;
                this.showPolicySchedule=true;
                this.showPolicyDetail=false;
                this.showPolicyTermination=false;
    
            }else if(this.selectedItemValue === 'PolicyDetail'){
                this.showPolicyIntroductionAndRelatedDocument=false;
                this.showPolicySchedule=false;
                this.showPolicyDetail=true;
                this.showPolicyTermination=false;
            }else if(this.selectedItemValue === 'PolicyTermination'){
                this.showPolicyIntroductionAndRelatedDocument=false;
                this.showPolicySchedule=false;
                this.showPolicyDetail=false;
                this.showPolicyTermination=true;
            }
            console.log('--->>>');
        } catch (error) {
            console.error('Exception : '+error.toString());
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: error.toString(),
                    variant: 'error',
                    mode: 'sticky'
                })
            );
        }
    }
    policyTermination(){
        this.policyTerminationButtonVariant = 'destructive';
        this.policyTerminationPopUp = true;
    }
    policyPopCancel(){
        this.policyTerminationButtonVariant = 'neutral';
        this.policyTerminationPopUp = false;
    }
    policyTerminationConfirm(){

    }
    
}