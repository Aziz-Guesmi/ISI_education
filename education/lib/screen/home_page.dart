import 'package:education/screen/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import '../theme/constants.dart';
import 'components/speciality_component.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.usr});
  final UserModel usr;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> specialite = [
    '1ING',
    '2ING',
    '3ING',
    '1IDL1',
    '1IDL2',
    '2IDL1',
    '2IDL2',
    'Lce1',
    'Lce2',
    'MDL',
    'SSII',
    'SIIOT',
  ];
  final controller = Get.put(AuthController());
  String? selectedSpecialite = '1ING';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        actions: [
            IconButton(
              onPressed: () async {
                controller.logout().then(
                      (value) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInPage(),
                        ),
                      ),
                    );
              },
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ),
            ),
          ],
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Specialties",
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (content) {
                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                              title: Text("Select the specialty to add"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DropdownButton<String>(
                                    value: selectedSpecialite,
                                    items: specialite
                                        .map(
                                          (item) => DropdownMenuItem<String>(
                                              value: item, child: Text(item)),
                                        )
                                        .toList(),
                                    onChanged: (item) => setState(() {
                                      selectedSpecialite = item;
                                    }),
                                  ),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (selectedSpecialite != null) {
                                      await controller
                                          .addSpecialiteToListController(
                                              widget.usr.id.toString(),
                                              selectedSpecialite.toString());
                                    }
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          });
                        });
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kBlueColor,
                    ),
                    child: Icon(
                      Icons.add,
                      color: kWhiteColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<dynamic>>(
                  stream: controller.getListSpecilityController(widget.usr.id!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return Text('No data available');
                    } else {
                      List<dynamic> listData = snapshot.data!;
                       return ListView.builder(
                        itemCount: listData.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.horizontal,
                            onDismissed: (direction) {
                              final String userId = widget.usr.id.toString();
                              final String speciality = listData[index]; // Assuming listData contains specialties as Strings
                              AuthController.instance.deleteSpecialiteController(userId, speciality);
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.delete),
                            ),
                            child: SpecialityComponent(
                              specialite: listData[index],
                              usr: widget.usr,
                            ),
                          );
                        },
                      );
                    }
                  }),
            )
          ],
        ),
      ),
    ));
  }
}
