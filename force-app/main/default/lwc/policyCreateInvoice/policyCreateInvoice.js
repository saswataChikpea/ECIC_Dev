import { LightningElement ,api,wire,track} from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import current_user from '@salesforce/user/Id';
import USERNAME_FIELD from '@salesforce/schema/User.Username';
import { getRecord } from 'lightning/uiRecordApi';
import POLICY_ID from '@salesforce/schema/Policy__c.Id';
import ACCOUNT_ID from '@salesforce/schema/Policy__c.Exporter__c';
import IS_INVOICED from '@salesforce/schema/Policy__c.Invoiced__c';
import getPolicyDetails from '@salesforce/apex/CreateSUPInvoice.getPolicyDetails'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createInvoiceForSUP from '@salesforce/apex/CreateSUPInvoice.createInvoiceForSUP'

export default class PolicyCreateInvoice  extends NavigationMixin(LightningElement){
    @api recordId;
    @track isLoading;
    @api 
    invoke(){
        this.isLoading=true;
        //alert('Invoke called!!!');
        console.log('Inside Invoke recordId:' +this.recordId);
        this.insertInvoiceJS();
        this.isLoading = !this.isLoading;
    }


    insertInvoiceJS(){
        console.log('insertInvoiceJS ----- called.');
        createInvoiceForSUP({
            policyID : this.recordId
        }).then(data => {
            console.log('createInvoiceForSUP success :'+JSON.stringify(data));
            try {
                if(data.isSuccess){
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: data.responseMsg,
                            message: 'Invoice already exist',
                            variant: 'success'
                        })
                    );
                    location.reload();
                    
                }else{
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: data.responseMsg,
                            message: '',
                            mode : 'sticky',
                            variant: 'error'
                        })
                    );
                }
               
            } catch (error) {
               
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Invoice Creation Failed.',
                        message: error.toString(),
                        mode : 'sticky',
                        variant: 'error'
                    })
                );
            }
            
        }).catch(error => {
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while loading policy settings',
                    message: error.toString()+' '+JSON.stringify(error),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
   
    
   
    /*selectedFields = [POLICY_ID, ACCOUNT_ID, IS_INVOICED];
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
        } else if (data) {
            console.log('data.fields : '+JSON.stringify(data.fields));
            this.logged_in_user = data.fields.Username.value;
        }
    }
    connectedCallback(){
        //console.log('selectedFields : '+POLICY_ID+' recordId:'+this.recordId);
        console.log("URL Parameters => ", JSON.stringify(this.currentPageReference.state));
        console.log("URL Parameters => ", this.currentPageReference.state.c__id);
    }*/

    
}