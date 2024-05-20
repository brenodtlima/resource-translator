import 'package:flutter/material.dart';
import 'package:languages/components/search_bar/custom_search_bar.dart';

import '../components/list_components/custom_list_components.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomSearchBar(),
          CustomListComponents(),
        ],
      ),
    );
  }
}
