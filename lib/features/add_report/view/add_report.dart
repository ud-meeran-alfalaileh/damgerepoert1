import 'dart:io';

import 'package:damgerepoert/config/sizes/sizes.dart';
import 'package:damgerepoert/config/theme/theme.dart';
import 'package:damgerepoert/core/backend/authentication.dart';
import 'package:damgerepoert/core/model/report_model.dart';
import 'package:damgerepoert/core/widget/text.dart';
import 'package:damgerepoert/features/add_report/controller/report_conroller.dart';
import 'package:damgerepoert/features/add_report/view/add_location_widget.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/src/media_type.dart';
import 'package:image_picker/image_picker.dart';

class ReportSubmissionForm extends StatefulWidget {
  const ReportSubmissionForm({super.key});

  @override
  State<ReportSubmissionForm> createState() => _ReportSubmissionFormState();
}

class _ReportSubmissionFormState extends State<ReportSubmissionForm> {
  final reportController = Get.put(ReportController());
  final _controller = ReportController.instance;
  final _picker = ImagePicker();
  File? _selectedImage;
  RxBool isLoading = false.obs;
  String? _uploadedImageUrl;
  final _authRepo = Get.put(AuthenticationRepository());
  late final email = _authRepo.firebaseUser.value?.email;
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      await uploadMedia(pickedFile.path);
    } else {
      Get.snackbar("No Image Selected", "Please select an image.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> uploadMedia(String file) async {
    isLoading.value = true;

    dio.Dio dioInstance = dio.Dio();
    dio.FormData formData = dio.FormData.fromMap({
      'file': await dio.MultipartFile.fromFile(
        file,
        contentType: MediaType('image', 'jpeg'),
      ),
    });

    try {
      final response = await dioInstance.post(
        "https://gts-b8dycqbsc6fqd6hg.uaenorth-01.azurewebsites.net/api/ImageUpload/upload",
        data: formData,
        options: dio.Options(
          headers: {
            "Accept": 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      print(response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false;
        final jsonData = response.data;
        final fileName = jsonData['path'];
        print(fileName);
        setState(() {
          _uploadedImageUrl = fileName;
        });
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;

      print("meeran $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _controller.formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextApp.mainAppText("Add Report"),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _controller.reportName,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColor.mainAppColor,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          border: const OutlineInputBorder(),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  // color: AppTheme.lightAppColors.black.withOpacity(.2),
                                  ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          labelText: "Report Name",
                          hintStyle: const TextStyle(
                              fontFamily: "Alexandria",
                              fontWeight: FontWeight.w500,
                              // color: AppTheme.lightAppColors.black.withOpacity(.5),
                              fontSize: 14),
                        ),
                        validator: _controller.validateReportName,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _controller.reportDescription,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColor.mainAppColor,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          border: const OutlineInputBorder(),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  // color: AppTheme.lightAppColors.black.withOpacity(.2),
                                  ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          labelText: "Report Description",
                          hintStyle: const TextStyle(
                              fontFamily: "Alexandria",
                              fontWeight: FontWeight.w500,
                              // color: AppTheme.lightAppColors.black.withOpacity(.5),
                              fontSize: 14),
                        ),
                        validator: _controller.validateReportDescription,
                      ),
                      const SizedBox(height: 20),
                      Stack(
                        children: [
                          TextFormField(
                            controller: _controller.reportDate,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColor.mainAppColor,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                              border: const OutlineInputBorder(),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      // color: AppTheme.lightAppColors.black.withOpacity(.2),
                                      ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              labelText: "Report Date",
                              hintText: "YYYY-MM-DD",
                              enabled: false,
                              hintStyle: const TextStyle(
                                fontFamily: "Alexandria",
                                  fontWeight: FontWeight.w500,
                                  // color: AppTheme.lightAppColors.black.withOpacity(.5),
                                  fontSize: 14),
                            ),
                            validator: _controller.validateReportDate,
                            keyboardType: TextInputType.datetime,
                          ),
                          GestureDetector(
                            onTap: () {
                              reportkDateWidget(
                                  context, _controller.reportDate);
                            },
                            child: Container(
                              width: context.screenWidth,
                              height: context.screenHeight * .1,
                              color: Colors.transparent,
                            ),
                          )
                        ],
                      ),
                      // const SizedBox(height: 20),
                      Stack(
                        children: [
                          TextFormField(
                            onTap: () {
                              reportController.showMap.value = true;
                            },
                            controller: _controller.location,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColor.mainAppColor,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                              border: const OutlineInputBorder(),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      // color: AppTheme.lightAppColors.black.withOpacity(.2),
                                      ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              labelText: "Location",
                              enabled: false,
                              hintStyle: const TextStyle(
                                  fontFamily: "Alexandria",
                                  fontWeight: FontWeight.w500,
                                  // color: AppTheme.lightAppColors.black.withOpacity(.5),
                                  fontSize: 14),
                            ),
                            // decoration: const InputDecoration(
                            //   labelText: "Location",
                            //   enabled: false,
                            //   hintText: "YYYY-MM-DD",
                            // ),
                            validator: _controller.validateReportLocation,
                            keyboardType: TextInputType.datetime,
                          ),
                          GestureDetector(
                            onTap: () {
                              reportController.showMap.value = true;
                            },
                            child: Container(
                              width: context.screenWidth,
                              height: context.screenHeight * .1,
                              color: Colors.transparent,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _selectedImage != null
                              ? Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                )
                              : const Center(
                                  child: Text("Tap to select an image"),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_controller.formKey.currentState!.validate()) {
                            if (_uploadedImageUrl != null) {
                              isLoading.value = true;
                              final report = ReportModel(
                                userEmail: email ?? "none",
                                reportName: _controller.reportName.text,
                                date: _controller.reportDate.text,
                                reportImage: _uploadedImageUrl!,
                                reportDescription:
                                    reportController.reportDescription.text,
                                reportLocation: reportController.location.text,
                                status: 'pending',
                              );

                              await _controller.createReport(report);
                              isLoading.value = false;
                            } else if (_uploadedImageUrl == null) {
                              Get.snackbar(
                                "Error",
                                'Select an image',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          }
                        },
                        child: const Text("Submit Report"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Obx(() => reportController.showMap.value == false
                ? const SizedBox.shrink()
                : const AddLocation()),
            Obx(() => isLoading.value
                ? Container(
                    width: context.screenWidth,
                    height: context.screenHeight,
                    color: const Color(0xff000000).withOpacity(0.2),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : const SizedBox.shrink())
          ],
        ),
      ),
    );
  }
}

Future<void> reportkDateWidget(
    BuildContext context, TextEditingController text) async {
  DateTime? newDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
          // Customizing the color of the DatePicker
          datePickerTheme: DatePickerThemeData(
            backgroundColor: Colors.white,
            headerBackgroundColor: AppColor.mainAppColor,
            headerForegroundColor: Colors.white,
            dayForegroundColor: MaterialStateColor.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.white; // Selected day color
              }
              return Colors.black; // Default day color
            }),
            dayBackgroundColor: MaterialStateColor.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return AppColor.mainAppColor; // Background for selected day
              }
              return Colors.white; // Default background
            }),
            yearForegroundColor: MaterialStateColor.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.white; // Selected year color
              }
              return Colors.black; // Default year color
            }),
          ),
        ),
        child: child!,
      );
    },
  );

  if (newDate != null) {
    text.text =
        "${newDate.year}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}";
    // Display the selected date in YYYY-MM-DD format
  }
}
