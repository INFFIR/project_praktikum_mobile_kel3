import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
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
  Get.put(BottomNavController());
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
                        controller.latitude.value = position.center.latitude;
                        controller.longitude.value = position.center.longitude;
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                      ),
                      // TileLayer(
                      //   urlTemplate: 'https://{s}.base.maps.api.here.com/maptile/2.1/maptile/newest/normal.day/{z}/{x}/{y}/256/png8?app_id=YOUR_APP_ID&app_code=YOUR_APP_CODE',
                      //   additionalOptions: {
                      //     'app_id': 'vpSt10YxGQc4ytFdju0F',
                      //     'app_code': 'eqsyvc_2P4sqLNV-ztXPVU4UizzrRb2xnLCZkMkfoCY',
                      //   },
                      // ), //intinya ini ga guna ga berfungsi aku gatau cara pakai api nya
                                          Positioned(
                      bottom: 16,
                      right: 16,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // FAB untuk "Get My Location"
                          FloatingActionButton(
                            heroTag: 'getLocation',
                            onPressed: () async {
                              await controller.getCurrentLocation();
                              _mapController.move(
                                LatLng(controller.latitude.value, controller.longitude.value),
                                17.0,
                              );
                            },
                            backgroundColor: Colors.grey[850],
                            child: const Icon(Icons.my_location, color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          // FAB untuk "Lokasi Toko"
                          FloatingActionButton(
                            heroTag: 'lokasiToko',
                            onPressed: () {
                              const tokoLat = -7.952904000198055;
                              const tokoLon = 112.63171099321725;
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

              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(), // Panggil BottomNavBar secara langsung
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
