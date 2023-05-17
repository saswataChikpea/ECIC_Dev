import { api, LightningElement, track } from 'lwc';
import { createRecord, updateRecord } from 'lightning/uiRecordApi';
import ID_FIELD from '@salesforce/schema/Account.Id';
import COMPLETED_TUTORIAL_FIELD from '@salesforce/schema/Account.Completed_Tutorial__c';


export default class WelcomeModal extends LightningElement {
    @api accountid;
    @track complete = false;
    handleComplete(e) {
        this.complete = e.target.checked;
    }
    handleSubmit() {
        // console.log('handleSubmit complete=',this.complete);
        if(this.complete){
            this.closeModal();
            const fields = {};
            try {
                fields[ID_FIELD.fieldApiName] = this.accountid;
                fields[COMPLETED_TUTORIAL_FIELD.fieldApiName] = true;

                const recordInput = { fields };
                    updateRecord(recordInput)
                        .then(() => {
                            // console.log('account updated');  
                                                          
                        })
                        .catch(error => {
                            // console.log('error in account update', error.body.message);
                        });
            }catch(exception){
                console.log('Exception=',JSON.stringify(exception));
            }
        } else {
            this.closeModal();
        }
    }
    closeModal(){
       
        const closeEvent = new CustomEvent("closewelcomemodal",{
            detail:''
        })
        this.dispatchEvent(closeEvent);
    }
}