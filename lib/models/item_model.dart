import 'package:flutter/foundation.dart';

class Item {
  final String name;
  final String description;
  final String rate;
  final String shopId;
  final String itemId;
  final String url;

  Item(
      {@required this.name,
      @required this.description,
      @required this.rate,
      @required this.shopId,
      @required this.itemId,
      @required this.url});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['itemName'] = this.name;
    map['description'] = this.description;
    map['rate'] = this.rate;
    map['shopId'] = this.shopId;
    map['itemId'] = this.itemId;
    map['imageUrl'] = this.url;

    return map;
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
        name: map['itemName'],
        description: map['description'],
        rate: map['rate'],
        shopId: map['shopId'],
        itemId: map['itemId'],
        url: map['imageUrl']);
  }
}
