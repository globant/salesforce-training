@isTest
public class LoginTestDataFActory {
	
	public static void insertUser(){
		
		User__c u = new User__c();
    	u.DNI__c = 15962142;
        u.Email__c = 'frindex@gmail.com';
        u.First_Name__c = 'john';
        u.Last_Name__c = 'franco';
        u.Password__c = 'pascal1981';
        u.Name = 'frindex@gmail.com';

        insert u;        
	}
	
}