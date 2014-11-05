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
}