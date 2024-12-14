import 'dart:io';
import 'package:damgerepoert/core/backend/authentication.dart';
import 'package:damgerepoert/features/add_report/controller/report_conroller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:damgerepoert/core/model/report_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  String? _uploadedImageUrl;
  final _authRepo = Get.put(AuthenticationRepository());
  late final email = _authRepo.firebaseUser.value?.email;
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {
      Get.snackbar("No Image Selected", "Please select an image.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> _uploadImageToFirebase() async {
    if (_selectedImage == null) return;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('reports/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = await storageRef.putFile(_selectedImage!);
      _uploadedImageUrl = await uploadTask.ref.getDownloadURL();
      Get.snackbar("Success", "Image uploaded successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to upload image: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> _uploadImageToSupabase() async {
    if (_selectedImage == null) return; // Ensure an image is selected

    try {
      // Reference to Supabase Storage
      final storage = Supabase.instance.client.storage
          .from('Gens'); // 'reports' is your bucket name

      // Create a unique filename for the image
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload the file to Supabase Storage
      final response = await storage.upload(
        fileName, // The file name for the upload
        _selectedImage!, // File object to be uploaded
        fileOptions: const FileOptions(
          // Optional: Define file options
          cacheControl: '3600', // Cache control
          upsert: true, // Overwrite file if it exists
        ),
      );

      // Check for errors during upload
      if (response != null) {
        throw response;
      }

      // Get the public URL of the uploaded file
      final publicUrl = storage.getPublicUrl(fileName);

      // Assign the URL to your uploaded image variable
      _uploadedImageUrl = publicUrl;

      // Show success message
      Get.snackbar(
        "Success",
        "Image uploaded successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // Show error message
      print(e);
      Get.snackbar(
        "Error",
        "Failed to upload image: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _controller.userEmail,
                  decoration: const InputDecoration(labelText: "User Email"),
                  validator: _controller.validateEmail,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _controller.reportName,
                  decoration: const InputDecoration(labelText: "Report Name"),
                  validator: _controller.validateReportName,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _controller.reportDate,
                  decoration: const InputDecoration(
                    labelText: "Report Date",
                    hintText: "YYYY-MM-DD",
                  ),
                  validator: _controller.validateReportDate,
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 10),
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
                    await _uploadImageToSupabase();

                    if (_uploadedImageUrl != null) {
                      final report = ReportModel(
                        userEmail: email ?? "none",
                        reportName: _controller.reportName.text,
                        date: _controller.reportDate.text,
                        reportImage: _uploadedImageUrl!,
                      );

                      await _controller.createReport(report);
                    }
                  },
                  child: const Text("Submit Report"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
