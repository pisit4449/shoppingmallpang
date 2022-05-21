import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shoppingmallpang/utility/myconstant.dart';
import 'package:shoppingmallpang/widget/show_image.dart';
import 'package:shoppingmallpang/widget/show_title.dart';

class MyDialog {
  Future<Null> alertLocationService(
      BuildContext context, String title, String message) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: ListTile(
                leading: ShowImage(path: MyConstant.image2),
                title:
                    ShowTitle(title: title, textStyle: MyConstant().h2Style()),
                subtitle: ShowTitle(
                    title: message, textStyle: MyConstant().h3Style()),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      await Geolocator.openLocationSettings();
                    },
                    child: Text('OK'))
              ],
            ));
  }

  Future<Null> normalDialog(
      BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: ShowImage(path: MyConstant.image4),
          title: ShowTitle(
            title: title,
            textStyle: MyConstant().h2Style(),
          ),subtitle: ShowTitle(title: message, textStyle: MyConstant().h3Style(),
        ),
      ),children: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'),),
      ],
    ),
    );
  }

Future<Null> showProgressDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) => WillPopScope(
              child: Center(
                child: CircularProgressIndicator(),
              ),
              onWillPop: () async {
                return false;
              },
            ));
  }

}
