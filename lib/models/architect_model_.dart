
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:construct_dream_admin/base/base_people.dart';

class Architect implements People{
  final dynamic location;
  final String email;
  final String architectId;
  final String tag;
  final String imageUrl;
  final String firstName;
  final String lastName;
  final String description;
  final String organizationName;
  final String costPerSquareMeter;
  final String state;
  final String district;
  final String phoneNumer;
  final String address;

  //<editor-fold desc="Data Methods" defaultstate="collapsed">

  const Architect({
    @required this.location,
    @required this.email,
    @required this.architectId,
    @required this.tag,
    @required this.imageUrl,
    @required this.firstName,
    @required this.lastName,
    @required this.description,
    @required this.organizationName,
    @required this.costPerSquareMeter,
    @required this.state,
    @required this.district,
    @required this.phoneNumer,
    @required this.address,
  });

  Architect copyWith({
    dynamic location,
    String email,
    String architectId,
    String tag,
    String imageUrl,
    String firstName,
    String lastName,
    String description,
    String organizationName,
    String costPerSquareMeter,
    String state,
    String district,
    String phoneNumer,
    String address,
  }) {
    if ((location == null || identical(location, this.location)) &&
        (email == null || identical(email, this.email)) &&
        (architectId == null || identical(architectId, this.architectId)) &&
        (tag == null || identical(tag, this.tag)) &&
        (imageUrl == null || identical(imageUrl, this.imageUrl)) &&
        (firstName == null || identical(firstName, this.firstName)) &&
        (lastName == null || identical(lastName, this.lastName)) &&
        (description == null || identical(description, this.description)) &&
        (organizationName == null ||
            identical(organizationName, this.organizationName)) &&
        (costPerSquareMeter == null ||
            identical(costPerSquareMeter, this.costPerSquareMeter)) &&
        (state == null || identical(state, this.state)) &&
        (district == null || identical(district, this.district)) &&
        (phoneNumer == null || identical(phoneNumer, this.phoneNumer)) &&
        (address == null || identical(address, this.address))) {
      return this;
    }

    return new Architect(
      location: location ?? this.location,
      email: email ?? this.email,
      architectId: architectId ?? this.architectId,
      tag: tag ?? this.tag,
      imageUrl: imageUrl ?? this.imageUrl,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      description: description ?? this.description,
      organizationName: organizationName ?? this.organizationName,
      costPerSquareMeter: costPerSquareMeter ?? this.costPerSquareMeter,
      state: state ?? this.state,
      district: district ?? this.district,
      phoneNumer: phoneNumer ?? this.phoneNumer,
      address: address ?? this.address,
    );
  }

  @override
  String toString() {
    return 'Architect{location: $location, email: $email, architectId: $architectId, tag: $tag, imageUrl: $imageUrl, firstName: $firstName, lastName: $lastName, description: $description, organizationName: $organizationName, costPerSquareMeter: $costPerSquareMeter, state: $state, district: $district, phoneNumer: $phoneNumer, address: $address}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Architect &&
          runtimeType == other.runtimeType &&
          location == other.location &&
          email == other.email &&
          architectId == other.architectId &&
          tag == other.tag &&
          imageUrl == other.imageUrl &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          description == other.description &&
          organizationName == other.organizationName &&
          costPerSquareMeter == other.costPerSquareMeter &&
          state == other.state &&
          district == other.district &&
          phoneNumer == other.phoneNumer &&
          address == other.address);

  @override
  int get hashCode =>
      location.hashCode ^
      email.hashCode ^
      architectId.hashCode ^
      tag.hashCode ^
      imageUrl.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      description.hashCode ^
      organizationName.hashCode ^
      costPerSquareMeter.hashCode ^
      state.hashCode ^
      district.hashCode ^
      phoneNumer.hashCode ^
      address.hashCode;

  factory Architect.fromMap(Map<String, dynamic> map) {
    return new Architect(
      location: map['location'] as dynamic,
      email: map['email'] as String,
      architectId: map['architectId'] as String,
      tag: map['tag'] as String,
      imageUrl: map['imageUrl'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      description: map['description'] as String,
      organizationName: map['organizationName'] as String,
      costPerSquareMeter: map['costPerSquareMeter'] as String,
      state: map['state'] as String,
      district: map['district'] as String,
      phoneNumer: map['phoneNumer'] as String,
      address: map['address'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'location': this.location.data,
      'email': this.email,
      'architectId': this.architectId,
      'tag': this.tag,
      'imageUrl': this.imageUrl,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'description': this.description,
      'organizationName': this.organizationName,
      'costPerSquareMeter': this.costPerSquareMeter,
      'state': this.state,
      'district': this.district,
      'phoneNumer': this.phoneNumer,
      'address': this.address,
    } as Map<String, dynamic>;
  }

  //</editor-fold>

  @override
  Widget buildListItem(BuildContext context) {
    return InkWell(
      splashColor: Colors.blue,
      onTap: (){
      // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ArchitectCallCard(architectId:this.architectId)));
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
                  backgroundImage: (this.imageUrl == null)?AssetImage("images/architect.png"):NetworkImage(this.imageUrl),
                ),
              ), Text(this.organizationName,style:TextStyle(fontWeight: FontWeight.w200,fontSize: 20))],
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
  String getDescription() {
    return this.description;
  }

  @override
  String getName() {
    return this.organizationName;
  }

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
   return this.phoneNumer;
  }

  @override
  String getProfession() {
    return "architect";
  }

  @override
  String getId() =>this.architectId;


}
