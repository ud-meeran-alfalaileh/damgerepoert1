import 'package:damgerepoert/config/sizes/size_box_extension.dart';
import 'package:damgerepoert/config/sizes/sizes.dart';
import 'package:damgerepoert/config/theme/theme.dart';
import 'package:damgerepoert/features/add_report/controller/add_location_controller.dart';
import 'package:damgerepoert/features/add_report/controller/report_conroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddLocation extends StatelessWidget {
  const AddLocation({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final LocationController controller = Get.put(LocationController());
    final reportController = Get.put(ReportController());

    return Container(
      width: context.screenWidth,
      height: context.screenHeight,
      color: const Color(0xff000000).withOpacity(0.2),
      child: Center(
        child: Container(
          color: const Color(0xffffffff),
          // width: context.screenWidth * .9,
          height: context.screenHeight * .5,
          constraints: BoxConstraints(minHeight: context.screenHeight * .7),
          child: SafeArea(
            child: Column(
              // mainAxisAlignment: ,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          reportController.showMap.value = false;
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                        ))
                  ],
                ),
                _buildMapContainer(context, controller),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      30.0.kH,
                      GestureDetector(
                          onTap: () async {
                            reportController.location.text =
                                "${controller.latitude.value},${controller.longitude.value}";

                            reportController.showMap.value = false;
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xff799c74),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "Add Location",
                                      style: TextStyle(
                                          color: AppColor.subappcolor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stack _buildMapContainer(
      BuildContext context, LocationController controller) {
    return Stack(
      children: [
        Container(
            width: context.screenWidth,
            height: context.screenHeight * .45,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black.withOpacity(0.3))),
            child: googleMapWidget(controller)),
        Positioned(
          left: 10,
          top: 10,
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: IconButton(
                onPressed: () => controller.handleSearch(context),
                icon: Icon(
                  Icons.search,
                  color: AppColor.mainAppColor,
                )),
          ),
        ),
        Positioned(
          right: 10,
          bottom: 10,
          child: Container(
            decoration: const BoxDecoration(
                color: Color(0x00ffffff), shape: BoxShape.circle),
            child: IconButton(
                onPressed: () => controller.getCurrentLocation(),
                icon: const Icon(
                  Icons.location_on_rounded,
                  color: Color(0xff000000),
                )),
          ),
        )
      ],
    );
  }
}

Obx googleMapWidget(LocationController controller) {
  return Obx(
    () => GoogleMap(
      myLocationButtonEnabled: false,
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: controller.initialPosition,
        zoom: 11.151926040649414,
      ),
      markers: controller.markers.values.toSet(),
      onTap: (LatLng latlng) {
        controller.latitude.value = latlng.latitude;
        controller.longitude.value = latlng.longitude;
        final marker = Marker(
          markerId: const MarkerId('myLocation'),
          position:
              LatLng(controller.latitude.value, controller.longitude.value),
          infoWindow: const InfoWindow(
            title: '',
          ),
        );
        controller.markers['myLocation'] = marker;
      },
      onMapCreated: (GoogleMapController mapController) {
        controller.mapController = mapController;
      },
    ),
  );
}
