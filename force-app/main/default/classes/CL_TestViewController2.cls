public with sharing class CL_TestViewController2 {

  public List<Test__c> records {
    get {
      List<Test__c> escaped = records.deepClone(true, true, true);
      escape(escaped);
      for (Test__c r : escaped) {
        escape(r.TestChild__r);
      }
      return escaped;
    }
    set;
  }
  public String name { get { return name.escapeHtml4(); } set; }
  public String childName { get { return childName.escapeHtml4(); } set; }

  public CL_TestViewController2() {

  }

  public void init() {
    name = '無';
    childName = '無';
    records = [ SELECT Id,Name,(SELECT Id,Name FROM TestChild__r) FROM Test__c LIMIT 1000 ];
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

    records = [ SELECT Id,Name,(SELECT Id,Name FROM TestChild__r) FROM Test__c LIMIT 1000 ];
    this.name = name;
    this.childName = childName;
  }

  public void escape(List<SObject> lst) {
    if (lst != null && lst.size() > 0) {
      for (SObject obj : lst) {
        Map<String, Schema.SObjectField> fieldMap = obj.getSObjectType().getDescribe().fields.getMap();
        for (Schema.SObjectField f : fieldMap.values()) {
          Schema.DescribeFieldResult dfr = f.getDescribe();
          if (dfr.soaptype == Schema.SoapType.String) {
            obj.put(dfr.name , ((String)obj.get(dfr.name)).escapeHtml4());
          }
        }
      }
    }
  }
}
