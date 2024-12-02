import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../components/bottom_navbar.dart';
import '../controllers/location_controller.dart';

class LocationView extends GetView<LocationController> {
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final MapController _mapController = MapController();

  LocationView({super.key});

  @override
  Widget build(BuildContext context) {
    final RxInt currentIndex = 2.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cari Lokasi Anda",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 45, 45, 45),
        actions: [
          // Tombol untuk menonaktifkan/aktifkan realtime detection
          IconButton(
            icon: Obx(() => Icon(
              controller.isRealtimeDetectionEnabled.value
                  ? Icons.location_off
                  : Icons.location_on,
              color: Colors.white,
            )),
            onPressed: () {
              controller.toggleRealtimeDetection();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black),
                  ),
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      onPositionChanged: (position, hasGesture) {
                        controller.latitude.value = position.center.latitude;
                        controller.longitude.value = position.center.longitude;
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                      ),
                      TileLayer(
                        urlTemplate: 'https://{s}.base.maps.api.here.com/maptile/2.1/maptile/newest/normal.day/{z}/{x}/{y}/256/png8?app_id=YOUR_APP_ID&app_code=YOUR_APP_CODE',
                        additionalOptions: {
                          'app_id': 'vpSt10YxGQc4ytFdju0F',
                          'app_code': 'eqsyvc_2P4sqLNV-ztXPVU4UizzrRb2xnLCZkMkfoCY',
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildSmoothTextField(
                  controller: latitudeController,
                  label: "Lintang",
                ),
                const SizedBox(height: 16),
                _buildSmoothTextField(
                  controller: longitudeController,
                  label: "Bujur",
                ),
                const SizedBox(height: 16),
                _buildSmoothButton(
                  label: "Search Location",
                  onPressed: () {
                    final lat = double.tryParse(latitudeController.text) ?? 0.0;
                    final lon = double.tryParse(longitudeController.text) ?? 0.0;
                    controller.searchLocation(lat, lon);
                    _mapController.move(LatLng(lat, lon), 13.0);
                  },
                ),
                const SizedBox(height: 16),
                _buildSmoothButton(
                  label: "Open in Google Maps",
                  onPressed: controller.openGoogleMaps,
                ),
                const SizedBox(height: 16),
                Obx(() => Text(
                  "Lokasi Saat ini: Lintang ${controller.latitude}, Bujur ${controller.longitude}",
                  style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                )),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavBar(
          currentIndex: currentIndex.value,
          onTap: (index) {
            currentIndex.value = index;
          },
        ),
      ),
    );
  }

  Widget _buildSmoothTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[800],
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildSmoothButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[850],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 4,
        shadowColor: Colors.black,
      ).merge(
        ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.grey[700]),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
