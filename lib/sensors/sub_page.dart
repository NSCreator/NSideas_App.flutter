import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';

import '../functions.dart';
import '../textFeild.dart';
import 'converter.dart';

class sensor extends StatefulWidget {
  SensorsConverter data;

  sensor(
      {Key? key,
        required this.data})
      : super(key: key);

  @override
  State<sensor> createState() => _sensorState();
}

class _sensorState extends State<sensor> {

  CarouselController buttonCarouselController = CarouselController();
  int currentPos = 0;

  @override
  void initState() {
    super.initState();

  }

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
                if(widget.data.images.isNotEmpty)scrollingImages(
                  images: widget.data.images,
                  id: widget.data.id,
                  isZoom: true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                  child: Text(widget.data.heading.full,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8,right: 8, top: 20),
                  child: Column(
                    children: [
                      HeadingWithDivider(heading:"About Sensor" ,),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text(
                          "          ${widget.data.about}",
                          style: TextStyle( fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                  child: Column(
                    children: [
                      HeadingWithDivider(heading:"Technical Parameters" ,),


                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(15)),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.data.technicalParameters
                                .length, // Number of rows including the header
                            itemBuilder: (context, index) {
                              TableConvertor subTechnicalParameters =widget.data.technicalParameters[index];
                              return Table(
                                border: TableBorder.all(
                                    width: 0.5,
                                    color: Colors.white60,
                                    borderRadius: index == 0
                                        ? BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))
                                        : index == widget.data.technicalParameters.length - 1
                                        ? BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15))
                                        : BorderRadius.circular(0)),
                                defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                                columnWidths: const {
                                  0: FractionColumnWidth(0.4),
                                  1: FractionColumnWidth(0.5),
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
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                              textAlign: TextAlign.center,
                                              subTechnicalParameters.col1,
                                              style:
                                              TextStyle(color: Colors.white)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      if (widget.data.pinDiagrams.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            children: [
                              HeadingWithDivider(heading:"Pin Connections" ,),
                              Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: Container(
                                  height: 2,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                              ),
                              scrollingImages(
                                images: widget.data.pinDiagrams,
                                id: widget.data.id,
                                isZoom: true,
                              ),
                            ],
                          ),
                        ),
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(15)),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.data.pinConnections
                                .length, // Number of rows including the header
                            itemBuilder: (context, index) {
                              TableConvertor subTechnicalParameters =
                              widget.data.pinConnections[index];
                              return Table(
                                border: TableBorder.all(
                                    width: 0.5,
                                    color: Colors.white60,
                                    borderRadius: index == 0
                                        ? BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))
                                        : index == widget.data.pinConnections.length - 1
                                        ? BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15))
                                        : BorderRadius.circular(0)),
                                defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                                columnWidths: const {
                                  0: FractionColumnWidth(0.4),
                                  1: FractionColumnWidth(0.5),
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
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                              textAlign: TextAlign.center,
                                              subTechnicalParameters.col1,
                                              style:
                                              TextStyle(color: Colors.white)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if(widget.data.descriptions.isNotEmpty)Description(
                  id: widget.data.id,
                  data: widget.data.descriptions, mode: 'sensors',
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ));
  }
}
class HeadingWithDivider extends StatelessWidget {
  String heading;
  HeadingWithDivider({required this.heading,super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider()),
        Center(
          child: Text(
            "  $heading  ",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(child: Divider()),
      ],
    );
  }
}

