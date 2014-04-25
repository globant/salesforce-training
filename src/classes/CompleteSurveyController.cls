public with sharing class CompleteSurveyController {

	public CustomUser__c customUser {get; set;}
	public Survey__c survey {get; set;}
	public String code {get; set;}
	
	public CompleteSurveyController(){
		
		code = ApexPages.currentPage().getParameters().get('code');
	
		List<SurveyAnswer__c> result = [select Id, CustomUser__r.Id, Survey__r.Id from SurveyAnswer__c WHERE Code__c =: code];
		if (result.size() > 0){
			//Get surveyAnswer
			SurveyAnswer__c surveyAnswer = result.get(0);
			
			//Get customUser
			List<CustomUser__c> usersList = [select Id, First_Name__c, Last_Name__c from CustomUser__c WHERE Id =: surveyAnswer.CustomUser__r.Id];
			if (usersList.size() > 0){
				customUser = usersList.get(0);
			}
			
			//Get survey
			List<Survey__c> surveyList = [select Id, Description__c, Discount__c, Shop__r.Id from Survey__c WHERE Id =: surveyAnswer.Survey__r.Id];
			if (surveyList.size() > 0){
				survey = surveyList.get(0);
			}
		}
		
	}	

}