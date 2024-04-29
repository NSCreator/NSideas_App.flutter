import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nsideas/functions.dart';
import 'package:nsideas/shopping/Converter.dart';
import 'package:nsideas/shopping/payment.dart';

import 'sub_page.dart';

class CartPage extends StatefulWidget {
   bool isBack;
CartPage({ this.isBack = true});
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<ProductsConverter> cart = [];

  getData() async {
    cart = await SubjectPreferences.get();
    if(cart.isNotEmpty)setState(() {
      cart;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
         if(widget.isBack)backButton(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10),
                      child: Text(
                        "Cart List",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: cart.length,
                        shrinkWrap: true,
                        itemBuilder: (context, int index) {
                          final cartData = cart[index];
                          return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 5),
                            margin: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                            cartData.images.first))),
                                Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  cartData.heading,
                                                  style: TextStyle(fontSize: 20),
                                                ),
                                              ),
                                              InkWell(onTap: () async {
                                                await SubjectPreferences.delete(cartData.id);
                                                getData();
                                              },child: Icon(Icons.close,color: Colors.red.withOpacity(0.5),)),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, top: 5),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .add_shopping_cart_outlined,
                                                  size: 20,
                                                ),
                                                QuantityWidget(
                                                  initialValue: cartData.quantity,
                                                  // Initial value
                                                  onChanged: (newValue) async {
                                                    await SubjectPreferences.updateQuantity(cartData.id,newValue);
                                                    getData();
                                                  },
                                                ),
                                                Spacer(),
                                                Text(
                                                  "₹ ${(cartData.cost - cartData.cost * (cartData.discount / 100))*cartData.quantity}",
                                                  style:
                                                  TextStyle(fontSize: 20),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          );
                        }),
                    if (cart.isEmpty)
                      Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50.0),
                            child: Text(
                              "Nothing",
                              style: TextStyle(fontSize: 20),
                            ),
                          )),
                  ],
                ),
              ),
            ),
            cart.isNotEmpty
                ? Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Cost : ${cart.fold(0.0, (sum, item) => sum + (item.quantity * item.cost - (item.quantity * item.cost * (item.discount / 100))))}",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Quantity : ${cart.fold(0, (sum, item) => sum+item.quantity)}",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      "You Saved : ${cart.fold(0.0, (sum, item) => sum + (item.quantity * item.cost)) - cart.fold(0.0, (sum, item) => sum + (item.quantity * item.cost - (item.quantity * item.cost * (item.discount / 100))))}",
                      style: TextStyle(fontSize: 18),
                    ),
                    InkWell(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaymentPage()));
                      },
                    )
                  ],
                ))
                : Container()
          ],
        ),
      ),
    );
  }
}
