global with sharing class CustomLoginController {
    global String username{get;set;}
    global String password{get;set;}
    global CustomLoginController () {}
        
     
    global PageReference forwardToCustomAuthPage() {
       return new PageReference( '/Login'); 
    }
   
    global PageReference login() {
    	 try
    	           {
    	           	  CustomUser__c result = 
                       [SELECT Name,Password__c
                        FROM CustomUser__c 
                        WHERE Username__c = :username and Password__c = :password];
                        
                        //when found login
                        //Site.login(username, password, null);
                     
                     String inputString = password;
				String md5Coded = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(inputString)));

                        
                        return new PageReference( '/apex/Dashboard');  
           
    	           }catch(Exception e)
    	           {
    	           	ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid User and Password.'); 
           				ApexPages.addMessage(msg);
           				
    	           		/*ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid user and password.'); 
           				ApexPages.addMessage(msg);*/
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