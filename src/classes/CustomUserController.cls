public class CustomUserController {

    public PageReference save() {
        Insert customUser;
        return new PageReference( '/apex/CustomLogin'); 
    }
    
    
    public CustomUser__c customUser {
    get {
      if (customUser == null)
      {
        customUser = new CustomUser__c();
      }
      return customUser ;
    }
    set;
  }
    
}