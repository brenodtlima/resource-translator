import 'dart:collection';
import 'package:flutter/material.dart';
import '../translate_resource/resource_controller.dart';
import '../translate_resource/resource_model.dart';

class ResourceRepository extends ChangeNotifier {
  List<ResourceModel> _list = [];

  String _value;
  String _languageId;
  String _moduleId;

  ResourceRepository({
    String value = '',
    String languageId = "Todos",
    String moduleId = "Todos",
  })  : _value = value,
        _languageId = languageId,
        _moduleId = moduleId;

  UnmodifiableListView<ResourceModel> get list => UnmodifiableListView(_list);

  String get value => _value;
  String get languageId => _languageId;

  /// Set a new language id to be searched and makes the controller update the resource list
  void set_languageId(
      String languageId, ResourceController resourceController, context) {
    _languageId = languageId;
    resourceController.consultDataToRepository(context);
    notifyListeners();
  }

  String get moduleId => _moduleId;

  /// Set a new module id to be searched and makes the controller update the resource list
  void set_moduleId(
      String moduleId, ResourceController resourceController, context) {
    _moduleId = moduleId;
    resourceController.consultDataToRepository(context);
    notifyListeners();
  }

  // void set_value(
  //     String value, ResourceController resourceController, context) {
  //   _value = value;
  //   resourceController.consultDataToRepository(context);
  //   notifyListeners();
  // }

  void addResource(ResourceModel resource) {
    _list.add(resource);
    notifyListeners();
  }

  /// Updates the resources list on the screen
  void setResources(List<ResourceModel> resources) {
    if (resources.isEmpty) {
      resources.add(ResourceModel(
          resource_id: "Recursos não encontrados",
          language_id: "-",));
    }
    _list = resources;
    notifyListeners();
  }
}
