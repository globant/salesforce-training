public class ShopViewController  {

    List<Shop__c> Shops;

    public ShopViewController(){
    }

    public ShopViewController(ApexPages.StandardController controller) {
        Document d = (Document) controller.getRecord();
        d.folderid = UserInfo.getUserId(); //this puts it in My Personal Documents
    }

    public List<Shop__c> getShops() {
        if(Shops == null) {
           Shops = [SELECT Id, Name,Description__c, Sector__c,Sub_Category__c,URL__c,Employee_Count_Number__c,Logo__c FROM Shop__c];
        }
        return Shops;
    }

    public PageReference NewShop() {

        PageReference NewShop = Page.ShopNew;
        NewShop.setRedirect(true);

        return NewShop;
    }

    public PageReference EditShop() {

        String ShopID = Apexpages.currentPage().getParameters().get('ShopId');

        PageReference EditShop = Page.ShopEdit;
        EditShop.setRedirect(true);

        if (ShopID != null)
        {
            EditShop.getParameters().put('id',ShopID);
        }

        return EditShop;
    }

    public PageReference DeleteShop(){

        String ShopID = Apexpages.currentPage().getParameters().get('ShopId');

        PageReference ShopView = Page.ShopView;
        ShopView.setRedirect(true);

        if (ShopID != null)
        {
            Shop__c Shop = [select id, name from Shop__c where id =:ShopID];

            if (Shop != null)
            {
                delete Shop;
            }
        }

        return ShopView;
    }

    public PageReference GoDash(){

        PageReference DashBoard = Page.Dashboard;
        DashBoard.setRedirect(true);

        return DashBoard;
    }
}