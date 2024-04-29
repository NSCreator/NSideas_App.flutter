import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nsideas/sensors/sub_page.dart';

import '../functions.dart';
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
              Padding(
                padding: EdgeInsets.only(left: 15,top: 10),
                child: Text(
                  "Sensors",
                  style: TextStyle( fontSize: 20,fontWeight: FontWeight.w500),
                ),
              ),
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
                  final SubjectsData = widget.sensors[index];

                  return InkWell(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.05),
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            alignment: Alignment.center,
                            child: SubjectsData.images.isNotEmpty?ImageShowAndDownload(
                              image: SubjectsData.images.first,
                              id: SubjectsData.id,
                            ):Text("No Image",style: TextStyle(color: Colors.black.withOpacity(0.15),fontSize: 20),),

                          ),
                        ),
                        Text(
                          SubjectsData.heading.short,
                          style: TextStyle(
                            fontSize: 20,
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
                                data: SubjectsData,
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
