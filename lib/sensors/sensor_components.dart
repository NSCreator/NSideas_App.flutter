import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nsideas/sensors/creator.dart';
import 'package:nsideas/sensors/sub_page.dart';

import '../functions.dart';
import '../home_page/home_page.dart';
import 'converter.dart';

class sensorsAndComponents extends StatefulWidget {
  List<SensorsConverter> sensors;
  sensorsAndComponents({required this.sensors});

  @override
  State<sensorsAndComponents> createState() => _sensorsAndComponentsState();
}

class _sensorsAndComponentsState extends State<sensorsAndComponents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              backButton(),
              HeadingH1(heading: "Sensors"),
              GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 15),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Adjust this value according to your layout
                  crossAxisSpacing: 10, // Adjust the spacing between grid items
                  mainAxisSpacing: 10, // Adjust the spacing between rows
                ),
                itemCount: widget.sensors!.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  final data = widget.sensors[index];
                  return InkWell(
                    child:Column(
                      children: [
                        Expanded(
                          child: data.thumbnail.fileUrl.isNotEmpty
                              ? Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                              ),

                              alignment: Alignment.center,
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                                child: ImageShowAndDownload(
                                  image: data.thumbnail.fileUrl,
                                  id: data.id,
                                ),
                              )

                          )
                              : Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.03),
                              borderRadius:
                              BorderRadius.all(Radius.circular(20)),
                            ),
                            alignment: Alignment.center,
                            child: data.thumbnail.fileUrl.isNotEmpty
                                ? ImageShowAndDownload(
                              image: data.thumbnail.fileUrl,
                              id: data.id,
                            )
                                : Text(
                              "No Image",
                              style: TextStyle(
                                  color:
                                  Colors.white.withOpacity(0.15),
                                  fontSize: 20),
                            ),
                          ),
                        ),
                        Text(
                          data.heading.short,
                          style: TextStyle(
                            fontSize: 20,color: Colors.white
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 300),
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              sensor(
                                data: data,
                              ),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            final fadeTransition = FadeTransition(
                              opacity: animation,
                              child: child,
                            );

                            return Container(
                              color: Colors.black.withOpacity(animation.value),
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 300),
                                opacity: animation.value.clamp(0.3, 1.0),
                                child: fadeTransition,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),


              SizedBox(
                height: 150,
              )
            ],
          ),
        ),
      ),
    );
  }
}
