import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';



enum ItemCategory{
  none,
  bricks,
  steel,
  cement,
  frame,
  concrete,
  other,
}


enum ItemEntryStatus{
  done,
  pending,
}

class ItemSelectionService with ChangeNotifier{
  ItemCategory _itemCategory  = ItemCategory.none;

  ItemCategory get itemCategory => _itemCategory;


  ItemEntryStatus _itemEntryStatus = ItemEntryStatus.pending;


  set itemCategory(ItemCategory value) {
    _itemCategory = value;
    notifyListeners();
  }

  ItemEntryStatus get itemEntryStatus => _itemEntryStatus;

  set itemEntryStatus(ItemEntryStatus value) {
    _itemEntryStatus = value;
    notifyListeners();
  }
}