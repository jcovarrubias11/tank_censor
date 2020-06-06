import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CensorProvider extends ChangeNotifier {
  FirebaseDatabase database = new FirebaseDatabase();
  bool _switchCensor = false;

  bool get switchCensor => _switchCensor;

  CensorProvider.instance();

  void updateSwitch(value) {
    _switchCensor = _switchCensor == true ? false : true;
    print(_switchCensor);
    notifyListeners();
  }
}
