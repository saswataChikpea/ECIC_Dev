import { api, LightningElement } from 'lwc';

export default class CustomCurrency extends LightningElement {
    @api name
    @api value
    @api formattedNumber
    @api placeholder
    @api showText = ''
    @api eventname
    @api disabled = false
    @api currency = 'HKD'
    @api id = 'text-input-id-001'
    get currencyClass() {
        return this.disabled ? 'slds-icon slds-input__icon slds-input__icon_left slds-icon-text-default disabled'
            : 'slds-icon slds-input__icon slds-input__icon_left slds-icon-text-default'
    }
    connectedCallback() {
        console.log("currency: connectedCallback:: ", this.value);
        // debugger
        if (this.value == '0') {
            this.showText = '0'
            this.formattedNumber = '0'
        } else if (this.value == '' || this.value == undefined) {
            this.showText = ''
            this.formattedNumber = ''
        } else {
            let val = Number(this.value).toLocaleString('en-US', { maximumFractionDigits: 2 })
            // val = val == '0' ? '0' : val
            this.formattedNumber = (val == 'NaN') ? '' : val
            this.showText = this.formattedNumber == 0 ? 0 : this.formattedNumber || ''
        }

    }

    toFixedIfNecessary(value, dp = 2) {
        return +parseFloat(value).toFixed(dp);
    }
    change(event) {
        this.value = event.target.value !== '' ? this.toFixedIfNecessary(Number(event.target.value)) : ''
        if (Number(event.target.value) > 0) {
            this.formattedNumber = Number(event.target.value).toLocaleString('en-US', { maximumFractionDigits: 2 })
        }
        else if (this.value == 0 || this.value == '0') {
            this.formattedNumber = String(this.value)
        } else {
            this.formattedNumber = ''
        }
        // const val = Number(event.target.value).toLocaleString('en-US', { maximumFractionDigits: 2 })
        // this.formattedNumber = (val == 'NaN' || !val) ? '' : val
        // debugger
    }
    handleFocus(event) {
        console.log('Currency Focus::', event.target.name, this.value);
        // this.showText = this.value || ''
        if (this.value == 0 || this.value == '0' || Number(this.value) > 0) {
            this.showText = this.value
        } else {
            this.showText = ''
        }
    }
    handleFocusOut(event) {
        this.showText = this.formattedNumber == '0' ? 0 : this.formattedNumber || ''
        console.log('Currency Focus out::', event.target.name, this.formattedNumber, this.showText);
        this.sendValue(this.value)

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