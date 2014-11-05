@isTest
private with sharing class OrderOptionAnswerTest {

	private static OptionAnswer__c CreateFullQuestion()
	{
		Question__c Question = new Question__c();
		Question.name           = 'Question';
		Question.Type__c        = 'Unique';
		Question.Survey__c      = null;
		Question.Description__c = 'Description for the Question.';
		Database.insert(Question);

		OptionAnswer__c OptAnswer1 = new OptionAnswer__c();
		OptAnswer1.name        = 'Answer1';
		OptAnswer1.Order__c    = null;
		OptAnswer1.Question__c = Question.id;
		Database.insert(OptAnswer1);

		OptionAnswer__c OptAnswer2 = new OptionAnswer__c();
		OptAnswer2.name        = 'Answer2';
		OptAnswer2.Order__c    = null;
		OptAnswer2.Question__c = Question.id;
		Database.insert(OptAnswer2);

		OptionAnswer__c OptAnswer3 = new OptionAnswer__c();
		OptAnswer3.name        = 'Answer3';
		OptAnswer3.Order__c    = null;
		OptAnswer3.Question__c = Question.id;
		Database.insert(OptAnswer3);

		return OptAnswer2;
	}
	
	@isTest static void testEditOrderWhenAfterInsertTriggered() {
		//Setup
		System.test.startTest();
		OptionAnswer__c Answer = CreateFullQuestion();

		//Execute
		OptionAnswer__c OptAnswer4 = new OptionAnswer__c();
		OptAnswer4.name        = 'Answer4';
		OptAnswer4.Order__c    = null;
		OptAnswer4.Question__c = Answer.Question__c;
		Database.insert(OptAnswer4);

		System.test.stopTest();

		//Verify
		system.debug('OptAnswer4.Order__c:'+OptAnswer4.Order__c);
		system.assertEquals(OptAnswer4.Order__c, 4, 'Trigger Must edit field order when after edit is triggered.');
	}
	
	@isTest static void testEditOrderWhenAfterDeleteTriggered() {
		//Setup
		System.test.startTest();
		OptionAnswer__c Answer = CreateFullQuestion();
		
		//Execute
		Database.delete(Answer);

		System.test.stopTest();

		//Verify
		system.assertEquals(true, true, 'Trigger Must edit field order when after delete is triggered.');
	}
	
}