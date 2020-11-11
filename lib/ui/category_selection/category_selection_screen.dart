import 'package:construct_dream_admin/models/category_model.dart';
import 'package:construct_dream_admin/ui/registration_screens/architect_registration_screen.dart';
import 'package:construct_dream_admin/ui/registration_screens/labour_registration_screen.dart';
import 'package:construct_dream_admin/ui/registration_screens/shop_register_screen.dart';
import 'package:flutter/material.dart';
import 'package:construct_dream_admin/helpers/ui_helper.dart' as uiHelper;
import 'package:flutter/services.dart';


class CategorySelectionScreen extends StatefulWidget {
  @override
  _CategorySelectionScreenState createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CategorySelection(),
    );
  }
}


class CategorySelection extends StatefulWidget {
  @override
  _CategorySelectionState createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  List<Category> _categoryList  =  List<Category>();
  bool categorySelected =  false;
  Category selectedCategory;

  @override
  void initState() {
    uiHelper.makeFullScreenUi();
    //If user has logged in through google we wont have his phone number
    // just his email this info can be used to check what auth method he has used

    _categoryList.add(Category("images/shop.png","Seller"," ","seller"));
    _categoryList.add(Category("images/architect.png","Architect"," ","architect"));
    _categoryList.add(Category("images/labourer.png","Labourer"," ","labourer"));
    SystemChrome.setEnabledSystemUIOverlays ([SystemUiOverlay.bottom]);


    super.initState();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
    child: ListView(
      children: [
       Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            uiHelper.getPadding(Text("Choose a category",style: uiHelper.getHeadingTextStyle(),textAlign: TextAlign.left,)),
            uiHelper.getPadding(Text("Who are you ?",style: uiHelper.getSubHeadingTextStyle(),textAlign: TextAlign.left,)),
            Container(
              height: MediaQuery.of(context).size.height/1.9,
              child: GridView.count(
                  crossAxisCount: 2,
                  children:_categoryList.asMap().map((key, value) => MapEntry(key,makeGridTiles(value, key))).values.toList()),
            ),
            uiHelper.getPadding(Container(height:100,child: Center(child: Text("Please select a category from above to continue",style: uiHelper.getSubHeadingTextStyle(),)))),
          ],
        ),
      ),
    ],
    ),
    );
  }

  Widget makeGridTiles(Category category,int position)
  {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          child: InkWell(
            splashColor: Colors.blue,
            onTap: (){
              print("Category ${category.categoryIdentifier}");

              if(category.categoryIdentifier == "seller")
              {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) =>ShopRegisterScreen()));
              }
              else if(category.categoryIdentifier == "architect")
              {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) =>ArchitectRegistrationScreen()));
              }
              else if(category.categoryIdentifier =="labourer")
              {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) =>LabourerRegistrationScreen()));
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    child: Image.asset(category.imagePath),width: 100,height: 100,),
                Text(category.name),
                Text(category.description)
              ],
            ),
          ),
        ),
      ),
    );
  }


}

