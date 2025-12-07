@isTest
public class AccountTerritoryHandlerTest {
    @isTest
    static void testAssignTerritories() {

        List<Account> accountsToInsert = new List<Account>{
            new Account(Name='NY Strategic Account', BillingPostalCode='10014', BillingState='NY'),
            new Account(Name='CA Strategic Account', BillingPostalCode='90024', BillingState='CA'),
            new Account(Name='CA Account', BillingPostalCode='90756', BillingState='CA'),
            new Account(Name='IL Account', BillingPostalCode='60601', BillingState='IL'),
            new Account(Name='NY State Only Account', BillingPostalCode='12000', BillingState='NY'),
            new Account(Name='TX Unassigned', BillingPostalCode='73301', BillingState='TX'),
            new Account(Name='No Address Account') // Missing ZIP and State
        };

        Test.startTest();
        insert accountsToInsert;
        Test.stopTest();

        Map<String, String> expectedResults = new Map<String, String>{
            'NY Strategic Account' => 'New York - Strategic',
            'CA Strategic Account' => 'California - Strategic',
            'CA Account' => 'California', 
            'IL Account' => 'Great Lakes',
            'NY State Only Account' => 'New York',
            'TX Unassigned' => 'Unassigned',
            'No Address Account' => 'Unknown'
        };

        for (Account acc : [SELECT Name, Territory__c FROM Account WHERE Name LIKE '%Account']) {
            System.assertEquals(expectedResults.get(acc.Name), acc.Territory__c, 'Territory mismatch for: ' + acc.Name);
             
    }
        }

   @isTest
   static void testUpdateTerritoryAssignmentWhenZipChanges() {
    Account acc = new Account(Name='Update Zip Account', BillingState='NY', BillingPostalCode='10014');
    insert acc;

    Test.startTest();

    acc.BillingState = 'CA';
    update acc;

    acc.BillingPostalCode = '90210';
    update acc;

    Test.stopTest();

    acc = [SELECT Territory__c FROM Account WHERE Id = :acc.Id];
    System.assertEquals('California - Strategic', acc.Territory__c);
}

}