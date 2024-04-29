import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nsideas/functions.dart';
import 'package:nsideas/settings/settings.dart';
import 'package:nsideas/shopping/cart.dart';

import '../favorites/converter.dart';
import '../home_page/home_page.dart';
import '../message/messaging_page.dart';
import '../project_files/sub_page.dart';
import '../project_files/projects_test.dart';
import '../sensors/sub_page.dart';
import '../textFeild.dart';
import 'Converter.dart';

class ProductPage extends StatefulWidget {
  ProductsConverter data;

  ProductPage({required this.data});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<String> ids = [];

  getData() async {
    List<ProductsConverter> subjects = await SavedProductsPreferences.get();
    ids = subjects.map((x) => x.id).toList();
    setState(() {
      ids;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double rating = double.parse(
        (widget.data.reviews.map((e) => e.rating).reduce((a, b) => a + b) /
                widget.data.reviews.length)
            .toStringAsFixed(1));
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              backButton(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: scrollingImages(
                    images: widget.data.images,
                    id: "HomePageImages",
                    isZoom: true,
                    ar: AspectRatio(
                      aspectRatio: 16 / 9,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                      widget.data.heading,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                        margin:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.black54),
                        child: Text(
                          "$rating",
                          style: TextStyle(color: Colors.white, fontSize: 12),
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
                    Text("(${widget.data.reviews.length})"),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Text("${widget.data.availability}"),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: Row(
                  children: [
                    Text(
                      "₹ ${widget.data.cost - widget.data.cost * (widget.data.discount / 100)}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        "₹ ${widget.data.cost}",
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 15,
                            color: Colors.black54),
                      ),
                    ),
                    Text(
                      "${widget.data.discount}% OFF",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.red),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 5),
                child: Row(
                  children: [
                    Icon(
                      Icons.add_shopping_cart_outlined,
                      size: 22,
                    ),
                    Text(
                      " Quantity",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              QuantityWidget(
                initialValue: 1, // Initial value
                onChanged: (newValue) {
                  setState(() {
                    widget.data.quantity = newValue;
                  });
                },
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      if (isAnonymousUser()) {
                        showToastText("Please LogIn");
                      } else {
                        await SubjectPreferences.add(widget.data);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Scaffold(body: CartPage())));
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Icon(Icons.shopping_cart),
                          Text(
                            " ADD TO CART ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (ids.contains(widget.data.id))
                        await SavedProductsPreferences.delete(widget.data.id);
                      else
                        await SavedProductsPreferences.add(widget.data);
                      getData();
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(
                        children: [
                          Icon(
                            ids.contains(widget.data.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 25,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  "${widget.data.about}",
                  style: TextStyle(fontSize: 18),
                ),
              )),
              if (widget.data.projectId.isNotEmpty)
                InkWell(
                  onTap: () async {
                    List<ProjectConverter> projects = await getProjects(false);
                    projects
                        .where((project) => project.id == widget.data.projectId)
                        .map((project) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Project(
                                    data: project,
                                  )));
                      return project;
                    }).toList();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: Text(
                      "View Making Process",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0, bottom: 10),
                child: HeadingWithDivider(
                  heading: 'Product Details',
                ),
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(left: 15, right: 10),
                  itemCount: widget.data.productDetails.length,
                  shrinkWrap: true,
                  itemBuilder: (context, int index) {
                    final pd = widget.data.productDetails[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pd.heading,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "${pd.subHeading}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(
                              left: 10,
                            ),
                            itemCount: pd.points.length,
                            shrinkWrap: true,
                            itemBuilder: (context, int index) {
                              final pdp = pd.points[index];
                              return Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 5,
                                  ),
                                  Text(
                                    " ${pdp}",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ],
                    );
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 25.0, bottom: 10),
                child: HeadingWithDivider(
                  heading: 'Specification Details',
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.data.specificationDetails
                      .length, // Number of rows including the header
                  itemBuilder: (context, index) {
                    TableConvertor subTechnicalParameters =
                        widget.data.specificationDetails[index];
                    return Table(
                      border: TableBorder.all(
                          width: 0.5,
                          color: Colors.black38,
                          borderRadius: index == 0
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15))
                              : index ==
                                      widget.data.specificationDetails.length -
                                          1
                                  ? BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15))
                                  : BorderRadius.circular(0)),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const {
                        0: FractionColumnWidth(0.1),
                        1: FractionColumnWidth(0.2),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8)),
                          children: [
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  subTechnicalParameters.col0,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                    textAlign: TextAlign.center,
                                    subTechnicalParameters.col1,
                                    style: TextStyle(color: Colors.black)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0, bottom: 10, left: 10),
                child: Text(
                  "Reviews",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
              ),
              ListView.builder(
                  itemCount: widget.data.reviews.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, int index) {
                    final r = widget.data.reviews[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 1),
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.black),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        r.username,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "@${r.userId}",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            "${r.date}",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              RatingBarIndicator(
                                rating: 4.5,
                                itemCount: 5,
                                itemSize: 20.0,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text("From ${r.userLocation}"),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              r.heading,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Text(r.comment),
                        ],
                      ),
                    );
                  }),
              SizedBox(
                height: 80,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          if (isAnonymousUser()) {
            showToastText("Please LogIn");
          } else
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => notifications()));
        },
        child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(30)),
            child: Icon(
              Icons.message,
              color: Colors.white,
            )),
      ),
    );
  }
}

class QuantityWidget extends StatefulWidget {
  final int initialValue;
  final Function(int) onChanged;

  QuantityWidget({required this.initialValue, required this.onChanged});

  @override
  _QuantityWidgetState createState() => _QuantityWidgetState();
}

class _QuantityWidgetState extends State<QuantityWidget> {
  int _quantity = 0;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            if (_quantity > 1) {
              setState(() {
                _quantity--;
                widget.onChanged(_quantity);
              });
            }
          },
        ),
        Text(
          '$_quantity',
          style: TextStyle(fontSize: 20.0),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            setState(() {
              _quantity++;
              widget.onChanged(_quantity);
            });
          },
        ),
      ],
    );
  }
}
