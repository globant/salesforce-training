public class CustomUserController {

    public PageReference save() {
        Insert customUser;
        return null;
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