import 'package:flutter/material.dart';
import 'package:languages/pages/initial_page.dart';
import 'package:languages/repositories/resource_repository.dart';
import 'package:languages/repositories/search_vars_repository.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ResourceRepository()),
        ChangeNotifierProvider(create: (_) => SearchVarsRepository()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Languages App',
        home: InitialPage(),
      ),
    );
  }
}
