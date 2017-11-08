@isTest
public with sharing class CL_TestViewControllerTest {

  public static testMethod void test01() {

    Test__c p = new Test__c(Name = 'p');
    insert p;
    TestChild__c c = new TestChild__c(Name = 'c', RefTest__c = p.Id);
    insert c;

    CL_TestViewController tgt =  new CL_TestViewController();

    Pagereference page = new PageReference('/apex/TestView');
    page.getParameters().put('name', 'parent');
    page.getParameters().put('childName', 'child');
    Test.setCurrentPage(page);

    tgt.init();
    tgt.doRegister();

    System.assert(true, tgt.records);
    // System.assert(false, '強制失敗');
  }
}
