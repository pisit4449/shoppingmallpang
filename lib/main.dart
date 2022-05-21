import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmallpang/states/add_product.dart';
import 'package:shoppingmallpang/states/authen.dart';
import 'package:shoppingmallpang/states/buyer_service.dart';
import 'package:shoppingmallpang/states/create_account.dart';
import 'package:shoppingmallpang/states/rider_service.dart';
import 'package:shoppingmallpang/states/seller_service.dart';
import 'package:shoppingmallpang/utility/myconstant.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/buyerService': (BuildContext context) => BuyerService(),
  '/sellerService': (BuildContext context) => SellerService(),
  '/riderService': (BuildContext context) => RiderService(),
  '/addProduct': (BuildContext context) => Addproduct(),
};

String? initialRoute;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? typeUser = preferences.getString('typeUser');
  print('### typeUser ===> $typeUser');
  if (typeUser?.isEmpty ?? true) {
    initialRoute = MyConstant.routeAuthen;
    runApp(MyApp());
  } else {
    switch (typeUser) {
      case 'buyer':
        initialRoute = MyConstant.routeBuyerService;
        runApp(MyApp());
        break;
      case 'seller':
        initialRoute = MyConstant.routeSellerService;
        runApp(MyApp());
        break;
      case 'rider':
        initialRoute = MyConstant.routeRiderService;
        runApp(MyApp());
        break;
      default:
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialColor materialColor = MaterialColor(0xff212121, MyConstant.mapMaterialColor);
    return MaterialApp(
      routes: map,
      title: MyConstant.appName,
      initialRoute: initialRoute,
      theme: ThemeData(primarySwatch: materialColor),
    );
  }
}
