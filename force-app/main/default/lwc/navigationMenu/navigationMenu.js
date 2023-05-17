import { LightningElement, api, wire, track } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
// import HAMBURGER_ICON from '@salesforce/resourceUrl/marketingHamburgerIcon';
// import X_ICON from '@salesforce/resourceUrl/marketingXIcon';
import getNavigationMenuItems from '@salesforce/apex/NavigationLinkSetPickList.getNavigationMenuItems';
import isGuestUser from '@salesforce/user/isGuest';
import basePath from '@salesforce/community/basePath';

/**
 * This is a custom LWC navigation menu component.
 * Make sure the Guest user profile has access to the NavigationMenuItemsController apex class.
 */
export default class NavigationMenu extends NavigationMixin(LightningElement) {
    @api buttonLabel;
    @api buttonRedirectPageAPIName;
    @api menuName;

    error;
    href = basePath;
    isLoaded;
    @track menuItems = [];
    @track singleMenuItems = []
    publishedState;
    showHamburgerMenu;


    hamburgerIcon = 'HAMBURGER_ICON';
    xIcon = 'X_ICON';

    @wire(getNavigationMenuItems, {
        menuName: '$menuName',
        publishedState: '$publishedState'
    })
    wiredMenuItems({ error, data }) {
        console.log('Menuitems::', data);
        if (data && !this.isLoaded) {
            let temp = data
                .map((item, index) => {
                    return {
                        target: item.Target,
                        id: item.Id,
                        parentId: item.ParentId,
                        label: item.Label,
                        defaultListViewId: item.DefaultListViewId,
                        type: item.Type,
                        accessRestriction: item.AccessRestriction
                    };
                })
                .filter((item) => {
                    // Only show "Public" items if guest user
                    return (
                        item.accessRestriction === 'None' ||
                        (item.accessRestriction === 'LoginRequired' &&
                            !isGuestUser)
                    );
                });
            console.log('temp::', JSON.stringify(temp));
            let parents = []
            for (const el of temp) {
                if (!el.parentId) {
                    parents.push(el)
                }
            }
            // let parents = temp.filter(el => !('parentId' in el))
            console.log('parents::', JSON.stringify(parents));
            this.menuItems = parents.map(el => {
                el['childs'] = temp.filter(el2 => (el2.parentId == el.id))
                return el
            })
            this.singleMenuItems = this.menuItems.filter(el => (el.childs.length == 0))
            this.menuItems = this.menuItems.filter(el => (el.childs.length != 0))
            console.log('final menuitems:', JSON.stringify(this.menuItems));

            this.error = undefined;
            this.isLoaded = true;
        } else if (error) {
            this.error = error;
            this.menuItems = [];
            this.isLoaded = true;
            console.log(`Menuitems menu error: ${JSON.stringify(this.error)}`);
        }
    }

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        const app =
            currentPageReference &&
            currentPageReference.state &&
            currentPageReference.state.app;
        if (app === 'commeditor') {
            this.publishedState = 'Draft';
        } else {
            this.publishedState = 'Live';
        }
    }

    handleClick() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: this.buttonRedirectPageAPIName
            }
        });
    }

    handleHamburgerMenuToggle(evt) {
        evt.stopPropagation();
        evt.preventDefault();
        if (this.showHamburgerMenu) {
            this.showHamburgerMenu = false;
        } else {
            this.showHamburgerMenu = true;
        }
    }
}