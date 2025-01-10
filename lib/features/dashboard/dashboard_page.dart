import 'package:carousel_slider/carousel_slider.dart';
import 'package:damgerepoert/config/sizes/size_box_extension.dart';
import 'package:damgerepoert/config/sizes/sizes.dart';
import 'package:damgerepoert/config/theme/theme.dart';
import 'package:damgerepoert/core/model/report_model.dart';
import 'package:damgerepoert/core/widget/text.dart';
import 'package:damgerepoert/features/add_report/controller/report_conroller.dart';
import 'package:damgerepoert/features/add_report/view/view_report.dart';
import 'package:damgerepoert/features/admin/admin_controller/admin_advice_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final controller = Get.put(ReportController());
  final adviceController = Get.put(AdviceController());
  @override
  void initState() {
    controller.getReport();
    adviceController.getAdvices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.subappcolor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              50.0.kH,
              TextApp.mainAppText("Today Advices"),
              Obx(
                () => adviceController.advices.isEmpty
                    ? CircularProgressIndicator()
                    : CarouselSlider.builder(
                        itemCount: adviceController.advices.length,
                        itemBuilder: (context, index, realIndex) {
                          return Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        adviceController.advices[index].image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // Black overlay
                              Container(
                                color: Colors.black.withOpacity(0.6),
                              ),
                              // Text overlay
                              Center(
                                child: Text(
                                  adviceController.advices[index].title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: true, // Automatically slide
                          enlargeCenterPage:
                              true, // Zoom in on the active slide
                          viewportFraction: 0.7, // Size of the active slide
                          aspectRatio: 16 / 9, // Adjust the aspect ratio
                          initialPage: 0, // Start with the first page
                        ),
                      ),
              ),
              50.0.kH,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextApp.mainAppText("Reports"),
                  GestureDetector(
                    onTap: () {
                      Get.to(const ViewReport());
                    },
                    child: TextApp.subAppText("See More"),
                  )
                ],
              ),
              5.0.kH,
              Obx(
                () => controller.isloading.value
                    ? const CircularProgressIndicator()
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: 2,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return ReportContainer(
                              model: controller.reports[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportContainer extends StatelessWidget {
  const ReportContainer({
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
            // color: Colors.white,
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
              width: context.screenWidth * .55,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextApp.mainAppText(model.reportName),
                  TextApp.subAppText(model.userEmail),
                  TextApp.subAppText(model.reportDescription),
                ],
              ),
            )
          ],
        ));
  }
}
