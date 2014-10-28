public class RegisterController {  
    
    public RegisterController () {
    }
	    
    @RemoteAction
    public static String register(String email,String firstName,String lastName,String dni,String password){
         
        if(password.length() < 6){
            return 'Password should have at least 6 characters';            
        }
        
        User__c u = new User__c();
        u.DNI__c = Integer.valueOf(dni);
        u.Email__c = email;
        u.First_Name__c = firstName;
        u.Last_Name__c = lastName;
        u.Password__c = password;
        u.Name = email;
        
        
        if(!isValidUser(u)){
            return 'User already exist';            
        }
        
        insert u;   
        
        return 'OK';        
    }

     private static boolean isValidUser(User__c user){
        //Query looking for a emailUser with unique field DNI
        List<User__c> userTemp = [SELECT u.Email__c 
                            FROM User__c u 
                            WHERE u.DNI__c = :user.DNI__c];        
        if(userTemp != null && userTemp.size()>0){
            return false;
        }
        return true;
    }
    
}