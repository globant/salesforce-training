public with sharing class EditCouponController {

    public Coupon__c coupon {get; set;}
    public String code {get; set;}
    
    public EditCouponController(){
        
    }
    
    public PageReference findCoupon(){
        
        List<Coupon__c> couponList = [SELECT Code__c, DateUsed__c, Discount__c, SurveyAnswer__r.Id, Available__c From Coupon__c Where Code__c=: code];
        if (couponList.size()>0){
            coupon = couponList.get(0);
        }else{
            //Display error message
        }
        return null;
    }
    
    public PageReference save(){
        
        upsert coupon;
        return null;
    }

}