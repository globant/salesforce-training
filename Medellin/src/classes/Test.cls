public with sharing class Test {

	Question__c question;

	List<OptionAnswer__c> optionAnswers;

	public Test() {		
	}

	public String sayHello(){
		return 'Hello';
	}


	public Question__c getQuestion(){
		return question;
	}

	public void setQuestion(Question__c q){
		question=q;
	}


	public List<OptionAnswer__c> getOptionAnswers(){


		if(optionAnswers==null){
			optionAnswers=[SELECT Id,Name FROM OptionAnswer__c WHERE question__c=:question.ID];
		}
		return optionAnswers;
	}

	public List<SelectOption> getOptionAnswersAsSelectOption(){


		List<SelectOption> selectOptions=new List<SelectOption>();

		for(OptionAnswer__c tmp:this.getOptionAnswers()){
			SelectOption so=new SelectOption(tmp.Id,tmp.Name);
			selectOptions.add(so);
		}
		return selectOptions;
	}

	public String ansText;

	public void setAnsText(String text){
			this.ansText=text;
	}

	public String getAnsText(){
			return this.ansText;
	}

	public void setAnsUnique(String text){
			this.ansUnique=text;
	}

	public String getAnsUnique(){
			return this.ansUnique;
	}

	public String ansUnique;

	String[] ansOptions = new String[]{};

	public void setAnsOptions(String[] ansOptions){
		this.ansOptions=ansOptions;
	}

	public String[]  getAnsOptions(){
		return this.ansOptions;
	}


	public Boolean isAnswered(){
		if(question.type__c=='text'){
			return this.getAnsText()!=null && this.getAnsText().length()>0;
		}
		if(question.type__c=='Multiple'){
			return this.getAnsOptions().size()>0;
		}
		return this.getAnsUnique()!=null && this.getAnsUnique().length()>0; 
	}


}