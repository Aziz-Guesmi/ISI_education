import 'package:educationadmin/screen/add_message_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/message_controller.dart';
import '../models/user_model.dart';
import '../theme/constants.dart';
import 'components/message_component.dart';

class AllMessagePage extends StatefulWidget {
  const AllMessagePage(
      {super.key, required this.usr, required this.specialite});
  final UserModel usr;
  final String specialite;

  @override
  State<AllMessagePage> createState() => _AllMessagePageState();
}

class _AllMessagePageState extends State<AllMessagePage> {
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.headline4!,
                      children: <TextSpan>[
                        TextSpan(
                          text: "Messages from specialty : ",
                          style: TextStyle(),
                        ),
                        TextSpan(
                          text: widget.specialite,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kBlueColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddMessagePage(
                              usr: widget.usr, specialite: widget.specialite),
                        ),
                      );
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
                    stream: controller.getMessageController(widget.specialite),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return Text('No data available');
                      } else {
                        return GridView.builder(
                            itemCount: snapshot.data!.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1),
                            itemBuilder: (context, index) {
                              return MessageComponent(
                                msg: snapshot.data![index],
                                user : widget.usr,
                                spec : widget.specialite,
                              );
                            });
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
