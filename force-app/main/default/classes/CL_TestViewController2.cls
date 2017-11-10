public without sharing class CL_TestViewController2 {

  public List<TestChild__c> records {
    get;
    set;
  }
  public String name { get; set; }
  public String childName { get; set; }
  public String jump { get; set; }

  public CL_TestViewController2() {

  }

  public void init() {
    this.jump = Apexpages.currentPage().getParameters().get('q');
    name = '無';
    childName = '無';
    records = [ SELECT Id,Name,RefTest__r.Name FROM TestChild__c ];
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
    doInsert(parent, children);

    records = [ SELECT Id,Name,RefTest__r.Name FROM TestChild__c ];
    for (TestChild__c t : records) {
      doDebug(t.Id);
    }
    this.name = name;
    this.childName = childName;
  }

  private void doInsert(Test__c p, TestChild__c c) {
    insert p;

    c.RefTest__c = p.Id;
    insert c;
  }

  public void doSetJump() {
    this.jump = Apexpages.currentPage().getParameters().get('jump');
  }

  public Pagereference doJump() {
    Pagereference next = new Pagereference(this.jump);
    next.setRedirect(true);
    return next;
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
  public static void doDebug(Id id) {
    System.debug([ SELECT Id,Name,RefTest__r.Name FROM TestChild__c WHERE Id = :id ]);
  }
}
