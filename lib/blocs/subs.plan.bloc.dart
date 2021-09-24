import 'package:rxdart/rxdart.dart';
import 'package:tritek_lms/data/repository/subscription.plans.repository.dart';
import 'package:tritek_lms/http/subscription.plan.dart';

class SubsBloc {
  final SubscriptionPlanRepository _repository = SubscriptionPlanRepository();
  final BehaviorSubject<SubscriptionPlanResponse> _subSubject =
      BehaviorSubject<SubscriptionPlanResponse>();

  final BehaviorSubject<bool> _payPalSubject = BehaviorSubject<bool>();
  final BehaviorSubject<BankResponse> _bankSubject =
      BehaviorSubject<BankResponse>();

  getSubs() async {
    SubscriptionPlanResponse response = await _repository.getSubs();
    _subSubject.sink.add(response);
  }

  getBank() async {
    BankResponse response = await _repository.getBank();
    _bankSubject.sink.add(response);
  }

  getPayPal() async {
    bool response = await _repository.getPaypal();
    _payPalSubject.sink.add(response);
  }

  dispose() {
    _subSubject.close();
    _payPalSubject.close();
    _bankSubject.close();
  }

  BehaviorSubject<SubscriptionPlanResponse> get subject => _subSubject;

  BehaviorSubject<BankResponse> get bank => _bankSubject;

  BehaviorSubject<bool> get paypal => _payPalSubject;
}

final subBloc = SubsBloc();
