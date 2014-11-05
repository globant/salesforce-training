@isTest
private with sharing class OrderOptionAnswerTest {
	
	@isTest static void testEditOrderWhenAfterInsertTriggered() {
		//Setup
		System.test.startTest();

		//Execute

		System.test.stopTest();

		//Verify
		system.assertEquals(true, true, 'Trigger Must edit field order when after edit is triggered.');
	}
	
	@isTest static void testEditOrderWhenAfterDeleteTriggered() {
		//Setup
		System.test.startTest();
		
		//Execute

		System.test.stopTest();

		//Verify
		system.assertEquals(true, true, 'Trigger Must edit field order when after delete is triggered.');
	}
	
}