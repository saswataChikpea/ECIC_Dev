import { LightningElement, track, api } from 'lwc';
import { createRecord, updateRecord } from 'lightning/uiRecordApi';
import createTask from '@salesforce/apex/TaskManagement.createTask';
import Date_f2f from '@salesforce/label/c.Date';
import Time from '@salesforce/label/c.Time';
import Number_of_participants from '@salesforce/label/c.Number_of_participants';
import Submit from '@salesforce/label/c.Submit';


export default class FaceToFaceAppointment extends LightningElement {

    @track label ={
        Date_f2f , Time , Number_of_participants , Submit
    }

    @api accountid;
    @track appointment_date = "";
    @track appointment_time = "";
    @track appointment_end_time = "";
    @track participant_no = 0;
    @track show_submit = true;
    @track submit_msg = "";
    @track min_date = '';
    @track max_date = '';


    handleAppointmentDate(e) {
        console.log('handleAppointmentDate app date=',e.target.value);
        let dt = new Date(e.target.value);
        let inputField = this.template.querySelector(`[data-id="appointment_date"]`);
        if ((dt.getDay() === 6) || (dt.getDay() === 0)) {
            inputField.setCustomValidity("Please enter a week day");            
        } else {            
            this.appointment_date = e.target.value;
            console.log('else part appointment_date',this.appointment_date);
            inputField.setCustomValidity('');
        }
        inputField.reportValidity();
    }
    handleAppointmentTime(e) {
        this.appointment_time = e.target.value;
        console.log('this.appointment_time=',this.appointment_time);
    }
    handleAppointmentEndTime(e) {
        this.appointment_end_time = e.target.value;
    }
    handleParticipantNumber(e) {
        this.participant_no = e.target.value;
    }
    handleSubmit() {
        this.show_submit = false;
        this.submit_msg = 'Please wait...';
        var fields = [];
        console.log('Appointment date=',this.appointment_date);
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
            createTask({ 'subject': 'Face to face appointment',
                'description': 'Face to face appointment request is created. Please verify.',
                'priority':'High',
                'type':'',
                'assignedTo':'',
                'relatedID':response.id
            }).then((result) => {
                console.log('Task created');

                }).catch((error) => {
                    console.log(error);
            });
            
            let event1 = new CustomEvent('closef2fmodal', {
            });
            this.dispatchEvent(event1);
        }).catch(error => {
            console.log('custom event Error: ' + error.toString());
        });
    }
    closeModal(e) {
        const closeEvent = new CustomEvent("closef2fmodal", {
        })
        this.dispatchEvent(closeEvent);
    }
    renderedCallback() {
        let rightNow = new Date();
        let min_date_temp = rightNow.setDate(rightNow.getDate() + 1);
        let max_date_temp = rightNow.setDate(rightNow.getDate() + 6);
        // console.log('rightNow.toISOString()=',rightNow.toISOString());
        // console.log('min_date_temp==',min_date_temp);
        let max_d = new Date(max_date_temp);
        let min_d = new Date(min_date_temp);
        // console.log(max_d.getFullYear()+'-'+max_d.getMonth()+'-'+max_d.getDate());
        this.max_date = max_d.getFullYear()+'-'+(max_d.getMonth() + 1).toString().padStart(2, "0")+'-'+max_d.getDate().toString().padStart(2, "0");
        this.min_date = min_d.getFullYear()+'-'+(min_d.getMonth() + 1).toString().padStart(2, "0")+'-'+min_d.getDate().toString().padStart(2, "0");

        // Adjust for the user's time zone
        // min_date_temp.setMinutes(
        //     new Date().getMinutes() - new Date().getTimezoneOffset()
        // );
        // max_date_temp.setMinutes(
        //     new Date().getMinutes() - new Date().getTimezoneOffset()
        // );
        // Return the date in "YYYY-MM-DD" format
        // this.min_date = min_date_temp.toISOString().slice(0, 10);
        // this.max_date = max_date_temp.toISOString().slice(0, 10);
        console.log('min_date==',this.min_date);
        console.log('max_date=',this.max_date);
    }
}