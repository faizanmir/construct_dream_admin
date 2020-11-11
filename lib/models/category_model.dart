import 'package:flutter/foundation.dart';

class Category  {
  final String _imagePath;
  final String _name;
  final String _description;
  final String _categoryIdentifier;

  Category(this._imagePath, this._name, this._description, this._categoryIdentifier);

  String get imagePath => _imagePath;

  String get name => _name;

  String get description => _description;

  String get categoryIdentifier => _categoryIdentifier;
}