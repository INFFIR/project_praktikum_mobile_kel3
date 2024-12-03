import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationController extends GetxController {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

    StreamSubscription<Position>? _positionStreamSubscription;

  void startLocationTracking(){
    Geolocator.isLocationServiceEnabled().then((serviceEnabled) async{
      if (!serviceEnabled){
        Get.snackbar('Error', 'Layanan Lokasi tidak dapat diaktifkan.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied){
        permission = await Geolocator.requestPermission();
        Get.snackbar('Error', 'Permission lokasi ditolak.');
        return;
      }
    
      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high, // Akurasi tinggi
          distanceFilter: 1, // Perbarui jika jarak pengguna berubah 10 meter
        ),
      ).listen((Position position) {
        latitude.value = position.latitude;
        longitude.value = position.longitude;
      });
    });
  }

  void stopLocationTracking(){
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }

  // Tambahkan variabel untuk tracking
  var isTracking = false.obs;
  Timer? _timer;

  // Fungsi untuk mencari lokasi berdasarkan latitude dan longitude
  void searchLocation(double lat, double lon) {
    latitude.value = lat;
    longitude.value = lon;
  }


    void navigateToStore(double storeLat, double storeLon) async {
    final googleMapsUrl = 
    'https://www.google.com/maps/dir/?api=1&origin=${latitude.value},${longitude.value}&destination=$storeLat,$storeLon&travelmode=driving';

    if (await canLaunch(googleMapsUrl)){
      await launch(googleMapsUrl);
    } else {
      Get.snackbar(
        'Error', 
        'Tidak dapat membuka Google Maps.');
    }
  }





  // Fungsi untuk membuka Google Maps
  void openGoogleMaps() async {
    final googleMapsUrl =
        'https://www.google.com/maps?q=${latitude.value},${longitude.value}';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      // Jika URL tidak dapat diluncurkan
      throw 'Could not launch $googleMapsUrl';
    }
  }

  // Fungsi untuk mendapatkan lokasi saat ini
  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      latitude.value = position.latitude;
      longitude.value = position.longitude;
    } catch (e) {
      // Tangani error jika gagal mendapatkan lokasi
      print('Error getting location: $e');
    }
  }

  // Fungsi untuk memulai tracking
  void startTracking() {
    if (!isTracking.value) {
      isTracking.value = true;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        await getCurrentLocation();
      });
    }
  }

  // Fungsi untuk menghentikan tracking
  void stopTracking() {
    if (isTracking.value) {
      isTracking.value = false;
      _timer?.cancel();
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}

// Fungsi untuk membuka Google Maps untuk rute

