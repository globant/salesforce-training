public class ShopNewController  {

    Shop__c Shop = new Shop__c();
    List<Shop__c> Shops;

    public String Name                {get; set;}
    public String Logo                {get; set;}
    public String Description         {get; set;}
    public Long Employee_Count_Number {get; set;}
    public String Sector              {get; set;}
    public String Sub_Category        {get; set;}
    public String URL                 {get; set;}

    Map<String, List<String>> DependencyMatrix = new Map<String, List<String>>();

    public ShopNewController(){

        DependencyMatrix.put('Agroindustria', new List<String>{'Produccion Lechera','Produccion Avicola'});
        DependencyMatrix.put('Alimento'     , new List<String>{'Produccion Lechera'});
        DependencyMatrix.put('Contrucción'  , new List<String>{'Aereo','Maritimo'});
        DependencyMatrix.put('Manufactura'  , new List<String>{'Celular','Tablet','Smartphone'});
        DependencyMatrix.put('Tecnología'   , new List<String>{'Celular','Tablet','Smartphone'});

    }
/*
    public ShopNewController(ApexPages.StandardController controller) {
        Document d = (Document) controller.getRecord();
        d.folderid = UserInfo.getUserId(); //this puts it in My Personal Documents
    }*/

    public List<SelectOption> getSectorOptions() {

        List<SelectOption> SectorOptions = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Shop__c.Sector__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

           for( Schema.PicklistEntry f : ple)
           {
              SectorOptions.add(new SelectOption(f.getLabel(), f.getValue()));
           }

        return SectorOptions;
    }

    public List<SelectOption> getSub_CategoryOptions() {

        List<SelectOption> SubSectorOptions = new List<SelectOption>();

        if(Sector != '' && Sector != null)
        {
           for (String Key: DependencyMatrix.keySet())
           {
                if(Key == Sector)//Sub_Category
                {
                    for(String nombre: DependencyMatrix.get(Key))
                    {
                        SubSectorOptions.add(new SelectOption(nombre, nombre));
                    }
                }
           }
        }
        else SubSectorOptions.add(new SelectOption('-1', 'Select a Sector'));

        return SubSectorOptions;
    }

    public List<Shop__c> getShops() {
        if(Shops == null) {
           Shops = [SELECT Id, Name,Description__c, Sector__c,Sub_Category__c,URL__c,Employee_Count_Number__c,Logo__c FROM Shop__c];
        }
        return Shops;
    }

    public Shop__c getShop() {
        return [select name, Logo__c, Description__c,Employee_Count_Number__c,  Sector__c,
                Sub_Category__c, URL__c from Shop__c where id = :ApexPages.currentPage().getParameters().get('id')];
    }

    public PageReference registerShop() {

        Shop.Name                     = Name;
        Shop.Logo__c                  = Logo;
        Shop.Description__c           = Description;
        Shop.Employee_Count_Number__c = Employee_Count_Number;
        Shop.Sector__c                = Sector;
        Shop.Sub_Category__c          = Sub_Category;
        Shop.URL__c                   = URL;

        insert Shop;

        PageReference ShopView = Page.ShopView;
        ShopView.setRedirect(true);

        return ShopView;
    }

    public PageReference Cancel(){

        PageReference ShopView = Page.ShopView;
        ShopView.setRedirect(true);

        return ShopView;
    }

    public PageReference UpdateSubCategory(){

        Sub_Category = Apexpages.currentPage().getParameters().get('UpdateSubCategory');
        return null;
    }

    public PageReference UpdateSector(){

        Sector       = Apexpages.currentPage().getParameters().get('UpdateSector');
        return null;
    }

}