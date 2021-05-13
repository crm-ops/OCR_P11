trigger BlockNoProductOrderActivation_trigger on Order (before update) {



  
   /* if (Trigger.isUpdate) {
        for (Order orderOld : Trigger.old) {

                   for (Order orderNew : Trigger.new) {

                    if (orderOld.Id == orderNew.Id){

                                

                                if(orderOld.Status =='Draft' && orderNew.Status=='Activated' && orderOld.nbOrderLines__c == 0){
                                    
                                      orderNew.addError('The Order has no product line items and cannot be activated as is. Please add products before attempting to Activate the order');  

                                    }

                        }

                    } 


            }
        }
*/
}