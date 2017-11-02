@isTest
public with sharing class CL_TestViewControllerTest {

  public static testMethod void test01() {
    System.assert(true);
    System.assert(false, '強制失敗');
  }
}
