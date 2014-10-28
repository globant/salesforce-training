public class GoToTheSurveyController {
	
	public GoToTheSurveyController(){
	}
	
	public String code{get;set;}
	public double DNI{get;set;}
	public Coupon__c coupon{get;set;}
	public SurveyAnswer__c surveyAnswer{get;set;}
	
	
	public boolean couponExist(){
		list<Coupon__c> couponList =  [SELECT c.Id, c.Name FROM Coupon__c c WHERE c.Name = :code];

		
		if(couponList != null && couponList.size() > 0 ){
			coupon = couponList.get(0);
			return true;
		}
		return false;
	}
	
	public boolean existRelationship(){
		surveyAnswer = [SELECT  s.DNIUser__c,  s.Coupon__c,s.DNIUser__r.DNI__c, s.Survey__c FROM SurveyAnswer__c s WHERE s.Coupon__c in ( SELECT c.Id FROM Coupon__c c WHERE c.Id = :coupon.Id)].get(0);

		if(null != surveyAnswer.DNIUser__c){
			return true;
		}
		return false;
	}

	public boolean thisUserIsTheOwer(){

		if(surveyAnswer.DNIUser__r.DNI__c == DNI){
			return true;
		}
		return false;
	}

	public boolean createRelationship(){

		User__c  user = [SELECT Id, User__c.Email__c, User__c.Password__c FROM User__c WHERE User__c.DNI__c = :DNI  LIMIT 1].get(0); 
		surveyAnswer.DNIUser__c = user.Id;

		try{
				update(surveyAnswer);
				return true;

			} catch(Exception e){
				return false;
			}

		return false;
	}

	public PageReference goToTheSurvey() {
		
		if(!couponExist()) {
			ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'This survey does not exist !!');
        	ApexPages.addMessage(msg);
			return null;
		}
		
		if(existRelationship()){
			
			if(!thisUserIsTheOwer()){
				ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You cann´t complete this survey !!');
	        	ApexPages.addMessage(msg);
				return null;
			}

		} else {

				if(!createRelationship()){
				ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'A error has ocurred, please try later !!');
	        	ApexPages.addMessage(msg);
				return null;
			}
		}
		
		

		String fullURL = '/apex/ApplySurvey';
		PageReference reference = new PageReference(fullURL);
		reference.getParameters().put('surveyAnswerId',surveyAnswer.Id);
        reference.setRedirect(true);
        return reference;
	
	 }

}