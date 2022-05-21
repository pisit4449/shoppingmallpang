import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmallpang/bodys/shop_manage_seller.dart';
import 'package:shoppingmallpang/bodys/shop_order_seller.dart';
import 'package:shoppingmallpang/bodys/show_product_seller.dart';
import 'package:shoppingmallpang/utility/myconstant.dart';
import 'package:shoppingmallpang/widget/show_signout.dart';
import 'package:shoppingmallpang/widget/show_title.dart';

class SellerService extends StatefulWidget {
  const SellerService({Key? key}) : super(key: key);

  @override
  State<SellerService> createState() => _SellerServiceState();
}

class _SellerServiceState extends State<SellerService> {
  List<Widget> widgets = [
    ShopOrderSeller(),
    ShopManageSeller(),
    ShowProductSeller()
  ];

  int indexWidget = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('This is Show Product'),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            ShowSignOut(),
            Column(
              children: [
                UserAccountsDrawerHeader(accountName: null, accountEmail: null),
                menuShowOrderSeller(),
                menuShopManageSeller(),
                menuShowProductSeller(),
              ],
            ),
          ],
        ),
      ),
      body: widgets[indexWidget],
    );
  }

  ListTile menuShowOrderSeller() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 0;
          Navigator.pop(context());
        });
      },
      tileColor: Colors.amber.shade100,
      subtitle: ShowTitle(
        title: 'แสดงรายละเอียด Order ที่ลูกค้าสั่ง',
        textStyle: MyConstant().h3Style(),
      ),
      title: ShowTitle(
        title: 'Show Order',
        textStyle: MyConstant().h2Style(),
      ),
      leading: Icon(
        Icons.filter_1_outlined,
        color: MyConstant.dark,
      ),
    );
  }

  ListTile menuShopManageSeller() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 1;
          Navigator.pop(context());
        });
      },
      tileColor: Colors.amber.shade50,
      subtitle: ShowTitle(
        title: 'การจัดการร้า่นค้าของตนเอง',
        textStyle: MyConstant().h3Style(),
      ),
      title: ShowTitle(
        title: 'Shop Manage',
        textStyle: MyConstant().h2Style(),
      ),
      leading: Icon(
        Icons.filter_2_outlined,
        color: MyConstant.dark,
      ),
    );
  }

  ListTile menuShowProductSeller() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 2;
          Navigator.pop(context());
        });
      },
      tileColor: Colors.amber.shade100,
      subtitle: ShowTitle(
        title: 'แสดงสินค้าของร้านให้ลูกค้าเห็น',
        textStyle: MyConstant().h3Style(),
      ),
      title: ShowTitle(
        title: 'Show Product',
        textStyle: MyConstant().h2Style(),
      ),
      leading: Icon(
        Icons.filter_3_outlined,
        color: MyConstant.dark,
      ),
    );
  }
}
