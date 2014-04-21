public class CustomUserController {

    public PageReference save() {
    
        String inputString = customUser.Password__c;
        String md5Coded = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(inputString)));
        customUser.Password__c = md5Coded ;
        CustomRole__c customerRole;
        customerRole = [select Id from CustomRole__c WHERE Name = 'Customer' LIMIT 1];
        customUser.Role__c = customerRole.Id;
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