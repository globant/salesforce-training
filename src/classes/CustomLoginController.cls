global with sharing class CustomLoginController {
    global String username{get;set;}
    global String password{get;set;}
    global Boolean showErrorMessage{get;set;}
    global Boolean showMessage{get;set;}
	global String Message{get;set;}  
    global CustomLoginController () 
    {
    	String label = ApexPages.currentPage().getParameters().get('mid');
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
    	}
    }
    global PageReference forwardToCustomAuthPage() {
       return new PageReference( '/Login'); 
    }
   
    global PageReference login() {
    	 try
    	           {
    	           	
    	           	  String inputString = password;
				String md5Coded = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(inputString)));
    	           	
    	           	  CustomUser__c result = 
                       [SELECT Name,Password__c
                        FROM CustomUser__c 
                        WHERE Username__c = :username and Password__c = :md5Coded];
                         
                        //when found login
                         //Site.login(username, password, null);
				try{
					
				Database.Saveresult sessionResult2 = Database.insert(new SessionData__c(CustomUserName__c = username, Name='CustomUserName'));
					SessionData__c sessionData = SessionData__c.getInstance('CustomUserName');
					System.debug(sessionData.Id);
					if(sessionData != null)
					{
						Database.delete(sessionData.Id);
					}					
					Database.insert(new SessionData__c(CustomUserName__c = username, Name='CustomUserName'));
					
				}catch(Exception ex)
				{
					System.debug(ex.getMessage() + 'exmessage');
					return new PageReference( '/apex/CustomLogin');     
				}
                     
                        return new PageReference( '/apex/Dashboard');  
           
    	           }catch(Exception e)
    	           {
    	           	Message = 'Invalid User and Password.!';
    	           	showErrorMessage = true;
					showMessage = true;
    	           }
 			return new PageReference( '/apex/CustomLogin');        
    }
    
    global void MD5Test()
    {
    	  String inputString = password;
		  String md5Coded = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(inputString)));
		  
  	            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, md5Coded); 
           				ApexPages.addMessage(msg);
                    
    }
}