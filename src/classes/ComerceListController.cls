public with sharing class ComerceListController {

	public List<Shop__c> shops {get;set;}
	public String redirectUrl{get;set;}
	public boolean shouldRedirect{get;set;}

	public ComerceListController() {
		getShopsByUser();
	}

	public void getShopsByUser(){
		User__c userObject = null;
		
		if(ApexPages.currentPage().getCookies().get('session') != null){						
			ID idSession = ID.valueOf(ApexPages.currentPage().getCookies().get('session').getValue());
			userObject = User.getUserObject(idSession);
			if(userObject != null){
				ID userId = userObject.Id;			
				shops = [SELECT s.Id,s.Logo__c,s.Name,s.Description__c,s.URL__c 
						FROM Shop__c s 
						WHERE s.Id in ( SELECT us.Shop__c	FROM UserShopJunt__c us	WHERE us.User__c = :userId)];				
			}
		}
	}

	public PageReference goToStatistics(){
		String shopID = Apexpages.currentPage().getParameters().get('shopId');	
		redirectUrl = '/apex/ComercePage?shopId=' + shopID;
		shouldRedirect = true;
        return null;		
	}
}