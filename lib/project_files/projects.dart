import 'package:flutter/material.dart';
import 'package:nsideas/project_files/sub_page.dart';
import 'package:nsideas/project_files/projects_test.dart';
import 'package:nsideas/sensors/sub_page.dart';

import '../functions.dart';
import '../home_page/home_page.dart';
import '../shopping/shopping_page.dart';


class Projects extends StatefulWidget {
  List<ProjectConverter> projects;
  Projects({required this.projects});
  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backButton(),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
              child: Text("Projects", style: HeadingTextStyle),
            ),

            widget.projects.isNotEmpty?ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, int index) {
                  final data = widget.projects[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Project(data: data)));
                    },
                    child: projectShowingContainer(data: data,),
                  );

                },
                itemCount: widget.projects.length): Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(

                  children: [
                    Icon(Icons.smart_toy_outlined,color: Colors.black,size: 50,),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
