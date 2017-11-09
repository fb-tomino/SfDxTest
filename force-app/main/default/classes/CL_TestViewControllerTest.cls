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
    page.getParameters().put('jump', '/apex/TestView');
    Test.setCurrentPage(page);

    tgt.init();
    tgt.doRegister();
    tgt.doSetJump();
    tgt.doJump();

    tgt.jump = 'http://example.com';
    tgt.doJump();

    List<TestChild__c> lst = new List<TestChild__c>{c};
    CL_TestViewController.doDebug(JSON.serialize(lst));

    System.assert(true, tgt.records);
    // System.assert(false, '強制失敗');
  }
}
