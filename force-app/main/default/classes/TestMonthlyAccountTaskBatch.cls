@isTest
private class TestMonthlyAccountTaskBatch {
    @isTest(SeeAllData=True)
    static void should_create_five_task_twelve_in_total() {

        //Create Pricebook
        Pricebook2 pb = new Pricebook2 (Name = 'Test PB001', Description ='Test PB001 Desc', IsActive=true); 
        Insert pb;

       
    
        //Create the PricebookEntry
      /*  PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = pb.Id,
            Product2Id = pd1.Id,
            UnitPrice = 1020,
            UseStandardPrice = false, 
            IsActive = true
        );
        Insert pbe;
        */

        //12 Accounts - 3 with 1 existing task each  - 3 with 1 order each  - 5 with no task or orders 

    
        //set up 10 accounts

        List<Account> lai = new List<Account>();
        for (Integer i = 0; i<12;i++){
            Account a = new Account(Name = 'Test Account_'+i);
            lai.add(a);
        }
        insert lai;

    

        //for each account create 1 contract 
        List<Contract> lci = new List<Contract>();
        List<Id> listAccountIds = new List<Id>();
        for (Account a : lai) {

            listAccountIds.add(a.Id);
            Contract c = new Contract(
            AccountId=a.Id,
            Status='Draft',
            StartDate = Date.newInstance(2021, 4, 1),
            ContractTerm = 24
            );

            lci.add(c);
        } 
            insert lci;

        Map<Id, Contract> mc= new Map<Id,Contract>([Select Id, AccountId from Contract WHERE AccountId in :listAccountIds]);  

        
        //Loop to affect a task to account 1 to 3 and an order to account 4 to 6 > add a test on account name
        
       
        List<Order> loi = new List<Order>();
        List<Task> lti = new List<Task>();
        Integer nbacntnotsknoordr =0; 
        for (Account a : lai) {
            for (Integer nborders = 0; nborders <1; nborders++){
                String crtId='';
                for(ID idKey:mc.keySet()) {
                    Contract c= mc.get(idKey);
                    if(c.AccountId==a.Id){
                        crtId=idKey;
                    }

                }
            
            If (a.Name == 'Test Account_0' ||a.Name == 'Test Account_1'||a.Name == 'Test Account_2'){
            // test name on nborders to create a task or an order or nothing
             Order o = new Order( AccountId = a.Id, EffectiveDate=Date.newInstance(2021, 4, 1) , ContractId = crtId , Status='Draft', Pricebook2Id=pb.Id);
             
             loi.add(o);
            } else if (a.Name == 'Test Account_3' ||a.Name == 'Test Account_4'||a.Name == 'Test Account_5'){
               
                Task t = new Task (WhatId = a.Id, Subject = 'Existing Task' , Status ='In Progress', Priority = 'Normal', IsRecurrence = false , ReminderDateTime = System.today().addDays(5), IsReminderSet =true );
              lti.add(t);  

            } else {
                nbacntnotsknoordr++;
                System.debug('nb account with no task or order should be 6 on test init actual is >'+nbacntnotsknoordr); 
            }

                

            } 
        }
            
            insert loi;
            insert lti;

       
        Test.startTest();
        MonthlyAccountTaskBatch matb = new MonthlyAccountTaskBatch();
        Id batchId = Database.executeBatch(matb);
        Test.stopTest();
        // after the testing stops, assert records were updated properly

       
        System.assertEquals(12, [select count() from Account WHERE Id IN :listAccountIds]);
        System.assertEquals(3, [select count() from Order WHERE AccountId IN :listAccountIds]);
        //System.assertEquals(6, nbacntnotsknoordr);
        System.assertEquals(3, [select count() from Task WHERE WhatId IN :listAccountIds AND Subject ='Existing Task']);
        System.assertEquals(6, [select count() from Task WHERE WhatId IN :listAccountIds AND Subject ='Call']);

    
    }
}