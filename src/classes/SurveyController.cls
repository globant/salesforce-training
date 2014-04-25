global class SurveyController {

    public Boolean displayCreateNewSurveyForm { get; set; }
    public Boolean displayCreateNewQuestionForm { get; set; }
    public Boolean displayCreateNewOptionForm { get; set; }
    public List<Question__c> listOfQuestions { get; set; }
    public List<Option__c> listOfOptionsForCurrentQuestion {get; set;}
    public List<String> questionTypes {get; set;}
    
    public Survey__c newSurvey {
     get {
            if (newSurvey == null)
            {
                newSurvey = new Survey__c();
            }
            return newSurvey;
            }
        set{}
    }
    
    public Question__c newQuestion {
     get {
            if (newQuestion == null)
            {
                newQuestion= new Question__c();
            }
            return newQuestion;
            }
        set{}
    }
    
     public Option__c newOption {
     get {
            if (newOption == null)
            {
                newOption= new Option__c();
            }
            return newOption;
            }
        set{}
    }
    
    //Constructor
    public SurveyController() {
        displayCreateNewSurveyForm = false;
        displayCreateNewQuestionForm = false;
        displayCreateNewOptionForm = false;
        listOfQuestions = new List<Question__c>();
        listOfOptionsForCurrentQuestion  = new List<Option__c>();
    }
    
    public List<SelectOption> getItems(){
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Text','Text'));
            options.add(new SelectOption('Radio','Radio'));
            options.add(new SelectOption('Check','Check'));
            return options;
    }
    
    public String selectedQuestionType
    {
       get
        {
           if(selectedQuestionType==null)
           {
               //selectedQuestionType='Text';
           }
           return selectedQuestionType;
        }
        set;
    }
    
    public PageReference changedQuestionType(string newSelectedQuestionType)
    {
        selectedQuestionType='Testing';
        return null;
    }
           
    public PageReference showCreateNewSurveyPanel() {
        if(displayCreateNewSurveyForm ){
            displayCreateNewSurveyForm = false;
        }
        else{
            displayCreateNewSurveyForm = true;
        }
        return null;
    }
    
    public PageReference appendQuestion(){
        try
        {
            if(newQuestion.Text__c.length()>0)
            {
                if(listOfQuestions.size() < 5)
                {
                    Question__c appendedQuestion = new Question__c();
                    appendedQuestion.Text__c = newQuestion.Text__c;
                    appendedQuestion.Type__c = selectedQuestionType;
                    appendedQuestion.Survey__c = newSurvey.Id;
                    //appendedQuestion.Options__c = listOfOptionsForCurrentQuestion;
                    listOfQuestions.Add(appendedQuestion);
                }
                else
                {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'A survey can have up to five questions.'); 
                    ApexPages.addMessage(msg);
                }   
            }
        }
        catch(System.NullPointerException nullPointerEx){
              ApexPages.Message noBlankQuestionMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'You cannot enter blank questions.'); 
                ApexPages.addMessage(noBlankQuestionMessage);
        }
   
        return null;    
    }
    
    public PageReference addQuestion(){
        if(!displayCreateNewQuestionForm){
            displayCreateNewQuestionForm = true;
        }
        return null;
    }
    
    public PageReference addOption(){
        if(!displayCreateNewOptionForm){
            displayCreateNewOptionForm = true;
        }
        return null;
    }
    
    public PageReference appendOption(){
        try
        {
            if(newOption.Text__c.length()>0)
            {
                    Option__c appendedOption = new Option__c();
                    appendedOption.Text__c = newOption.Text__c;
                    appendedOption.Question__c = newQuestion.Id;
                    listOfOptionsForCurrentQuestion.Add(appendedOption);
            }
        }
        catch(System.NullPointerException nullPointerEx){
              ApexPages.Message noBlankOptionMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'You cannot enter a blank option.'); 
                ApexPages.addMessage(noBlankOptionMessage);
        }
   
        return null;    
    }
    
    public PageReference saveSurvey(){
        Insert newSurvey;
        return null;
    }
    
    public PageReference cancelNewSurvey(){
        return null;
    }
}