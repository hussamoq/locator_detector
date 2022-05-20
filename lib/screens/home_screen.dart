import 'package:flutter/material.dart';
import 'package:locator_detector/models/employee.dart';
import 'package:locator_detector/provider/faculty_information_provider.dart';
import 'package:locator_detector/provider/faculty_list_povider.dart';
import 'package:locator_detector/screens/faculty_information_screen.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'dart:io';
import 'dart:convert';

import './faculties_list_screen.dart';
import './faculty_information_screen.dart';

import '../provider/faculty_list_povider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final facultyListProvider =
        Provider.of<FacultyListProvider>(context, listen: false);
    final facultyInformationProvider =
        Provider.of<FacultyInformationProvider>(context, listen: false);

    //Shows an informative dialog to user
    Future<void> _takePictureFrontExteriorDialog() async {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Padding(
            padding: EdgeInsets.only(bottom: 15),
            child:
                Text('Take a clear picture of the faculty\'s FRONT EXTERIOR'),
          ),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }

    //This function sends the image and wait for a response from server
    Future<Map<String, dynamic>?> _sendAndReturnResponse(XFile image) async {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://locator.loophole.site/core/emp/'),
      );
      request.headers.addAll({
        'method': 'POST',
        'accept': 'application/json',
      });
      request.files.add(
        await http.MultipartFile.fromPath('image', File(image.path).path),
      );

      //USE RESPONSE DATA HERE
      Map<String, dynamic> responseData;
      try {
        //Set a time out on send, incase server wasnt responding in time
        var response = await request.send().timeout(const Duration(seconds: 20),
            onTimeout: () {
          throw "Server timed out";
        });
        var responsed = await http.Response.fromStream(response);
        responseData = json.decode(responsed.body);
      } catch (error) {
        //remove loading screen first, then display error
        Navigator.of(context).pop();

        showDialog(
            context: context,
            builder: (ctx) {
              return const AlertDialog(
                title: Text('SERVER ERROR'),
                content: Text(
                    'An error from our end has occured, please try again later.'),
              );
            });

        return null;
      }

      return responseData;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Expanded(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: deviceHeight * 0.001,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    child: Container(
                      height: deviceHeight * 0.31,
                      width: deviceWidth * 0.31,
                      margin: const EdgeInsets.all(20),
                      child: Image.asset('assets/images/JULogo2.png'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: deviceHeight * 0.04,
              ),
              FittedBox(
                child: Text(
                  'The University of Jordan',
                  style: TextStyle(
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 0.7,
                    fontWeight: FontWeight.w400,
                    fontSize: 25,
                  ),
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.03,
              ),
              Text(
                'Locator & Detector',
                style: TextStyle(
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 0.7,
                  fontWeight: FontWeight.w400,
                  fontSize: 22,
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.07,
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(FacultiesListScreen.routeName)
                          .then(
                              //reinitailize items set after destroying the
                              //faculty list screen
                              (value) =>
                                  facultyListProvider.reinitializeList());
                    },
                    child: const Text('Locate'),
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      padding: EdgeInsets.only(
                          left: deviceWidth * 0.35, right: deviceWidth * 0.35),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      //Show a dialog informing the user to
                      //take a clear picture
                      await _takePictureFrontExteriorDialog();

                      //This is the part where the user is prompted to take a
                      //picture
                      ImagePicker picker = ImagePicker();
                      XFile? image = await picker.pickImage(
                        source: ImageSource.camera,
                        maxHeight: 640,
                        maxWidth: 640,
                      );

                      //If the user cancel the operation, image path would be null
                      //return from function in this case
                      if (image == null) {
                        return;
                      }

                      //display a loading screen while fetching data from server
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const Scaffold(
                            body: Center(child: CircularProgressIndicator())),
                      ));

                      //send image, and wait for response
                      Map<String, dynamic>? responseData =
                          await _sendAndReturnResponse(image);

                      //Return value is null, return
                      if (responseData == null) {
                        return;
                      }

                      //Data is returned as a map of maps
                      //first layer has 3 objects, faculty and employee
                      //containing the faculty and employee data respectively,
                      //faculty object having keys {name, faculty_dean,
                      //faculty_info, established_date}
                      //employee having a LIST OF MAPS each map with values
                      //{first_name, last_name, office_place,} like this:
                      //Map<String, dynamic> facultyInfo = responseData['faculty'];
                      //List<dynamic> employeeInfo = responseData['employee'];

                      if (responseData['faculty']['name'] == 'None') {
                        await showDialog(
                            context: context,
                            builder: (ctx) {
                              return const AlertDialog(
                                title: Text('SERVER ERROR'),
                                content: Text(
                                    'An error from our end has occured, please try again later.'),
                              );
                            });

                        //pop loading menu and return
                        Navigator.of(context).pop();
                        return;
                      }

                      //push in the faculty information screen
                      try {
                        Navigator.of(context).pushReplacementNamed(
                          FacultyInformationScreen.routeName,
                          arguments: <String>[
                            responseData['faculty']['name']!,
                            responseData['faculty']['faculty_dean']!,
                            responseData['faculty']['faculty_info']!,
                            responseData['faculty']['established_date']!
                                .toString(),
                          ],
                        ).then((_) {
                          //Empties the prvider's lists/containers after user steps
                          //back to the home screen
                          facultyInformationProvider.emptyList();
                        });

                        //provide the provider with the necessary employee objects
                        for (Map<String, dynamic> singleEmployee
                            in responseData['employee']) {
                          facultyInformationProvider.addEmployee(Employee(
                            firstName: singleEmployee['first_name']!,
                            lastName: singleEmployee['last_name']!,
                            officeLocation:
                                (singleEmployee['office_place1'] as String)
                                        .isEmpty
                                    ? singleEmployee['office_place']
                                    : singleEmployee['office_place1'],
                            departmentName: singleEmployee['name'],
                          ));
                        }
                      } catch (error) {
                        await showDialog(
                            context: context,
                            builder: (ctx) {
                              return const AlertDialog(
                                title: Text('Nothing detected'),
                                content: Text(
                                    'No faculty detected! make sure you\'re taking a picture of the front exterior of the faculty.'),
                              );
                            });

                        //Pop off loading screen
                        Navigator.of(context).pop();
                        return;
                      }

                      //fill in the received information in the prvoider
                      /*TO BE MODIFIED*/
                      // facultyInformationProvider.addEmployee(Employee(
                      //     firstName: 'Abdullah',
                      //     lastName: 'S',
                      //     officeLocation: '3rd Floor',
                      //     departmentName: 'CS'));
                      // facultyInformationProvider.addEmployee(Employee(
                      //     firstName: 'Ameer',
                      //     lastName: 'Sameer',
                      //     officeLocation: '2nd Floor',
                      //     departmentName: 'BIT'));

                      // for (dynamic data in responseData) {
                      //   //add info to this object then psuh to add it
                      //   //final obj = Employee(...data...);
                      //   ///facultyInformationProvider.addEmployee(empObj);
                      // }
                    },
                    child: const Text('Detect'),
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      padding: EdgeInsets.only(
                          left: deviceWidth * 0.35, right: deviceWidth * 0.35),
                    ),
                  ),
                ],
              ),
              TextButton(
                child: const Text('About'),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return AboutDialog(
                          applicationName: 'Locator And Detector',
                          applicationVersion: '1.0.0',
                          applicationIcon: Image.asset(
                            'assets/images/appLogo.png',
                            height: 30,
                            width: 30,
                          ),
                          applicationLegalese: 'All rights reserved',
                          children: const [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'This application was developed to help the general public of The University of Jordan; from guests, students up to staff members to locate general buildings and identify faculties through deep learning technology.',
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        );
                      });
                },
                style: TextButton.styleFrom(
                  alignment: Alignment.bottomCenter,
                  primary: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
