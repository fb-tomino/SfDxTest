public with sharing class CL_TestViewController {

  public List<Test__c> records { get; set {
      escape(value);
      // for (Test__c r : value) {
      //   escape(r.TestChild__r);
      // }
      records = value;
    }
  }
  public String name { get; set { name = value.escapeHtml4(); } }
  public String childName { get; set; }

  public CL_TestViewController() {

  }

  public void init() {
    name = '無';
    childName = '無';
    records = [ SELECT Id,Name,(SELECT Id,Name FROM TestChild__r) FROM Test__c ];
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

    records = [ SELECT Id,Name,(SELECT Id,Name FROM TestChild__r) FROM Test__c ];
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
