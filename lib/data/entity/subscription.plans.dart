class SubscriptionPlans {
  int id;
  String name;
  String price;
  String plan;
  List<String> properties;

  SubscriptionPlans(
      {this.id, this.name, this.price, this.plan, this.properties});

  SubscriptionPlans.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    plan = json['plan'];
    properties = json['properties'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['plan'] = this.plan;
    data['properties'] = this.properties;
    return data;
  }
}

class AccountDetails {
  String bankName;
  String accountNo;
  String sortCode;
  String name;

  AccountDetails({this.bankName, this.name, this.accountNo, this.sortCode});

  AccountDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    accountNo = json['accountNo'];
    sortCode = json['sortCode'];
    bankName = json['bankName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['bankName'] = this.bankName;
    data['sortCode'] = this.sortCode;
    data['accountNo'] = this.accountNo;
    return data;
  }
}
