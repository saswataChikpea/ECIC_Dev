import { LightningElement, track, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import current_user from '@salesforce/user/Id';
import NAME_FIELD from '@salesforce/schema/User.Name';
import USERNAME_FIELD from '@salesforce/schema/User.Username';
import getWrapperPolicyHolderData from '@salesforce/apex/PolicyManagement.getWrapperPolicyHolderData';
import getWrapperAllSchedule from '@salesforce/apex/PolicyManagement.getWrapperAllSchedule';

import { getRecord } from 'lightning/uiRecordApi';

import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
export default class PolicyCover extends NavigationMixin(LightningElement) {
    @track userId = current_user;
    @track pageTitle;
    @api isOmbp;
    @api isSbp;
    @api isSup;
    @api productName;
    @api policyHolderName;
    @api policyHolderRegAdd;
    @api issueDate;
    @api phoneNumber;
    @track productShortForm;
    @track productShortFormWithBoundry;

    @track Registered_Address_Line_1;
    @track Registered_Address_Line_2;
    @track Registered_Address_Line_3;
    @track Registered_District;
    @track Registered_Territory;
    @track Proposal_Submission_Date;
    @track Number_of_credit_limit_applications;
    @track effectiveDate;

    connectedCallback() {

        console.log('PolicyCover lwc');
        console.log('userId : ' + this.userId);
        this.phoneNumber = 'PH000001';
        console.log('PolicyCover userId :: ' + this.userId);
        console.log('isOmbp : ' + this.isOmbp + ' isSbp : ' + this.isSbp + ' isSup : ' + this.isSup);
        if (this.isOmbp) {
            this.productName = 'Online Micro-Business Policy ("OMBP")';
            this.productShortForm = 'OMBP';
            this.productShortFormWithBoundry = '(OMBP)';
        } else if (this.isSbp) {
            this.productName = 'Small Business Policy ("SBP")';
            this.productShortForm = 'SBP';
            this.productShortFormWithBoundry = '(SBP)';
        } else if (this.isSup) {
            this.productName = 'Self Underwritten Policy ("SUP")';
            this.productShortForm = 'SUP';
            this.productShortFormWithBoundry = '(SUP)';
        }
        this.getPolicyHolderData();
        this.getAllSchedule();
    }
    @track error;
    @track name;
    @wire(getRecord, {
        recordId: current_user,
        fields: [NAME_FIELD, USERNAME_FIELD]
    }) wireuser({
        error,
        data
    }) {
        if (error) {
            this.error = error;
            //this.name = 'alice.zzzz@ignatica.io';
        } else if (data) {
            console.log('data.fields : ' + JSON.stringify(data.fields));
            this.name = data.fields.Username.value.split('@')[0];
        }
    }

    getPolicyHolderData(){
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
               this.Number_of_credit_limit_applications = data.Number_of_credit_limit_applications;

                
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

    getAllSchedule(){
        console.log('getAllSchedule called.');
        getWrapperAllSchedule({
            usrId : this.userId
        }).then(data => {
            console.log('getWrapperAllSchedule success :'+JSON.stringify(data));
            try {
                for(let sch in data){
                    this.policyNumber=data[sch].policyNumber;
                    
                    if(data[sch].scheduleType === 'Schedule 1'){
                        console.log('Schedule 1*********************x');
                        
                       
                    }else if(data[sch].scheduleType === 'Schedule 2'){
                        console.log('Schedule 2*********************');
                        
                    }else if(data[sch].scheduleType === 'Schedule 3'){
                        console.log('Schedule 3*********************');
                        
                    }else if(data[sch].scheduleType === 'Schedule 4'){
                        console.log('Schedule 4*********************');
                        
                    }else if(data[sch].scheduleType === 'Policy Cover'){
                        console.log('Policy Cover*********************');
                        this.issueDate = data[sch].coverIssueDate;
                        //this.effectiveDate = data[sch].scheduleEffectiveDate;
                        
                    }
                }
                //console.log('this.issueDate :'+this.issueDate+' this.effectiveDate:'+this.effectiveDate);
            } catch (error) {
               console.error(error.toString+'=='+JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while fetching Policy Schedule',
                        message: error.toString()+' '+JSON.stringify(error),
                        mode : 'sticky',
                        variant: 'warning'
                    })
                );
            }
            
        }).catch(error => {
            console.error(error.toString+'=main='+JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while fetching Schedule',
                    message: error.toString()+' '+JSON.stringify(error),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }

    
}