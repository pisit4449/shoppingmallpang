import 'package:flutter/material.dart';
import 'package:shoppingmallpang/states/authen.dart';
import 'package:shoppingmallpang/states/buyer_service.dart';
import 'package:shoppingmallpang/states/create_account.dart';
import 'package:shoppingmallpang/states/rider_service.dart';
import 'package:shoppingmallpang/states/seller_service.dart';
import 'package:shoppingmallpang/utility/myconstant.dart';


final Map<String, WidgetBuilder> map = {
  '/authen':(BuildContext context) => Authen(),
  '/createAccount':(BuildContext context) => CreateAccount(),
  '/buyerService':(BuildContext context) => BuyerService(),
  '/sellerService':(BuildContext context) => SellerService(),
  '/riderService':(BuildContext context) => RiderService(),
};

String? initialRoute;

void main() {
  initialRoute = MyConstant.routeAuthen;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: map,
      title: MyConstant.appName,
      initialRoute: initialRoute,
    );
  }
}

