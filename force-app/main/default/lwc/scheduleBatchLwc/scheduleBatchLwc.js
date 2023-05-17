import { LightningElement ,api,wire,track} from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import shceduleBatchConditionally from '@salesforce/apex/ScheduleBatch.shceduleBatchConditionally'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class ScheduleBatchLwc extends NavigationMixin(LightningElement){
    @api recordId;
    @track isLoading;
    @track ecicSettings;
    @api 
    invoke(){
        this.isLoading=true;
        console.log('ScheduleBatchLwc Inside Invoke recordId:' +this.recordId);
        this.handleScheduleBatch();
        this.isLoading = !this.isLoading;
    }
    handleScheduleBatch(){
        console.log('handleScheduleBatch ----- called.');
        shceduleBatchConditionally({
            isBatch : 'isBatch'
        }).then(data => {
            console.log('shceduleBatchConditionally success :'+JSON.stringify(data));
            try {
                if(data.isSuccess){
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: data.responseMsg,
                            message: 'Batch Scheduled Succesfully.',
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
                console.err('Batch1 Scheduled Failed '+error.toString()+' '+JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Batch Scheduled Failed '+error.toString()+' '+JSON.stringify(error),
                        message: error.toString(),
                        mode : 'sticky',
                        variant: 'error'
                    })
                );
            }
            
        }).catch(error => {
            console.err('Batch2 Scheduled Failed '+error.toString()+' '+JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Batch Scheduled Failed '+error.toString()+' '+JSON.stringify(error),
                    message: error.toString(),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
}