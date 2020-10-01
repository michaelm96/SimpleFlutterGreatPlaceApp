import 'dart:convert';
import 'package:http/http.dart' as http;

const GOOGLE_API_KEY = 'thisIsRandom';

class LocationHelper {
  static String generateLocationPreviewImage(
      {double latitude, double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

  static Future<String> getPlacesAddress(double lat, double lng) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY';
    final res = await http.get(url);
    return json.decode(res.body)['results'][0][
        'formatted_address']; // 'results' and 'formatted_address' key got from google map response
  }
}
