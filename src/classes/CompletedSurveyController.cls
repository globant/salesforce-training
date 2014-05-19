public with sharing class CompletedSurveyController {

    public PageReference goToVoucher(){
        String code = ApexPages.currentPage().getParameters().get('code');
        Pagereference voucher = Page.Voucher;
        voucher.getParameters().put('code',code);
        voucher.setRedirect(true);
        return voucher; 
    }
}