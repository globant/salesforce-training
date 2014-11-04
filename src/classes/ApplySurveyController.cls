public class ApplySurveyController {


	List<Question__c> Questions; 

	List<Test> wrapperQuestions; 

	Test test= new Test();

	String[] multiselect = new String[]{};

	ID surveyAnswerID;


	SurveyAnswer__c surveyAnswer=[SELECT ID FROM SurveyAnswer__c LIMIT 1];


	String dni;

	public String getDni(){
		return this.dni;
	}

	String sessionID=Userinfo.getSessionID();


	public String getSessionID(){
		return this.sessionID;
	}

	public void setSessionID(String algo){
		this.sessionID=algo;
	}

	/*This is a comment*/
	public ApplySurveyController() {
		dni=User.getDni(ApexPages.currentPage());
		//ID idSurveyAnswer=Id.valueOf('a0GJ000000EkZ6I');
		surveyAnswerID=Apexpages.currentPage().getParameters().get('surveyAnswerId');		
		dni=surveyAnswerID;
	}

	public ApplySurveyController(ApexPages.StandardController controller) {
        Document d = (Document) controller.getRecord();
        d.folderid = UserInfo.getUserId(); //this puts it in My Personal Documents			
    }

	public  List<Question__c>  getQuestions(){

		surveyAnswer=[SELECT ID,Survey__c FROM SurveyAnswer__c where Id=:surveyAnswerID LIMIT 1];

		dni=surveyAnswer.Survey__c;
/*
		surveyAnswer=[SELECT ID FROM SurveyAnswer__c where Id=:surveyAnswerID LIMIT 1];

		if(surveyAnswer==null){			
				ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'No existe survey');
        		ApexPages.addMessage(msg);   
        		PageReference referencePage = Page.Dashboard;
        		referencePage.setRedirect(true);
		}
*/

		
		if(Questions == null){
			 Questions=[SELECT Question__c.Description__c,Type__c,Name
	                            FROM Question__c WHERE Survey__c=:surveyAnswer.Survey__c];
		}
		return Questions; 
	}

	public Test getTest(){
		return test;
	}

	public List<Test> getWrapperQuestions(){

		if(wrapperQuestions==null){
			wrapperQuestions=new List<Test>();

			for(Question__c temp:this.getQuestions()){
				Test wrapper=new Test();
				wrapper.setQuestion(temp);
				wrapperQuestions.add(wrapper);		
			}
		}
		return wrapperQuestions;
	}


	public void setMultiselect(String[] multiselect){
		this.multiselect=multiselect;
	}

	public String[]  getMultiselect(){
		return this.multiselect;
	}
	
	public PageReference Reset(){

		PageReference referencePage = Page.ApplySurvey;
        referencePage.setRedirect(true);
        return referencePage;

	}

	public PageReference goToDashBoard(){

		PageReference referencePage = Page.Dashboard;
        referencePage.setRedirect(true);
        return referencePage;

	}
	

	public PageReference SaveSurvey(){

		//insertQuestionAnswer(Id.valueOf('a0BJ000000747kv'));

		Integer questionNumber=0;

		Boolean hasErrors=false;


		for(Test wrapperClass:this.getWrapperQuestions()){

			questionNumber++;

			if(!wrapperClass.isAnswered()){
				ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The Question '+questionNumber+' has not anwered.');
        		ApexPages.addMessage(msg);
        		hasErrors=true;	
        		continue;
			}

			if(wrapperClass.getQuestion().Type__c!='Multiple'){
				ID tmpID;
				if(wrapperClass.getQuestion().Type__c=='Text'){
					OptionAnswer__c optionAnswer=new OptionAnswer__c();
					optionAnswer.question__c=wrapperClass.getQuestion().ID;
					optionAnswer.Name=wrapperClass.getAnsText();		
					Database.insert(optionAnswer,true);
					tmpID=optionAnswer.ID;

				}
				else{
					tmpID=Id.valueOf(wrapperClass.getAnsUnique());
				}
				insertQuestionAnswer(tmpID);
		
			}else{
				for(String optionAnswerID:wrapperClass.getAnsOptions()){
					insertQuestionAnswer(Id.valueOf(optionAnswerID));
				}				
			}
		}


		if(hasErrors){  
			ApexPages.Message msg= new ApexPages.Message(ApexPages.Severity.ERROR,'Answer all questions.');
			ApexPages.addMessage(msg);
			return null;
		}

		PageReference referencePage = Page.Dashboard;
        referencePage.setRedirect(true);
        return referencePage;

	}

	public void insertQuestionAnswer(ID optionAnswerID){
		QuestionAnswer__c answer 
				= new QuestionAnswer__c();
		answer.OptionsAnswers__c=optionAnswerID;
		answer.SurveyAnswer__c=ID.valueOf('a0GJ000000EkXPF');
		answer.Name='Anything';
		insert answer;
	}


}