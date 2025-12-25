public with sharing class AccountTriggerHandler {

    /* =====================================================
       ================= BEFORE INSERT =====================
       ===================================================== */
    public static void beforeInsert(List<Account> newList) {
        for (Account acc : newList) {
            // Default Account Name
            if (String.isBlank(acc.Name)) {
                acc.Name = 'New Account';
            }

            // Example: Default Type
            if (String.isBlank(acc.Type)) {
                acc.Type = 'Customer';
            }
        }
    }

    /* =====================================================
       ================= BEFORE UPDATE =====================
       ===================================================== */
    public static void beforeUpdate(List<Account> newList, Map<Id, Account> oldMap) {
        for (Account acc : newList) {
            Account oldAcc = oldMap.get(acc.Id);

            // Prevent Industry change once set
            if (oldAcc.Industry != null && acc.Industry != oldAcc.Industry) {
                acc.addError('Industry cannot be changed once set.');
            }
        }
    }

    /* =====================================================
       ================= BEFORE DELETE =====================
       ===================================================== */
    public static void beforeDelete(List<Account> oldList) {
        for (Account acc : oldList) {
            // Prevent deletion of Customer Accounts
            if (acc.Type == 'Customer') {
                acc.addError('Customer Accounts cannot be deleted.');
            }
        }
    }

    /* =====================================================
       ================= AFTER INSERT ======================
       ===================================================== */
    public static void afterInsert(List<Account> newList) {
        // Example: Log or async processing
        System.debug('Accounts inserted: ' + newList.size());
    }

    /* =====================================================
       ================= AFTER UPDATE ======================
       ===================================================== */
    public static void afterUpdate(List<Account> newList, Map<Id, Account> oldMap) {
        // Example: Future callout / platform event
        System.debug('Accounts updated');
    }

    /* =====================================================
       ================= AFTER DELETE ======================
       ===================================================== */
    public static void afterDelete(Map<Id, Account> oldMap) {
        System.debug('Accounts deleted: ' + oldMap.size());
    }

    /* =====================================================
       ================= AFTER UNDELETE ====================
       ===================================================== */
    public static void afterUndelete(List<Account> newList) {
        System.debug('Accounts undeleted: ' + newList.size());
    }
}