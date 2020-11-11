
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:construct_dream_admin/base/list_item_base.dart';
import 'package:construct_dream_admin/base/base_people.dart';

class Labourer implements ListItem,People{
  final String type;
  final String tag;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String costPerDay;
  final String labourId;
  //final GeoFirePoint geoFirePoint;
  final String state;
  final String district;
  final String imageUrl;

  Labourer(
      {this.imageUrl,
      this.state,
      this.district,
      this.type,
      this.tag,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.costPerDay,
     // this.geoFirePoint,
      this.labourId});

  factory Labourer.fromMap(Map<String, dynamic> map) {
    return new Labourer(
      type: map['type'] as String,
      tag: map['tag'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      costPerDay: map['costPerDay'] as String,
      labourId: map['labourId'] as String,
      //geoFirePoint: map['geoFirePoint'] as GeoFirePoint,
      state: map['state'] as String,
      district: map['district'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'type': this.type,
      'tag': this.tag,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'phoneNumber': this.phoneNumber,
      'costPerDay': this.costPerDay,
      'labourId': this.labourId,
      //'location': this.geoFirePoint.data,
      'state': this.state,
      'district': this.district,
      'imageUrl': this.imageUrl,
    } as Map<String, dynamic>;
  }

  @override
  Widget buildListItem(context) {
    return InkWell(
      onTap: (){
        //Navigator.of(context).push(MaterialPageRoute(builder:(_)=> LabourerCallCard(personId: this.labourId,)));
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
                  backgroundImage: (this.imageUrl == null)
                      ? AssetImage("images/labourer.png")
                      : NetworkImage(this.imageUrl),
                ),
              ),
              Text(
                this.firstName,
                style: TextStyle(fontWeight: FontWeight.w300,fontSize: 20),
              ),
              Text(this.type)
            ],
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

  @override
  String getDescription() => "No description";

  @override
  String getName() =>this.firstName;

  @override
  String getType() {
    return this.tag;
  }
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
   return this.type;
  }
  @override
  String getId() =>this.labourId;
}
