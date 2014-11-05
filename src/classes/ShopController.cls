public class ShopController {

    public ShopController(){

    }

    public ShopController(ApexPages.StandardController controller) {
        Document d = (Document) controller.getRecord();
        d.folderid = UserInfo.getUserId(); //this puts it in My Personal Documents
    }

     List<Shop__c> Shops;

    public String Name                {get; set;}
    public String Logo                {get; set;}
    public String Description         {get; set;}
    public Long Employee_Count_Number {get; set;}
    public String Sector              {get; set;}
    public String Sub_Category        {get; set;}
    public String URL                 {get; set;}

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
 
       private List<SelectOption> SubSectorOptions = new List<SelectOption>();
    public List<SelectOption> getSub_CategoryOptions() {
 

        Schema.DescribeFieldResult fieldResult = Shop__c.Sub_Category__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

           for( Schema.PicklistEntry f : ple)
           {
            if(passedParam1!='')
              SubSectorOptions.add(new SelectOption(f.getLabel(), f.getValue()+passedParam1));
           }

            return SubSectorOptions;
        }

    public List<Shop__c> getShops() {
        if(Shops == null) {
           Shops = [SELECT Id, Name__c,Description__c, Sector__c,Sub_Category__c,URL__c,Employee_Count_Number__c,Logo__c FROM Shop__c];
        }
        return Shops;
    }

    public PageReference registerShop() {

        Shop__c Shop = new Shop__c();

        Shop.Name__c                  = Name;
        Shop.Logo__c                  = Logo;
        Shop.Description__c           = Description;
        Shop.Employee_Count_Number__c = Employee_Count_Number;
        Shop.Sector__c                = Sector;
        Shop.Sub_Category__c          = Sub_Category;
        Shop.URL__c                   = URL;

        insert Shop;

        return null;
    }

    public PageReference save(){
        return null;
    }

public String passedParam1 {get;set;}

public PageReference UpdateSubCategory(){
passedParam1 = Apexpages.currentPage().getParameters().get('Selected');
SubSectorOptions.clear();
 
SubSectorOptions.add(new SelectOption('test', passedParam1));
 
return null;

}
    
}