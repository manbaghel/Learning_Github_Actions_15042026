@IsTest
private class DemoAccountHelperTest {

    @TestSetup
    static void setupTestData() {
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Acme Corporation', Industry = 'Technology', Phone = '555-0100'),
            new Account(Name = 'Acme Labs', Industry = 'Technology', Phone = '555-0101'),
            new Account(Name = 'Global Industries', Industry = 'Manufacturing', Phone = '555-0200')
        };
        insert accounts;
    }

    @IsTest
    static void testGetAccountsByName() {
        List<Account> results = DemoAccountHelper.getAccountsByName('Acme');

        Assert.areEqual(2, results.size(), 'Should find 2 accounts matching "Acme"');
        for (Account acc : results) {
            Assert.isTrue(acc.Name.contains('Acme'), 'Each result should contain "Acme" in the name');
        }
    }

    @IsTest
    static void testGetAccountsByNameNoResults() {
        List<Account> results = DemoAccountHelper.getAccountsByName('NonExistent');

        Assert.areEqual(0, results.size(), 'Should return no accounts for non-matching search');
    }

    @IsTest
    static void testCreateAccount() {
        Account created = DemoAccountHelper.createAccount('New Test Corp', 'Finance', '555-0300');

        Assert.isNotNull(created.Id, 'Created account should have an Id');
        Account fetched = [SELECT Name, Industry, Phone FROM Account WHERE Id = :created.Id];
        Assert.areEqual('New Test Corp', fetched.Name);
        Assert.areEqual('Finance', fetched.Industry);
        Assert.areEqual('555-0300', fetched.Phone);
    }

    @IsTest
    static void testUpdateAccountIndustry() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Global Industries' LIMIT 1];

        DemoAccountHelper.updateAccountIndustry(acc.Id, 'Energy');

        Account updated = [SELECT Industry FROM Account WHERE Id = :acc.Id];
        Assert.areEqual('Energy', updated.Industry, 'Industry should be updated to Energy');
    }

    @IsTest
    static void testCountAccountsByIndustry() {
        Integer techCount = DemoAccountHelper.countAccountsByIndustry('Technology');
        Integer mfgCount = DemoAccountHelper.countAccountsByIndustry('Manufacturing');

        Assert.areEqual(2, techCount, 'Should find 2 Technology accounts');
        Assert.areEqual(1, mfgCount, 'Should find 1 Manufacturing account');
    }
}