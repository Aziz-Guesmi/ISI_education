import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/message_model.dart';
import '../../theme/constants.dart';
import '../message_page.dart';
import '../../controllers/message_controller.dart';

class MessageComponent extends StatelessWidget {
  const MessageComponent({Key? key, required this.msg}) : super(key: key);
  final MessageModel? msg;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MessagePage(msg: msg)),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.withOpacity(0.2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 150, // Fixed width for the image
              height: 300,
              child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Image.network(
                  msg!.urlImg.toString(),
                  fit: BoxFit.cover,
                  height: double.infinity,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: RichText(
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.headline6!,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Title : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kBlueColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: msg!.title.toString(),
                                      style: TextStyle(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: RichText(
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Prof : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kBlueColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: msg!.nomProf.toString(),
                                      style: TextStyle(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: RichText(
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Description : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kBlueColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: msg!.description.toString(),
                                      style: TextStyle(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  msg!.checkImportant == true
                      ? RichText(
                          text: TextSpan(
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: Colors.redAccent),
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.warning_amber_rounded,
                                  size: 14,
                                  color: Colors.redAccent,
                                ),
                              ),
                              TextSpan(
                                text: " Important",
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
