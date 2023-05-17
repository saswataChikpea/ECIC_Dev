import { LightningElement, api, track } from 'lwc'

export default class CustomModal extends LightningElement {
    @track openmodel = false
    @track showInputText = false
    @track showModalMessage = false
    @api modalTitle = 'Lightning'
    @api modalMessage
    @api inputLabel = ''
    @api inputPlaceHolder = 'Type here...'
    @api confirmLabel = 'Ok'

    @api type = 'Input'
    inputTxtValue

    connectedCallback() {
        //this.openmodel  = true
        if (this.type === 'Input') {
            this.showInputText = true
        }
        if (this.modalMessage) {
            this.showModalMessage = true
        } else {
            this.showModalMessage = false
        }
    }
    @api showModal() {
        console.log('############showModal')
        this.openmodel = true
    }
    @api hideModal() {
        this.openmodel = false
    }
    @api get inputValue() {
        return this.inputTxtValue
    }
    handleInputChange(event) {
        this.inputTxtValue = event.target.value
    }
    onConfirm(event) {

        const event1 = new CustomEvent('confirmbtnpress', {
            // detail contains only primitives
            detail: { inputTxtValue: this.inputTxtValue }
        });
        this.dispatchEvent(event1)
        // this.hideModal()
    }
    resendOTP(event) {
        //setting otp blank
        try {
            this.template.querySelector(`[data-id="OTP_INPUT"]`).value = ""
        } catch (error) {
            console.error(error);
        }

        const event1 = new CustomEvent('resendbtnpress', {
        });
        this.dispatchEvent(event1)
    }
}