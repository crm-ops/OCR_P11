
@isTest
public with sharing class TestBlockActvtnNoPrdctOrderTrig {
    


        @isTest
        public static void shouldProduceActivatedOrderWithProducts() {

            Account acc1 = new Account(Name = 'Test Account 1');
            
            List<Account> al = new List<Account>();
            al.add(acc1);
    
            insert al;

            
            // Create a Pricebook

                Pricebook2 priceBook = new Pricebook2(
                    Name = 'Example Price Book',
                    Description = 'This is the Price Book description.',
                    IsActive = true
                );

                insert priceBook;

                // Create a Product

                Product2 product = new Product2(
                    Name = 'Example Product',
                    Description = 'This is the Product description.',
                  //  ProductCode = 'EX1234',
                  //  StockKeepingUnit = 'EX5678',
                    Family = 'Example Product Family',
                    QuantityUnitOfMeasure = 'inches',
                    DisplayUrl = 'https://www.example.com/',
                    ExternalId = 'ID #1234',
                    //ExternalDataSourceId = '0XCXXXXXXXXXXXXXXX',
                    IsActive = true
                );

                insert product;

                // Get the Standard Price Book ID

                // Instantiate the Pricebook2 record first, setting the Id
                    Pricebook2 standardPricebook = new Pricebook2(
                        Id = Test.getStandardPricebookId(),
                        IsActive = true
                    );

                    update standardPricebook;

                // Insert the Product in the Standard Price Book (if necessary)

                PricebookEntry standardPriceBookEntry = new PricebookEntry(
                    Pricebook2Id = standardPriceBook.Id,
                    Product2Id = product.Id,
                    UnitPrice = 100.00,
                    UseStandardPrice = false,
                    IsActive = true
                );

                insert standardPriceBookEntry;

                // Insert the Product in the New Price Book

                PricebookEntry priceBookEntry = new PricebookEntry(
                    Pricebook2Id = priceBook.Id,
                    Product2Id = product.Id,
                    UnitPrice = 100.00,
                    UseStandardPrice = false,
                    IsActive = true
                );

                insert priceBookEntry;    


            
            //Create the Contract
            Contract ctrct = new Contract(
                AccountId = acc1.Id,
                Status='Draft',
                StartDate = Date.newInstance(2021, 5, 2),
                ContractTerm = 24
            );
    
            Insert ctrct;

            ctrct = [SELECT Id, Status FROM Contract WHERE Status = 'Draft'];
            ctrct.status = 'Activated';

            update ctrct;
            
    
         
    
            //prepare to insert a list of 100 orders
            List<Order> listobase = new List<Order>();
            String crtid='';
    
            for(Account a:al) {
                if(a.id == acc1.Id){
                    crtid=ctrct.Id;
    
                } 
    
                for (Integer i = 0; i<1;i++ ) {
    
                    Order o = new Order(AccountId = a.Id, EffectiveDate=Date.newInstance(2021, 5, 2) , ContractId = crtid, Status='Draft', Pricebook2Id=standardPriceBook.Id);
                    listobase.add(o);
                }
    
            }
    
            insert listobase;
    
            List<Id> accntIds = new List<Id>();
            accntIds.add(acc1.Id);
           
    
            listobase = [SELECT Id,  AccountId, Pricebook2Id FROM Order WHERE Pricebook2Id= :standardPriceBook.Id AND AccountId IN :accntIds];
            
            //for each order create 1 orderitem line
            Integer qty = 0;
            List<OrderItem> listoibase = new List<OrderItem>();
    
            List<PricebookEntry> pbeid = [Select Id,  Pricebook2Id from PricebookEntry where PriceBook2Id = :standardPriceBook.Id];
    
            for ( Order o :listobase) {
                if (o.AccountId==acc1.Id && o.Pricebook2Id == standardPriceBook.Id) {
                    qty=10;
                }
    
                   
                OrderItem oi = new OrderItem(OrderId = o.Id, PricebookEntryId = pbeid[0].Id, Quantity=qty, UnitPrice = 150);
                listoibase.add(oi);
            }
    
    
            //dml to insert line items & update orders in bulk 
            insert listoibase;


            //Test sequence - get the order and attempt to activate it

            Test.startTest();
        
            for ( Order o :listobase) {
                o.Status ='Activated';

            }

            update listobase;
            
            
            
            Test.stopTest();
            
            standardPricebook = [SELECT IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
            system.assertEquals(true, standardPricebook.IsStandard, 'The Standard Pricebook should now return IsStandard = true');
            
            
            List<Order> activeOrders = [SELECT Id  FROM Order WHERE Status = 'Activated'];
            
    
            System.assertNotEquals(0, activeOrders.size());


        }


        @isTest
        public static void shouldGenerateAnErrorMessage() {
            Boolean expectedExceptionThrown=false;

            Account acc1 = new Account(Name = 'Test Account 1');
            
            List<Account> al = new List<Account>();
            al.add(acc1);
    
            insert al;

            
            // Create a Pricebook

                Pricebook2 priceBook = new Pricebook2(
                    Name = 'Example Price Book',
                    Description = 'This is the Price Book description.',
                    IsActive = true
                );

                insert priceBook;

                // Create a Product

                Product2 product = new Product2(
                    Name = 'Example Product',
                    Description = 'This is the Product description.',
                  //  ProductCode = 'EX1234',
                  //  StockKeepingUnit = 'EX5678',
                    Family = 'Example Product Family',
                    QuantityUnitOfMeasure = 'inches',
                    DisplayUrl = 'https://www.example.com/',
                    ExternalId = 'ID #1234',
                    //ExternalDataSourceId = '0XCXXXXXXXXXXXXXXX',
                    IsActive = true
                );

                insert product;

                // Get the Standard Price Book ID

                // Instantiate the Pricebook2 record first, setting the Id
                    Pricebook2 standardPricebook = new Pricebook2(
                        Id = Test.getStandardPricebookId(),
                        IsActive = true
                    );

                    update standardPricebook;

                // Insert the Product in the Standard Price Book (if necessary)

                PricebookEntry standardPriceBookEntry = new PricebookEntry(
                    Pricebook2Id = standardPriceBook.Id,
                    Product2Id = product.Id,
                    UnitPrice = 100.00,
                    UseStandardPrice = false,
                    IsActive = true
                );

                insert standardPriceBookEntry;

                // Insert the Product in the New Price Book

                PricebookEntry priceBookEntry = new PricebookEntry(
                    Pricebook2Id = priceBook.Id,
                    Product2Id = product.Id,
                    UnitPrice = 100.00,
                    UseStandardPrice = false,
                    IsActive = true
                );

                insert priceBookEntry;    


            
            //Create the Contract
            Contract ctrct = new Contract(
                AccountId = acc1.Id,
                Status='Draft',
                StartDate = Date.newInstance(2021, 5, 2),
                ContractTerm = 24
            );
    
            Insert ctrct;

            ctrct = [SELECT Id, Status FROM Contract WHERE Status = 'Draft'];
            ctrct.status = 'Activated';

            update ctrct;
            
    
         
    
            //prepare to insert a list of 100 orders
            List<Order> listobase = new List<Order>();
            String crtid='';
    
            for(Account a:al) {
                if(a.id == acc1.Id){
                    crtid=ctrct.Id;
    
                } 
    
                for (Integer i = 0; i<1;i++ ) {
    
                    Order o = new Order(AccountId = a.Id, EffectiveDate=Date.newInstance(2021, 5, 2) , ContractId = crtid, Status='Draft', Pricebook2Id=standardPriceBook.Id);
                    listobase.add(o);
                }
    
            }
    
            insert listobase;
    
            List<Id> accntIds = new List<Id>();
            accntIds.add(acc1.Id);
           
    
            listobase = [SELECT Id,  AccountId, Pricebook2Id FROM Order WHERE Pricebook2Id= :standardPriceBook.Id AND AccountId IN :accntIds];
            
            //for each order create 1 orderitem line
            Integer qty = 0;
            List<OrderItem> listoibase = new List<OrderItem>();
    
            List<PricebookEntry> pbeid = [Select Id,  Pricebook2Id from PricebookEntry where PriceBook2Id = :standardPriceBook.Id];
    
            /*for ( Order o :listobase) {
                if (o.AccountId==acc1.Id && o.Pricebook2Id == standardPriceBook.Id) {
                    qty=10;
                }
    
                   
                OrderItem oi = new OrderItem(OrderId = o.Id, PricebookEntryId = pbeid[0].Id, Quantity=qty, UnitPrice = 150);
                listoibase.add(oi);
            }
            */
    
    
            //dml to insert line items & update orders in bulk 
            insert listoibase;


            //Test sequence - get the order and attempt to activate it

            Test.startTest();
        
            try {
            for ( Order o :listobase) {
                o.Status ='Activated';

            }

            update listobase;
            
            } catch (Exception e ) {
            expectedExceptionThrown  = e.getMessage().contains('The Order has no product line items and cannot be activated as is. Please add products before attempting to Activate the order')?true:false;
            
            }       

            Test.stopTest();
            
          
            
            List<Order> activeOrders = [SELECT Id  FROM Order WHERE Status = 'Activated'];
            
    
            System.assertEquals(0, activeOrders.size());
            System.assertEquals(true, expectedExceptionThrown);

        }
           
           
           
           
            



    
}
