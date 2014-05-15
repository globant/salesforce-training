public with sharing class Util {
	
	public static  List<String> shopAdminPermissions = new List<String> { 'DashboardAdmin', 'two' };
	public static  List<String> customerPermissions = new List<String> { 'Dashboard', 'two' };
	
	public static Boolean checkPermissions(String page, String role){
				
		if (role == 'ShopAdmin' && contains(shopAdminPermissions, role)){//if user is shopAdmin
			return true;
		}else if (role == 'Customer' && contains(customerPermissions, role)){ //if user is customer
			return true;
		}	
		return false;
	}
	
	private static Boolean contains(List<String> theList, String theString){
		for (String s : theList){
			if (s == theString){
				return true;
			}
		}
		return false;
	}
	
	public static String getCurrentPageName(){
		String strurl = ApexPages.currentPage().getUrl();
		strurl = strurl.split('apex/')[1];
		return strurl;
	}
	
	public static PageReference goToError(){
		Pagereference goToErrorPage = Page.Error;
        goToErrorPage.setRedirect(true);
        return goToErrorPage; 
	}
}