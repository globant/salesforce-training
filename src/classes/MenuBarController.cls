public with sharing class MenuBarController {
	
	public PageReference logout(){
   		CookieManager.logout();
   		PageReference login = Page.CustomLogin;
        login.setRedirect(true);
        return login;
   	}  

}