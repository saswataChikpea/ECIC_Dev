import { api, LightningElement, track } from 'lwc';
import { createRecord, updateRecord } from 'lightning/uiRecordApi';
import ID_FIELD from '@salesforce/schema/Quote__c.Id';
import COMPLETED_TUTORIAL_FIELD from '@salesforce/schema/Quote__c.Completed_Tutorial__c';

export default class QuotationTutorialModal extends LightningElement {
    @api id;
    @api productName;
    @track complete = false;
    handleComplete(e) {
        this.complete = e.target.checked;
    }
    handleSubmit() {
        // console.log('handleSubmit complete=',this.complete);
        if (this.complete) {
            this.closeModal();
            const fields = {};
            try {
                fields[ID_FIELD.fieldApiName] = String(this.id).split('-')[0];
                fields[COMPLETED_TUTORIAL_FIELD.fieldApiName] = true;

                const recordInput = { fields };
                console.log("recordInput:", recordInput);
                updateRecord(recordInput)
                    .then(() => {
                        // console.log('account updated');  

                    })
                    .catch(error => {
                        // console.log('error in account update', error.body.message);
                    });
            } catch (exception) {
                console.log('Exception=', exception);
            }
        } else {
            this.closeModal();
        }
    }
    closeModal() {

        const closeEvent = new CustomEvent("closewelcomemodal", {
            detail: ''
        })
        this.dispatchEvent(closeEvent);
    }
}