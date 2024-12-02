import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationController extends GetxController {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  // Fungsi untuk mencari lokasi berdasarkan latitude dan longitude
  void searchLocation(double lat, double lon) {
    latitude.value = lat;
    longitude.value = lon;
  }

  // Fungsi untuk membuka Google Maps
  void openGoogleMaps() async {
    final googleMapsUrl = 'https://www.google.com/maps?q=$latitude,$longitude';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      // Jika URL tidak dapat diluncurkan
      throw 'Could not launch $googleMapsUrl';
    }
  }


  // Fungsi untuk mendapatkan lokasi saat ini
  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    latitude.value = position.latitude;
    longitude.value = position.longitude;
  }
}
