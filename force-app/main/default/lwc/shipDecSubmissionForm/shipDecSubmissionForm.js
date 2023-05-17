import { LightningElement ,  track , wire, api} from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import current_user from '@salesforce/user/Id';
import getPolicyHolderData from '@salesforce/apex/PolicyManagement.getPolicyHolderData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import USERNAME_FIELD from '@salesforce/schema/User.Username';
import { getRecord } from 'lightning/uiRecordApi';
import getBuyerInformation from '@salesforce/apex/ShipmentDeclaration.getBuyerInformation';
import createShipmentDecalaration from '@salesforce/apex/ShipmentDeclaration.createShipmentDecalaration';
import SHIPMENT_DECLARATION from '@salesforce/schema/Shipment_Declaration__c';
import PAYMENT_TERM_TYPE from '@salesforce/schema/Shipment_Declaration__c.Payment_Term_Type__c';
import ENDORSEMENT from '@salesforce/schema/Shipment_Declaration__c.Endorsement__c';
import SHIPMENT_MONTH from '@salesforce/schema/Shipment_Declaration__c.Shipment_Month__c';
import SHIPMENT_YEAR from '@salesforce/schema/Shipment_Declaration__c.Shipment_Year__c';

import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import addJustInvoice from '@salesforce/apex/ShipmentDeclaration.addJustInvoice';
import fetchShipDecById from '@salesforce/apex/ShipmentDeclaration.fetchShipDecById';
import updateShipmentDecalaration from '@salesforce/apex/ShipmentDeclaration.updateShipmentDecalaration';
import validateShipmentDate from '@salesforce/apex/ShipmentDeclaration.validateShipmentDate';
import getEcicSettings from '@salesforce/apex/ShipmentDeclaration.getEcicSettings';
import adjustInvoiceDate from '@salesforce/apex/ShipmentDeclaration.adjustInvoiceDate';

import Declaration_Submission from '@salesforce/label/c.Declaration_Submission';
import Company_Name from '@salesforce/label/c.Company_Name';
import Policy_Number from '@salesforce/label/c.Policy_Number';
import Policy_Type from '@salesforce/label/c.Policy_Type';
import By_Batch from '@salesforce/label/c.By_Batch';
import Mandatory_field from '@salesforce/label/c.Mandatory_field';
import Buyer_Name from '@salesforce/label/c.Buyer_Name';
import Buyer_Code from '@salesforce/label/c.Buyer_Code';
import Shipment_Declaration_Type from '@salesforce/label/c.Shipment_Declaration_Type';
import Pre_Shipment_Declaration from '@salesforce/label/c.Pre_Shipment_Declaration';
import Contractual_party_is_overseas_subsidiary from '@salesforce/label/c.Contractual_party_is_overseas_subsidiary';
import Yes from '@salesforce/label/c.Yes';
import No from '@salesforce/label/c.No';
import Endorsement from '@salesforce/label/c.Endorsement';
import Currency from '@salesforce/label/c.Currency';
import Gross_Invoice_Value_Amount from '@salesforce/label/c.Gross_Invoice_Value_Amount';
import Payment_Terms from '@salesforce/label/c.Payment_Terms';
import DP from '@salesforce/label/c.DP';
import DA from '@salesforce/label/c.DA';
import OA from '@salesforce/label/c.OA';
import Invoice_Due_Date from '@salesforce/label/c.Invoice_Due_Date';
import Port_of_Loading_Ship_From from '@salesforce/label/c.Port_of_Loading_Ship_From';
import Country_of_Origin from '@salesforce/label/c.Country_of_Origin';
import Destination_Country_Market_Ship_to from '@salesforce/label/c.Destination_Country_Market_Ship_to';
import Harmonized_Code from '@salesforce/label/c.Harmonized_Code';
import Search_Harmonized_Code_link from '@salesforce/label/c.Search_Harmonized_Code_link';
import Policyholder_s_Reference_No_if_any from '@salesforce/label/c.Policyholder_s_Reference_No_if_any';
import Late_declaration from '@salesforce/label/c.Late_declaration';
import Not_Overdue_Shipment from '@salesforce/label/c.Not_Overdue_Shipment';
import No_overdue_payment from '@salesforce/label/c.No_overdue_payment';
import No_adverse_info from '@salesforce/label/c.No_adverse_info';
import Others_Please_specify from '@salesforce/label/c.Others_Please_specify';
import Note from '@salesforce/label/c.Note';
import PH_declarations from '@salesforce/label/c.PH_declarations';
import Contract_Date from '@salesforce/label/c.Contract_Date';
import Amend_Declaration from '@salesforce/label/c.Amend_Declaration';
import getWrapperPolicyHolderData from '@salesforce/apex/PolicyManagement.getWrapperPolicyHolderData';
import getProductDetails from '@salesforce/apex/PolicyManagement.getProductDetails';
import CONTRACTUAL_SELLER from '@salesforce/schema/Shipment_Declaration__c.Who_is_the_contractual_seller__c';
import getAllEndorsements from '@salesforce/apex/ShipmentDeclaration.fetchAllEndorsements';







export default class ShipDecSubmissionForm extends LightningElement {

    @track label = {
        Declaration_Submission,Company_Name,Policy_Number,Policy_Type,By_Batch,Mandatory_field,Buyer_Name,
        Buyer_Code,Shipment_Declaration_Type,Pre_Shipment_Declaration,Contractual_party_is_overseas_subsidiary,
        Yes,No,Endorsement,Currency,Gross_Invoice_Value_Amount,Payment_Terms,DP,DA,OA,Invoice_Due_Date,
        Port_of_Loading_Ship_From,Country_of_Origin,Destination_Country_Market_Ship_to,Harmonized_Code,
        Search_Harmonized_Code_link,Policyholder_s_Reference_No_if_any,Late_declaration,Not_Overdue_Shipment,
        No_overdue_payment,No_adverse_info,Others_Please_specify,Note,PH_declarations,Contract_Date,
        Amend_Declaration

    }

    @track userId = current_user;
    @track companyName;
    @track logged_in_user;
    @track isByEntryBtnDisabled = false;
    @track isByBatchBtnDisabled = true;
    @track isRequiredTrue=true;
    @track endorsementValue;
    @track buyerName = '';
    @track buyerCode = '';
    @track isLoading;
    @track harmonizeCode = '';
    @track paymentTermType = '';
    @track refNo = '';
    @track destinationMarket = '';
    @track portOfLoading = '';
    @track showLateDeclaration=false;
    @track preShipYes = false;
    @track preShipNo = false;
    @track givValue;
    @track shipTo;
    @track shipFrom;
    @api shipmentId;
    @track isShowShipDecSubmissionForm;
    @track isShowShipDecRecordScreen;
    @track lateDecOtherReason='';
    @track contactualSellerOptions;
    @track contractualSeller;
    @wire(getObjectInfo, { objectApiName: SHIPMENT_DECLARATION })
    objectInfo;
    @track paymentTermTypeOptions;

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: PAYMENT_TERM_TYPE})
    PaymentMethodPicklistValues({ data, error }) {
        if (data) this.paymentTermTypeOptions = data.values;
    }

    @track endorsementAllList;
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: ENDORSEMENT})
    EndorsementPicklistValues({ data, error }) {
        if (data) this.endorsementAllList = data.values;
    }

    @track shipmentMonthList;
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: SHIPMENT_MONTH})
    ShipmentMonthListPicklistValues({ data, error }) {
        if (data) this.shipmentMonthList = data.values;
    }

    @track shipmentYearList;
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: SHIPMENT_YEAR})
    ShipmentYearListPicklistValues({ data, error }) {
        if (data) this.shipmentYearList = data.values;
    }

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: CONTRACTUAL_SELLER})
    ContractualSellerPicklistValues({ data, error }) {
        console.log('data ::'+data);
        if (data) this.contactualSellerOptions = data.values;
    }

    @wire(getRecord, { recordId: current_user,fields: [USERNAME_FIELD]}) 
    wireuser({error,data}) {
        if (error) {
           this.error = error ; 
           //this.name='alice.zzzz@ignatica.io';
        } else if (data) {
            console.log('data.fields : '+JSON.stringify(data.fields));
            this.logged_in_user = data.fields.Username.value;
        }
    }


    @track policyNumber;
    @track Countrylist1 = [
        { value: 'India', label: 'India' },
        { value: 'China', label: 'China' },
        { value: 'Japan', label: 'Japan' },
    ];
    @track CurrencyList = [
        
        { value: 'AUD', label: 'AUD' },
        { value: 'CAD', label: 'CAD' },
        { value: 'CHF', label: 'CHF' },
        { value: 'DEM', label: 'DEM' },
        { value: 'EUR', label: 'EUR' },
        { value: 'GBP', label: 'GBP' },
        { value: 'JPY', label: 'JPY' },
        { value: 'NZD', label: 'NZD' },

        { value: 'SGD', label: 'SGD' },
        { value: 'USD', label: 'USD' },
        { value: 'ATS', label: 'ATS' },
        { value: 'BEF', label: 'BEF' },
        { value: 'EUR', label: 'EUR' },
        { value: 'GBP', label: 'GBP' },
        { value: 'CNY', label: 'CNY' },
        { value: 'DKK', label: 'DKK' },

        { value: 'IEP', label: 'IEP' },
        { value: 'NLG', label: 'NLG' },
        { value: 'NOK', label: 'NOK' },
        { value: 'SEK', label: 'SEK' },
        { value: 'TWD', label: 'TWD' },
        { value: 'ZAR', label: 'FIM' },
        { value: 'PTE', label: 'PTE' },
        { value: 'HKD', label: 'HKD' },
    ];
    @track currencyList = ["AUD", "CAD", "CHF", "DEM", "EUR", "GBP", "JPY", "NZD", "SGD", "USD", "ATS", "BEF", "CNY", "DKK", "IEP", "NLG", "NOK", "SEK", "TWD", "ZAR", "FIM", "PTE", "HKD", "ECU", "MYR", "ALL", "DZD", "AMD", "BSD", "BHD", "BDT", "BBD", "BZD", "XOF", "BMD", "BTN", "BOB", "BWP", "BRL", "BND", "BIF", "XAF", "CVE", "KYD", "CLP", "COP", "KMF", "CRC", "HRK", "CUP", "CZK", "DJF", "XCD", "DOP", "ECS", "EGP", "SVC", "ETB", "FKP", "FJD", "XPF", "GMD", "GIP", "GRD", "GTQ", "GNF", "GYD", "HTG", "HNL", "HUF", "ISK", "INR", "IDR", "IRR", "IQD", "ILS", "JMD", "JOD", "KHR", "KZT", "KES", "KRW", "KWD", "LAK", "LBP", "LSL", "LRD", "LYD", "LTL", "LUF", "MOP", "MKD", "MWK", "MVR", "MRU", "MUR", "MDL", "MNT", "MAD", "MMK", "NPR", "ANG", "NGN", "KPW", "OMR", "PKR", "PAB", "PGK", "PYG", "PEN", "PHP", "PLN", "QAR", "RON", "RWF", "STN", "SAR", "SCR", "SLL", "SIT", "SBD", "SOS", "LKR", "SHP", "SZL", "SYP", "TZS", "THB", "TOP", "TTD", "TND", "TRL", "UGX", "AED", "UYW", "UZS", "VUV", "VES", "VND", "WST", "YER", "YUN", "CDF", "KGS", "NAD", "GEL", "ROL", "BAM", "AWG", "AFN", "AOA", "ARS", "AZN", "BGN", "BYN", "ERN", "GHS", "MGA", "MXN", "MZN", "NIO", "RSD", "RUB", "SDG", "SRD", "TJS", "TMT", "TRY", "UAH", "ZMW", "ZWL", "SSP"]
    @track currencyOptions = this.currencyList.map(el => ({ label: el, value: el }))
    @track Payment_terms = [
        { value: 'DP', label: this.label.DP },
        { value: 'DA', label: this.label.DA },
        { value: 'OA', label: this.label.OA },
    ];
    @track shipmentTypeList = [
        { value: 'Individual', label: 'Individual' },
        { value: 'Monthly lump sum', label: 'Monthly lump sum' }
    ];
    @track endorsementList=[]; //= ["EN21 Hand-Carriage of Goods Endorsement", "EN48A Extended Cover for Pre-shipment Risks Endorsement", "EN49A Pre-Shipment Endorsement", "EN67 Sales By Overseas Subsidiary Company (Sales In Subsidiary Country / Market) Endorsement", "EN68 Sales By Overseas Subsidiary Company (Sales In Subsidiary Country / Market) Endorsement", "EN69 Sales By Overseas Subsidiary Company (Sales Over The Border) Endorsement", "EN70 Sales By Overseas Subsidiary Company (Sales Over The Border) Endorsement", "EN84 Sales By Overseas Subsidiary Company (Sales In Subsidiary Country / Market) Endorsement", "EN85 Sales By Overseas Subsidiary Company (Sales In Subsidiary Country / Market) Endorsement", "EN86 Sales By Overseas Subsidiary Company (Sales Over The Border) Endorsement", "EN87 Sales By Overseas Subsidiary Company (Sales Over The Border) Endorsement"]
    @track edorsementOptions; //= this.endorsementList.map(el => ({ label: el, value: el }))
    @track policyID;
    @track paymentTermDay;
    @track invoiceDate;
    @track shipmentType;
    @track shipOverSubYes = false;
    @track shipOverSubNo;
    @track shipmentDate;
    @track contractDate;
    @track ecic_currency;
    @track countryOfOrigin;
    @track isAmendForm=false;
    @track isShowAmendReasonScreen=false;
    @track cancelConfirmationScreen=false;
    @track isShowMonthlyLumpSum=false;
    @track ReasonForAmendment;
    @track ReasonForAmendmentMsg;
    @track isShowBulkScreen=false;
    @track shipmeDateLabel='Shipment Date';
    @track isShipmentMonth=false;
    @track policyType;
    @track shipmentMonthValue;
    @track shipmentYearValue;

    @track isLimitedAccess;
    @track limitedAccessDate;
    @track isLimitedAccessWithinSixMonth;
    @track policyStatus;
    @track isPolicyValid;
    @track isPolTerminationWithinSixMonth;

    @track isProductOMBP;
    @track isProductSBP;
    @track isProductSUP;
    @track defaultPaymentTermType;
    @track defaultPaymentTermDays;
    @track isCheckMaxTenure;
    @track isClientRelatedToEN68;

    connectedCallback(){
        console.log('shipmentId : '+this.shipmentId);
        if(this.shipmentId){
            this.isAmendForm=true;
            this.fetchShipDecRecords();
            this.isShowAmendReasonScreen=true;
        }
        console.log('isAmendForm : '+this.isAmendForm);
        this.isLoading = true;
        this.getPolicyHolderData();
        this.getModifiedPolicyHolderData();
        this.getEcicConfig();
        this.getProductDetailsJS();

        this.isLoading = false;
        this.isShowShipDecSubmissionForm = true;
        this.isCheckMaxTenure=false;
        this.isProductSBP=false;
        this.isProductSUP=false;
        this.isProductOMBP=false;
        this.getAllEndorsements();
    }
    getAllEndorsements(){
        console.log('getAllEndorsements ==>>'+this.userId);
        getAllEndorsements({
            userId : this.userId
        }).then(data => {
            console.log(' fetchAllEndorsements success :'+JSON.stringify(data));
            try {
                if(data){
                    for(let en in data){
                        //this.endorsementList.push(data[en].Type__c);
                        console.log('data[en].Type__c ::'+data[en].Type__c);
                        this.endorsementList = [...this.endorsementList, data[en].Type__c];

                    }

                    //this.endorsementList = data;
                    console.log('endorsementList X===>>'+JSON.stringify(this.endorsementList));
                    this.edorsementOptions = this.endorsementList.map(el => ({ label: el, value: el }));
                    console.log('edorsementOptions X===>>'+JSON.stringify(this.edorsementOptions));
                }
           } catch (error) {
               console.log('1 error.toString() '+error.toString()+' '+JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while fetching Endorsement',
                        message: error.body.message,
                        mode : 'sticky',
                        variant: 'warning'
                    })
                );
            }
        }).catch(error => {
            console.log('2 error.toString() '+error.toString()+' '+JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while fetching Endorsement data',
                    message: error.body.message,
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
    getProductDetailsJS(){
        console.log('getProductDetailsJS called.');
        getProductDetails({
            usrId : this.userId
        }).then(data => {
            console.log('getProductDetails success :'+JSON.stringify(data));
            try {
                if (data){
                    if(data.Default_Payment_Term_Type__c){
                        if(data.Default_Payment_Term_Type__c === 'DP'){
                            this.Payment_terms = [
                                { value: 'DP', label: this.label.DP },
                            ];
                        }else if(data.Default_Payment_Term_Type__c === 'DA'){
                            this.Payment_terms = [
                                { value: 'DA', label: this.label.DA },
                            ];
                        }else if(data.Default_Payment_Term_Type__c === 'OA'){
                            this.Payment_terms = [
                                { value: 'OA', label: this.label.OA },
                            ];
                        }
                    }
                    if(data.Default_Payment_Term_Days__c){
                        this.defaultPaymentTermDays=data.Default_Payment_Term_Days__c;
                        this.isCheckMaxTenure = true;
                    }
                }
                
             } catch (error) {
               console.log(error.body.message,' ',JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while loading Product Configuration',
                        message: error.body.message,
                        mode : 'sticky',
                        variant: 'error'
                    })
                );
            }
            
        }).catch(error => {
            console.log('==>>',error.body.message,'<<==>> ',JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while loading Product Configurations',
                    message: error.body.message,
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
    getEcicConfig(){
        console.log('getECICSettings called.');
        getEcicSettings({
            msg : 'msg'
        }).then(data => {
            console.log('getECICSettings success :'+JSON.stringify(data));
            try {
                if (data){
                    this.isShowMonthlyLumpSum = data.Enable_Monthy_Lump_Sum__c;
                    if (!this.isShowMonthlyLumpSum){
                        this.shipmentTypeList = [
                            { value: 'Individual', label: 'Individual' }
                        ];
                    }
                }
                
             } catch (error) {
               
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while loading ECIC Settings',
                        message: error.body.message,
                        mode : 'sticky',
                        variant: 'warning'
                    })
                );
            }
            
        }).catch(error => {
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while loading ECIC Settings',
                    message: error.body.message,
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
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
            { label: "Falkland Island (Malvinas)", value: "Falkland Island (Malvinas)" },
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
    getPolicyHolderData(){
        console.log('getPolicyHolderData called.');
        getPolicyHolderData({
            usrId : this.userId
        }).then(data => {
            console.log('getPolicyHolderData success :'+JSON.stringify(data));
            try {
                this.companyName = data.Name;
                this.policyNumber = data.Current_Policy__r.Name;
                this.policyID = data.Current_Policy__c;
                this.policyType = data.Current_Policy__r.Product__r.Name;
                if(this.policyType === 'OMBP'){
                    this.isProductOMBP = true;
                }else if(this.policyType === 'SBP'){
                    this.isProductSBP = true;
                }else if(this.policyType === 'SUP'){
                    this.isProductSUP= true;
                }
             } catch (error) {
               
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while fetching User data',
                        message: error.toString(),
                        mode : 'sticky',
                        variant: 'warning'
                    })
                );
            }
            
        }).catch(error => {
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while fetching User data',
                    message: error.toString(),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
    getModifiedPolicyHolderData(){
        console.log('getWrapperPolicyHolderData called.');
        getWrapperPolicyHolderData({
            usrId : this.userId
        }).then(data => {
            console.log('getWrapperPolicyHolderData success :'+JSON.stringify(data));
            try {
                
               
               this.isLimitedAccess = data.isLimitedAccess;
               this.limitedAccessDate = data.limitedAccessDate;
               this.isLimitedAccessWithinSixMonth = data.isLimitedAccessWithinSixMonth;
               this.policyStatus = data.policyStatus;
               this.isPolicyValid = (data.policyStatus == 'Valid')? true:false; 
               this.isPolTerminationWithinSixMonth = data.isPolTerminationWithinSixMonth;


                
            } catch (error) {
               console.error(error.toString()+' '+JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while fetching User data',
                        message: error.toString()+' '+JSON.stringify(error),
                        mode : 'sticky',
                        variant: 'warning'
                    })
                );
            }
            
        }).catch(error => {
            console.error(error.toString()+' '+JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while fetching User data.',
                    message: error.toString()+' '+JSON.stringify(error),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
    fetchShipDecRecords(){
        console.log('fetchShipDecById caed');
        this.isLoading = true;
        fetchShipDecById({
            shipmentId : this.shipmentId
        }).then(response => {
            console.log('fetchShipDecById success :'+JSON.stringify(response));
            if(response){
               
                this.allShipDecRecords = response;
                this.buyerName = response[0].buyerName;
                this.buyerCode = response[0].buyerCode;
                this.shipmentType = response[0].shipmentType;
                if(this.shipmentType === 'Monthly lump sum'){
                    this.isShipmentMonth = true;
                    this.shipmeDateLabel = 'Shipment Date';
                }
                if(response[0].preShipmentDeclaration){
                    this.preShipYes = true;
                    this.preShipNo = !this.preShipYes;
                }else{
                    this.preShipNo = true;
                    this.preShipYes = !this.preShipNo;
                }
                //this.shipOverSubYes = response[0].buyerName;
                //this.shipOverSubno = response[0].buyerName;
                this.endorsementValue = response[0].endorsement;

                this.shipmentDate = response[0].shipMentDate;
                //this.contractDate = response[0].buyerName;
                this.ecic_currency = response[0].ecicCurrency;
                this.givValue = response[0].grossInvoiceValue;
                this.paymentTermType = response[0].paymentTerm;
                this.paymentTermDay = response[0].paymentTermDay;
                this.invoiceDate = response[0].invoiceDate;
                this.shipFrom = response[0].portOfLoading;
                this.countryOfOrigin = response[0].countryOrigin;
                this.shipTo = response[0].destinationCountry;
                this.harmonizeCode = response[0].harmonizedCode;
                this.refNo = response[0].phRefNo;
                this.shipmentMonthValue = response[0].shipmentMonth;
                this.shipmentYearValue = response[0].shipmentYearValue;
            }
            this.isLoading = false;
            
        }).catch(error => {
            console.log('fetchShipDecRecords error :'+JSON.stringify(error));
            this.isLoading = false;
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Occurred',
                    message: error.toString(),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
    handleKeyUp(evt) {
        console.log('handleKeyUp : '+evt.keyCode);
        const isEnterKey = evt.keyCode === 13;
        if (isEnterKey) {
            this.searchBuyer(evt);
        }
    }
    searchBuyer(event){
        this.isLoading = true;
        console.log('searchBuyer tar name : '+event.target.name+' value : '+event.target.value);
        if(event.target.name === 'buyerName'){
            this.buyerName = event.target.value;
        }else if(event.target.name === 'buyerCode'){
            this.buyerCode = event.target.value;
        }
        if(event.target.name === 'buyerName' || event.target.name === 'buyerCode'){
            if (event.target.value != '' ){
                console.log('getBuyerInformation called.');
                getBuyerInformation({
                    usrId : this.userId,
                    buyerName : this.buyerName,
                    buyerCode : this.buyerCode
                }).then(data => {
                    console.log('getBuyerInformation success :'+JSON.stringify(data));
                    try {
                        if(data.isSuccess){
                            console.log('Success ');
                            this.buyerName = data.buyerName;
                            this.buyerCode = data.buyerCode;
                            this.isClientRelatedToEN68 = data.isClientRelatedToEN68;
                            //this.policyID = data.policyID;
                            console.log('this.policyID ::'+this.policyID);
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Buyer Exist',
                                    message: 'Found a buyer with name : '+data.buyerName+ ' and Code : '+data.buyerCode,
                                    variant: 'success'
                                })
                            );
                        }else{
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Error',
                                    message: 'You have no valid credit limit or outstanding credit limit application on this buyer. Please submit a credit limit application. ',
                                    variant: 'error'
                                })
                            );
                        }
                    } catch (error) {
                        console.log('Error 1 '+error.toString()+' '+JSON.stringify(error));
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Exception occurred while fetching buyer information.',
                                message: error.body.message,
                                mode : 'sticky',
                                variant: 'warning'
                            })
                        );
                    }
                }).catch(error => {
                    console.log('Error 2 '+error.toString()+' Error 2 '+JSON.stringify(error));
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Exception occurred while fetching buyer information.',
                            message: error.body.message,
                            mode : 'sticky',
                            variant: 'error'
                        })
                    );
                });
            }
        }
        this.isLoading = false;
    }

    checkPreShipDec(event){
        console.log('checkPreShipDec tar name : '+event.target.name); 
        console.log('checkPreShipDec tar checked '+event.target.checked);
        if(event.target.name === 'preShipYes'){
            this.preShipYes = event.target.checked;
            if(this.preShipYes){
                this.preShipNo = false;
            }
            
        }else if(event.target.name === 'preShipNo'){
            this.preShipNo = event.target.checked;
            if(this.preShipNo){
                this.preShipYes = false;
            }
        }
    }
    get endorsementList() {
        return [
            { label: 'New', value: 'new' },
            { label: 'In Progress', value: 'inProgress' },
            { label: 'Finished', value: 'finished' },
        ];
    }
    handleEndorsement(){
        
    }
    /*handleContractDate(event){
        console.log('handleContractDate tar1 name : '+event.target.name+' '+event.target.value);
        this.showLateDeclaration=true;
    }*/
    /*handlePaymentTermDay(event){
        console.log('handlePaymentTermDay tar name : '+event.target.name+' '+event.target.value);
        this.paymentTermDay = event.target.value;
        this.adjustInvoiceDate();
        addJustInvoice({
            addToInvoiceDate : event.target.value
        }).then(data => {
            console.log('handlePaymentTermDay success :'+JSON.stringify(data));
            try {
                this.invoiceDate = data;
             } catch (error) {
               
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while adding date to Invoice',
                        message: error.toString(),
                        mode : 'sticky',
                        variant: 'warning'
                    })
                );
            }
            //this.adjustInvoiceDate();
        }).catch(error => {
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while adding date to Invoice',
                    message: error.toString(),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }*/
   
    handleShipping(event){
        console.log('handleShipping tar name : '+event.target.name+' '+event.target.value);
        if(event.target.name === 'shipFrom'){
            if (this.shipTo === 'event.target.value'){
               
            }
        }else if(event.target.name === 'shipTo'){
            if (this.shipTo === 'event.target.value'){

            }
        }
    }
    handleShipDecType(event){
        console.log('handleShipDec tar name : '+event.target.name+' vaue : '+event.target.value);
        this.shipmentType = event.target.value;
        if(this.shipmentType === 'Monthly lump sum'){
            this.shipmeDateLabel='Shipment Month';
            this.isShipmentMonth=true;
        }else{
            this.shipmeDateLabel='Shipment Date';
            this.isShipmentMonth=false;
        }
    }

    handleContractDate(event){
        console.log('handleContractDate tar name : '+event.target.name+' vaue : '+event.target.value);

        this.contractDate = event.target.value;
    }
    handleCurrency(event){
        console.log('handleCurrency tar name : '+event.target.name+' vaue : '+event.target.value);
        this.ecic_currency = event.target.value;
    }
    handleGIV(event){
        console.log('handlePaymentTerm tar name : '+event.target.name+' vaue : '+event.target.value);
        this.givValue = event.target.value;
    }
    handlePaymentTerm(event){
        console.log('handlePaymentTerm tar name : '+event.target.name+' vaue : '+event.target.value);
        this.paymentTermType = event.target.value;
    }
    handleInvoiceDate(event){
        console.log('handleInvoiceDate tar name : '+event.target.name+' vaue : '+event.target.value);
        this.invoiceDate = event.target.value;
    }
    submitAmend(event){
        console.log('submitAmend tar val : '+event.target.value); 
        this.isShowAmendReasonScreen = false;
    }
    
    handleInputData(event){
        console.log('handleInputData tar name : '+event.target.name+' vaue : '+event.target.value);
        if(event.target.name === 'shipFrom'){
            this.shipFrom = event.target.value;

        }if(event.target.name === 'endorsement'){
            console.log('Name : '+event.target.name+' value:'+event.target.value);
            this.endorsementValue = event.target.value;

        }else if(event.target.name === 'countryOfOrigin'){
            this.countryOfOrigin = event.target.value;

        }else if(event.target.name === 'shipFrom'){
            this.shipFrom = event.target.value;

        }else if(event.target.name === 'shipTo'){
            this.shipTo = event.target.value;

        }else if(event.target.name === 'harmonizeCode'){
            this.harmonizeCode = event.target.value;

        }else if(event.target.name === 'refNo'){
            this.refNo = event.target.value;

        }else if(event.target.name === 'invoiceDate'){
            this.invoiceDate = event.target.value;

        }else if(event.target.name === 'paymentTermType'){
            this.paymentTermType = event.target.value;
            this.adjustInvoiceDate();

        }else if(event.target.name === 'paymentTermDay'){
            console.log('isCheckMaxTenure',this.isCheckMaxTenure,' paymentTermDayValue',event.target.value);
            let paymentTermDayValue = event.target.value;
            let paymentTermDay=this.template.querySelector(".paymentTermDay"); 

            if(this.isCheckMaxTenure){
                if(paymentTermDayValue > this.defaultPaymentTermDays){
                    paymentTermDay.setCustomValidity("Please enter valid tenor");
                    paymentTermDay.reportValidity();
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Cannot exceed more than default tenor',
                            message: 'The tenor cannot exceed the maximum tenor allowed that is '+this.defaultPaymentTermDays,
                            mode : 'sticky',
                            variant: 'error'
                        })
                    );
                }else{
                    paymentTermDay.setCustomValidity('');
                    paymentTermDay.reportValidity(); 
                    this.paymentTermDay = paymentTermDayValue;
                    this.adjustInvoiceDate();
                }
            }else{
                this.adjustInvoiceDate();
            }

        }else if(event.target.name === 'shipmentYear'){
            this.shipmentYearValue = event.target.value;
            

        }else if(event.target.name === 'shipmentMonth'){
            this.shipmentMonthValue = event.target.value;

        }else if(event.target.name === 'shipmentDate'){
            this.shipmentDate = event.target.value;
            validateShipmentDate({
                shipmentDate : this.shipmentDate
            }).then(data => {
                console.log('handleInputData shipmentDate success :'+JSON.stringify(data));
                try {
                    this.showLateDeclaration = !data;
                    this.adjustInvoiceDate();
                 } catch (error) {
                   this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Exception Occurred while validationg shipment date.',
                            message: error.body.message,
                            mode : 'sticky',
                            variant: 'warning'
                        })
                    );
                }
            }).catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while validationg shipment date.',
                        message:error.body.message,
                        mode : 'sticky',
                        variant: 'error'
                    })
                );
            });
            
        }else if(event.target.name === '1st'){
            this.lateDecOtherReason = 'The shipemnt involved has not become overdue and the buyer has not requested any extention or change of payment terms.';
        }else if(event.target.name === '2nd'){
            this.lateDecOtherReason = 'No overdue payment is heard about the buyer.';
        }else if(event.target.name === '3rd'){
            this.lateDecOtherReason = 'No advarse information is heard about the buyer.';
        }else if(event.target.name === 'others'){
            //this.lateDecOtherReason = '';
        }else if(event.target.name === 'endorsement'){
            //this.endorsementValue = '';
            console.log('this endorsementValue : '+this.endorsementValue);
        }else if(event.target.name === 'shipOverSubYes'){
            console.log('Name : '+event.target.name+' value:'+ event.target.value);
            this.shipOverSubYes = event.target.value;
        }else if(event.target.name === 'contractualSeller'){
            console.log('Name : '+event.target.name+' value:'+ event.target.value);
        }
    }
    
    adjustInvoiceDate(){
        console.log('adjustInvoiceDate Shipment Date: '+this.shipmentDate+' Payment Term '+this.paymentTermType+' Day'+this.paymentTermDay);
        if(this.shipmentDate){
            console.log('Found Shipment Date');
            if(typeof this.paymentTermType === 'undefined'){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Please provide the Payment Day.',
                        message: '',
                        variant: 'warning'
                    })
                );
            }else{
                console.log('Found Payment Term Type : '+this.paymentTermType);
                if(typeof this.paymentTermDay === 'undefined'){
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Please provide the Payment Day.',
                            message: '',
                            variant: 'warning'
                        })
                    );
                }else{
                    console.log('Found Payment Term Day : '+this.paymentTermDay);
                    adjustInvoiceDate({
                        shipmentDate : this.shipmentDate,
                        paymentTermType : this.paymentTermType,
                        paymentTermDay : this.paymentTermDay
                    }).then(data => {
                        console.log('handleInputData shipmentDate success :'+JSON.stringify(data));
                        try {
                            this.invoiceDate = data;
                         } catch (error) {
                           this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Exception Occurred while Adjusting Invoice Date.',
                                    message: error.body.message,
                                    mode : 'sticky',
                                    variant: 'warning'
                                })
                            );
                        }
                    }).catch(error => {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Exception Occurred while Adjusting Invoice Date.',
                                message: error.body.message,
                                mode : 'sticky',
                                variant: 'error'
                            })
                        );
                    });
                }
            }
        }
        console.log('invoiceDate : '+this.invoiceDate);
    }

    handleNext(){
        console.log('handleNext this.policyID ::',this.policyID,' isLimitedAccess :',this.isLimitedAccess,' isPolicyValid :',this.isPolicyValid+' isPolTerminationWithinSixMonth:',this.isPolTerminationWithinSixMonth,' isProductSBP',this.isProductSBP);
        if(!this.isLimitedAccess){
            if(this.isPolicyValid || (!this.isPolicyValid && this.isPolTerminationWithinSixMonth && this.isProductSBP)){
                console.log('Proceed to Submit Shipment Decalration');
                try {
                    const allValid = [...this.template.querySelectorAll('.validValue')]
                    .reduce((validSoFar, inputCmp) => {
                        inputCmp.reportValidity();
                        return validSoFar && inputCmp.checkValidity();
                    }, true);
                    if (allValid) {
                        console.log('allValid :'+allValid); 
                        this.handleCreateShipRecord();
                    }
                } catch (error) {
                    console.log('Exception at :'+error.toString+' '+JSON.stringify(error));
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Exception Occurred',
                            message: 'Message : '+error.toString,
                            mode : 'sticky',
                            variant: 'error'
                        })
                    );
                }
            }else {
                console.log('Policy is terminated.');
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Policy is terminated.',
                        message: 'Your policy is terminated. You are not allowed to perform this action.',
                        mode : 'sticky',
                        variant: 'error'
                    })
                );
            } 
            
        }else {
            console.log('Policy Holder account is deactivated.');
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Your have limited access.',
                    message: 'Your account is deactivated. You don\'t have access to perform this action.',
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        }   
       
    }
    handleCreateShipRecord(){
        this.isLoading = true;
        console.log('handleCreateShipRecord tar1 policyID : '+this.policyID+' destinationMarket :'+this.shipTo+' destinationMarket : '+this.destinationMarket+' portOfLoading:'+this.shipFrom+'shipmentMonthValue:'+this.shipmentMonthValue+' shipmentYearValue:'+this.shipmentYearValue);
        createShipmentDecalaration({
            policyID : this.policyID,
            buyerName : this.buyerName,
            buyerCode  : this.buyerCode,
            givValue : this.givValue,
            shipmentType : this.shipmentType,
            preShipYes : this.preShipYes,
            shipOverSubYes : this.shipOverSubYes,
            shipmentDate : this.shipmentDate,
            invoiceDate : this.invoiceDate,
            contractDate : this.contractDate,
            ecic_currency : this.ecic_currency,
            paymentTermType : this.paymentTermType,
            paymentTermDay : this.paymentTermDay,
            refNo : this.refNo,
            destinationMarket : this.shipTo,
            portOfLoading : this.shipFrom,
            countryOfOrigin : this.countryOfOrigin,
            harmonizeCode : this.harmonizeCode,
            lateDecOtherReason : this.lateDecOtherReason,
            endorsementValue : this.endorsementValue,
            shipmentMonthValue : this.shipmentMonthValue,
            shipmentYearValue : this.shipmentYearValue,
            contractualSeller : this.contractualSeller
            

        }).then(response => {
            console.log('handleCreateShipRecord success :'+JSON.stringify(response));
            if(response){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Shipment Declared Successfully',
                        message: 'Shipment Declared record created.',
                        mode : 'sticky',
                        variant: 'success'
                    })
                );
                this.isShowShipDecSubmissionForm = false;
                this.isShowShipDecRecordScreen = true;
            }
            this.isLoading = false;
            
            
        }).catch(error => {
            console.log('handleCreateShipRecord error :'+JSON.stringify(error));
            this.isLoading = false;
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Occurred',
                    message: error.body.message,
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
    handleUpdateShipRecord(){
        this.isLoading = true;
        console.log('ReasonForAmendmentMsg :'+this.ReasonForAmendmentMsg+' ReasonForAmendment :'+this.ReasonForAmendment);
        let reasonForAmend = this.ReasonForAmendmentMsg == 'Typing Mistake' ? this.ReasonForAmendmentMsg : this.ReasonForAmendment;
        console.log('handleCreateShipRecord tar1 policyID : '+this.policyID+' destinationMarket :'+this.shipTo+' destinationMarket : '+this.destinationMarket+' portOfLoading:'+this.shipFrom+'shipmentYearValue : '+this.shipmentYearValue);
        updateShipmentDecalaration({
            policyID : this.policyID,
            buyerName : this.buyerName,
            buyerCode  : this.buyerCode,
            givValue : this.givValue,
            shipmentType : this.shipmentType,
            preShipYes : this.preShipYes,
            shipOverSubYes : this.shipOverSubYes,
            shipmentDate : this.shipmentDate,
            invoiceDate : this.invoiceDate,
            contractDate : this.contractDate,
            ecic_currency : this.ecic_currency,
            paymentTermType : this.paymentTermType,
            paymentTermDay : this.paymentTermDay,
            refNo : this.refNo,
            destinationMarket : this.shipTo,
            portOfLoading : this.shipFrom,
            countryOfOrigin : this.countryOfOrigin,
            shipmentId : this.shipmentId,
            harmonizeCode : this.harmonizeCode,
            ReasonForAmendment : reasonForAmend,
            lateDecOtherReason : this.lateDecOtherReason,
            endorsementValue : this.endorsementValue,
            shipmentMonthValue : this.shipmentMonthValue,
            shipmentYearValue : this.shipmentYearValue,
            contractualSeller : this.contractualSeller
            

        }).then(response => {
            console.log('handleCreateShipRecord success :'+JSON.stringify(response));
            if(response){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Shipment Declared Updated Successfully',
                        message: 'Shipment Declared record Updated.',
                        mode : 'sticky',
                        variant: 'success'
                    })
                );
                this.isShowShipDecSubmissionForm = false;
                this.isShowShipDecRecordScreen = true;
            }
            this.isLoading = false;
            
            
        }).catch(error => {
            console.log('handleCreateShipRecord error :'+JSON.stringify(error));
            this.isLoading = false;
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Occurred',
                    message: error.toString(),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
    handleCheckboxChange(event){
        console.log('handleCheckboxChange tar name : '+event.target.name+' vaue : '+event.target.value);

    } 
    handleAmendReason(event){ 
        console.log('handleAmendReason tar name : '+event.target.name+' vaue : '+event.target.value);
        
         if(event.target.name === 'typingMistake'){
            this.ReasonForAmendmentMsg = 'Typing Mistake';

        }else if(event.target.name === 'userReason'){
            this.ReasonForAmendment = event.target.value;
        } 
        console.log('handleAmendReason ReasonForAmendment : '+this.ReasonForAmendment);

    }
    gotoBulkScreen(event){
        console.log('gotoBulkScreen :: ');
        this.isShowBulkScreen = true;
        this.isShowShipDecSubmissionForm = false;
        this.isShowShipDecRecordScreen = false;
    }
}