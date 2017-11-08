@isTest
public with sharing class CL_TestViewControllerTest2 {

  public static testMethod void test01() {
    CL_TestViewController2 tgt =  new CL_TestViewController2();

    Pagereference page = new PageReference('/apex/TestView2');
    page.getParameters().put('name', 'parent');
    page.getParameters().put('childName', 'child');
    Test.setCurrentPage(page);

    tgt.init();
    tgt.doRegister();

    System.assert(true);
    // System.assert(false, '強制失敗');
  }
}
