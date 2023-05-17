/* eslint-disable  no-console */
import { api, LightningElement } from 'lwc';

export default class CustomRadio extends LightningElement {
    @api options = [
    ];
    @api eventname;
    @api btnname;
    @api isdisabled = false
    handleSelected(e) {
        console.log("handleSelected", e.target.value);
        let selected_val = e.target.value;
        const event1 = new CustomEvent(this.eventname, {
            // detail contains only primitives

            detail: { selectedValue: selected_val, value: e.target.value, name: e.target.name }
        });
        this.dispatchEvent(event1);
    }
}