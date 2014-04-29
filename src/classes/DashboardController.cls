global with sharing class DashboardController extends CustomController{
	
	global String code {get;set;}
	
	global PageReference goToSurvey() {
		
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
    	else{
    		Message = 'There is no survey for this code and user!';
    	    showErrorMessage = true;
			showMessage = true;
    	}
		return new PageReference( '/apex/Dashboard');
    }   
}