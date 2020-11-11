import 'package:geoflutterfire/geoflutterfire.dart';
class User {
  final String firstName;
  final String lastName;
  final String email;
  final GeoFirePoint geoFirePoint;
  final String userId;
  final String imageUrl;
  final String tag;
  User( {this.firstName, this.lastName, this.email, this.geoFirePoint, this.userId,this.imageUrl,this.tag,});


  Map<String,dynamic> toMap()
  {
    Map map = new Map<String,dynamic>();
    map['firstName'] = this.firstName;
    map['lastName'] =  this.lastName;
    map['email'] =  this.email;
    map['location'] =  this.geoFirePoint.data;
    map['userId']  =  this.userId;
    map['imageUrl'] =  this.imageUrl;
    map['tag'] = this.tag;
    return map;
  }


}