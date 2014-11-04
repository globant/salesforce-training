@isTest
private class LoginControllerTest {
	
	@isTest static void login_successLogin() {
		
		System.test.startTest();
		
		LoginTestDataFActory.insertUser();

		LoginController loginController = new LoginController();
		loginController.email = 'frindex@gmail.com';
		loginController.password = 'pascal1981';
		
		PageReference pageReference = loginController.login();		
		
		System.test.stopTest();

		System.assertEquals(Page.Dashboard.getUrl(),pageReference.getUrl(),'The pagge should be Dashboard when is success login');
	}
	

	@isTest static void login_failLogin() {
		
		
		System.test.startTest();
		
		LoginTestDataFActory.insertUser();

		LoginController loginController = new LoginController();
		loginController.email = 'frindex@gmail.com';
		loginController.password = 'xxxxx';
		PageReference pageReference = loginController.login();		
		
		System.test.stopTest();

		boolean noLogin = pageReference==null?true:false;
		
		System.assertEquals(true,noLogin,'The function should be return null');		
	}
}