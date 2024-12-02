import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationController extends GetxController {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var isRealtimeDetectionEnabled = false.obs; // Status fitur realtime detection

  Position? _currentPosition;

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

  // Fungsi untuk mengaktifkan atau menonaktifkan realtime location detection
  void toggleRealtimeDetection() async {
    isRealtimeDetectionEnabled.value = !isRealtimeDetectionEnabled.value;

    if (isRealtimeDetectionEnabled.value) {
      // Aktifkan deteksi lokasi
      _startLocationTracking();
    } else {
      // Hentikan deteksi lokasi
      _stopLocationTracking();
    }
  }

  // Mulai deteksi lokasi secara terus-menerus
  void _startLocationTracking() {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update setiap 10 meter
      ),
    ).listen((Position position) {
      _currentPosition = position;
      latitude.value = position.latitude;
      longitude.value = position.longitude;
    });
  }

  // Hentikan deteksi lokasi
  void _stopLocationTracking() {
    // Anda bisa menambahkan logika untuk menghentikan stream lokasi
    // Namun, Geolocator otomatis menghentikan stream saat tidak digunakan
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
