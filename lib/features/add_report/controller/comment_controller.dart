import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentController extends GetxController {
    static CommentController get instance => Get.find();
final TextEditingController comment = TextEditingController();


 vaildateComment(String? comment) {
    if (GetUtils.isUsername(comment!)) {
      return null;
    }
    return 'UserName is not vaild';
  }

}