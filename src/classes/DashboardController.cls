global with sharing class DashboardController extends CustomController{
	
	global String code {get;set;}
	
	global PageReference goToSurvey() {

		try
    	{
    		List<SurveyAnswer__c> surveyAnswer = [SELECT Code__c
                        FROM SurveyAnswer__c 
                        WHERE Code__c = :code and CustomUser__r.Username__c = :user.Username__c];
                        
			if(surveyAnswer.size() > 0)
			{
				Pagereference completesurvey = Page.CompleteSurvey;
				completesurvey.getParameters().put('code',code);
				completesurvey.setRedirect(true);
				return completesurvey; 
			}
    	}
    	catch(Exception e)
    	{
    		ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'There is no survey for this code'); 
           				ApexPages.addMessage(msg);
    	}
		return null;
		
    }   
}