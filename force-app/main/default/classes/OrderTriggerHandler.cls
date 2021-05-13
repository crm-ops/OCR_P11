public with sharing class OrderTriggerHandler { 
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean IsFromBachJob ;
    public static boolean isFromUploadAPI=false;
    
    
    public OrderTriggerHandler(boolean isExecuting, integer size)
    {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
            

    public void OnBeforeInsert(List<Order> newOrder)
    {
        system.debug('Order Trigger On Before Insert');
    }
    public void OnAfterInsert(List<Order> newOrder)
    {
        system.debug('Order Trigger On After Insert');
    }
    public void OnAfterUpdate( List<Order> newOrder, List<Order> oldOrder, Map<ID, Order> newOrderMap , Map<ID, Order> oldOrderMap )
    {
        system.debug('Order Trigger On After Update ');
       
    }
    public void OnBeforeUpdate( List<Order> newOrder, List<Order> oldOrder, Map<ID, Order> newOrderMap , Map<ID, Order> oldOrderMap )
    {
        system.debug('Order Trigger On Before Update ');
        OrderActions.blockOrderIfNoProduct(newOrder, oldOrder);

    }

    public void OnBeforeDelete(List<Order> deletedOrders, Map<Id, Order> deletedOrderMap){

        system.debug('Order Trigger On Before Delete ');
    }

    public void OnAfterDelete(List<Order> deletedOrders, Map<Id, Order> deletedOrderMap)
    {
        system.debug('Order Trigger On after Delete ');
        OrderActions.deactivateAccountsWithNoRemainingOrder(deletedOrders);
    }


    @future 
    public static void OnAfterUpdateAsync(Set<ID> newOrderIDs)
    {

    }      
    public boolean IsTriggerContext
    {
        get{ return m_isExecuting;}
    }
    
    public boolean IsVisualforcePageContext
    {
        get{ return !IsTriggerContext;}
    }
    
    public boolean IsWebServiceContext
    {
        get{ return !IsTriggerContext;}
    }
    
    public boolean IsExecuteAnonymousContext
    {
        get{ return !IsTriggerContext;}
    }
}
