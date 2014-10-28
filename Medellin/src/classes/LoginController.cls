public class LoginController {
    
    public String email { get; set; }
    public String password { get; set; }

    public LoginController(){}
    
    public PageReference login() {
        
        //System.debug('************ ingrese con: ************ '+email+' '+password);

        String error = '';

        List<User__c> users = [SELECT u.Email__c,u.Password__c,u.DNI__c,u.Id FROM User__c u WHERE u.Email__c = :email];
        
        if(users == null || users.size()==0){
            error = 'Incorrect user name';                        
        }else{
            
            if(!password.equals(users.get(0).Password__c)) {
                error = 'Password dont match';                
            }
        }

        if(!String.isEmpty(error)){
            
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, error);
            ApexPages.addMessage(msg);
            //System.debug('************ no encontre nada: ************ '+email+' '+password);

        }else{
            
            PageReference page = new PageReference('/apex/Dashboard');
            Cookie userCookie = new Cookie('session', String.valueOf(users.get(0).Id), '/', 1000, false); 

            page.setCookies(new Cookie[] {
                userCookie
            });
    
            page.setRedirect(true);
            //System.debug('************ los datos son correctos '+email+' '+password);
            return page;        

        }

        return null;
    }    
}