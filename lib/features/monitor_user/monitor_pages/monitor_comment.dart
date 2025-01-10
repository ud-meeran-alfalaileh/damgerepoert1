import 'package:damgerepoert/config/sizes/size_box_extension.dart';
import 'package:damgerepoert/config/sizes/sizes.dart';
import 'package:damgerepoert/config/theme/theme.dart';
import 'package:damgerepoert/core/model/comment_model.dart';
import 'package:damgerepoert/core/model/form_model.dart';
import 'package:damgerepoert/core/model/report_model.dart';
import 'package:damgerepoert/core/widget/buttons.dart';
import 'package:damgerepoert/core/widget/form_model.dart';
import 'package:damgerepoert/core/widget/text.dart';
import 'package:damgerepoert/features/add_report/controller/comment_controller.dart';
import 'package:damgerepoert/features/add_report/report_repository/comment_repositry.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class MonitorCommentPage extends StatefulWidget {
  const MonitorCommentPage( this.reportModel,{super.key} );
 final ReportModel reportModel;
  @override
  State<MonitorCommentPage> createState() => _MonitorCommentPageState();
}

class _MonitorCommentPageState extends State<MonitorCommentPage> {

  @override
  Widget build(BuildContext context) {
    final  controller = Get.put(CommentController());
    return SafeArea(child: Scaffold(
        appBar:AppBar(
          leading: IconButton(onPressed: Get.back, icon: const Icon(Icons.arrow_back_ios_new_outlined)),
          title: TextApp.appBarText("Repoert comments"),
        ),

body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
  child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
    children: [
  Container(
  //        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
          width: context.screenWidth,
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColor.mainAppColor.withOpacity(0.2))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
            widget.reportModel. reportImage,
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
                    TextApp.mainAppText(widget.reportModel.reportName),
                    TextApp.subAppText(widget.reportModel.userEmail),
                    TextApp.subAppText(widget.reportModel.reportDescription),
                  ],
                ),
              )
            ],
          )),
  const Gap(20),
  FormWidget(textForm:FormModel(controller: controller.comment, enableText: false, 
  hintText: "Add your comment ", icon:const  Icon(Icons.comment),
   invisible: false, validator: (comment)=>controller.vaildateComment(comment),
    type: TextInputType.text, onChange: null, inputFormat: null, onTap: null)),
    Gap(20),
  Buttons.formscontainer(title: "Add comment", onTap:()=> {CommenttRepository().createComment(CommentModel(userEmail: widget.reportModel.userEmail, 
  reportName: widget.reportModel.reportName, date: widget.reportModel.date,
   reportImage: widget.reportModel.reportImage,
  reportDescription: widget.reportModel.reportDescription,
   reportLocation: widget.reportModel.reportLocation, 
   status: widget.reportModel.status, comment: controller.comment.text)),})

  ,

Gap(10),

  
  ],),
),

    ));
  }
}