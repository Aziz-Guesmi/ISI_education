import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import '../theme/constants.dart';
import 'home_page.dart';
import 'signin_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _fullnameController = TextEditingController();

  bool _passwordVisible = false;
  bool satusSignUp = false;
  GlobalKey<FormState> formkeySignUp = GlobalKey<FormState>();
  final controller = Get.put(AuthController());
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
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          child: Form(
            key: formkeySignUp,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "Sign Up",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Image.asset(
                          "assets/images/signup_image.png",
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _fullnameController,
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: "Enter FullName",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            prefixIcon: Icon(Icons.person_outline_rounded),
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
                          controller: _emailController,
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: "Enter your e-mail address",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          style:
                              Theme.of(context).inputDecorationTheme.labelStyle,
                          validator: MultiValidator(
                            [
                              RequiredValidator(errorText: "*Required"),
                              EmailValidator(
                                  errorText:
                                      "Please enter a valid e-mail address"),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordController,
                          maxLines: 1,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            hintText: "Enter your password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                          style:
                              Theme.of(context).inputDecorationTheme.labelStyle,
                          validator: MultiValidator([
                            RequiredValidator(errorText: "*Required"),
                            MinLengthValidator(6,
                                errorText:
                                    "Password must contain at least 6 characters"),
                            MaxLengthValidator(15,
                                errorText:
                                    "The password must not contain more than 15 characters.")
                          ]),
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
                        if (formkeySignUp.currentState!.validate()) {
                          final usr = UserModel(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                            fullName: _fullnameController.text.trim(),
                            role: "Admin",
                          );
                          satusSignUp =
                              (await controller.createUserController(usr))!;
                          if (satusSignUp) {
                            UserModel usr =
                                (await controller.getUserDetailsController())!;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(usr: usr),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Something wrong")));
                          }
                        }
                      },
                      child: Text(
                        "Sign Up",
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: kWhiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInPage(),
                      ),
                    );
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.headline5!,
                      children: <TextSpan>[
                        TextSpan(
                          text: "I have an account?  ",
                        ),
                        TextSpan(
                          text: "sign in here ",
                          style: TextStyle(
                              color: kBlueColor, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
