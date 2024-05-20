import 'package:flutter/material.dart';
import 'package:languages/translate_resource/resource_controller.dart';
import 'package:provider/provider.dart';

import '../../repositories/resource_repository.dart';
import '../../repositories/search_vars_repository.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final String title_text = "Olá, seja bem-vindo(a)!";
  final String hint_text_form = "Função atualmente indisponível";

  String languages_dropdownvalue = '';

  String module_dropdownvalue = '';

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchLanguages();
    _fetchModules();
  }

  /// Updates the languages present in the data using the controller and giving it to the provider
  Future<void> _fetchLanguages() async {
    final repository = Provider.of<ResourceRepository>(context, listen: false);
    final search_var = Provider.of<SearchVarsRepository>(context, listen: false);
    var resourceController = ResourceController(repository: repository);

    List<String> languages = await resourceController.getDistinctLanguages();
    setState(() {
      search_var.set_lenguages_items(languages);
      if (search_var.languages_items.isNotEmpty) {
        languages_dropdownvalue = search_var.languages_items.first;
      }
    });
  }

  /// Updates the modules present in the data using the controller and giving it to the provider
  Future<void> _fetchModules() async {
    final repository = Provider.of<ResourceRepository>(context, listen: false);
    final search_var = Provider.of<SearchVarsRepository>(context, listen: false);
    var resourceController = ResourceController(repository: repository);

    List<String> modules = await resourceController.getDistinctModules();
    setState(() {
      search_var.set_modules_items(modules);
      if (search_var.modules_items.isNotEmpty) {
        module_dropdownvalue = search_var.modules_items.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<ResourceRepository>(context, listen: false);
    final search_var = Provider.of<SearchVarsRepository>(context, listen: false);
    var resourceController = ResourceController(repository: repository);

    return SizedBox(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 4,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 35,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title_text,
                    style: const TextStyle(fontSize: 25),
                  )),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: textController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black12,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  hintText: hint_text_form,
                  contentPadding: const EdgeInsets.all(15),
                  suffixIcon: const Icon(
                    Icons.search,
                    size: 30,
                    color: Color(0xff0099e5),
                  ),
                ),
                // onChanged: (value){
                //   setState(() {
                //     search_var.value = value;
                //     repository.set_value(
                //       module_dropdownvalue,
                //       resourceController,
                //       context,
                //     );
                //   });
                // },
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Module ID"),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButton<String>(
                              value: module_dropdownvalue,
                              items: search_var.modules_items.map((String item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30, right: 1),
                                    child: Text(
                                      item,
                                      style: TextStyle(fontSize: 19),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onTap: (){
                                setState(() {

                                });
                              },
                              onChanged: (newValue) {
                                setState(() {
                                  module_dropdownvalue = newValue!;
                                });
                                repository.set_moduleId(
                                  module_dropdownvalue,
                                  resourceController,
                                  context,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Language ID"),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButton<String>(
                              value: languages_dropdownvalue,
                              items: search_var.languages_items.map((String item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30, right: 1),
                                    child: Text(
                                      item,
                                      style: TextStyle(fontSize: 19),
                                    ),
                                  ),
                                );
                              }).toList(),
                                onTap: (){
                                  setState(() {

                                  });
                                },
                              onChanged: (newValue) {
                                setState(() {
                                  languages_dropdownvalue = newValue!;
                                });
                                repository.set_languageId(
                                  languages_dropdownvalue,
                                  resourceController,
                                  context,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
