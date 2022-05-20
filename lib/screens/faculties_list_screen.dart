import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/faculty_list_item.dart';
import '../widgets/search_bar.dart';

import '../provider/faculty_list_povider.dart';

class FacultiesListScreen extends StatelessWidget {
  static const routeName = '/faculties-list';

  @override
  Widget build(BuildContext context) {
    final facultyProvider = Provider.of<FacultyListProvider>(context);

    //Keep a copy of the list instead of calling List() multiple times
    //in ListView.builder below
    var facultiesList = facultyProvider.items.map((item) {
      return FacultyListItem(
        facultyName: item.name,
        facultyLocation: item.location,
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title:
            const FittedBox(child: Text('Search for a faculty or building...')),
        actions: [
          SearchBar(
            facultyProvider.newPrefix,
            facultyProvider.reinitializeList,
          ),
        ],
        centerTitle: true,
      ),
      body: Scrollbar(
        thickness: 5,
        interactive: true,
        child: ListView.builder(
          itemCount: facultyProvider.count,
          itemBuilder: (ctx, i) => facultiesList[i],
        ),
      ),
    );
  }
}
