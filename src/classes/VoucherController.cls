public with sharing class VoucherController {

    public String code {get; set;}
    
    public VoucherController(){
        code = ApexPages.currentPage().getParameters().get('code');
    }
}