import { api, LightningElement, track } from 'lwc';

export default class OnboardingHome extends LightningElement {
    @api products
    @api selectedproduct
    @api boardingSetting
    @track selectedproductId
    @track productList
    fetchProductSuccessful = false
    @track productSelected = false
    // products = [{ "Id": "a07N000000Rb3TCIAZ", "Name": "OMBP", "Premium_Rate__c": 0.8, "Image_Url__c": "/servlet/servlet.ImageServer?id=0150x000000dIHI&oid=00D0x000000H6OH&lastMod=1619163940000", "Full_Name__c": "Online Micro Business Policy", "Display_Sequence__c": 1 }, { "Id": "a07N000000Rb3TDIAZ", "Name": "SBP", "Image_Url__c": "/servlet/servlet.FileDownload?file=0150x000000ctzu", "Full_Name__c": "Small Business Policy", "Display_Sequence__c": 2 }, { "Id": "a07N000000Rb3TBIAZ", "Name": "SUP", "Premium_Rate__c": 103, "Image_Url__c": "/servlet/servlet.FileDownload?file=0150x000000ctzz", "Full_Name__c": "Self Underwritten Policy", "Display_Sequence__c": 3 }]

    connectedCallback() {
        console.log("connected => selected Product", this.selectedproduct)
        // console.log("connected => ##***meta data=", this.boardingSetting.Step_1A_Banner__c)
        if (this.selectedproduct) {
            this.selectedproductId = this.selectedproduct
        }
    }
    renderedCallback() {
        console.log("products", this.products)
        console.log("selectedproduct", this.selectedproduct)
        if (this.productSelected || (!this.fetchProductSuccessful && this.products !== undefined)) {
            this.products = this.products.reduce((result, el) => {
                result.push({
                    ...el,
                    className: (this.selectedproductId === el.Id) ? "slds-col slds-size_1-of-1 slds-large-size_1-of-3 card " : "slds-col slds-size_1-of-1 slds-large-size_1-of-3 card",
                })
                return result
            }, [])
            // console.log("setting productlist", JSON.stringify(this.products))
            this.fetchProductSuccessful = true
            this.productSelected = false
        }
    }
    handleProductSelect(event) {
        console.log(event.currentTarget.id)
        let id = event.currentTarget.id + ""
        id = id.split("-")[0]
        this.selectedproductId = id
        this.productSelected = true

        this.products = this.products.reduce((result, el) => {
            result.push({
                ...el,
                className: (id === el.Id) ? "slds-col slds-size_1-of-1 slds-large-size_1-of-3 card " : "slds-col slds-size_1-of-1 slds-large-size_1-of-3 card",
            })
            return result
        }, [])

        const event1 = new CustomEvent('productselected', {
            // detail contains only primitives
            detail: { selected_product: id }
        });
        this.dispatchEvent(event1)

    }
    showOnboardingDP() {
        if (!this.selectedproductId) {
            alert("Please select a product to continue")
            return
        }
        console.log(' ====> handleOnboardingDP')
        const event1 = new CustomEvent('handlepagechange', {
            // detail contains only primitives
            detail: { pageId: 'showOnboardingDP', source: 'showOnboardingHome' }
        });
        this.dispatchEvent(event1)
    }
    showOnboardingPI(event) {
        console.log('showOnboardingDP ====> ')
        const event1 = new CustomEvent('handlepagechange', {
            // detail contains only primitives
            detail: { pageId: 'showOnboardingPI', source: 'showOnboardingHome' }
        });
        this.dispatchEvent(event1)
    }
    showProductCom(event) {
        console.log('showProductCom ====> ')
        const event1 = new CustomEvent('handlepagechange', {
            // detail contains only primitives
            detail: { pageId: 'showProductCom', source: 'showOnboardingHome' }
        });
        this.dispatchEvent(event1)
    }


}