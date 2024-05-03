import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/message_controller.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../theme/constants.dart';
import 'package:http/http.dart' as http;
const String backendUrl = 'http://192.168.92.166:9250/api/updateNotification';

class UpdateMessagePage extends StatefulWidget {
  final MessageModel message;
  final UserModel user;
  final String specialite;

  const UpdateMessagePage({
    super.key,
    required this.message,
    required this.user,
    required this.specialite,
  });

  @override
  State<UpdateMessagePage> createState() => _UpdateMessagePageState();
}

class _UpdateMessagePageState extends State<UpdateMessagePage> {
  late TextEditingController _titreController;
  late TextEditingController _descriptionController;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();




  File? _image;
  final picker = ImagePicker();
   Future getImageGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("no image picked");
      }
    });
  }

  

  Future<void> triggerNotification() async {
    try {
      final response = await http.get(

          Uri.parse(backendUrl)); // Requête pour déclencher la notification

      if (response.statusCode == 200) {
        print("Notification sent to all devices.");
      } else {
        print("Error sending notification: ${response.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }




  @override
  void initState() {
    super.initState();
    _titreController = TextEditingController(text: widget.message.title);
    _descriptionController =
        TextEditingController(text: widget.message.description);
  }

  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Center(
            child: SvgPicture.asset(
              "assets/images/logo_title_image.svg",
              height: 40,
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Update the message",
                            style: Theme.of(context).textTheme.headline3!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: InkWell(
                            onTap: getImageGallery,
                            child: Container(
                              height: 200,
                              width: 300,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: _image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        _image!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : widget.message.urlImg != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.network(
                                            widget.message.urlImg!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Center(
                                          child: Icon(Icons.add_photo_alternate_outlined, size: 30),
                                        ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _titreController,
                          decoration: InputDecoration(
                            hintText: "Title",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            // Set text size here
                            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            hintStyle: TextStyle(fontSize: 16), // Adjust the font size as needed
                          ),
                          style: Theme.of(context).textTheme.bodyText1, // Set text style here
                          validator: RequiredValidator(errorText: "Title is required"),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            hintText: "Description",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            // Set text size here
                            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            hintStyle: TextStyle(fontSize: 16), // Adjust the font size as needed
                          ),
                          maxLines: 4,
                          style: Theme.of(context).textTheme.bodyText1, // Set text style here
                          validator: RequiredValidator(errorText: "Description is required"),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: kBlueColor,
                      ),
                        onPressed: () {
                    if (formkey.currentState!.validate()) {
                      final updatedMessage = MessageModel(
                        idMsg: widget.message.idMsg,
                        title: _titreController.text.trim(),
                        description: _descriptionController.text.trim(),
                        urlImg:
                            _image != null ? _image!.path : widget.message.urlImg,
                      );

                      MessageController.instance.editMessageController(
                        widget.specialite,
                        updatedMessage,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Message updated successfully"),
                        ),
                      );

                      Navigator.pop(context); // Retour à la page précédente
                    }
                  },

                      child: Text(
                        "Update",
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: kWhiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
