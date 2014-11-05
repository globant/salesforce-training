public with sharing class ComerceController {
    
    public List<Shop__c> shops{get;set;}
    public Boolean renderAVG {get;set;}
    public Boolean renderMotives {get;set;}
    
    public ComerceController() {
        
        User__c userObject = null;
        
        if(ApexPages.currentPage().getCookies().get('session') != null){                        
            ID idSession = ID.valueOf(ApexPages.currentPage().getCookies().get('session').getValue());
            userObject = User.getUserObject(idSession);
            if(userObject != null){
                ID userId = userObject.Id;
        //ID userId = [SELECT u.id FROM User__c  u WHERE u.DNI__c = 15962144 ].get(0).id;       
        shops = [SELECT s.Id,s.Logo__c,s.Name,s.Description__c,s.URL__c FROM Shop__c s WHERE    
                    s.Id in ( SELECT us.Shop__c FROM UserShopJunt__c us WHERE us.User__c = :userId)];    
                    
       showShop();           
            }
        }

        
    }

    /*
    *return the avg of percent of discount from coupon object for the 8 weeeks ago  
    */
    public List<DataSource> getAVGCoupon(){
        
        renderAVG = false;
        String shopID = Apexpages.currentPage().getParameters().get('shopId');                  
        User__c userObject = null;

        if(ApexPages.currentPage().getCookies().get('session') != null){                        
            ID idSession = ID.valueOf(ApexPages.currentPage().getCookies().get('session').getValue());
            userObject = User.getUserObject(idSession);
            if(userObject == null){
                return null;
            }
        }else{
            return null;
        }

        if(shopID == null || String.isEmpty(shopID)){
            return null;
        }
        
        Integer daysAgoI = 0;   
        Integer daysAgoF = 7;           

        List<DataSource> avgCouponPercent = new List<DataSource>();
        
        for(Integer i = 1; i <= 8; i++){
            
            if( i > 1 ){
                daysAgoI = daysAgoF;    
                daysAgoF *= i;
            }
            
            String userId = userObject.Id;

            LIST<AggregateResult> result = Database.query('SELECT AVG(Coupon__r.Disccount__c)'+
                    ' FROM SurveyAnswer__c s'+
                    ' WHERE '+
                        ' s.DNIUser__c = :userId '+
                        ' AND Coupon__r.status__c = \'Used\' '+
                        ' AND Survey__r.Shop__r.Id = :shopID'+
                        ' AND Coupon__r.date_of_use__c >= N_DAYS_AGO:'+daysAgoF+
                        ' AND Coupon__r.date_of_use__c <= N_DAYS_AGO:'+daysAgoI );

            
            String label = 'Week '+i;
            
            if(result !=null && result.size() > 0){
                
                if(result.get(0).get('expr0')!=null){                   
                    Double val = Double.valueOf(result.get(0).get('expr0'));
                    avgCouponPercent.add(new DataSource(label,val));
                }else{
                    avgCouponPercent.add(new DataSource(label,0));      
                }               
            }else{
                return null;
            }                       
        }

        boolean existData = false;
        for(DataSource item : avgCouponPercent){
            if(item.val > 0){
                existData = true;
                break;
            }
        }

        if(existData){
            renderAVG = true;
            return avgCouponPercent;
        }

        return null;        
    }

    public void showShop(){
        this.getAVGCoupon();
        this.getDiscountMotives();
    }

    public List<DataSource> getDiscountMotives(){
          
        renderMotives = false;          
        String shopID = Apexpages.currentPage().getParameters().get('shopId');                  
        User__c userObject = null;

        if(ApexPages.currentPage().getCookies().get('session') != null){                        
            ID idSession = ID.valueOf(ApexPages.currentPage().getCookies().get('session').getValue());
            userObject = User.getUserObject(idSession);
            if(userObject == null){
                return null;
            }
        }else{
            return null;
        }

        if(shopID == null || String.isEmpty(shopID)){
            return null;
        }

        String userId = userObject.Id;

        List<AggregateResult> result = [SELECT Coupon__r.reason__c,COUNT(Coupon__c)
                                        FROM
                                        SurveyAnswer__c s
                                        WHERE
                                        s.DNIUser__c = :userId
                                        AND Coupon__r.status__c = 'Used'
                                        AND Survey__r.Shop__c = :shopID

                                        GROUP BY Coupon__r.reason__c];


        List<DataSource> discountMotives = new List<DataSource>();
        if(result !=null && result.size() > 0){
            
            for(AggregateResult item : result){
                Double val = Double.valueOf(item.get('expr0'));
                String description = String.valueOf(item.get('reason__c'));
                discountMotives.add(new DataSource(description,val));
            }
        }
        
        if(discountMotives.isEmpty()){
            return null;    
        }

        renderMotives = true;
        return discountMotives;
    }

    public class DataSource{
        
        public String   lvl {get;set;}
        public Double   val {get;set;}      

        public DataSource(String lvl,Double val){
            this.lvl = lvl;
            this.val = val;
        }
    }
}