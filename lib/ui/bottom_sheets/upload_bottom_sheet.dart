import 'package:construct_dream_admin/services/firebase_service.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class UploadBottomSheet extends StatefulWidget {
  final Function onContinuePressed;

  const UploadBottomSheet({this.onContinuePressed});
  @override
  _UploadBottomSheetState createState() => _UploadBottomSheetState();
}

class _UploadBottomSheetState extends State<UploadBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final _firebaseService =
        Provider.of<FirebaseService>(context, listen: true);
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5))),
        child: Consumer<FirebaseService>(builder: (_, firebaseService, __) {
          return _makeUiForUploadState(firebaseService);
        }),
      ),
    );
  }

  Widget _makeUiForUploadState(FirebaseService firebaseService) {
    print(firebaseService.dataFetchStatus);
    switch (firebaseService.dataFetchStatus) {
      case DataFetchStatus.onInitiate:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            )
          ],
        );
        break;

      case DataFetchStatus.onSuccess:
        return Container();
        break;
      case DataFetchStatus.onError:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.clear, color: Colors.red, size: 50),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Oops! ,Something went wrong ,Please try again",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            )
          ],
        );
        break;

      case DataFetchStatus.onComplete:
        return Container(
          height: 100,
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 50,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Profile successfully registered",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Material(
                  color: Colors.blue,
                  child: FlatButton(
                    onPressed: () {
                      widget.onContinuePressed();
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Continue",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w200,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
        // Navigator.of(context).pop();
        break;

      default:
        return Container(
          height: 50,
          width: 50,
        );
    }
  }
}
