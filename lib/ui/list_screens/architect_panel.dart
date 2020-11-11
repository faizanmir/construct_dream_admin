import 'package:construct_dream_admin/helpers/ui_helper.dart';
import 'package:construct_dream_admin/models/architect_model_.dart';
import 'package:construct_dream_admin/services/firebase_service.dart';
import 'package:construct_dream_admin/ui/registration_screens/architect_registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArchitectPanel extends StatefulWidget {
  @override
  _ArchitectPanelState createState() => _ArchitectPanelState();
}

class _ArchitectPanelState extends State<ArchitectPanel> {
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
                heading: "Architects",
              ),
              Divider(
                color: Colors.black,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Consumer<FirebaseService>(
                  builder: (_, __, ___) => FutureBuilder<List<Architect>>(
                    future: firebaseService.getAllArchitects(),
                    builder: (_, snap) {
                      if (snap.connectionState == ConnectionState.done) {
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
                                                  snap.data[position]
                                                      .organizationName,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                Text(snap.data[position].tag)
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
                                                                .deleteArchitect(snap
                                                                    .data[
                                                                        position]
                                                                    .architectId);
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
                                                      Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ArchitectRegistrationScreen(architect: snap.data[position],)));
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
