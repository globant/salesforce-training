global abstract with sharing class CustomController {

  	global CustomUser__C user{get;set;}
  	global Boolean showErrorMessage{get;set;}
  	global Boolean showMessage{get;set;}
  	global String Message{get;set;}
  	public CustomRole__c role {get; set;}
  	
  	global CustomController () 
  	{
  		Id userId = CookieManager.getLoggedUser();
  		if (userId != null){
  			user = [SELECT Name, Username__c, First_Name__c, Last_Name__c, Role__r.Id, Email__c, Password__c, Role__r.Name, Session_Time__c
            		FROM CustomUser__c 
            		WHERE Id = :userId LIMIT 100];
            
            Id roleId = user.Role__r.Id;  
          	List<CustomRole__c> roleList = [SELECT Name FROM CustomRole__c WHERE Id = :roleId LIMIT 100];
          	if (roleList.size() > 0){
          		role = roleList.get(0);
          		CookieManager.createCookie(userId, Integer.valueOf(user.Session_Time__c));
          	}
        
  		}else{
  			Message = 'Invalid User and Password.!';
           	showErrorMessage = true;
       		showMessage = true;
  		} 	
   	}
   	
   	global PageReference getCheckPermissions(){
        String page = Util.getCurrentPageName();
      	if (!Util.checkPermissions(page, role.Name)){
        	return Util.goToError();
        }
        return null;
    }
   	
}