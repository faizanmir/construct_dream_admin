import 'package:construct_dream_admin/models/category_model.dart';
import 'package:construct_dream_admin/ui/category_selection/category_selection_screen.dart';
import 'package:construct_dream_admin/ui/dashboard/edit_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:construct_dream_admin/helpers/ui_helper.dart' as uiHelper;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var optionList = new List<Category>();

  @override
  void initState() {
    optionList.add(new Category(
        "images/registration.png", "Register", "Make a new entry", "new"));
    optionList.add(
        new Category("images/edit.png", "Edit", "Edit an older entry", "edit"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: ListView(
        children: [
          uiHelper.getPadding(Text(
            "Choose a category",
            style: uiHelper.getHeadingTextStyle(),
            textAlign: TextAlign.left,
          )),
          uiHelper.getPadding(Text(
            "Please make a choice.",
            style: uiHelper.getSubHeadingTextStyle(),
            textAlign: TextAlign.left,
          )),
          Container(
            height: MediaQuery.of(context).size.height / 1.9,
            child: GridView.count(
                crossAxisCount: 2,
                children: optionList
                    .asMap()
                    .map((key, value) =>
                        MapEntry(key, makeGridTiles(value, key)))
                    .values
                    .toList()),
          ),
        ],
      )),
    );
  }

  Widget makeGridTiles(Category category, int position) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: InkWell(
            splashColor: Colors.blue,
            onTap: () {
              print(category.name);
              switch (category.categoryIdentifier) {
                case "new":
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => CategorySelectionScreen()));
                  break;
                case "edit":
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=>EditDashboard()));
                  break;
                default:
                  break;
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset(category.imagePath),
                  width: 100,
                  height: 100,
                ),
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
