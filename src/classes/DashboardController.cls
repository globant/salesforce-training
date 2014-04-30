global with sharing class DashboardController {

    public List<Coupon__c> getLastCoupons() {
     List<Coupon__c> lastCouponsList = [SELECT Name,SurveyAnswer__r.Survey__r.Name, Available__c, Discount__c FROM Coupon__c];
              return lastCouponsList;
    }

    
    global String code {get;set;}
    
    global PageReference goToSurvey() {

        try
        {
            SurveyAnswer__c surveyAnswer = [SELECT Code__c
                        FROM SurveyAnswer__c 
                        WHERE Code__c = :code];
        }
        catch(Exception e)
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'There is no survey for this code'); 
                        ApexPages.addMessage(msg);
        }
        
        Pagereference completesurvey = Page.CompleteSurvey;
        completesurvey.getParameters().put('code',code);
        completesurvey.setRedirect(true);
        return completesurvey; 
    }   
    
    
}