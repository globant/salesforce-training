@RestResource(urlMapping='/CouponWebService/*')
global with sharing class CouponWebService {
	

    @HttpGet
    global static Coupon__c doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String couponName = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Coupon__c result = [SELECT c.status__c, c.reason__c, c.date_of_use__c  From Coupon__c c WHERE c.Name = :couponName ].get(0);
        return result;
    }
}