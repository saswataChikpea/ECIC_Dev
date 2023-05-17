import { api, LightningElement } from 'lwc';

export default class CustomNumberInput extends LightningElement {
    @api name
    @api value
    @api formattedNumber
    @api placeholder
    @api showText = ''
    @api eventname
    @api disabled = false
    @api currency = 'HKD'

    get currencyClass() {
        return this.disabled ? 'slds-icon slds-input__icon slds-input__icon_left slds-icon-text-default disabled'
            : 'slds-icon slds-input__icon slds-input__icon_left slds-icon-text-default'
    }
    connectedCallback() {
        const val = Number(this.value).toLocaleString('en-US', { maximumFractionDigits: 2 })
        this.formattedNumber = (val == 'NaN' || !val) ? '' : val
        this.showText = this.formattedNumber || ''

    }
    change(event) {
        this.value = Number(event.target.value)
        const val = Number(event.target.value).toLocaleString('en-US', { maximumFractionDigits: 2 })
        this.formattedNumber = (val == 'NaN' || !val) ? '' : val
    }
    handleFocus(event) {
        // console.log('Currency Focus::', event.target.name, JSON.stringify(event.target));
        this.showText = this.value || ''
    }
    handleFocusOut(event) {
        // console.log('Currency Focus out::', event.target.name, JSON.stringify(event.target));
        this.showText = this.formattedNumber || ''
        console.log('Currency Focus out:this.value:', this.value)
        this.sendValue(this.value || '')
        /*var a = Number(this.value)
        console.log('Currency Focus out:a:', a)
        if(isNaN(a)){
            this.sendValue('0')
        }else{
            this.sendValue(a)
        }*/
    }
    sendValue(val) {
        console.log("sendValue", val);
        // let selected_val = e.target.value;
        const event1 = new CustomEvent(this.eventname, {
            // detail contains only primitives

            target: { value: val, name: this.name }
        });
        this.dispatchEvent(event1);
    }
}