import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:nsideas/main.dart';
import 'package:nsideas/message/messaging_page.dart';
import 'package:nsideas/settings/user_convertor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../functions.dart';
import '../home_page/home_page.dart';
import 'logIn_page.dart';

enum Gender { male, female, other }

class createNewUser extends StatefulWidget {
  const createNewUser({super.key});

  @override
  State<createNewUser> createState() => _createNewUserState();
}

class _createNewUserState extends State<createNewUser> {
  bool isTrue = false;
  bool isSend = false;
  String otp = "";
  Gender? _gender;
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneNoController = TextEditingController();
  final OccupationController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController_X = TextEditingController();

  String generateCode() {
    final Random random = Random();
    const characters = '123456789abcdefghijklmnpqrstuvwxyz';
    String code = '';

    for (int i = 0; i < 6; i++) {
      code += characters[random.nextInt(characters.length)];
    }
    return code;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              backButton(),
              TextFieldContainer(
                child: TextFormField(
                  controller: emailController,
                  enabled: !isTrue,
                  textInputAction: TextInputAction.next,
                  style: textFieldStyle(),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Existing Gmail ID',
                      hintStyle: textFieldHintStyle()),
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? "Enter a valid Email"
                          : null,
                ),
                heading: "Enter Gmail ID",
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isSend)
                    Flexible(
                      child: TextFieldContainer(
                          child: TextFormField(
                        controller: otpController,
                        textInputAction: TextInputAction.next,
                        style: textFieldStyle(),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter OPT',
                            hintStyle: textFieldHintStyle()),
                      )),
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          isSend ? "Verity" : "Send OTP",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      onTap: () async {
                        if (isSend) {
                          if (otp == otpController.text.trim()) {
                            isTrue = true;
                            FirebaseFirestore.instance
                                .collection("tempRegisters")
                                .doc(emailController.text)
                                .delete();
                          } else {
                            showToastText("Please Enter Correct OTP");
                          }
                        } else {
                          otp = generateCode();
                          showToastText("OTP is Sent to our Email");
                          FirebaseFirestore.instance
                              .collection("tempOtps")
                              .doc(emailController.text)
                              .set({"email": emailController.text, "otp": otp});
                          sendEmail(emailController.text, otp);
                          isSend = true;
                        }

                        setState(() {
                          isSend;
                          otp;
                          isTrue;
                        });
                      },
                    ),
                  ),
                ],
              ),
              if (isTrue)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      child: Text(
                        "Fill the Details",
                        style: creatorHeadingTextStyle,
                      ),
                    ),
                    TextFieldContainer(
                        child: TextFormField(
                      controller: fullNameController,
                      textInputAction: TextInputAction.next,
                      style: textFieldStyle(),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Full Name',
                          hintStyle: textFieldHintStyle()),
                    )),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                      child: Text(
                        'Gender',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, bottom: 10),
                      child: Row(
                        children: <Widget>[
                          Radio<Gender>(
                            value: Gender.male,
                            groupValue: _gender,
                            onChanged: (Gender? value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                          ),
                          Text('Male'),
                          Radio<Gender>(
                            value: Gender.female,
                            groupValue: _gender,
                            onChanged: (Gender? value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                          ),
                          Text('Female'),
                          Radio<Gender>(
                            value: Gender.other,
                            groupValue: _gender,
                            onChanged: (Gender? value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                          ),
                          Text('Other'),
                        ],
                      ),
                    ),
                    TextFieldContainer(
                        child: TextFormField(
                      controller: OccupationController,
                      textInputAction: TextInputAction.next,
                      style: textFieldStyle(),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Occupation',
                          hintStyle: textFieldHintStyle()),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    )),
                    TextFieldContainer(
                        child: TextFormField(
                      controller: phoneNoController,
                      textInputAction: TextInputAction.next,
                      style: textFieldStyle(),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Phone Number (+91 only)',
                          hintStyle: textFieldHintStyle()),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    )),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => _selectDate(context),
                            child: Text('Select Date of Birth'),
                          ),
                          Text(
                            _selectedDate != null
                                ? '  Age: ${calculateAge(_selectedDate!)}'
                                : '',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    TextFieldContainer(
                        child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      style: textFieldStyle(),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'password',
                          hintStyle: textFieldHintStyle()),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value != null && value.length < 6
                          ? "Enter min. 6 characters"
                          : null,
                    ),heading: "Password",),
                    TextFieldContainer(
                        child: TextFormField(
                      obscureText: true,
                      controller: passwordController_X,
                      textInputAction: TextInputAction.next,
                      style: textFieldStyle(),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Conform Password',
                        hintStyle: textFieldHintStyle(),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value != null && value.length < 6
                          ? "Enter min. 6 characters"
                          : null,
                    )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Text('cancel ', style: TextStyle(fontSize: 20)),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {

                            if (passwordController.text.trim() ==
                                passwordController_X.text.trim()) {
                              if (fullNameController.text.isNotEmpty) {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => Center(
                                      child: CircularProgressIndicator(),
                                    ));
                                try {
                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                      email: emailController.text
                                          .trim()
                                          .toLowerCase(),
                                      password: passwordController.text.trim());
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(emailController.text)
                                      .set(UserConvertor(email: emailController.text, id: emailController.text, name: fullNameController.text, age: "$_selectedDate", gender: "$_gender", occupation: OccupationController.text, phoneNumber: phoneNoController.text, addresses: []).toJson());

                                  await FirebaseMessaging.instance
                                      .getToken()
                                      .then((token) async {
                                    if (token != null) {
                                      await FirebaseFirestore.instance
                                          .collection("tokens")
                                          .doc(emailController.text)
                                          .set({
                                        "id": emailController.text,
                                        "token": token,
                                        "time": getID(),
                                      }).then((_) {
                                        print("Token stored successfully");
                                        messageToOwner(head: "New Family Member",message: emailController.text,payload: {"navigation":"message"});

                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MyHomePage()));
                                      }).catchError((error) {
                                        print("Error storing token: $error");
                                      });
                                    } else {
                                      print("Failed to retrieve FCM token");
                                    }
                                  }).catchError((error) {
                                    print("Error getting FCM token: $error");
                                    Navigator.pop(context);

                                  });

                                } on FirebaseException catch (e) {
                                  Navigator.pop(context);
                                  showToastText("$e");

                                }

                              } else {
                                showToastText("Fill All Details");
                              }
                            } else {
                              showToastText("Enter Same Password");

                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Text(
                              'Sign up ',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50,),

                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendEmail(String mail, String otp) async {
    final smtpServer = gmail('sujithnimmala03@gmail.com', 'jommccifbjyrvejq');
    final message = Message()
      ..from = Address('sujithnimmala03@gmail.com')
      ..recipients.add(mail)
      ..subject = 'OTP from NS Ideas'
      ..text = 'Your Otp : $otp';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
    } catch (e) {
      print('Error sending email: $e');
    }
  }

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    final age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      return age - 1;
    }
    return age;
  }
}
