import 'dart:async';

import 'package:damgerepoert/core/model/report_model.dart';
import 'package:damgerepoert/features/add_report/report_repository/report_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  static MapController get instance => Get.find();
  final reportRepository = Get.put(ReportRepository());
  Completer<GoogleMapController> controller = Completer();
  GoogleMapController? mapController;
  late LatLng initialPosition =
      const LatLng(31.900883058179527, 35.9346984671693);

  RxBool isLoading = true.obs;
  RxList<ReportModel> reports = <ReportModel>[].obs;
  RxSet<Marker> markers = <Marker>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // getCurrentLocation();
    getReport();
  }

  Future<void> getReport() async {
    isLoading.value = true;
    try {
      reports.value = await reportRepository.fetchReports();

      // Create markers for each report
      markers.value = reports
          .map((report) {
            final locationParts = report.reportLocation.split(',');
            if (locationParts.length == 2) {
              final latitude = double.tryParse(locationParts[0]);
              final longitude = double.tryParse(locationParts[1]);

              if (latitude != null && longitude != null) {
                return Marker(
                  markerId: MarkerId(report.id ?? report.reportName),
                  position: LatLng(latitude, longitude),
                  infoWindow: InfoWindow(
                    title: report.reportName,
                    snippet: report.reportDescription,
                  ),
                );
              }
            }
            return null;
          })
          .whereType<Marker>()
          .toSet();

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print(e);
    }
  }

  void goToPosition(Position position) async {
    print(position);

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 15),
      ),
    );
  }

  void goToPositionButton(lat, long) async {
    // print(latitude)
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, long), zoom: 16),
      ),
    );
  }

//   Future<void> getCurrentLocation() async {
//     LocationPermission permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       // Handle denied permission
//     } else if (permission == LocationPermission.deniedForever) {
//       // Handle permanently denied permission
//     } else {
//       try {
//         Position position = await Geolocator.getCurrentPosition();
//         initialPosition = LatLng(position.latitude, position.longitude);

//         goToPosition(position);

//         markers.clear(); // clear old marker and set new one
//         final marker = Marker(
//           markerId: const MarkerId('deliveryMarker'),
//           position: LatLng(position.latitude, position.longitude),
//           infoWindow: const InfoWindow(
//             title: '',
//           ),
//         );
//       } catch (e) {
//         print(e);
//       }
//     }
//   }
}
