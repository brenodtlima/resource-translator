import 'dart:collection';

import 'package:flutter/material.dart';

class SearchVarsRepository extends ChangeNotifier{
  String value = "";
  List<String> _languages_items = [];
  List<String> _modules_items = [];

  UnmodifiableListView<String> get languages_items => UnmodifiableListView(_languages_items);
  UnmodifiableListView<String> get modules_items => UnmodifiableListView(_modules_items);

  void set_lenguages_items(List<String> list){
    _languages_items = list;
    notifyListeners();
  }

  // void set_value(String value){
  //   value = value;
  //   notifyListeners();
  // }

  void set_modules_items(List<String> list){
    _modules_items = list;
    notifyListeners();
  }

}