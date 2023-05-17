import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import ID_FIELD from '@salesforce/schema/Contact.Id';
import FIRST_NAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LAST_NAME_FIELD from '@salesforce/schema/Contact.LastName';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import POSITION_FIELD from '@salesforce/schema/Contact.Position__c';
const FIELDS = ['Contact.FirstName', 'Contact.LastName', 'Contact.Phone', 'Contact.Email', 'Contact.Position__c'];
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class ContactInfoEdit extends LightningElement {
    @api contactid;
    contactid;
    @track first_name = "";
    @track last_name = "";
    @track phone = "";
    @track email = "";
    @track position = "";
    @track refresh_contact = false;
    @track error_msg = ''
    @wire(getRecord, { recordId: '$contactid', fields: FIELDS })
    wiredRecord({ error, data }) {
        if (error) {
            console.log(JSON.stringify(error));
            console.error('Error=', JSON.stringify(error));
        } else if (data) {
            this.contact = data;
            if (this.contact.fields.FirstName.value) {
                this.first_name = this.contact.fields.FirstName.value;
            }
            if (this.contact.fields.Phone.value) {
                this.phone = this.contact.fields.Phone.value;
            }
            if (this.contact.fields.LastName.value) {
                this.last_name = this.contact.fields.LastName.value;
            }
            if (this.contact.fields.Email.value) {
                this.email = this.contact.fields.Email.value;
            }
            if (this.contact.fields.Position__c.value) {
                this.position = this.contact.fields.Position__c.value;
            }
            console.log('contact data=' + JSON.stringify(this.contact.fields));
        }
    }
    handleFirstName(e) {
        this.first_name = e.target.value;
    }
    handleLastName(e) {
        this.last_name = e.target.value;
    }
    handleEmail(e) {
        this.email = e.target.value;
    }
    handlePhone(e) {
        this.phone = e.target.value;
    }
    handlePosition(e) {
        this.position = e.target.value;
    }
    checkValidation() {
        let is_valid = true;
        // let validRegex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;
        let validRegex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        if ((this.first_name.length < 3) || (/[^a-zA-Z\-\/ /]/.test(this.first_name))) {
            this.error_msg = 'Invalid First Name';
            is_valid = false;
        }
        if ((this.last_name.length < 3) || (/[^a-zA-Z\-\/ /]/.test(this.last_name))) {
            this.error_msg = 'Invalid Last Name';
            is_valid = false;
        }
        if (!validRegex.test(this.email)) {
            this.error_msg = 'Invalid Email Address';
            is_valid = false;
        }
        if ((this.phone === '') || (this.phone === null) || (this.phone.length < 6)) {
            this.error_msg = 'Invalid Contact Number.';
            is_valid = false;
        }
        if ((this.position.length < 3) || (/[^a-zA-Z\-\/ /./]/.test(this.position))) {
            this.error_msg = 'Invalid Title';
            is_valid = false;
        }
        return is_valid;
    }
    handleUpdate(e) {
        console.log("handleUpdate")
        let is_valid = this.checkValidation();

        if (is_valid) {
            try {
                const fields = {};
                fields[ID_FIELD.fieldApiName] = this.contactid;
                fields[FIRST_NAME_FIELD.fieldApiName] = this.first_name;
                fields[LAST_NAME_FIELD.fieldApiName] = this.last_name;
                fields[PHONE_FIELD.fieldApiName] = this.phone;
                fields[EMAIL_FIELD.fieldApiName] = this.email;
                fields[POSITION_FIELD.fieldApiName] = this.position;
                const recordInput = { fields };
                updateRecord(recordInput)
                    .then(() => {
                        console.log('Contact updated');
                        this.refresh_contact = true;
                        this.closeModal()
                        // this.show_confirmation = true;                        
                    })
                    .catch(error => {
                        console.log('error in contact update', error.body.message);
                    });
            } catch (error) {
                console.error(error.toString(), JSON.stringify(error));
                console.log('error==' + JSON.stringify(error));
            }
        } else {
            this.showToast(this.error_msg);
        }
    }
    showToast(msg) {
        const event = new ShowToastEvent({
            title: 'Error',
            message: msg,
            variant: 'error'
        });
        this.dispatchEvent(event);
    }
    closeModal(e) {
        let detail = {
            refresh: this.refresh_contact
        }
        const closeEvent = new CustomEvent("closeeditmodal", {
            detail: detail
        })
        this.dispatchEvent(closeEvent);
    }
}