public with sharing class DemoAccountHelper {

    public static List<Account> getAccountsByName(String searchName) {
        String likePattern = '%' + String.escapeSingleQuotes(searchName) + '%';
        return [
            SELECT Id, Name, Industry, Phone, Website
            FROM Account
            WHERE Name LIKE :likePattern
            ORDER BY Name
            LIMIT 50
        ];
    }

    public static Account createAccount(String name, String industry, String phone) {
        Account acc = new Account(
            Name = name,
            Industry = industry,
            Phone = phone
        );
        insert acc;
        return acc;
    }

    public static void updateAccountIndustry(Id accountId, String newIndustry) {
        Account acc = [SELECT Id, Industry FROM Account WHERE Id = :accountId LIMIT 1];
        acc.Industry = newIndustry;
        update acc;
    }

    public static Integer countAccountsByIndustry(String industry) {
        return [SELECT COUNT() FROM Account WHERE Industry = :industry];
    }
}