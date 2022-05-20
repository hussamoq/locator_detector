import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './screens/home_screen.dart';
import './screens/faculties_list_screen.dart';
import './screens/map_screen.dart';
import './screens/faculty_information_screen.dart';
import './screens/employee_list_screen.dart';

import './provider/faculty_list_povider.dart';
import './provider/faculty_information_provider.dart';

void main() {
  //Should be portraits should be initialized before running the main app
  WidgetsFlutterBinding.ensureInitialized();

  //This sets the device orientations
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //Run the main application
  runApp(Source());
}

class Source extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => FacultyListProvider()),
        ChangeNotifierProvider(create: (ctx) => FacultyInformationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Faculty Locator And Detector',
        theme: ThemeData(
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Colors.green,
            onPrimary: Colors.black,
            secondary: Colors.red,
            onSecondary: Colors.black,
            error: Colors.yellow,
            onError: Colors.orange,
            background: Colors.amber,
            onBackground: Colors.cyan,
            surface: Colors.purple,
            onSurface: Colors.blue,
          ),
        ),
        routes: {
          '/': (ctx) => HomeScreen(),
          FacultiesListScreen.routeName: (ctx) => FacultiesListScreen(),
          MapScreen.routeName: (ctx) => MapScreen(),
          FacultyInformationScreen.routeName: (ctx) =>
              FacultyInformationScreen(),
          EmployeeListScreen.routeName: (ctx) => EmployeeListScreen(),
        },
      ),
    );
  }
}
