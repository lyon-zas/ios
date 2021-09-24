import 'package:tritek_lms/http/subscription.plan.dart';

class SubscriptionPlanRepository {
  SubscriptionPlanApiProvider _apiProvider = SubscriptionPlanApiProvider();

  Future<SubscriptionPlanResponse> getSubs() {
    return _apiProvider.getSubscriptionPlans();
  }

  Future<bool> getPaypal() {
    return _apiProvider.getPayPal();
  }

  Future<BankResponse> getBank() {
    return _apiProvider.getBank();
  }
}
