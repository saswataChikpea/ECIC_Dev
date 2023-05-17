import { LightningElement,track,api } from 'lwc';

export default class ClContractualSeller extends LightningElement {
    @api subsidiaries;
    @track show_subsidiaries = false;
    @track selected_subsidiaries = [];
    @track contractual_seller = '';
    @track contractual_seller_options = [
        { label: 'Policyholder', value: 'Policyholder' },
        { label: 'Subsidiary in Mainland China / overseas', value: 'Subsidiary' },
        { label: 'Policyholder or subsidiary in Mainland China / overseas', value: 'Policyholder or subsidiary' }
    ];
    handleContractualSeller(e) {
        console.log(e.target.value);
        this.contractual_seller = e.target.value;
        this.show_subsidiaries = this.contractual_seller == 'Policyholder' ? false : true;
    }
    handleSelectSubisiary(e) {
        let id=e.currentTarget.dataset.id;
        if(e.target.checked)
            this.selected_subsidiaries.push(id);
        else 
            this.selected_subsidiaries = this.selected_subsidiaries.filter(item=>item!=id);
        console.log('selected_subsidiaries=',JSON.stringify(this.selected_subsidiaries));
        var detail = {
            subsidiaries : this.selected_subsidiaries,
            contractual_seller : this.contractual_seller
        }
        const selectEvent = new CustomEvent("selectedsub",{
            detail:detail
        })
        this.dispatchEvent(selectEvent);
    }
}