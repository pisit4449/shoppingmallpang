import 'package:flutter/material.dart';
import 'package:shoppingmallpang/utility/myconstant.dart';
import 'package:shoppingmallpang/widget/show_image.dart';
import 'package:shoppingmallpang/widget/show_title.dart';

class Authen extends StatefulWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  bool statusRedEye = true;

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
                      onPressed: () => Navigator.pushNamed(
                          context, MyConstant.routeCreateAccount),
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
            onPressed: () {},
            child: Text('Login'),
          ),
        ),
      ],
    );
  }

  Row buildFormUser(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.only(top: 30),
          width: size * 0.6,
          child: TextFormField(
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
