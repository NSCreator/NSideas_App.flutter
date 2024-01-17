// // ignore_for_file: unnecessary_import, non_constant_identifier_names, prefer_const_constructors, sort_child_properties_last, must_be_immutable, file_names, use_build_context_synchronously
//
// import 'dart:async';
// import 'dart:math';
// import 'package:email_validator/email_validator.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server/gmail.dart';
// import 'package:nsideas/homePage.dart';
//
// import 'authPage.dart';
// import 'functions.dart';
//
//
// class LoginPage extends StatelessWidget {
//   LoginPage({super.key});
//
//   // text editing controllers
//   final usernameController = TextEditingController();
//   final passwordController = TextEditingController();
//
//   // sign user in method
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   Future<UserCredential?> _signInWithGoogle() async {
//     // try {
//     //   final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//     //   if (googleUser == null) return null;
//     //
//     //   final GoogleSignInAuthentication googleAuth =
//     //   await googleUser.authentication;
//     //   final OAuthCredential credential = GoogleAuthProvider.credential(
//     //     accessToken: googleAuth.accessToken,
//     //     idToken: googleAuth.idToken,
//     //   );
//     //
//     //   return await _auth.signInWithCredential(credential);
//     // } catch (e) {
//     //   print('Error signing in with Google: $e');
//     //   return null;
//     // }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: Colors.grey,
//         body: SafeArea(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               const Icon(
//                 Icons.lock,
//                 size: 100,
//               ),
//
//               Column(
//                 children: [
//                   Text(
//                     'Welcome back you\'ve been missed!',
//                     style: TextStyle(
//                       color: Colors.grey[700],
//                       fontSize: 16,
//                     ),
//                   ),
//
//                   const SizedBox(height: 25),
//
//                   MyTextField(
//                     controller: usernameController,
//                     hintText: 'Username',
//                     obscureText: false,
//                   ),
//
//                   const SizedBox(height: 10),
//
//                   MyTextField(
//                     controller: passwordController,
//                     hintText: 'Password',
//                     obscureText: true,
//                   ),
//
//                   const SizedBox(height: 10),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         InkWell(
//                           onTap: () async {
//                             if (usernameController.text.length > 10) {
//                               final String email = usernameController.text.trim();
//                               try {
//                                 await _auth.sendPasswordResetEmail(email: email);
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) => AlertDialog(
//                                     title: Text('Password Reset Email Sent'),
//                                     content: Text(
//                                         'An email with instructions to reset your password has been sent to $email.'),
//                                     actions: <Widget>[
//                                       TextButton(
//                                         onPressed: () => Navigator.pop(context),
//                                         child: Text('OK'),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               } catch (error) {
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) => AlertDialog(
//                                     title: Text('Error'),
//                                     content: Text(error.toString()),
//                                     actions: <Widget>[
//                                       TextButton(
//                                         onPressed: () => Navigator.pop(context),
//                                         child: Text('OK'),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               }
//                             } else {
//                               showToastText("Enter Gmail");
//                             }
//                           },
//                           child: Text(
//                             'Forgot Password?',
//                             style: TextStyle(color: Colors.grey[600]),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 25),
//
//                   // sign in button
//                   InkWell(
//                     onTap:()=> signIn(context),
//                     child: Container(
//                       padding: const EdgeInsets.all(25),
//                       margin: const EdgeInsets.symmetric(horizontal: 25),
//                       decoration: BoxDecoration(
//                         color: Colors.black,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           "Sign In",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//
//                 ],
//               ),
//               //
//               // Column(
//               //   children: [
//               //     const SizedBox(height: 20),
//               //
//               //     // or continue with
//               //     Padding(
//               //       padding: const EdgeInsets.symmetric(horizontal: 25.0),
//               //       child: Row(
//               //         children: [
//               //           Expanded(
//               //             child: Divider(
//               //               thickness: 0.5,
//               //               color: Colors.grey[400],
//               //             ),
//               //           ),
//               //           Padding(
//               //             padding: const EdgeInsets.symmetric(horizontal: 10.0),
//               //             child: Text(
//               //               'Or continue with',
//               //               style: TextStyle(color: Colors.grey[700]),
//               //             ),
//               //           ),
//               //           Expanded(
//               //             child: Divider(
//               //               thickness: 0.5,
//               //               color: Colors.grey[400],
//               //             ),
//               //           ),
//               //         ],
//               //       ),
//               //     ),
//               //
//               //     const SizedBox(height: 10),
//               //
//               //     Row(
//               //       mainAxisAlignment: MainAxisAlignment.center,
//               //       children:  [
//               //
//               //         InkWell(
//               //           onTap: (){
//               //             _signInWithGoogle();
//               //           },
//               //           child: Container(
//               //             padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
//               //             decoration: BoxDecoration(
//               //               border: Border.all(color: Colors.white),
//               //               borderRadius: BorderRadius.circular(16),
//               //               color: Colors.grey[200],
//               //             ),
//               //             child: Row(
//               //               children: [
//               //                 Image.asset(
//               //                   'lib/images/google.png',
//               //                   height: 30,
//               //                 ),
//               //                 Text("oogle",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)
//               //               ],
//               //             ),
//               //           ),
//               //         ),
//               //
//               //       ],
//               //     ),
//               //   ],
//               // ),
//
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Not a member?',
//                     style: TextStyle(color: Colors.grey[700]),
//                   ),
//                   const SizedBox(width: 4),
//                   InkWell(
//                     onTap: (){
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => createNewUser()));
//                     },
//                     child: const Text(
//                       'Register now',
//                       style: TextStyle(
//                         color: Colors.blue,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   Future signIn(BuildContext context) async {
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => Center(
//           child: CircularProgressIndicator(),
//         ));
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: usernameController.text.trim().toLowerCase(),
//           password: passwordController.text.trim());
//       await FirebaseMessaging.instance.getToken().then((token) async {
//         if (token != null) {
//           await FirebaseFirestore.instance
//               .collection("tokens")
//               .doc(usernameController.text)
//               .set({
//             "id": usernameController.text,
//             "token": token,
//             "time": getID(),
//           }).then((_) {
//             print("Token stored successfully");
//           }).catchError((error) {
//             print("Error storing token: $error");
//           });
//         } else {
//           print("Failed to retrieve FCM token");
//         }
//       }).catchError((error) {
//         print("Error getting FCM token: $error");
//       });
//     } on FirebaseException catch (e) {
//       showToastText(e.message as String);
//
//     }
//     Navigator.pop(context);
//   }
// }
//
// class MyTextField extends StatelessWidget {
//   final controller;
//   final String hintText;
//   final bool obscureText;
//
//   const MyTextField({
//     super.key,
//     required this.controller,
//     required this.hintText,
//     required this.obscureText,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 25.0),
//       child: TextField(
//         controller: controller,
//         obscureText: obscureText,
//         decoration: InputDecoration(
//             enabledBorder: const OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.white),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.grey.shade400),
//             ),
//             fillColor: Colors.grey.shade200,
//             filled: true,
//             hintText: hintText,
//             hintStyle: TextStyle(color: Colors.grey[500])),
//       ),
//     );
//   }
// }
//
//
// double size(BuildContext context) {
//   MediaQueryData mediaQuery = MediaQuery.of(context);
//   double screenHeight = ((mediaQuery.size.height/900)+(mediaQuery.size.width/400))/2;
//   return screenHeight;
// }
//
// class createNewUser extends StatefulWidget {
//   const createNewUser({super.key});
//
//
//
//   @override
//   State<createNewUser> createState() => _createNewUserState();
// }
//
// class _createNewUserState extends State<createNewUser> {
//   bool isTrue = false;
//   bool isSend = false;
//   String otp = "";
//
//   final emailController = TextEditingController();
//   final otpController = TextEditingController();
//   final passwordController = TextEditingController();
//   final firstNameController = TextEditingController();
//   final lastNameController = TextEditingController();
//   final passwordController_X = TextEditingController();
//
//   String generateCode() {
//     final Random random = Random();
//     const characters = '123456789abcdefghijklmnpqrstuvwxyz';
//     String code = '';
//
//     for (int i = 0; i < 6; i++) {
//       code += characters[random.nextInt(characters.length)];
//     }
//
//     return code;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double Size = size(context);
//     return Scaffold(
//
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Expanded(
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.arrow_back,
//                         size: 25,
//                         color: Colors.white,
//                       ),
//                       Text(
//                         "Enter Gmail ID",
//                         style: TextStyle(color: Colors.white70, fontSize: 16),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//
//             TextFieldContainer(
//                 child: TextFormField(
//                   controller: emailController,
//                   textInputAction: TextInputAction.next,
//                   style: textFieldStyle(Size),
//                   decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'Enter Gmail ID',
//                       hintStyle: textFieldHintStyle(Size)),
//                   validator: (email) =>
//                   email != null && !EmailValidator.validate(email)
//                       ? "Enter a valid Email"
//                       : null,
//                 )),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 if (isSend)
//                   Flexible(
//                     child: TextFieldContainer(
//                         child: TextFormField(
//                           controller: otpController,
//                           textInputAction: TextInputAction.next,
//                           style: textFieldStyle(Size),
//                           decoration: InputDecoration(
//                               border: InputBorder.none,
//                               hintText: 'Enter OPT',
//                               hintStyle: textFieldHintStyle(Size)),
//                         )),
//                   ),
//                 Padding(
//                   padding:  EdgeInsets.symmetric(horizontal:  10),
//                   child: InkWell(
//                     child: Container(
//                       padding:  EdgeInsets.symmetric(
//                           vertical:  5, horizontal:  10),
//                       decoration: BoxDecoration(
//                           color: Colors.amber.withOpacity(0.7),
//                           borderRadius: BorderRadius.circular( 30)),
//                       child: Text(
//                         isSend ? "Verity" : "Send OTP",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize:  25,
//                             fontWeight: FontWeight.w500
//                         ),
//                       ),
//                     ),
//                     onTap: () async {
//
//
//                       if (isSend) {
//                         if (otp == otpController.text.trim()) {
//                           isTrue = true;
//                           FirebaseFirestore.instance
//                               .collection("tempRegisters")
//                               .doc(emailController.text)
//                               .delete();
//                         } else {
//                           showToastText("Please Enter Correct OTP");
//                         }
//                       }
//                       else {
//                         otp = generateCode();
//                         showToastText("OTP is Sent to our Email");
//                         FirebaseFirestore.instance
//                             .collection("tempOtps")
//                             .doc(emailController.text)
//                             .set({"email": emailController.text, "otp": otp});
//                         sendEmail(emailController.text, otp);
//                         isSend = true;
//                       }
//
//
//
//                       setState(() {
//                         isSend;
//                         otp;
//                         isTrue;
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//
//             if (isTrue)
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding:
//                     EdgeInsets.symmetric(vertical:  15, horizontal:  15),
//                     child: Text(
//                       "Fill the Details",
//                       style: creatorHeadingTextStyle,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Flexible(
//                         child: TextFieldContainer(
//                             child: TextFormField(
//                               controller: firstNameController,
//                               textInputAction: TextInputAction.next,
//                               style: textFieldStyle(Size),
//                               decoration: InputDecoration(
//                                   border: InputBorder.none,
//                                   hintText: 'First Name',
//                                   hintStyle: textFieldHintStyle(Size)),
//                             )),
//                       ),
//                       Flexible(
//                         child: TextFieldContainer(
//                             child: TextFormField(
//                               controller: lastNameController,
//                               textInputAction: TextInputAction.next,
//                               style: textFieldStyle(Size),
//                               decoration: InputDecoration(
//                                 border: InputBorder.none,
//                                 hintText: 'Last Name',
//                                 hintStyle: textFieldHintStyle(Size),
//                               ),
//                             )),
//                       ),
//                     ],
//                   ),
//
//                   TextFieldContainer(
//                       child: TextFormField(
//                         obscureText: true,
//                         controller: passwordController,
//                         textInputAction: TextInputAction.next,
//                         style: textFieldStyle(Size),
//                         decoration: InputDecoration(
//                             border: InputBorder.none,
//                             hintText: 'Password',
//                             hintStyle: textFieldHintStyle(Size)),
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         validator: (value) => value != null && value.length < 6
//                             ? "Enter min. 6 characters"
//                             : null,
//                       )),
//                   TextFieldContainer(
//                       child: TextFormField(
//                         obscureText: true,
//                         controller: passwordController_X,
//                         textInputAction: TextInputAction.next,
//                         style: textFieldStyle(Size),
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           hintText: 'Conform Password',
//                           hintStyle: textFieldHintStyle(Size),
//                         ),
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         validator: (value) => value != null && value.length < 6
//                             ? "Enter min. 6 characters"
//                             : null,
//                       )),
//
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: Padding(
//                       padding: EdgeInsets.only(right:  15),
//                       child:
//                       Text('cancel ', style: TextStyle(fontSize:  20)),
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () async {
//                       if (passwordController.text.trim() ==
//                           passwordController_X.text.trim()) {
//                         if (firstNameController.text.isNotEmpty &&
//                             lastNameController.text.isNotEmpty) {
//                           showDialog(
//                               context: context,
//                               barrierDismissible: false,
//                               builder: (context) => Center(
//                                 child: CircularProgressIndicator(),
//                               ));
//                           try {
//                             await FirebaseFirestore.instance
//                                 .collection("users")
//                                 .doc(emailController.text)
//                                 .set({
//                               "id": emailController.text,
//                               "firstName": firstNameController.text,
//                               "lastName":lastNameController.text
//
//                             });
//                             await FirebaseAuth.instance
//                                 .createUserWithEmailAndPassword(
//                                 email:
//                                 emailController.text.trim().toLowerCase(),
//                                 password: passwordController.text.trim());
//                             await FirebaseMessaging.instance.getToken().then((token) async {
//                               if (token != null) {
//                                 await FirebaseFirestore.instance
//                                     .collection("tokens")
//                                     .doc(emailController.text)
//                                     .set({
//                                   "id": emailController.text,
//                                   "token": token,
//                                   "time": getID(),
//                                 }).then((_) {
//                                   print("Token stored successfully");
//                                 }).catchError((error) {
//                                   print("Error storing token: $error");
//                                 });
//                               } else {
//                                 print("Failed to retrieve FCM token");
//                               }
//                             }).catchError((error) {
//                               print("Error getting FCM token: $error");
//                             });
//                           } on FirebaseException catch (e) {
//                           }
//                           Navigator.pop(context);
//                           Navigator.pop(context);
//                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
//                         } else {
//                           showToastText("Fill All Details");
//                         }
//                       } else {
//                         showToastText("Enter Same Password");
//                       }
//                     },
//                     child: Padding(
//                       padding: EdgeInsets.only(right:  15),
//                       child: Text(
//                         'Sign up ',
//                         style: TextStyle(fontSize:  20),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> sendEmail(String mail, String otp) async {
//     final smtpServer = gmail('esrkr.app@gmail.com', 'wndwwhhpifpgnanu');
//     final message = Message()
//       ..from = Address('esrkr.app@gmail.com')
//       ..recipients.add(mail)
//       ..subject = 'OTP from NS Ideas'
//       ..text = 'Your Otp : $otp';
//
//     try {
//       final sendReport = await send(message, smtpServer);
//       print('Message sent: ${sendReport.toString()}');
//     } catch (e) {
//       print('Error sending email: $e');
//     }
//   }
// }
//
