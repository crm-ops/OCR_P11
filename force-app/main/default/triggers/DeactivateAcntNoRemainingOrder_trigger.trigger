trigger DeactivateAcntNoRemainingOrder_trigger on Order (After delete) {


// list account (id) 

if (Trigger.isDelete) {/*

                Set<Id> acntIds = new Set<Id>();

                for (Order o  : Trigger.old) {
                    acntIds.add(o.AccountId);
                }

                // Map AccountId NbOrder = SOQL select accountId count order from order where account id in list accountid group by account id 

                //Map<Id,Integer> countOrders = [SELECT AccountId , COUNT(Id) FROM Order WHERE AccountId IN :acntIds GROUP BY AccountId HAVING COUNT(Id) > 0];
                
                AggregateResult[] countOrders = [SELECT AccountId , COUNT(Id) FROM Order WHERE AccountId IN :acntIds GROUP BY AccountId HAVING COUNT(Id) > 0];
                
                List<Account> acnt2update = [SELECT Id, Active__c FROM Account WHERE Id in :acntIds];

                for(Account act : acnt2update) {

                        for(AggregateResult countOrder : countOrders) {

                                if(act.Id == countOrder.get('AccountId')) {
                                    act.Active__c=true;
                                }
                                else {
                                    act.Active__c=true;
                                }

                        }

                }

                update acnt2update;

            */ }
}