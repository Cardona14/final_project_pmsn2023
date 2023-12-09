import 'package:flutter/material.dart';

class LogProvider with ChangeNotifier{
  String? _uid;
  String? get user => _uid;
  
  set setUserUid(String value){
    _uid = value;
    notifyListeners();
  }
}