@isTest private with sharing class ShopNewControllerTest {
	
	@isTest public static void testCreateNewShopObject()
	{
		// Setup
		System.test.startTest();

		//Execute
		ShopNewController ShopController = SetupShop();
		Shop__c TestResult = GetShop(ShopController);
		System.test.stopTest();

		//Verify
		system.assertNotEquals(TestResult, null, 'Test must create a new Shop object');
	}
	
	@isTest public static void TestGetSectorOptions()
	{
		// Setup
		System.test.startTest();

		ShopNewController ShopController = SetupShop();
		ApexPages.currentPage().getParameters().put('UpdateSector','Tecnología');
		ShopController.UpdateSector();

		//Execute
		List<SelectOption> TestResult = new List<SelectOption>();
		TestResult = ShopController.getSectorOptions();


		System.test.stopTest();

		//Verify
		system.assertEquals(TestResult.isEmpty(), false, 'Test must return values from Sector List');

	}
	
	@isTest public static void TestGetSubCategoryOptionsWithout_SelectedSector()
	{
		// Setup
		System.test.startTest();

		ShopNewController ShopController = SetupShop();

		//ApexPages.currentPage().getParameters().put('UpdateSector'     ,'Manufactura');
		ApexPages.currentPage().getParameters().put('UpdateSubCategory','Celular');
		ShopController.UpdateSector();
		ShopController.UpdateSubCategory();

		//Execute
		List<SelectOption> Sector     = new List<SelectOption>();
		List<SelectOption> TestResult = new List<SelectOption>();
		Sector     = ShopController.getSectorOptions();
		TestResult = ShopController.getSub_CategoryOptions();

		System.test.stopTest();

		//Verify
		system.assertEquals(TestResult.isEmpty(), false, 'Test must return values from Sub Category List');

	}
	
	@isTest public static void TestGetSubCategoryOptionsWith_SelectedSector()
	{
		// Setup
		System.test.startTest();

		ShopNewController ShopController = SetupShop();

		ApexPages.currentPage().getParameters().put('UpdateSector'     ,'Manufactura');
		ApexPages.currentPage().getParameters().put('UpdateSubCategory','Celular');
		ShopController.UpdateSector();
		ShopController.UpdateSubCategory();

		//Execute
		List<SelectOption> Sector     = new List<SelectOption>();
		List<SelectOption> TestResult = new List<SelectOption>();
		Sector     = ShopController.getSectorOptions();
		TestResult = ShopController.getSub_CategoryOptions();

		System.test.stopTest();

		//Verify
		system.assertEquals(TestResult.isEmpty(), false, 'Test must return values from Sub Category List');

	}

	@isTest public static void GetAllRegisteredShops()
	{
		// Setup
		System.test.startTest();
		ShopNewController ShopController = SetupShop();
		List<Shop__c> TestResult = ShopController.getShops();
		ShopController.Cancel();

		System.test.stopTest();
		system.debug(String.valueOf(TestResult.size()));
		//Verify
		system.assertEquals(TestResult.isEmpty(), false, 'Test must return all shops previously created');

	}

	private static ShopNewController SetupShop()
	{
		ShopNewController Shop = new ShopNewController();
		Shop.name = 'TempShop'; 
		Shop.URL = 'http://www.TempShop.com'; 
		Shop.Employee_Count_Number = 5; 
		Shop.Description  = 'TempShop'; 	
		Shop.Sector       = 'Manufactura';
		Shop.Sub_Category = 'Celular';

		Shop.registerShop();

		return Shop;
	}

	private static Shop__c GetShop(ShopNewController ShopController){

		Shop__c TempShop = [select id, name from Shop__c where name=:ShopController.name and url__c =:ShopController.url limit 1];
		Shop__c TestResult;

		if(TempShop != null){
			ApexPages.currentPage().getParameters().put('id',TempShop.id);
			TestResult = ShopController.getShop();
		}

		return TestResult;
	}
}