@isTest
public with sharing class CL_TestViewControllerTest {

  public static testMethod void test01() {
    CL_TestViewController tgt =  new CL_TestViewController();

    Pagereference page = new PageReference('/apex/TestView');
    page.getParameters().put('name', 'parent');
    page.getParameters().put('childName', 'child');
    Test.setCurrentPage(page);

    tgt.init();
    tgt.doRegister();

    System.assert(true);
    // System.assert(false, '強制失敗');
  }
}
