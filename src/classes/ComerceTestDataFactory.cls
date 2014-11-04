@isTest
private class ComerceTestDataFactory {
	
	public static void fillShop(String name,String description,String logo,String url,String sector,String subCategory){

		Shop__c s = new Shop__c();
		s.Name = name;
		s.Description__c = description;
		s.URL__c = url;
		s.Sector__c = sector;
		s.Sub_Category__c = subCategory;

		insert s;
	}
	
}