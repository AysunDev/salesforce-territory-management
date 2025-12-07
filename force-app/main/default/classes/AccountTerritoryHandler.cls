public class AccountTerritoryHandler {

    public static void assignTerritories(List<Account> accts) {
        
        try {
        //Query all relevant territory mappins
        List<Territory_Mapping__mdt> mappings = [SELECT Territory__c, State__c, Priority__c, Zip_Code__c
                                                 FROM Territory_Mapping__mdt
                                                 ORDER BY Priority__c ASC
                                                 ];
        //Map zip code to mapping record (for strategic zip matching)
        Map<String, Territory_Mapping__mdt> zipToMapping = new Map<String, Territory_Mapping__mdt>(); //new york str + cal str
      
        
        //Map state to mapping record (for state matching)
        Map<String, Territory_Mapping__mdt> stateToMapping = new Map<String, Territory_Mapping__mdt>();// new york + calif + great lake
       
        
        for(Territory_Mapping__mdt m : mappings) {
            if (!String.isBlank(m.Zip_Code__c)) {
                zipToMapping.put(m.Zip_Code__c, m);
               
            } else if (!String.isBlank(m.State__c))
                stateToMapping.put(m.State__c, m);
                
        }
        
        for (Account acc : accts) {
            String state = acc.BillingState;
            String zip = acc.BillingPostalCode;
            String newTerritory = null;
            
            
            if (!String.isBlank(zip) && zipToMapping.containsKey(zip)) {
                newTerritory = zipToMapping.get(zip).Territory__c;
            } else if (!String.isBlank(state) && stateToMapping.containsKey(state)) {
                newTerritory = stateToMapping.get(state).Territory__c;
            } else if (String.isBlank(zip) && String.IsBlank(state)) {
                newTerritory = 'Unknown';
            } else {
                newTerritory = 'Unassigned';
            }
            acc.Territory__c = newTerritory;
        }
           } catch (Exception e) {
            System.debug('An error occurred in assignTerritories: ' + e.getMessage());
        }
    }
}