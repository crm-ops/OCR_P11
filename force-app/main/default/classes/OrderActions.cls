public without sharing class OrderActions {
    public static void blockOrderIfNoProduct (  List<Order> newOrder, List<Order> oldOrder)
    {
        for (Order oo : oldOrder) {

            for (Order no : newOrder) {

             if (oo.Id == no.Id){

                         

                         if(oo.Status =='Draft' && no.Status=='Activated' && oo.nbOrderLines__c == 0){
                             
                               no.addError('The Order has no product line items and cannot be activated as is. Please add products before attempting to Activate the order');  

                             }

                 }

             } 


     }
    }

    public static void deactivateAccountsWithNoRemainingOrder ( List<Order> deletedOrders)
    {
        Set<Id> acntIds = new Set<Id>();

        for (Order o  : deletedOrders) {
            acntIds.add(o.AccountId);
        }

        // Map AccountId NbOrder = SOQL select accountId count order from order where account id in list accountid group by account id 

        //Map<Id,Integer> countOrders = [SELECT AccountId , COUNT(Id) FROM Order WHERE AccountId IN :acntIds GROUP BY AccountId HAVING COUNT(Id) > 0];
        
        AggregateResult[] countOrders = [SELECT AccountId, COUNT(Id) FROM Order WHERE AccountId IN :acntIds GROUP BY AccountId HAVING COUNT(Id) > 0];
        
        List<Id> aIdsWithPositiveOrderCount = new List<Id>();
        
        for (AggregateResult co : countOrders) {
            aIdsWithPositiveOrderCount.add((Id) co.get('AccountId'));
        }

       
        List<Account> acnt2update = [SELECT Id, Active__c FROM Account WHERE Id in :acntIds];

        for(Account act : acnt2update) {

               

                        if(aIdsWithPositiveOrderCount.contains(act.Id)) {
                            act.Active__c=true;
                        }
                        else {
                            act.Active__c=false;
                        }

                

        }

        update acnt2update;

    }
}
