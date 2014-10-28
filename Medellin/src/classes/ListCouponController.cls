public class ListCouponController {

	public List<SurveyAnswerView__c> surveyAnswers		{get; set;}
	public Integer limitSize 							{get; set;}
	public String selectOption 							{get; set;}
	public Integer registerToShow						{get; set;}

    public ListCouponController() {
    		registerToShow = Integer.valueOf(Label.register_show);
    	    surveyAnswers = getCouponAnswerView(200);
    	    this.limitSize = surveyAnswers.size();
    	    surveyAnswers = getCouponAnswerView(registerToShow);
    }

    private List<SurveyAnswer__c> getCouponAnswer(Integer size){
    	
        //TODO Query looking for the user 
        
        //Query looking for coupon  field DNI 
        //TODO Change user DNI
        List<SurveyAnswer__c> surveyAnsByUser = 
        [SELECT sa.State__c, sa.DNIUser__c, sa.Survey__r.Name,
        sa.Coupon__r.Name, sa.Coupon__r.status__c, sa.Coupon__r.Disccount__c, sa.Date__c
        FROM SurveyAnswer__c sa 
        LIMIT:size];

        return surveyAnsByUser;
    }  
    
    public List<SurveyAnswerView__c> getCouponAnswerView(Integer size) {
    	SurveyAnswerView__c view;

    	List<SurveyAnswer__c> surveyAnsByUser = getCouponAnswer(size);
    	List<SurveyAnswerView__c> listView = new List<SurveyAnswerView__c>();

        for(SurveyAnswer__c survey: surveyAnsByUser){
        	view = new SurveyAnswerView__c();
        	view.coupon__c = survey.Coupon__r.Name;
        	view.survey__c = survey.Survey__r.Name;
        	view.status__c = survey.Coupon__r.status__c;
        	view.discount__c = survey.Coupon__r.Disccount__c;
        	view.date__c = survey.Date__c;
        	listView.add(view);
        }         

        return listView;
    }

    public PageReference updateList(){
    	//TODO code
		Integer size = Integer.valueOf(this.selectOption);

    	surveyAnswers = getCouponAnswerView(size);
    	return null;
    }

    public List<SelectOption> getSelectOptions() {
        List<SelectOption> options = new List<SelectOption>();
        if(this.limitSize > registerToShow){
        	for(Integer i=1; i<=limitSize/registerToShow; i++){
        		 options.add(new SelectOption(''+(i*registerToShow),''+(i*registerToShow)));
        	}

        	if(math.mod(this.limitSize,registerToShow) != 0){
        		options.add(new SelectOption(''+limitSize,''+limitSize));
        	}


        }  else {
        	options.add(new SelectOption(''+registerToShow,''+registerToShow));
        }      
        return options;
    }
}