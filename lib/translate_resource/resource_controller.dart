import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:languages/repositories/search_vars_repository.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../pages/initial_page.dart';
import '../repositories/resource_repository.dart';
import '../translate_resource/resource_model.dart';

class ResourceController {
  final ResourceRepository repository;
  Database? _database;

  ResourceController({required this.repository});

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize the database if necessary
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'resource_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE resources('
          'created_at INTEGER, '
          'updated_at INTEGER, '
          'resource_id TEXT PRIMARY KEY, '
          'module_id TEXT, '
          'value TEXT, '
          'language_id TEXT)',
        );
      },
    );
  }

  /// Insert a list of resources into the database using batches
  Future<void> insertResources(List<ResourceModel> resources) async {
    final db = await database;
    await db.transaction((txn) async {
      Batch batch = txn.batch();
      for (var resource in resources) {
        batch.insert(
          'resources',
          resource.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  /// In case the table is empty, make the http request and load it
  Future<void> fetchAndStoreResources(BuildContext context) async {
    final db = await database;
    final search_var = Provider.of<SearchVarsRepository>(context, listen: false);
    List<Map<String, dynamic>> tables = await db.query('resources', limit: 1, );
    try {
      if (tables.isEmpty) {
        print("Requisitando http");
        final response = await http.get(Uri.parse(
            'http://portal.greenmilesoftware.com/get_resources_since'));
        print(response.statusCode);
        if (response.statusCode == 200) {
          List<dynamic> jsonData = json.decode(response.body);
          List<ResourceModel> resources = jsonData
              .map((item) => ResourceModel.fromMap(item['resource']))
              .toList();
          await insertResources(resources);
          search_var.set_lenguages_items(await getDistinctLanguages());
          search_var.set_modules_items(await getDistinctModules());

        } else {
          throw Exception('Failed to load resources');
        }
      }
      consultDataToRepository(context);
    } catch (e) {
      print("Error fetching and storing resources: $e");
    }
  }

  /// For every change in the search variables, creates another query and updates de list of resources
  Future<void> consultDataToRepository(BuildContext context) async {
    final db = await database;
    final repository = Provider.of<ResourceRepository>(context, listen: false);

    final value = repository.value;
    final languageId = repository.languageId;
    final module_id = repository.moduleId;

    String whereClause = '';
    List<dynamic> whereArgs = [];
    //
    // if (value != "") {
    //   whereClause += 'value LIKE ?';
    //   whereArgs.add(value); // Using % for LIKE operation
    // }

    if (languageId != "Todos") {
      if (whereClause.isNotEmpty) {
        whereClause += ' AND ';
      }
      whereClause += 'language_id = ?';
      whereArgs.add(languageId);
    }

    if (module_id != "Todos") {
      if (whereClause.isNotEmpty) {
        whereClause += ' AND ';
      }
      whereClause += 'module_id = ?';
      whereArgs.add(module_id);
    }

    List<Map<String, dynamic>> result = await db.query(
      'resources',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
    );

    List<ResourceModel> resources = result.map((row) => ResourceModel.fromMap(row)).toList();
    repository.setResources(resources);
  }

  /// Get a list of all the languages present in the data
  Future<List<String>> getDistinctLanguages() async {
    final db = await database;

    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT DISTINCT language_id FROM resources');
    List<String> distinctLanguages =
        result.map((row) => row['language_id'] as String).toList();
    distinctLanguages.insert(0, "Todos");
    return distinctLanguages;
  }

  /// Get a list of all the modules ids present in the data
  Future<List<String>> getDistinctModules() async {
    final db = await database;

    List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT DISTINCT module_id FROM resources',
    );
    List<String> distinctModules =
        result.map((row) => row['module_id'] as String).toList();
    distinctModules.insert(0, "Todos");

    return distinctModules;
  }
}
