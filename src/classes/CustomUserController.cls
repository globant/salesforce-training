public class CustomUserController {
        
        public CustomUser__c customUser {get; set;}
        public String confirmPassword {get; set;}
        public String Message {get; set;}
        public Boolean showErrorMessage{get;set;}
    	public Boolean showMessage{get;set;}
        
        public CustomUserController(){
                customUser = new CustomUser__c();
        }
        
        private Boolean existUser(){
                List<CustomUser__c> userList = [select Id from CustomUser__c WHERE (Email__c = :customUser.Email__c or Username__c = :customUser.Username__c)];
                if (userList.size()>0){
                        return true;
                }
                return false;
        }
        
        private Boolean existCustomerRole(){
                List<CustomRole__c> roleList = [select Id from CustomRole__c WHERE Name = 'Customer'];
                if (roleList.size() > 0){
                        customUser.Role__c = roleList.get(0).Id;
                        return true;
                }
                return false;
        }

    public PageReference save() {
        
        if (existUser()){
                //if exist an other user with this email
                PageReference login = Page.CustomLogin;
                login.getParameters().put('mid', '1');
                login.setRedirect(true);
                return login;
        }else{
                if (existCustomerRole()){
                    String encodedPassword = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(customUser.Password__c)));
                        customUser.Password__c = encodedPassword ;
                        customUser.Name__c = customUser.First_Name__c + ' ' + customUser.Last_Name__c;
                        Insert customUser;
                        PageReference login = Page.CustomLogin;
                        login.setRedirect(true);
                        return login;
                }
               
                //if not exist customer role 
                PageReference login = Page.Login;
                login.getParameters().put('mid', '2');
                login.setRedirect(true);
                return login;
        }
         
    }
    
    
}