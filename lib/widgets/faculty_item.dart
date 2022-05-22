import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../provider/faculty_information_provider.dart';

import '../screens/employee_list_screen.dart';
import 'dart:convert';

import '../models/employee.dart';

const URI_WEBSITE_LINK = 'locator.loophole.site';
const URI_PATH_TO_EMPLOYEES = '/core/employeelist/';
const SECRET_TOKEN = 'hashtag@#ploaanhyvybal*1288mmc32*())(!';

class FacultyItem extends StatelessWidget {
  final int facultyId;
  final String facultyName;

  FacultyItem(this.facultyName, this.facultyId);

  @override
  Widget build(BuildContext context) {
//Use this shared provider
    final facultyInformationProvider =
        Provider.of<FacultyInformationProvider>(context, listen: false);

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.account_balance_outlined),
          title: Text(facultyName),
          onTap: () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            );

            try {
              http.Response response = await http.get(
                Uri.http(URI_WEBSITE_LINK, URI_PATH_TO_EMPLOYEES,
                    {'id': facultyId.toString()}),
                headers: {
                  'method': 'GET',
                  'accept': 'application/json',
                  'authentication-token': SECRET_TOKEN,
                },
              ).timeout(const Duration(seconds: 15),
                  onTimeout: () => throw "Connection timed out");

              //provide the provider with the necessary employee objects
              for (Map<String, dynamic> singleEmployee
                  in jsonDecode(response.body)) {
                facultyInformationProvider.addEmployee(
                  Employee(
                    firstName: singleEmployee['first_name']!,
                    lastName: singleEmployee['last_name']!,
                    officeLocation:
                        (singleEmployee['office_place1'] as String).isEmpty
                            ? singleEmployee['office_place']
                            : singleEmployee['office_place1'],
                    departmentName: singleEmployee['name'],
                  ),
                );
              }
            } catch (error) {
              await showDialog(
                  context: context,
                  builder: (ctx) {
                    return const AlertDialog(
                      title: Text('SERVER ERROR'),
                      content: Text(
                          'An error from our end has occured, please try again later.'),
                    );
                  });

              Navigator.of(context).pop();
              return;
            }

            //Push employee screen after being done fetching data
            Navigator.of(context)
                .pushReplacementNamed(EmployeeListScreen.routeName)
                //Emplty list after coming back from screen
                .then((_) => facultyInformationProvider.emptyList());
          },
        ),
        const Divider(
          thickness: 1.5,
        ),
      ],
    );
  }
}
