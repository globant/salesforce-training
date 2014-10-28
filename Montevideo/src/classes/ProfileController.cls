public with sharing class ProfileController extends CustomController {
 
    public ProfileController(){
        super();
        if (user != null){
            String pageName = Util.getCurrentPageName();
            if (!Util.checkPermissions(pageName, role.Name)){
                Util.goToError();
            }
        }
    }
    
    public PageReference save(){
        String passwordMD5 =  EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(user.Password__c)));
        user.Password__c = passwordMD5;
        update user;
        
        if (user.Role__r.Name == 'Customer'){
            PageReference dashboard = Page.Dashboard;
            dashboard.setRedirect(true);
            return dashboard;  
        }else if (user.Role__r.Name == 'ShopAdmin'){
            PageReference home = Page.Home;
            home.setRedirect(true);
            return home; 
        }
        return null;
    }
}