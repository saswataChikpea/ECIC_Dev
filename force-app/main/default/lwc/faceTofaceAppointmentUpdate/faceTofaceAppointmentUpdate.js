import { LightningElement, track, api } from 'lwc';
import { createRecord, updateRecord } from 'lightning/uiRecordApi';
import getCustomEventDetails from '@salesforce/apex/EventManagement.getCustomEventDetails';
import CUSTOM_EVENT_ID from '@salesforce/schema/ECIC_Custom_Event__c.Id';
import CUSTOM_APPOINTMENT_DATE from '@salesforce/schema/ECIC_Custom_Event__c.Appointment_Date__c';
import CUSTOM_APPOINTMENT_TIME from '@salesforce/schema/ECIC_Custom_Event__c.Appointment_Time__c';
import CUSTOM_PARTICIPANT_NO from '@salesforce/schema/ECIC_Custom_Event__c.Number_of_participants__c';
// import CUSTOM_IS_UPDATE from '@salesforce/schema/ECIC_Custom_Event__c.Is_Update__c';
import CUSTOM_STATUS from '@salesforce/schema/ECIC_Custom_Event__c.Status__c';
import CUSTOM_SME_TEAM from '@salesforce/schema/ECIC_Custom_Event__c.SME_Team_Member__c';
import EVENT_ID from '@salesforce/schema/ECIC_Custom_Event__c.Event_Id__c';
import Date_f2f from '@salesforce/label/c.Date';
import Time from '@salesforce/label/c.Time';
import Number_of_participants from '@salesforce/label/c.Number_of_participants';


export default class FaceTofaceAppointmentUpdate extends LightningElement {

    @track label ={
        Date_f2f , Time , Number_of_participants
    }

    @api accountid;
    @api selectedevent;
    @track appointment_date = "";
    @track prev_appointment_date = "";
    @track appointment_time = "";
    @track prev_appointment_time = "";
    @track appointment_end_time = "";
    @track participant_no = 0;
    @track prev_participant_no = 0;
    @track show_submit = true;
    @track submit_msg = "";
    @track min_date = '';
    @track max_date = '';
    @track custom_event_detail = [];
    @track first_load = true;
    @track is_approved = false;
    @track custom_event_id = '';


    handleAppointmentDate(e) {
        
        let dt = new Date(e.target.value);
        console.log('day=',dt.getDay());
        console.log('selected date=', e.target.value);
        let inputField = this.template.querySelector(`[data-id="appointment_date"]`);
        console.log('inputField',inputField);
        if ((dt.getDay() === 6) || (dt.getDay() === 0)) {
            inputField.setCustomValidity("Please enter a week day");            
        } else {
            inputField.setCustomValidity('');
            this.appointment_date = e.target.value;
        }
        inputField.reportValidity();
    }
    handleAppointmentTime(e) {
        this.appointment_time = e.target.value;
        console.log('this.appointment_time=', this.appointment_time);
    }
    handleAppointmentEndTime(e) {
        this.appointment_end_time = e.target.value;
        console.log('selected time:', this.appointment_end_time);
    }
    handleParticipantNumber(e) {
        this.participant_no = e.target.value;
    }
    handleDelete() {
        this.show_submit = false;
        this.submit_msg = 'Please wait...';
        const fields = {};
        fields[CUSTOM_EVENT_ID.fieldApiName] = this.custom_event_id;
        fields[CUSTOM_STATUS.fieldApiName] = 'Cancelled';
        const recordInput = { fields };
        updateRecord(recordInput)
            .then(() => {
                // this.show_checkbox_spinner = false;
                console.log('event deleted');
                this.closeModal();
            })
            .catch(error => {
                console.log('error in custom event update', JSON.stringify(error));
            });
    }
    handleAccept() {
        this.show_submit = false;
        this.submit_msg = 'Please wait...';
        var fields = [];
        fields = {
            'Account__c': this.accountid,
            'Appointment_Date__c': this.appointment_date,
            'Appointment_Time__c': this.appointment_time,
            // 'Appointment_End_Time__c': this.appointment_end_time,
            'Number_of_participants__c': this.participant_no,
            'Status__c': 'Accepted',
            'Event_Id__c': this.selectedevent.Id,
            'SME_Team_Member__c': this.selectedevent.WhoId
        }
        var objRecordInput = { 'apiName': 'ECIC_Custom_Event__c', fields };
        createRecord(objRecordInput).then(response => {
            console.log('custom event record created with Id: ' + response.id);
            let event1 = new CustomEvent('closef2fupdatemodal', {
            });
            this.dispatchEvent(event1);
        }).catch(error => {
            console.log('custom event Error: ' + JSON.stringify(error));
            console.error('custom event Error: ' + JSON.stringify(error));
        });
    }
    handleDecline() {
        this.show_submit = false;
        this.submit_msg = 'Please wait...';
        var fields = [];
        fields = {
            'Account__c': this.accountid,
            'Appointment_Date__c': this.appointment_date,
            'Appointment_Time__c': this.appointment_time,
            // 'Appointment_End_Time__c': this.appointment_end_time,
            'Number_of_participants__c': this.participant_no,
            //'Status__c': 'Accepted',
            'Event_Id__c': this.selectedevent.Id,
            //'SME_Team_Member__c': this.selectedevent.WhoId
        }
        var objRecordInput = { 'apiName': 'ECIC_Custom_Event__c', fields };
        createRecord(objRecordInput).then(response => {
            console.log('custom event record created with Id: ' + response.id);
            this.custom_event_id = response.id;
            this.handleDelete();
        }).catch(error => {
            console.log('custom event Error: ' + JSON.stringify(error));
            console.error('custom event Error: ' + JSON.stringify(error));
        });
    }
    handleSubmit() {
        console.log('on update this.appointment_time=', this.appointment_time);
        this.show_submit = false;
        this.submit_msg = 'Please wait...';
        const fields = {};
        fields[CUSTOM_EVENT_ID.fieldApiName] = this.custom_event_detail.Id;
        fields[CUSTOM_APPOINTMENT_DATE.fieldApiName] = this.appointment_date;
        fields[CUSTOM_APPOINTMENT_TIME.fieldApiName] = this.appointment_time;
        fields[CUSTOM_PARTICIPANT_NO.fieldApiName] = this.participant_no;
        // fields[CUSTOM_IS_UPDATE.fieldApiName] = true;
        fields[CUSTOM_STATUS.fieldApiName] = 'Updated';
        fields[CUSTOM_SME_TEAM.fieldApiName] = '';


        const recordInput = { fields };
        updateRecord(recordInput)
            .then(() => {
                // this.show_checkbox_spinner = false;
                console.log('Custom event updated');
                this.closeModal();
            })
            .catch(error => {
                this.show_checkbox_spinner = false;
                console.log('error in custom event update', JSON.stringify(error));
            });


        /*var fields = [];
        fields = {
            'Account__c': this.accountid,
            'Appointment_Date__c': this.appointment_date,
            'Appointment_Time__c': this.appointment_time,
            // 'Appointment_End_Time__c': this.appointment_end_time,
            'Number_of_participants__c': this.participant_no,
            'Status__c': 'New'
        }
        var objRecordInput = { 'apiName': 'ECIC_Custom_Event__c', fields };
        createRecord(objRecordInput).then(response => {
            console.log('custom event record created with Id: ' + response.id);
            let event1 = new CustomEvent('closef2fmodal', {
            });
            this.dispatchEvent(event1);
        }).catch(error => {
            console.log('custom event Error: ' + error.toString());
        });*/
    }
    closeModal(e) {
        const closeEvent = new CustomEvent("closef2fupdatemodal", {
        })
        this.dispatchEvent(closeEvent);
    }
    callGetCustomEvent() {
        getCustomEventDetails({ eventId: this.selectedevent.Id })
            .then((result) => {
                let self = this;
                console.log("returned Custom events", JSON.stringify(result));
                this.custom_event_detail = result;
                this.custom_event_id = result.Id;
                this.prev_participant_no = result.Number_of_participants__c;
                this.participant_no = result.Number_of_participants__c;
            })
            .catch((error) => {
                console.log('error getCustomEventDetails=', JSON.stringify(error));
            });
    }
    renderedCallback() {
        // appointment_date = "";
        // appointment_time = "";
        if (this.first_load) {
            this.first_load = false;
            this.callGetCustomEvent();
            this.is_approved = this.selectedevent.is_user_approved;
            console.log('StartDateTime=' + this.selectedevent.StartDateTime);
            let start_date_time = new Date(this.selectedevent.StartDateTime);
            this.appointment_date = (start_date_time.getFullYear() + '-' + (start_date_time.getMonth() + 1).toString().padStart(2, "0") + '-' + start_date_time.getDate().toString().padStart(2, "0")).trim();
            this.prev_appointment_date = (start_date_time.getFullYear() + '-' + (start_date_time.getMonth() + 1).toString().padStart(2, "0") + '-' + start_date_time.getDate().toString().padStart(2, "0")).trim();
            console.log('time=' + (start_date_time.getHours() < 10 ? "0" : "") + ((start_date_time.getHours() > 12) ? (start_date_time.getHours() - 12) : start_date_time.getHours()) + ":" + (start_date_time.getMinutes() < 10 ? "0" : "") + start_date_time.getMinutes() + ": " + ((start_date_time.getHours() > 12) ? ('PM') : 'AM'));
            console.log('appointment date=', this.appointment_date);
            // console.log(this.prev_appointment_date.toISOString());
            console.log(new Date(this.selectedevent.StartDateTime).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }));
            this.appointment_time = new Date(this.selectedevent.StartDateTime).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', hour12: false }) + ':00.000'
            console.log('appointment_time==', this.appointment_time);
            this.prev_appointment_time = (((start_date_time.getHours() > 12) ? (start_date_time.getHours() - 12) : start_date_time.getHours()) + ":" + (start_date_time.getMinutes() < 10 ? "0" : "") + start_date_time.getMinutes() + " " + ((start_date_time.getHours() > 12) ? ('PM') : 'AM')).trim();
            // this.prev_appointment_time = ((start_date_time.getHours() < 10 ? "0" : "") + ((start_date_time.getHours() > 12) ? (start_date_time.getHours() - 12) : start_date_time.getHours()) + ":" + (start_date_time.getMinutes() < 10 ? "0" : "") + start_date_time.getMinutes() + " " + ((start_date_time.getHours() > 12) ? ('PM') : 'AM')).trim();
            let rightNow = new Date();
            let min_date_temp = rightNow.setDate(rightNow.getDate() + 1);
            let max_date_temp = rightNow.setDate(rightNow.getDate() + 6);
            // console.log('rightNow.toISOString()=',rightNow.toISOString());
            // console.log('min_date_temp==',min_date_temp);
            let max_d = new Date(max_date_temp);
            let min_d = new Date(min_date_temp);
            // console.log(max_d.getFullYear()+'-'+max_d.getMonth()+'-'+max_d.getDate());
            this.max_date = max_d.getFullYear() + '-' + (max_d.getMonth() + 1).toString().padStart(2, "0") + '-' + max_d.getDate().toString().padStart(2, "0");
            this.min_date = min_d.getFullYear() + '-' + (min_d.getMonth() + 1).toString().padStart(2, "0") + '-' + min_d.getDate().toString().padStart(2, "0");
        }
    }
}