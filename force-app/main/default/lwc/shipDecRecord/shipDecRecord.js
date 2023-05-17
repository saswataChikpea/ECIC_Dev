import { LightningElement ,  track , wire, api} from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import current_user from '@salesforce/user/Id';
import getPolicyHolderData from '@salesforce/apex/PolicyManagement.getPolicyHolderData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import USERNAME_FIELD from '@salesforce/schema/User.Username';
import { getRecord } from 'lightning/uiRecordApi';
import getBuyerInformation from '@salesforce/apex/ShipmentDeclaration.getBuyerInformation';
import fetchAllShipDec from '@salesforce/apex/ShipmentDeclaration.fetchAllShipDec';
import getDeclaredBuyerInfo from '@salesforce/apex/ShipmentDeclaration.getDeclaredBuyerInfo';
import updateSettlement from '@salesforce/apex/ShipmentDeclaration.updateSettlement';
import fetchAllShipDecHistory from '@salesforce/apex/ShipmentDeclaration.fetchAllShipDecHistory';
import changeStatusForApproval from '@salesforce/apex/ShipmentDeclaration.changeStatusForApproval';

import Declaration_Record from '@salesforce/label/c.Declaration_Record';
import Company_Name from '@salesforce/label/c.Company_Name';
import Policy_Number from '@salesforce/label/c.Policy_Number';
import Policy_Type from '@salesforce/label/c.Policy_Type';
import Select_Buyer from '@salesforce/label/c.Select_Buyer';
import Search_Buyer_Name from '@salesforce/label/c.Search_Buyer_Name';
import Declaration_Received_Date from '@salesforce/label/c.Declaration_Received_Date';
import Reset from '@salesforce/label/c.Reset';
import Search from '@salesforce/label/c.Search';
import Sort_ascending from '@salesforce/label/c.Sort_ascending';
import Sort_descending from '@salesforce/label/c.Sort_descending';
import Declaration_Receive_Date from '@salesforce/label/c.Declaration_Receive_Date';
import Pre_Shipment_Declaration_Yes_No from '@salesforce/label/c.Pre_Shipment_Declaration_Yes_No';
import Premium_HKD from '@salesforce/label/c.Premium_HKD';
import Due_Date from '@salesforce/label/c.Due_Date';
import Endorsement from '@salesforce/label/c.Endorsement';
import Shipment_was_made_by_an_overseas_subsidiary from '@salesforce/label/c.Shipment_was_made_by_an_overseas_subsidiary';
import Harmonized_Code from '@salesforce/label/c.Harmonized_Code';
import EC_Reach_Reference_No from '@salesforce/label/c.EC_Reach_Reference_No';
import Revision_History from '@salesforce/label/c.Revision_History';
import Download from '@salesforce/label/c.Download';
import PDF from '@salesforce/label/c.PDF';
import Excel from '@salesforce/label/c.Excel';
import Save from '@salesforce/label/c.Save';
import Cancel_Declaration from '@salesforce/label/c.Cancel_Declaration';
import Please_specify_the_reason_of_cancelling_this_declaration from '@salesforce/label/c.Please_specify_the_reason_of_cancelling_this_declaration';
import Duplicated_declaration from '@salesforce/label/c.Duplicated_declaration';
import Shipment_cancelled from '@salesforce/label/c.Shipment_cancelled';
import No_credit_shipment from '@salesforce/label/c.No_credit_shipment';
import Others from '@salesforce/label/c.Others';
import Confirm from '@salesforce/label/c.Confirm';
import Your_request_for_declaration_cancellation_has_been_submitted from '@salesforce/label/c.Your_request_for_declaration_cancellation_has_been_submitted';
import OK from '@salesforce/label/c.OK';
import Revise_Date from '@salesforce/label/c.Revise_Date';
import Buyer_Name from '@salesforce/label/c.Buyer_Name';
import Buyer_Code from '@salesforce/label/c.Buyer_Code';
import Shipment_Date from '@salesforce/label/c.Shipment_Date';
import Currency from '@salesforce/label/c.Currency';
import Gross_Invoice_Value_Amount from '@salesforce/label/c.Gross_Invoice_Value_Amount';
import Gross_Invoice_Value_Amount_HKD from '@salesforce/label/c.Gross_Invoice_Value_Amount_HKD';
import Premium_Terms from '@salesforce/label/c.Premium_Terms';
import Port_of_Loading_Ship_From from '@salesforce/label/c.Port_of_Loading_Ship_From';
import Country_Market_of_Origin from '@salesforce/label/c.Country_Market_of_Origin';
import Destination_Country_Market_Ship_to from '@salesforce/label/c.Destination_Country_Market_Ship_to';
import Close from '@salesforce/label/c.Close';
import Select from '@salesforce/label/c.Select';
import OA from '@salesforce/label/c.OA';
import DA from '@salesforce/label/c.DA';
import DP from '@salesforce/label/c.DP';
import Finished from '@salesforce/label/c.Finished';
import In_Progress from '@salesforce/label/c.In_Progress';
import New from '@salesforce/label/c.New';
import Settled_Declaration from '@salesforce/label/c.Settled_Declaration';
import Gross_Invoice_Value from '@salesforce/label/c.Gross_Invoice_Value';
import Payment_Terms from '@salesforce/label/c.Payment_Terms';
import Policyholder_s_Reference_No_if_any from '@salesforce/label/c.Policyholder_s_Reference_No_if_any';
import Status from '@salesforce/label/c.Status';
import Is_Settled from '@salesforce/label/c.Is_Settled';
import Download_All_Record from '@salesforce/label/c.Download_All_Record';
import Amend from '@salesforce/label/c.Amend';
import Details from '@salesforce/label/c.Details';
import Delete from '@salesforce/label/c.Delete';
import Amendment_not_allowed from '@salesforce/label/c.Amendment_not_allowed';
import Shipment_Declaration_Status_Cancellation_pending_for_SME_team_leader_approval from '@salesforce/label/c.Shipment_Declaration_Status_Cancellation_pending_for_SME_team_leader_approval';
import Shipment_Declaration_Status_Cancelled from '@salesforce/label/c.Shipment_Declaration_Status_Cancelled';
import Shipment_Declaration_Status_Amendment_pending_for_SME_team_leader_approval from '@salesforce/label/c.Shipment_Declaration_Status_Amendment_pending_for_SME_team_leader_approval';
import Shipment_Declaration_Status_Cancellation_pending_for_SME_team_staff_approval from '@salesforce/label/c.Shipment_Declaration_Status_Cancellation_pending_for_SME_team_staff_approval';
import Shipment_Declaration_Status_Amendment_pending_for_SME_team_staff_approval from '@salesforce/label/c.Shipment_Declaration_Status_Amendment_pending_for_SME_team_staff_approval';
import Shipment_Declaration_Submit_For_Cancellation from '@salesforce/label/c.Shipment_Declaration_Submit_For_Cancellation';
import Shipment_Declaration_Submit_For_Cancellation_Failed from '@salesforce/label/c.Shipment_Declaration_Submit_For_Cancellation_Failed';
import Shipment_Declaration_Settled_successfully from '@salesforce/label/c.Shipment_Declaration_Settled_successfully';
import Exception_occurred_while_updating from '@salesforce/label/c.Exception_occurred_while_updating';
import Data_Not_Found from '@salesforce/label/c.Data_Not_Found';

export default class ShipDecRecord extends LightningElement {
    @track label ={
        Declaration_Record,Company_Name,Policy_Number,Policy_Type,Select_Buyer,Search_Buyer_Name,Declaration_Received_Date,Reset,Search,
        Sort_ascending,Sort_descending,Declaration_Receive_Date,Pre_Shipment_Declaration_Yes_No,Premium_HKD,Due_Date,Endorsement,
        Shipment_was_made_by_an_overseas_subsidiary,Harmonized_Code,EC_Reach_Reference_No,Revision_History,Download,PDF,Excel,Save,
        Cancel_Declaration,Please_specify_the_reason_of_cancelling_this_declaration,Duplicated_declaration,Shipment_cancelled,No_credit_shipment,
        Others,Confirm,Your_request_for_declaration_cancellation_has_been_submitted,OK,Revision_History,Revise_Date,Buyer_Name,Buyer_Code,
        Shipment_Date,Currency,Gross_Invoice_Value_Amount,Gross_Invoice_Value_Amount_HKD,Premium_Terms,Port_of_Loading_Ship_From,
        Country_Market_of_Origin,Destination_Country_Market_Ship_to,Close,Select,OA,DA,DP,New,In_Progress,Finished,Settled_Declaration,
        Gross_Invoice_Value,Payment_Terms,Policyholder_s_Reference_No_if_any,Status,Is_Settled,Download_All_Record,Amend,Details,Delete,
        Amendment_not_allowed,Shipment_Declaration_Status_Cancelled,Shipment_Declaration_Status_Cancellation_pending_for_SME_team_leader_approval,
        Shipment_Declaration_Status_Amendment_pending_for_SME_team_leader_approval,Shipment_Declaration_Status_Cancellation_pending_for_SME_team_staff_approval,
        Shipment_Declaration_Status_Amendment_pending_for_SME_team_staff_approval,Shipment_Declaration_Submit_For_Cancellation,
        Shipment_Declaration_Submit_For_Cancellation_Failed,Shipment_Declaration_Settled_successfully,Exception_occurred_while_updating,Data_Not_Found,




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
    @track showAutoDetectError=false;
    @track preShipYes = false;
    @track preShipNo = false;
    @track givValue =0;
    @track isShowCancelScreen=false;
    @track cancelConfirmationScreen=false;
    @track isShowAmendReasonScreen=false;
    @track shipDecThatNeedToBesettled=[];
    @track selecetdBuyerName;
    @track typedBuyerName;
    @track shipStart;
    @track shipEnd;
    @track recieveStartDate;
    @track recieveEndDate;
    @track showAmendForm=false;
    @track policyID;
    @track shipmentDecId;
    @track coverButtonIcon="utility:up";
    @track showRevisionHistoryScreen=false;
    @wire(getRecord, {
        recordId: current_user,
        fields: [USERNAME_FIELD]
    }) wireuser({
        error,
        data
    }) {
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
        { value: 'select', label: 'Select' },
        { value: 'USD', label: 'USD' },
        { value: 'INR', label: 'INR' },
    ];
    @track Payment_terms = [
        { value: 'select', label: this.label.Select },
        { value: 'DP', label: this.label.DP },
        { value: 'DA', label: this.label.DA },
        { value: 'OA', label: this.label.OA },
    ];
    @track allShipDecRecords=[];
    @track allShipDecHistoryRecords=[];
    @track previewState=false;
    @track recordIdForCancelation;
    @track reasonForCancellation;
    @track policyType;
    connectedCallback(){
        this.isLoading = true;
        this.getPolicyHolderData();
        this.fetchShipDecRecords();
        this.isLoading = false;
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
            { label: this.label.New, value: 'new' },
            { label: this.label.In_Progress, value: 'inProgress' },
            { label: this.label.Finished, value: 'finished' },
        ];
    }
    
    fetchShipDecRecords(){
        console.log('fetchShipDecRecords caed');
        this.isLoading = true;
        fetchAllShipDec({
            userId : this.userId
        }).then(response => {
            console.log('fetchShipDecRecords success :'+JSON.stringify(response));
            if(response){
                
                this.allShipDecRecords = response;
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
    handlePreview(event){
        console.log('checkPreShipDec tar name : '+event.target.name); 
        console.log('checkPreShipDec tar checked '+event.target.value);
        for(let sdr in this.allShipDecRecords){
            if(this.allShipDecRecords[sdr].id === event.target.value){
                console.log('SD id matched');
                if(this.allShipDecRecords[sdr].isShowDetais){
                    this.allShipDecRecords[sdr].isShowDetais=false;
                }else{
                    this.allShipDecRecords[sdr].isShowDetais=true;
                }
                
            }else{
                this.allShipDecRecords[sdr].isShowDetais=false;
            }

        }
    }
    editData = true
    defSortIconClass = " slds-button__icon_right slds-current-color"
    keys = [
        {
            "label": this.label.Settled_Declaration,
            "fieldName": "isShowDetais",
            "type": "text",
            "sortable": false,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass
        },
        {
            "label": this.label.Buyer_Name,
            "fieldName": "buyerName",
            "type": "text",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass
        },
        {
            "label": this.label.Buyer_Code,
            "fieldName": "buyerCode",
            "type": "text",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass
        },
        {
            "label": this.label.Shipment_Date,
            "fieldName": "shipMentDate",
            "type": "text",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass
        },
        {
            "label": this.label.Currency,
            "fieldName": "ecicCurrency",
            "type": "text",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass
        },
        {
            "label": this.label.Gross_Invoice_Value,
            "fieldName": "grossInvoiceValue",
            "type": "text",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass
        },
        {
            "label": this.label.Payment_Terms,
            "fieldName": "paymentTerm",
            "type": "text",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass
        },
        {
            "label": this.label.Port_of_Loading_Ship_From,
            "fieldName": "portOfLoading",
            "type": "text",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass
        },

        {
            "label": this.label.Country_Market_of_Origin,
            "fieldName": "countryOrigin",
            "type": "text",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass
        },

        
        {
            "label": this.label.Destination_Country_Market_Ship_to,
            "fieldName": "destinationCountry",
            "type": "text",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass
        },
        
        {
            "label": this.label.Policyholder_s_Reference_No_if_any,
            "fieldName": "phRefNo",
            "type": "text",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass
        },
        {
            "label": this.label.Status,
            "fieldName": "status",
            "type": "text",
            "sortable": true,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass
        },
        {
            "label": this.label.Is_Settled,
            "fieldName": "isSettled",
            "type": "text",
            "disabled": true,
            "sortable": false,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass
        },
        {
            "label": this.label.Download_All_Record,
            "fieldName": "isShowDetais",
            "type": "text",
            "sortable": false,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass
        },
        {
            "label": this.label.Amend,
            "fieldName": "Harmonized_Code__c",
            "type": "text",
            "sortable": false,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass
        },
        {
            "label": this.label.Details,
            "fieldName": "Harmonized_Code__c",
            "type": "text",
            "sortable": false,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass
        },
        {
            "label": this.label.Delete,
            "fieldName": "Harmonized_Code__c",
            "type": "text",
            "sortable": false,
            "downIconClass": this.defSortIconClass,
            "upIconClass": this.defSortIconClass
        }
    ]
    sortAsending(event) {
        var key = event.currentTarget.dataset.id;
        console.log("sortAsending::", key);
        this.allShipDecRecords = this.allShipDecRecords.sort((a, b) => (a[key] > b[key]) ? 1 : ((b[key] > a[key]) ? -1 : 0))
        this.setSortedIconColor(key, 'up')
    }
    sortDecending(event) {
        var key = event.currentTarget.dataset.id;
        console.log("sortDecending::", key);
        this.allShipDecRecords = this.allShipDecRecords.sort((a, b) => (a[key] < b[key]) ? 1 : ((b[key] < a[key]) ? -1 : 0))
        this.setSortedIconColor(key, 'down')
    }
    handleDownloadAll(event){
        console.log('handleDownloadAll tar val : '+event.target.vaue); 
        console.log('handleDownloadAll tar val : '+event.detail.value); 
        
        
    }
    downloadData(event) { 
        console.log('downloadData tar val : '+event.detail.value); 
        let fileFormat =  event.detail.value;
        let rowEnd = '\n';
        let csvString = '';
        // this set elminates the duplicates if have any duplicate keys
        let rowData = new Set();

        // getting keys from data
        this.allShipDecRecords.forEach(function (record) {
            Object.keys(record).forEach(function (key) {
                rowData.add(key);
            });
        });

        // Array.from() method returns an Array object from any object with a length property or an iterable object.
        rowData = Array.from(rowData);
        
        // splitting using ','
        csvString += rowData.join(',');
        csvString += rowEnd;

        // main for loop to get the data based on key value
        for(let i=0; i < this.allShipDecRecords.length; i++){
            let colValue = 0;

            // validating keys in data
            for(let key in rowData) {
                if(rowData.hasOwnProperty(key)) {
                    // Key value 
                    // Ex: Id, Name
                    let rowKey = rowData[key];
                    // add , after every value except the first.
                    if(colValue > 0){
                        csvString += ',';
                    }
                    // If the column is undefined, it as blank in the CSV file.
                    let value = this.allShipDecRecords[i][rowKey] === undefined ? '' : this.allShipDecRecords[i][rowKey];
                    csvString += '"'+ value +'"';
                    colValue++;
                }
            }
            csvString += rowEnd;
        }

        // Creating anchor element to download
        let downloadElement = document.createElement('a');

        // This  encodeURI encodes special characters, except: , / ? : @ & = + $ # (Use encodeURIComponent() to encode these characters).
        if(fileFormat === 'PDF'){
            downloadElement.href = 'data:application/pdf;charset=utf-8,' + encodeURI(csvString);
        }else{
            downloadElement.href = 'data:application/excel;charset=utf-8,' + encodeURI(csvString);
        }
        
        downloadElement.target = '_self';
        // CSV File Name
        downloadElement.download =(fileFormat === 'PDF') ? 'Shipment Declaration.pdf': 'Shipment Declaration.xls';
        // below statement is required if you are using firefox browser
        document.body.appendChild(downloadElement);
        // click() Javascript function to download CSV file
        downloadElement.click(); 
    }
    handleDelete(event){
        console.log('handleDelete tar val : '+event.target.value); 
        this.recordIdForCancelation = event.target.value;
        this.isShowCancelScreen = true;
        console.log('handleDelete isShowCancelScreen : '+this.isShowCancelScreen+' recordIdForCancelation:'+this.recordIdForCancelation); 
    }
    amendShipDec(event){
        console.log('amendShipDec tar val : '+event.target.value); 
        try {
            this.shipmentDecId = event.target.value;
            
            for(let ship in this.allShipDecRecords){
                if(this.shipmentDecId === this.allShipDecRecords[ship].id){
                    if(this.allShipDecRecords[ship].status === 'Cancelled'){
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: this.label.Amendment_not_allowed,
                                message: this.label.Shipment_Declaration_Status_Cancelled,
                                variant: 'error'
                            })
                        );
                    }else if(this.allShipDecRecords[ship].status === 'Cancellation pending for SME team leader approval'){
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: this.label.Amendment_not_allowed,
                                message: this.label.Shipment_Declaration_Status_Cancellation_pending_for_SME_team_leader_approval,
                                variant: 'error'
                            })
                        );
                    }else if(this.allShipDecRecords[ship].status === 'Amendment pending for SME team leader approval'){
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: this.label.Amendment_not_allowed,
                                message: this.label.Shipment_Declaration_Status_Amendment_pending_for_SME_team_leader_approval,
                                variant: 'error'
                            })
                        );
                    }else if(this.allShipDecRecords[ship].status === 'Cancellation pending for SME team staff approval'){
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: this.label.Amendment_not_allowed,
                                message: this.label.Shipment_Declaration_Status_Cancellation_pending_for_SME_team_staff_approval,
                                variant: 'error'
                            })
                        );
                    }else if(this.allShipDecRecords[ship].status === 'Amendment pending for SME team staff approval'){
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: this.label.Amendment_not_allowed,
                                message: this.label.Shipment_Declaration_Status_Amendment_pending_for_SME_team_staff_approval,
                                variant: 'error'
                            })
                        );
                    }else{
                        this.showAmendForm = true;
                    }
                }
            }
            
            /*for(let ship in this.allShipDecRecords){
                if(this.shipmentDecId === this.allShipDecRecords[ship].id){
                    console.log('this.allShipDecRecords[ship] : '+this.allShipDecRecords[ship].status)
                    if(this.allShipDecRecords[ship].status === 'Allowed To Amend'){
                        this.showAmendForm = true;
                    }else if(this.allShipDecRecords[ship].status === 'Not Settled') {
                        //Change the status to Waiting for Amend
                        changeStatusForApproval({
                            shipmentDecId : this.shipmentDecId,
                            actionFor : 'Amend'
                        }).then(data => {
                            console.log('changeStatusForApproval success :'+JSON.stringify(data));
                            try {
                                if(data){
                                    this.dispatchEvent(
                                        new ShowToastEvent({
                                            title: 'Shipment Declaration Submit For Approval',
                                            message: 'Shipment Declaration Submit For Approval',
                                            variant: 'success'
                                        })
                                    );
                                    
                                }else{
                                    this.dispatchEvent(
                                        new ShowToastEvent({
                                            title: 'Shipment Declaration Status Change Failed',
                                            message: 'Shipment Declaration Status Change Failed ',
                                            variant: 'error'
                                        })
                                    );
                                }
                            } catch (error) {
                                console.error('Error 1 '+error.toString()+' '+JSON.stringify(error));
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                        title: 'Exception occurred while Updating shipment declaration.',
                                        message: error.toString(),
                                        variant: 'warning'
                                    })
                                );
                            }
                        
                        }).catch(error => {
                            console.error('Error 2 '+error.toString());
                                console.error('Error 2 '+JSON.stringify(error));
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Exception occurred while updating shipment declaration.',
                                    message: error.toString(),
                                    mode : 'sticky',
                                    variant: 'error'
                                })
                            );
                        });
                    }
                }
            }*/
        } catch (error) {
            console.log('Exception at '+error.toString()+' '+JSON.stringify(error));
        }
        
    }
    confirmCancelling(event){
        console.log('confirmCancelling tar val : '+event.target.value); 
        this.reasonForCancellation = event.target.value;
        this.isShowCancelScreen = false;
        this.cancelConfirmationScreen = true;
        for(let ship in this.allShipDecRecords){
                if(this.recordIdForCancelation === this.allShipDecRecords[ship].id){
                    console.log('this.allShipDecRecords[ship] : '+this.allShipDecRecords[ship].status)
                    
                        //Change the status to Waiting for Amend
                        changeStatusForApproval({
                            shipmentDecId : this.recordIdForCancelation,
                            actionFor : 'Cancel',
                            reasonForCancellation : this.reasonForCancellation
                        }).then(data => {
                            console.log('changeStatusForApproval success :'+JSON.stringify(data));
                            try {
                                if(data){
                                    this.dispatchEvent(
                                        new ShowToastEvent({
                                            title: this.label.Shipment_Declaration_Submit_For_Cancellation,
                                            message: this.label.Shipment_Declaration_Submit_For_Cancellation,
                                            variant: 'success'
                                        })
                                    );
                                    window.location.reload();
                                    
                                }else{
                                    this.dispatchEvent(
                                        new ShowToastEvent({
                                            title: this.label.Shipment_Declaration_Submit_For_Cancellation_Failed,
                                            message: this.label.Shipment_Declaration_Submit_For_Cancellation_Failed,
                                            variant: 'error'
                                        })
                                    );
                                }
                            } catch (error) {
                                console.error('Error 1 '+error.toString()+' '+JSON.stringify(error));
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                        title: 'Exception occurred while Submit For Cancellation Failed.',
                                        message: error.toString(),
                                        variant: 'warning'
                                    })
                                );
                            }
                        
                        }).catch(error => {
                            console.error('Error 2 '+error.toString());
                                console.error('Error 2 '+JSON.stringify(error));
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Exception occurred Submit For Cancellation Failed.',
                                    message: error.toString(),
                                    mode : 'sticky',
                                    variant: 'error'
                                })
                            );
                        });
                }
            }
    }
    
    cancelConfirmScren(event){
        console.log('cancelConfirmScren tar val : '+event.target.value); 
        this.cancelConfirmationScreen = false;
    }
    submitAmend(event){
        console.log('submitAmend tar val : '+event.target.value); 
        this.isShowAmendReasonScreen = false;
    }
    handleShipDecSettlement(event){
        console.log('handleShipDecSettlement tar val : '+event.target.value+' checked : '+event.target.checked); 
        try {
            if(event.target.checked){
                this.shipDecThatNeedToBesettled.push(event.target.value);
            }else{
                this.shipDecThatNeedToBesettled.pop(event.target.value);
            }
            
        } catch (error) {
            console.log('handleShipDecSettlement error : '+JSON.stringify(error)+' '+error.toString); 

        }
        
        console.log('shipDecThatNeedToBesettled : '+this.shipDecThatNeedToBesettled); 
    }
    handleSettlement(){
        this.isLoading = true;
        console.log('handleSettlement shipDecThatNeedToBesettled : '+this.shipDecThatNeedToBesettled); 
        if (Array.isArray(this.shipDecThatNeedToBesettled)){
            console.log('Array found.'+this.shipDecThatNeedToBesettled.length); 
            if (this.shipDecThatNeedToBesettled.length>0){
                console.log('Go For Update.'); 
                    updateSettlement({
                        shipIDList : this.shipDecThatNeedToBesettled
                    }).then(data => {
                        console.log('updateSettlement success :'+JSON.stringify(data));
                        try {
                            if(data){
                                this.fetchShipDecRecords();
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                        title: this.label.Shipment_Declaration_Settled_successfully,
                                        message: this.label.Shipment_Declaration_Settled_successfully,
                                        variant: 'success'
                                    })
                                );
                            }else{
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                        title: this.label.Exception_occurred_while_updating,
                                        message: this.label.Exception_occurred_while_updating,
                                        variant: 'error'
                                    })
                                );
                            }
                        } catch (error) {
                        
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Exception Occurred while Settling Shipment Declaration',
                                    message: error.toString(),
                                    variant: 'error'
                                })
                            );
                        }
                        
                    }).catch(error => {
                        
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Exception Occurred while Settling Shipment Declaration',
                                message: error.toString(),
                                mode : 'sticky',
                                variant: 'error'
                            })
                        );
                    });
            }else{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Please select shipment declaration record to settle',
                        message: 'Please select shipment declaration record to settle',
                        variant: 'warning'
                    })
                );
            }
        }
        this.isLoading = false;
    }
    handleSearchFilter(event){
        console.log('handleDateFilter tar name : '+event.target.name+' value : '+event.target.value); 
        if(event.target.name === 'selecetdBuyerName'){
            this.selecetdBuyerName = event.target.value;
        }else if(event.target.name === 'typedBuyerName'){
            this.typedBuyerName = event.target.value;
        }else if(event.target.name === 'shipStart'){
            this.shipStart = event.target.value;
        }else if(event.target.name === 'shipEnd'){
            this.shipEnd = event.target.value;
        }else if(event.target.name === 'recieveStartDate'){
            this.recieveStartDate = event.target.value;
        }else if(event.target.name === 'recieveEndDate'){
            this.recieveEndDate = event.target.value;
        }else if(event.target.name === 'recieveEndDate'){
            this.recieveEndDate = event.target.value;
        }
    }
    searchDeclaredShipments(){
        this.isLoading = true;
        console.log('searchDeclaredShipments called recieveStartDate:'+this.recieveStartDate+' recieveEndDate :'+this.recieveEndDate);
        getDeclaredBuyerInfo({
            usrId : this.userId,
            selecetdBuyerName : this.selecetdBuyerName,
            typedBuyerName : this.typedBuyerName,
            shipStart : this.shipStart,
            shipEnd : this.shipEnd,
            createdFrom : this.recieveStartDate,
            createdTo : this.recieveEndDate,
            policyID : this.policyID
        }).then(data => {
            console.log('getDeclaredBuyerInfo success :'+JSON.stringify(data));
            try {
                if(data){
                    
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Found Shipment Declared Record',
                            message: '',
                            variant: 'success'
                        })
                    );
                    this.allShipDecRecords = data;
                    
                }else{
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: this.label.Data_Not_Found,
                            message: this.label.Data_Not_Found,
                            variant: 'warning'
                        })
                    );
                    this.allShipDecRecords = [];
                }
            } catch (error) {
            console.error('Error 1 '+error.toString());
            console.error('Error 2 '+JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception occurred while loading shipment declaration.',
                        message: error.toString(),
                        variant: 'warning'
                    })
                );
            }
        
        }).catch(error => {
            console.error('Error 2 '+error.toString());
                console.error('Error 2 '+JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception occurred while loading shipment declaration.',
                    message: error.toString(),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
            
           
        this.isLoading = false;
    }
    clearSearchField(){
        this.typedBuyerName='';
        this.shipStart='';
        this.shipEnd='';
        this.recieveStartDate='';
        this.recieveEndDate='';
        this.fetchShipDecRecords();
    }
    showRevisionHistory(event){ 
        this.allShipDecHistoryRecords=[];
        console.log('showRevisionHistory tar name : '+event.target.name+' value : '+event.target.value);  
        if(event.target.value){
            fetchAllShipDecHistory({
                shipmentID : event.target.value
            }).then(data => {
                console.log('showRevisionHistory success :'+JSON.stringify(data));
                try {
                    if(data){
                        this.showRevisionHistoryScreen= true;
                        this.allShipDecHistoryRecords = data;
                        
                    }else{
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: this.label.Data_Not_Found,
                                message: this.label.Data_Not_Found,
                                variant: 'warning'
                            })
                        );
                        this.allShipDecRecords = [];
                    }
                } catch (error) {
                    console.error('Error 1 '+error.toString()+' '+JSON.stringify(error));
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Exception occurred while loading shipment declaration history.',
                            message: error.toString(),
                            variant: 'warning'
                        })
                    );
                }
            
            }).catch(error => {
                console.error('Error 2 '+error.toString());
                    console.error('Error 2 '+JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception occurred while loading shipment declaration.',
                        message: error.toString(),
                        mode : 'sticky',
                        variant: 'error'
                    })
                );
            });
        }

    }
    expandHandler(event){ 
        console.log('expandHandler : '+event.currentTarget.id);
        let id = event.currentTarget.id + "";
        id = id.split("-")[0]; 
        console.log('expandHandler id: '+id);
        for(let sdr in this.allShipDecHistoryRecords){
            if(this.allShipDecHistoryRecords[sdr].Id === id){
                console.log('SDH id matched');
                if(this.allShipDecHistoryRecords[sdr].isShowDetais){
                    this.allShipDecHistoryRecords[sdr].isShowDetais=false;
                    this.allShipDecHistoryRecords[sdr].coverButtonIcon = "utility:up";
                }else{
                    this.allShipDecHistoryRecords[sdr].isShowDetais=true;
                    this.allShipDecHistoryRecords[sdr].coverButtonIcon = "utility:down";
                }
            }else{
                this.allShipDecHistoryRecords[sdr].isShowDetais=false;
                this.allShipDecHistoryRecords[sdr].coverButtonIcon = "utility:up";

            }

        }
    }
    cancelRevisionHistoryScreen(event){
        this.showRevisionHistoryScreen = false;
    }
}