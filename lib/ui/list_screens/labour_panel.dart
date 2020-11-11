import 'package:construct_dream_admin/helpers/ui_helper.dart';
import 'package:construct_dream_admin/models/labour_model.dart';
import 'package:construct_dream_admin/services/firebase_service.dart';
import 'package:construct_dream_admin/ui/registration_screens/labour_registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LabourPanel extends StatefulWidget {
  @override
  _LabourPanelState createState() => _LabourPanelState();
}

class _LabourPanelState extends State<LabourPanel> {
  FirebaseService firebaseService;
  bool reload;

  @override
  void didChangeDependencies() {
    firebaseService = Provider.of<FirebaseService>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: [
              Heading(
                heading: "Labourers",
              ),
              Divider(
                color: Colors.black,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Consumer<FirebaseService>(
                  builder: (_, __, ___) => FutureBuilder<List<Labourer>>(
                    future: firebaseService.getAllLabourers(),
                    builder: (_, snap) {
                      if (snap.hasData &&
                          snap.connectionState == ConnectionState.done) {
                        return ListView.builder(
                          itemBuilder: (_, position) {
                            return Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Text(
                                                  snap.data[position].getName(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                Text(snap.data[position]
                                                    .getProfession())
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                    child: Card(
                                                        color: Colors.red,
                                                        elevation: 2,
                                                        child: Center(
                                                            child: IconButton(
                                                          onPressed: () {
                                                            firebaseService
                                                                .deleteLabourer(snap
                                                                    .data[
                                                                        position]
                                                                    .getId());
                                                          },
                                                          icon: Icon(
                                                            Icons.delete,
                                                            color: Colors.white,
                                                          ),
                                                        )))),
                                                Card(
                                                  color: Colors.green,
                                                  elevation: 2,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context).push(MaterialPageRoute(builder: (_)=>LabourerRegistrationScreen(labourer: snap.data[position],)));
                                                    },
                                                    icon: Icon(
                                                      Icons.edit,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: snap.data.length,
                        );
                      } else {
                        return Container(
                          child: Center(
                            child: Container(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
