import 'package:flutter/material.dart';

import '../screens/employee_list_screen.dart';

class FacultyInformationScreen extends StatelessWidget {
  static const routeName = '/faculty-information';
  String? facultyName;
  String? facultyDean;
  String? facultyInformation;
  String? establishment;

  @override
  Widget build(BuildContext context) {
    final passedArguments =
        ModalRoute.of(context)!.settings.arguments as List<String>;
    final deviceHeight = MediaQuery.of(context).size.height;

    facultyName = passedArguments[0];
    facultyDean = passedArguments[1];
    facultyInformation = passedArguments[2];
    establishment = passedArguments[3];

    Widget _informationBuilder() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Current dean: $facultyDean',
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            'Established in $establishment',
            style: const TextStyle(fontSize: 18),
          ),
          const Divider(
            thickness: 3,
            color: Colors.black,
          ),
          SizedBox(
            height: deviceHeight * 0.02,
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Text(
                  facultyInformation!,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EmployeeListScreen.routeName);
            },
            child: const Text(
              'Employee List',
            ),
          )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(facultyName!),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(style: BorderStyle.solid, width: 2),
        ),
        child: _informationBuilder(),
      ),
    );
  }
}
