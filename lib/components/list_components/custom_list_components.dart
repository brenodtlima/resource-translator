import 'package:flutter/material.dart';
import 'package:languages/repositories/resource_repository.dart';
import 'package:provider/provider.dart';
import '../../translate_resource/resource_controller.dart';
import '../../translate_resource/resource_model.dart';
import '../../translate_resource/resource_view.dart';

class CustomListComponents extends StatefulWidget {
  const CustomListComponents({super.key});

  @override
  State<CustomListComponents> createState() => _CustomListComponentsState();
}

class _CustomListComponentsState extends State<CustomListComponents> {
  late ResourceController _resourceController;

  @override
  void initState() {
    super.initState();
    final repository = Provider.of<ResourceRepository>(context, listen: false);
    _resourceController = ResourceController(repository: repository);
    _initializeResources();
  }

  /// Being called in the initState, will check if theres already a database, and if not, make the controller create it
  Future<void> _initializeResources() async {
    await _resourceController.fetchAndStoreResources(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ResourceRepository>(builder: (context, resources, child) {
      return resources.list.isEmpty
          ? Expanded(
        child: Stack(
          children: [
            Opacity(
              opacity: 0.7,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/clouds_bg.png'),
                      fit: BoxFit.fitWidth),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    child: Image.asset(
                      "assets/gifs/loading.gif",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text("Carregando dados"),
                ],
              ),
            ),
          ],
        ),
      )
          : Expanded(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return ResourceView(resource: resources.list[index]);
          },
          itemCount: resources.list.length,
        ),
      );
    });
  }
}
