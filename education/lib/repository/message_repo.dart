import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/message_model.dart';

class MessageRepo extends GetxController {
  static MessageRepo get instance => Get.find();
  final _db = FirebaseFirestore.instance;

//get message
  Stream<List<MessageModel>> getMessage(String specialite) {
    return _db
        .collection(specialite)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> docSnapshot) {
      if (docSnapshot.docs.isNotEmpty) {
        return docSnapshot.docs
            .map((doc) => MessageModel.fromSnapshot(doc))
            .toList();
      } else {
        return [];
      }
    });
  }
}
