import 'dart:io';
import 'package:construct_dream_admin/models/store_model.dart';
import 'package:construct_dream_admin/services/firebase_service.dart';
import 'package:construct_dream_admin/ui/bottom_sheets/upload_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:construct_dream_admin/helpers/ui_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';


import 'package:provider/provider.dart';

enum SellerType { isRetailer, isWholesaler, none, isBoth }

class ShopRegisterScreen extends StatefulWidget {
  final Store store;
  const ShopRegisterScreen({Key key, this.store}) : super(key: key);
  @override
  _ShopRegisterScreenState createState() => _ShopRegisterScreenState();
}

class _ShopRegisterScreenState extends State<ShopRegisterScreen> {
  String tag = "shop";
  List<String> categories = List<String>();
  bool locationAcquired = false;
  File file;
  String landmark;
  GeoFirePoint geoFirePoint;
  bool hasSelectedLocation = false;
  String shopCategory;
  bool isRetailer = false;
  List<String> shopCategoryList = ["Retailer", "Wholesaler", "Both"];
  SellerType sellerType = SellerType.none;

  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final pnoController = TextEditingController();
  final snameController = TextEditingController();
  final descripController = TextEditingController();
  final emailController = TextEditingController();
  final stateController = TextEditingController();
  final districtController = TextEditingController();

  bool isCementSelected = false,
      isSteelSelected = false,
      isOtherSelected = false,
      isConcreteSelected = false,
      isFrameSelected = false,
      isBrickSelected = false,
      isShutteringSelected = false;
  List<String> selectedCategories = new List();

  var addressController = TextEditingController();

  @override
  void initState() {
    //"Cement", "Steel", "Concrete", "Frame", "Brick"

    categories
      ..add("Cement")
      ..add("Steel")
      ..add("Concrete")
      ..add("Frame")
      ..add("Brick")
      ..add("Other")
      ..add("Shuttering");

    if (widget.store != null) {
      fnameController.text = widget.store.firstName;
      lnameController.text = widget.store.lastName;
      pnoController.text = widget.store.phoneNumber;
      descripController.text = widget.store.getDescription();
      snameController.text = widget.store.shopName;
      stateController.text = widget.store.state;
      districtController.text = widget.store.district;
      emailController.text = widget.store.email;
      addressController.text = widget.store.address;
      if (widget.store.address != null) {
        landmark = widget.store.landmark;
        hasSelectedLocation = true;
      }

      if (widget.store.sellerCategory == shopCategoryList[0]) {
        shopCategory = shopCategoryList[0];
      } else if (widget.store.sellerCategory == shopCategoryList[1]) {
        shopCategory = shopCategoryList[1];
      } else {
        shopCategory = shopCategoryList[2];
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Padding(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: [
              Heading(
                heading: "Register your shop",
                color: Colors.white,
              ),
              buildBody(context)
            ],
          )),
    );
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
                    maxLines: 1,
                    controller: fnameController),
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
            FieldDivider("Shop Description"),
            Row(
              children: [
                DetailsTextField(
                    labelText: "Shop Name",
                    textInputType: TextInputType.text,
                    maxLines: 1,
                    controller: snameController),
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
              children: [
                DetailsTextField(
                    labelText: "Address",
                    textInputType: TextInputType.text,
                    maxLines: 1,
                    controller: addressController),
              ],
            ),
            FieldDivider("Choose landmark"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (!hasSelectedLocation)
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
                                    landmark,
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
            FieldDivider("Categories"),
            Wrap(spacing: 3, children: [
              ChoiceChip(
                  disabledColor: Colors.grey,
                  label: Text(
                    "Cement",
                    style: TextStyle(color: Colors.white),
                  ),
                  selected: isCementSelected,
                  onSelected: (val) async {
                    if (val) {
                      selectedCategories
                          .add(categories[0].trim().toLowerCase());
                    } else {
                      selectedCategories
                          .remove(categories[0].trim().toLowerCase());
                    }
                    setState(() {
                      isCementSelected = val;
                    });
                  },
                  selectedColor: Colors.pink),

              ChoiceChip(
                label: Text("Steel", style: TextStyle(color: Colors.white)),
                selected: isSteelSelected,
                onSelected: (val) {
                  if (val) {
                    selectedCategories.add(categories[1].trim().toLowerCase());
                  } else {
                    selectedCategories
                        .remove(categories[1].trim().toLowerCase());
                  }
                  setState(() {
                    isSteelSelected = val;
                  });
                },
                selectedColor: Colors.pink,
              ),
              ChoiceChip(
                label: Text("Concrete", style: TextStyle(color: Colors.white)),
                selected: isConcreteSelected,
                onSelected: (val) {
                  if (val) {
                    selectedCategories.add(categories[2].trim().toLowerCase());
                  } else {
                    selectedCategories
                        .remove(categories[2].trim().toLowerCase());
                  }
                  setState(() {
                    isConcreteSelected = val;
                  });
                },
                selectedColor: Colors.pink,
              ),
              ChoiceChip(
                  label: Text("Frame", style: TextStyle(color: Colors.white)),
                  selected: isFrameSelected,
                  onSelected: (val) {
                    if (val) {
                      selectedCategories
                          .add(categories[3].trim().toLowerCase());
                    } else {
                      selectedCategories
                          .remove(categories[3].trim().toLowerCase());
                    }
                    setState(() {
                      isFrameSelected = val;
                    });
                  },
                  selectedColor: Colors.pink),
              ChoiceChip(
                  label: Text("Brick", style: TextStyle(color: Colors.white)),
                  selected: isBrickSelected,
                  onSelected: (val) {
                    if (val) {
                      selectedCategories
                          .add(categories[4].trim().toLowerCase());
                    } else {
                      selectedCategories
                          .remove(categories[4].trim().toLowerCase());
                    }
                    setState(() {
                      isBrickSelected = val;
                    });
                  },
                  selectedColor: Colors.pink),
              ChoiceChip(
                  label: Text("Other", style: TextStyle(color: Colors.white)),
                  selected: isOtherSelected,
                  onSelected: (val) {
                    if (val) {
                      selectedCategories
                          .add(categories[5].trim().toLowerCase());
                    } else {
                      selectedCategories
                          .remove(categories[5].trim().toLowerCase());
                    }
                    setState(() {
                      isOtherSelected = val;
                    });
                  },
                  selectedColor: Colors.pink),
              ChoiceChip(
                  label:
                      Text("Shuttering", style: TextStyle(color: Colors.white)),
                  selected: isShutteringSelected,
                  onSelected: (val) {
                    if (val) {
                      selectedCategories
                          .add(categories[6].trim().toLowerCase());
                    } else {
                      selectedCategories
                          .remove(categories[6].trim().toLowerCase());
                    }
                    setState(() {
                      isShutteringSelected = val;
                    });
                  },
                  selectedColor: Colors.pink)
              //("Frame", isFrameSelected)
            ]),
            FieldDivider("Select category"),
            DropdownButton(
              value: shopCategory,
              onChanged: (value) {
                setState(() {
                  shopCategory = value;
                });
              },
              items: shopCategoryList
                  .map(
                    (e) => DropdownMenuItem(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: ListTile(
                          title: Text(e),
                        ),
                      ),
                      value: e,
                    ),
                  )
                  .toList(),
            ),
            FieldDivider("All Done !!"),
            Padding(
              padding: EdgeInsets.all(15),
              child: makeCardView(
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
                _makeAndUploadStore();
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

  _makeAndUploadStore() async {
    final _firebaseService =
        Provider.of<FirebaseService>(context, listen: false);

    var shopId, imageUrl;

    if (widget.store == null) {
      shopId = DateTime.now().millisecondsSinceEpoch.toString();
      imageUrl = null;
    } else {
      shopId = widget.store.shopId;
      imageUrl = widget.store.imageUrl;
    }

    if (landmark != null && geoFirePoint != null) {
      _makeUploadBottomSheet();
      if (sellerType == SellerType.isRetailer ||
          sellerType == SellerType.none) {
        isRetailer = true;
      } else {
        isRetailer = false;
      }

      var store = Store(
        email: emailController.text,
        shopId: shopId,
        description: descripController.text,
        shopName: snameController.text,
        vendorType: selectedCategories,
        tag: tag,
        firstName: fnameController.text,
        lastName: lnameController.text,
        district: districtController.text.toLowerCase(),
        state: stateController.text.toLowerCase(),
        phoneNumber: pnoController.text,
        imageUrl: imageUrl,
        address: addressController.text,
        location: geoFirePoint.data,
        canSell: false,
        landmark: landmark,
        sellerCategory: shopCategory,
        gstin: null,
      );

      (widget.store == null)
          ? _firebaseService.uploadData(data: store)
          : _firebaseService.updateShop(store);
    } else {
      Fluttertoast.showToast(
          msg: "Please select a landmark for the shop",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }
  }

  Widget makeChips(String chipText, bool selected) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ChoiceChip(
        label: Text(chipText),
        selected: selected,
        onSelected: (val) {},
        labelStyle: TextStyle(color: Colors.white),
        avatar: CircleAvatar(
          child: Text(chipText.substring(0, 1)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    fnameController.dispose();
    lnameController.dispose();
    pnoController.dispose();
    descripController.dispose();
    snameController.dispose();
    stateController.dispose();
    districtController.dispose();
    addressController.dispose();
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
                "AIzaSyBuW_HLahqAS3xXIEXKprVCzrvifWisXS8"),
      ),
    );

    if (result != null) {
      geoFirePoint =
          new GeoFirePoint(result.latLng.latitude, result.latLng.longitude);
      landmark = result.locality;
      print(landmark);
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
