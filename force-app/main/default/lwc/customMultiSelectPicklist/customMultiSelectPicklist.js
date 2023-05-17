import { LightningElement, api, track } from 'lwc';

export default class CustomMultiSelectPicklist extends LightningElement {
    /* 
        component receives the following params:
        label - String with label name;
        disabled - Boolean value, enable or disable Input;
        options - Array of objects [{label:'option label', value: 'option value'},{...},...];
    
        to clear the value call clear() function from parent:
        let multiSelectPicklist = this.template.querySelector('c-multi-select-pick-list');
        if (multiSelectPicklist) {
           multiSelectPicklist.clear();
        }
   
        to get the value receive "valuechange" event in parent;
        returned value is the array of strings - values of selected options;
        example of usage:
        <c-multi-select-pick-list options={marketAccessOptions}
                                   onvaluechange={handleValueChange}
                                   label="Market Access">
        </c-multi-select-pick-list>

        handleValueChange(event){
            console.log(JSON.stringify(event.detail));
        }
    */


    @api label = "";
    _disabled = false;
    @api
    get disabled() {
        return this._disabled;
    }
    set disabled(value) {
        this._disabled = value;
        this.handleDisabled();
    }
    @track inputOptions;
    @track labelClass = "slds-form-element__label"
    @api name = ""
    @api defaultValue = ""
    @api
    get options() {
        return this.inputOptions.filter(option => option.value !== 'All');
    }
    set options(value) {
        let options = [
            //     {
            //     value: 'All',
            //     label: 'All'
            // }
        ];
        this.inputOptions = options.concat(value);
    }
    @api
    clear() {
        this.handleAllOption();
    }
    value = [];
    @track inputValue = '';
    hasRendered;
    renderedCallback() {
        if (!this.hasRendered) {
            //  we coll the logic once, when page rendered first time
            this.handleDisabled();
            // if (this.defaultValue && this.options) {
            this.handleDefaultSelection()
            // }
        }
        if (!this.label)
            this.labelClass = "slds-form-element__label display_none"
        this.hasRendered = true;
    }
    connectedCallback() {
        if (this.defaultValue && this.options) {
            // this.handleDefaultSelection()
        }
    }
    handleDisabled() {
        let input = this.template.querySelector("input");
        if (input) {
            input.disabled = this.disabled;
        }
    }
    comboboxIsRendered;
    handleClick() {
        let sldsCombobox = this.template.querySelector(".slds-combobox");
        sldsCombobox.classList.toggle("slds-is-open");
        if (!this.comboboxIsRendered) {
            let allOption = this.template.querySelector('[data-id="All"]');
            // allOption.firstChild.classList.add("slds-is-selected");
            this.comboboxIsRendered = true;
        }
    }
    handleSelection(event) {
        let value = event.currentTarget.dataset.value;
        if (value === 'All') {
            this.handleAllOption();
        }
        else {
            this.handleOption(event, value);
        }
        let input = this.template.querySelector("input");
        input.focus();
        this.sendValues();
    }
    sendValues() {
        let values = [];
        for (const valueObject of this.value) {
            values.push(valueObject.value);
        }
        this.dispatchEvent(new CustomEvent("valuechange", {
            detail: values
        }));
    }
    handleAllOption() {
        this.value = [];
        this.inputValue = 'All';
        let listBoxOptions = this.template.querySelectorAll('.slds-is-selected');
        for (let option of listBoxOptions) {
            option.classList.remove("slds-is-selected");
        }
        let allOption = this.template.querySelector('[data-id="All"]');
        allOption.firstChild.classList.add("slds-is-selected");
        this.closeDropbox();
    }
    handleDefaultSelection() {
        const values = this.defaultValue ? this.defaultValue.split(";") : []
        // // debugger
        let option = this.options.filter(option => values.includes(option.value));
        this.value = option;
        this.inputOptions = [
            //     {
            //     value: 'All',
            //     label: 'All',
            //     className: values.length === 0 ? "slds-media slds-listbox__option slds-listbox__option_plain slds-media_small" : "slds-media slds-listbox__option slds-listbox__option_plain slds-media_small",
            // },
            ...this.options.reduce((result, el) => {
                result.push({
                    ...el,
                    className: values.includes(el.value) ? "slds-media slds-listbox__option slds-listbox__option_plain slds-media_small slds-is-selected slds-is-selected" : "slds-media slds-listbox__option slds-listbox__option_plain slds-media_small",
                })
                return result
            }, []),

        ]
        if (this.value.length > 1) {
            // this.inputValue = this.value.length + ' options selected';
            this.inputValue = this.value.reduce((a, b) => ({ value: a.value + ', ' + b.value })).value
        } else if (this.value.length === 1) {
            this.inputValue = this.value[0].label;
        }
        else {
            this.inputValue = '';
        }
    }
    handleOption(event, value) {
        let listBoxOption = event.currentTarget.firstChild;
        // console.log("current option:", this.options, JSON.stringify(event.currentTarget))
        // debugger
        if (listBoxOption.classList.contains("slds-is-selected")) {
            this.value = this.value.filter(option => option.value !== value);
        }
        else {
            //     let allOption = this.template.querySelector('[data-id="All"]');
            //     allOption.firstChild.classList.remove("slds-is-selected");
            let option = this.options.find(option => option.value === value);
            this.value.push(option);
        }
        if (this.value.length > 1) {
            // this.inputValue = this.value.length + ' options selected';
            this.inputValue = this.value.reduce((a, b) => ({ value: a.value + ', ' + b.value })).value
        }
        else if (this.value.length === 1) {
            this.inputValue = this.value[0].label;
        }
        else {
            this.inputValue = '';
        }
        // debugger
        listBoxOption.classList.toggle("slds-is-selected");
    }
    dropDownInFocus = false;
    handleBlur() {
        if (!this.dropDownInFocus) {
            this.closeDropbox();
        }
    }
    handleMouseleave() {
        this.dropDownInFocus = false;
    }
    handleMouseEnter() {
        this.dropDownInFocus = true;
    }
    closeDropbox() {
        let sldsCombobox = this.template.querySelector(".slds-combobox");
        sldsCombobox.classList.remove("slds-is-open");
    }
}