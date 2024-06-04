import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:nsideas/functions.dart';
import 'package:nsideas/message/messaging_page.dart';
import 'package:nsideas/shopping/orders.dart';
import 'package:nsideas/test1.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page/home_page.dart';
import '../main.dart';
import '../settings/settings.dart';
import '../settings/user_convertor.dart';
import 'Converter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  List<ProductsConverter> cart = [];
  AddressConvertor address = AddressConvertor(
      street1: '',
      id: '',
      city: '',
      state: "",
      zip: '',
      nearBy: '',
      country: '',
      phone: "");

  getData() async {
    cart = await SubjectPreferences.get();

    setState(() {
      cart;
    });
  }

  final tidController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  final PhotoUrlController = TextEditingController();

  bool isPaymentMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isPaymentMode)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    backButton(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10),
                      child: Text(
                        "Payment",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                    ),
                    AddressPage(
                      onChanged: (val) {
                        setState(() {
                          address = val;
                          showToastText("Address Selected");
                        });
                      },
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: 5, bottom: 5, left: 15, right: 25),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Price Details",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Cost"),
                              Text(
                                  "${cart.fold(0.0, (sum, item) => sum + (item.quantity * item.cost - (item.quantity * item.cost * (item.discount / 100))))}"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Shipping Details "),
                              Text(
                                  "${cart.fold(0.0, (sum, item) => sum + (item.quantity * item.cost - (item.quantity * item.cost * (item.discount / 100)))) < 1000 ? 50 : 'Free Shipping'}"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Final Cost : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              ),
                              Text(
                                "${cart.fold(0.0, (sum, item) => sum + (item.quantity * item.cost - (item.quantity * item.cost * (item.discount / 100)))) < 1000 ? cart.fold(0.0, (sum, item) => sum + (item.quantity * item.cost - (item.quantity * item.cost * (item.discount / 100)))) + 50 : cart.fold(0.0, (sum, item) => sum + (item.quantity * item.cost - (item.quantity * item.cost * (item.discount / 100))))}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (cart.fold(
                            0.0,
                            (sum, item) =>
                                sum +
                                (item.quantity * item.cost -
                                    (item.quantity *
                                        item.cost *
                                        (item.discount / 100)))) <
                        1000)
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10),
                              child: Image.asset("assets/img_1.png"),
                            )),
                            Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    Wrap(
                                      children: [
                                        Text(
                                          "Get",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          " Free ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          "Shipping Details",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    Wrap(
                                      children: [
                                        Text(
                                          "Free Shipping on about",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.blueAccent),
                                        ),
                                        Text(
                                          " ₹",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.indigo),
                                        ),
                                        Text(
                                          "1000",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.blueAccent),
                                        ),
                                      ],
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    InkWell(
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "Processed with Payment",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                      onTap: () {
                        if (address.id.isEmpty) {
                          showToastText("Select Address");
                        } else {
                          setState(() {
                            isPaymentMode = true;
                          });
                        }
                      },
                    ),
                  ],
                ),
              if (isPaymentMode)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                isPaymentMode = false;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 8),
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_back,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "back to Address",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FullUser())
                          .get(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error.toString()}'),
                          );
                        }
                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return Center(
                            child: Text('Document not found.'),
                          );
                        }
                        final Map<String, dynamic> doc =
                            snapshot.data!.data() as Map<String, dynamic>;
                        UserConvertor data = UserConvertor.fromJson(doc);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 15),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "User Details",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  data.name,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  data.occupation,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Address : ",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (address.phone.isNotEmpty)
                                        Text(
                                          address.phone,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      if (address.street1.isNotEmpty)
                                        Text(
                                          address.street1,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      if (address.street2.isNotEmpty)
                                        Text(
                                          address.street2,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      if (address.nearBy.isNotEmpty)
                                        Text(
                                          address.nearBy,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      if (address.city.isNotEmpty)
                                        Text(
                                          address.city,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      if (address.state.isNotEmpty)
                                        Text(
                                          address.state,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      if (address.country.isNotEmpty)
                                        Text(
                                          address.country,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      if (address.zip.isNotEmpty)
                                        Text(
                                          address.zip,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Payment ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          InkWell(
                            onTap: () {
                              String upi = "sujithnimmala03@oksbi";
                              double amount = cart.fold(
                                          0.0,
                                          (sum, item) =>
                                              sum +
                                              (item.quantity * item.cost -
                                                  (item.quantity *
                                                      item.cost *
                                                      (item.discount / 100)))) <
                                      1000
                                  ? cart.fold(
                                          0.0,
                                          (sum, item) =>
                                              sum +
                                              (item.quantity * item.cost -
                                                  (item.quantity *
                                                      item.cost *
                                                      (item.discount / 100)))) +
                                      50
                                  : cart.fold(
                                      0.0,
                                      (sum, item) =>
                                          sum +
                                          (item.quantity * item.cost -
                                              (item.quantity *
                                                  item.cost *
                                                  (item.discount / 100))));

                              String url = "upi://pay?pa=$upi&am=$amount";

                              ExternalLaunchUrl(url);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Cost : ${cart.fold(0.0, (sum, item) => sum + (item.quantity * item.cost - (item.quantity * item.cost * (item.discount / 100)))) < 1000 ? cart.fold(0.0, (sum, item) => sum + (item.quantity * item.cost - (item.quantity * item.cost * (item.discount / 100)))) + 50 : cart.fold(0.0, (sum, item) => sum + (item.quantity * item.cost - (item.quantity * item.cost * (item.discount / 100))))}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          "Quantity : ${cart.fold(0, (sum, item) => sum + item.quantity)}",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.greenAccent),
                                    child: Text(
                                      "Pay",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5),
                      child: Text(
                        "Upload Payment ScreenShot",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                    ),
                    // Uploader(onChanged: (val){
                    //   PhotoUrlController.text = val.first;
                    // }, type: FileType.image),
                    TextFieldContainer(
                      controller: tidController,
                      hintText: 'Enter Transaction Id',
                      heading: 'Transaction Id',
                    ),
                    InkWell(
                      onTap: () async {
                        try {
                          String id = getID();

                          OrdersConverter order = OrdersConverter(
                            isShipped: false,
                            id: id,
                            products: cart,
                            cost: cart.fold(
                                        0.0,
                                        (sum, item) =>
                                            sum +
                                            (item.quantity * item.cost -
                                                (item.quantity *
                                                    item.cost *
                                                    (item.discount / 100)))) <
                                    1000
                                ? cart.fold(
                                        0.0,
                                        (sum, item) =>
                                            sum + (item.quantity * item.cost)) +
                                    50
                                : cart.fold(
                                    0.0,
                                    (sum, item) =>
                                        sum + (item.quantity * item.cost)),
                            qty: cart.fold(
                                0, (sum, item) => sum + item.quantity),
                            isConformed: "No Yet",
                            address: address,
                            userId: userId(),
                            image: PhotoUrlController.text,
                            transactionId: tidController.text,
                            timeTakenToDelivery: "N/A",
                            carrier: "N/A",
                            trackingNumber: "N/A",
                            estimatedDeliveryDate: "N/A",
                            deliveryStatus: "N/A",
                            notes: "",
                            finalCost: cart.fold(
                                        0.0,
                                        (sum, item) =>
                                            sum +
                                            (item.quantity * item.cost -
                                                (item.quantity *
                                                    item.cost *
                                                    (item.discount / 100)))) <
                                    1000
                                ? cart.fold(
                                        0.0,
                                        (sum, item) =>
                                            sum +
                                            (item.quantity * item.cost -
                                                (item.quantity *
                                                    item.cost *
                                                    (item.discount / 100)))) +
                                    50
                                : cart.fold(
                                    0.0,
                                    (sum, item) =>
                                        sum +
                                        (item.quantity * item.cost -
                                            (item.quantity *
                                                item.cost *
                                                (item.discount / 100)))),
                          );

                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(userId())
                              .collection("orders")
                              .doc(id)
                              .set(order.toJson());
                          FirebaseFirestore.instance
                              .collection("orders")
                              .doc(id)
                              .set(order.toJson());
                          messageToOwner(
                              payload: {"navigation": "all_orders"},
                              message:
                                  "Cost : ${cart.fold(0.0, (sum, item) => sum + (item.quantity * item.cost - (item.quantity * item.cost * (item.discount / 100)))) < 1000 ? cart.fold(0.0, (sum, item) => sum + (item.quantity * item.cost - (item.quantity * item.cost * (item.discount / 100)))) + 50 : cart.fold(0.0, (sum, item) => sum + (item.quantity * item.cost - (item.quantity * item.cost * (item.discount / 100))))}, from : ${address.city}",
                              head: "Shopping");
                          final prefs = await SharedPreferences.getInstance();
                          prefs.remove("cart");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage()));
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.greenAccent),
                            child: Text(
                              "Submit",
                              style:
                                  TextStyle(fontSize: 25, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
