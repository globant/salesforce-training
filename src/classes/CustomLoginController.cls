global with sharing class CustomLoginController {
    global String username{get;set;}
    global String password{get;set;}
    global Boolean showErrorMessage{get;set;}
    global Boolean showMessage{get;set;}
    global String Message{get;set;}  
    global CustomLoginController () 
    {
       /* String label = ApexPages.currentPage().getParameters().get('mid');
        if(label != null)
        {
            if(label == '1')
            {
                Message = System.Label.Success1;
                showErrorMessage = false;
            }else
            {
                Message = System.Label.Error1;
                showErrorMessage = true;
            }
            
            showMessage = true; 
        }else{
        
        showMessage = false; 
        }*/
    }
    
    global PageReference forwardToCustomAuthPage() {
       return new PageReference( '/Login'); 
    }
    
    global PageReference login() {
        String md5Coded = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(password)));
        List<CustomUser__c> userList = [SELECT Name, Password__c, Role__r.Id, Role__r.Name, Session_Time__c
                                                FROM CustomUser__c 
                                                WHERE Username__c = :username and Password__c = :md5Coded];
        
    	
        if (userList.size()> 0){
                CustomUser__c user = userList.get(0);
                CookieManager.createCookie(user.Id, Integer.valueOf(user.Session_Time__c));
                if (user.Role__r.Name == 'Customer'){
                        PageReference dashboard = Page.Dashboard;
                        dashboard.setRedirect(true);
                        return dashboard;
                }else if (user.Role__r.Name == 'ShopAdmin'){
                        PageReference dashboardAdmin = Page.Home;
                        dashboardAdmin.setRedirect(true);
                        return dashboardAdmin; 
                }
        }
        
        PageReference login = Page.CustomLogin;
        login.setRedirect(true);
        return login;    
                
    }
    
    global void MD5Test()
    {
        String inputString = password;
        String md5Coded = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(inputString)));
        
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, md5Coded); 
        ApexPages.addMessage(msg);
    }
}