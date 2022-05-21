import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoppingmallpang/utility/myconstant.dart';
import 'package:shoppingmallpang/utility/mydialog.dart';
import 'package:shoppingmallpang/widget/show_image.dart';
import 'package:shoppingmallpang/widget/show_title.dart';
import 'package:shoppingmallpang/widget/showgrogress.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String avatar = '';
  String? typeUser;
  File? file;
  double? lat, lng;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    findlocacion();
  }

  Future<Null> findlocacion() async {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print('Service Location Open');

      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
              context(), 'ไม่อนุญาตแชร์ Location', 'โปรดแชร์ Location');
        } else {
          findLatLng();
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
              context(), 'ไม่อนุญาตแชร์ Location', 'โปรดแชร์ Location');
        } else {
          findLatLng();
        }
      }
    } else {
      print('Service Location Close');
      MyDialog().alertLocationService(
          context(), 'Location ของคุณปิดอยู่', 'กรุณาเปิด Location Service');
    }
  }

  Future<Null> findLatLng() async {
    print('findLatLng ==> work');
    Position? position = await findPosition();
    setState(() {
      lat = position!.latitude;
      lng = position.longitude;
      print('lat = $lat,  lng = $lng');
    });
  }

  Future<Position?> findPosition() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        actions: [buildCreateNewAccount(context)],
        backgroundColor: MyConstant.primary,
        title: Text('Create New Account'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildGeneralTitle('ข้อมูลทั่วไป :'),
                buildFormName(size),
                buildGeneralTitle('ชนิดของ User :'),
                buildRadioBuyer(size),
                buildRadioSeller(size),
                buildRadioRider(size),
                buildFormUserName(size),
                buildFormPhone(size),
                buildFormAddress(size),
                buildFormPassword(size),
                buildGeneralTitle('รูปภาพประจำตัว'),
                buildImageAvatar(size),
                buildGeneralTitle('แสดงพิกัดที่คุณอยู่'),
                buildMap(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> uploadPictureAndInserData() async {
    String name = nameController.text;
    String user = userController.text;
    String phone = phoneController.text;
    String address = addressController.text;
    String password = passwordController.text;
    print(
        '## name => $name, user => $user, phone => $phone, address => $address, password => $password');
    String path =
        '${MyConstant.domain}/shoppingpang/getUserWhereUser.php?isAdd=true&user=$user';
    await Dio().get(path).then((value) async {
      print('### value ===> $value');
      if (value.toString() == 'null') {
        print('### User OK');

        if (file == null) {
          //  No Avatar
          processInsertMySQL(
            name: name,
            address: address,
            password: password,
            phone: phone,
            user: user,
          );
        } else {
          // Have Avatar
          print('### process Upload Avatar');

          // การอัพรูปขึ้นไปเก็บไว้ในโฟลเดอร์
          String apiSaveAvatar =
              '${MyConstant.domain}/shoppingpang/saveAvatar.php';
          int i = Random().nextInt(1000000);
          String nameAvatar = 'avatar$i.jpg';
          Map<String, dynamic> map = Map();
          map['file'] =
              await MultipartFile.fromFile(file!.path, filename: nameAvatar);
          FormData data = FormData.fromMap(map);
          await Dio().post(apiSaveAvatar, data: data).then((value) {
            avatar = '/shoppingpang/avatar/$nameAvatar';
            processInsertMySQL(
              name: name,
              address: address,
              password: password,
              phone: phone,
              user: user,
            );
          });
        }
      } else {
        MyDialog()
            .normalDialog(context(), 'User False !!!', 'Please Chang User');
      }
    });
  }

  Future<Null> processInsertMySQL({
    String? name,
    String? user,
    String? phone,
    String? address,
    String? password,
  }) async {
    print('## ProcessInsertMySQL Work and avatar ===> $avatar');
    String apiInsertUser =
        '${MyConstant.domain}/shoppingpang/insertUser.php?isAdd=true&name=$name&typeUser=$typeUser&address=$address&phone=$phone&user=$user&password=$password&avatar=$avatar&lat=$lat&lng=$lng';
    await Dio().get(apiInsertUser).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context());
      } else {
        MyDialog().normalDialog(
            context(), 'Create New User False!!!', 'Please try Again');
      }
    });
  }

  IconButton buildCreateNewAccount(BuildContext context) {
    return IconButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            if (typeUser == null) {
              MyDialog().normalDialog(
                context,
                'ยังไม่ด้เลือกชนิด User',
                'กรุณาเลือกชนิด User',
              );
            } else {
              print('Process Insert to Database');
              uploadPictureAndInserData();
            }
          }
        },
        icon: Icon(Icons.cloud_upload));
  }

  Set<Marker> setMarker() => <Marker>[
        Marker(
          markerId: MarkerId('id'),
          position: LatLng(lat!, lng!),
          infoWindow: InfoWindow(
              title: 'คุณอยู่ที่นี่', snippet: 'Lat = $lat, Lng = $lng'),
        )
      ].toSet();

  Widget buildMap() => Container(
        width: double.infinity,
        height: 200,
        child: lat == null
            ? ShowProgress()
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat!, lng!),
                  zoom: 16,
                ),
                onMapCreated: (controller) {},
                markers: setMarker(),
              ),
      );

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker()
          .pickImage(source: source, maxWidth: 800, maxHeight: 800);

      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row buildImageAvatar(double size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () => chooseImage(ImageSource.camera),
          icon: Icon(
            Icons.add_a_photo,
            size: 40,
            color: MyConstant.dark,
          ),
        ),
        Container(
          width: size * 0.6,
          child: file == null
              ? ShowImage(path: MyConstant.avatar)
              : Image.file(file!),
        ),
        IconButton(
          onPressed: () => chooseImage(ImageSource.gallery),
          icon: Icon(
            Icons.add_photo_alternate,
            size: 40,
            color: MyConstant.dark,
          ),
        )
      ],
    );
  }

  Row buildRadioBuyer(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            // tileColor: Colors.blue,
            activeColor: Colors.black,
            selectedTileColor: Colors.amber,
            title: ShowTitle(
              title: 'Buyer (ผู้ซื้อ)',
              textStyle: MyConstant().h2Style(),
            ),
            value: 'buyer',
            groupValue: typeUser,
            onChanged: (value) {
              setState(() {
                typeUser = value as String?;
              });
            },
          ),
        ),
      ],
    );
  }

  Row buildRadioSeller(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            activeColor: Colors.black,
            title: ShowTitle(
              title: 'Seller (ผู้ขาย)',
              textStyle: MyConstant().h2Style(),
            ),
            value: 'seller',
            groupValue: typeUser,
            onChanged: (value) {
              setState(() {
                typeUser = value as String?;
              });
            },
          ),
        ),
      ],
    );
  }

  Row buildRadioRider(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            activeColor: Colors.black,
            title: ShowTitle(
              title: 'Rider (ผู้ส่ง)',
              textStyle: MyConstant().h2Style(),
            ),
            value: 'rider',
            groupValue: typeUser,
            onChanged: (value) {
              setState(() {
                typeUser = value as String?;
              });
            },
          ),
        ),
      ],
    );
  }

  Row buildFormName(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: size * 0.7,
          child: TextFormField(
            controller: nameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก Name ด้วยค่ะ';
              } else {}
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.badge,
                semanticLabel: 'Text to',
                size: 36,
                color: MyConstant.dark,
              ),
              labelStyle: MyConstant().h2Style(),
              labelText: 'Name :',
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

  Row buildFormUserName(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: size * 0.7,
          child: TextFormField(
            controller: userController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก Name ด้วยค่ะ';
              } else {}
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.person,
                semanticLabel: 'Text to',
                size: 36,
                color: MyConstant.dark,
              ),
              labelStyle: MyConstant().h2Style(),
              labelText: 'UserName :',
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

  Row buildFormPhone(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: size * 0.7,
          child: TextFormField(
            controller: phoneController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก Name ด้วยค่ะ';
              } else {}
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.phone_android,
                semanticLabel: 'Text to',
                size: 36,
                color: MyConstant.dark,
              ),
              labelStyle: MyConstant().h2Style(),
              labelText: 'Phone :',
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

  Row buildFormAddress(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: size * 0.7,
          child: TextFormField(
            controller: addressController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก Name ด้วยค่ะ';
              } else {}
            },
            maxLines: 4,
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                child: Icon(
                  Icons.home,
                  semanticLabel: 'Text to',
                  size: 36,
                  color: MyConstant.dark,
                ),
              ),
              hintStyle: MyConstant().h2Style(),
              hintText: 'Address :',
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
          margin: EdgeInsets.symmetric(vertical: 10),
          width: size * 0.7,
          child: TextFormField(
            controller: passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก Name ด้วยค่ะ';
              } else {}
            },
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.vpn_key,
                semanticLabel: 'Text to',
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

  Container buildGeneralTitle(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ShowTitle(
        title: title,
        textStyle: MyConstant().h2Style(),
      ),
    );
  }
}
