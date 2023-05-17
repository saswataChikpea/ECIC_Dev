import { LightningElement, track, wire } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import PARSER from '@salesforce/resourceUrl/PapaParseV2';
import createShipmentDecalarationBulk from '@salesforce/apex/ShipmentDeclarationBulk.createShipmentDecalarationBulk';
import getBuyerInformationBulk from '@salesforce/apex/ShipmentDeclarationBulk.getBuyerInformationBulk';
import current_user from '@salesforce/user/Id';
import getPolicyHolderData from '@salesforce/apex/PolicyManagement.getPolicyHolderData';
import USERNAME_FIELD from '@salesforce/schema/User.Username';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getBulkUploadTemplateUrl from '@salesforce/apex/ShipmentDeclarationBulk.getBulkUploadTemplateUrl';

import Company_Name from '@salesforce/label/c.Company_Name';
import Policy_Number from '@salesforce/label/c.Policy_Number';
import Policy_Type from '@salesforce/label/c.Policy_Type';
import Declaration_Record from '@salesforce/label/c.Declaration_Record';
import Declaration from '@salesforce/label/c.Declaration';
import Download_Shipment_Template from '@salesforce/label/c.Download_Shipment_Template';
import Download_Template from '@salesforce/label/c.Download_Template';
import By_Entry from '@salesforce/label/c.By_Entry';
import By_Batch from '@salesforce/label/c.By_Batch';
import Back from '@salesforce/label/c.Back';
import Submit from '@salesforce/label/c.Back';
import Edit from '@salesforce/label/c.Edit';
import Cancel from '@salesforce/label/c.Cancel';
import Next from '@salesforce/label/c.Next';



export default class ShipDecSubmissionBulk extends LightningElement {


    @track label ={
        Company_Name,Policy_Number,Policy_Type,Declaration_Record,Declaration,Download_Shipment_Template,
        Download_Template,By_Entry,By_Batch,Back,Submit,Edit,Cancel,Next
    }

    userId = current_user//'0050l000004g2LGAAY'//current_user;
    parserInitialized = false;
    @track data = []
    policyId
    policyType
    @track companyName;
    @track logged_in_user;
    @track policyNumber;
    @track availableBuyerNameMap = {}//to check valid buyer name
    @track availableBuyerCodeMap = {}//to check valid buyer code
    templateLink
    lateDeclarationReason
    lateDeclarationAcceptedList = []
    isShowBulkScreen = true;
    isShowShipDecSubmissionForm = false;

    // data = [{ "Pre_Shipment_Declaration__c": "Yes", "Buyer_Name__c": "Wagner, Burke and Ellis", "Buyer_Code__c": "JPN303861", "Shipment_Date__c": "2021-03-16", "Currency__c": "HKD", "Gross_Invoice_Value__c": "$30,035,450.80", "Payment_Term_Type__c": "DA", "Payment_Term_Days__c": "133", "Due_Date__c": "2021-07-27", "Endorsement__c": "", "Shipment_was_made_by_anoverseas_subsidia__c": "No", "Overseas_Subsidiary_Name__c": "", "Port_of_Loading_Ship_From__c": "Tokelau", "Country_of_Origin__c": "Netherlands", "Destination_Country_Market_Ship_to__c": "Poland", "Harmonized_Code__c": "1051400", "Policyholder_Reference_No__c": "Xm9638368773" }, { "Pre_Shipment_Declaration__c": "No", "Buyer_Name__c": "Hess, Daniels and Sloan", "Buyer_Code__c": "GUM352730", "Shipment_Date__c": "2021-04-05", "Currency__c": "NLG", "Gross_Invoice_Value__c": "$40,458,059.51", "Payment_Term_Type__c": "DP", "Payment_Term_Days__c": "", "Due_Date__c": "", "Endorsement__c": "", "Shipment_was_made_by_anoverseas_subsidia__c": "No", "Overseas_Subsidiary_Name__c": "", "Port_of_Loading_Ship_From__c": "Bouvet Island", "Country_of_Origin__c": "Trinidad and Tobago", "Destination_Country_Market_Ship_to__c": "Jordan", "Harmonized_Code__c": "1063300", "Policyholder_Reference_No__c": "ca6406780938" }, { "Pre_Shipment_Declaration__c": "No", "Buyer_Name__c": "Wise Ltd", "Buyer_Code__c": "PAN413464", "Shipment_Date__c": "2021-01-05", "Currency__c": "NZD", "Gross_Invoice_Value__c": "$94,036,209.89", "Payment_Term_Type__c": "DP", "Payment_Term_Days__c": "", "Due_Date__c": "", "Endorsement__c": "", "Shipment_was_made_by_anoverseas_subsidia__c": "No", "Overseas_Subsidiary_Name__c": "", "Port_of_Loading_Ship_From__c": "Falkland Islands (Malvinas)", "Country_of_Origin__c": "Bangladesh", "Destination_Country_Market_Ship_to__c": "New Caledonia", "Harmonized_Code__c": "1062010", "Policyholder_Reference_No__c": "Fs6522883046" }, { "Pre_Shipment_Declaration__c": "No", "Buyer_Name__c": "May Inc", "Buyer_Code__c": "AIA314592", "Shipment_Date__c": "2021-04-13", "Currency__c": "NLG", "Gross_Invoice_Value__c": "$3,224,055.98", "Payment_Term_Type__c": "DA", "Payment_Term_Days__c": "129", "Due_Date__c": "2021-08-20", "Endorsement__c": "", "Shipment_was_made_by_anoverseas_subsidia__c": "No", "Overseas_Subsidiary_Name__c": "", "Port_of_Loading_Ship_From__c": "Luxembourg", "Country_of_Origin__c": "Indonesia", "Destination_Country_Market_Ship_to__c": "Azerbaijan", "Harmonized_Code__c": "1051100", "Policyholder_Reference_No__c": "cV5653154242" }]
    // data = [
    //     {
    //         "a": 1,
    //         "b": 2,
    //     },
    //     {
    //         "a": 3,
    //         "b": 4
    //     }
    // ]
    // @track keys = []
    editData = true
    @track errDataMap = {}
    @track validationErrDataMap = {}
    @track successfulData = []
    @track errData = []
    // @track errData = [...this.data]// []
    defSortIconClass = " slds-button__icon_right slds-current-color"
    keys = [
        {
            "label": "Pre-Shipment Declaration",
            "fieldName": "Pre_Shipment_Declaration__c",
            "type": "picklist",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass,
        },
        {
            "label": "Buyer Name",
            "fieldName": "Buyer_Name__c",
            "type": "text",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass,
            "isRequired": true
        },
        {
            "label": "Buyer Code",
            "fieldName": "Buyer_Code__c",
            "type": "text",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass,
            "isRequired": true
        },
        {
            "label": "Shipment Date",
            "fieldName": "Shipment_Date__c",
            "type": "date",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass,
            "isRequired": true
        },
        {
            "label": "Currency",
            "fieldName": "Currency__c",
            "type": "picklist",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass,
            "isRequired": true
        },
        {
            "label": "Gross Invoice Value (Amount)",
            "fieldName": "Gross_Invoice_Value__c",
            "type": "text",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass,
            "isRequired": true
        },
        {
            "label": "Payment Term",
            "fieldName": "Payment_Term_Type__c",
            "type": "picklist",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass,
        },
        {
            "label": "Tenor",
            "fieldName": "Payment_Term_Days__c",
            "type": "text",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass,
        },
        {
            "label": "Due Date",
            "fieldName": "Due_Date__c",
            "type": "date",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass,
        },
        {
            "label": "Endorsement",
            "fieldName": "Endorsement__c",
            "type": "picklist",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass,
        },
        {
            "label": "Shipment was made by an overseas subsidiary",
            "fieldName": "Shipment_was_made_by_anoverseas_subsidia__c",
            "type": "picklist",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass,
        },
        {
            "label": "Overseas Subsidiary Name",
            "fieldName": "Overseas_Subsidiary_Name__c",
            "type": "text",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass,
        },
        {
            "label": "Port of Loading (\"Ship From\")",
            "fieldName": "Port_of_Loading_Ship_From__c",
            "type": "picklist",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass,
            "isRequired": true
        },
        {
            "label": "Country/Market of Origin",
            "fieldName": "Country_of_Origin__c",
            "type": "picklist",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass,
            "isRequired": true
        },
        {
            "label": "Destination Country / Market (\"Ship To\")",
            "fieldName": "Destination_Country_Market_Ship_to__c",
            "type": "picklist",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass,
            "isRequired": true
        },
        {
            "label": "Harmonized Code",
            "fieldName": "Harmonized_Code__c",
            "type": "text",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass,
            "isRequired": true
        },
        {
            "label": "Policyholder’s Reference No. (if any)",
            "fieldName": "Policyholder_Reference_No__c",
            "type": "text",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass,
            "isRequired": true
        }
    ]
    keyMap = this.keys.reduce((ac, a) => ({ ...ac, [a.fieldName]: a }), {})
    @track allDataKeys = [...this.keys]
    @track successfulDataKeys = [...this.keys]
    @track errDataKeys = [...this.keys]
    openSubmitPage = false

    @track dataList = []
    @track successDataList = []
    @track errDataList = []
    @track editErrDataList = []
    @track lateDecErrDataList = []

    setDataList(type) {
        const dataType = type || 'ALL'
        let temp = []
        let errMap = {}
        if (dataType == 'ALL') {
            temp = [...this.data]
            errMap = { ...this.errDataMap }
        } else if (dataType == 'SUCCESSFUL') {
            temp = [...this.successfulData]
        } else if (dataType == 'ERR') {
            temp = [...this.errData]
            errMap = { ...this.validationErrDataMap }
        }
        console.log("setDataList::", type);
        console.log("errMap::", JSON.stringify(errMap));
        const temp1 = temp.map((row, index) => {
            console.log("row::", errMap[index])
            const r = {
                key: index,
                errorMsg: !this.editData && errMap[index] ? errMap[index] : "",
                class: (!this.editData && errMap[index]) ? "rowHasError" : "",
                dataMap: row,
                isEditable: dataType == 'ERR' && this.editErrDataList.includes(index) ? true : false,
                isLateDeclared: dataType == 'ERR' && this.lateDecErrDataList.includes(index) ? true : false,
                lateDeclarationReason: dataType == 'SUCCESSFUL' && this.lateDeclarationAcceptedList.includes(index) ? this.lateDeclarationReason : "",

                data: Object.keys(row).map((key, i) => {
                    let cell = {
                        key: i,
                        value: row[key],
                        Name: key
                    }
                    const type = this.keyMap[key] ? this.keyMap[key].type : ""//this.getFieldType(key)

                    if (type == 'picklist') {
                        cell['options'] = this.getOptions(key)
                        cell['isDropdown'] = true
                    } else if (type == 'date') {
                        cell['isDate'] = true
                    } else {
                        cell['isText'] = true
                    }
                    return cell
                })

            }
            // delete this.errDataMap[index];
            return r;
        })
        if (dataType == 'ALL') {
            this.dataList = temp1
            this.errDataMap = {}
        } else if (dataType == 'SUCCESSFUL') {
            this.successDataList = temp1
        } else if (dataType == 'ERR') {
            this.errDataList = temp1
            // this.validationErrDataMap = {}
        }
        // console.log("datalist:", JSON.stringify(this.dataList));
        // return temp
    }
    // get errDataList() {
    //     const temp = this.errData.map((row, index) => {
    //         // console.log("row::", JSON.stringify(row))
    //         return {
    //             key: index,
    //             errorMsg: !this.editData && this.errDataMap[index] ? this.errDataMap[index] : "",
    //             // class: (!this.editData && this.errDataMap[index]) ? "rowHasError" : "",
    //             class: "rowHasError",
    //             isEditable: this.editErrDataList.includes(index) ? true : false,
    //             data: Object.keys(row).map((key, i) => {
    //                 let cell = {
    //                     key: i,
    //                     value: row[key],
    //                     Name: key,
    //                 }
    //                 // const type = this.keyMap[key].type//this.getFieldType(key)
    //                 const type = this.keyMap[key] ? this.keyMap[key].type : ""//this.getFieldType(key)

    //                 if (type == 'picklist') {
    //                     cell['options'] = this.getOptions(key)
    //                     cell['isDropdown'] = true
    //                 } else if (type == 'date') {
    //                     cell['isDate'] = true
    //                 } else {
    //                     cell['isText'] = true
    //                 }
    //                 return cell
    //             })

    //         }
    //     })
    //     console.log("error datalist:", JSON.stringify(temp));
    //     return temp
    // }

    getOptions(apiName) {
        // return [{ "label": "Yes", "value": "Yes", "isChecked": false }, { "label": "No", "value": "No", "isChecked": false }]
        return {
            Pre_Shipment_Declaration__c: [{ "label": "Yes", "value": "Yes" }, { "label": "No", "value": "No" }],
            Currency__c: this.currencyOptions,
            Payment_Term_Type__c: [{ "label": "DP", "value": "DP" }, { "label": "DA", "value": "DA" }, { "label": "OA", "value": "OA" }],
            Shipment_was_made_by_anoverseas_subsidia__c: [{ "label": "Yes", "value": "Yes" }, { "label": "No", "value": "No" }],
            Port_of_Loading_Ship_From__c: this.countryOptions,
            Country_of_Origin__c: this.countryOptions,
            Destination_Country_Market_Ship_to__c: this.countryOptions,
            Endorsement__c: this.edorsementOptions
        }[apiName]
    }
    apiNameMap = {
        "Pre-Shipment Declaration": "Pre_Shipment_Declaration__c",
        "Buyer Name": "Buyer_Name__c",
        "Buyer Code": "Buyer_Code__c",
        "Shipment Date": "Shipment_Date__c",
        "Currency": "Currency__c",
        "Gross Invoice Value (Amount)": "Gross_Invoice_Value__c",
        "Payment Term": "Payment_Term_Type__c",
        "Tenor": "Payment_Term_Days__c",
        "Due Date": "Due_Date__c",
        "Endorsement": "Endorsement__c",
        "Shipment was made by an overseas subsidiary": "Shipment_was_made_by_anoverseas_subsidia__c",
        "Overseas Subsidiary Name": "Overseas_Subsidiary_Name__c",
        'Port of Loading ("Ship From")': "Port_of_Loading_Ship_From__c",
        "Country/Market of Origin": "Country_of_Origin__c",
        'Destination Country / Market ("Ship To")': "Destination_Country_Market_Ship_to__c",
        "Harmonized Code": "Harmonized_Code__c",
        "Policyholder’s Reference No. (if any)": "Policyholder_Reference_No__c"
    }
    connectedCallback() {
        console.log("current_user::", this.userId)
        // this.validateFileds(this.userId)
        this.getPolicyHolderData()
        this.getBulkUploadTemplateUrl()
    }

    getFieldType(key) {
        if (['Pre_Shipment_Declaration__c', 'Currency__c', 'Payment_Term_Type__c', 'Shipment_was_made_by_anoverseas_subsidia__c',
            'Port of Loading ("Ship From")', 'Country of Origin', 'Destination Country / Market ("Ship To")']
            .includes(key)) {
            return 'DROP_DOWN'
        } else if (['Shipment Date', 'Due Date'].includes(key)) {
            return 'DATE'
        } else {
            return "TEXT"
        }
    }
    handleQChange(e) {
        const name = e.currentTarget.dataset.name
        const value = e.target.value
        var key = e.currentTarget.dataset.id;
        console.log('handleqchange::' + 'key=' + key + ' name=', name + ' value= ' + value);
        // debugger
        if ((name == 'Shipment_Date__c' && this.data[key]['Payment_Term_Days__c']) || (name == 'Payment_Term_Days__c' && this.data[key]['Shipment_Date__c'])) {
            try {
                const d = name == 'Payment_Term_Days__c' ? this.data[key]['Shipment_Date__c'] : value
                const day = name == 'Payment_Term_Days__c' ? Number(value) : Number(this.data[key]['Payment_Term_Days__c'])
                let current = new Date(d);
                current = new Date(current.getFullYear(), current.getMonth(), current.getDate() + day);

                const today = current.getFullYear() + '-' + String(current.getMonth() + 1).padStart(2, '0') + '-' + String(current.getDate()).padStart(2, '0');
                // return today

                this.data[key]['Due_Date__c'] = today
            } catch (error) {
                console.error(error);
            }
        }
        this.data[key][name] = value
        this.setDataList()

    }
    handleQChangeErr(e) {
        const name = e.currentTarget.dataset.name
        const value = e.target.value
        var key = e.currentTarget.dataset.id;
        console.log('handleqchange::' + 'key=' + key + ' name=', name + ' value= ' + value);
        // debugger
        if ((name == 'Shipment_Date__c' && this.errData[key]['Payment_Term_Days__c']) || (name == 'Payment_Term_Days__c' && this.errData[key]['Shipment_Date__c'])) {
            try {
                const d = name == 'Payment_Term_Days__c' ? this.errData[key]['Shipment_Date__c'] : value
                const day = name == 'Payment_Term_Days__c' ? Number(value) : Number(this.errData[key]['Payment_Term_Days__c'])
                let current = new Date(d);
                current = new Date(current.getFullYear(), current.getMonth(), current.getDate() + day);

                const today = current.getFullYear() + '-' + String(current.getMonth() + 1).padStart(2, '0') + '-' + String(current.getDate()).padStart(2, '0');
                // return today

                this.errData[key]['Due_Date__c'] = today
            } catch (error) {
                console.error(error);
            }
        }
        this.errData[key][name] = value

        //now check whole row
        try {

            const el = this.errData[key]
            const buyerInfo = this.availableBuyerNameMap[el.Buyer_Name__c]
            let errMsg = "Invalid credit limit or outstanding credit limit application for this buyer"
            const validShipmentDate = this.validateShipmentDate(el.Shipment_Date__c)
            console.log('buyerInfo::', buyerInfo, 'validShipmentDate: ' + validShipmentDate);
            if (buyerInfo && validShipmentDate) {
                console.log("Err fixed::");
                this.successfulData.push(el)
                this.setDataList('SUCCESSFUL')
                this.errData.splice(key, 1)
                this.editErrDataList.splice(this.editErrDataList.indexOf(key), 1)
                this.lateDecErrDataList.splice(this.lateDecErrDataList.indexOf(key), 1)
                // delete this.validationErrDataMap[key];
                this.validationErrDataMap = Object.keys(this.validationErrDataMap).reduce((acc, a) => {
                    if (Number(a) >= key) {
                        return { ...acc, [a]: this.validationErrDataMap[Number(a) + 1] }
                    } else {
                        return { ...acc, [a]: this.validationErrDataMap[a] }
                    }
                }, {})
                // this.errData = this.errData.filter((el, i) => (i !== key))
            }
            else {
                // this.errData.push(el)
                if (buyerInfo && !validShipmentDate) {
                    errMsg = 'Late Declaration'
                    if (!this.lateDecErrDataList.includes(key)) {
                        this.lateDecErrDataList.push(key)
                    }
                }
                console.log('Still has error::');
                // this.validationErrDataMap = this.errData.reduce((ac, a, i) => ({ ...ac, [i]: errMsg }), {})
                this.validationErrDataMap[key] = errMsg
            }

        } catch (error) {
            console.error("err:", JSON.stringify(error));
        }
        this.setDataList('ERR')

    }

    removeErrRow(event) {
        var key = event.currentTarget.dataset.id;
        console.log("remove::", key);
        if (this.errData.length > 0) {
            this.errData.splice(key, 1)
            this.validationErrDataMap = Object.keys(this.validationErrDataMap).reduce((acc, a) => {
                if (Number(a) >= key) {
                    return { ...acc, [a]: this.validationErrDataMap[Number(a) + 1] }
                } else {
                    return { ...acc, [a]: this.validationErrDataMap[a] }
                }
            }, {})
            if (this.lateDecErrDataList.includes(Number(key))) {
                this.lateDecErrDataList.splice(this.lateDecErrDataList.indexOf(Number(key)), 1)
            }
        }
        console.log("lateDecErrDataList:", JSON.stringify(this.lateDecErrDataList));
        console.log("validationErrDataMap:", JSON.stringify(this.validationErrDataMap));
        this.errDataList = this.errDataList.filter((el) => (el.key !== Number(key)))
        // this.setDataList('ERR')
    }
    editErrRow(event) {
        var key = event.currentTarget.dataset.id;
        console.log("edit::", key);
        if (!this.lateDecErrDataList.includes(Number(key))) {
            this.editErrDataList.push(Number(key))
        }
        console.log("edit::", JSON.stringify(this.editErrDataList));
        this.setDataList('ERR')
    }
    addNewRow() {
        if (this.successfulData.length >= 20) {
            this.showToast("You have reached maximum limit of 20 records")
            return
        }
        // this.successfulData.push(
        //     this.keys.map(el => (el.fieldName)).reduce((ac, a) => ({ ...ac, [a]: '' }), {})
        // )
        this.data.push(
            this.keys.map(el => (el.fieldName)).reduce((ac, a) => ({ ...ac, [a]: '' }), {})
        )
        this.setDataList()
    }
    removeRow(event) {
        var key = event.currentTarget.dataset.id;
        if (this.data.length > 0) {
            this.data.splice(key, 1)
            this.setDataList()
        }
    }
    sortAsending(event) {
        var key = event.currentTarget.dataset.id;
        const type = event.currentTarget.dataset.type;
        console.log("sortAsending::", key, type);
        try {
            if (type == 'ALL') {
                this.dataList = this.dataList.sort((a, b) => (a.dataMap[key] > b.dataMap[key]) ? 1 : ((b.dataMap[key] > a.dataMap[key]) ? -1 : 0))
            } else if (type == 'SUCCESSFUL') {
                this.successDataList = this.successDataList.sort((a, b) => (a.dataMap[key] > b.dataMap[key]) ? 1 : ((b.dataMap[key] > a.dataMap[key]) ? -1 : 0))
            } else if (type == 'ERR') {
                this.errDataList = this.errDataList.sort((a, b) => (a.dataMap[key] > b.dataMap[key]) ? 1 : ((b.dataMap[key] > a.dataMap[key]) ? -1 : 0))
            }
            this.setSortedIconColor(type, key, 'up')
        } catch (error) {
            console.log("error::", error);
        }
        // console.log(JSON.stringify(this.dataList));
        // this.setDataList()
    }
    sortDecending(event) {
        var key = event.currentTarget.dataset.id;
        const type = event.currentTarget.dataset.type;
        console.log("sortDecending::", key, type);
        this.dataList = this.dataList.sort((a, b) => (a.dataMap[key] < b.dataMap[key]) ? 1 : ((b.dataMap[key] < a.dataMap[key]) ? -1 : 0))
        try {
            if (type == 'ALL') {
                this.dataList = this.dataList.sort((a, b) => (a.dataMap[key] < b.dataMap[key]) ? 1 : ((b.dataMap[key] > a.dataMap[key]) ? -1 : 0))
            } else if (type == 'SUCCESSFUL') {
                this.successDataList = this.successDataList.sort((a, b) => (a.dataMap[key] < b.dataMap[key]) ? 1 : ((b.dataMap[key] > a.dataMap[key]) ? -1 : 0))
            } else if (type == 'ERR') {
                this.errDataList = this.errDataList.sort((a, b) => (a.dataMap[key] < b.dataMap[key]) ? 1 : ((b.dataMap[key] > a.dataMap[key]) ? -1 : 0))
            }
            this.setSortedIconColor(type, key, 'down')
        } catch (error) {
            console.log("error::", error);
        }

        // this.setSortedIconColor(type, key, 'down')
        // this.setDataList()
    }
    handleCheckboxChange(event) {
        try {
            const targetValue = event.target.checked
            const targetName = event.target.name
            const value = event.currentTarget.dataset.value
            console.log(targetName + ':: ' + targetValue + ':: ', value);
            if (targetValue) {
                this.lateDeclarationReason = value
            }
        } catch (error) {
            console.error(error);
        }

    }

    setSortedIconColor(dataType, key, type) {
        // for (const el of this.keys) {
        const temp = this.keys.map(k => {
            let el = { ...k }
            if (key == el.fieldName) {
                el.upIconClass = type == 'up' ? this.defSortIconClass + ' sortIconSelected' : this.defSortIconClass
                el.downIconClass = type == 'down' ? this.defSortIconClass + ' sortIconSelected' : this.defSortIconClass
            }
            return el
            //  else {
            //     el.upIconClass = this.defSortIconClass
            //     el.downIconClass = this.defSortIconClass
            // }
        })
        // console.log("key:::", el);
        // }
        if (dataType == 'ALL') {
            this.allDataKeys = temp
        } else if (dataType == 'SUCCESSFUL') {
            this.successfulDataKeys = temp
        } else if (dataType == 'ERR') {
            this.errDataKeys = temp
        }
    }
    validateFileds() {//check on field level 
        // return true
        // this.errData = []
        this.successfulData = []
        let i = 0
        this.data.forEach(row => {
            //	

            let mandetoryFiledsErr = []
            if (!row['Buyer_Name__c']) {
                mandetoryFiledsErr.push('Buyer Name')
            }
            if (!row['Buyer_Code__c']) {
                mandetoryFiledsErr.push('Buyer Code')
            }
            if (!row['Shipment_Date__c']) {
                mandetoryFiledsErr.push('Shipment Date')
            }
            if (!row['Currency__c']) {
                mandetoryFiledsErr.push('Currency')
            }
            if (!row['Gross_Invoice_Value__c']) {
                mandetoryFiledsErr.push('Gross Invoice Value (Amount)')
            }
            if (!row['Port_of_Loading_Ship_From__c']) {
                mandetoryFiledsErr.push('Port of Loading ("Ship From")')
            }
            if (!row['Country_of_Origin__c']) {
                mandetoryFiledsErr.push('Country/Market of Origin')
            }
            if (!row['Destination_Country_Market_Ship_to__c']) {
                mandetoryFiledsErr.push('Destination Country / Market ("Ship To")')
            }
            if (!row['Harmonized_Code__c']) {
                mandetoryFiledsErr.push('Harmonized Code')
            }
            if (mandetoryFiledsErr.length) {
                this.errDataMap[i] = 'Mandetory field(s) ' + mandetoryFiledsErr.join(', ') + ' can not be empty.'
            }
            i++;
        });
        console.log(JSON.stringify(this.errDataMap));
        this.setDataList()
        return this.errData.length == 0 ? true : false

    }
    validateData() {//checkbuyer name, code etc record level
        // return true
        this.errData = []
        this.successfulData = []
        this.errDataMap = {}
        this.editErrDataList = []
        this.lateDecErrDataList = []

        try {
            this.data.forEach(el => {
                const buyerInfo = this.availableBuyerNameMap[el.Buyer_Name__c]
                // this.validationErrDataMap = this.errData.reduce((ac, a, i) => ({ ...ac, [i]: errMsg }), {})
                let errMsg = "Invalid credit limit or outstanding credit limit application for this buyer"
                const validShipmentDate = this.validateShipmentDate(el.Shipment_Date__c)
                console.log('buyerInfo::', buyerInfo, 'validShipmentDate: ' + validShipmentDate);
                if (buyerInfo && validShipmentDate) {
                    this.successfulData.push(el)
                }
                else {
                    this.errData.push(el)
                    if (buyerInfo && !validShipmentDate) {
                        errMsg = 'Late Declaration'
                        this.lateDecErrDataList.push(this.errData.length - 1)

                    }
                    // console.log('debugger maybe');
                    // this.validationErrDataMap = this.errData.reduce((ac, a, i) => ({ ...ac, [i]: errMsg }), {})
                    this.validationErrDataMap[this.errData.length - 1] = errMsg
                }
                // i++;
            })

            this.setDataList('ERR')
            this.setDataList('SUCCESSFUL')

        } catch (error) {
            console.error('Error 1 ' + error.toString());
        }

    }
    validateLateDeclaration() {
        if (!this.lateDeclarationReason) {
            this.showToast("Please choose a valid reason for late declaration")
            return
        }

        let temp = []
        this.errDataList.forEach(el => {
            if (el.isLateDeclared) {
                this.successfulData.push(el.dataMap)
                this.lateDeclarationAcceptedList.push(this.successfulData.length - 1)
            } else {
                temp.push({ ...el })
            }
        })
        this.errData = this.errData.filter((el, i) => (!this.lateDecErrDataList.includes(i)))
        this.lateDecErrDataList = []
        this.errDataList = temp;
        this.setDataList('SUCCESSFUL')
    }
    @wire(getRecord, {
        recordId: current_user,
        fields: [USERNAME_FIELD]
    }) wireuser({
        error,
        data
    }) {
        if (error) {
            this.error = error;
            //this.name='alice.zzzz@ignatica.io';
        } else if (data) {
            console.log('data.fields : ' + JSON.stringify(data.fields));
            this.logged_in_user = data.fields.Username.value;
        }
    }

    validateShipmentDate(shipmentDate) {
        let isValid = false;
        if (shipmentDate) {
            const sd = new Date(shipmentDate)
            const d = new Date()
            if (d.getFullYear() == sd.getFullYear()) {
                if (d.getDate() <= 14) {
                    if ((sd.getMonth() == d.getMonth()) || (sd.getMonth() == (d.getMonth() - 1))) {
                        isValid = true;
                    }
                } else if (d.getDate() > 14) {
                    if (sd.getMonth() == d.getMonth()) {
                        isValid = true;
                    }
                }
            }
        }
        console.log('shipmentDate :', shipmentDate, isValid);
        return isValid;
    }

    @wire(getBuyerInformationBulk, { usrId: '$userId' })
    getBuyerInformationBulkCallback({ error, data }) {
        if (data) {
            console.log("getBuyerInformationBulk success::" + JSON.stringify(data));
            if (data.length > 0) {
                this.availableBuyerNameMap = data.reduce((acc, a) => ({ ...acc, [a.buyerName]: a }), {})
                this.availableBuyerCodeMap = data.reduce((acc, a) => ({ ...acc, [a.buyerCode]: a }), {})
            }
            // console.log("buyer code map::", JSON.stringify(this.availableBuyerNameMap));

        } else if (error) {
            console.log("getBuyerInformationBulk Error::" + JSON.stringify(error));
        }
    }

    getPolicyHolderData() {
        console.log('getPolicyHolderData called.');
        getPolicyHolderData({
            usrId: this.userId
        }).then(data => {
            console.log('getPolicyHolderData success :' + JSON.stringify(data));
            try {
                this.companyName = data.Name;
                this.policyNumber = data.Current_Policy__r.Name;
                this.policyId = data.Current_Policy__c;
                this.policyType = data.Current_Policy__r.Product__r.Name;
                //this.isLoadCMS = true;

            } catch (error) {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Something went wrong fetching data',
                        message: error.toString(),
                        mode: 'sticky',
                        variant: 'error'
                    })
                );
            }

        }).catch(error => {

            this.dispatchEvent(
                // new ShowToastEvent({
                //     title: 'Something went wrong fetching data',
                //     message: error.toString(),
                //     mode: 'sticky',
                //     variant: 'error'
                // })
            );
        });
    }
    getBulkUploadTemplateUrl() {
        console.log('getBulkUploadTemplateUrl called. userid', this.userId);
        getBulkUploadTemplateUrl().then(data => {
            console.log('getBulkUploadTemplateUrl success :' + JSON.stringify(data));
            try {
                this.templateLink = data
            } catch (error) {
                console.error("error cms::", JSON.stringify(error));

            }

        }).catch(error => {
            console.error("error cms::", JSON.stringify(error));
        });
    }
    gotoFormScreen() {
        console.log('gotoFormScreen :: ');
        this.isShowBulkScreen = false;
        this.isShowShipDecSubmissionForm = true;
        // this.isShowShipDecRecordScreen = false;
    }

    toggleEdit() {
        this.editData = !this.editData
        if (!this.editData) {
            this.validateFileds()
        }
    }
    toggleShowSubmit() {
        if (this.openSubmitPage) {
            this.data = [...this.successfulData, ... this.errData]
        }
        this.openSubmitPage = !this.openSubmitPage
    }
    verifyData() {
        console.log("handle verify data click");
        this.toggleShowSubmit()
        this.validateData()
    }
    submitData() {
        console.log("handle submit data click");
        let submitData = false
        if (this.successfulData.length == 0) {
            this.showToast("No data to upload. Please correct the records and try again")
            return
        }
        if (this.errData.length) {
            let msg = `There are ${this.errData.length} records cannot be submitted due to error. Do yo want to submit the declaration without error?`
            if (!confirm(msg)) {
                console.log('"::::No');
            } else {
                submitData = true
            }
        } else {
            submitData = true
        }
        if (submitData) {
            console.log("successful data:", JSON.stringify(this.successDataList));
            const data = this.successDataList.map(el => {
                if (el.lateDeclarationReason) {
                    return { ...el.dataMap, Reason_For_Late_Declaration__c: el.lateDeclarationReason }
                } else {
                    return { ...el.dataMap }
                }
            })

            console.log("calling submit bulk. data::", JSON.stringify(data));
            createShipmentDecalarationBulk({ shipDecList: data, policyId: this.policyId }).then(data => {
                console.log("createShipmentDecalarationBulk sucessful::", data);
                this.showToast("Shipment declaration has been submitted successfully.", 'Success', 'success')
            }).catch(error => {
                console.log("createShipmentDecalarationBulk error::", error);
            })
        }
    }

    renderedCallback() {
        if (!this.parserInitialized) {

            Promise.all([
                loadScript(this, PARSER + '/papaparse.min.js'),
            ])
                .then(() => {
                    // Initialise the calen
                    this.parserInitialized = true;


                })
                .catch(error => {
                    // eslint-disable-next-line no-console
                    console.error({
                        message: 'Error occured on FullCalendarJS',
                        error
                    });
                })
            // }
        }
    }

    openfileUpload(event) {
        try {
            const file = event.target.files[0]
            console.log(file.size)
            Papa.parse(file, {
                quoteChar: '"',
                header: 'true',
                complete: (results) => {
                    // this._rows = results.data;
                    this.loading = false;
                    // console.log('data:::', JSON.stringify(results.data))
                    if (results.data.length == 0) {
                        console.log("No data provided");
                        return
                    }
                    try {
                        this.data = results.data.map(el => {
                            return Object.keys(el).reduce((ac, key) => {
                                return {
                                    ...ac,
                                    [this.apiNameMap[key]]: el[key]
                                }
                            },
                                {}
                            )
                        })
                        this.data = this.data.filter(el => (el.Buyer_Name__c || el.Buyer_Code__c || el.Currency__c))
                        this.editData = false
                        this.validateFileds()
                        // console.log("formatted data::", JSON.stringify(this.data));
                    } catch (error) {
                        console.error(error);
                    }
                },
                error: (error) => {
                    console.error(error);
                    this.loading = false;
                }
            })

        } catch (error) {
            console.error(error);
        }
    }

    showToast = (message, title, variant) => {
        try {
            if (this.isLocal) {
                alert(message || "")
                return
            }
            const toastEvent = new ShowToastEvent({
                title: title || 'Error!',
                message: message || "",
                variant: variant || 'error'
            })
            this.dispatchEvent(toastEvent)
        } catch (error) {
            console.error(error)
        }

    }
    endorsementList = ["EN21 Hand-Carriage of Goods Endorsement", "EN48A Extended Cover for Pre-shipment Risks Endorsement", "EN49A Pre-Shipment Endorsement", "EN67 Sales By Overseas Subsidiary Company (Sales In Subsidiary Country / Market) Endorsement", "EN68 Sales By Overseas Subsidiary Company (Sales In Subsidiary Country / Market) Endorsement", "EN69 Sales By Overseas Subsidiary Company (Sales Over The Border) Endorsement", "EN70 Sales By Overseas Subsidiary Company (Sales Over The Border) Endorsement", "EN84 Sales By Overseas Subsidiary Company (Sales In Subsidiary Country / Market) Endorsement", "EN85 Sales By Overseas Subsidiary Company (Sales In Subsidiary Country / Market) Endorsement", "EN86 Sales By Overseas Subsidiary Company (Sales Over The Border) Endorsement", "EN87 Sales By Overseas Subsidiary Company (Sales Over The Border) Endorsement"]
    edorsementOptions = this.endorsementList.map(el => ({ label: el, value: el }))
    currencyList = ["AUD", "CAD", "CHF", "DEM", "EUR", "GBP", "JPY", "NZD", "SGD", "USD", "ATS", "BEF", "CNY", "DKK", "IEP", "NLG", "NOK", "SEK", "TWD", "ZAR", "FIM", "PTE", "HKD", "ECU", "MYR", "ALL", "DZD", "AMD", "BSD", "BHD", "BDT", "BBD", "BZD", "XOF", "BMD", "BTN", "BOB", "BWP", "BRL", "BND", "BIF", "XAF", "CVE", "KYD", "CLP", "COP", "KMF", "CRC", "HRK", "CUP", "CZK", "DJF", "XCD", "DOP", "ECS", "EGP", "SVC", "ETB", "FKP", "FJD", "XPF", "GMD", "GIP", "GRD", "GTQ", "GNF", "GYD", "HTG", "HNL", "HUF", "ISK", "INR", "IDR", "IRR", "IQD", "ILS", "JMD", "JOD", "KHR", "KZT", "KES", "KRW", "KWD", "LAK", "LBP", "LSL", "LRD", "LYD", "LTL", "LUF", "MOP", "MKD", "MWK", "MVR", "MRU", "MUR", "MDL", "MNT", "MAD", "MMK", "NPR", "ANG", "NGN", "KPW", "OMR", "PKR", "PAB", "PGK", "PYG", "PEN", "PHP", "PLN", "QAR", "RON", "RWF", "STN", "SAR", "SCR", "SLL", "SIT", "SBD", "SOS", "LKR", "SHP", "SZL", "SYP", "TZS", "THB", "TOP", "TTD", "TND", "TRL", "UGX", "AED", "UYW", "UZS", "VUV", "VES", "VND", "WST", "YER", "YUN", "CDF", "KGS", "NAD", "GEL", "ROL", "BAM", "AWG", "AFN", "AOA", "ARS", "AZN", "BGN", "BYN", "ERN", "GHS", "MGA", "MXN", "MZN", "NIO", "RSD", "RUB", "SDG", "SRD", "TJS", "TMT", "TRY", "UAH", "ZMW", "ZWL", "SSP"]
    currencyOptions = this.currencyList.map(el => ({ label: el, value: el }))
    get countryOptions() {
        return [
            { label: "Australia", value: "Australia" },
            { label: "Austria", value: "Austria" },
            { label: "Belgium", value: "Belgium" },
            { label: "Bermuda", value: "Bermuda" },
            { label: "Brunei Darussalam", value: "Brunei Darussalam" },
            { label: "Canada", value: "Canada" },
            { label: "Chile", value: "Chile" },
            { label: "China", value: "China" },
            { label: "Czechia", value: "Czechia" },
            { label: "Denmark", value: "Denmark" },
            { label: "Finland", value: "Finland" },
            { label: "France", value: "France" },
            { label: "Gabon Germany", value: "Gabon Germany" },
            { label: "Holy See", value: "Holy See" },
            { label: "Ireland", value: "Ireland" },
            { label: "Italy", value: "Italy" },
            { label: "Japan", value: "Japan" },
            { label: "Korea, Republic of ", value: "Korea, Republic of " },
            { label: "Kuwait", value: "Kuwait" },
            { label: "Liechtensteni", value: "Liechtensteni" },
            { label: "Luxembourg", value: "Luxembourg" },
            { label: "Macao", value: "Macao" },
            { label: "Manoco", value: "Manoco" },
            { label: "Netherlands", value: "Netherlands" },
            { label: "New Zealand", value: "New Zealand" },
            { label: "Norway", value: "Norway" },
            { label: "Oman", value: "Oman" },
            { label: "Portugal", value: "Portugal" },
            { label: "Qatar", value: "Qatar" },
            { label: "San Marino", value: "San Marino" },
            { label: "Saudi Arabia", value: "Saudi Arabia" },
            { label: "Singapore", value: "Singapore" },
            { label: "Spain", value: "Spain" },
            { label: "Sweden", value: "Sweden" },
            { label: "Switzerland", value: "Switzerland" },
            { label: "Taiwan", value: "Taiwan" },
            { label: "United Arab Emirates", value: "United Arab Emirates" },
            { label: "United Kindom", value: "United Kindom" },
            { label: "United States of America", value: "United States of America" },
            { label: "Aland Island", value: "Aland Island" },
            { label: "American Samoa", value: "American Samoa" },
            { label: "Andorra", value: "Andorra" },
            { label: "Anguilla", value: "Anguilla" },
            { label: "Aruba", value: "Aruba" },
            { label: "Bahamas", value: "Bahamas" },
            { label: "Bonaire, Sint Eustatius and Saba", value: "Bonaire, Sint Eustatius and Saba" },
            { label: "Botswana", value: "Botswana" },
            { label: "Bouvet Island", value: "Bouvet Island" },
            { label: "Brazil", value: "Brazil" },
            { label: "British Indian Ocean Territory", value: "British Indian Ocean Territory" },
            { label: "Cayman Islands", value: "Cayman Islands" },
            { label: "Christmas Island", value: "Christmas Island" },
            { label: "Cocos (Keeling) Islands", value: "Cocos (Keeling) Islands" },
            { label: "Colombia", value: "Colombia" },
            { label: "Cook Islands", value: "Cook Islands" },
            { label: "Curacao", value: "Curacao" },
            { label: "Cuyprus", value: "Cuyprus" },
            { label: "Estonia", value: "Estonia" },
            { label: "Eswatini", value: "Eswatini" },
            { label: "Falkland Islands (Malvinas)", value: "Falkland Islands (Malvinas)" },
            { label: "Faroe", value: "Faroe" },
            { label: "French Guiana", value: "French Guiana" },
            { label: "French Polynesia", value: "French Polynesia" },
            { label: "French Southern Territories", value: "French Southern Territories" },
            { label: "Gibraltar", value: "Gibraltar" },
            { label: "Greenland", value: "Greenland" },
            { label: "Guadeloupe", value: "Guadeloupe" },
            { label: "Guam", value: "Guam" },
            { label: "Guernsey", value: "Guernsey" },
            { label: "Heard Island and McDonald Islands", value: "Heard Island and McDonald Islands" },
            { label: "Hungary", value: "Hungary" },
            { label: "Iceland", value: "Iceland" },
            { label: "India", value: "India" },
            { label: "Indonesia", value: "Indonesia" },
            { label: "Isle of Man", value: "Isle of Man" },
            { label: "Israel", value: "Israel" },
            { label: "Jersey", value: "Jersey" },
            { label: "Latvia", value: "Latvia" },
            { label: "Lithuania", value: "Lithuania" },
            { label: "Malaysia", value: "Malaysia" },
            { label: "Malta", value: "Malta" },
            { label: "Martinique", value: "Martinique" },
            { label: "Mauritius", value: "Mauritius" },
            { label: "Mayotee", value: "Mayotee" },
            { label: "Mexico", value: "Mexico" },
            { label: "Monaco", value: "Monaco" },
            { label: "Montserrat", value: "Montserrat" },
            { label: "Morocco", value: "Morocco" },
            { label: "Namibia", value: "Namibia" },
            { label: "New Caledonia", value: "New Caledonia" },
            { label: "Niue", value: "Niue" },
            { label: "Norflol Island", value: "Norflol Island" },
            { label: "Northern Mariana Islands", value: "Northern Mariana Islands" },
            { label: "Panama", value: "Panama" },
            { label: "Peru", value: "Peru" },
            { label: "Philippines", value: "Philippines" },
            { label: "Pitcairn", value: "Pitcairn" },
            { label: "Poland", value: "Poland" },
            { label: "Puerto Rico", value: "Puerto Rico" },
            { label: "Reunion", value: "Reunion" },
            { label: "Romania", value: "Romania" },
            { label: "Russian Federation", value: "Russian Federation" },
            { label: "Saint Barthelemy", value: "Saint Barthelemy" },
            { label: "Saint Helena, Ascension and Tristan Da Cunha", value: "Saint Helena, Ascension and Tristan Da Cunha" },
            { label: "Saint Pierre and Miquelon", value: "Saint Pierre and Miquelon" },
            { label: "Sint Maarten (Dutch Part)", value: "Sint Maarten (Dutch Part)" },
            { label: "Slovakia", value: "Slovakia" },
            { label: "Slovenia", value: "Slovenia" },
            { label: "South Africa", value: "South Africa" },
            { label: "South Georgia and the South Sandwich Islands", value: "South Georgia and the South Sandwich Islands" },
            { label: "Svalbard and Jan Mayen", value: "Svalbard and Jan Mayen" },
            { label: "Thailand", value: "Thailand" },
            { label: "Tokelau", value: "Tokelau" },
            { label: "Trinidad and Tobago", value: "Trinidad and Tobago" },
            { label: "Turks and Caicas Islands", value: "Turks and Caicas Islands" },
            { label: "Uruguay", value: "Uruguay" },
            { label: "Virgin Islands, British", value: "Virgin Islands, British" },
            { label: "Virgin Islands, U.S.", value: "Virgin Islands, U.S." },
            { label: "Wallis and Futuna", value: "Wallis and Futuna" },
            { label: "Algeria", value: "Algeria" },
            { label: "Angola", value: "Angola" },
            { label: "Argentina", value: "Argentina" },
            { label: "Azerbaijan", value: "Azerbaijan" },
            { label: "Bahrain", value: "Bahrain" },
            { label: "Bangladesh", value: "Bangladesh" },
            { label: "Barbodas", value: "Barbodas" },
            { label: "Benin", value: "Benin" },
            { label: "Bhutan", value: "Bhutan" },
            { label: "Bolivia (Plurinational State of)", value: "Bolivia (Plurinational State of)" },
            { label: "Bulgaria", value: "Bulgaria" },
            { label: "Burkina Faso", value: "Burkina Faso" },
            { label: "Cabo Verde", value: "Cabo Verde" },
            { label: "Cameroon", value: "Cameroon" },
            { label: "Comoros", value: "Comoros" },
            { label: "Costa Rica", value: "Costa Rica" },
            { label: "Croatia", value: "Croatia" },
            { label: "Djibouti", value: "Djibouti" },
            { label: "Dominica", value: "Dominica" },
            { label: "Dominican Republic", value: "Dominican Republic" },
            { label: "Ecuador", value: "Ecuador" },
            { label: "Egypt", value: "Egypt" },
            { label: "El Salvador", value: "El Salvador" },
            { label: "Equatorial Guinea", value: "Equatorial Guinea" },
            { label: "Ethiopia", value: "Ethiopia" },
            { label: "Fiji", value: "Fiji" },
            { label: "Ghana", value: "Ghana" },
            { label: "Greece", value: "Greece" },
            { label: "Guatemala", value: "Guatemala" },
            { label: "Honduras", value: "Honduras" },
            { label: "Iran, Islamic Republic of", value: "Iran, Islamic Republic of" },
            { label: "Jamaica", value: "Jamaica" },
            { label: "Jordan", value: "Jordan" },
            { label: "Kazakhstan", value: "Kazakhstan" },
            { label: "Kenya", value: "Kenya" },
            { label: "Lao People's Democratic Repubic", value: "Lao People's Democratic Repubic" },
            { label: "Lesotho", value: "Lesotho" },
            { label: "Maldives", value: "Maldives" },
            { label: "Mali", value: "Mali" },
            { label: "Manogolia", value: "Manogolia" },
            { label: "Myanmar", value: "Myanmar" },
            { label: "Nepal", value: "Nepal" },
            { label: "Niger", value: "Niger" },
            { label: "Nigeria", value: "Nigeria" },
            { label: "Pakistan", value: "Pakistan" },
            { label: "Papua New Guinea", value: "Papua New Guinea" },
            { label: "Paraguay", value: "Paraguay" },
            { label: "Saint Lucia", value: "Saint Lucia" },
            { label: "Saint Vincent and the Grenadines", value: "Saint Vincent and the Grenadines" },
            { label: "Samoa", value: "Samoa" },
            { label: "Sao Tome and Principe", value: "Sao Tome and Principe" },
            { label: "Serbia", value: "Serbia" },
            { label: "Senegal", value: "Senegal" },
            { label: "Seychelles", value: "Seychelles" },
            { label: "Solomon Islands", value: "Solomon Islands" },
            { label: "Srilanka", value: "Srilanka" },
            { label: "Suriname", value: "Suriname" },
            { label: "Togo", value: "Togo" },
            { label: "Tonga", value: "Tonga" },
            { label: "Tunisia", value: "Tunisia" },
            { label: "Turkey", value: "Turkey" },
            { label: "Vanuatu", value: "Vanuatu" },
            { label: "Vietnam", value: "Vietnam" },

        ].sort((a, b) => a.value.localeCompare(b.value))
    }
}