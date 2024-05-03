import 'package:get/get.dart';

import '../models/message_model.dart';
import '../repository/message_repo.dart';

class MessageController extends GetxController {
  static MessageController get instance => Get.find();
  final _messageRepo = Get.put(MessageRepo());
  createMsgController(MessageModel msg, String specialite, String urlImg) {
    _messageRepo.createMsg(msg, specialite, urlImg);
  }

  Stream<List<dynamic>> getMessageController(String specialite) {
    return _messageRepo.getMessage(specialite);
  }

 Future<void> deleteMessage(String specialite, String? messageId) async {
    try {
      await _messageRepo.deleteMessage(specialite, messageId);
    } catch (error) {
      // Handle error
      print('Error deleting message: $error');
    }
  }
   
  //   updateMsgController(MessageModel msg, String specialite, String urlImg) {
  //   try {
  //     _messageRepo.updateMsg(msg, specialite, urlImg);
  //     // If the update is successful, show a success message
  //     Get.snackbar('Success', 'Message updated successfully');
  //   } catch (error) {
  //     // If an error occurs during update, show an error message
  //     print('Failed to update message: $error');
  //     Get.snackbar('Error', 'Failed to update message');
  //   }
  // }

  editMessageController(String specialite, MessageModel updatedMsg) {
    try {
      _messageRepo.editMessage(specialite, updatedMsg);
    } catch (error) {
      print("Erreur lors de la mise à jour du message : $error");
    }
  }

}
