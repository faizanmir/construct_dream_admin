import 'package:flutter/material.dart';
abstract class ListItem{
  Widget buildListItem(BuildContext context);
  String getName();
  String getDescription();
  String getType();
  String getImageUrl();
  String getId();
}

