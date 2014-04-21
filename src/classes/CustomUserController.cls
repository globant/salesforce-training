public class CustomUserController {

    public PageReference save() {
    
        String inputString = customUser.Password__c;
        String md5Coded = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(inputString)));
        customUser.Password__c = md5Coded ;
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