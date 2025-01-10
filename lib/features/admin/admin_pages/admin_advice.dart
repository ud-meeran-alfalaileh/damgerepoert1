import 'package:damgerepoert/config/sizes/size_box_extension.dart';
import 'package:damgerepoert/config/sizes/sizes.dart';
import 'package:damgerepoert/core/widget/text.dart';
import 'package:damgerepoert/features/admin/admin_controller/admin_advice_controller.dart';
import 'package:damgerepoert/features/admin/admin_pages/admin_add_advice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminAdvice extends StatefulWidget {
  const AdminAdvice({super.key});

  @override
  State<AdminAdvice> createState() => _AdminAdviceState();
}

class _AdminAdviceState extends State<AdminAdvice> {
  final controller = Get.put(AdviceController());

  @override
  void initState() {
    controller.getAdvices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.to(const AdminAddAdvice());
                      },
                      icon: const Icon(Icons.add),
                    )
                  ],
                ),
                TextApp.mainAppText('Advices'),
                Obx(
                  () => controller.isloading.value
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.advices.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return 10.0.kH;
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  controller.advices[index].image,
                                  width: context.screenWidth * .5,
                                ),
                                10.0.kW,
                                SizedBox(
                                  width: context.screenWidth * .35,
                                  child: Column(
                                    children: [
                                      TextApp.adviceText(
                                          "Advice: ${controller.advices[index].title}"),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              controller.deleteAdvice(
                                                  controller.advices[index].id);
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
