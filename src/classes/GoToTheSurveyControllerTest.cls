@isTest
private class GoToTheSurveyControllerTest {
	
	private static Coupon__c SetupGoToTheSurveyCoupon(){
		Coupon__c coupon = new Coupon__c();
		coupon.Disccount__c = 45;
		coupon.reason__c = 'Bulky purchase';
		coupon.status__c = 'Not used';

		insert coupon;
		coupon = [SELECT Id, Disccount__c, reason__c,status__c, Name from Coupon__c where Id = :coupon.Id];
		return coupon;


	}

	private static Shop__c SetupGoToTheSurveyShop(){
		Shop__c shop = new Shop__c();
		shop.name = 'TempShop'; 
		shop.URL__c = 'http://www.TempShop.com'; 
		shop.Employee_Count_Number__c = 5; 
		shop.Description__c  = 'TempShop'; 	
		shop.Sector__c       = 'Manufactura';
		shop.Sub_Category__c = 'Celular';

		insert shop;
		return shop;
	}

	private static Survey__c SetupGoToTheSurveySurvey(Shop__c shop){
		Survey__c survey = new Survey__c();
		survey.Title__c = 'Tittle';
		survey.Description__c = 'Description';
		survey.Shop__r = shop;

		insert survey;

		return survey;
	}

	private static  User__c SetupGoToTheSurveyUser(){
		User__c userCustom = new User__c();
		userCustom.DNI__c = 123456;
		userCustom.Email__c = '12@email.com';
		userCustom.First_Name__c = 'firstName';
		userCustom.Last_Name__c = 'lastName';
		userCustom.Password__c = '123';

		insert userCustom;
		return userCustom;
	}

	private static SurveyAnswer__c SetupGoToTheSurveySurveyAnswer(Coupon__c coupon, User__c user, Survey__c survey){
		SurveyAnswer__c surveyAnswerCustom = new SurveyAnswer__c();
		surveyAnswerCustom.Coupon__c = coupon.Id;
		surveyAnswerCustom.DNIUser__c = user.Id;
		surveyAnswerCustom.Survey__c = survey.Id;
		surveyAnswerCustom.State__c = 'Complete';
		date myDate = date.newInstance(1990, 11, 21);
		
		surveyAnswerCustom.Date__c = myDate;

		insert surveyAnswerCustom;
		return surveyAnswerCustom;

		
	}

	@isTest
	public static  void testCouponExist(){
		// Setup
		System.test.startTest();
		
		Coupon__c coupon = SetupGoToTheSurveyCoupon();
		GoToTheSurveyController goToTheSurvey = new GoToTheSurveyController();
		goToTheSurvey.code = coupon.Name;
		
		boolean couponExist = goToTheSurvey.couponExist();
		
		
		system.assertEquals(true,couponExist);
		System.test.stopTest();
	}

	@isTest
	public static void testCouponDoesNotExist(){
		// Setup
		System.test.startTest();
		
		GoToTheSurveyController goToTheSurvey = new GoToTheSurveyController();
		goToTheSurvey.code = 'doesnotexist';
		
		boolean couponExist = goToTheSurvey.couponExist();
		
		
		system.assertEquals(false,couponExist);
		System.test.stopTest();
	}

	@isTest
	public static void testIsTheSurveyComplete(){
		// Setup
		System.test.startTest();

		Coupon__c coupon = SetupGoToTheSurveyCoupon();
		Shop__c shop = SetupGoToTheSurveyShop();
		Survey__c survey = SetupGoToTheSurveySurvey(shop);
		User__c user = SetupGoToTheSurveyUser();
		SurveyAnswer__c surveyAnswer  = SetupGoToTheSurveySurveyAnswer(coupon, user, survey);

		GoToTheSurveyController goToTheSurvey = new GoToTheSurveyController();

		goToTheSurvey.coupon = coupon;

		boolean isTheSurveyComplete = goToTheSurvey.isTheSurveyComplete();


		system.assertEquals(true,isTheSurveyComplete);
		System.test.stopTest();



	}

	@isTest
	public static void testIsTheSurveyNotComplete(){
		// Setup
		System.test.startTest();

		Coupon__c coupon = SetupGoToTheSurveyCoupon();
		Shop__c shop = SetupGoToTheSurveyShop();
		Survey__c survey = SetupGoToTheSurveySurvey(shop);
		User__c user = SetupGoToTheSurveyUser();
		SurveyAnswer__c surveyAnswer  = SetupGoToTheSurveySurveyAnswer(coupon, user, survey);
		surveyAnswer.State__c = 'Incomplete';

		GoToTheSurveyController goToTheSurvey = new GoToTheSurveyController();

		goToTheSurvey.coupon = coupon;

		boolean isTheSurveyComplete = goToTheSurvey.isTheSurveyComplete();


		system.assertEquals(false,isTheSurveyComplete);
		System.test.stopTest();
	}

}