global with sharing class DashboardController {
	
	global PageReference goToSurvey() {
		
        return new PageReference( '/apex/CustomLogin'); 
    }
	
	global String code {
    	get; set;
  	}
}