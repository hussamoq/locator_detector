import 'package:flutter/material.dart';

class EmployeeInformation extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String officeLocation;
  final String departmentName;

  EmployeeInformation({
    required this.firstName,
    required this.lastName,
    required this.officeLocation,
    required this.departmentName,
  });

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Card(
      elevation: 5,
      shadowColor: Colors.green,
      child: Container(
        padding: EdgeInsets.only(
            bottom: deviceHeight * 0.02, top: 5, left: 5, right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Employee name: $firstName $lastName'),
            Text('Department name: $departmentName'),
            Text('Office location: $officeLocation')
          ],
        ),
      ),
    );
  }
}
