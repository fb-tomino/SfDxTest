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

  public CL_TestViewController() {

  }

  public void init() {
    name = '無';
    childName = '無';
    records = [ SELECT Id,Name,RefTest__r.Name FROM TestChild__c LIMIT 1000 ];
  }

  public void doRegister() {
    String name = Apexpages.currentPage().getParameters().get('name');
    String childName = Apexpages.currentPage().getParameters().get('childName');

    Test__c parent = new Test__c(
      Name = name
    );
    insert parent;

    TestChild__c children = new TestChild__c(
      Name = childName,
      RefTest__c = parent.Id
    );
    insert children;

    records = [ SELECT Id,Name,RefTest__r.Name FROM TestChild__c LIMIT 1000 ];
    this.name = name;
    this.childName = childName;
  }

  public void escape(List<SObject> lst) {
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
}
