import 'package:flutter/material.dart';
import 'package:locator_detector/helpers/location_helper.dart';
import '../models/faculty_location.dart';
import '../screens/map_screen.dart';

class FacultyListItem extends StatelessWidget {
  final String facultyName;
  final FacultyLocation facultyLocation;

  FacultyListItem({
    required this.facultyName,
    required this.facultyLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(
            Icons.location_on_outlined,
            color: Colors.red,
          ),
          title: Text(facultyName),
          //Asyncrosnouly fetch the user's location before moving on to
          //the map screen
          onTap: () async {
            //display a loading screen until the location is fetched
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            );

            FacultyLocation? currentPosition;
            //await current position
            try {
              currentPosition =
                  await LocationHelper.getCurrentUserLocation().timeout(
                      const Duration(
                        seconds: 15,
                      ), onTimeout: () {
                throw "Could not fetch location";
              });
            } catch (error) {
              //Make sure the location was able to be fetched,
              //otherwise display an error ot the user
              await showDialog(
                  context: context,
                  builder: (ctx) => const AlertDialog(
                        title: Text("Error Occured"),
                        content: Text('Could not fetch current location'),
                      ));

              Navigator.of(context).pop();
              return;
            }

            if (facultyName == 'Bansor') {
              var arbitraryLocation = FacultyLocation(
                currentPosition!.longitude,
                currentPosition.latitude + 0.0005,
              );
              Navigator.of(context).pushReplacementNamed(MapScreen.routeName,
                  arguments: [currentPosition, arbitraryLocation, facultyName]);

              return;
            }

            if (facultyName == 'Airfield') {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Airfield'),
                    ),
                    body: Image.asset(
                      'assets/images/airfield.png',
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              );

              return;
            }

            //replace the loading screen page with the map screen
            Navigator.of(context).pushReplacementNamed(MapScreen.routeName,
                arguments: [facultyLocation, currentPosition, facultyName]);
          },
        ),
        const Divider(),
      ],
    );
  }
}
