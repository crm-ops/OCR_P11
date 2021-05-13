global class MonthlyAccountTaskBatch implements Database.Batchable<sObject>, Database.Stateful {
    
   global Database.QueryLocator start(Database.BatchableContext bc){ 
       //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Ordered'
       return Database.getQueryLocator('SELECT Id FROM Account');

   }
    
   global void execute(Database.BatchableContext bc, List<Account> scope){      

       //storing all orders
       List<Order> acntIdsWithOrder = [Select AccountId from Order];
       
       
       List<Task> acntIdsWithTask = [Select WhatId from Task WHERE WhatId IN :scope AND Status !='Completed'];
       Set<Id> acntIdsWithTaskOrOrder = new Set<Id>();

       //Merging account Id with an order or a non completed task in a single set
       for (Order o : acntIdsWithOrder) {
                    acntIdsWithTaskOrOrder.add(o.AccountId);
       } 
       for (Task t : acntIdsWithTask) {
               acntIdsWithTaskOrOrder.add(t.WhatId);
       }
    
       //Creating a task for account without order or active task
       List<Task> taskstoinsert = new List<Task>();
       for(Account myAccount : scope ){

                if( acntIdsWithTaskOrOrder.contains(myAccount.Id)) {
                    System.debug('This account id> '+myAccount.Id+' is associated with an order or a task to complete ... no need to add task');
                } else {
                Task t = new Task (WhatId = myAccount.Id, Subject = 'Call' , Status ='Not Started', Priority = 'Normal', IsRecurrence = false , ReminderDateTime = System.today().addDays(5), IsReminderSet =true );

                taskstoinsert.add(t);
                }
           }                   
       
   
       
       insert taskstoinsert;
   }    
    
   global void finish(Database.BatchableContext info){     
       
   } 
}