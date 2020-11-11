import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construct_dream_admin/base/base_people.dart';
import 'package:construct_dream_admin/models/architect_model_.dart';
import 'package:construct_dream_admin/models/labour_model.dart';
import 'package:construct_dream_admin/models/store_model.dart';

import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

enum DataFetchStatus { onInitiate, onSuccess, onError, onComplete, inProcess }

class FirebaseService with ChangeNotifier {
  Firestore _firestore = Firestore.instance;

  Firestore get firestore => _firestore;

  DataFetchStatus _dataFetchStatus = DataFetchStatus.onInitiate;

  DataFetchStatus get dataFetchStatus => _dataFetchStatus;

  set dataFetchStatus(DataFetchStatus value) {
    _dataFetchStatus = value;
    notifyListeners();
  }

  void uploadData(
      {dynamic data,
      Function onSuccess,
      Function onError,
      Function onComplete}) async {
    await _firestore
        .collection("profiles")
        .document()
        .setData(data.toMap())
        .then((value) => {
              _dataFetchStatus = DataFetchStatus.onSuccess,
              this.notifyListeners(),
              if (onSuccess != null) {onSuccess()}
            })
        .catchError((e) {
      _dataFetchStatus = DataFetchStatus.onError;
      this.notifyListeners();
    }).whenComplete(() => {
              _dataFetchStatus = DataFetchStatus.onComplete,
              this.notifyListeners(),
              if (onComplete != null)
                {
                  onComplete(),
                }
            });
  }

  void uploadItemData(
      {dynamic data,
      Function onSuccess,
      Function onError,
      Function onComplete}) async {
    dataFetchStatus = DataFetchStatus.inProcess;
    await _firestore
        .collection("items")
        .document()
        .setData(data.toMap())
        .then((value) => {
              dataFetchStatus = DataFetchStatus.onSuccess,
              if (onSuccess != null) {onSuccess()}
            })
        .catchError((e) {
      dataFetchStatus = DataFetchStatus.onError;
    }).whenComplete(() => {
              dataFetchStatus = DataFetchStatus.onComplete,
              if (onComplete != null)
                {
                  onComplete(),
                }
            });
  }

  Future<Store> getShopProfile(String shopId) async {
    List<Store> storeList = [];
    var qs = await Firestore.instance
        .collection("profiles")
        .where(
          "shopId",
          isEqualTo: shopId,
        )
        .getDocuments();
    qs.documents.forEach((element) {
      storeList.add(Store.fromMap(element.data));
    });
    return storeList[0];
  }




  Future<List<Store>> getShopsForCategories(
      List<String> categories, Function callback) async {
    var shops = await _makeShopListForCategories(categories, callback);
    return shops;
  }

  Future<QuerySnapshot> _getShopByDistrict(String district) async {
    return await Firestore.instance
        .collection("profiles")
        .where("tag", isEqualTo: "shop")
        .where("district", isEqualTo: district.toLowerCase().trim())
        .getDocuments();
  }

  Future<QuerySnapshot> _getShopsByState(String state) async {
    return await Firestore.instance
        .collection("profiles")
        .where("state", isEqualTo: state.toLowerCase().trim())
        .getDocuments();
  }

  Future<QuerySnapshot> _getLabourerByDistrict(String district) async {
    return await Firestore.instance
        .collection("profiles")
        .where("tag", isEqualTo: "labourer")
        .where("district", isEqualTo: district.toLowerCase().trim())
        .getDocuments();
  }

  Future<QuerySnapshot> _getLabourerByState(String state) async {
    return await Firestore.instance
        .collection("profiles")
        .where("tag", isEqualTo: "labourer")
        .where("state", isEqualTo: state.toLowerCase().trim())
        .getDocuments();
  }

  Future<QuerySnapshot> _getArchitectByState(String state) async {
    return await Firestore.instance
        .collection("profiles")
        .where("tag", isEqualTo: "architect")
        .where("state", isEqualTo: state.toLowerCase().trim())
        .getDocuments();
  }

  Future<QuerySnapshot> _getArchitectByDistrict(String district) async {
    return await Firestore.instance
        .collection("profiles")
        .where("tag", isEqualTo: "architect")
        .where("district", isEqualTo: district.toLowerCase().trim())
        .getDocuments();
  }

  _makeShopListForCategories(List<String> categories, Function action) {
    List<Store> shops = [];
    categories.forEach((category) async {
      await firestore
          .collection("profiles")
          .where("tag", isEqualTo: "shop")
          .where("vendorType", arrayContains: category.toLowerCase())
          .getDocuments()
          .then((value) {
        value.documents.forEach((element) {
          shops.add(Store.fromMap(element.data));
          //this is a callback to return data
          action(shops);
        });
      });
    });
  }






  Future<List<Store>> getAllShops() async {
    var querySnapshot = await Firestore.instance
        .collection("profiles")
        .where("tag", isEqualTo: "shop")
        .orderBy("shopId",descending: true)
        .getDocuments();
    var shopList = new List<Store>();
    querySnapshot.documents.forEach((element) {
      shopList.add(Store.fromMap(element.data));
    });
    return Future.value(shopList);
  }





  Future<List<Labourer>> getAllLabourers() async {
    var querySnapshot = await Firestore.instance
        .collection("profiles")
        .where("tag", isEqualTo: "labourer").orderBy("labourId")
        .getDocuments();
    var labourList = new List<Labourer>();
    querySnapshot.documents.forEach((element) {
      labourList.add(Labourer.fromMap(element.data));
    });
    return Future.value(labourList);
  }





  Future<List<Architect>> getAllArchitects() async {
    var querySnapshot = await Firestore.instance
        .collection("profiles")
        .where("tag", isEqualTo: "architect")
        .getDocuments();
    var architectList = new List<Architect>();
    print("Here ${querySnapshot.documents}" );

    querySnapshot.documents.forEach((element) {
      print(element.data);
      architectList.add(Architect.fromMap(element.data));

    });
    return Future.value(architectList);
  }



  Future<Labourer> getLabourerById(String labourerId) async {
    var qs = await Firestore.instance
        .collection("profiles")
        .where("tag", isEqualTo: "labourer")
        .where("labourId", isEqualTo: labourerId)
        .getDocuments();
    return Labourer.fromMap(qs.documents[0].data);
  }

  Future<Architect> getArchitectById(String architectId) async {
    var qs = await Firestore.instance
        .collection("profiles")
        .where("tag", isEqualTo: "architect")
        .where("architectId", isEqualTo: architectId)
        .getDocuments();
    return Architect.fromMap(qs.documents[0].data);
  }
























 Future<List<People>> getAllData(String query) async {
    var itemsByState = await Firestore.instance
        .collection("profiles")
        .where("state", isEqualTo: query.toLowerCase())
        .getDocuments();
    var itemsByDistrict = await Firestore.instance
        .collection("profiles")
        .where("district", isEqualTo: query.toLowerCase())
        .getDocuments();
    var itemsByCategory = await Firestore.instance
        .collection("profiles")
        .where("vendorType", arrayContains: query.toLowerCase())
        .getDocuments();
    var data = itemsByState.documents +
        itemsByDistrict.documents +
        itemsByCategory.documents;
    var itemList = List<People>();

    data.forEach((element) {
      if (element.data["tag"] == "shop") {
        itemList.add(Store.fromMap(element.data));
      } else if (element.data["tag"] == "architect") {
        itemList.add(Architect.fromMap(element.data));
      } else if (element.data['tag'] == "labourer") {
        itemList.add(Labourer.fromMap(element.data));
      }
    });

    return Future.value(itemList);
  }


  Future<void> deleteStore(String storeId) async
  {
    var qs  =  await Firestore.instance.collection("profiles").where("shopId",isEqualTo: storeId).getDocuments();
    qs.documents.forEach((element) {Firestore.instance.collection("profiles").document(element.documentID).delete();});
    dataFetchStatus  =  DataFetchStatus.onComplete;
  }




  Future<void> deleteArchitect(String architectId) async{
    print(architectId);
    var qs  =  await Firestore.instance.collection("profiles").where("architectId",isEqualTo: architectId).getDocuments();

    qs.documents.forEach((element) {
      print(element.data);
      Firestore.instance.collection("profiles").document(element.documentID).delete();});
    dataFetchStatus  =  DataFetchStatus.onComplete;
  }




  Future<void> deleteLabourer(String labourerId) async{
    var qs  =  await Firestore.instance.collection("profiles").where("labourId",isEqualTo:labourerId).getDocuments();
    qs.documents.forEach((element) {
      Firestore.instance.collection("profiles").document(element.documentID).delete();});
    dataFetchStatus  =  DataFetchStatus.onComplete;

  }



  Future<void> updateShop(Store store) async
  {
    var qs  =  await Firestore.instance.collection("profiles").where("shopId",isEqualTo: store.shopId).getDocuments();

    qs.documents.forEach((element) {
      print(element.data);
      Firestore.instance.collection("profiles").document(element.documentID).updateData(store.toMap());
    });
    dataFetchStatus  =  DataFetchStatus.onComplete;
  }



  Future<void> updateArchitect(Architect architect) async
  {
    var qs  =  await Firestore.instance.collection("profiles").where("architectId",isEqualTo: architect.getId()).getDocuments();
    qs.documents.forEach((element) {
      Firestore.instance.collection("profiles").document(element.documentID).updateData(architect.toMap());
    });
    dataFetchStatus =  DataFetchStatus.onComplete;
  }



  Future<void> updateLabourer(Labourer labourer) async
  {
    var qs  =  await Firestore.instance.collection("profiles").where("labourId",isEqualTo:labourer.getId()).getDocuments();
    qs.documents.forEach((element) {

      Firestore.instance.collection("profiles").document(element.documentID).updateData(labourer.toMap());
    });
    dataFetchStatus  =  DataFetchStatus.onComplete;
  }









}
