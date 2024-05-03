import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../controllers/message_controller.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../theme/constants.dart';
import 'package:http/http.dart' as http;

const String backendUrl = 'http://192.168.92.166:9250/api/sendNotification';


class AddMessagePage extends StatefulWidget {
  const AddMessagePage(
      {super.key, required this.usr, required this.specialite});
  final UserModel? usr;
  final String? specialite;

  @override
  State<AddMessagePage> createState() => _AddMessagePageState();
}

class _AddMessagePageState extends State<AddMessagePage> {
  TextEditingController _titreController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

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


  bool _isChecked = false;
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

  final controller = Get.put(MessageController());
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
        body: Container(
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
                            "Add a new message",
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 10),

                        Center(
                          child: InkWell(
                            onTap: () {
                              getImageGallery();
                            },
                            child: Container(
                              height: 200,
                              width: 300,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: _image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        _image!.absolute,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Center(
                                      child: Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 30),
                                    ),
                            ),
                          ),
                        ),
                        //
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _titreController,
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: "Title",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          style:
                              Theme.of(context).inputDecorationTheme.labelStyle,
                          validator: MultiValidator(
                            [
                              RequiredValidator(errorText: "*Required"),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "Description",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          style:
                              Theme.of(context).inputDecorationTheme.labelStyle,
                          validator: MultiValidator(
                            [
                              RequiredValidator(errorText: "*Required"),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _isChecked,
                              onChanged: (newValue) {
                                setState(() {
                                  _isChecked = newValue!;
                                });
                              },
                            ),
                            Text(
                              "Important",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
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
                      onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          final msg = MessageModel(
                            title: _titreController.text.trim(),
                            description: _descriptionController.text.trim(),
                            nomProf: widget.usr!.fullName,
                            checkImportant: _isChecked,
                          );
                          await controller.createMsgController(
                              msg, widget.specialite!, _image!.path);
                          Navigator.pop(context);
                          await triggerNotification();

                        }
                      },
                      child: Text(
                        "Send",
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
