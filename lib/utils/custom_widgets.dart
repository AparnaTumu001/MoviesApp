import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

alertWithProgressBar(context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
            child: new AlertDialog(
                content: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                  const CircularProgressIndicator(),
                  new Text("Please wait...")
                ])),
            onWillPop: () {},
          ));
}

getCustomDateFormat(String givenReleaseDate) {
  String releaseDate = "";
  try {
    DateFormat dateFormat = DateFormat("dd MMM, yyyy");
    DateTime dateTime = DateTime.tryParse(givenReleaseDate);
    releaseDate = dateFormat.format(dateTime);
  } catch (e) {
    releaseDate = givenReleaseDate;
  }
  return releaseDate;
}

Widget errorWidget() {
  return Center(
    child: new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Icon(
          Icons.error_outline,
          size: 80.0,
        ),
        new SizedBox(
          height: 20.0,
        ),
        new Text(
          "Something went wrong.Please try after sometime.",
          style: new TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: Colors.grey[500]),
          textAlign: TextAlign.center,
        )
      ],
    ),
  );
}
