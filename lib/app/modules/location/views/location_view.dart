import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/components/bottom_navbar.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/location/controllers/location_controller.dart';

class LocationView extends GetView<LocationController> {
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final MapController _mapController = MapController();

  LocationView({super.key});

  @override
  Widget build(BuildContext context) {
    final RxInt currentIndex = 2.obs;

    // Listener untuk memindahkan peta saat lokasi berubah dan tracking aktif
    ever(controller.latitude, (_) {
      if (controller.isTracking.value) {
        _mapController.move(
          LatLng(controller.latitude.value, controller.longitude.value),
          17.0,
        );
      }
    });

    ever(controller.longitude, (_) {
      if (controller.isTracking.value) {
        _mapController.move(
          LatLng(controller.latitude.value, controller.longitude.value),
          17.0,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cari Lokasi Anda",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 45, 45, 45),
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
                        // Jika terjadi pergerakan pada peta dan tracking aktif, hentikan tracking
                        if (hasGesture && controller.isTracking.value) {
                          controller.stopTracking();
                        }
                        controller.latitude.value = position.center.latitude;
                        controller.longitude.value = position.center.longitude;
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // FAB untuk "Get My Location" dengan toggle
                            Obx(() => FloatingActionButton(
                                  heroTag: 'getLocation',
                                  onPressed: () {
                                    if (controller.isTracking.value) {
                                      controller.stopTracking();
                                    } else {
                                      controller.startTracking();
                                    }
                                  },
                                  backgroundColor: controller.isTracking.value
                                      ? Colors.blue
                                      : Colors.grey[850],
                                  child: Icon(
                                    controller.isTracking.value
                                        ? Icons.stop
                                        : Icons.my_location,
                                    color: Colors.white,
                                  ),
                                )),
                            const SizedBox(height: 16),
                            // FAB untuk "Lokasi Toko"
                            FloatingActionButton(
                              heroTag: 'lokasiToko',
                              onPressed: () {
                                const tokoLat = -7.952904000198055;
                                const tokoLon = 112.63171099321725;
                                controller.searchLocation(tokoLat, tokoLon);
                                _mapController.move(LatLng(tokoLat, tokoLon), 17.0);
                              },
                              backgroundColor: Colors.grey[850],
                              child: const Icon(Icons.store, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() => Text(
                      "Lokasi Saat ini: Lintang ${controller.latitude}, Bujur ${controller.longitude}",
                      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    )),
                const SizedBox(height: 16),
                // Menampilkan TextField dan tombol search secara horizontal dengan jarak yang seimbang
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildSmoothTextField(
                        controller: latitudeController,
                        label: "Lintang",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSmoothTextField(
                        controller: longitudeController,
                        label: "Bujur",
                      ),
                    ),
                    const SizedBox(width: 16), // Jarak pemisah yang sama seperti Lintang dan Bujur
                    Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.grey[850], // Latar belakang tombol
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          final lat = double.tryParse(latitudeController.text) ?? 0.0;
                          final lon = double.tryParse(longitudeController.text) ?? 0.0;
                          controller.searchLocation(lat, lon);
                          _mapController.move(LatLng(lat, lon), 17.0);
                        },
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        iconSize: 30,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                _buildSmoothButton(
                  label: "Open in Google Maps",
                  onPressed: controller.openGoogleMaps,
                ),
            _buildSmoothButton(
              label: "Navigate to Store",
              onPressed: () {
                // Ganti dengan koordinat toko
                double storeLat = -7.95304;
                double storeLon = 112.63167;
                controller.navigateToStore(storeLat, storeLon);
              },
              ),
              const SizedBox(height: 16),
            _buildSmoothButton(
              label: "Start Real-Time Location Tracking",
              onPressed: controller.startLocationTracking,
            ),
            const SizedBox(height: 16),
            _buildSmoothButton(
              label: "Stop Real-Time Location Tracking",
              onPressed: controller.stopLocationTracking,
            ),
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
    return SizedBox(
      height: 35, // Terapkan height jika diberikan
      child: TextField(
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
      ),
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

