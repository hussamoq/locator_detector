import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locator_detector/models/faculty_location.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/map-screen';

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  FacultyLocation? userLocation;
  FacultyLocation? faculty;
  String? facultyName;
  FacultyLocation? liveLocation;
  bool initializedCurrentLocation = false;

  @override
  Widget build(BuildContext context) {
    final initialLocation =
        ModalRoute.of(context)!.settings.arguments as List<Object?>;
    faculty = initialLocation[0] as FacultyLocation?;
    userLocation = initialLocation[1] as FacultyLocation;

    facultyName = initialLocation[2] as String?;

    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.satellite,
            markers: <Marker>{
              Marker(
                infoWindow: const InfoWindow(title: 'You'),
                markerId: const MarkerId('user199231244549'),
                position: LatLng(
                  userLocation!.latitude,
                  userLocation!.longitude,
                ),
              ),
              Marker(
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueCyan),
                infoWindow: InfoWindow(title: facultyName!),
                markerId: MarkerId(facultyName!),
                position: LatLng(
                  faculty!.latitude,
                  faculty!.longitude,
                ),
              )
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(faculty!.latitude, faculty!.longitude),
              zoom: 16,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.cyan,
                    ),
                    Text(
                      ' $facultyName',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        backgroundColor: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: const [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.red,
                    ),
                    Text(
                      ' You',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        backgroundColor: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
