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
            		
          	List<CustomRole__c> roleList = [SELECT Name FROM CustomRole__c WHERE Id = :user.Role__r.Id LIMIT 100];
          	if (roleList.size() > 0){
          		role = roleList.get(0);
          	}
        
  		}else{
  			Message = 'Invalid User and Password.!';
           	showErrorMessage = true;
       		showMessage = true;
  		} 	
   	}
   	
}