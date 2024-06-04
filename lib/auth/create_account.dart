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
import 'package:nsideas/settings/settings.dart';
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
                controller: emailController,
                hintText: 'Enter Existing Gmail ID',


                heading: "Enter Gmail ID",
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isSend)
                    Flexible(
                      child: TextFieldContainer(
                          controller: otpController,
                          hintText: 'Enter OPT',
                        ),
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

                    HeadingH1(heading: "Fill the Details"),
                    TextFieldContainer(
                      controller: fullNameController,
                      hintText: 'Full Name',
                      heading: "Full Name",),
                   HeadingH2(heading: "Gender"),
                    Padding(
                      padding: EdgeInsets.only(left: 10, bottom: 10),
                      child: Row(
                        children: <Widget>[
                          Radio<Gender>(

                            activeColor:Colors.white,
                            value: Gender.male,
                            groupValue: _gender,
                            onChanged: (Gender? value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                          ),
                          Text('Male',style: TextStyle(color: Colors.white70,fontSize: 20,fontWeight: FontWeight.w500),),
                          Radio<Gender>(
                            value: Gender.female,
                            activeColor:Colors.white,
                            groupValue: _gender,
                            onChanged: (Gender? value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                          ),
                          Text('Female',style: TextStyle(color: Colors.white70,fontSize: 20,fontWeight: FontWeight.w500),),
                          Radio<Gender>(
                            value: Gender.other,
                            activeColor:Colors.white,
                            groupValue: _gender,
                            onChanged: (Gender? value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                          ),
                          Text('Other',style: TextStyle(color: Colors.white70,fontSize: 20,fontWeight: FontWeight.w500),),
                        ],
                      ),
                    ),
                    TextFieldContainer(
                      controller: OccupationController,
                      hintText: 'Occupation',
                      heading: "Occupation",),
                    TextFieldContainer(
                      controller: phoneNoController,
                      hintText: 'Phone Number (+91 only)  --optional',heading: "Phone Number ( optional )",),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          HeadingH1(heading: "Age --- ${_selectedDate != null
                      ? '${calculateAge(_selectedDate!)} '
                        : ''}"),


                          ElevatedButton(
                            onPressed: () => _selectDate(context),
                            child: Text('Select Date of Birth'),
                          ),

                        ],
                      ),
                    ),
                    TextFieldContainer(
                      controller: passwordController,
                      hintText: 'password',
                      heading: "Password",),
                    TextFieldContainer(
                        controller: passwordController_X,
                        hintText: 'Conform Password',
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Text('cancel ', style: TextStyle(fontSize: 20,color: Colors.white70)),
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
                                  await auth
                                      .createUserWithEmailAndPassword(
                                      email: emailController.text
                                          .trim()
                                          .toLowerCase(),
                                      password: passwordController.text.trim());
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(emailController.text)
                                      .set(UserConvertor(email: emailController.text, id: emailController.text, name: fullNameController.text, age: "$_selectedDate", gender: "$_gender", occupation: OccupationController.text, phoneNumber: phoneNoController.text, addresses: []).toJson());
                                  await auth.currentUser?.updateDisplayName(fullNameController.text);
                                  await auth.currentUser?.updatePhotoURL("");
                                  updateToken(emailController.text);

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyHomePage()));

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
                              style: TextStyle(fontSize: 25,color: Colors.white),
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
