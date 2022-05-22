import 'package:flutter/material.dart';

class FacultyItem extends StatelessWidget {
  final int facultyId;
  final String facultyName;

  FacultyItem(this.facultyName, this.facultyId);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.account_balance_outlined),
          title: Text(facultyName),
        ),
        const Divider(),
      ],
    );
  }
}
