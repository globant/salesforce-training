@isTest
private class CommerceProfileControllerTest{

    static testMethod void verifySetCurrentShop(){
    Shop__c shop1 = new Shop__c(Name='Shop1');
    Shop__c shop2 = new Shop__c(Name='Shop2');
    Shop__c shop3 = new Shop__c(Name='Shop3');
    test.startTest();
    insert shop1;
    insert shop2;
    insert shop3;
    test.stopTest();
    Shop__c retrievedShop = [SELECT Name, Site__c, Logo_Url__c FROM Shop__c WHERE Id = :shop2.Id];
    CommerceProfileController controllerToBeTested = new CommerceProfileController();
    controllerToBeTested.shopIdChosen = shop2.Id;
    controllerToBeTested.SetCurrentShop();
    System.AssertEquals(controllerToBeTested.currentShop.Id,shop2.Id);
    }

}