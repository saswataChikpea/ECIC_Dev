@isTest
public class NavigationLinkSetPickListTest {
    @isTest
    public static  void defaultValuetest(){
        NavigationLinkSetPickList nav = new NavigationLinkSetPickList();
        nav.getDefaultValue();
        nav.getValues();
        
    }
    @isTest(seeAlldata = true) 
    public static void getNavigationMenuItemstest(){
        NavigationLinkSetPickList.getNavigationMenuItems('menuName', 'test1');
        NavigationLinkSetPickList.getNavigationMenuItems('', 'test1');
        
    }
}