
global class ScheduleMonthlyAccountTaskBatch implements Schedulable {
    global void execute(SchedulableContext sc) {
       MonthlyAccountTaskBatch matb = new MonthlyAccountTaskBatch(); 
       database.executebatch(matb);
    }
 }