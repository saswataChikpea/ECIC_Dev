import { LightningElement, track } from 'lwc';

export default class DclContainer extends LightningElement {
    @track dclRecords = false;
    @track dclApplication = false;
    @track is_rendered = false;
    @track dcl_id = '';

    handleChange(e) {
        console.log("e.detail.Pagename=",e.detail.Pagename);        
        if (e.detail.Pagename === "dclApplication" ){
            this.dclApplication = true;
            this.dclRecords = false;
        } else if (e.detail.Pagename === "dclRecord" ){
            console.log('dclRecord');
            this.dclApplication = false;
            this.dclRecords = true;
        } else if (e.detail.Pagename === "RedirectdclRecord" ){
            this.dclApplication = false;
            this.dclRecords = true;
            this.dcl_id = e.detail.cl_id;
        } 
    }
    renderedCallback(){
        if(!this.is_rendered) {
            this.is_rendered = true;
            this.dclApplication = true;
            this.dclRecords = false;
        }
    }
}