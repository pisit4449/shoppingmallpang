import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmallpang/utility/myconstant.dart';
import 'package:shoppingmallpang/widget/show_title.dart';

class ShowSignOut extends StatelessWidget {
  const ShowSignOut({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.clear().then(
                  (value) => Navigator.pushNamedAndRemoveUntil(
                      context, MyConstant.routeAuthen, (route) => false),
                );
          },
          subtitle: ShowTitle(
            title: 'SingOUt And Go To Authen',
            textStyle: MyConstant().h3WhiteStyle(),
          ),
          title: ShowTitle(
              title: 'Sign Out', textStyle: MyConstant().h2WhiteStyle()),
          tileColor: Colors.red.shade900,
          leading: Icon(
            Icons.exit_to_app,
            color: Colors.white,
            size: 40,
          ),
        ),
      ],
    );
  }
}