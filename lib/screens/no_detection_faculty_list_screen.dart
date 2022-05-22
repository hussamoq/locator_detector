import 'package:flutter/material.dart';
import '../widgets/faculty_item.dart';

class NoDetectionFacultyListScreen extends StatelessWidget {
  static const routeName = 'no-detection-faculty-list';
  final List<FacultyItem> facultyItems;

  NoDetectionFacultyListScreen(this.facultyItems);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose desired faculty'),
        centerTitle: true,
      ),
      body: ListView(
        children: [...facultyItems],
      ),
    );
  }
}
