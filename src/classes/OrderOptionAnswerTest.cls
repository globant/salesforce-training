@isTest
private with sharing class OrderOptionAnswerTest {

	private static OptionAnswer__c CreateFullQuestion()
	{
		Shop__c Shop = new Shop__c();
		Shop.name                     = 'Shop Name';
		Shop.URL__c                   = 'URL Shop';
		Shop.Description__c           = 'Shop Description';
		Shop.Employee_Count_Number__c = 10;
		Database.insert(Shop);

		Survey__c Survey = new Survey__c();
		Survey.name           = 'SurveyName';
		Survey.Shop__c        = Shop.id;
		Survey.Title__c       = 'Survey Title';
		Survey.Description__c = 'Survey Description';
		Database.insert(Survey);

		Question__c Question = new Question__c();
		Question.name           = 'Question';
		Question.Type__c        = 'Unique';
		Question.Survey__c      = Survey.id;
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

		boolean inOrder = True;
		Integer Step = 0;
		List<OptionAnswer__c> Answers = [SELECT Order__c FROM OptionAnswer__c WHERE Question__c = :Answer.Question__c ORDER BY Order__c];

		for(OptionAnswer__c Result : Answers)
		{
			inOrder &= Result.Order__c == ++Step;
		}

		System.test.stopTest();

		//Verify
		system.assertEquals(inOrder, True, 'Trigger Must edit field "order__c" when after insert is triggered, the field must be in order ascending.');
	}
	
	@isTest static void testEditOrderWhenAfterDeleteTriggered() {
		//Setup
		System.test.startTest();
		OptionAnswer__c Answer = CreateFullQuestion();
		
		//Execute
		Database.delete(Answer);
		boolean inOrder = True;
		Integer Step = 0;
		List<OptionAnswer__c> Answers = [SELECT Order__c FROM OptionAnswer__c WHERE Question__c = :Answer.Question__c ORDER BY Order__c];

		for(OptionAnswer__c Result : Answers)
		{
			inOrder &= Result.Order__c == ++Step;
		}

		System.test.stopTest();

		//Verify
		system.assertEquals(inOrder, true, 'Trigger Must edit field "order__c" when after delete is triggered, the field must be in order ascending');
	}
	
}