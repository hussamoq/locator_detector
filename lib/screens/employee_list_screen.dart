import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/faculty_information_provider.dart';

import '../widgets/employee_information.dart';
import '../widgets/search_bar.dart';

import '../models/employee.dart';

class EmployeeListScreen extends StatelessWidget {
  static const routeName = '/employee-list';

  @override
  Widget build(BuildContext context) {
    final facultyInformationProvider =
        Provider.of<FacultyInformationProvider>(context);
    final List<Employee> employeeList = facultyInformationProvider.employees;

    return Scaffold(
      appBar: AppBar(
        title: Text('Search by name...'),
        centerTitle: true,
        actions: [
          SearchBar(facultyInformationProvider.addPrefix,
              facultyInformationProvider.reinitializeList)
        ],
      ),
      body: ListView.builder(
        itemBuilder: (ctx, i) {
          return EmployeeInformation(
            firstName: employeeList[i].firstName,
            lastName: employeeList[i].lastName,
            officeLocation: employeeList[i].officeLocation,
            departmentName: employeeList[i].departmentName,
          );
        },
        itemCount: facultyInformationProvider.count,
      ),
    );
  }
}
