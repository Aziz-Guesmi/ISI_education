import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import '../models/message_model.dart';

class MessageRepo extends GetxController {
  static MessageRepo get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  // create msg
    createMsg(MessageModel msg, String specialite, String urlImg) async {
      String msgUrl;
      try {
        String fileName = DateTime.now().microsecondsSinceEpoch.toString();
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImages = referenceRoot.child('imagesMessage');
        Reference referenceImageUpload =
            referenceDirImages.child(fileName + ".png");
        await referenceImageUpload.putFile(File(urlImg));
        msgUrl = await referenceImageUpload.getDownloadURL();
        final docMsg = _db.collection(specialite).doc();
        msg = msg.setIdandUrlMsg(docMsg.id, msgUrl);
        await docMsg.set(msg.toJson());
      } catch (error) {
        print(error);
      }
    }

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


  

  Future<void> deleteMessage(String specialite, String? messageId) async {
    try {
      await _db.collection(specialite).doc(messageId).delete();
    } catch (error) {
      print('Error deleting message: $error');
      rethrow;
    }
  }



  Future<void> editMessage(String specialite, MessageModel updatedMsg) async {
    try {
      //Todo : image update ne9sa
      await _db
          .collection(specialite)
          .doc(updatedMsg.idMsg)
          .update(updatedMsg.toJson());
    } catch (error) {
      print("Erreur lors de la mise à jour du message : $error");
    }
  }

}
