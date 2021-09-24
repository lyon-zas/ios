import 'package:flutter/material.dart';

class Value {
  String value;
  String question;

  Value({@required this.value, @required this.question});

  static Value fromDB(String dbvalue) {
    return new Value(value: dbvalue.split(':')[0], question: dbvalue.split(':')[1]);
  }
}