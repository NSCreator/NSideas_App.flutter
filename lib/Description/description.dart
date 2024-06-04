import 'package:flutter/material.dart';
import 'package:nsideas/Description/Converter.dart';
import 'package:nsideas/Description/codeFile.dart';
import 'package:nsideas/Description/creator.dart';
import 'package:nsideas/functions.dart';
import 'package:nsideas/textFeild.dart';

import '../project_files/projects_test.dart';

class Description extends StatefulWidget {
  final List<DescriptionConvertor> data;
  final String id;
  final String mode;

  Description({required this.id, required this.data, required this.mode});

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isOwner())
            Row(
              children: [
                Expanded(
                    child: Text(
                      "Add Descriptions",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.white),
                    )),
                ElevatedButton(
                  child: Text("ADD"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DescriptionCreator(
                              id: widget.id,
                              mode: widget.mode,
                            )));
                  },
                ),
              ],
            ),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.data.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final data = widget.data[index];
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isOwner())
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DescriptionCreator(
                                      index: index,
                                      descriptions: widget.data,
                                      id: widget.id,
                                      mode: widget.mode,
                                      data: data,
                                    )));
                          },
                          icon: Icon(Icons.edit)),
                    if (data.points.isNotEmpty)
                      StyledTextWidget(
                        text: data.heading,
                        fontSize: 20,

                      )
                    else if (data.ivf.isNotEmpty)
                      StyledTextWidget(
                        text: data.heading,
                        fontSize: 20,
                        color: Colors.white70,
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: StyledTextWidget(
                            text: data.heading,
                            fontSize: 20,
                            color: Colors.white.withOpacity(0.9)),
                      ),
                    if (data.ivf.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: scrollingImages(
                          images: data.ivf
                              .map((HomePageImage) => HomePageImage?.fileUrl)
                              .toList(),
                          id: widget.id,
                          isZoom: true,
                        ),
                      ),
                    if (data.points.isNotEmpty)
                      ListView.builder(
                          padding: EdgeInsets.all(10),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.points.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (data.points.isNotEmpty) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${index + 1}. ",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                  Expanded(
                                      child: StyledTextWidget(
                                          text: data.points[index],
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 16)),
                                ],
                              );
                            } else {
                              return Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: StyledTextWidget(
                                      text: data.points[index],
                                      color: Colors.orangeAccent,
                                      fontSize: 20));
                            }
                          }),
                    if (data.table.isNotEmpty)
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(15)),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data.table
                              .length, // Number of rows including the header
                          itemBuilder: (context, index) {
                            TableConvertor subTechnicalParameters =
                            data.table[index];
                            return Table(
                              border: TableBorder.all(
                                  width: 0.5,
                                  color: Colors.white54,
                                  borderRadius:data.table.length==1?BorderRadius.circular(15): index == 0
                                      ? BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15))
                                      : index == data.table.length - 1
                                      ? BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15))
                                      : BorderRadius.circular(0)),
                              defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                              columnWidths: const {
                                0: FractionColumnWidth(0.2),
                                1: FractionColumnWidth(0.3),
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
                    if (data.code.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10,left: 5),
                        child: Text(
                          "Code Files",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500,color: Colors.white),
                        ),
                      ),
                    if (data.code.isNotEmpty)
                      ListView.builder(
                          padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          itemCount: data.code.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, int index) {
                            final codeData = data.code[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return CodeFileView(
                                        code: codeData.code,
                                        lang: codeData.lang,
                                      );
                                    }));
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 2.0),
                                padding: EdgeInsets.symmetric(vertical: 3.0),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  // border: Border.all(color: Colors.white24),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: 40,
                                        child: Image.asset(
                                            "assets/file_icon.png")),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            codeData.heading,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            codeData.lang,
                                            style: TextStyle(fontSize: 12,color: Colors.white70),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          })
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(
              height: 15,
            ),
          ),
        ],
      ),
    );
  }
}
