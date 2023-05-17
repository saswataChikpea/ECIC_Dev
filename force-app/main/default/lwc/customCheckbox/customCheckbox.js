import { LightningElement, api } from 'lwc';

export default class CustomCheckbox extends LightningElement {
    @api options = [
    ];
    handleSelected(e) {
        // console.log("handleSelected", e.target.value);
        let selected_val = e.target.value;
        const event1 = new CustomEvent('handlecheckboxchange', {
            // detail contains only primitives

            detail: { selectedValue: selected_val }
        });
        this.dispatchEvent(event1);
    }
}