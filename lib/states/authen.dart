import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmallpang/models/user_model.dart';
import 'package:shoppingmallpang/utility/myconstant.dart';
import 'package:shoppingmallpang/utility/mydialog.dart';
import 'package:shoppingmallpang/widget/show_image.dart';
import 'package:shoppingmallpang/widget/show_title.dart';

class Authen extends StatefulWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  bool statusRedEye = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  buildImage(size),
                  buildAppName(),
                  buildFormUser(size),
                  buildFormPassword(size),
                  buildLoginButton(size),
                  buildCreateNewAccount(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding buildCreateNewAccount(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShowTitle(
            title: 'Non Account ? /',
            textStyle: MyConstant().h3Style(),
          ),
          TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, MyConstant.routeCreateAccount),
              child: ShowTitle(
                title: 'Create New Account',
                textStyle: MyConstant().h2Style(),
              ))
        ],
      ),
    );
  }

  Row buildLoginButton(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          width: size * 0.6,
          height: 60,
          child: ElevatedButton(
            style: MyConstant().myButtonStyle(),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                String user = userController.text;
                String password = passwordController.text;
                print('### user ==> $user, password ==> $password');
                checkAuthen(user: user, password: password);
              }
            },
            child: Text('Login'),
          ),
        ),
      ],
    );
  }

  Future<Null> checkAuthen({String? user, String? password}) async {
    String apiCheckAuthen =
        '${MyConstant.domain}/shoppingpang/getUserWhereUser.php?isAdd=true&user=$user';
    await Dio().get(apiCheckAuthen).then((value)async {
      print('## value for api ==> $value');
      if (value.toString() == 'null') {
        MyDialog().normalDialog(
            context(), 'User False!!!', 'No $user in my Database');
      } else {
        for (var item in json.decode(value.data)) {
          UserModel model = UserModel.fromMap(item);
          if (password == model.password) {
            String typeUser = model.typeUser;
            print('### Authen Success in type ==> $typeUser, $model.id, $model.name');

            SharedPreferences preferences = await SharedPreferences.getInstance();
            preferences.setString('id', model.id);
            preferences.setString('typeUser', typeUser);
            preferences.setString('user', model.user);
            preferences.setString('name', model.name);


            switch (typeUser) {
              case 'buyer':
                Navigator.pushNamedAndRemoveUntil(
                    context(), MyConstant.routeBuyerService, (route) => false);
                break;
              case 'seller':
                Navigator.pushNamedAndRemoveUntil(
                    context(), MyConstant.routeSellerService, (route) => false);
                break;
              case 'rider':
                Navigator.pushNamedAndRemoveUntil(
                    context(), MyConstant.routeRiderService, (route) => false);
                break;
              default:
            }
          } else {
            MyDialog().normalDialog(
                context(), 'Password False!!!', 'Please Try Again');
          }
        }
      }
    });
  }

  Row buildFormUser(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.only(top: 30),
          width: size * 0.6,
          child: TextFormField(
            controller: userController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill User in Blank';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.account_circle,
                semanticLabel: 'Text to',
                size: 36,
                color: MyConstant.dark,
              ),
              labelStyle: MyConstant().h2Style(),
              labelText: 'User :',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  style: BorderStyle.solid,
                  width: 3.0,
                  color: MyConstant.light,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: MyConstant.dark,
                  width: 3.0,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildFormPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.only(top: 20),
          width: size * 0.6,
          child: TextFormField(
            controller: passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill User in Blank';
              } else {
                return null;
              }
            },
            obscureText: statusRedEye,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      statusRedEye = !statusRedEye;
                    });
                  },
                  icon: statusRedEye
                      ? Icon(
                          Icons.remove_red_eye,
                          color: MyConstant.dark,
                          size: 36,
                        )
                      : Icon(
                          Icons.remove_red_eye_outlined,
                          color: MyConstant.dark,
                          size: 36,
                        )),
              prefixIcon: Icon(
                Icons.lock,
                size: 36,
                color: MyConstant.dark,
              ),
              labelStyle: MyConstant().h2Style(),
              labelText: 'Password :',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  style: BorderStyle.solid,
                  width: 3.0,
                  color: MyConstant.light,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: MyConstant.dark,
                  width: 3.0,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAppName() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShowTitle(
            title: MyConstant.appName,
            textStyle: MyConstant().h1Style(),
          ),
        ],
      ),
    );
  }

  Row buildImage(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.65,
          child: ShowImage(path: MyConstant.image3),
        ),
      ],
    );
  }
}
