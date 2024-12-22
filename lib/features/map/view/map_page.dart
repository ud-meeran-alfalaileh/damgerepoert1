import 'package:damgerepoert/config/sizes/size_box_extension.dart';
import 'package:damgerepoert/config/sizes/sizes.dart';
import 'package:damgerepoert/config/theme/theme.dart';
import 'package:damgerepoert/core/model/report_model.dart';
import 'package:damgerepoert/core/widget/text.dart';
import 'package:damgerepoert/features/map/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final controller = Get.put(MapController());
  @override
  void initState() {
    super.initState();
  }

  Future<void> getData() async {
    // await controller.getCurrentLocation();
    await controller.getReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports Map'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SizedBox(
          height: context.screenHeight,
          width: context.screenWidth,
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(37.4219983, -122.084), // Default location
                  zoom: 10,
                ),
                markers: controller.markers.value,
                onMapCreated: (GoogleMapController mapController) {
                  controller.mapController = mapController;
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: context.screenHeight * .15,
                  padding: const EdgeInsets.only(bottom: 40, left: 10),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.reports.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return 20.0.kW;
                    },
                    itemBuilder: (BuildContext context, int index) {
                      final location =
                          controller.reports[index].reportLocation.split(',');
                      final lat = location[0];
                      final long = location[1];

                      return GestureDetector(
                        onTap: () {
                          controller.goToPositionButton(
                              double.parse(lat), double.parse(long));
                        },
                        child: SizedBox(
                          width: context.screenWidth * .8,
                          child: ReportMapContainer(
                            model: controller.reports[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}

class ReportMapContainer extends StatelessWidget {
  const ReportMapContainer({
    super.key,
    required this.model,
  });

  final ReportModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
        width: context.screenWidth,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColor.mainAppColor.withOpacity(0.2))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              model.reportImage,
              width: context.screenWidth * .2,
              height: context.screenHeight * .1,
              fit: BoxFit.cover,
            ),
            10.0.kW,
            SizedBox(
              width: context.screenWidth * .4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextApp.mainAppText(model.reportName),
                  TextApp.subAppText(model.userEmail),
                  TextApp.subAppText(detailsShortText(model.reportDescription)),
                ],
              ),
            )
          ],
        ));
  }
}

String detailsShortText(String text, {int maxLength = 24}) {
  if (text.length <= maxLength) {
    return text;
  } else {
    return "${text.substring(0, maxLength)}..";
  }
}
