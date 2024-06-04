import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';

import '../Description/description.dart';
import '../functions.dart';
import '../home_page/home_page.dart';
import '../test.dart';
import '../textFeild.dart';
import 'converter.dart';
import 'creator.dart';

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
                Row(
                  children: [
                    backButton(),
                    if (isOwner())
                      PopupMenuButton<String>(
                        child: Icon(Icons.more_vert),
                        itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                        onSelected: (String value) {
                          if (value == 'edit') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SensorsCreator(
                                      data: widget.data,
                                    )));
                          } else if (value == 'delete') {
                            showToastText('Delete action selected');
                          }
                        },
                      ),
                  ],
                ),
                HeadingH2(heading:widget.data.heading.short),
                if(widget.data.thumbnail.fileUrl.isNotEmpty)ImageShowAndDownload(image: widget.data.thumbnail.fileUrl, id:widget.data.type ),
                if (widget.data.heading.full.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      widget.data.heading.full,
                      style: TextStyle(fontSize: 25, color: Colors.white,fontWeight: FontWeight.w500),
                    ),
                  ),
                if (widget.data.images.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: scrollingImages(
                        images: widget.data.images
                            .map((HomePageImage) => HomePageImage.fileUrl)
                            .toList(),
                        id: widget.data.type,
                        isZoom: true,
                        ar: AspectRatio(
                          aspectRatio: 16 / 6,
                        )),
                  ),


                if(widget.data.about.isNotEmpty) Padding(
                  padding: EdgeInsets.only(left: 10,right: 8, top: 20),
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

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: [
                              HeadingWithDivider(heading:"Pin Connections" ,),
                              if (widget.data.pinDiagram.fileUrl.isNotEmpty)ImageShowAndDownload(
                                image: widget.data.pinDiagram.fileUrl,
                                id: widget.data.id,
                                isZoom: true,
                              ),
                            ],
                          ),
                        ),
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 8),
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
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(child: Divider(color: Colors.white54,)),
      ],
    );
  }
}

