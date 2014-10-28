public with sharing class ComerceController {
	
	public List<Shop__c> shops{get;set;}
	
	public ComerceController() {
		
		ID userId = [SELECT u.id FROM User__c  u WHERE u.DNI__c = 15962144 ].get(0).id;		
		shops = [SELECT s.Id,s.Logo__c,s.Name,s.Description__c,s.URL__c FROM Shop__c s WHERE	
					s.Id in ( SELECT us.Shop__c	FROM UserShopJunt__c us	WHERE us.User__c = :userId)];

	}

	/*
	*return the avg of percent of discount from coupon object for the 8 weeeks ago	
	*/
	public List<DataSource> getAVGCoupon(){
		  
		String shopID = Apexpages.currentPage().getParameters().get('ShopId');
		String userId = Apexpages.currentPage().getParameters().get('userId');

		if(shopID == null || userId == null){
			return null;
		}

		userId = 'a0CJ000000HjsmYMAR';
		
		List<DataSource> avgCouponPercent = new List<DataSource>();

		Integer daysAgoI = 0;	
		Integer daysAgoF = 7;			

		for(Integer i = 1; i <= 8; i++){
			
			if( i > 1 ){
				daysAgoI = daysAgoF;	
				daysAgoF *= i;
			}
			
			LIST<AggregateResult> result = Database.query('SELECT AVG(c.Disccount__c)'+
					'FROM Coupon__c c '+
					'WHERE '+
 						'c.Id in (	SELECT s.Coupon__c '+
									'FROM SurveyAnswer__C s '+
									'WHERE '+
										's.DNIUser__c = :userId) '+
						'AND c.status__c = \'Used\' '+
						'AND c.date_of_use__c >= N_DAYS_AGO:'+daysAgoF+
						' AND c.date_of_use__c <= N_DAYS_AGO:'+daysAgoI );

			
			String label = 'Week '+i;
			
			if(result !=null && result.size() > 0){
				
				if(result.get(0).get('expr0')!=null){					
					Double val = Double.valueOf(result.get(0).get('expr0'));
					avgCouponPercent.add(new DataSource(label,val));
				}else{
					avgCouponPercent.add(new DataSource(label,0));		
				}
				
			}else{
				avgCouponPercent.add(new DataSource(label,0));	
			}						
		}
        return avgCouponPercent;
	}

	public PageReference showShop(){
		this.getAVGCoupon();
		return null;
	}

    
     public List<PieWedgeData> getDiscountMotives() {
        List<PieWedgeData> data = new List<PieWedgeData>();
        data.add(new PieWedgeData('Jan', 30));
        data.add(new PieWedgeData('Feb', 15));
        data.add(new PieWedgeData('Mar', 10));
        data.add(new PieWedgeData('Apr', 20));
        data.add(new PieWedgeData('May', 20));
        data.add(new PieWedgeData('Jun', 5));
        return data;
    }

    // Wrapper class
    public class PieWedgeData {

        public String name { get; set; }
        public Integer data { get; set; }

        public PieWedgeData(String name, Integer data) {
            this.name = name;
            this.data = data;
        }
    }
    
	public class DataSource{
		
		public String 	lvl	{get;set;}
		public Double 	val {get;set;}		

		public DataSource(String lvl,Double val){
			this.lvl = lvl;
			this.val = val;
		}
	}
}