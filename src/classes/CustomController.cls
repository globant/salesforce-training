global abstract with sharing class CustomController {

  global CustomUser__C user{get;set;}
  global Boolean showErrorMessage{get;set;}
  global Boolean showMessage{get;set;}
  global String Message{get;set;}
    
  global CustomController () 
  {    
    SessionData__c username = SessionData__c.getInstance('CustomUserName');
    System.debug('username' + username);
    try
    {
      user = [SELECT Name,Password__c, Username__c
            FROM CustomUser__c 
            WHERE Username__c = :username.CustomUserName__c];
        }
        catch(Exception e)
      {
         Message = 'Invalid User and Password.!';
           showErrorMessage = true;
       showMessage = true;
        }
   }
}