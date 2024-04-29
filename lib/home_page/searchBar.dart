// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:nsideas/project_files/sub_page.dart';
import 'package:nsideas/project_files/projects_test.dart';
import '../functions.dart';

class searchBar extends StatefulWidget {
  List<ProjectConverter> projects;

  searchBar({required this.projects});

  @override
  State<searchBar> createState() => _searchBarState();
}

class _searchBarState extends State<searchBar> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: InkWell(
                  child: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: TextFieldContainer(
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.search,
                          size: 25,
                          color: Colors.black54,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: (val) {
                            setState(() {
                              name = val;
                            });
                          },
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search Bar',
                              hintStyle: TextStyle(color: Colors.black54),
                              labelStyle: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (name.isNotEmpty)
                InkWell(
                  onTap: () {
                    setState(() {
                      name = "";
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 10,
                    ),
                    child: Icon(
                      Icons.clear,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                )
            ],
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
                itemCount: widget.projects.length,
                itemBuilder: (context, int index) {
                  final data = widget.projects[index];
                  return data.heading.short
                              .toLowerCase()
                              .contains(name.toLowerCase()) ||
                          data.heading.full
                              .toLowerCase()
                              .contains(name.toLowerCase()) ||
                          data.tags.contains(name.toUpperCase())
                      ? InkWell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                if (data.images.isNotEmpty)
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: 55,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              data.images.first.file_url),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.heading.short,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      data.heading.full,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Project(data: data)));
                          },
                        )
                      : Container();
                }),
          ),
        ],
      ),
    ));
  }
}
