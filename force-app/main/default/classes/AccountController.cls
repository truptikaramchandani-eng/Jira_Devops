public with sharing class AccountController {

    /* =====================================================
       =============== FETCH ALL ACCOUNTS ==================
       ===================================================== */
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(Integer limitSize) {

        if (!Schema.sObjectType.Account.isAccessible()) {
            throw new AuraHandledException('Access denied to Account object');
        }

        Integer recordsLimit = (limitSize == null || limitSize <= 0) ? 50 : limitSize;

        return [
            SELECT Id, Name, Type, Industry, Phone, Website, BillingCity, BillingCountry
            FROM Account
            ORDER BY CreatedDate DESC
            LIMIT :recordsLimit
        ];
    }
    }