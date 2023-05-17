import { LightningElement, track, wire, api } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class AllTabContainer extends NavigationMixin(LightningElement) {
    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.currentPageReference = currentPageReference;
    }
    @track accountID;
    @track showPolicyScreen;
    @track selectedPolicyScreen;
    @track isPolicyDocument;
    @track isPolicyDetail;
    @track isLetterOfAuthority;
    @track isInvoice;
    @track isDeclarationSubmission;
    @track isDeclarationRecord;
    isDeclarationSubmissionBulk;

    connectedCallback() {
        console.log("URL Parameters => ", JSON.stringify(this.currentPageReference.state));
        console.log("URL Parameters => ", this.currentPageReference.state.c__id);
        this.isPolicyDocument = false;
        this.isPolicyDetail = false;
        this.isLetterOfAuthority = false;
        this.isInvoice = false;
    }
    handleOnselectPolicyManagement(event) {
        this.showPolicyScreen = true;
        try {
            this.selectedItemValue = event.detail.value;
            console.log('handleOnselectPolicyManagement this.selectedItemValue : ' + this.selectedItemValue);
            if (this.selectedItemValue === 'PolicyDocument') {
                this.isPolicyDocument = true;
                this.isPolicyDetail = false;
                this.isLetterOfAuthority = false;
                this.isInvoice = false;
                this.isDeclarationSubmission = false;
                this.isDeclarationRecord = false;
            } else if (this.selectedItemValue === 'PolicyDetail') {
                this.isPolicyDocument = false;
                this.isPolicyDetail = true;
                this.isLetterOfAuthority = false;
                this.isInvoice = false;
                this.isDeclarationSubmission = false;
                this.isDeclarationRecord = false;
            } else if (this.selectedItemValue === 'LetterOfAuthority') {
                this.isPolicyDocument = false;
                this.isPolicyDetail = false;
                this.isLetterOfAuthority = true;
                this.isInvoice = false;
                this.isDeclarationSubmission = false;
                this.isDeclarationRecord = false;
            } else if (this.selectedItemValue === 'Invoice') {
                this.isPolicyDocument = false;
                this.isPolicyDetail = false;
                this.isLetterOfAuthority = false;
                this.isInvoice = true;
                this.isDeclarationSubmission = false;
                this.isDeclarationRecord = false;
            } else if (this.selectedItemValue === 'DeclarationSubmission') {
                this.isPolicyDocument = false;
                this.isPolicyDetail = false;
                this.isLetterOfAuthority = false;
                this.isInvoice = false;
                this.isDeclarationSubmission = true;
                this.isDeclarationRecord = false;
            } else if (this.selectedItemValue === 'DeclarationRecord') {
                this.isPolicyDocument = false;
                this.isPolicyDetail = false;
                this.isLetterOfAuthority = false;
                this.isInvoice = false;
                this.isDeclarationSubmission = false;
                this.isDeclarationRecord = true;
            } else if (this.selectedItemValue === 'DeclarationSubmissionBulk') {
                this.isPolicyDocument = false;
                this.isPolicyDetail = false;
                this.isLetterOfAuthority = false;
                this.isInvoice = false;
                this.isDeclarationSubmission = false;
                this.isDeclarationRecord = false;
                this.isDeclarationSubmissionBulk = true;
            }

            console.log('--->>>');
            //this.showPolicyScreen = true;
        } catch (error) {
            console.error('Exception : ' + error.toString());
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
    handlePageChange(event) {
        console.log('handlePageChange =====> ')
        const pageId = event.detail.pageId
        this.selected_product = event.detail.selected_product
        console.log('pageId ====> ' + JSON.stringify(pageId))

    }

    /*handleOnselectPolicyManagement(event) {
        this.showPolicyScreen = true;
        try {
            this.selectedItemValue = event.detail.value;
            console.log('handleOnselectPolicyManagement this.selectedItemValue : '+this.selectedItemValue);
            if(this.selectedItemValue === 'PolicyIntroductionAndRelatedDocument'){
                this.selectedPolicyScreen = this.selectedItemValue;
                try {
                    var chilMethod = this.template.querySelector("c-policy-managment-container");
                    chilMethod.customHandleOnselect(this.selectedPolicyScreen); 
                } catch (error) {
                    console.error('Exception : '+error.toString());
                }
                
            }else if(this.selectedItemValue === 'PolicySchedule'){
                this.selectedPolicyScreen = this.selectedItemValue;
                try {
                    var chilMethod = this.template.querySelector("c-policy-managment-container");
                    chilMethod.customHandleOnselect(this.selectedPolicyScreen); 
                } catch (error) {
                    console.error('Exception : '+error.toString());
                }

            }else if(this.selectedItemValue === 'PolicyDetail'){
                this.selectedPolicyScreen = this.selectedItemValue;
                try {
                    var chilMethod = this.template.querySelector("c-policy-managment-container");
                    chilMethod.customHandleOnselect(this.selectedPolicyScreen); 
                } catch (error) {
                    console.error('Exception : '+error.toString());
                }

            }else if(this.selectedItemValue === 'PolicyTermination'){
                this.selectedPolicyScreen = this.selectedItemValue;
                try {
                    var chilMethod = this.template.querySelector("c-policy-managment-container");
                    chilMethod.customHandleOnselect(this.selectedPolicyScreen); 
                } catch (error) {
                    console.error('Exception : '+error.toString());
                }

            }
            console.log('--->>>');
            //this.showPolicyScreen = true;
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
    }*/


}