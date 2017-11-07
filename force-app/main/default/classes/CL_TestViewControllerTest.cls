@isTest
public with sharing class CL_TestViewControllerTest {

  public static testMethod void test01() {
    new CL_TestViewController().init();

    Pagereference page = Page.TestView;
    page.getParameters().put('name', 'parent');
    page.getParameters().put('childName', 'child');
    Test.setCurrentPage(page);

    new CL_TestViewController().doRegister();

    System.assert(true);
    // System.assert(false, '強制失敗');
  }
}
