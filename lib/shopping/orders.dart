import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nsideas/home_page/home_page.dart';
import 'package:nsideas/settings/user_convertor.dart';
import 'package:nsideas/shopping/Converter.dart';
import 'package:nsideas/test.dart';

import '../functions.dart';
import '../test1.dart';

class orders_page extends StatefulWidget {
  const orders_page({super.key});

  @override
  State<orders_page> createState() => _orders_pageState();
}

class _orders_pageState extends State<orders_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
            backButton(),
            HeadingH2(heading:"Our Orders,${userId().split("@").first}"),
            StreamBuilder<List<OrdersConverter>>(
              stream: readOrders(),
              builder: (context, snapshot) {
                final subjects = snapshot.data;
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 0.3,
                        color: Colors.cyan,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Text("Error with server");
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: subjects!.length,
                          itemBuilder: (context, int index) {
                            final data = subjects[index];
                            return Container(
                              padding: const EdgeInsets.all(10.0),
                              margin: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 4),

                              decoration: BoxDecoration(color: data.isShipped?Colors.white:Colors.greenAccent.withOpacity(0.3),borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("Cost : ₹${data.finalCost}  ",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20),),
                                      Text("₹${data.cost}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,decoration: TextDecoration.lineThrough,),),
                                      Spacer(),
                                      Container(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(8)),child: Text("qty : ${data.qty}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white),)),

                                    ],
                                  ),
                                  Text("Conformed Status : ${data.isConformed}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                  Text("City: ${data.address.city}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                  Text("carrier : ${data.carrier}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                  Text("Delivery Status : ${data.deliveryStatus}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                  Text("Delivered By: ${data.timeTakenToDelivery}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                  Text("Note: ${data.notes}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                ],
                              ),
                            );
                          });
                    }
                }
              },
            )
                    ],
                  ),
          )),
    );
  }
}

Stream<List<OrdersConverter>> readOrders() => FirebaseFirestore.instance
    .collection("users")
    .doc(userId())
    .collection("orders").orderBy("id",descending: true)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) {


          return OrdersConverter.fromJson(doc.data());
        }).toList());

// Stream<List<OrdersConverter>> readOrders() => FirebaseFirestore.instance
//     .collection("users")
//     .doc(userId())
//     .collection("orders")
//     .snapshots()
//     .map((snapshot) => snapshot.docs.map((doc) {
//           // Decrypt the encrypted data retrieved from Firestore
//
//           final encryptedData =
//               encrypt.Encrypted.fromBase64(doc.data()['encryptedData']);
//           try {
//             final decryptedData = Encryptor.decryptData(encryptedData);
//           } catch (e) {
//             print(e);
//           }
//
//           final decryptedData = Encryptor.decryptData(encryptedData);
//           // Parse the decrypted JSON data and create OrdersConverter objects
//           final Map<String, dynamic> jsonData = json.decode(decryptedData);
//           return OrdersConverter.fromJson(jsonData);
//         }).toList());

class OrdersConverter {
  final String id;
  final List<ProductsConverter> products;
  final double cost,finalCost;
  final int qty;
  final AddressConvertor address; // Corrected class name
  final String userId, isConformed; // Corrected property name
  final String image;
  final String transactionId;
  final String timeTakenToDelivery;
  final String carrier;
  final String trackingNumber;
  final String estimatedDeliveryDate;
  final String deliveryStatus;
  final String notes;
  final bool isShipped;

  OrdersConverter({
    required this.id,
    required this.products,
    required this.isShipped,
    required this.finalCost,
    required this.cost,
    required this.qty,
    required this.isConformed, // Corrected property name
    required this.address,
    required this.userId,
    required this.image,
    required this.transactionId,
    required this.timeTakenToDelivery,
    required this.carrier,
    required this.trackingNumber,
    required this.estimatedDeliveryDate,
    required this.deliveryStatus,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'products': products.map((product) => product.toJson()).toList(),
        'isConformed': isConformed, // Corrected property name
        'cost': cost,
        'finalCost': finalCost,
        'isShipped': isShipped,
        'qty': qty,
        'address': address.toJson(),
        'userId': userId,
        'image': image,
        'transactionId': transactionId,
        'timeTakenToDelivery': timeTakenToDelivery,
        'carrier': carrier,
        'trackingNumber': trackingNumber,
        'estimatedDeliveryDate': estimatedDeliveryDate,
        'deliveryStatus': deliveryStatus,
        'notes': notes,
      };

  static OrdersConverter fromJson(Map<String, dynamic> json) => OrdersConverter(
        id: json['id'] ?? "",
        products: List<ProductsConverter>.from((json['products'] ?? [])
            .map((productJson) => ProductsConverter.fromJson(productJson))),
        cost: json['cost'] ?? 0.0,
    finalCost: json['finalCost'] ?? 0.0,
        qty: json['qty'] ?? 0,
        address: AddressConvertor.fromJson(json['address'] ?? {}),
        userId: json['userId'] ?? "",
        image: json['image'] ?? "",
    isShipped: json['isShipped'] ?? false,
        isConformed: json['isConformed'] ?? "",
        // Corrected property name
        transactionId: json['transactionId'] ?? "",
        timeTakenToDelivery: json['timeTakenToDelivery'] ?? "",
        carrier: json['carrier'] ?? "",
        trackingNumber: json['trackingNumber'] ?? "",
        estimatedDeliveryDate: json['estimatedDeliveryDate'] ?? "",
        deliveryStatus: json['deliveryStatus'] ?? "",
        notes: json['notes'] ?? "",
      );

  static List<OrdersConverter> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}
