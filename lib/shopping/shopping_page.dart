import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nsideas/functions.dart';
import 'package:nsideas/shopping/Converter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page/home_page.dart';
import 'cart.dart';
import 'sub_page.dart';

TextStyle HeadingTextStyle =
    TextStyle(fontSize: 25, fontWeight: FontWeight.w500,color: Colors.white);

class ShoppingPage extends StatefulWidget {
  List<ProductsConverter> products;

  ShoppingPage({required this.products});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          backButton(),
          Row(
            children: [
              HeadingH1(heading: "Shopping"),
              Spacer(),
              if (!isAnonymousUser()) InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CartPage()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.white70,
                      size: 30,
                    ),
                  ))
            ],
          ),
          ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: widget.products.length,
              itemBuilder: (context, int index) {
                final ProductsConverter data = widget.products[index];

                double rating = double.parse(
                    (data.reviews.map((e) => e.rating).reduce((a, b) => a + b) /
                            data.reviews.length)
                        .toStringAsFixed(1));
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductPage(
                                  data: data,
                                )));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                            aspectRatio: 16 / 6,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  data.images.first,
                                  fit: BoxFit.cover,
                                ))),
                        Text(
                          data.heading,
                          style: TextStyle(fontSize: 20),
                        ),
                        Row(
                          children: [
                            Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 1, horizontal: 8),
                                margin: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black54),
                                child: Text(
                                  "${double.parse(rating.toStringAsFixed(1))}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                )),
                            RatingBarIndicator(
                              rating: rating,
                              itemCount: 5,
                              itemSize: 20.0,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                            ),
                            Text("(${data.reviews.length})"),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(data.availability),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              Text(
                                "₹ ${data.cost - data.cost * (data.discount / 100)}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text(
                                  " ${data.discount}%",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red),
                                ),
                              ),
                              Text(
                                "₹ ${data.cost}",
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          if (!widget.products.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white10, borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Icon(Icons.shopping_bag,color: Colors.white70,),
                  Text(
                    " Unavailable Products",
                    style: TextStyle(fontSize: 20,color: Colors.white),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}

Future<List<ProductsConverter>> getProducts(bool isLoading) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final studyMaterialsJson = prefs.getString("products") ?? "";

  if (studyMaterialsJson.isEmpty || isLoading) {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('products').get();
    List<Map<String, dynamic>> projectsData = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    String projectsJson = jsonEncode(projectsData);
    await prefs.setString("products", projectsJson);
    List<ProductsConverter> projects =
        projectsData.map((json) => ProductsConverter.fromJson(json)).toList();
    return projects;
  } else {
    List<dynamic> projectsJsonList = json.decode(studyMaterialsJson);
    List<ProductsConverter> projects = projectsJsonList
        .map((json) => ProductsConverter.fromJson(json))
        .toList();

    return projects;
  }
}
