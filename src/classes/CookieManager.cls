public with sharing class CookieManager {
	
	public static void createCookie(ID userId, Integer sessiontime){
		
		Cookie session =  ApexPages.currentPage().getCookies().get('sessionID');
		if (sessionTime == null){
			sessionTime = 10;
		}
		session = new Cookie('sessionID',userId,null,sessiontime*60,false);
        ApexPages.currentPage().setCookies(new Cookie[]{session});
	}
	
	public static Id getLoggedUser(){
		Cookie session = ApexPages.currentPage().getCookies().get('sessionID');
		if (session != null && session.getValue() != null){
			Id userId = Id.valueOf(session.getValue());
			return userId;
		}
		return null;
		
	}
	
	public static void logout(){
		Cookie session = ApexPages.currentPage().getCookies().get('sessionID');
		if (session != null){
			session = new Cookie('sessionID', null,null,-1,false);
			ApexPages.currentPage().setCookies(new Cookie[]{session});
		}
	}
	

}