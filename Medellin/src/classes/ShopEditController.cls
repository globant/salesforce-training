public class ShopEditController {

    Shop__c Shop;

    public String Sid                    {get; set;}
    public String Name                   {get; set;}
    public String Description            {get; set;}
    public String Sector                 {get; set;}
    public String Sub_Category           {get; set;}
    public String URL                    {get; set;}
    public Decimal Employee_Count_Number {get; set;}
    public String Logo {get{

            Logo = '/servlet/servlet.FileDownload?file=';

            List<Attachment> attachedFiles = [select Id from Attachment where parentId =:Sid order By LastModifiedDate DESC limit 1];

            if( attachedFiles != null && attachedFiles.size() > 0 ) {
                Logo += attachedFiles[0].Id;
            }
            else Logo = '';

            return Logo;
        } set;}

    public Blob   attachmentBody {get; set;}
    public String attachmentName {get; set;}

    Map<String, List<String>> DependencyMatrix = new Map<String, List<String>>();

    public ShopEditController (){
        // this matrix should be loaded dynamically from the framework!
        DependencyMatrix.put('Agroindustria', new List<String>{'Producción Lechera','Producción Avicola'});
        DependencyMatrix.put('Alimento'     , new List<String>{'Producción Lechera','Producción Avicola'});
        DependencyMatrix.put('Contrucción'  , new List<String>{'Aereo','Marítimo'});
        DependencyMatrix.put('Manufactura'  , new List<String>{'Celular','Tablet'});
        DependencyMatrix.put('Tecnología'   , new List<String>{'Celular','Tablet'});

    }

    public ShopEditController (ApexPages.StandardController controller) {

        Document d = (Document) controller.getRecord();
        d.folderid = UserInfo.getUserId(); //this puts it in My Personal Documents
    }

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

       for (String Key: DependencyMatrix.keySet())
       {
            if(Key == Sector)
            {
                for(String nombre: DependencyMatrix.get(Key))
                {
                    SubSectorOptions.add(new SelectOption(nombre, nombre));
                }
            }
       }

        return SubSectorOptions;
    }

    public Shop__c getShop() {

        if(Shop == null)
        {
            Shop = new Shop__c();
            Shop = [select id,Name, Logo__c, Description__c,Employee_Count_Number__c,  Sector__c,
                    Sub_Category__c, URL__c from Shop__c where id = :ApexPages.currentPage().getParameters().get('id')];

            Sid                    = Shop.id                       ;
            Name                   = Shop.Name                     ;
            Logo                   = Shop.Logo__c                  ;
            Description            = Shop.Description__c           ;
            Employee_Count_Number  = Shop.Employee_Count_Number__c ;
            Sector                 = Shop.Sector__c                ;
            Sub_Category           = Shop.Sub_Category__c          ;
            URL                    = Shop.URL__c                   ;
        }

        return Shop;
    }

    public PageReference UpdateShop() {
/*
        Shop.id                       = Sid;
        Shop.Name                     = Name;
        Shop.Logo__c                  = Logo;
        Shop.Description__c           = Description;
        Shop.Employee_Count_Number__c = Employee_Count_Number;
        Shop.URL__c                   = URL;*/

        update Shop;

        if((attachmentName != null) && (attachmentBody!= null))
        {
            Attachment newAtt = new Attachment();
            newAtt.name = attachmentName;
            newAtt.body = attachmentBody;
            newAtt.parentID = Sid;
            insert newAtt;
        }

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

        Sector = Apexpages.currentPage().getParameters().get('UpdateSector');
        return null;
    }

}