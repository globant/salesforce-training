@isTest private with sharing class ShopEditControllerTest {

	private static void SetupShop()
	{
		Shop__c Shop = new Shop__c();
		Shop.name = 'TempShop'; 
		Shop.URL__c = 'http://www.TempShop.com'; 
		Shop.Employee_Count_Number__c = 5; 
		Shop.Description__c  = 'TempShop'; 	
		Shop.Sector__c       = 'Manufactura';
		Shop.Sub_Category__c = 'Celular';

		Database.insert(Shop);
		ApexPages.currentPage().getParameters().put('id',Shop.id);

	}
	
	@isTest public static void TestEditShopObject()
	{
		// Setup
		System.test.startTest();
		SetupShop();
		ShopEditController ShopController = new ShopEditController();
		 
		Shop__c TestResult = ShopController.getShop();

		//Execute
  
		if(TestResult != null){

			ShopController.Description = 'Edited Description';
			ShopController.UpdateShop();
			TestResult = ShopController.getShop();
		}

		ShopController.Cancel();

		System.test.stopTest();

		//Verify
		system.assertEquals(TestResult.Description__c, 'Edited Description', 'Test must update a description for a Shop object');
	}
	
	@isTest public static void TestGetSectorOptions()
	{
		// Setup
		System.test.startTest();
		SetupShop();
		ShopEditController ShopController = new ShopEditController();
		ShopController.getShop();
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
		SetupShop();

		ShopEditController ShopController = new ShopEditController();
		ShopController.getShop();

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

		system.debug('Sector.Size():'+Sector.Size());
		system.debug('TestResult.Size():'+TestResult.Size());

		//Verify
		system.assertEquals(TestResult.Size(), 1, 'Test must return values from Sub Category List');

	}
	
	@isTest public static void TestGetSubCategoryOptionsWith_SelectedSector()
	{
		// Setup
		System.test.startTest();
		SetupShop();

		ShopEditController ShopController = new ShopEditController();
		ShopController.getShop();

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
	
}