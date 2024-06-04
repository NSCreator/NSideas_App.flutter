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
                controller: phoneNoController,
                hintText: 'Phone Number (+91 only)',

                heading: "Phone Number (+91 only)",),

              TextFieldContainer(
                controller: street1Controller,
                hintText: 'Street 1',


                heading: "Street 1",
              ),
                TextFieldContainer(
                  controller: Street2Controller,
                  hintText: 'Street 2',
                  heading: "Street 2",),

                TextFieldContainer(
                  controller: NearByController,
                  hintText: 'Near By',

                   heading: "Near By",),

                TextFieldContainer(
                  controller: cityController,
                  hintText: 'City',

                  heading: "City",),
                TextFieldContainer(
                  controller: stateController,
                  hintText: 'State',

                   heading: "State",),
              TextFieldContainer(
                controller: zipController,
                hintText: 'zip',
                heading: "zip",),
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
