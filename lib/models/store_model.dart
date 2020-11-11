import 'package:construct_dream_admin/base/list_item_base.dart';
import 'package:construct_dream_admin/base/base_people.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class Store implements ListItem,People{

  final dynamic location;
  final String email;
  final String shopId;
  final String tag;
  final String imageUrl;
  final String firstName;
  final String lastName;
  final String description;
  final String shopName;
  final List<dynamic> vendorType;
  final String state;
  final String district;
  final String phoneNumber;
  final String address;
  final String gstin;
  final String sellerCategory;
  final bool canSell;
  final int registrationPriority;
  final String landmark;

  //<editor-fold desc="Data Methods" defaultstate="collapsed">

  const Store({
    @required this.location,
    @required this.email,
    @required this.shopId,
    @required this.tag,
    @required this.imageUrl,
    @required this.firstName,
    @required this.lastName,
    @required this.description,
    @required this.shopName,
    @required this.vendorType,
    @required this.state,
    @required this.district,
    @required this.phoneNumber,
    @required this.address,
    @required this.gstin,
    @required this.sellerCategory,
    @required this.canSell,
    this.registrationPriority  =2 ,
    @required this.landmark,
  });

  factory Store.fromMap(Map<String, dynamic> map) {
    return new Store(
      location: map['location'] as dynamic,
      email: map['email'] as String,
      shopId: map['shopId'] as String,
      tag: map['tag'] as String,
      imageUrl: map['imageUrl'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      description: map['description'] as String,
      shopName: map['shopName'] as String,
      vendorType: map['vendorType'] as List<dynamic>,
      state: map['state'] as String,
      district: map['district'] as String,
      phoneNumber: map['phoneNumber'] as String,
      address: map['address'] as String,
      gstin: map['gstin'] as String,
      sellerCategory: map['sellerCategory'] as String,
      canSell: map['canSell'] as bool,
      registrationPriority: map['registrationPriority'] as int,
      landmark: map['landmark'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'location': this.location,
      'email': this.email,
      'shopId': this.shopId,
      'tag': this.tag,
      'imageUrl': this.imageUrl,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'description': this.description,
      'shopName': this.shopName,
      'vendorType': this.vendorType,
      'state': this.state,
      'district': this.district,
      'phoneNumber': this.phoneNumber,
      'address': this.address,
      'gstin': this.gstin,
      'sellerCategory': this.sellerCategory,
      'canSell': this.canSell,
      'registrationPriority': this.registrationPriority,
      'landmark': this.landmark,
    } as Map<String, dynamic>;
  }

  @override
  Widget buildListItem(context) {
    return InkWell(
      onTap: (){
       // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ShopCallCard(shopId: this.shopId,)));
      },
      child: GridTile(
        child: Card(
          elevation: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 100,
                width: 100,
                child: CircleAvatar(
                backgroundImage: (this.imageUrl == null)?AssetImage("images/shop.png"):NetworkImage(this.imageUrl),
            ),
              ), Text(this.shopName,style:TextStyle(fontWeight: FontWeight.w300,fontSize: 20),)],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  //<editor-fold desc="Data Methods" defaultstate="collapsed">



  //</editor-fold>

  @override
  String getDescription()=>this.description;

  @override
  String getName() =>this.shopName;

  @override
  String getType() => this.tag;

  @override
  String getImageUrl() {
    return this.imageUrl;
  }

  @override
  String getPhoneNumber() {
    return this.phoneNumber;
  }

  @override
  String getProfession() {
   return "Shop";
  }

  @override
  String getId() =>this.shopId;



}
