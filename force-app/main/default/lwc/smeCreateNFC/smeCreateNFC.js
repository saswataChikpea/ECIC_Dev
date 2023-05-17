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
import getNFCRecordFromLegacy from '@salesforce/apex/SME_ConsoleHandler.getNFCRecordFromLegacy'

export default class SmeCreateNFC extends NavigationMixin(LightningElement) {
    @api recordId;
    @track isLoading;
    @api 
    invoke(){
        this.isLoading=true;
        //alert('Invoke called!!!');
        console.log('Inside SmeCreateNFC Invoke recordId:' +this.recordId);
        this.fetchNFC();
        this.isLoading = !this.isLoading;
    }

    fetchNFC(){
        console.log('fetchNFC ----- called.');
        getNFCRecordFromLegacy({
            accID : this.recordId
        }).then(data => {
            console.log('fetchNFC success :'+JSON.stringify(data));
            try {
                if(data){
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: data.responseMsg,
                            message: 'NFC Retrieved Successfully',
                            variant: 'success'
                        })
                    );
                    location.reload();
                    
                }else{
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Failed to retrieve nfc please check nfc section for reason',
                            message: '',
                            mode : 'sticky',
                            variant: 'error'
                        })
                    );
                    location.reload();
                }
               
            } catch (error) {
               
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'NFC Retrieve Failed.',
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

}