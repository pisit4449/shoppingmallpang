import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmallpang/utility/myconstant.dart';
import 'package:shoppingmallpang/utility/mydialog.dart';
import 'package:shoppingmallpang/widget/show_image.dart';
import 'package:shoppingmallpang/widget/show_title.dart';

class Addproduct extends StatefulWidget {
  const Addproduct({Key? key}) : super(key: key);

  @override
  State<Addproduct> createState() => _AddproductState();
}

class _AddproductState extends State<Addproduct> {
  final formKey = GlobalKey<FormState>();
  List<File?> files = [];
  File? file;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  List<String> paths = [];

  @override
  void initState() {
    super.initState();
    initialFile();
  }

  void initialFile() {
    for (var i = 0; i < 4; i++) {
      files.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => processAddProduct(),
              icon: Icon(Icons.cloud_upload))
        ],
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: LayoutBuilder(
          builder: (context, constraints) => GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            behavior: HitTestBehavior.opaque,
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      buildFormName(constraints),
                      buildFormPrice(constraints),
                      buildFormDetail(constraints),
                      buildImage(constraints),
                      buildButtonAddProduct(constraints)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void processAddProduct() async {
    if (formKey.currentState!.validate()) {
      bool checkFile = true;
      for (var item in files) {
        if (item == null) {
          checkFile = false;
        }
      }
      if (checkFile) {
        // print('### Chooe 4 image Success');
        MyDialog().showProgressDialog(context());
        // Navigator.pop(context());

        String apiSaveProduct =
            '${MyConstant.domain}/shoppingpang/saveProduct.php';

        int loop = 0;
        for (var item in files) {
          int i = Random().nextInt(1000000);
          String nameFile = 'product$i.jpg';
          paths.add('/product/$nameFile');

          Map<String, dynamic> map = {};
          map['file'] =
              await MultipartFile.fromFile(item!.path, filename: nameFile);
          FormData data = FormData.fromMap(map);
          await Dio().post(apiSaveProduct, data: data).then((value) async {
            print('Upload Success');
            loop++;
            if (loop >= files.length) {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();

              String idSeller = preferences.getString('id')!;
              String? nameSeller = preferences.getString('name');
              String name = nameController.text;
              String price = priceController.text;
              String detail = detailController.text;
              String images = paths.toString();
              print('### idSeller = $idSeller, nameSeller = $nameSeller');
              print('### name = $name, price = $price, detail = $detail');
              print('### imagee ==> $images');

              String path =
                  '${MyConstant.domain}/shoppingpang/insertProduct.php?isAdd=true&idSeller=$idSeller&nameSeller=$nameSeller&name=$name&price=$price&detail=$detail&images=$images';
              await Dio().get(path).then((value) => Navigator.pop(context()));

              Navigator.pop(context());
            }
          });
        }
      } else {
        MyDialog().normalDialog(
            context(), 'More Image!!!', 'Please Choose More Image');
      }
    }
  }


  Future<Null> processImagePicker(ImageSource source, int index) async {
    try {
      var result = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
        files[index] = file;
      });
    } catch (e) {}
  }

  Future<Null> chooseSourceImageDialog(int index) async {
    print('### Click form index ====> $index');
    showDialog(
      context: context(),
      builder: (context) => AlertDialog(
        title: ListTile(
          subtitle: ShowTitle(
            title: 'Please Tab on Camera or Gallary',
            textStyle: MyConstant().h3Style(),
          ),
          title: ShowTitle(
            title: 'Source Image ${index + 1} ?',
            textStyle: MyConstant().h2Style(),
          ),
          leading: ShowImage(path: MyConstant.image3),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  processImagePicker(ImageSource.camera, index);
                },
                child: Text('Camara'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  processImagePicker(ImageSource.gallery, index);
                },
                child: Text('Gallary'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancle'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container buildButtonAddProduct(BoxConstraints constraints) {
    return Container(
      height: 60,
      padding: EdgeInsets.only(top: 20),
      width: constraints.maxWidth * 0.75,
      child: ElevatedButton(
        style: MyConstant().myButtonStyle(),
        onPressed: () {
          processAddProduct();
        },
        child: Text('Add Product'),
      ),
    );
  }

  Column buildImage(BoxConstraints constraints) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          height: constraints.maxWidth * 0.75,
          width: constraints.maxWidth * 0.75,
          child:
              file == null ? Image.asset(MyConstant.image6) : Image.file(file!),
        ),
        Container(
          width: constraints.maxWidth * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 48,
                width: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(0),
                  child: files[0] == null
                      ? Image.asset(MyConstant.image6)
                      : Image.file(
                          files[0]!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Container(
                height: 48,
                width: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(1),
                  child: files[1] == null
                      ? Image.asset(MyConstant.image6)
                      : Image.file(
                          files[1]!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Container(
                height: 48,
                width: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(2),
                  child: files[2] == null
                      ? Image.asset(MyConstant.image6)
                      : Image.file(
                          files[2]!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Container(
                height: 48,
                width: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(3),
                  child: files[3] == null
                      ? Image.asset(MyConstant.image6)
                      : Image.file(
                          files[3]!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildFormName(BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: constraints.maxWidth * 0.75,
      child: TextFormField(
        controller: nameController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill In Blank';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.account_box,
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
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 3.0,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget buildFormPrice(BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: constraints.maxWidth * 0.75,
      child: TextFormField(
        controller: priceController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill In Blank';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.money,
            color: MyConstant.dark,
          ),
          labelStyle: MyConstant().h2Style(),
          labelText: 'Price :',
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
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 3.0,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget buildFormDetail(BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: constraints.maxWidth * 0.75,
      child: TextFormField(
        controller: detailController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill In Blank';
          } else {
            return null;
          }
        },
        maxLines: 4,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
            child: Icon(
              Icons.details,
              color: MyConstant.dark,
            ),
          ),
          hintStyle: MyConstant().h2Style(),
          hintText: 'Detail :',
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
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 3.0,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}






// ignore_for_file: sized_box_for_whitespace

