import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../functions.dart';
import '../home_page/home_page.dart';
import 'orders.dart';

class all_orders_page extends StatefulWidget {
  const all_orders_page({super.key});

  @override
  State<all_orders_page> createState() => _all_orders_pageState();
}

class _all_orders_pageState extends State<all_orders_page> {
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
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("All Orders",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 25),),
                ),
                StreamBuilder<List<OrdersConverter>>(
                  stream: readAllOrders(),
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

Stream<List<OrdersConverter>> readAllOrders() => FirebaseFirestore.instance

    .collection("orders").orderBy("id",descending: true)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) {


  return OrdersConverter.fromJson(doc.data());
}).toList());
