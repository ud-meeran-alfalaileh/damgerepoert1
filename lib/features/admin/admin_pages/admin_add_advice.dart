import 'dart:io';

import 'package:damgerepoert/config/sizes/size_box_extension.dart';
import 'package:damgerepoert/core/backend/authentication.dart';
import 'package:damgerepoert/features/admin/admin_controller/admin_advice_controller.dart';
import 'package:damgerepoert/features/admin/admin_model.dart/advice_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/src/media_type.dart';
import 'package:image_picker/image_picker.dart';

class AdminAddAdvice extends StatefulWidget {
  const AdminAddAdvice({super.key});

  @override
  State<AdminAddAdvice> createState() => _AdminAddAdviceState();
}

class _AdminAddAdviceState extends State<AdminAddAdvice> {
  final controller = Get.put(AdviceController());
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
        final jsonData = response.data;
        final fileName = jsonData['path'];
        print(fileName);
        setState(() {
          _uploadedImageUrl = fileName;
        });
      } else {}
    } catch (e) {
      print("meeran $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: controller.title,
                  decoration: const InputDecoration(labelText: "Advice"),
                  validator: controller.validateAdvicetName,
                ),
                20.0.kH,
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
                ElevatedButton(
                  onPressed: () async {
                    if (_uploadedImageUrl != null) {
                      isLoading.value = true;
                      final advice = AdviceModel(
                        title: controller.title.text,
                        image: _uploadedImageUrl!,
                      );

                      await controller.createAdvice(advice);
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
