trigger AccountTrigger on Account (before insert, before update) {
    
    if (Trigger.isInsert) {
             AccountTerritoryHandler.assignTerritories(Trigger.new); 
    }
    if (Trigger.isUpdate){
            List<Account> changedZipAccounts = new List<Account>();
            for(Account acc : Trigger.new) {
                Account oldAcc = Trigger.oldMap.get(acc.Id);
                if (acc.BillingPostalCode != oldAcc.BillingPostalCode) {
                    changedZipAccounts.add(acc);
                }
            }
            if (!changedZipAccounts.isEmpty()) {
                AccountTerritoryHandler.assignTerritories(changedZipAccounts);
    }
    }
}