public class CommerceProfileController{
    public List<Shop__c> associatedShops{get;set;}
    public Shop__c currentShop{get;set;}
    public String shopIdChosen {get; set;}
    
    public CommerceProfileController(){
        associatedShops = [SELECT Name, Site__c, Logo_Url__c FROM Shop__c];
   
    }
    public PageReference showCommerce(){
         currentShop = [SELECT Name, Site__c, Logo_Url__c FROM Shop__c WHERE Id = :shopIdChosen]; 
         return null;
    }
}