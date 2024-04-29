import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../functions.dart';
import '../shopping/address.dart';
import '../test1.dart';

class UserConvertor {
  final String email;
  final String id;
  final String name;
  final String age;
  final String gender;
  final String occupation;
  final String phoneNumber;
  final List<AddressConvertor> addresses;

  UserConvertor({
    required this.email,
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.occupation,
    required this.phoneNumber,
    required this.addresses,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "id": id,
      "name": name,
      "age": age,
      "gender": gender,
      "occupation": occupation,
      "phone_number": phoneNumber,
      "addresses": addresses.map((address) => address.toJson()).toList(),
    };
  }

  static UserConvertor fromJson(Map<String, dynamic> json) {
    return UserConvertor(
      id: json['id'] ?? "",
      email: json['email'] ?? "",
      name: json['name'] ?? '',
      age: json['age'] ?? "",
      gender: json['gender'] ?? "",
      occupation: json['occupation'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
      addresses: AddressConvertor.fromMapList(json['addresses'] ?? []),
    );
  }

  static List<UserConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}




class AddressPreferences {
  static const String key = "address";

  static Future<void> save(List<AddressConvertor> subjects) async {
    final prefs = await SharedPreferences.getInstance();
    final subjectsJson = subjects.map((subject) => subject.toJson()).toList();
    final subjectsString = jsonEncode(subjectsJson);
    await prefs.setString(key, subjectsString);
  }

  // Get a list of subjects from shared preferences
  static Future<List<AddressConvertor>> get() async {
    final prefs = await SharedPreferences.getInstance();
    final subjectsString = prefs.getString(key);
    if (subjectsString != null) {
      final subjectsJson = jsonDecode(subjectsString) as List;
      return subjectsJson
          .map((json) => AddressConvertor.fromJson(json))
          .toList();
    } else {
      return [];
    }
  }

  // Add a new subject to shared preferences
  static Future<void> add(AddressConvertor newSubject) async {
    final List<AddressConvertor> subjects = await get();
    subjects.add(newSubject);
    await save(subjects);
  }

  // Set a subject as default
  static Future<void> makeItDefault(String id) async {
    final List<AddressConvertor> subjects = await get();

    for (var subject in subjects) {
      subject.defaultVal = (subject.id == id);
    }

    await save(subjects);
  }

  // Edit a subject in shared preferences
  static Future<void> edit(AddressConvertor editedSubject) async {
    final List<AddressConvertor> subjects = await get();

    // Find the subject to edit by its ID and replace it with the edited subject
    final index =
        subjects.indexWhere((subject) => subject.id == editedSubject.id);
    if (index != -1) {
      subjects[index] = editedSubject;
    }

    await save(subjects);
  }

  // Delete a subject from shared preferences
  static Future<void> delete(String subjectId) async {
    List<AddressConvertor> subjects = await get();
    subjects.removeWhere((subject) => subject.id == subjectId);
    await save(subjects);
  }
}

class AddressPage extends StatefulWidget {
  final Function(AddressConvertor) onChanged;

  const AddressPage({required this.onChanged});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  List<AddressConvertor> address = [];
 bool remove=false;
  getData() async {
    address = await AddressPreferences.get();
    for (AddressConvertor data in address) {
      if (data.defaultVal == true) {

          widget.onChanged(data);


      }
    }
    setState(() {
      address;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Shipping Address",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              Spacer(),
              InkWell(
                onTap: () async {
                  setState(() {
                    remove = true;
                  });
                },
                child: Text(
                  "Remove",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,color: Colors.red.withOpacity(0.8)),
                ),
              ),
              remove?InkWell(
                onTap: () async {
                  setState(() {
                    remove = false;
                  });
                },
                child: Text(
                  " Done ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ):InkWell(
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context)=>addressCreator()));
                  getData();
                },
                child: Text(
                  "   Add ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 5),
              shrinkWrap: true,
              itemCount: address.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, int index) {
                final data = address[index];
                return InkWell(
                  onTap: () async {
                    await AddressPreferences.makeItDefault(data.id);
                    await getData();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    margin: EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: data.defaultVal == true
                            ? Colors.greenAccent.withOpacity(0.3)
                            : remove?Colors.black.withOpacity(0.08):null),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(remove)Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                          Text(data.id,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                          InkWell(onTap: () async {
                            await AddressPreferences.delete(data.id);
                            getData();
                          },child: Icon(Icons.close,color: Colors.red.withOpacity(0.8),))
                        ],),
                        if (data.phone.isNotEmpty) Text(data.phone),
                        if (data.street1.isNotEmpty) Text(data.street1),
                        if (data.street2.isNotEmpty) Text(data.street2),
                        if (data.nearBy.isNotEmpty) Text(data.nearBy),
                        if (data.city.isNotEmpty) Text(data.city),
                        if (data.state.isNotEmpty) Text(data.state),
                        if (data.country.isNotEmpty) Text(data.country),
                        Row(
                          mainAxisAlignment: data.zip.isNotEmpty
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.end,
                          children: [
                            if (data.zip.isNotEmpty) Text(data.zip),
                            if (data.defaultVal)
                              Row(
                                children: [
                                  Text(
                                    "Default ",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
