import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nsideas/functions.dart';

import '../shopping/shopping_page.dart';
import 'converter.dart';

class NotificationPage extends StatefulWidget {
  List<NotificationConverter> notification;
   NotificationPage({required this.notification});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backButton(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
              child: Text(
                "Notifications",
                style: HeadingTextStyle
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.zero,
                itemCount: widget.notification.length,
                shrinkWrap: true,

                itemBuilder: (context, int index) {
                  final data = widget.notification[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    padding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex:2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.heading,
                                    style: TextStyle(fontSize: 20),
                                  ),

                                  Text(calculateTimeDifference(data.id))
                                ],
                              ),
                            ),
                            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(10),child: Image.network(data.image.first)))
                          ],
                        ),
                        Text(data.description),
                      ],
                    ),
                  );
                }),
if(!widget.notification.isNotEmpty)Center(child: Text("Empty"))
          ],
        ),
      ),
    );
  }
}
