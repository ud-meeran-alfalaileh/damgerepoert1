import 'package:damgerepoert/core/widget/text.dart';
import 'package:damgerepoert/features/add_report/controller/report_conroller.dart';
import 'package:damgerepoert/features/dashboard/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewReport extends StatelessWidget {
  const ViewReport({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReportController());

    return Scaffold(
      // backgroundColor: AppColor.subappcolor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextApp.mainAppText("Reports"),
              Obx(
                () => controller.isloading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: controller.reports.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          final latlng = controller
                              .reports[index].reportLocation
                              .split(',');
                          final lat = latlng[0];
                          final long = latlng[1];
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return _showMapContainer(
                                        context,
                                        double.parse(long),
                                        double.parse(lat),
                                        controller.reports[index].reportName);
                                  });
                            },
                            child: ReportContainer(
                                model: controller.reports[index]),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showMapContainer(BuildContext context, long, lat, String title) {
    // Initial position
    final LatLng initialLatLng = LatLng(lat, long);

    // Create a set of markers
    final Set<Marker> markers = {
      Marker(
        markerId: MarkerId(title),
        position: initialLatLng,
        infoWindow: InfoWindow(
          title: title,
          snippet: 'report Location',
        ),
      ),
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                )),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .6,
          child: Center(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(lat, long),
                zoom: 15.00,
              ),
              markers: markers, // Pass the markers set
            ),
          ),
        ),
      ],
    );
  }
}
