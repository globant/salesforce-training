public with sharing class Util {
	
	public static  List<String> shopAdminPermissions = new List<String> { 'home', 'createsurvey', 'assignsurvey' };
	public static  List<String> customerPermissions = new List<String> { 'dashboard'};
	
	public static Boolean checkPermissions(String page, String role){
				
		if (role == 'ShopAdmin' && contains(shopAdminPermissions, page)){//if user is shopAdmin
			return true;
		}else if (role == 'Customer' && contains(customerPermissions, page)){ //if user is customer
			return true;
		}	
		return false;
	}
	
	private static Boolean contains(List<String> theList, String theString){
		for (String s : theList){
			if (s.toLowerCase() == theString.toLowerCase()){
				return true;
			}
		}
		return false;
	}
	
	public static String getCurrentPageName(){
		String strurl = ApexPages.currentPage().getUrl();
		strurl = strurl.split('apex/')[1];
		strurl = strurl.split('\\?')[0];
		return strurl;
	}
	
	public static PageReference goToError(){
		Pagereference goToErrorPage = Page.Error;
        goToErrorPage.setRedirect(true);
        return goToErrorPage;
	}
}