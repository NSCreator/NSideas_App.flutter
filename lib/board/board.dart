import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nsideas/board/sub_page.dart';

import '../functions.dart';
import '../home_page/home_page.dart';
import 'converter.dart';
import 'creator.dart';

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
                  color: Colors.white,
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
                final data = boards[index];

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
                            Board(
                          data: data,
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
