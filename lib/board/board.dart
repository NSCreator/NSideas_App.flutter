import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nsideas/board/sub_page.dart';

import '../functions.dart';
import 'converter.dart';

class Boards extends StatelessWidget {
  String boardName;
  List<BoardsConverter> boards;

  Boards({required this.boardName, required this.boards});

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
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
              child: Text(
                "Boards",
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: boards.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                final SubjectsData = boards[index];

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
                          child: SubjectsData.images.isNotEmpty
                              ? ImageShowAndDownload(
                                  image: SubjectsData.images.first,
                                  id: SubjectsData.id,
                                )
                              : Text("No Image",style: TextStyle(color: Colors.black.withOpacity(0.15),fontSize: 20),),
                        ),
                      ),
                      Text(
                        SubjectsData.heading.full,
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
                            arduinoBoard(
                          data: SubjectsData,
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
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
          ],
        ),
      ),
    );
  }
}
