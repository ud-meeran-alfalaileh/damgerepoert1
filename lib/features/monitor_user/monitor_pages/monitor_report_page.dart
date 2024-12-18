import 'package:damgerepoert/config/sizes/size_box_extension.dart';
import 'package:damgerepoert/config/sizes/sizes.dart';
import 'package:damgerepoert/config/theme/theme.dart';
import 'package:damgerepoert/core/model/report_model.dart';
import 'package:damgerepoert/core/widget/text.dart';
import 'package:damgerepoert/features/add_report/controller/report_conroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MonitorReportPage extends StatefulWidget {
  const MonitorReportPage({super.key});

  @override
  State<MonitorReportPage> createState() => _MonitorReportPageState();
}

class _MonitorReportPageState extends State<MonitorReportPage> {
  final controller = Get.put(ReportController());
  @override
  void initState() {
    controller.getReport();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [TextApp.mainAppText("Report")],
              ),
              10.0.kH,
              Obx(
                () => controller.isloading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: controller.reports.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return controller.reports[index].status == "pending"
                              ? SizedBox.shrink()
                              : 10.0.kH;
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return controller.reports[index].status == "pending"
                              ? SizedBox.shrink()
                              : _adminReportContainer(context, index);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _adminReportContainer(BuildContext context, int index) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
        width: context.screenWidth,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColor.mainAppColor.withOpacity(0.2))),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  controller.reports[index].reportImage,
                  width: context.screenWidth * .2,
                  height: context.screenHeight * .1,
                  fit: BoxFit.cover,
                ),
                10.0.kW,
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextApp.mainAppText(controller.reports[index].reportName),
                    TextApp.subAppText(controller.reports[index].userEmail),
                    TextApp.subAppText(
                        controller.reports[index].reportDescription),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.reports[index].status == 'reviewed'
                        ? null
                        : controller.updateReport(ReportModel(
                            id: controller.reports[index].id,
                            userEmail: controller.reports[index].userEmail,
                            reportName: controller.reports[index].reportName,
                            date: controller.reports[index].date,
                            reportImage: controller.reports[index].reportImage,
                            reportDescription:
                                controller.reports[index].reportDescription,
                            reportLocation:
                                controller.reports[index].reportLocation,
                            status: "reviewed"));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: controller.reports[index].status == 'reviewed'
                            ? AppColor.subappcolor
                            : AppColor.mainAppColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      controller.reports[index].status == 'reviewed'
                          ? "Done"
                          : "Reviewed",
                      style: TextStyle(
                          color: controller.reports[index].status == 'reviewed'
                              ? AppColor.mainAppColor
                              : AppColor.subappcolor),
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
