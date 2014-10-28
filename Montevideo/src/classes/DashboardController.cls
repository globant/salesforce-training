public with sharing class DashboardController extends CustomController{
    
    public String code {get;set;}
    
    public List<Coupon__c> lastCoupons{get;set;}
    
    
    public DashboardController(){
        super();
        String pageName = Util.getCurrentPageName();
        if (!Util.checkPermissions(pageName, role.Name)){
            Util.goToError();
        }
        
        lastCoupons = [SELECT Name,SurveyAnswer__r.Survey__r.Name, Available__c, Discount__c FROM Coupon__c];
    }
    
    
    public PageReference goToSurvey() {
        
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
    
    public PageReference logout(){
   		CookieManager.logout();
   		PageReference login = Page.CustomLogin;
        login.setRedirect(true);
        return login;
   	}      
}