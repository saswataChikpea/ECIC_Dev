import { LightningElement, track, wire, api } from 'lwc';
import UsrId from '@salesforce/user/Id';
import getComanyInfo from '@salesforce/apex/CompanyDetails.getComanyInfo';
import getPolicyHolder from '@salesforce/apex/ClPolicy.getPolicyHolder';
import getPolicyDetails from '@salesforce/apex/ClPolicy.getPolicyDetails';
import getContactInfo from '@salesforce/apex/CompanyDetails.getContactInfo';
import { createRecord, updateRecord } from 'lightning/uiRecordApi';
import CONTACT_ID from '@salesforce/schema/Contact.Id';
import CONTACT_IS_ACTIVE from '@salesforce/schema/Contact.Is_Active__c';
import CONTACT_PRIMARY from '@salesforce/schema/Contact.Primary_Contact__c';
import CONTACT_SMS_NOTIF from '@salesforce/schema/Contact.Enable_SMS_Notification__c';
import CONTACT_EMAIL_NOTIF from '@salesforce/schema/Contact.Enable_Email_Notification__c';
import getAuthorisedPersons from '@salesforce/apex/CompanyDetails.getAuthorisedPersons';
import getBeneficiary from '@salesforce/apex/CompanyDetails.getBeneficiary';
import getDirector from '@salesforce/apex/CompanyDetails.getDirector';
import createSpecialContact from '@salesforce/apex/CompanyDetails.createSpecialContact';
import removeContact from '@salesforce/apex/CompanyDetails.removeContact';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import UpdatePrimaryContact from '@salesforce/apex/CompanyDetails.UpdatePrimaryContact';
import getBRDocuments from '@salesforce/apex/CompanyDetails.getBRDocuments';
import Company_Information from '@salesforce/label/c.Company_Information';
import Registered_Company_Name from '@salesforce/label/c.Registered_Company_Name';
import Registered_Company_Address from '@salesforce/label/c.Registered_Company_Address';
import Language_Of_Correspondence from '@salesforce/label/c.Language_Of_Correspondence';
import Legal_Type from '@salesforce/label/c.Legal_Type';
import Goods_Services from '@salesforce/label/c.Goods_Services';
import Business_Registration_Number from '@salesforce/label/c.Business_Registration_Number';
import Correspondence_Company_Address from '@salesforce/label/c.Correspondence_Company_Address';
import Office_Telephone_No from '@salesforce/label/c.Office_Telephone_No';
import Authorised_Person from '@salesforce/label/c.Authorised_Person';
import Beneficiary_Owner from '@salesforce/label/c.Beneficiary_Owner';
import Director from '@salesforce/label/c.Director';
import Main_Contact_Person from '@salesforce/label/c.Main_Contact_Person';
import Surname from '@salesforce/label/c.Surname';
import First_Name from '@salesforce/label/c.First_Name';
import Title from '@salesforce/label/c.Title';
import Contact_Number from '@salesforce/label/c.Contact_Number';
import Email from '@salesforce/label/c.Email';
import Enable_email_notifications from '@salesforce/label/c.Enable_email_notifications';
import Edit from '@salesforce/label/c.Edit';
import Add from '@salesforce/label/c.Add';
import Business_Registration_Certificate_Record from '@salesforce/label/c.Business_Registration_Certificate_Record';
import Document  from '@salesforce/label/c.Document';
import Received_Date from '@salesforce/label/c.Received_Date';
import BRC_Expiry_Date from '@salesforce/label/c.BRC_Expiry_Date';
import Company_Name from '@salesforce/label/c.Company_Name';
import Login_Account from '@salesforce/label/c.Login_Account';
import Policy_Number from '@salesforce/label/c.Policy_Number';
import Registered_District from '@salesforce/label/c.Registered_District';
import Registered_Territory from '@salesforce/label/c.Registered_Territory';
import Correspondence_District from '@salesforce/label/c.Correspondence_District';
import Correspondence_Territory from '@salesforce/label/c.Correspondence_Territory';
import Bank_account from '@salesforce/label/c.Bank_account';
import Select_Legal_Type from '@salesforce/label/c.Select_Legal_Type';
import Select_Goods_or_Services from '@salesforce/label/c.Select_Goods_or_Services';

// import testSme from '@salesforce/apex/sendEmailWithoutSharing.testSme';

export default class CompanyProfile extends LightningElement {

    @track label = {
        Company_Information , Registered_Company_Name , Registered_Company_Address , Language_Of_Correspondence,
        Legal_Type,Goods_Services,Business_Registration_Number,Correspondence_Company_Address,Office_Telephone_No,
        Authorised_Person, Beneficiary_Owner,Director,Main_Contact_Person,Surname,First_Name,Title,
        Contact_Number,Email,Enable_email_notifications,Edit,Add,Business_Registration_Certificate_Record,Document,
        Received_Date,BRC_Expiry_Date,Company_Name,Policy_Number,Login_Account,Registered_District,Registered_Territory,Correspondence_District,
        Correspondence_Territory,Bank_account,Select_Legal_Type,Select_Goods_or_Services
    }

    @track benificiary_owners = [];
    @track is_render_firsttime = false;
    @track show_save_btn = false;
    @track auth_person_save_btn = false;
    @track director_save_btn = false;
    @track brc_records = [];
    @track show_edit_modal = false;
    @api accId = "";
    @api company_info = [];
    @track policy_details = [];
    @track account_name = "";
    @track policy_no = "";
    @track policy_type = "";
    @track contact_info = [];
    @track show_checkbox_spinner = false;
    @track enable_primary_contact = false;
    // @track primary_contact_count = 0;
    @track contact_edit_modal = false;
    @track edit_contact_id = "";
    @track show_contact_create_modal = false;
    @track authorised_person_list = [];
    @track show_authorised_person_list = false;
    @track show_auth_person_create_modal = false;
    @track removed_beneficiary = [];
    @track removed_auth_person = [];
    @track directors_list = [];
    @track remove_directors = [];
    @track registered_address123 = '';
    @track correspondence_address123 = '';
    @track policy_available = false;




    UsrId = UsrId;
    // @wire(getContactInfo,{acc_id:'$accId'}) contacts;
    /*@wire(testSme) 
    callgetProduct({ error, data }) {
        if (data) {
            console.log("Userdata:" + JSON.stringify(data));            
        }
        else {
            console.log('error::', JSON.stringify(error));
        }
    }*/
    handlePrimaryContact(event) {
        //consele.log('All contacts:', JSON.stringify(this.contact_info));
        let other_contact_Ids = [];
        // this.show_checkbox_spinner = true;
        if (!confirm("Do you like to change primary contact?")) {
            //consele.log('"::::No');
            var selectedRow = event.currentTarget;
            var key = selectedRow.dataset.id;
            //consele.log('key=', key);
            /*this.contact_info.map(function(each_contact,i){
                if(each_contact.Id === key){
                    //consele.log('matched contact Id=',key);
                    each_contact.Primary_Contact__c = false;
                }
            });
            inputField = this.template.querySelector(`[data-id='${key}']`);
            inputField.checked = false;*/
            this.show_checkbox_spinner = true;
            this.getContact();
            // return false;
        } else {
            //consele.log('::::Yes');
            //Write your confirmed logic
            this.show_checkbox_spinner = true;
            var selectedRow = event.currentTarget;
            var key = selectedRow.dataset.id;
            this.contact_info.map(function (each_contact, i) {
                other_contact_Ids.push(each_contact.Id);
            });
            let index = other_contact_Ids.indexOf(key);
            other_contact_Ids.splice(index, 1);
            //consele.log('New Primary contact Id=', key);
            //consele.log('remaining contact ids=', JSON.stringify(other_contact_Ids));
            //UpdatePrimaryContact
            UpdatePrimaryContact({
                primary_contact_id: key,
                other_contacts: other_contact_Ids
            })
                .then((result) => {
                    this.show_checkbox_spinner = false;
                    //consele.log("Primary contact update result:" + result);
                    this.getContact();
                })
                .catch((error) => {
                    //consele.log("Error UpdatePrimaryContact:", JSON.stringify(error));
                    console.error("Error UpdatePrimaryContact:", JSON.stringify(error));
                });
        }

        /*
        this.show_checkbox_spinner = true;
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        const fields = {};
        fields[CONTACT_ID.fieldApiName] = key;
        fields[CONTACT_PRIMARY.fieldApiName] = event.target.checked;
        if (!event.target.checked) {
            fields[CONTACT_SMS_NOTIF.fieldApiName] = false;
        }
        let is_updated = this.updateContactField(fields, 'primary_contact', event.target.checked, key);
        //consele.log('is_updated=' + is_updated);
        //consele.log('Selected Id=', key);
        //consele.log('event.target.checked=', event.target.checked);
        */
    }
    handleAuthAdd(e) {
        this.show_auth_person_create_modal = true;
    }
    closecreateauthmodal(e) {
        this.show_auth_person_create_modal = false;
    }
    handleEmailNotif(event) {

        this.show_checkbox_spinner = true;
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        const fields = {};
        fields[CONTACT_ID.fieldApiName] = key;
        fields[CONTACT_EMAIL_NOTIF.fieldApiName] = event.target.checked;
        let is_updated = this.updateContactField(fields, 'emailnotif', event.target.checked, key);

        //consele.log('email notif Selected Id=', key);
        //consele.log('event.target.checked=', event.target.checked);
    }
    handleSmsNotif(event) {
        this.show_checkbox_spinner = true;
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        const fields = {};
        fields[CONTACT_ID.fieldApiName] = key;
        fields[CONTACT_SMS_NOTIF.fieldApiName] = event.target.checked;
        let is_updated = this.updateContactField(fields, 'smsnotif', event.target.checked, key);

        //consele.log('sms notif Selected Id=', key);
        //consele.log('event.target.checked=', event.target.checked);
    }
    updateContactField(fields, field_type, updated_val, key) {

        try {
            const recordInput = { fields };
            updateRecord(recordInput)
                .then(() => {
                    // this.show_checkbox_spinner = false;
                    //consele.log('Contact updated');
                    this.getContact();
                    /*if (field_type ==='primary_contact') {                        
                            this.contact_info.map(function (each_contact, i) {
                                if (each_contact.Id === key) {
                                    each_contact.Primary_Contact__c = updated_val;
                                    if (!updated_val) {
                                        each_contact.Enable_SMS_Notification__c = false;
                                    }
                                }                                
                            });                            
                            //consele.log('this.contact_info after update' + JSON.stringify(this.contact_info));                        
                    } else if (field_type === 'emailnotif'){
                        this.contact_info.map(function (each_contact, i) {
                            if (each_contact.Id === key) {
                                each_contact.Enable_Email_Notification__c = updated_val;
                            }                                
                        });
                    } else if (field_type === 'smsnotif'){
                        this.contact_info.map(function (each_contact, i) {
                            if (each_contact.Id === key) {
                                each_contact.Enable_SMS_Notification__c = updated_val;
                            }                                
                        });
                    }*/
                })
                .catch(error => {
                    this.show_checkbox_spinner = false;
                    //consele.log('error in contact update', JSON.stringify(error));
                });
        } catch (error) {
            //consele.log('exception=', JSON.stringify(error));
            console.error(error.toString() + " " + error);
        }

    }
    handleEdit(e) {
        this.show_edit_modal = true;
    }
    closeeditmodal(e) {
        this.show_edit_modal = false;
        this.callCompanyDetails();
    }
    removeRow(event) {
        let self = this;
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        //consele.log(JSON.stringify(selectedRow));
        //consele.log(JSON.stringify(selectedRow.dataset));
        //consele.log('Removed key=', key);
        if (this.benificiary_owners.length > 1) {
            this.benificiary_owners.splice(key, 1);
        } else if (this.benificiary_owners.length == 1) {
            this.benificiary_owners = [];
        }
        if (key.length >= 15) {
            self.removed_beneficiary.push(key);
        }
        this.show_save_btn = true;
    }
    handleBenName(e) {
        var selectedRow = e.currentTarget;
        var key = selectedRow.dataset.id;
        //consele.log('handlebenname key', key);
        this.benificiary_owners[key].Name = e.target.value;
    }
    addRow() {
        // this.index++;
        //var i = JSON.parse(JSON.stringify(this.index));
        // var i = this.index;
        /*this.accountList.push ({
            sobjectType: 'Account',
            Name: '',
            AccountNumber : '',
            Phone: '',
            key : i
        });*/
        // this.inv.key = i;
        // this.benificiary_owners.push(JSON.parse(JSON.stringify(this.inv)));

        // //consele.log('Enter ', JSON.stringify(this.invoiceList));
        var key = this.benificiary_owners.length;
        this.benificiary_owners.push({
            'Name': '',
            'Id': key,
            'editable': true
        });
        this.show_save_btn = true;
    }
    handleAuthPersonName(e) {
        var selectedRow = e.currentTarget;
        var key = selectedRow.dataset.id;
        this.authorised_person_list[key].Name = e.target.value;
    }
    addAuthPersonRow() {
        var key = this.authorised_person_list.length;
        this.authorised_person_list.push({
            'Name': '',
            'Id': key,
            'editable': true
        });
        this.auth_person_save_btn = true;
    }
    removeAuthPersonRow(event) {
        let self = this;
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        //consele.log(JSON.stringify(selectedRow));
        //consele.log(JSON.stringify(selectedRow.dataset));
        //consele.log('Removed key=', key);
        if (this.authorised_person_list.length > 1) {
            this.authorised_person_list.splice(key, 1);
        } else if (this.authorised_person_list.length == 1) {
            this.authorised_person_list = [];
        }
        if (key.length >= 15) {
            self.removed_auth_person.push(key);
        }
        this.auth_person_save_btn = true;
    }
    handleDirectorName(e) {
        var selectedRow = e.currentTarget;
        var key = selectedRow.dataset.id;
        this.directors_list[key].Name = e.target.value;
    }
    addDirectorRow() {
        var key = this.directors_list.length;
        this.directors_list.push({
            'Name': '',
            'Id': key,
            'editable': true
        });
        this.director_save_btn = true;
    }
    removeDirectorRow(event) {
        let self = this;
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;

        if (this.directors_list.length > 1) {
            this.directors_list.splice(key, 1);
            if (key.length >= 15) {
                self.remove_directors.push(key);
            }
            this.director_save_btn = true;
        } else if (this.directors_list.length == 1) {
            // this.directors_list = [];
            this.showToast('There must be at least one director.');
            this.director_save_btn = false;
        }
        
        
    }
    handleDirectorSave() {
        //consele.log('handleDirectorSave=' + JSON.stringify(this.directors_list));
        let added_directors = [];
        let array_location = [];
        for (var i = 0; i < this.directors_list.length; i++) {
            if ((this.directors_list[i].Name.length < 3) || (/[^a-zA-Z\-\/ /]/.test(this.directors_list[i].Name))) {
                added_directors = [];
                this.director_save_btn = true;
                this.showToast('Invalid Director Name');
                return;
            } else {
                this.directors_list[i].editable = false;

                if (this.directors_list[i].Id.toString().length <= 15) {
                    let full_name = this.directors_list[i].Name;
                    //consele.log('full_name=', full_name);
                    let name_array = full_name.trim().split(" ");
                    //consele.log('name_array=', name_array);
                    let last_name = name_array[name_array.length - 1];
                    let first_name = full_name.replace(last_name, "").trim();
                    //consele.log('first_name=', first_name);
                    //consele.log('last_name=', last_name);
                    added_directors.push({
                        'Account__c': this.accId,
                        'firstName': first_name,
                        'lastName': last_name,
                        'Authorised_Person__c': false,
                        'Beneficiary_Owner__c': false,
                        'Director__c': true
                    });
                    // this.directors_list.splice(i, 1);
                    array_location.push(i);
                }
            }
        }
        
        this.director_save_btn = false;
        for (var i = array_location.length -1; i >= 0; i--){
            this.directors_list.splice(array_location[i],1);
        }
        //consele.log('remove_directors==', JSON.stringify(this.remove_directors));
        if (added_directors.length > 0) {
            createSpecialContact({
                cust_json: added_directors
            })
                .then((result) => {
                    //consele.log("createSpecialContact successfully called",JSON.stringify(result));
                    this.showToastSuccess('Saved', 'Change request received, will be applied upon approval');
                })
                .catch((error) => {
                    //consele.log('error==', JSON.stringify(error));
                    console.error('error==', JSON.stringify(error))
                });
        }
        if (this.remove_directors.length > 0) {
            removeContact({
                contact_id: this.remove_directors
            })
                .then((result) => {
                    //consele.log("Deleted successfully");
                    this.showToastSuccess('Saved', 'Change request received, will be applied upon approval');
                })
                .catch((error) => {
                    //consele.log('error==', JSON.stringify(error));
                    console.error('error==', JSON.stringify(error))
                });
        }
    }
    handleAuthPersonSave() {
        //consele.log('handleSaveauth==' + JSON.stringify(this.authorised_person_list));
        let added_authorised_persons = [];
        let array_location = [];
        for (var i = 0; i < this.authorised_person_list.length; i++) {
            if ((this.authorised_person_list[i].Name.length < 3) || (/[^a-zA-Z\-\/ /]/.test(this.authorised_person_list[i].Name))) {
                added_authorised_persons = [];
                this.auth_person_save_btn = true;
                this.showToast('Invalid Authorised Person Name');
                return;
            } else {
                this.authorised_person_list[i].editable = false;
                //consele.log('this.authorised_person_list[i].Id.length=', this.authorised_person_list[i].Id.toString().length);
                if (this.authorised_person_list[i].Id.toString().length <= 15) {
                    let full_name = this.authorised_person_list[i].Name;
                    //consele.log('full_name=', full_name);
                    let name_array = full_name.trim().split(" ");
                    //consele.log('name_array=', name_array);
                    let last_name = name_array[name_array.length - 1];
                    let first_name = full_name.replace(last_name, "").trim();
                    //consele.log('first_name=', first_name);
                    //consele.log('last_name=', last_name);
                    added_authorised_persons.push({
                        'Account__c': this.accId,
                        'Is_Active__c': false,
                        'firstName': first_name,
                        'lastName': last_name,
                        'Authorised_Person__c': true,
                        'Beneficiary_Owner__c': false,
                        'Director__c': false
                    });
                    // this.authorised_person_list.splice(i, 1);
                    array_location.push(i);
                }
            }
        }
        this.auth_person_save_btn = false;
        //consele.log('array_location=',JSON.stringify(array_location));
        for (var i = array_location.length -1; i >= 0; i--){
            this.authorised_person_list.splice(array_location[i],1);
        }
        //consele.log('removed_authorised_person==', JSON.stringify(this.removed_auth_person));
        //consele.log('added_authorised_persons==', JSON.stringify(added_authorised_persons));
        if (added_authorised_persons.length > 0) {
            createSpecialContact({
                cust_json: added_authorised_persons
            })
                .then((result) => {
                    //consele.log("createSpecialContact successfully called");
                    this.showToastSuccess('Saved', 'Change request received, will be applied upon approval');
                })
                .catch((error) => {
                    //consele.log('error==', JSON.stringify(error));
                    console.error('error==', JSON.stringify(error))
                });
        }
        if (this.removed_auth_person.length > 0) {
            removeContact({
                contact_id: this.removed_auth_person
            })
                .then((result) => {
                    //consele.log("Deleted successfully");
                    this.showToastSuccess('Saved', 'Change request received, will be applied upon approval');
                })
                .catch((error) => {
                    //consele.log('error==', JSON.stringify(error));
                    console.error('error==', JSON.stringify(error))
                });
        }
    }
    handleBenificiarySave() {
        //consele.log('handleSave=' + JSON.stringify(this.benificiary_owners));
        let added_beneficiaries = [];
        let array_location = [];
        
        for (var i = 0; i < this.benificiary_owners.length; i++) {
            //consele.log('Name=', this.benificiary_owners[i].Name);
            try {
                if ((this.benificiary_owners[i].Name.length < 3) || (/[^a-zA-Z\-\/ /]/.test(this.benificiary_owners[i].Name))) {
                    added_beneficiaries = [];
                    this.show_save_btn = true;
                    this.showToast('Invalid Beneficiary Name');
                    return;
                } else {
                    this.benificiary_owners[i].editable = false;
                    //consele.log('this.benificiary_owners[i].Id.length=', this.benificiary_owners[i].Id.toString().length);
                    if (this.benificiary_owners[i].Id.toString().length <= 15) {
                        //try{
                        let full_name = this.benificiary_owners[i].Name;
                        let name_array = full_name.trim().split(" ");
                        let last_name = name_array[name_array.length - 1];
                        let first_name = full_name.replace(last_name, "").trim();

                        added_beneficiaries.push({
                            'Account__c': this.accId,
                            'Is_Active__c': false,
                            'firstName': first_name,
                            'lastName': last_name,
                            'Authorised_Person__c': false,
                            'Beneficiary_Owner__c': true,
                            'Director__c': false
                        });
                        array_location.push(i);
                        // this.benificiary_owners.splice(i, 1);
                    }
                }
            } catch (error) {
                //consele.log('error::', JSON.stringify(error));
            }
        }
        //consele.log('array_location=',JSON.stringify(array_location));
        for (var i = array_location.length -1; i >= 0; i--){
            this.benificiary_owners.splice(array_location[i],1);
        }        
        this.show_save_btn = false;
        //consele.log('removed_beneficiary==', JSON.stringify(this.removed_beneficiary));
        //consele.log('added beneficiaries=', JSON.stringify(added_beneficiaries))
        if (added_beneficiaries.length > 0) {
            
            createSpecialContact({
                cust_json: added_beneficiaries
            })
                .then((result) => {
                    //consele.log("createSpecialContact successfully called");
                    this.showToastSuccess('Saved','Change request received, will be applied upon approval');
                })
                .catch((error) => {
                    //consele.log('error==', JSON.stringify(error));
                    console.error('error==', JSON.stringify(error))
                });                
        }
        if (this.removed_beneficiary.length > 0) {
            removeContact({
                contact_id: this.removed_beneficiary
            })
                .then((result) => {
                    //consele.log("Deleted successfully");
                    this.showToastSuccess('Saved', 'Change request received, will be applied upon approval');
                })
                .catch((error) => {
                    //consele.log('error==', JSON.stringify(error));
                    console.error('error==', JSON.stringify(error))
                });
        }
    }
    showToast(msg) {
        const event = new ShowToastEvent({
            title: 'Error',
            message: msg,
            variant: 'error'
        });
        this.dispatchEvent(event);
    }
    showToastSuccess(title, msg) {
        const event = new ShowToastEvent({
            title: title,
            message: msg,
            variant: 'success'
        });
        this.dispatchEvent(event);
    }
    callCompanyDetails() {
        getComanyInfo({ 'acc_id': this.accId })
            .then((result) => {
                //consele.log('company Details=', JSON.stringify(result));
                this.company_info = result;
                //correspondence_address123

                if (result.Registered_Address_Line_1__c) {
                    this.registered_address123 = result.Registered_Address_Line_1__c;
                }
                if (result.Registered_Address_Line_2__c) {
                    if (this.registered_address123.trim() !== '') {
                        this.registered_address123 = this.registered_address123 + ',' + result.Registered_Address_Line_2__c;
                    } else {
                        this.registered_address123 = result.Registered_Address_Line_2__c;
                    }
                }
                if (result.Registered_Address_Line_3__c) {
                    if (this.registered_address123.trim() !== '') {
                        this.registered_address123 = this.registered_address123 + ',' + result.Registered_Address_Line_3__c;
                    } else {
                        this.registered_address123 = result.Registered_Address_Line_3__c;
                    }
                }
                if (result.Correspondence_Address_Line_1__c) {
                    this.correspondence_address123 = result.Correspondence_Address_Line_1__c;
                }
                if (result.Correspondence_Address_Line_2__c) {
                    if (this.correspondence_address123.trim() !== '') {
                        this.correspondence_address123 = this.correspondence_address123 + ',' + result.Correspondence_Address_Line_2__c;
                    } else {
                        this.correspondence_address123 = result.Correspondence_Address_Line_2__c;
                    }
                }
                if (result.Correspondence_Address_Line_3__c) {
                    if (this.correspondence_address123.trim() !== '') {
                        this.correspondence_address123 = this.correspondence_address123 + ',' + result.Correspondence_Address_Line_3__c;
                    } else {
                        this.correspondence_address123 = result.Correspondence_Address_Line_3__c;
                    }
                }

            }).catch((error) => {
                //consele.log(error);
            });
    }
    getContact() {
        getContactInfo({
            acc_id: this.accId
        })
            .then((result) => {
                this.show_checkbox_spinner = false;
                //consele.log("Contact:" + JSON.stringify(result));
                this.contact_info = result;
            })
            .catch((error) => {
            });
    }
    getAuthorisedPersonList() {
        let self = this;
        getAuthorisedPersons({
            acc_id: this.accId
        })
            .then((result) => {
                //consele.log("authorised person=" + JSON.stringify(result));
                // this.authorised_person_list = result;
                if (result.length > 0) {
                    this.show_authorised_person_list = true;
                }
                result.map(function (each_row, index) {
                    //consele.log('each_row=', each_row);
                    self.authorised_person_list.push({
                        'editable': false,
                        ...each_row
                    });
                });
            })
            .catch((error) => {
            });
    }
    getBeneficiaryList() {
        let self = this;
        getBeneficiary({
            acc_id: this.accId
        })
            .then((result) => {
                //consele.log("benificiary_owners=" + JSON.stringify(result));
                result.map(function (each_row, index) {
                    self.benificiary_owners.push({
                        'editable': false,
                        ...each_row
                    });
                });
            })
            .catch((error) => {
            });
    }
    getDirectorsList() {
        let self = this;
        getDirector({
            acc_id: this.accId
        })
            .then((result) => {
                //consele.log("directors=" + JSON.stringify(result));
                result.map(function (each_row, index) {
                    self.directors_list.push({
                        'editable': false,
                        ...each_row
                    });
                });
            })
            .catch((error) => {
            });
    }
    getBRDocumentsList(){
        getBRDocuments({
            acc_id: this.accId
        }).then((result)=>{
            //consele.log('result=',JSON.stringify(result));
            let temp_res = result;
            let self = this;
            temp_res.map((each_res)=>{
                self.brc_records.push({
                    ...each_res,
                    'link':'/ECReach/sfc/servlet.shepherd/document/download/'+each_res.Document_Id__c
                })
            })
            // this.brc_records = temp_res;
        }).catch((error) => {
            //consele.log('error in getBRDocuments',JSON.stringify(error));
            });
    }
    handleContactEdit(e) {
        var selectedRow = e.currentTarget;
        var key = selectedRow.dataset.id;
        this.edit_contact_id = key;
        this.contact_edit_modal = true;
    }
    handleContactDelete(e) {
        var selectedRow = e.currentTarget;
        var contactId = selectedRow.dataset.id;
        this.show_checkbox_spinner = true;

        const fields = {};
        fields[CONTACT_ID.fieldApiName] = contactId;
        fields[CONTACT_IS_ACTIVE.fieldApiName] = false;
        let is_updated = this.updateContactField(fields, '', '', '');
        //CONTACT_IS_ACTIVE
    }
    handleContactAdd(e) {
        this.show_contact_create_modal = true;
    }
    closecreatecontactmodal(e) {
        this.show_contact_create_modal = false;
        let should_refresh = e.detail.refresh;
        //consele.log("detail=" + JSON.stringify(e.detail));;
        if (should_refresh) {
            this.getContact();
        }
    }
    getPolicy() {
        
        getPolicyDetails({
            acc_id: this.accId
        })
            .then((result) => {
                console.log("Policy details=", JSON.stringify(result));
                this.policy_details = result;
                this.account_name = result.Exporter__r.Name;
                this.policy_no = result.Name;//result.Legacy_Customer_Number__c;
                this.policy_type = result.Product__r.Name;
                this.policy_available = true;
                // this.effective_date = result.Commencement_Date__c;
                // this.policy_id = result.Id;

            })
            .catch((error) => {

                //consele.log("error");
                console.error('e.name => ' + error.name);
                console.error('e.message => ' + error.message);
                console.error('e.stack => ' + error.stack);
                console.error(error);
            });
    }
    closecontacteditmodal(e) {
        this.contact_edit_modal = false;
        let should_refresh = e.detail.refresh;
        //consele.log("detail=" + JSON.stringify(e.detail));;
        if (should_refresh) {
            this.getContact();
        }
    }
    // handleExternalLink(){
    //     window.open('https://testsecureacceptance.cybersource.com/embedded/pay');
    // }
    renderedCallback() {
        //consele.log('--ContactInfo=' + JSON.stringify(this.contact_info));
        let primary_contact_count = 0;
        let self = this;
        this.contact_info.map(function (each_contact, i) {
            if (each_contact.Primary_Contact__c) {
                primary_contact_count = primary_contact_count + 1;
            }
        });
        //consele.log("this.primary_contact_count=" + this.primary_contact_count);
        if (primary_contact_count > 0) {
            this.enable_primary_contact = false;
        } else {
            this.enable_primary_contact = true;
        }
        if (!this.is_render_firsttime) {
            this.is_render_firsttime = true;
            getPolicyHolder({ 'user_id': this.UsrId })
                .then((result) => {
                    //consele.log('accountId===', result);
                    this.accId = result;
                    this.callCompanyDetails();
                    this.getPolicy();
                    this.getContact();
                    this.getAuthorisedPersonList();
                    this.getBeneficiaryList();
                    this.getDirectorsList();
                    this.getBRDocumentsList();
                }).catch((error) => {

                    //consele.log(error);
                });

            /*this.brc_records.push({
                'id': 1,
                'document': '2021BP',
                'received_date': '2021-03-01 13:00',
                'expiry_date': '2022-02-25'
            });
            this.brc_records.push({
                'id': 2,
                'document': '2021BP',
                'received_date': '2021-03-01 13:00',
                'expiry_date': '2022-02-25'
            });
            this.brc_records.push({
                'id': 3,
                'document': '2021BP',
                'received_date': '2021-03-01 13:00',
                'expiry_date': '2022-02-25'
            });*/

        }

    }

}