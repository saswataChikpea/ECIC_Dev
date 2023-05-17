import { LightningElement ,api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class PolicyInvoker extends LightningElement {
    connectedCallback(){
        console.log('Hiiiiii');
        this.dispatchEvent(
            new ShowToastEvent( {
                title: 'Success',
                message: 'LWC Called.',
                variant: 'success'
            } )
        );
    }
    @api invoke() {
        this.dispatchEvent(
            new ShowToastEvent( {
                title: 'Success',
                message: 'Hi I am Action Call Lwc.',
                variant: 'success'
            } )
        );
      }
}