import 'package:construct_dream_admin/helpers/ui_helper.dart';
import 'package:construct_dream_admin/models/architect_model_.dart';
import 'package:construct_dream_admin/services/firebase_service.dart';
import 'package:construct_dream_admin/ui/bottom_sheets/upload_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import 'package:place_picker/place_picker.dart';
import 'package:provider/provider.dart';

class ArchitectRegistrationScreen extends StatefulWidget {
  final Architect architect;
  const ArchitectRegistrationScreen({Key key, this.architect})
      : super(key: key);
  @override
  _ArchitectRegistrationScreenState createState() =>
      _ArchitectRegistrationScreenState();
}

class _ArchitectRegistrationScreenState
    extends State<ArchitectRegistrationScreen> {
  String tag = "architect";
  List<String> chipList = List<String>();
  bool locationAcquired = false;
  GeoFirePoint geoFirePoint;
  bool hasSelectedLocation = false;
  String address;

  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final pnoController = TextEditingController();
  final onameController = TextEditingController();
  final descripController = TextEditingController();
  final perSquareMeterController = TextEditingController();
  final emailController = TextEditingController();
  final stateController = TextEditingController();
  final districtController = TextEditingController();


  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    chipList.add("Cement");
    chipList.add("Iron");
    chipList.add("Hardware");

    if (widget.architect != null) {
      fnameController.text = widget.architect.firstName;
      lnameController.text = widget.architect.lastName;
      pnoController.text = widget.architect.phoneNumer;
      onameController.text = widget.architect.organizationName;
      descripController.text = widget.architect.getDescription();
      perSquareMeterController.text = widget.architect.costPerSquareMeter;
      emailController.text = widget.architect.email;
      stateController.text = widget.architect.state;
      districtController.text = widget.architect.district;
      if (widget.architect.address != null) {
        address = widget.architect.address;
        hasSelectedLocation = true;
      }
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
        backgroundColor: Colors.green,
        body: Padding(
            padding: EdgeInsets.all(15),
            child: ListView(
              children: [
                Heading(
                  heading: "Register Architect",
                  color: Colors.white,
                ),
                buildBody(context)
              ],
            )));
  }

  Widget buildBody(BuildContext context) {
    return Container(
      child: Card(
        elevation: 10,
        shadowColor: Colors.black38,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FieldDivider("Personal Details"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DetailsTextField(
                  labelText: "First Name",
                  textInputType: TextInputType.text,
                  controller: fnameController,
                  maxLines: 1,
                ),
                SizedBox(
                  width: 10,
                ),
                DetailsTextField(
                    labelText: "Last Name",
                    textInputType: TextInputType.text,
                    maxLines: 1,
                    controller: lnameController),
              ],
            ),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: [
//                DetailsTextField(
//                  labelText: "State",
//                  textInputType: TextInputType.text,
//                  controller: stateController,
//                  maxLines: 1,
//                ),
//                SizedBox(
//                  width: 10,
//                ),
//                DetailsTextField(
//                    labelText: "District",
//                    textInputType: TextInputType.text,
//                    maxLines: 1,
//                    controller: districtController),
//              ],
//            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DetailsTextField(
                    labelText: "Phone Number",
                    textInputType: TextInputType.phone,
                    maxLines: 1,
                    controller: pnoController)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DetailsTextField(
                    labelText: "Email",
                    textInputType: TextInputType.text,
                    maxLines: 1,
                    controller: emailController)
              ],
            ),
            FieldDivider("Description"),
            Row(
              children: [
                DetailsTextField(
                    labelText: "Organization Name",
                    textInputType: TextInputType.text,
                    maxLines: 1,
                    controller: onameController),
              ],
            ),
            FieldDivider("Choose shop location"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (!hasSelectedLocation && widget.architect == null)
                    ? RaisedButton(
                        color: Colors.blue,
                        child: Text(
                          "Select Location",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w200,
                              fontSize: 20),
                        ),
                        onPressed: () async {
                          getLocationFromMaps();
                        },
                      )
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FlatButton(
                            onPressed: () {
                              getLocationFromMaps();
                            },
                            child: Card(
                                elevation: 2,
                                shadowColor: Colors.blue,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    address,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 20),
                                  ),
                                )),
                          ),
                        ),
                      )
              ],
            ),
            FieldDivider("All Done !!"),
            Padding(
              padding: EdgeInsets.all(15),
              child: makeCardView(
                  30,
                  MediaQuery.of(context).size.width / 1.5,
                  75,
                  (widget.architect == null)
                      ? Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w200),
                        )
                      : Text(
                          "Update",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w200),
                        ), () {
                  _makeAndUploadArchitect();
              }),
            )
          ],
        ),
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

  _makeAndUploadArchitect() async {
    final _firebaseService =
        Provider.of<FirebaseService>(context, listen: false);

    if (address != null && geoFirePoint != null) {
      _makeUploadBottomSheet();

      var id = (widget.architect == null)
          ? DateTime.now().millisecondsSinceEpoch.toString()
          : widget.architect.getId();
      var url =
          (widget.architect == null) ? null : widget.architect.getImageUrl();
      var architect = Architect(
        state: stateController.text.toLowerCase(),
        district: districtController.text.toLowerCase(),
        location: geoFirePoint,
        email: emailController.text,
        architectId: id,
        description: descripController.text,
        organizationName: onameController.text,
        tag: tag,
        firstName: fnameController.text,
        lastName: lnameController.text,
        costPerSquareMeter: perSquareMeterController.text,
        imageUrl: url,
        phoneNumer: pnoController.text,
        address: address,
      );

      (widget.architect == null)
          ? _firebaseService.uploadData(data: architect)
          : _firebaseService.updateArchitect(architect);
    } else {
      Fluttertoast.showToast(
          msg: "Please select an address",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }
  }

  @override
  void dispose() {
    fnameController.dispose();
    lnameController.dispose();
    pnoController.dispose();
    descripController.dispose();
    onameController.dispose();
    super.dispose();
  }

  getLocationFromMaps() async {
    // LocationResult result = await showLocationPicker(
    //   context,
    //   "AIzaSyA1ml9AksOYdWWMskIJ0IYqRuJ773SGUX8",
    //   automaticallyAnimateToCurrentLocation: true,
    //   myLocationButtonEnabled: true,
    // );
    LocationResult result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            PlacePicker(
                "AIzaSyA1ml9AksOYdWWMskIJ0IYqRuJ773SGUX8"),
      ),
    );

    if (result != null) {
      geoFirePoint =
      new GeoFirePoint(result.latLng.latitude, result.latLng.longitude);
      // landmark = result.locality;
      // print(landmark);
      setState(() {
        hasSelectedLocation = true;
      });
    } else {
      setState(() {
        hasSelectedLocation = false;
      });
    }
  }
}
