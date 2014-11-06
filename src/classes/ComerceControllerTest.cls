@isTest
public class ComerceControllerTest {
	
	@isTest static void test_existShopsForUser() {
		
		System.test.startTest();
		ComerceControllerDataProvider provider = new ComerceControllerDataProvider();
		User__c user = provider.fillUser(15962142,'frindex@gmail.com','15962142', 'franco', 'ballesteros');
		Shop__c shop = provider.fillShop('nike','shoes and sport','url to logo','www.nike.com','any sector','subcategory');
		provider.fillUserShopJunt(user,shop);

		ComerceController comerce = new ComerceController();
		List<Shop__c> shops = comerce.getShops(user.Id);
		System.test.stopTest();

		System.assert(!shops.isEmpty(),'The method getShops must be return at lest a one shop for the user.');	
	}
	

	public class ComerceControllerDataProvider{

		public User__c fillUser(Decimal dni,String email,String pass,String firstName,String lastName){

			User__c u = new User__c();
	        u.DNI__c = dni;
	        u.Email__c = email;
	        u.First_Name__c = firstName;
	        u.Last_Name__c = lastName;
	        u.Password__c = pass;
	        u.Name = email;

	        insert u;

	        //u = [select Id,DNI__c,Email__c,First_Name__c,Last_Name__c,Password__c,Name from User__c where Id=:u.Id];	

	        return u;
		}

		public Shop__c fillShop(String name,String description,String logo,String url,String sector,String subCategory){

    		Shop__c s = new Shop__c();
		    s.Name = name;
		    s.Description__c = description;
		    s.URL__c = url;
		    s.Sector__c = sector;
		    s.Sub_Category__c = subCategory;
		    s.Employee_Count_Number__c = 1; 
		    //s.sector = 'sector';
		    //s.subcategory = 'subCategory';	

		    insert s;

		    return s;
		}

		public UserShopJunt__c fillUserShopJunt(User__c user,Shop__c shop){

		    UserShopJunt__c uj = new UserShopJunt__c();
		    uj.User__r = user;
		    uj.Shop__r = shop;
		    uj.Shop__c = shop.Id;
		    uj.User__c = user.Id;

		    insert uj;

		    return uj;
		}    
	}
}