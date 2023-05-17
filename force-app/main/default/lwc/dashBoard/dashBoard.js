import { api, LightningElement, track, wire } from 'lwc';
import getPolicyDetails from '@salesforce/apex/ClPolicy.getPolicyDetails';
import getCLListByPolicy from '@salesforce/apex/CLApplicationRecord.getCLListByPolicy';
import getPolicyHolder from '@salesforce/apex/ClPolicy.getPolicyHolder';
import UsrId from '@salesforce/user/Id';
import getEvents from '@salesforce/apex/EventManagement.getEvents';
import getPendingCustomEventList from '@salesforce/apex/EventManagement.getPendingCustomEventList';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import FullCalendarJS from '@salesforce/resourceUrl/FullCalendarJS';
import getFeedItems from '@salesforce/apex/FeedItemManagement.getFeedItems';
import { createRecord, updateRecord } from 'lightning/uiRecordApi';
import getComanyInfo from '@salesforce/apex/CompanyDetails.getComanyInfo';
// import createFeed from '@salesforce/apex/FeedItemManagement.createFeed';
// import getComments from '@salesforce/apex/FeedItemManagement.getComments';
// import createFeedComment from '@salesforce/apex/FeedItemManagement.createFeedComment';
//import getTasks from '@salesforce/apex/TaskManagement.getTasks';
import getCustomEventList from '@salesforce/apex/EventManagement.getCustomEventList';
import Company_Name from '@salesforce/label/c.Company_Name';
import Current_Policy from '@salesforce/label/c.Current_Policy';
import Policy_Number from '@salesforce/label/c.Policy_Number';
import Effective_Date from '@salesforce/label/c.Effective_Date';
import Renewal_Date from '@salesforce/label/c.Renewal_Date';
import Reminder from '@salesforce/label/c.Reminder';
import Policy from '@salesforce/label/c.Policy';
import To_do_List from '@salesforce/label/c.To_do_List';
import E_Communication from '@salesforce/label/c.E_Communication';
import Credit_Limit_Approval_Process_Status from '@salesforce/label/c.Credit_Limit_Approval_Process_Status';
import Application_Received from '@salesforce/label/c.Application_Received';
import Gathering_Buyer_Credit_Information from '@salesforce/label/c.Gathering_Buyer_Credit_Information';
import Application_under_Assessment from '@salesforce/label/c.Application_under_Assessment';
import Gathering_Additional_Buyer_Credit_Information from '@salesforce/label/c.Gathering_Additional_Buyer_Credit_Information';
import Assessment_Completed from '@salesforce/label/c.Assessment_Completed';
import getProposalList from '@salesforce/apex/OnboardingCreateSiteUser.getProposalList'
import getQuotationList from '@salesforce/apex/OnboardingCreateSiteUser.getQuotationList'
import getBuyerVettingList from '@salesforce/apex/OnboardingCreateSiteUser.getBuyerVettingList'
import Quotations from '@salesforce/label/c.Quotations';
import Outstanding_Policy_Applications from '@salesforce/label/c.Outstanding_Policy_Applications';
import HKECIC_Calendar from '@salesforce/label/c.HKECIC_Calendar';
import Issue_Date from '@salesforce/label/c.Issue_Date';
import Quotation_Number from '@salesforce/label/c.Quotation_Number';
import Policy_Type from '@salesforce/label/c.Policy_Type';
import Status from '@salesforce/label/c.Status';
import View from '@salesforce/label/c.View';
import Application_Date from '@salesforce/label/c.Application_Date';
import Application_Number from '@salesforce/label/c.Application_Number';
import Upcoming_Event from '@salesforce/label/c.Upcoming_Event';
import Face_to_face_appointment from '@salesforce/label/c.Face_to_face_appointment';
import Create_a_new_policy_application from '@salesforce/label/c.Create_a_new_policy_application';
import { NavigationMixin } from 'lightning/navigation';
import basePath from '@salesforce/community/basePath';


export default class DashBoard extends NavigationMixin(
    LightningElement
) {
    @track label = {
        Company_Name,
        Current_Policy,
        Policy_Number,
        Effective_Date,
        Renewal_Date,
        Reminder,
        Policy,
        To_do_List,
        E_Communication,
        Credit_Limit_Approval_Process_Status,
        Application_Received,
        Gathering_Buyer_Credit_Information,
        Application_under_Assessment,
        Gathering_Additional_Buyer_Credit_Information,
        Assessment_Completed,
        Quotations,
        Outstanding_Policy_Applications,
        HKECIC_Calendar,
        Issue_Date,
        Quotation_Number,
        Policy_Type,
        Status,
        View,
        Application_Date,
        Application_Number,
        Upcoming_Event,
        Face_to_face_appointment,
        Create_a_new_policy_application

    }
    @track progress = 'slds-progress-bar__value progress3';
    @api accId = '';
    @track account_name = '';
    @track policy_no = '';
    @track policy_type = '';
    @track effective_date = '';
    @track has_rendered = false;
    @track cl_list = [];
    @track policy_id = '';
    renewal_date
    @track tempReturnedEvents = [];
    @track returnedEvents = [];
    @track finalEvents = [];
    @track showf2fModal = false;
    @track feedItems = [];
    @track task_list = [];
    @api selectedEvent = [];
    @track showf2fUpdateModal = false;
    @track show_welcome_modal = false;
    @track href = '#';
    UsrId = UsrId;
    pageReference;
    handleUpdateEvent(e) {
        var selectedRow = e.currentTarget;
        var key = selectedRow.dataset.id;
        let self = this;
        this.returnedEvents.map(function (each_event, i) {
            if (each_event.Id === key) {
                //console.log('selected event=', JSON.stringify(each_event));
                self.selectedEvent = each_event;
            }
        });
        this.showf2fUpdateModal = true;
        //console.log('showf2fUpdateModal=', this.showf2fUpdateModal);
    }
    closef2fupdatemodal(e) {
        this.showf2fUpdateModal = false;
        this.callgetEvent();
    }
    getCLList(policyId) {
        getCLListByPolicy({
            policy_id: policyId
        })
            .then((result) => {
                //console.log("cl_list=", result);
                //this.cl_list = result;
                let self = this;
                result.map(function (each_cl, index) {
                    if (each_cl.CL_Status__c === 'Under Processing') {
                        self.cl_list.push({
                            ...each_cl,
                            'class': 'slds-progress-bar__value progress3'
                        })
                    } else if (each_cl.CL_Status__c === 'Valid') {
                        self.cl_list.push({
                            ...each_cl,
                            'class': 'slds-progress-bar__value progress5'
                        })
                    } else {
                        self.cl_list.push({
                            ...each_cl,
                            'class': 'slds-progress-bar__value progress2'
                        })
                    }
                });
                //console.log("updated cl ist=", this.cl_list);
            })
            .catch((error) => {

                //console.log(error);
            });
    }
    getPolicy() {
        //console.log("getPolicy method");
        getPolicyDetails({
            acc_id: this.accId
        })
            .then((result) => {
                //console.log("Policy details=", JSON.stringify(result));
                this.account_name = result.Exporter__r.Name;
                this.policy_no = result.Legacy_Customer_Number__c;
                this.policy_type = result.Product__r.Name;
                this.effective_date = result.Commencement_Date__c;
                this.policy_id = result.Id;
                this.renewal_date = result.Policy_Renewal_Date__c;
                this.getCLList(this.policy_id);
            })
            .catch((error) => {

                //console.log("error");
                console.error('e.name => ' + error.name);
                console.error('e.message => ' + error.message);
                console.error('e.stack => ' + error.stack);
                console.error(error);
            });
    }
    initialiseFullCalendarJs() {
        this.finalEvents = [];
        //console.log('initialiseFullCalendarJs');
        //console.log('this.returnedEvents=', JSON.stringify(this.returnedEvents));
        for (var i = 0; i < this.returnedEvents.length; i++) {
            //console.log('event subject=' + this.returnedEvents[i].Subject);
            var localstartDate = new Date(this.returnedEvents[i].StartDateTime);
            var localendDate = new Date(this.returnedEvents[i].EndDateTime);
            this.finalEvents.push({
                'title': this.returnedEvents[i].Subject,
                'start': localstartDate,
                'end': localendDate,
                'id': this.returnedEvents[i].Id
            });
        }
        /*this.finalEvents.push({
            'title': 'Test event',
            'start': '2021-05-13 13:00:00',
            'end': '2021-05-13 15:00:00',
            'id': '123456'
        });*/
        const ele = this.template.querySelector('div.fullcalendarjs');
        // eslint-disable-next-line no-undef
        $(ele).fullCalendar({
            header: {
                left: 'prev,next',
                center: 'title',
                right: 'month,basicWeek,basicDay'
            },
            // defaultDate: '2020-03-12',
            defaultDate: new Date(), // default day is today
            navLinks: true, // can click day/week names to navigate views
            editable: true,
            eventLimit: true, // allow "more" link when too many events
            events: this.finalEvents
        });
    }
    formatDate(date) {
        var curDate = new Date(date);
        if (curDate.getMonth() == 11) {
            var current = new Date(curDate.getFullYear() + 1, 0, curDate.getDate());
        } else {
            var current = new Date(curDate.getFullYear(), curDate.getMonth() + 1, curDate.getDate());
        }

        const today = current.getFullYear() + '-' + String(current.getMonth()).padStart(2, '0') + '-' + String(current.getDate()).padStart(2, '0');
        return today
    }
    callgetEvent() {
        getEvents({ 'accid': this.accId })
            .then((result) => {
                console.log("returned Event", JSON.stringify(result));
                this.tempReturnedEvents = result;
                this.callCustomEvent();

            })
            .catch((error) => {
                //console.log('error=', error);
            });
    }
    callCustomEvent() {
        // let customEventList = [];
        this.returnedEvents = [];
        let self = this;
        let formatted_date = '';
        let temp_another_events = [];
        getCustomEventList({ 'eventList': this.tempReturnedEvents })
            .then((result) => {
                console.log('Returned custom events::', JSON.stringify(result));
                this.tempReturnedEvents.map(function (each_event, i) {
                    result.map(function (each_cust_event, index) {
                        formatted_date = self.formatDate(each_event.StartDateTime);
                        if ((each_event.Id).trim() === (each_cust_event.Event_Id__c).trim()) {
                            self.returnedEvents.push({
                                ...each_event,
                                formatted_date: formatted_date,
                                is_user_approved: true
                            });
                            delete self.tempReturnedEvents[i];
                        }
                    });
                });
                // this.tempReturnedEvents.filter(function(val){if((val!==null)&&(val!=='')&&(val!=='null'))return val}).join(",")
                // _.compact(this.tempReturnedEvents).join(", ");
                // _.filter(this.tempReturnedEvents, function(val) { return val !== null; }).join(", ");
                this.tempReturnedEvents.map(function (each_event, i) {
                    formatted_date = self.formatDate(each_event.StartDateTime);
                    if ((each_event !== null) && (each_event !== 'null') && (each_event.length !== 0)) {
                        self.returnedEvents.push({
                            ...each_event,
                            formatted_date: formatted_date,
                            is_user_approved: false
                        });
                    }
                });
                // this.returnedEvents.reverse();
                this.returnedEvents.reverse();
                // this.returnedEvents=temp_another_events;
                // this.returnedEvents=[...this.returnedEvents]
                //console.log('After deletion tempReturnedEvents :', JSON.stringify(this.tempReturnedEvents));
                //console.log('returnedEvents ***** :', JSON.stringify(this.returnedEvents));
                //result.map(function())
                this.initialiseFullCalendarJs();
            })
            .catch((error) => {
                //console.log('error getcustomevent=', JSON.stringify(error));
                console.error('error getcustomevent=', JSON.stringify(error));
            });
    }
    callgetPendingCustomEventList() {
        getPendingCustomEventList({ 'accid': this.accId })
            .then((result) => {
                //console.log("getPendingCustomEventList::", JSON.stringify(result));

            })
            .catch((error) => {
                //console.log('error create feed=', JSON.stringify(error));
            });
    }
    /*createFeedItem(){
        createFeed({ 'accid': this.accId })
            .then((result) => {
                //console.log("returned created FeedItems", JSON.stringify(result));
                
            })
            .catch((error) => {
                //console.log('error create feed=', JSON.stringify(error));
            });
    }*/
    /*callcreateFeedComment(){
        //console.log("callcreateFeedComment");
        createFeedComment()
            .then((result) => {
                //console.log("returned created Feedcomments", JSON.stringify(result));
                
            })
            .catch((error) => {
                //console.log('error create comment=', JSON.stringify(error));
            });
    }*/
    callgetFeedItems() {
        //console.log('callgetFeedItems');
        getFeedItems({ 'accid': this.accId })
            .then((result) => {
                let self = this;
                //console.log("returned FeedItems", JSON.stringify(result));
                result.map(function (each_res, index) {
                    // each_res.Title=each_res.Title.replace('<p>','');
                    // each_res.Title=each_res.Title.replace('</p>','');
                    // each_res.Body=each_res.Body.replace('<p>','');
                    // each_res.Body=each_res.Body.replace('</p>','');
                    self.feedItems.push(each_res);
                });
                //this.feedItems = result;
            })
            .catch((error) => {
                //console.log('error=', error);
            });
    }
    /*callGetComments(){
        //console.log('callGetComments');
        getComments()
        .then((result) => {
            let self = this;
            //console.log("returned comments", JSON.stringify(result));
            
        })
        .catch((error) => {
            //console.log('error getcomments=', error);
        });
    }*/
    callGetTasks() {
        //console.log('callgettasks accid=' + this.accId);
        getTasks({ 'acc_id': this.accId })
            .then((result) => {
                //console.log('callGetTasks result');
                //console.log("returned tasks", JSON.stringify(result));
                this.task_list = result;
            })
            .catch((error) => {
                //console.log('gettask Error: ' + JSON.stringify(error));
                console.error(error.toString(), JSON.stringify(error));
            });
    }

    loadPromise() {
        Promise.all([
            loadScript(this, FullCalendarJS + '/FullCalendarJS/jquery.min.js'),
            loadScript(this, FullCalendarJS + '/FullCalendarJS/moment.min.js'),
            loadScript(this, FullCalendarJS + '/FullCalendarJS/fullcalendar.min.js'),
            loadStyle(this, FullCalendarJS + '/FullCalendarJS/fullcalendar.min.css'), ,
            // loadStyle(this, FullCalendarJS + '/fullcalendar.print.min.css')
        ])
            .then(() => {
                // Initialise the calendar configuration
                this.callgetEvent();

                //this.createFeedItem();


            })
            .catch(error => {
                // eslint-disable-next-line no-console
                console.error({
                    message: 'Error occured on FullCalendarJS',
                    error
                });
            })
    }
    openF2FModal() {
        this.showf2fModal = true;
    }
    closef2fmodal() {
        this.showf2fModal = false;
    }
    closewelcomemodal() {
        this.show_welcome_modal = false;
    }

    callCompanyDetails() {
        // commented by Arindam Dec17-2021 as not in day1 requirement
        // getComanyInfo({ 'acc_id': this.accId })
        //     .then((result) => {
        //         //console.log('company Details=', JSON.stringify(result));
        //         //console.log('Completed_Tutorial__c=',result.Completed_Tutorial__c);
        //         this.show_welcome_modal = result.Completed_Tutorial__c ? false : true;
        //     }).catch((error) => {
        //         //console.log(error);
        //     });
    }

    renderedCallback() {
        //console.log("renderedCallback");
        ////console.log("UsrId ::======" + UsrId);
        if (!this.has_rendered) {
            this.has_rendered = true;
            //console.log('userid::', this.UsrId);
            getPolicyHolder({ 'user_id': this.UsrId })
                .then((result) => {
                    //console.log('accountId===', result);
                    this.accId = result;
                    this.getPolicy();
                    this.callCompanyDetails()
                    this.loadPromise();
                    this.callgetFeedItems();
                    this.callGetTasks();
                    // this.callGetComments();
                    //this.callcreateFeedComment();
                }).catch((error) => {

                    //console.log(error);
                });
            if (this.accId !== "") {

            }
            //console.log("before promise call");


        }
    }

    @track quoteColumns = [
        { label: this.label.Issue_Date, fieldName: 'Issue_Date__c', type: 'date' },
        { label: this.label.Quotation_Number, fieldName: 'Name' },
        { label: this.label.Policy_Type, fieldName: 'ProductName' },
        { label: this.label.Status, fieldName: 'Status__c' },
        {
            label: this.label.View,
            type: 'button-icon', typeAttributes: {
                iconName: 'utility:preview',
                label: this.label.View,
                name: 'view',
                variant: 'bare',
                alternativeText: 'view',
                disabled: false
            }
        },
        // {
        //     label: 'Revice',
        //     type: 'button-icon', typeAttributes: {
        //         iconName: 'utility:edit',
        //         label: 'Revice',
        //         name: 'revice',
        //         variant: 'bare',
        //         alternativeText: 'revice',
        //         disabled: false
        //     }
        // }
    ];
    @track proposalColumns = [
        { label: this.label.Application_Date, fieldName: 'CreatedDate', type: 'date' },
        { label: this.label.Application_Number, fieldName: 'Name' },
        { label: this.label.Policy_Type, fieldName: 'ProductName' },
        { label: this.label.Status, fieldName: 'Status__c' },
        {
            label: this.label.View,
            type: 'button-icon', typeAttributes: {
                iconName: 'utility:preview',
                label: 'View',
                name: 'view',
                variant: 'bare',
                alternativeText: 'view',
                disabled: false
            }
        }
    ];
    @track buyerVettingColumns = [
        { label: this.label.Application_Date, fieldName: 'CreatedDate', type: 'date' },
        { label: this.label.Application_Number, fieldName: 'Name' },
        { label: "Buyer Name", fieldName: 'Buyer_Name__c' },//saswata please change label: Arindam 
        { label: "Buyer Country", fieldName: 'Buyer_Country__c' },
        { label: this.label.Status, fieldName: 'Status__c' },

    ];
    handleRowActionQuote(event) {
        console.log('handleRowActionQuote');
        const actionName = event.detail.action.name;
        // console.log("actionName::", actionName);
        const row = event.detail.row;
        console.log("event detail", JSON.stringify(row));
        switch (actionName) {
            case 'view':
                this.showQuoteDetails(row);
                break;
            case 'revice':
                this.reviceQuotation(row);
                break;
            default:
        }
    }
    handleRowActionProposal(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'view':
                this.showRowDetails(row);
                break;
            default:
        }
    }
    showRowDetails(data) {
        try {
            console.log("showQuoteDetails::", JSON.stringify(data));
            const redUrl = './application-details' + '?id=' + data.Id
            console.log("redirecting to :", redUrl);

            window.location.href = redUrl
        } catch (error) {
            console.error(error);
        }
    }
    showQuoteDetails(data) {
        try {
            console.log("showQuoteDetails::", JSON.stringify(data));
            let addStatus = data.Status__c == 'Pending for acceptance' ? '&st=' + 'pfa' : ''
            const redUrl = './quote-detail' + '?id=' + data.Id + addStatus
            console.log("redirecting to :", redUrl);
            this.pageReference = {
                type: 'standard__webPage',
                attributes: {
                    url: basePath + redUrl
                }
            };
            if (this.pageReference) {
                this[NavigationMixin.GenerateUrl](this.pageReference).then(
                    (url) => {
                        this.href = url;
                    }
                );
            }
            console.log('this.href=', this.href);
            window.location.href = redUrl
        } catch (error) {
            console.error(error);
        }
    }

    reviceQuotation(data) {
        //console.log("reviceQuotation::", JSON.stringify(data));
        // const redUrl = '/ECReach/s/onboarding' + '?createNewProposal=true'
        const redUrl = '/ECReach/s/onboarding' + '?id=' + data.Id + '&rq=true'
        //console.log("redirecting to :", redUrl);
        window.location.href = redUrl
    }

    showCreateAnotherProposalButton
    @track proposalData = []
    @track quoteData = []
    @track buyerVettingData = []

    @wire(getProposalList, { usrId: '$UsrId' })
    handleProposalList({ error, data }) {
        console.log('####getproposal data=' + JSON.stringify(data))
        let set = new Set();
        if (data) {
            this.proposalData = data.filter(el => (el.Product__r)).map(el => {
                set.add(el.Product__r.Name)
                return { ...el, ProductName: el.Product__r.Name }
            })
            console.log("set:::", set.size);
            this.showCreateAnotherProposalButton = set.size >= 3 ? false : true
            //console.log('####getproposal list data=' + JSON.stringify(this.proposalData))
        }
        if (error) {
            console.error('####getproposal list error=' + JSON.stringify(error))

        }
    }
    @wire(getQuotationList, { usrId: '$UsrId' })
    handleQuotationList({ error, data }) {
        if (data) {
            this.quoteData = data.filter(el => (el.Product__r)).map(el => {
                return { ...el, ProductName: el.Product__r.Name }
            })
            //console.log('####getquotationlist data=' + JSON.stringify(this.quoteData))
        }
        if (error) {
            console.error('####getquotationlist error=' + JSON.stringify(error))

        }
    }
    @wire(getBuyerVettingList, { usrId: '$UsrId' })
    handleBuyervettingList({ error, data }) {
        if (data) {
            console.log('####getBuyerVettingList data=' + JSON.stringify(data))
            this.buyerVettingData = data
        }
        if (error) {
            console.error('####getBuyerVettingList error=' + JSON.stringify(error))

        }
    }
    createNewProposal() {
        const redUrl = '/ECReach/s/onboarding' + '?createNewProposal=true'
        //console.log("redirecting to :", redUrl);
        window.location.href = redUrl
    }

}