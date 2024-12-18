import 'package:cloud_firestore/cloud_firestore.dart';

class AdviceModel {
  String? id;
  String title;
  String image;
  AdviceModel({
     this.id,
    required this.title,
    required this.image,
  });

  tojason() {
    return {
      "title": title,
      "image": image,
    };
  }

  factory AdviceModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data()!;
    return AdviceModel(
      id: documentSnapshot.id,
      title: data["title"],
      image: data["image"],
    );
  }
}
