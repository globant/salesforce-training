public with sharing class AssingSurveyController {
	 
	  public SurveyAnswer__c surveyA {get; set;}  
	  public CustomUser__c customUser {get; set;}  
      public Boolean showErrorMessage{get;set;}
      public Boolean showMessage{get;set;}
      public String Message{get;set;}  
    
		public AssingSurveyController()
		{
			String label = ApexPages.currentPage().getParameters().get('mid');
        if(label != null)
        {
            if(label == '1')
            {
                Message = System.Label.Success1;
                showErrorMessage = false;
            }else
            {
                Message = System.Label.Error1;
                showErrorMessage = true;
            }
            
            showMessage = true; 
        }else{
        	showMessage = false; 
        }
        
			surveyA = new SurveyAnswer__c();
			customUser = new CustomUser__c();
		}
		
	public PageReference AddSurveyAnswer()
    {     
        Insert surveyA;     
        ApexPages.currentPage().getParameters().put('mid', '2');
        return null;                
    }

}