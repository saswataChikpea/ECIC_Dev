import { api, LightningElement, track, wire } from 'lwc'
import getFeatureElements from '@salesforce/apex/OnBoarding.getFeatureElements'
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import searchProduct from '@salesforce/apex/OnBoarding.searchProduct'
import searchProduct1 from '@salesforce/apex/OnBoarding.searchProduct1'
import getCountryList from '@salesforce/apex/GetCustomMetaData.getCountryList';
import Required_Field from '@salesforce/label/c.Required_Field';
import Onboarding_Email_Validation_Message from '@salesforce/label/c.Onboarding_Email_Validation_Message';
import Error from '@salesforce/label/c.Error';
import Complete_the_questionnaire_below_to_find_out_the_suitable_policy_for_your_compan from '@salesforce/label/c.Complete_the_questionnaire_below_to_find_out_the_suitable_policy_for_your_compan';
import Back from '@salesforce/label/c.Back';
import Show_Recommended_Product from '@salesforce/label/c.Show_Recommended_Product';
import Next from '@salesforce/label/c.Next';


export default class OnboardingPI extends LightningElement {
    @api retUrl = "showOnboardingHome"
    @api products
    @api language
    @track error = false
    @track exceptionDetail
    @track stages = [
    ]
    @track current_stage = 0
    @track maxStage = 7
    @track nextBtn = 'Next';

    @track shouldShowPrevButton = true
    @track questions

    questions_map = {}
    @track all_questions
    existing_policy_holder = false
    selected_product
    @track shouldShowPrevButton = true
    @track shouldShowNextFieldsClass = ""
    @track isCompanyNameValid = false
    @track firstQuestion
    @track firstPageQuestions = []
    @track secondPageQuestions = []
    @track showFirstPage = true
    @track showSecondPage = false
    @track countryGradeMap = {}
    @api proposal
    @track countryOptions = []
    // proposal = { "Self_Approving_CL__c": "Yes" }
    products = [{ "Id": "a070l00000Aj0x6AAB", "Name": "OMBP", "Premium_Rate__c": 0.8, "Image_Url__c": "https://kennychun--dev2--c.documentforce.com/servlet/servlet…id=0150l000000mI4d&oid=00D0l00000029IA&lastMod=1621523832000", "Full_Name__c": "ONLINE MICRO BUSINESS POLICY (OMBP)", "Display_Sequence__c": 1, "Price_Book__c": "a0C0l00000Dhpf2EAB" }, { "Id": "a070l00000Aj0x7AAB", "Name": "SBP", "Image_Url__c": "https://kennychun--dev2--c.documentforce.com/servlet/servlet…id=0150l000000mL4V&oid=00D0l00000029IA&lastMod=1621523832000", "Full_Name__c": "SMALL BUSINESS POLICY", "Display_Sequence__c": 2, "Price_Book__c": "a0C0l00000Dhpf2EAB" }, { "Id": "a070l00000Aj0x5AAB", "Name": "SUP", "Premium_Rate__c": 103, "Image_Url__c": "https://kennychun--dev2--c.documentforce.com/servlet/servlet…id=0150l000000mL4W&oid=00D0l00000029IA&lastMod=1621523832000", "Full_Name__c": "SELF UNDERWEITTEN POLICY (SUP)", "Display_Sequence__c": 3, "Price_Book__c": "a0C0l00000Dhpf2EAB" }]
    @track label = {
        Required_Field,
        Onboarding_Email_Validation_Message,
        Error, Complete_the_questionnaire_below_to_find_out_the_suitable_policy_for_your_compan, Back, Show_Recommended_Product,
        Next
    }
    connectedCallback() {
        //this.questions.q2.turnover_last_year = 'below $20mn';
        //this.questions.q2.turnover_next_year = 'below $20mn';
        // this.callgetCountryList()
        this.proposal = this.proposal === undefined ? {} : { ...this.proposal }
        console.log("connectedCallback proposal=", JSON.stringify(this.proposal))
        console.log("connectedCallback products=", JSON.stringify(this.products))
        this.products = this.products === undefined ? {} : [...this.products]
        // if (this.countryGrade) {
        //     this.countryGradeMap = {
        //         ...this.countryGrade.GRADE_A.reduce((ac, a) => ({ ...ac, [a.toUpperCase()]: 'GRADE_A' }), {}),
        //         ...this.countryGrade.GRADE_B.reduce((ac, a) => ({ ...ac, [a.toUpperCase()]: 'GRADE_B' }), {}),
        //         ...this.countryGrade.GRADE_C.reduce((ac, a) => ({ ...ac, [a.toUpperCase()]: 'GRADE_C' }), {})
        //     }
        //     // console.log("grade::", JSON.stringify(this.countryGradeMap))
        // }

    }
    renderedCallback() {
        this.shouldShowPrevButton = this.current_stage == 0 ? false : true
    }
    loadFromProposal() {
        // console.log(ljkdfls)
        if (this.proposal) {
            this.all_questions.forEach((question) => {
                const value = this.proposal[question.Name + "__c"]
                try {
                    if (value) {
                        question.Value = value
                        if (question.isRadio) {
                            question.options = question.options.map(el => {
                                el.isChecked = el.value == value ? true : false
                                return el
                            })
                        }
                    }
                } catch (error) {
                    console.error("error", error);
                }
            })
        }
    }

    get quesFieldName() {
        if (this.language == 'zh_CN') {
            return 'Question_CH__c'
        } else if (this.language == 'zh_TW') {
            return 'Question_HK__c'
        } else if (this.language == 'zh_HK') {
            return 'Question_HK__c'
        } else {
            return 'Question__c'
        }

    }

    @wire(getFeatureElements, { source: 'onboardingMaster' })
    getFeatureElements({ error, data }) {
        if (data) {
            console.log('getFeatureElements=' + JSON.stringify(data, null, '\t'))
            const temp_questions = []
            this.all_questions = []
            //this.questions.q0.company_name_q = data[0].Question__c
            var stg_label = 1
            data.forEach((rec, index) => {
                const ques = { ...rec }

                this.questions_map[ques.Name] = ques
                this.all_questions.push(ques)
                ques.Question_old = ques[this.quesFieldName]
                ques.Question__c = ques[this.quesFieldName]
                ques.visible = false
                ques.Value = ""
                ques.options = []
                if (ques.Data_Type__c === 'Picklist') {
                    ques.isPickList = true
                    ques.options.push(
                        { label: '--Select--', value: '' }
                    )
                    //ques.Value = '20'
                } else if (ques.Data_Type__c === 'Picklist (Multi-Select)') {
                    ques.isMultiSelectPicklist = true
                    if (ques.Name === 'Buyer_Country_Market') {
                        ques.options = this.countryOptions
                    }
                } else if (ques.Data_Type__c === 'Radio') {
                    ques.isRadio = true
                    ques.radiogroup = ques.Name
                } else if (ques.Data_Type__c == 'Number') {
                    ques.isNumber = true
                } else if (ques.Data_Type__c == 'Currency') {
                    ques.isCurrency = true
                } else {
                    ques.isText = true
                }
                if (ques.Feature_Element_Values__r && ques.Data_Type__c !== 'Picklist (Multi-Select)')
                    ques.Feature_Element_Values__r.forEach((val) => {
                        // console.log('getFeatureElements=' + JSON.stringify(val, null, '\t'))
                        ques.options.push({ label: val.Name, value: val.Element_Value__c })
                    })
                // console.log('questions.values=' + JSON.stringify(ques.options, null, '\t'))

                const q_index = ques.Display_Sequence__c - 1
                /*const q_sub_index = ques.Sub_Display_Sequence__c - 1
                if (!this.group[q_index]) {
                    this.group[q_index] = []
                    temp_questions[q_index] = []
                    //creating path stages dynamically
                    this.stages.push({ "id": index, "label": stg_label, "assistive_text": "Stage Complete", "stage_class": "slds-path__item slds-is-incomplete" })
                    stg_label++
                }
                this.group[q_index].push(q_sub_index)
                //this.temp_questions.push(ques)
                //extracting first question and keeping it seperate
                // if (ques.Display_Sequence__c === 1) {
                //     this.firstQuestion = ques
                // } else {
                // }
                temp_questions[q_index].push(ques)*/
                temp_questions[q_index] = ques
            });
            //setting fist question visible
            // temp_questions[0][0].visible = true
            this.questions = temp_questions
            // console.log('group=' + JSON.stringify(this.group))
            console.log('questions=' + JSON.stringify(this.questions, null, '\t'))

            //creating first and second page questions
            this.firstPageQuestions = this.questions.slice(0, 2)
            this.secondPageQuestions = this.questions.slice(2, this.questions.length)
            // console.log("firstPageQeustions", JSON.stringify(this.firstPageQuestions))
            //making first path stages selected
            // this.stages[0].stage_class = "slds-path__item slds-is-current slds-is-active"
            // this.stages = [...this.stages]
            this.loadFromProposal()
        } else if (error) {
            console.error(error)
            this.error = 'Unable to load';
            if (error.body) {
                if (Array.isArray(error.body)) {
                    this.exceptionDetail = error.body.map(e => e.message).join(', ')
                } else if (typeof error.body.message === 'string') {
                    this.exceptionDetail = error.body.message
                }
            } else {
                this.exceptionDetail = error
            }
        }
    }


    callSearchProduct() {
        console.log('searchProduct called.');
        //console.log(JSON.stringify(this.all_questions, null, '\t'))
        let turnOverMap = {}//for checking product search null condition 
        const pf_list = []// Product_Feature__c list
        this.all_questions.forEach((question) => {
            turnOverMap[question.Name] = question.Value || ""
            // console.log(JSON.stringify(question, null, '\t'))
            if (question.Name === 'Buyer_Country_Market') {
                // console.log("value::", question.Value)
                const finalCountryGrade = question.Value.split(';').reduce((prev, curr) => {
                    // console.log(":::", this.countryGradeMap);
                    console.log(curr, " grade::", this.countryGradeMap[curr])
                    let grade = this.countryGradeMap[curr] || "GRADE_NOT_LISTED"
                    return grade > prev ? grade : prev
                }, "")
                console.log("final grade::", finalCountryGrade);
                turnOverMap[question.Name] = finalCountryGrade
                pf_list.push({
                    Name: question.Name,
                    Feature_Element__c: question.Id, Criteria_Value__c: finalCountryGrade
                })
            } else if (question.hasOwnProperty('Value')) {
                pf_list.push({
                    Name: question.Name,
                    Feature_Element__c: question.Id, Criteria_Value__c: question.Value
                })
            }
        })
        // console.log('all_questions=' + JSON.stringify(pf_list, null, '\t'))
        searchProduct({ features: pf_list }).then(data => {
            console.log('#search searchProduct success ::' + JSON.stringify(data));
            try {
                // const productWeightSortedArray = Object.keys(data).sort((a, b) => data[a] - data[b]).reverse()
                // console.log('productWeightSortedArray ::' + JSON.stringify(productWeightSortedArray));

                // console.log('products ::' + JSON.stringify(this.products));
                //this.products = data;
                const tempForLog = this.products.reduce((prev, curr) => {
                    return { ...prev, [curr.Name]: data[curr.Id] }
                }, {})
                console.log("search weitage count::", JSON.stringify(tempForLog));

                // todo

                //now checking for product search null
                let isProductSearchNull = false
                let productSearchError = null
                if (turnOverMap['Past_Turnover'] && turnOverMap['Past_Turnover'] === 'HKD 50,000,001 and above') {
                    isProductSearchNull = true
                    productSearchError = "Past turnover over 5M"
                } else if (turnOverMap['Future_Turnover'] && turnOverMap['Future_Turnover'] === 'HKD 50,000,001 and above') {
                    isProductSearchNull = true
                    productSearchError = "Future turnover over 5M"
                } else if (Number(turnOverMap['Sales_Amount_Range']) >= 5000001) {
                    isProductSearchNull = true
                    productSearchError = "Credit limit over 5M"
                } else if (turnOverMap['Self_Approving_CL'] == "Yes" && Number(turnOverMap['Sales_Amount_Range']) > 3000000) {
                    isProductSearchNull = true
                    productSearchError = "Self approving credit limit yes but credit limit over 3M"
                } else if (Number(turnOverMap['Sales_Amount_Range']) <= 800000 && !['HKD 1-10,000,000', 'HKD 10,000,001 – 20,000,000', 'HKD 20,000,001 – 30,000,000'].includes(turnOverMap['Past_Turnover'])) {//ombp condition1
                    isProductSearchNull = true
                    productSearchError = "Credit limit OMBP but Past Turnover over 3M"
                } else if (Number(turnOverMap['Sales_Amount_Range']) <= 800000 && !['HKD 1-10,000,000', 'HKD 10,000,001 – 20,000,000', 'HKD 20,000,001 – 30,000,000'].includes(turnOverMap['Future_Turnover'])) {//ombp condition1
                    isProductSearchNull = true
                    productSearchError = "Credit limit OMBP but Future Turnover over 3M"
                } else if (Number(turnOverMap['Sales_Amount_Range']) <= 800000 && turnOverMap['Self_Approving_CL'] == "Yes") {//ombp condition3
                    isProductSearchNull = true
                    productSearchError = "Credit limit OMBP Self approving credit limit YES"
                } else if (Number(turnOverMap['Sales_Amount_Range']) <= 800000 && turnOverMap['Buyer_Country_Market'] !== 'A') {//ombp condition4
                    isProductSearchNull = true
                    productSearchError = "Credit limit OMBP Self but country market not in Grade A"
                } else if (turnOverMap['Self_Approving_CL'] == "Yes" && turnOverMap['Buyer_Country_Market'] !== 'A') {
                    isProductSearchNull = true
                    productSearchError = "Self approving credit limit yes but country market not in Grade A"
                } else if (!['A', 'B', 'C'].includes(turnOverMap['Buyer_Country_Market'])) {
                    isProductSearchNull = true
                    productSearchError = "Country outside grade list"
                }

                if (isProductSearchNull) {
                    console.log("Product Search is Null\n:: reason=", productSearchError + '\n===>recommending SBP');
                    this.selected_product = null
                    //default error msg
                    // productSearchError = "There are no recommended products given your responses. Please select a policy type and proceed."
                    productSearchError = null
                    data = []
                }

                const productOrder = { SBP: 3, SUP: 2, OMBP: 1 }//FRD If there are multiple products in the intersection sbp>sup>ombp
                const tempProducts = this.products.sort((a, b) =>//first sorting by product name as mentioned in frd
                    (productOrder[b.Name] - productOrder[a.Name]))
                    .sort((a, b) =>// then sorting by weitage count
                        (data[b.Id] - data[a.Id]))
                const SBPProduct = this.products.filter(el => (el.Name == 'SBP'))[0].Id
                this.selected_product = isProductSearchNull ? SBPProduct : tempProducts[0].Id
                console.log("final recomended::", this.selected_product)
                // console.log("final sorted products::", JSON.stringify(tempProducts))


                console.log('showOnboardingDP ====> ')
                const event1 = new CustomEvent('handlepagechange', {
                    // detail contains only primitives
                    detail: { pageId: 'showOnboardingDP', source: 'showOnboardingPI', selected_product: this.selected_product, proposal: this.proposal, productSearchError }
                });
                this.dispatchEvent(event1)
            } catch (error) {
                console.error('Cannot fetch Product : ' + error);
                // this.dispatchEvent(
                //     new ShowToastEvent({
                //         title: 'Error Occurred.',
                //         message: error.toString(),
                //         mode: 'sticky',
                //         variant: 'error'
                //     })
                // );
            }
        }).catch(error => {
            console.error('Cannot fetch Product : ' + error);
            // this.dispatchEvent(
            //     new ShowToastEvent({
            //         title: 'Error Occurred',
            //         message: error.toString(),
            //         mode: 'sticky',
            //         variant: 'error'
            //     })
            // );
        });
    }

    handleQChange(event) {
        const targetName = event.target.name
        const targetValue = event.target.value


        console.log('Current type of the input: ' + targetName)
        console.log('Current value of the input: ' + targetValue)

        if (targetValue && targetName) {
            ///HKD 50,000,001 and above
            if (targetName == 'Future_Turnover' && targetValue == 'HKD 50,000,001 and above') {
                // this.showToast("We do not have any product recommended for the chosen turnover. Please contact SME team")
                const fnameCmp = this.template.querySelector(`[data-id='${targetName}']`);
                fnameCmp.setCustomValidity("There are no recomended products for the chosen turnover. Please contact the SME team");
                fnameCmp.reportValidity()
                // return
            } else if (targetName == 'Past_Turnover' && targetValue == 'HKD 50,000,001 and above') {
                // this.showToast("We do not have any product recommended for the chosen turnover. Please contact SME team")
                const fnameCmp = this.template.querySelector(`[data-id='${targetName}']`);
                fnameCmp.setCustomValidity("There are no recomended products for the chosen turnover. Please contact the SME team");
                fnameCmp.reportValidity()
                // return
            }
            else if (targetName == 'Future_Turnover' || targetName == 'Past_Turnover') {
                const fnameCmp1 = this.template.querySelector(`[data-id='${targetName}']`);
                fnameCmp1.setCustomValidity("")
                fnameCmp1.reportValidity()
            }
            // console.log(targetName + ":::", targetValue)
            this.questions_map[targetName].Value = targetValue
            this.proposal[targetName + '__c'] = targetValue
        } else if (event.detail.payload) {//c-custom-multi-select-picklist
            const targetValue = event.detail.payload.values.join(";")
            console.log('Current value of the input: ' + targetValue)
            this.questions_map[targetName].Value = targetValue
            this.proposal[targetName + '__c'] = targetValue
        } else if (event.detail.value) {
            const targetValue = event.detail.value
            console.log('Current value of the input: ' + targetValue)
            this.questions_map[targetName].Value = targetValue
            this.proposal[targetName + '__c'] = targetValue
        } else if (event.target.checked === true) {
            const targetValue = event.target.checked
            console.log('Current value of the input: ' + targetValue)
            this.questions_map[targetName].Value = targetValue
            this.proposal[targetName + '__c'] = targetValue
        }
        console.log('proposal=' + JSON.stringify(this.proposal))
        // console.log('questions_map=' + JSON.stringify(this.questions_map))
    }
    handleCurrencyChange(event) {
        const targetName = event.target.name
        const targetValue = event.target.value
        console.log(targetName + ' :: ', targetValue);
        if (targetName == 'Insurable_Turnover' && targetValue > 50000000) {
            console.log("test");
            // this.all_questions.slice(2, this.all_questions.length).every((question) => {
            //     //var ques 
            //     let dataId = question.Name
            //     const fnameCmp = this.template.querySelector(`[data-id='${dataId}']`);

            //     if (question.Name == 'Insurable_Turnover') {
            //         question.errMsg = "There are no recomended products for the chosen turnover. Please contact the SME team."
            //         return false
            //     }
            // })
            this.all_questions = this.all_questions.map(el => {
                if (el.Name == 'Insurable_Turnover') {
                    el.errMsg = "There are no recomended products for the chosen turnover. Please contact the SME team."
                }
                return el
            })
            // this.questions_map['Insurable_Turnover'].errMsg = "There are no recomended products for the chosen turnover. Please contact the SME team."
        } else if (targetName == 'Insurable_Turnover') {
            this.all_questions = this.all_questions.map(el => {
                if (el.Name == 'Insurable_Turnover') {
                    el.errMsg = ""
                }
                return el
            })
        }
        console.log("test1", this.questions_map[targetName].errMsg);
        this.questions_map[targetName].Value = targetValue
        this.proposal[targetName + '__c'] = targetValue
    }

    // handleQPickListChange(event){
    //     console.log('event.detail=' + JSON.stringify(event.detail), event.target.options.find(opt => opt.value === event.detail.value))
    //     const name = event.target.options.find(opt => opt.value === event.detail.value).name;
    //     const targetValue = event.detail.value
    //     this.questions_map[name].Value = targetValue
    //     this.proposal[event.detail.name+'__c'] = targetValue 
    //     console.log('proposal=' + JSON.stringify(this.proposal))
    // }
    // isLocal = true
    showToast = (message, title, variant) => {
        if (this.isLocal) {
            alert(message || "")
            return
        }
        const toastEvent = new ShowToastEvent({
            title: title || this.label.Error,
            message: message || "",
            variant: variant || 'error'
        })
        this.dispatchEvent(toastEvent)
    }
    handleQRadioChange(event) {
        console.log('event.detail=' + JSON.stringify(event.detail))
        const targetValue = event.detail.selectedValue
        // if (event.detail.name === 'Existing_Policy_Holder') {
        //     console.log('Current value of the input: ' + targetValue)
        //     this.proposal[event.detail.name + '__c'] = targetValue
        //     if (event.detail.value === 'true') {
        //         this.nextBtn = 'Review'
        //         this.existing_policy_holder = true
        //     } else {
        //         this.nextBtn = 'Next'
        //         this.existing_policy_holder = false
        //     }
        // } else {
        this.questions_map[event.detail.name].Value = targetValue
        this.proposal[event.detail.name + '__c'] = targetValue
        // }
        console.log('proposal=' + JSON.stringify(this.proposal))

    }

    get annualSalesTurnOverForLast12Month() {
        return [
            { label: 'below $20mn', value: 'below $20mn' },
            { label: 'above $20mn', value: 'above $20mn' }
        ];
    }

    //@track astoForNext12Month = 'below $20mn';
    get annualSalesTurnOverForNext12Month() {
        return [
            { label: 'below $20mn', value: 'below $20mn' },
            { label: 'above $20mn', value: 'above $20mn' }
        ];
    }
    isNum = (val) => {
        return /^\d+$/.test(val);
    }
    getMaxFutureTurnover() {
        const ft = this.proposal['Future_Turnover__c']
        if (ft == 'HKD 1-10,000,000')
            return 10 * 1000000
        else if (ft == 'HKD 10,000,001 – 20,000,000')
            return 20 * 1000000
        else if (ft == 'HKD 20,000,001 – 30,000,000')
            return 30 * 1000000
        else if (ft == 'HKD 30,000,001 – 40,000,000')
            return 40 * 1000000
        else if (ft == 'HKD 40,000,001 – 50,000,000')
            return 50 * 1000000
        else if (ft == 'HKD 50,000,001 and above')
            return 60 * 1000000
    }
    showOnboardingDP(event) {
        /*const isInputsCorrect = [...this.template.querySelectorAll('input')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);
        if (isInputsCorrect) {
            //perform success logic
            console.log("valid input")
    
        } else {
            alert('Please update the invalid form entries and try again.');
            return
        }*/
        if (!this.proposal.Company_Name__c) {
            alert('Please provide the company name.');
            console.log("invalid name")
            return
        }
        let allInputsCorrect = true
        this.all_questions.slice(2, this.all_questions.length).every((question) => {
            //var ques 
            // console.log(JSON.stringify(question, null, '\t'))
            if (question.isRadio || question.isMultiSelectPicklist) {
                if (!this.proposal[question.Name + '__c']) {
                    question.errMsg = this.label.Required_Field
                    allInputsCorrect = false;
                    return false
                } else {
                    question.errMsg = ""
                    return true
                }
            }
            const dataId = question.Name
            try {
                let fnameCmp = this.template.querySelector(`[data-id='${dataId}']`);
                if (fnameCmp) {

                    let fnamevalue = fnameCmp.value
                    if (!fnamevalue) {
                        if (!question.isCurrency) {
                            fnameCmp.setCustomValidity(this.label.Required_Field);
                            fnameCmp.reportValidity();
                        } else {
                            question.errMsg = this.label.Required_Field
                        }
                        allInputsCorrect = false;
                        return false
                    } else if (question.isNumber && !this.isNum(fnamevalue)) {
                        fnameCmp.setCustomValidity("Please enter a numeric value");
                        fnameCmp.reportValidity();
                        allInputsCorrect = false;
                        return false
                    } else if (question.Name == 'Past_Turnover' && question.Value == 'HKD 50,000,001 and above') {
                        const fnameCmp = this.template.querySelector(`[data-id='${dataId}']`);
                        // fnameCmp.setCustomValidity("There are no recomended products for the chosen turnover. Please contact the SME team.")
                        // fnameCmp.reportValidity()
                        question.errMsg = "There are no recomended products for the chosen turnover. Please contact the SME team."
                        // this.showToast("We do not have any product recommended for the chosen turnover. Please contact SME team")
                        allInputsCorrect = false;
                        return false
                    } else if (question.Name == 'Future_Turnover' && question.Value == 'HKD 50,000,001 and above') {
                        const fnameCmp = this.template.querySelector(`[data-id='${dataId}']`);
                        // fnameCmp.setCustomValidity("There are no recomended products for the chosen turnover. Please contact the SME team.")
                        // fnameCmp.reportValidity()
                        question.errMsg = "There are no recomended products for the chosen turnover. Please contact the SME team."
                        // this.showToast("We do not have any product recommended for the chosen turnover. Please contact SME team")
                        allInputsCorrect = false;
                        return false
                    } else if (question.Name == 'Insurable_Turnover' && question.Value > this.getMaxFutureTurnover()) {
                        const fnameCmp = this.template.querySelector(`[data-id='${dataId}']`);
                        // fnameCmp.setCustomValidity("Insurable turnover must not exceed the estimated annual sales turnover for the next 12 months.")
                        // fnameCmp.reportValidity()
                        question.errMsg = "Insurable turnover must not exceed the estimated annual sales turnover for the next 12 months."
                        // this.showToast("We do not have any product recommended for the chosen turnover. Please contact SME team")
                        allInputsCorrect = false;
                        return false
                    } else if (question.Name == 'Insurable_Turnover' && question.Value > 50000000) {
                        question.errMsg = "There are no recomended products for the chosen turnover. Please contact the SME team."
                        allInputsCorrect = false;
                        return false
                    }
                    else {
                        allInputsCorrect = true
                        if (!question.isCurrency) {
                            fnameCmp.setCustomValidity(""); // clear previous err
                            fnameCmp.reportValidity();
                        } else {
                            question.errMsg = ''
                        }
                    }
                }
                return true
            } catch (error) {
                console.log(error)
            }
        })
        if (allInputsCorrect) {
            this.callSearchProduct()
        }

    }
    showPrevious() {
        console.log(' ====> showPrevious')
        // const event1 = new CustomEvent('handlepagechange', {
        //     // detail contains only primitives
        //     detail: { pageId: "showOnboardingHome", source: 'showOnboardingPI' }
        // });
        // this.dispatchEvent(event1)
        if (this.usrId) {
            console.log('redirecting to dashboard')
            window.location.href = '/ECReach/s/dashboard'
        } else {
            window.location.href = '/ECReach/s/'
        }

    }
    validateEmail(email) {
        const re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return re.test(String(email).toLowerCase());
    }

    togglePage() {
        if (this.showFirstPage && (!this.proposal.Company_Name__c || !this.validateEmail(this.proposal.Company_Email__c))) {
            // const event = new ShowToastEvent({
            //     "title": this.label.Error,
            //     "message": this.label.Onboarding_Email_Validation_Message,
            // });
            // this.dispatchEvent(event);
            this.showToast(this.label.Error)
            console.log("invalid email or name")
            // alert("Please provide company name and proper email address")
            return
        } else {
            const company_name = this.proposal['Company_Name__c']
            this.all_questions.forEach((question) => {
                var ques = question.Question_old
                //console.log('question='+ques)
                if (ques && ques.includes("${company_name}")) {
                    ques = ques.replace(/\${company_name}/, company_name)
                    question.Question__c = ques
                }
            })
        }
        this.showFirstPage = this.showFirstPage ? false : true
        this.showSecondPage = this.showSecondPage ? false : true
        console.log('Toggle page::');
        this.loadFromProposal()
    }
    // get countryGrade() {
    //     return { "GRADE_A": ["Australia", "Austria", "Belgium", "Bermuda", "Brunei Darussalam", "Canada", "Chile", "China", "Czechia", "Denmark", "Finland", "France", "Gabon Germany", "Holy See", "Ireland", "Italy", "Japan", "Korea, Republic of", "Kuwait", "Liechtenstein", "Luxembourg", "Macao", "Monaco", "Netherlands", "New Zealand", "Norway", "Oman", "Portugal", "Qatar", "San Marino", "Saudi Arabia", "Singapore", "Spain", "Sweden", "Switzerland", "Taiwan", "United Arab Emirates", "United Kingdom", "United States of America"], "GRADE_B": ["Aland Island", "American Samoa", "Andorra", "Anguilla", "Aruba", "Bahamas", "Bonaire, Sint Eustatius and Saba", "Botswana", "Bouvet Island", "Brazil", "British Indian Ocean Territory", "Cayman Islands", "Christmas Island", "Cocos (Keeling) Islands", "Colombia", "Cook Islands", "Curacao", "Cyprus", "Estonia", "Eswatini", "Falkland Island (Malvinas)", "Faroe", "French Guiana", "French Polynesia", "French Southern Territories", "Gibraltar", "Greenland", "Guadeloupe", "Guam", "Guernsey", "Heard Island and McDonald Islands", "Hungary", "Iceland", "India", "Indonesia", "Isle of Man", "Israel", "Jersey", "Latvia", "Lithuania", "Malaysia", "Malta", "Martinique", "Mauritius", "Mayotee", "Mexico", "Montserrat", "Morocco", "Namibia", "New Caledonia", "Niue", "Norflol Island", "Northern Mariana Islands", "Panama", "Peru", "Philippines", "Pitcairn", "Poland", "Puerto Rico", "Reunion", "Romania", "Russian Federation", "Saint Barthelemy", "Saint Helena, Ascension and Tristan Da Cunha", "Saint Pierre and Miquelon", "Sint Maarten (Dutch Part)", "Slovakia", "Slovenia", "South Africa", "South Georgia and the South Sandwich Islands", "Svalbard and Jan Mayen", "Thailand", "Tokelau", "Trinidad and Tobago", "Turks and Caicas Islands", "Uruguay", "Virgin Islands, British", "Virgin Islands, U.S.", "Wallis and Futuna"], "GRADE_C": ["Algeria", "Angola", "Argentina", "Azerbaijan", "Bahrain", "Bangladesh", "Barbodas", "Benin", "Bhutan", "Bolivia (Plurinational State of)", "Bulgaria", "Burkina Faso", "Cabo Verde", "Cameroon", "Comoros", "Costa Rica", "Croatia", "Djibouti", "Dominica", "Dominican Republic", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Ethiopia", "Fiji", "Ghana", "Greece", "Guatemala", "Honduras", "Iran, Islamic Republic of", "Jamaica", "Jordan", "Kazakhstan", "Kenya", "Lao People's Democratic Repubic", "Lesotho", "Maldives", "Mali", "Manogolia", "Myanmar", "Nepal", "Niger", "Nigeria", "Pakistan", "Papua New Guinea", "Paraguay", "Saint Lucia", "Saint Vincent and the Grenadines", "Samoa", "Sao Tome and Principe", "Serbia", "Senegal", "Seychelles", "Solomon Islands", "Srilanka", "Suriname", "Togo", "Tonga", "Tunisia", "Turkey", "Vanuatu", "Vietnam"] }
    // }
    // callgetCountryList() {
    @wire(getCountryList, {})
    callgetCountryList({ data, error }) {
        if (data) {
            console.log("getCountryList::", data);
            this.countryOptions = data.map((country) => ({ label: country.CTRY_CTRY_NAME__c, value: country.CTRY_CTRY_NAME__c, code: country.CTRY_CTRY_CODE__c }));
            // this.countryOptions = this.countryOptions.filter(el => el.label.toUpperCase() !== 'HONG KONG');
            this.countryOptions = this.countryOptions.sort((a, b) => a.value.localeCompare(b.value));
            // console.log("Country options:: ", JSON.stringify(this.countryOptions));
            this.countryGradeMap = data.reduce((acc, a) => (a.CTRY_GRADE__c ? { ...acc, [a.CTRY_CTRY_NAME__c]: a.CTRY_GRADE__c } : acc), {})
            console.log("countryGradeMap::", JSON.stringify(this.countryGradeMap));
        }
        else if (error) {
            console.log('error::', JSON.stringify(error));
            console.error('error::', JSON.stringify(error));
        }
    }

}