public with sharing class CL_TestViewController {

    public List<Test__c> records { get; set; }

    public CL_TestViewController() {

    }

    public void init() {
      records = [ SELECT Id,Name,(SELECT Id,Name FROM TestChild__r) FROM Test__c ];
    }
}
