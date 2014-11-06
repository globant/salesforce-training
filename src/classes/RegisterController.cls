public class RegisterController {

     public RegisterController () {
    }
    
    public Long dni {get; set;}
    public String firstName {get; set;}
    public String lastName {get; set;}    
    public String email {get; set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = 
        value == null ? value : value.trim(); }}
          
    private boolean isValidPassword() {
        return password == confirmPassword;
    }
    
    private boolean isValidUser(User__c user){
        //Query looking for user with unique DNI        
        List<User__c> userTemp = [SELECT u.Email__c 
                            FROM User__c u 
                            WHERE u.DNI__c = :user.DNI__c];        
        if(userTemp != null && userTemp.size()>0 && userTemp.size()<2){
            return false;
        }
        return true;
    }
    
    public PageReference registerUser() {        
        if (!isValidPassword()) {
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Password do not match');
           ApexPages.addMessage(msg);
            return null;
        }
        
        if(password.length() < 6){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Password should have at least 6 characters');
            ApexPages.addMessage(msg);
            return null;
        }

         String dniString = '';

        try{
           dniString = String.valueOf(dni);
        }catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The value should be a long number');
        }

        if(dniString.length() > 10){
             ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'DNI should not have more than 10 characters');
            ApexPages.addMessage(msg);
            return null;
        }
        
        User__c u = new User__c();
        u.DNI__c = dni;
        u.Email__c = email;
        u.First_Name__c = firstName;
        u.Last_Name__c = lastName;
        u.Password__c = password;
        u.Name = email;
                
        if(!isValidUser(u)){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'User already exist');
            ApexPages.addMessage(msg);
            return null;                     
        }
        
        insert u;   
        PageReference page = new PageReference('/apex/Login');
        page.setRedirect(true);
        return page;        
    }
}