import { LightningElement,api, track, wire } from 'lwc';
import initMethod from '@salesforce/apex/FetchCmsContent.initMethod';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getCMSontentByContentIdsV1 from '@salesforce/apex/ContentManagementSystem.getCMSontentByContentIdsV1';
import current_user from '@salesforce/user/Id';
import getDomainBaseURL from '@salesforce/apex/PolicyManagement.getDomainBaseURL'

export default class EndorsementContent extends LightningElement {

    @api contentID;
    connectedCallback(){
        console.log('endorsementContent connectedCallback');
        this.getPublishedContent();
    }
    getPublishedContent(){
        console.log('getPublishedContent called.');
        getCMSontentByContentIdsV1({}).then(data => {
            console.log('getCMSontentByContentIdsV1 success :'+JSON.stringify(data));
            try {

                this.counter = this.counter +1;
                console.log('Counter : '+this.counter);
                for(let t in data){
                    console.log('counter--'+this.counter+' t--->'+t+' value:: '+ data[t].contentNodes.body.value);
                    //console.log('title--'+data[t].title+' t--->'+data[t].contentNodes.body.value);
                }
             } catch (error) {
               console.log('Error 1 : '+error.toString()+' '+JSON.stringify(error.toString()));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while Loading Terms & Conditions',
                        message: error.toString()+' '+JSON.stringify(error.toString()),
                        mode : 'sticky',
                        variant: 'warning'
                    })
                );
            }
            
        }).catch(error => {
            console.log('Error 2 : '+error.toString()+' '+JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while Loading Terms & Conditions',
                    message: error.toString(),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
}