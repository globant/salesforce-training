public with sharing class CookieManager {
	
	public static void createCookie(ID userId){
		
		Cookie session =  ApexPages.currentPage().getCookies().get('sessionID');
		//Page.CustomLogin.getCookies().get('sessionID');
    
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        if (session == null) {
            session = new Cookie('sessionID',userId,null,3600,false);
        } else {
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
            //Integer count = Integer.valueOf(counter.getValue());
            session = new Cookie('sessionID', userId,null,3600,false);
        }
    
        // Set the new cookie for the page
       ApexPages.currentPage().setCookies(new Cookie[]{session});
	
	}
	
	public static Cookie getCookie(){
		Cookie session = ApexPages.currentPage().getCookies().get('sessionID');
		return session;
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
			session = new Cookie('sessionID', null,null,0,false);
		}
	}
	

}