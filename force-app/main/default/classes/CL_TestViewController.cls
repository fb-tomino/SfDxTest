public with sharing class CL_TestViewController {

  public List<TestChild__c> records {
    get {
      List<TestChild__c> tmp = records.deepClone(true, true, true);
      escape(tmp);
      return tmp;
    }
    set;
  }
  public String name { get { return name.escapeHtml4(); } set; }
  public String childName { get { return childName.escapeHtml4(); } set; }
  public String jump { get; set; }

  public CL_TestViewController() {

  }

  public void init() {
    this.jump = Apexpages.currentPage().getParameters().get('q');
    name = '無';
    childName = '無';
    records = [ SELECT Id,Name,RefTest__r.Name FROM TestChild__c LIMIT 50000 ];
  }

  public void doRegister() {
    String name = Apexpages.currentPage().getParameters().get('name');
    String childName = Apexpages.currentPage().getParameters().get('childName');

    Test__c parent = new Test__c(
      Name = name
    );
    TestChild__c children = new TestChild__c(
      Name = childName
    );
    doInsert(new List<Test__c>{parent}, new List<TestChild__c>{children});

    records = [ SELECT Id,Name,RefTest__r.Name FROM TestChild__c LIMIT 50000 ];
    doDebug(JSON.serialize(records));

    this.name = name;
    this.childName = childName;
  }

  private void doInsert(List<Test__c> p, List<TestChild__c> c) {
    insert p;

    for(Integer i=0; i<p.size(); i++) {
      c[i].RefTest__c = p[i].Id;
    }
    insert c;
  }

  public void doSetJump() {
    this.jump = Apexpages.currentPage().getParameters().get('jump');
  }

  public Pagereference doJump() {
    if (this.jump.startsWith('/')) {
      Pagereference next = new Pagereference(this.jump);
      next.setRedirect(true);
      return next;
    }
    return null;
  }

  @TestVisible
  private void escape(List<SObject> lst) {
    if (lst != null && lst.size() > 0) {
      for (SObject obj : lst) {
        escapeSObject(obj);
      }
    }
  }

  private void escapeSObject(SObject obj) {
    Map<String, Schema.SObjectField> fieldMap = obj.getSObjectType().getDescribe().fields.getMap();
    for (Schema.SObjectField f : fieldMap.values()) {
      Schema.DescribeFieldResult dfr = f.getDescribe();
      if (dfr.soaptype == Schema.SoapType.String) {
        obj.put(dfr.name , ((String)obj.get(dfr.name)).escapeHtml4());
      } else if (dfr.soaptype == Schema.SoapType.ID) {
        for (Schema.SObjectType t : dfr.getReferenceTo()) {
          if (dfr.getRelationshipName().contains('__r')) {
            SObject ro = obj.getSObject(dfr.getRelationshipName());
            System.debug(dfr.getRelationshipName());
            if (ro != null) {
              escapeSObject(ro);
              obj.putSObject(dfr.getRelationshipName(), ro);
            }
          }
        }
      }
    }
  }

  @future(callout = true)
  public static void doDebug(String json) {
    List<TestChild__c> lst = (List<TestChild__c>)System.JSON.deserialize(json, List<TestChild__c>.class);
    for (TestChild__c c : lst) {
      System.debug(c);
    }
  }
}
