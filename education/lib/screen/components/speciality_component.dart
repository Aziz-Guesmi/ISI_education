import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../theme/constants.dart';
import '../all_message_page.dart';

class SpecialityComponent extends StatelessWidget {
  const SpecialityComponent(
      {super.key, required this.specialite, required this.usr});
  final String specialite;
  final UserModel usr;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AllMessagePage(usr: usr, specialite: specialite),
          ),
        );
      },
      child: Container(
  height: 100,
  padding: EdgeInsets.all(10),
  margin: EdgeInsets.all(10),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Colors.grey.withOpacity(0.2),
  ),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Image.asset(
        "assets/images/isi_image.png",
        height: 80,
        fit: BoxFit.contain,
      ),
      SizedBox(width: 10),
      SizedBox(
        height: 80, // Set the height of the SizedBox
        child: Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.headline6!,
              children: <TextSpan>[
                TextSpan(
                  text: "specialty : ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kBlueColor,
                  ),
                ),
                TextSpan(
                  text: specialite,
                  style: TextStyle(),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  ),
),


    );
  }
}
