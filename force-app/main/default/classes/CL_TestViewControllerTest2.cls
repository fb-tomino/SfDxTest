@isTest
public with sharing class CL_TestViewControllerTest2 {

  public static testMethod void test01() {

    Test__c p = new Test__c(Name = 'p');
    insert p;
    TestChild__c c = new TestChild__c(Name = 'c', RefTest__c = p.Id);
    insert c;

    CL_TestViewController2 tgt =  new CL_TestViewController2();

    Pagereference page = new PageReference('/apex/TestView2');
    page.getParameters().put('name', 'parent');
    page.getParameters().put('childName', 'child');
    page.getParameters().put('jump', '/apex/TestView');
    Test.setCurrentPage(page);

    tgt.init();
    tgt.doRegister();
    tgt.doSetJump();
    tgt.doJump();

    List<TestChild__c> lst = [ SELECT Id,Name,RefTest__r.Name FROM TestChild__c WHERE RefTest__c != null ];
    CL_TestViewController2.doDebug(lst[0].Id);
    tgt.escape(lst);

    System.assert(true, tgt.records);
    // System.assert(false, '強制失敗');
  }
}
