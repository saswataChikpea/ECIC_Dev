import { LightningElement,api,wire,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import acknowledgePolicyTermination from '@salesforce/apex/PolicyManagement.acknowledgePolicyTermination';

export default class PolicyTerminationAcknowledgementBySMETeamHead extends LightningElement {
    @api recordId;
    @track isLoading;
    @api 
    invoke(){
        console.log('PolicyTerminationAcknowledgementBySMETeamHead invoke called');
        this.isLoading=true;
        console.log('Inside Invoke recordId:' +this.recordId);
        this.acknowledgeMentBySMETeam();
        this.isLoading = !this.isLoading;
    }
    acknowledgeMentBySMETeam(){
        this.isLoading = !this.isLoading;
        console.log('acknowledgeMentBySMETeam : '+this.recordId);
        acknowledgePolicyTermination({
            policyID : this.recordId
        }).then(data => {
            console.log('acknowledgePolicyTermination success :'+JSON.stringify(data));
            try {
                if(data.isSuccess){
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: data.responseMsg,
                            message: data.responseMsg,
                            variant: 'success'
                        })
                    );
                    location.reload();
                    
                }else{
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: data.responseMsg,
                            message: 'Policy Termination Acknowledgement Failed',
                            mode : 'sticky',
                            variant: 'warning'
                        })
                    );
                }
            } catch (error) {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Policy Termination Acknowledgement Failed',
                        message: error.toString(),
                        mode : 'sticky',
                        variant: 'error'
                    })
                );
            }
            
        }).catch(error => {
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Policy Termination Acknowledgement Failed.',
                    message: error.toString(),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
        this.isLoading = !this.isLoading;
    }
}