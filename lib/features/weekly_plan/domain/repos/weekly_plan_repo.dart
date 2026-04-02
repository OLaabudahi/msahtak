import '../entities/hub.dart';
import '../entities/weekly_plan_details.dart';

abstract class WeeklyPlanRepo {
  
  Future<List<Hub>> getHubs();

  
  Future<WeeklyPlanDetails> getPlanDetails(String hubId);

  
  Future<void> activatePlan(String hubId);
}
