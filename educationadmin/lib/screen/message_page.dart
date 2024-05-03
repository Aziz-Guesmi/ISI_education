import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/message_model.dart';
import '../theme/constants.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({Key? key, this.msg}) : super(key: key);
  final MessageModel? msg;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Expanded(
                flex: 2,
                child: Image.network(
                  msg!.urlImg.toString(),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: RichText(
                          textAlign: TextAlign.start,
                          maxLines: 2,
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
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
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
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: RichText(
                          textAlign: TextAlign.start,
                          maxLines: 8,
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
                      SizedBox(height: 10),
                      msg!.checkImportant == true
                          ? Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: RichText(
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
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
