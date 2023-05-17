import { api, LightningElement, track } from 'lwc';
import Step1 from '@salesforce/label/c.Step1';
import Company_Information from '@salesforce/label/c.Company_Information';
import Step2 from '@salesforce/label/c.Step2';
import Select_policy from '@salesforce/label/c.Select_policy';
import Step3 from '@salesforce/label/c.Step3';
import Fill_in_Proposal from '@salesforce/label/c.Fill_in_Proposal';
import Step4 from '@salesforce/label/c.Step4';
import Confirmation from '@salesforce/label/c.Confirmation';
import Step5 from '@salesforce/label/c.Step5';
import Create_account from '@salesforce/label/c.Create_account';
import Step6 from '@salesforce/label/c.Step6';
import Quotation from '@salesforce/label/c.Quotation';



export default class OnboardingProgress extends LightningElement {

    @track label ={
        Step1,Company_Information,Step2,Select_policy,Step3,Fill_in_Proposal,Step4,Confirmation,
        Step5,Create_account,Step6,Quotation
    }

    @api activeIndex = "0"
    @track steps = [
        {
            "Id": "0",
            "class_step": "step1",
            "step_number": this.label.Step1,
            "step_title": this.label.Company_Information,
            "class_dot_indicator_left": "dot-span visibility-hidden",
            "class_dot_indicator_left_small": "dot-span-small visibility-hidden",
            "class_dot_indicator_right": "dot-span visibility-hidden",
            "class_dot_indicator_right_small": "dot-span-small visibility-hidden"
        },
        {
            "Id": "1",
            "class_step": "step1",
            "step_number": this.label.Step2,
            "step_title": this.label.Select_policy,
            "class_dot_indicator_left": "dot-span visibility-hidden",
            "class_dot_indicator_left_small": "dot-span-small visibility-hidden",
            "class_dot_indicator_right": "dot-span visibility-hidden",
            "class_dot_indicator_right_small": "dot-span-small visibility-hidden"
        },
        {
            "Id": "2",
            "class_step": "step1",
            "step_number": this.label.Step3,
            "step_title": this.label.Fill_in_Proposal,
            "class_dot_indicator_left": "dot-span visibility-hidden",
            "class_dot_indicator_left_small": "dot-span-small visibility-hidden",
            "class_dot_indicator_right": "dot-span visibility-hidden",
            "class_dot_indicator_right_small": "dot-span-small visibility-hidden"
        },
        {
            "Id": "3",
            "class_step": "step1",
            "step_number": this.label.Step4,
            "step_title": this.label.Confirmation,
            "class_dot_indicator_left": "dot-span visibility-hidden",
            "class_dot_indicator_left_small": "dot-span-small visibility-hidden",
            "class_dot_indicator_right": "dot-span visibility-hidden",
            "class_dot_indicator_right_small": "dot-span-small visibility-hidden"
        },
        {
            "Id": "4",
            "class_step": "step1",
            "step_number": this.label.Step5,
            "step_title": this.label.Create_account,
            "class_dot_indicator_left": "dot-span visibility-hidden",
            "class_dot_indicator_left_small": "dot-span-small visibility-hidden",
            "class_dot_indicator_right": "dot-span visibility-hidden",
            "class_dot_indicator_right_small": "dot-span-small visibility-hidden"
        },
        {
            "Id": "5",
            "class_step": "step1",
            "step_number": this.label.Step6,
            "step_title": this.label.Quotation,
            "class_dot_indicator_left": "dot-span visibility-hidden",
            "class_dot_indicator_left_small": "dot-span-small visibility-hidden",
            "class_dot_indicator_right": "dot-span visibility-hidden",
            "class_dot_indicator_right_small": "dot-span-small visibility-hidden"
        }
    ]

    renderedCallback() {
        const index = parseInt(this.activeIndex) - 1
        const step = this.steps[index]
        let tempSteps = this.steps
        for (var i = 0; i <= index; i++) {
            tempSteps[i].class_step = "step1 step1-done"
            if (i > 0 && i < tempSteps.length) {
                tempSteps[i].class_dot_indicator_left = "dot-span"
                tempSteps[i].class_dot_indicator_left_small = "dot-span-small"
                tempSteps[i].class_dot_indicator_right = "dot-span"
                tempSteps[i].class_dot_indicator_right_small = "dot-span-small"
            }
        }
        this.steps = tempSteps
        // step.class_step = "slds-col step current"
    }

}