// ignore: constant_identifier_names
import 'package:location/location.dart';

import '../models/faculty_location.dart';

class LocationHelper {
  static const _GOOGLE_API_KEY = 'AIzaSyDUaZub2Tz8aXghQgHFg5jxkvH4p04UTX0';

  static String generateLocationMethod(
      {required double latitude, required double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:green%7Clabel:C%7C$latitude,$longitude&key=$_GOOGLE_API_KEY&signature=YOUR_SIGNATURE';
  }

  static Future<FacultyLocation?> getCurrentUserLocation() async {
    final location = await Location().getLocation();

    // if both altitude and longitude arent null then return them
    if (location.latitude != null && location.longitude != null) {
      return FacultyLocation(location.longitude!, location.latitude!);
    }

    //if location somehow wasnt able to be fetched then return null
    return null;
  }
}
