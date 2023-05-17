import { LightningElement ,  track , wire, api} from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import current_user from '@salesforce/user/Id';
import getPolicyHolderData from '@salesforce/apex/PolicyManagement.getPolicyHolderData';
import getAllSchedule from '@salesforce/apex/PolicyManagement.getAllSchedule'
import getInvoiceData from '@salesforce/apex/PolicyManagement.getInvoiceData'

import USERNAME_FIELD from '@salesforce/schema/User.Username';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDomainBaseURL from '@salesforce/apex/PolicyManagement.getDomainBaseURL'
// getParametersValues from '@salesforce/apex/PaymentProcessor.getParametersValues'
//import getSignedData from '@salesforce/apex/PaymentProcessor.getSignedData'
//import storeTheInvoiceID from '@salesforce/apex/PolicyManagement.storeTheInvoiceID'
import processPaymentTransaction from '@salesforce/apex/PaymentProcessor.processPaymentTransaction'
import CUSTOMCSS from '@salesforce/resourceUrl/multilineToastCSS';
import { loadStyle } from 'lightning/platformResourceLoader';
import callConvertCLItoCreditLimit from '@salesforce/apex/PaymentProcessor.callConvertCLItoCreditLimit'
// import gateway_logo from '@salesforce/resourceUrl/payment_gateway_logo';

import Company_Name from '@salesforce/label/c.Company_Name';
import Login_Account from '@salesforce/label/c.Login_Account';
import Policy_Number from '@salesforce/label/c.Policy_Number';
import Invoice_No from '@salesforce/label/c.Invoice_No';
import Issue_Date from '@salesforce/label/c.Issue_Date';
import Due_Date from '@salesforce/label/c.Due_Date';
import Amount from '@salesforce/label/c.Amount';
import Select from '@salesforce/label/c.Select';
import Download_Invoice from '@salesforce/label/c.Download_Invoice';
import Pay from '@salesforce/label/c.Pay';
import Status from '@salesforce/label/c.Status';
import Invoice from '@salesforce/label/c.Invoice';
import Payment_Receipt from '@salesforce/label/c.Payment_Receipt';
import Download_Selected_Document from '@salesforce/label/c.Download_Selected_Document';
import Cancel from '@salesforce/label/c.Cancel';
import TERMS_AND_CONDITIONS_FOR_PAYMENT from '@salesforce/label/c.TERMS_AND_CONDITIONS_FOR_PAYMENT';
import Policy_Invoice_Terms from '@salesforce/label/c.Policy_Invoice_Terms';
import Policy_Invoice_Terms2 from '@salesforce/label/c.Policy_Invoice_Terms2';
import Policy_Invoice_Terms3 from '@salesforce/label/c.Policy_Invoice_Terms3';
import Policy_Invoice_Terms4 from '@salesforce/label/c.Policy_Invoice_Terms4';
import Policy_Invoice_Terms5 from '@salesforce/label/c.Policy_Invoice_Terms5';
import Policy_Invoice_Terms5a from '@salesforce/label/c.Policy_Invoice_Terms5a';
import Policy_Invoice_Terms5b from '@salesforce/label/c.Policy_Invoice_Terms5b';
import Policy_Invoice_Terms5c from '@salesforce/label/c.Policy_Invoice_Terms5c';
import Policy_Invoice_Terms6 from '@salesforce/label/c.Policy_Invoice_Terms6';
import Policy_Invoice_Terms7 from '@salesforce/label/c.Policy_Invoice_Terms7';
import Policy_Invoice_Terms8 from '@salesforce/label/c.Policy_Invoice_Terms8';
import Policy_Invoice_Terms9 from '@salesforce/label/c.Policy_Invoice_Terms9';
import Back from '@salesforce/label/c.Back';
import Next from '@salesforce/label/c.Next';
import getWrapperPolicyHolderData from '@salesforce/apex/PolicyManagement.getWrapperPolicyHolderData';




const unPaidInvoiceColumn = [
    { label: 'Invoice No.', fieldName: 'name',type: 'text' },
    { label: 'Issue Date', fieldName: 'issueDate', type:'date'},
    { label: 'Due Date', fieldName: 'dueDate',type:'date' },
    { label: 'Amount', fieldName: 'amount', type:'number' }
];
const paidInvoiceColumn = [
    { label: 'Invoice No.', fieldName: 'name',type: 'text' },
    { label: 'Issue Date', fieldName: 'issueDate', type:'date'},
    { label: 'Due Date', fieldName: 'dueDate',type:'date' },
    { label: 'Amount', fieldName: 'amount', type:'number' },
    { label: 'Status', fieldName: 'status', type:'text' }
];
export default class PolicyInvoice extends NavigationMixin(LightningElement) {


    @track label ={
        Company_Name,Login_Account,Policy_Number,Invoice_No,Issue_Date,Due_Date,Amount,Select,Download_Invoice,Pay,Status,Invoice,
        Payment_Receipt,Download_Selected_Document,Cancel,TERMS_AND_CONDITIONS_FOR_PAYMENT,Policy_Invoice_Terms,Policy_Invoice_Terms2,
        Policy_Invoice_Terms3,Policy_Invoice_Terms4,Policy_Invoice_Terms5,Policy_Invoice_Terms5a,Policy_Invoice_Terms5b,Policy_Invoice_Terms5c,
        Policy_Invoice_Terms6,Policy_Invoice_Terms7,Policy_Invoice_Terms8,Policy_Invoice_Terms9,Back,Next
    }
    // mastercardLogoUrl = gateway_logo + '/masterCard/sc_learn_74x40.gif';
    // visaLogoUrl = gateway_logo + '/VisaSecure/visa-secure_blu_100ppi.jpg';
    // jcbLogoUrl = gateway_logo + '/jcb/pic_logo_04.gif';
    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.currentPageReference = currentPageReference;
    }
    @track showUnpaidInvoice;
    @track unPaidInvoiceColumn;
    @track unpaidInvoiceData=[];
    @track paidInvoiceColumn;
    @track paidInvoiceData=[];
    @track userId = current_user;

    @track isProductOMBP;
    @track isProductSBP;
    @track isProductSUP;
    @track accInfo;
    @track currentPolicyID;
    @track companyName;
    @track currentPolicy;
    @track policyNumber;
    @track issueDate;
    @track renewalDate;
    @track currentPolicyName;
    @track isProductId;
    @track effectiveDate;

    @track error;
    @track logged_in_user;
    @track totalAmount = 0;
    @track checkbox1Value = false;
    @track showCheckboxError = false;
    @track checkboxNotSelectedErrorMsg = "Please accept all the terms & conditions to continue."
    @track btnDisabled = true
    @track disableNextClass = "disabled"
    @track showPaymentTermsAndCOnditions = false;
    @wire(getRecord, {
        recordId: current_user,
        fields: [USERNAME_FIELD]
    }) wireuser({
        error,
        data
    }) {
        if (error) {
        this.error = error ; 
        } else if (data) {
            console.log('data.fields : '+JSON.stringify(data.fields));
            this.logged_in_user = data.fields.Username.value;
        }
    }
    @track vFURL='https://kennychun--dev2.my.salesforce.com/apex/PolicyInvoice?policyID=';
    @track paymentPage='https://kennychun--dev2.my.salesforce.com/apex/HostedPaymentPage';
    @track showInvoicePDF=false;
    @track showVFPage=false;
    @track domainBaseURL;
    @track vfPageUrl;
    @track paymentRequestData;
    @track paymentReqDataDataSignature;
    @track payPostURL='https://testsecureacceptance.cybersource.com/pay';
    @track listOfInvoiceIds=[];
    @track invoiceIds='END';
    @track lastSelectedInvoiceId;
    @track isCssLoaded = false;
    @track showPay=true;
    @track payResponseData;
    @track cla_id;
    @track language;

    @track isLimitedAccess;
    @track limitedAccessDate;
    @track isLimitedAccessWithinSixMonth;
    @track policyStatus;
    @track isPolicyValid;
    @track isPolTerminationWithinSixMonth;

    connectedCallback(){
        console.log('Inovoice userId : '+this.userId);
        console.log("URL Parameters => ", JSON.stringify(this.currentPageReference.state));
        this.language =  this.currentPageReference.state.language;
        console.log('this.language ::'+this.language);
        let reason_code = this.currentPageReference.state.reason_code;
        console.log('reason_code ======>>'+reason_code);
        if(typeof reason_code === 'undefined'){
            console.log('Undefined reason_code:'+reason_code);
            //this.handlePayTransaction();
        }else{
            console.log('Found reason_code:'+reason_code);
            this.handlePayTransaction(); 
        }
        console.log("URL Parameters => ", this.currentPageReference.state.c__id);
        this.sfdcBaseURL = window.location.origin;
        console.log('Base Url : '+this.sfdcBaseURL);
        this.showUnpaidInvoice = true;
        this.unPaidInvoiceColumn = unPaidInvoiceColumn;
        
        this.paidInvoiceColumn = paidInvoiceColumn;
        
        this.getPolicyHolderData();
        this.getModifiedPolicyHolderData();
        this.getAllSchedule();
        this.getInvoiceDetailsJS();
        this.getDomainBaseURLJS();
        //this.getParametersValuesJS();
        //this.getSignedDataJS();

    }
    renderedCallback(){
        console.error('renderedCallback ');
        if(this.isCssLoaded) return
        this.isCssLoaded = true;
        loadStyle(this,CUSTOMCSS).then(()=>{
            console.log('loaded');
        })
        .catch(error=>{
            console.log('Error===>> to load');
        });
    
    }
    //callConvertCLItoCreditLimit
    handleCreditLimit(){
        console.log('handleCreditLimit : '+this.cla_id);
        callConvertCLItoCreditLimit({
            cla_id : this.cla_id
        }).then(data => {
            console.log('handleCreditLimit success :'+JSON.stringify(data));
            if(data.isSuccess){
            }else{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Credit Limit Issue Failed.',
                        message:'Credit Limit Issue Failed.',
                        mode : 'sticky',
                        variant: 'error'
                    })
                );
            }
        }).catch(error => {
            console.error('Error : '+error.toString()+' '+JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Credit Limit Application Issue.',
                    message: JSON.stringify(error),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
    handlePayTransaction(){
        processPaymentTransaction({
            response : JSON.stringify(this.currentPageReference.state)
        }).then(data => {
            console.log('processPaymentTransaction success :'+JSON.stringify(data));
            this.payResponseData = data;
           
            if(data.isSuccess){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Payment Done Successfully.',
                        message: data.responseMsg+'\n Order Number : '+data.orderNumber+'\nPaid Amount : '+data.paidAmount+'\nReason Code : '+data.reasonCode,
                        mode : 'sticky',
                        variant: 'success'
                    })
                );
                if(this.payResponseData){
                    console.log('Go for CLA');
                    if(this.payResponseData.invLine && this.payResponseData.invLine.length > 0){
                        console.log('Found CLA');
                        this.cla_id = this.payResponseData.invLine[0].Credit_Limit_Application__c;
                        this.handleCreditLimit();
                    }
                }
            }else{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Failed Payment.',
                        message: data.responseMsg+'\nReason Code : '+data.reasonCode,

                        mode : 'sticky',
                        variant: 'error'
                    })
                );
            }
        }).catch(error => {
            console.error('Error : '+error.toString()+' '+JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Failed Payment.',
                    message: JSON.stringify(error),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
    getDomainBaseURLJS(){
        getDomainBaseURL({}).then(data => {
            console.log('getDomainBaseURL success :'+JSON.stringify(data));
            this.domainBaseURL = data;


        }).catch(error => {
            console.log('Error : '+error.toString()+' '+JSON.stringify(error));
        });
    }
    
    paymentPopCancel(event){
        this.showVFPage = false;
    }
    getParametersValuesJS(){
        getParametersValues({}).then(data => {
            console.log('getParametersValues success :'+JSON.stringify(data));
            this.paymentRequestData = data;


        }).catch(error => {
            console.log('Error : '+error.toString()+' '+JSON.stringify(error));
        });
    }
    getSignedDataJS(){
        getSignedData({}).then(data => {
            console.log('getSignedData success :'+JSON.stringify(data));
            this.paymentReqDataDataSignature = data;


        }).catch(error => {
            console.log('Error : '+error.toString()+' '+JSON.stringify(error));
        });
    }
    getPolicyHolderData(){
        console.log('getPolicyHolderData called.');
        getPolicyHolderData({
            usrId : this.userId
        }).then(data => {
            console.log('getPolicyHolderData success :'+JSON.stringify(data));
            try {
                this.accInfo = data;
                this.companyName = data.Name;
                this.currentPolicyID = data.Current_Policy__c;
                this.currentPolicy = data.Current_Policy__r.Product__r.Name;
                this.policyNumber = data.Current_Policy__r.Name;
                this.currentPolicyName = data.Current_Policy__r.Product__r.Full_Name__c;
                this.isProductId = data.Current_Policy__r.Product__c;
                //this.mapDataPassToSchedule.push({key:'policyNumber',value:this.policyNumber}); 
                //console.log('mapDataPassToSchedule  One: '+JSON.stringify(this.mapDataPassToSchedule));
                if(data.Current_Policy__r.Status__c === 'Valid' && data.Current_Policy__r.Allow_Policy_Holder_To_Terminate__c){
                    this.isPolicyHolderAllowedToTerminatePolicy  = true;
                }
                if(this.currentPolicy === 'OMBP'){
                    this.isProductOMBP = true;
                }else if(this.currentPolicy === 'SBP'){
                    this.isProductSBP = true;
                }else if(this.currentPolicy === 'SUP'){
                    this.isProductSUP= true;
                }
                this.vFURL = this.vFURL + this.currentPolicyID;
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

    getAllSchedule(){
        console.log('getAllSchedule called.');
        getAllSchedule({
            usrId : this.userId
        }).then(data => {
            console.log('getAllSchedule success :'+JSON.stringify(data));
            try {
                this.allSchedule = data;
                for(let sch in data){
                    if(data[sch].Type__c === 'Schedule 1'){
                        console.log('Schedule 1*********************x');
                        //this.currentPolicyHolderAddress = data[sch].Policyholder_s_Address__c;
                        this.currentPolicyIssueDate = data[sch].Issue_Date__c;
                        //this.maximumLiabilty = data[sch].Maximum_Liability__c;
                        this.commencementDate =data[sch].Commencement_Date__c;
                        //this.percentageOfIndmenity = data[sch].Percentage_of_Indemnity__c;
                        this.issueDate = data[sch].Issue_Date__c;
                        this.renewalDate = data[sch].Renewal_Date__c;
                        this.effectiveDate = data[sch].Effective_Date__c;
                        
                    }else if(data[sch].Type__c === 'Schedule 2'){
                        console.log('Schedule 2*********************');
                    }else if(data[sch].Type__c === 'Schedule 3'){
                        console.log('Schedule 3*********************');
                    }else if(data[sch].Type__c === 'Schedule 4'){
                        console.log('Schedule 4*********************');
                    }
                }
            } catch (error) {
               
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while fetching Policy Schedule',
                        message: error.toString(),
                        mode : 'sticky',
                        variant: 'warning'
                    })
                );
            }
            
        }).catch(error => {
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while fetching Schedule',
                    message: error.toString(),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
    
    getInvoiceDetailsJS(){
        console.log('getInvoiceDetailsJS called.');
        getInvoiceData({
            usrId : this.userId
        }).then(data => {
            console.log('getInvoiceData success :'+JSON.stringify(data));
            try {
                if(data){
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Found Invoice',
                            message: '',
                            variant: 'success'
                        })
                    );
                    for(let i in data){
                        if(data[i].status==="UnPaid"){
                            console.log('Found Unpaid');
                            this.unpaidInvoiceData.push(data[i]);
                        }else if(data[i].status==="Paid"){
                            console.log('Found paid');
                            this.paidInvoiceData.push(data[i]);
                        }
                    }
                }
                
            } catch (error) {
               
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while loading invoice.',
                        message: error.toString(),
                        mode : 'sticky',
                        variant: 'warning'
                    })
                );
            }
            
        }).catch(error => {
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred while loading invoice.',
                    message: error.toString(),
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        });
    }
    
    downloadInvoice1(){
        console.log('window.location.origin : '+window.location.origin);
        console.log('downloadInvoice '+this.currentPolicyID);
        const urlWithParameters =window.location.origin+'/ECReach/apex/PolicyInvoice?policyID='+this.currentPolicyID;
        //const urlWithParameters = 'https://kennychun--dev2.my.salesforce.com/apex/PolicyInvoice?policyID='+this.currentPolicyID;
        
        console.log('urlWithParameters...'+urlWithParameters);
        this[NavigationMixin.Navigate]({
        type: 'standard__webPage',
            attributes: {
            url: urlWithParameters
        }
        }, false); //if you set true this will opens the new url in same window
    }
    downloadInvoice(){
        console.log('window.location.origin : '+window.location.origin);
        console.log('downloadInvoice '+this.currentPolicyID);
        if(this.listOfInvoiceIds.length>0){
            for(let invId in this.listOfInvoiceIds){
                console.log('invId=='+this.listOfInvoiceIds[invId]);
                const urlWithParameters = window.location.origin+'/ECReach/apex/PolicyInvoice?policyID='+this.currentPolicyID+'&invoiceId='+this.listOfInvoiceIds[invId];
                
                console.log('urlWithParameters...'+urlWithParameters);
                //window.open(urlWithParameters);
                this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                    attributes: {
                    url: urlWithParameters
                }
                }, false); //if you set true this will opens the new url in same window
                
            }
        }else{
            console.log('Select the Invoice to Download.');
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Please select any invoice to download',
                    message: error.toString(),
                    mode : '',
                    variant: 'warning'
                })
            );
        }
        
        
    }

    handleNavigate() {
        const config = {
            type: 'standard__webPage',
            attributes: {
                url: this.payPostURL
            }
        };
        this[NavigationMixin.Navigate](config);
    }

    handleInvoiceSelection(event){
        let isChecked = event.target.checked;
        let item_id = event.target.value;
        console.log('handleInvoiceSelection isChecked :'+isChecked+' item_id:'+item_id);
        
        for(let unPaid in this.unpaidInvoiceData){
            if(this.unpaidInvoiceData[unPaid].Id === item_id){
                console.log('Matched Invoice.');
                if(isChecked){
                    this.lastSelectedInvoiceId = item_id;
                    this.unpaidInvoiceData[unPaid].invoiceCheckBox=true;
                    this.listOfInvoiceIds.push(item_id);
                    //this.totalAmount = parseFloat(this.totalAmount) + parseFloat(this.unpaidInvoiceData[unPaid].premium);
                    this.totalAmount = parseFloat(this.unpaidInvoiceData[unPaid].premium);

                    const urlWithParameters = window.location.origin+'/ECReach/apex/PolicyInvoice?policyID='+this.currentPolicyID+'&invoiceId='+item_id;
                    window.open(urlWithParameters);
                }else{
                    this.listOfInvoiceIds.pop(item_id);
                    this.unpaidInvoiceData[unPaid].invoiceCheckBox=false;
                    //this.totalAmount = parseFloat(this.totalAmount) - parseFloat(this.unpaidInvoiceData[unPaid].premium);
                }
            }else{
                console.log('not matched !!!');
                this.unpaidInvoiceData[unPaid].invoiceCheckBox=false;
            }
        }
        console.log('Un Paid data : '+JSON.stringify(this.unpaidInvoiceData));
        /*for(let invoiceId in  this.listOfInvoiceIds){
            this.invoiceIds = this.listOfInvoiceIds[invoiceId]+'-'+this.invoiceIds;
        }*/
        console.log('totalAmount : '+this.totalAmount+' listOfInvoiceIds : '+this.listOfInvoiceIds);
    }
    handlePaidInvoiceSelection(event){
        let isChecked = event.target.checked;
        let item_id = event.target.value;
        console.log('handleInvoiceSelection isChecked :'+isChecked+' item_id:'+item_id);
        
        for(let unPaid in this.paidInvoiceData){
            if(this.paidInvoiceData[unPaid].Id === item_id){
                console.log('Matched Invoice.');
                if(isChecked){
                    const urlWithParameters = window.location.origin+'/ECReach/apex/PolicyInvoice?policyID='+this.currentPolicyID+'&invoiceId='+item_id;
                    window.open(urlWithParameters);
                }
            }
        }
        console.log('totalAmount : '+this.totalAmount+' listOfInvoiceIds : '+this.listOfInvoiceIds);
    }
    handlePaymentSelection(event){
        let isChecked = event.target.checked;
        let item_id = event.target.value;
        console.log('handleInvoiceSelection isChecked :'+isChecked+' item_id:'+item_id);
        if(!item_id){
            console.log('Payment Not Created Yet');
        }
        for(let unPaid in this.paidInvoiceData){
            if(this.paidInvoiceData[unPaid].Id === item_id){
                console.log('Matched Invoice.');
                if(isChecked){
                    const urlWithParameters = window.location.origin+'/ECReach/apex/Payment_Receipt?InvoiceId='+item_id;
                    window.open(urlWithParameters);
                }
            }
        }
        console.log('totalAmount : '+this.totalAmount+' listOfInvoiceIds : '+this.listOfInvoiceIds);
    }
    handleCheckboxChange(event) {
        console.log(event.currentTarget.name, event.currentTarget.checked)
        if (event.currentTarget.checked) {
            this.showCheckboxError = false
        }
        if (event.currentTarget.name == "checkbox1"){
            this.checkbox1Value = event.currentTarget.checked ? true : false
        }
    }
    handleScroll(event) {
        console.log('handleScroll : ');
        this.btnDisabled = event.target.scrollTop + 30 >= (event.target.scrollHeight - event.target.offsetHeight) ? false : true
        this.disableNextClass = event.target.scrollTop + 30 >= (event.target.scrollHeight - event.target.offsetHeight) ? "" : "disabled"
        console.log('handleScroll btnDisabled : '+this.btnDisabled+' disableNextClass:'+this.disableNextClass);
    }
    /*handelInvoiceIdCapture(){
        storeTheInvoiceID({
            invoiceList : this.listOfInvoiceIds
        }).then(data => {
            console.log('storeTheInvoiceID success :'+JSON.stringify(data));
            if(data){
                console.log('Successfully stored the invoice id in Ecic Settings.');
            }else{
                console.error('Error while updating Ecic Settings');
            }
        }).catch(error => {
            console.error('Error : '+error.toString()+' '+JSON.stringify(error));
        });
    }*/
    alertUserForGLoabalPayRedirect(event){
        let y = confirm('You will be re-directed to the payment gateway. Are you sure you want to proceed?');
        console.log('y : '+y);
        if(y){
            this.redirectToPaymentPage();
        }
    }
    redirectToPaymentPage() {
        console.log('Proceed To Pay Page checkbox1Value:'+this.checkbox1Value+' lastSelectedInvoiceId :'+this.lastSelectedInvoiceId);
        
        console.log('proceed further')
        //this.handelInvoiceIdCapture();
        if(this.checkbox1Value){
            this.vfPageUrl = 'https://'+this.domainBaseURL+'/ECReach/apex/HostedPaymentPage?invoiceID='+this.lastSelectedInvoiceId+'&language='+this.language;
        
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: this.vfPageUrl
                }
            },
            true // Replaces the current page in your browser history with the URL
            )
            
            
        }else{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Please Accept the Terms and Conditions.',
                    message: '',
                    mode : '',
                    variant: 'error'
                })
            );
        }
       

    }
    proceedToPay(event){
        console.log('Limited Access Check : '+this.isLimitedAccess);
        if(!this.isLimitedAccess){
            if(this.isPolicyValid){

                this.showPaymentTermsAndCOnditions = true;
            }else if(!this.isPolicyValid && this.isPolTerminationWithinSixMonth && this.isProductSBP){
                console.log('Policy is terminated but within 6 month.');
                this.showPaymentTermsAndCOnditions = true;
            }else {
                console.log('Policy is terminated and more than 6 month.');
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Policy is terminated.',
                        message: 'Your policy is terminated. You are not allowed to perform this action.',
                        mode : 'sticky',
                        variant: 'error'
                    })
                );
            } 
            
        }else{
            console.log('Policy Holder account is deactivated.');
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Your have limited access.',
                    message: 'Your account is deactivated.',
                    mode : 'sticky',
                    variant: 'error'
                })
            );
        }
        
        
    }
    showPrevious(event){
        this.showPaymentTermsAndCOnditions = false;
        this.checkbox1Value = false;
        this.btnDisabled = true;
        this.disableNextClass = 'disable';
    }
}