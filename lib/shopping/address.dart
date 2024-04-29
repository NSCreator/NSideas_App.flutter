import 'package:flutter/material.dart';

import '../functions.dart';
import '../settings/user_convertor.dart';
import '../test1.dart';

class addressCreator extends StatefulWidget {
  const addressCreator({super.key});

  @override
  State<addressCreator> createState() => _addressCreatorState();
}

class _addressCreatorState extends State<addressCreator> {
  final street1Controller = TextEditingController();
  final Street2Controller = TextEditingController();
  final phoneNoController = TextEditingController();
  final NearByController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              backButton(),
              TextFieldContainer(
                child: TextFormField(
                  controller: phoneNoController,
                  textInputAction: TextInputAction.next,
                  style: textFieldStyle(),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Phone Number (+91 only)',
                      hintStyle: textFieldHintStyle()),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),heading: "Phone Number (+91 only)",),

              TextFieldContainer(
                child: TextFormField(
                  controller: street1Controller,

                  textInputAction: TextInputAction.next,
                  style: textFieldStyle(),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Street 1',
                      hintStyle: textFieldHintStyle()),

                ),
                heading: "Street 1",
              ),
                TextFieldContainer(
                    child: TextFormField(
                      controller: Street2Controller,
                      textInputAction: TextInputAction.next,
                      style: textFieldStyle(),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Street 2',
                          hintStyle: textFieldHintStyle()),
                    ),heading: "Street 2",),

                TextFieldContainer(
                    child: TextFormField(
                      controller: NearByController,
                      textInputAction: TextInputAction.next,
                      style: textFieldStyle(),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Near By',
                          hintStyle: textFieldHintStyle()),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),heading: "Near By",),

                TextFieldContainer(
                  child: TextFormField(
                    controller: cityController,
                    textInputAction: TextInputAction.next,
                    style: textFieldStyle(),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'City',
                        hintStyle: textFieldHintStyle()),
                  ),heading: "City",),
                TextFieldContainer(
                    child: TextFormField(
                      controller: stateController,
                      textInputAction: TextInputAction.next,
                      style: textFieldStyle(),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'State',
                        hintStyle: textFieldHintStyle(),
                      ),

                    ),heading: "State",),
              TextFieldContainer(
                    child: TextFormField(
                      controller: zipController,
                      textInputAction: TextInputAction.next,
                      style: textFieldStyle(),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'zip',
                        hintStyle: textFieldHintStyle(),
                      ),

                    ),heading: "zip",),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Text('cancel ', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await AddressPreferences.add(AddressConvertor(street1: street1Controller.text, id: getID(), city: cityController.text, state: stateController.text, zip: zipController.text, nearBy: NearByController.text, country: "India", phone: phoneNoController.text,street2: Street2Controller.text));
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Text(
                          'ADD Address',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }

}
