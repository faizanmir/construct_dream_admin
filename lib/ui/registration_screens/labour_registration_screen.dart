import 'dart:io';

import 'package:construct_dream_admin/helpers/ui_helper.dart';
import 'package:construct_dream_admin/models/labour_model.dart';
import 'package:construct_dream_admin/services/auth_handler.dart';
import 'package:construct_dream_admin/services/firebase_service.dart';

import 'package:construct_dream_admin/ui/bottom_sheets/upload_bottom_sheet.dart';
import 'package:flutter/material.dart';
import "package:construct_dream_admin/helpers/ui_helper.dart" as uiHelper;
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:provider/provider.dart';

class LabourerRegistrationScreen extends StatefulWidget {
  final Labourer labourer;

  const LabourerRegistrationScreen({Key key, this.labourer}) : super(key: key);
  @override
  _LabourerRegistrationScreenState createState() =>
      _LabourerRegistrationScreenState();
}

class _LabourerRegistrationScreenState extends State<LabourerRegistrationScreen> {
  String tag = "labourer";
  String specialization;
  List<String> specialisations = new List();
  final fnController = TextEditingController();
  final lnController = TextEditingController();
  final emailController = TextEditingController();
  final pNoController = TextEditingController();
  final costPerDayController = TextEditingController();
  final stateController = TextEditingController();
  final districtController = TextEditingController();
  GeoFirePoint _geoFirePoint;

  @override
  void initState() {
    specialisations
      ..add("Plumber")
      ..add("Electrician")
      ..add("Labourer")
      ..add("Gate-Keeper");

    if (widget.labourer != null) {
      fnController.text = widget.labourer.firstName;
      lnController.text = widget.labourer.lastName;
      stateController.text = widget.labourer.state;
      districtController.text = widget.labourer.district;
      pNoController.text = widget.labourer.phoneNumber;
      costPerDayController.text = widget.labourer.costPerDay;
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context),
      backgroundColor: Colors.pink,
    );
  }

  Widget buildBody(BuildContext context) {
    Color dividerColor = Colors.lime;
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ListView(
        children: [
          Heading(
            heading: "Register Professional",
            color: Colors.white,
          ),
          Container(
            child: Card(
              elevation: 10,
              shadowColor: Colors.black38,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FieldDivider(
                    "Personal Details",
                    color: dividerColor,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DetailsTextField(
                          labelText: "First Name",
                          textInputType: TextInputType.text,
                          maxLines: 1,
                          controller: fnController),
                      SizedBox(
                        width: 10,
                      ),
                      DetailsTextField(
                          labelText: "Last Name",
                          textInputType: TextInputType.text,
                          maxLines: 1,
                          controller: lnController),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DetailsTextField(
                        labelText: "State",
                        textInputType: TextInputType.text,
                        controller: stateController,
                        maxLines: 1,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      DetailsTextField(
                          labelText: "District",
                          textInputType: TextInputType.text,
                          maxLines: 1,
                          controller: districtController),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DetailsTextField(
                          labelText: "Phone Number",
                          textInputType: TextInputType.phone,
                          maxLines: 1,
                          controller: pNoController)
                    ],
                  ),
                  FieldDivider(
                    "Choose specialization",
                    color: dividerColor,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton(
                        items: specialisations
                            .map<DropdownMenuItem<String>>(
                                (e) => _makeSpecializationTile(e))
                            .toList(),
                        value: specialization,
                        onChanged: (String value) {
                          print(value);
                          setState(() {
                            specialization = value;
                          });
                        },
                      ),
                    ],
                  ),
                  FieldDivider(
                    "All Done !!",
                    color: dividerColor,
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: uiHelper.makeCardView(
                        30,
                        MediaQuery.of(context).size.width / 1.5,
                        75,
                        Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w200),
                        ), () {

                        _makeAndUploadLabourer();

                    }),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _makeUploadBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) => UploadBottomSheet(
              onContinuePressed: () {
                Navigator.of(context).pop();
              },
            ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  _makeAndUploadLabourer() async {
    final _firebaseService =
        Provider.of<FirebaseService>(context, listen: false);
    _makeUploadBottomSheet();
    var url = (widget.labourer != null) ? widget.labourer.imageUrl : null;
    var labourer = Labourer(
        state: stateController.text.trim()..toLowerCase(),
        district: districtController.text.trim()..toLowerCase(),
        labourId: (widget.labourer != null)
            ? widget.labourer.labourId
            : DateTime.now().millisecondsSinceEpoch.toString(),
        lastName: lnController.text,
        firstName: fnController.text,
        tag: tag,
        costPerDay: costPerDayController.text,
        type: specialization,
        imageUrl: url,
        //geoFirePoint: _geoFirePoint,
        phoneNumber: pNoController.text);
    (widget.labourer != null)
        ? _firebaseService.updateLabourer(labourer)
        : _firebaseService.uploadData(data: labourer);
  }

  DropdownMenuItem<String> _makeSpecializationTile(String spec) {
    return DropdownMenuItem<String>(
      value: spec,
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        child: ListTile(
          title: Text(
            spec,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
