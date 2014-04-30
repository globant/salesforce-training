public with sharing class CreateSurveyController extends CustomController {

    public PageReference changeType() {
        return null;
    }


    public Survey__c survey {get; set;}
    public List<Question> QuestionsInSurvey {get; set;}
    public Shop__c shop {get; set;}
    
    public String currentQuestionText {get; set;}
    public Integer CurrentQuestionNumber {get; set;}    
    public String currentQuestionType {get; set;}
    public String currentOptionText {get; set;}
    
    public List<Option> OptionsListAux{get; set;}
       
    public List<SelectOption> getQuestionTypes() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Text','Text')); 
        options.add(new SelectOption('Radio','Radio')); 
        options.add(new SelectOption('Checkbox','Checkbox')); 
        return options; 
    }
    
    public CreateSurveyController()
    {
    	survey = new Survey__c();
    	QuestionsInSurvey = new List<Question>();   
        OptionsListAux = new List<Option>(); 
        currentQuestionType = 'Text';  
               
        if(user!=null){
         	List<Shop__c> userShop = [SELECT Category__c, Id, Name
	        FROM Shop__c 
	        WHERE Custom_User_Owner__c = :user.Id];
	        if(userShop.size() > 0)
		     {
		        	 shop = userShop.get(0);
		     }
	   	}
        
       
         
    }
    
    public PageReference AddQuestion()
    {
        Question newQuestion = new Question();
        newQuestion.Text = currentQuestionText;
        newQuestion.Type = currentQuestionType;
        newQuestion.QuestionNumber = QuestionsInSurvey.size() + 1; 
        newQuestion.QuestionOptions = new List<Option>(); 
        CurrentQuestionNumber = newQuestion.QuestionNumber;
        for (Option op : OptionsListAux){
            newQuestion.QuestionOptions.Add(op);
        }
        QuestionsInSurvey.Add(newQuestion);
        return null;
    }
    
    public PageReference AddOption()
    {
        Option newOption = new Option();
        newOption.Text = currentOptionText;
        OptionsListAux.add(newOption);
        return null;
    }
    
    public PageReference AddSurvey()
    {
    	
    	survey.Shop__c = shop.Id;
        Insert survey;
        for(Question q: QuestionsInSurvey){
        Question__c newQuestion = new Question__c();
        newQuestion.Text__c = q.Text;
        newQuestion.Type__c = q.Type;
        newQuestion.Survey__c = survey.Id;
        Insert newQuestion;
             for(Option op: q.QuestionOptions){      
              Option__c newOption = new Option__c();
              newOption.Text__c = q.Text;
              newOption.Question__c = newQuestion.Id; 
              Insert newOption;
            }
        }
        
        return null;
                
    }
 class Question {
    public String Text {get; set;}
    public Integer QuestionNumber {get; set;}
    public List<Option> QuestionOptions {get; set;}
    public String Type {get; set;}
        
     // myInnerClass code here
   }
   
   class Option {
     public String Text {get; set;}
   }
   
}