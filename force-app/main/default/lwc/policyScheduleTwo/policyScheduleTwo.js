import { LightningElement ,  track , wire, api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import current_user from '@salesforce/user/Id';
import getWrapperAllSchedule from '@salesforce/apex/PolicyManagement.getWrapperAllSchedule';
//import getDynmaicPricing from '@salesforce/apex/PolicyManagement.getDynmaicPricing';


import getSchdule2CountryList from '@salesforce/apex/GetCustomMetaData.getSchdule2CountryList';
import getClause70CountryList from '@salesforce/apex/GetCustomMetaData.getClause70CountryList';



import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
export default class PolicyScheduleTwo extends NavigationMixin(LightningElement) {

    @track userId = current_user;
    @track pageTitle;
    @api isSbp;
    @api isSup;
    @api productId;
    @api policyId;
    @api productName;
    @api policyCommDate;//this is the effective date
    @api mapDataPassToSchedule;
    @track isLoading = true;
    @track issueDate;
    @track policyNumber;
    @track effectiveDate;

    @track DP;
    @track DA_OA_0_30;
    @track DA_OA_31_60;
    @track DA_OA_61_90;
    @track DA_OA_91_120;

    @track DP_NonA;
    @track DA_OA_0_30_NonA;
    @track DA_OA_31_60_NonA;
    @track DA_OA_61_90_NonA;
    @track DA_OA_91_120_NonA;

    @track baseRatePerAnnum;

    @track leftCountryList=[];
    @track rightCountryList=[];
    @wire(getSchdule2CountryList, {})
    handlegetSchdule2CountryList({ error, data }) {
        if (data) {
            const temp = data.map(el => {
                return {
                    name: el.CTRY_CTRY_NAME__c,
                    code: el.CTRY_CTRY_CODE__c,
                    group: el.CTRY_GRADE__c,
                    condition: el.Special_Condition__c
                }
            })

            let half = Math.ceil(temp.length / 2)
            this.leftCountryList = temp.slice(0, half);
            this.rightCountryList = temp.slice(half);
            console.log('schdule2CountryList::', temp.length, this.leftCountryList, this.rightCountryList);
        } else if (error) {
            console.error('#### handlegetSchdule2CountryList error=' + JSON.stringify(error))
        }
    }

    @track clause70CountryList = []
    @wire(getClause70CountryList, {})
    handlegetClause70CountryList({ error, data }) {
        if (data) {
            this.clause70CountryList = data.map(el => {
                return {
                    name: el.CTRY_CTRY_NAME__c,
                    code: el.CTRY_CTRY_CODE__c
                }
            })
            console.log('clause70CountryList::', JSON.stringify(this.clause70CountryList));
        } else if (error) {
            console.error('####handlegetClause70CountryList error=' + JSON.stringify(error))
        }
    }
    connectedCallback(){
        //this.isLoading = true;
        //this.userId = '0051100000BarVxAAJ';
        console.log('userId :: '+this.userId+' productId:'+this.productId+' policyId:'+this.policyId+' effecte-policyCommDate:'+this.policyCommDate);

        console.log('mapDataPassToSchedule  : '+JSON.stringify(this.mapDataPassToSchedule));
        console.log('isSbp : '+this.isSbp+' isSup : '+this.isSup+' productName: '+this.productName);
        if(this.isSbp){
            this.pageTitle = this.productName + '- SCHEDULE II (PART 1)';
        }else if(this.isSup){
            this.pageTitle = this.productName + '- SCHEDULE II (PART 1)';
        }
        
        this.countryList = [
            { "COUNTRY_MARKET": "Aland Islands","CODE": "ALA","GROUP": "B","SPECIAL_CONDITIONS": ''},
            { "COUNTRY_MARKET": "Algeria","CODE": "DZA","GROUP": "C","SPECIAL_CONDITIONS": '1 (9 months), 2'},
            { "COUNTRY_MARKET": "American Samoa","CODE": "ASM","GROUP": "B","SPECIAL_CONDITIONS": ''},
            { "COUNTRY_MARKET": "Andorra","CODE": "AND","GROUP": "B","SPECIAL_CONDITIONS": ''},
            { "COUNTRY_MARKET": "Angola","CODE": "AGO","GROUP": "C","SPECIAL_CONDITIONS": '2'}
          ];
        this.handleCountryList();
        this.getAllSchedule();
        this.isLoading = false;
       
        /*for(let sch in this.mapDataPassToSchedule){
            console.log('key :'+this.mapDataPassToSchedule[sch].key+' value :'+this.mapDataPassToSchedule[sch].value);
        
            if(this.mapDataPassToSchedule[sch].key  === 'policyNumber'){
                this.policyNumber = this.mapDataPassToSchedule[sch].value;
            }
            if(this.mapDataPassToSchedule[sch].key  === 'issueDate'){
                this.issueDate = this.mapDataPassToSchedule[sch].value;
            }
            if(this.mapDataPassToSchedule[sch].key  === 'effectiveDate'){
                this.effectiveDate = this.mapDataPassToSchedule[sch].value;
            }
        }*/
    }
    handleCountryList(){
        try {
            console.log('Size of the country list : '+this.countryList.length);
            if(this.countryList.length>0 && this.countryList.length>1){
                var name='COUNTRY_MARKET';
                var fullLength=this.countryList.length;
                console.log('fullLength : '+fullLength);
                var remainder = fullLength%2;
                console.log('remainder : '+remainder);

                var quotient = (fullLength-remainder)/2;
                console.log('quotient : '+quotient);
                for(let cnList in this.countryList){
                    console.log('cnList :'+cnList);
                    if(cnList < quotient){
                        //console.log('left list :'+countryList[cnList]);
                        this.leftCountryList.push(this.countryList[cnList]);
                    }else{
                        //console.log('right list :'+countryList[cnList]);
                        this.rightCountryList.push(this.countryList[cnList]);
                    }
                }
            }
            console.log('leftCountryList : '+JSON.stringify(this.leftCountryList));
            console.log('rightCountryList : '+JSON.stringify(this.rightCountryList));
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Exception Occurred While Fetching Country List',
                    message: error.toString(),
                    mode : 'sticky',
                    variant: 'warning'
                })
            );
        }
        
    }

    getAllSchedule(){
        console.log('getAllSchedule called.');
        getWrapperAllSchedule({
            usrId : this.userId
        }).then(data => {
            console.log('getWrapperAllSchedule success :'+JSON.stringify(data));
            try {
                for(let sch in data){
                    this.policyNumber=data[sch].policyNumber;
                    
                    if(data[sch].scheduleType === 'Schedule 1'){
                        console.log('Schedule 1*********************x');
                        this.baseRatePerAnnum = data[sch].baseRatePerAnnum;
                       
                    }else if(data[sch].scheduleType === 'Schedule 2'){
                        console.log('Schedule 2*********************');
                        this.issueDate = data[sch].scheduleIssueDate;
                        this.effectiveDate = data[sch].scheduleEffectiveDate;

                        this.DP = data[sch].DP;
                        this.DA_OA_0_30 = data[sch].DA_OA_0_30;
                        this.DA_OA_31_60= data[sch].DA_OA_31_60;
                        this.DA_OA_61_90= data[sch].DA_OA_61_90;
                        this.DA_OA_91_120= data[sch].DA_OA_91_120;

                        this.DP_NonA = data[sch].DP_NonA;
                        this.DA_OA_0_30_NonA = data[sch].DA_OA_0_30_NonA;
                        this.DA_OA_31_60_NonA = data[sch].DA_OA_31_60_NonA;
                        this.DA_OA_61_90_NonA = data[sch].DA_OA_61_90_NonA;
                        this.DA_OA_91_120_NonA = data[sch].DA_OA_91_120_NonA;
                    }else if(data[sch].scheduleType === 'Schedule 3'){
                        console.log('Schedule 3*********************');
                    }else if(data[sch].scheduleType === 'Schedule 4'){
                        console.log('Schedule 4*********************');
                    }
                }
                console.log('this.issueDate :'+this.issueDate+' this.effectiveDate:'+this.effectiveDate);
            } catch (error) {
               console.error(error.toString+'=='+JSON.stringify(error));
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

    getdpList(){
        console.log('getdpList called.');
        getDynmaicPricing({
            productId : this.productId,
            policyId : this.policyId
        }).then(data => {
            console.log('getDynmaicPricing success :'+JSON.stringify(data));
            try {
                for(let dp in data){
                   console.log('dp==>>'+dp);
                }
            } catch (error) {
               console.error(error.toString+'=='+JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Exception Occurred while fetching Dynamic Pricing',
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
}