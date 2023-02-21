import 'dart:io';

import 'package:auctionapp/Global/global.dart';
import 'package:auctionapp/Screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

DateTime date = DateTime.now();

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {

  final productNameTextEditingController = TextEditingController();
  final productDescriptionTextEditingController = TextEditingController();
  final minBidPriceTextEditingController = TextEditingController();

  // declare a GlobalKey
  final _formKey = GlobalKey<FormState>();

  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();
  String downloadUrlImage = "";

  getImageFromGallery() async
  {
    imgXFile = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imgXFile;
    });
  }

  void _submit() async {
    if(_formKey.currentState!.validate()){
      if(imgXFile == null){
        Fluttertoast.showToast(msg: "Please select an image.");
      }
      else {
        //upload image to storage
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

        fStorage.Reference storageRef = fStorage.FirebaseStorage.instance
            .ref()
            .child("productsImages").child(fileName);

        fStorage.UploadTask uploadImageTask = storageRef.putFile(File(imgXFile!.path));

        fStorage.TaskSnapshot taskSnapshot = await uploadImageTask.whenComplete(() {});

        await taskSnapshot.ref.getDownloadURL().then((urlImage)
        {
          downloadUrlImage = urlImage;
        });

        print("No error");

        DocumentReference reference = FirebaseFirestore.instance
            .collection("products")
            .doc();

        print("Reference Id: " + reference.id);
        print("User Id: " + sharedPreferences!.getString("uid")!);
        print("Photo Url: " + downloadUrlImage);
        print("Product Name: " + productNameTextEditingController.text.trim());
        print("Product Description: " + productDescriptionTextEditingController.text.trim());
        print("Min Bid Price: " + minBidPriceTextEditingController.text.trim());
        print("Auction End Time: " + date.toString());

        reference.set(
        {
          "productId": reference.id,
          "userUid": sharedPreferences!.getString("uid"),
          "photoUrl": downloadUrlImage,
          "productName": productNameTextEditingController.text.trim(),
          "productDescription": productDescriptionTextEditingController.text.trim(),
          "minBidPrice": minBidPriceTextEditingController.text.trim(),
          "auctionEndTime": date,
        });

        Fluttertoast.showToast(msg: "Product added successfully.");

        Navigator.push(context, MaterialPageRoute(builder: (c) => HomeScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.all(0),
          children: [

            const SizedBox(height: 50,),

            Center(
              child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    //borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 100),
                      padding: const EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        //color: Colors.white,
                        color: Colors.white70,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Add an item',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(height: 10,),

                          const Text(
                            'Please enter your product name and other information',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 20,),

                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(width: 2,color: Colors.purple),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  //get-capture image
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: ()
                                    {
                                      getImageFromGallery();
                                    },
                                    child: CircleAvatar(
                                      radius: MediaQuery.of(context).size.width * 0.20,
                                      backgroundColor: Colors.white,
                                      backgroundImage: imgXFile == null
                                          ? null
                                          : FileImage(
                                          File(imgXFile!.path)
                                      ),
                                      child: imgXFile == null
                                          ? Icon(
                                        Icons.add_photo_alternate,
                                        color: Colors.grey,
                                        size: MediaQuery.of(context).size.width * 0.20,
                                      ) : null,
                                    ),
                                  ),

                                  // GestureDetector(
                                  //   behavior: HitTestBehavior.translucent,
                                  //   onTap: () {
                                  //     getImageFromGallery();
                                  //   },
                                  //   child: Container(
                                  //     width: double.infinity,
                                  //     height: 200,
                                  //     decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(10),
                                  //       image: DecorationImage(
                                  //         image:
                                  //       )
                                  //     ),
                                  //
                                  //     child: imgXFile == null ? Icon(Icons.add_photo_alternate) : null,
                                  //   ),
                                  // ),

                                  const SizedBox(height: 20,),

                                  TextFormField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50)
                                    ],
                                    decoration: InputDecoration(
                                      hintText: 'Product Name',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey.shade200,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      prefixIcon: Icon(Icons.production_quantity_limits_sharp, color: Colors.grey,),
                                    ),
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Name can\'t be empty';
                                      }
                                      if (text.length < 2) {
                                        return 'Please enter a valid name';
                                      }
                                      if(text.length > 49){
                                        return 'Name can\'t be more than 50';
                                      }
                                    },
                                    onChanged: (text) => setState(() {
                                      productNameTextEditingController.text = text;
                                    }),
                                  ),

                                  const SizedBox(height: 20,),

                                  TextFormField(
                                    keyboardType: TextInputType.multiline,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(300)
                                    ],
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      hintText: 'Product Description',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey.shade200,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      prefixIcon: Icon(Icons.production_quantity_limits_sharp, color: Colors.grey,),
                                    ),
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Name can\'t be empty';
                                      }
                                      if (text.length < 2) {
                                        return 'Please enter a valid name';
                                      }
                                      if(text.length > 299){
                                        return 'Name can\'t be more than 50';
                                      }
                                    },
                                    onChanged: (text) => setState(() {
                                      productDescriptionTextEditingController.text = text;
                                    }),
                                  ),

                                  const SizedBox(height: 20,),

                                  TextFormField(
                                    keyboardType: TextInputType.numberWithOptions(signed: true),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50)
                                    ],
                                    decoration: InputDecoration(
                                      hintText: 'Minimum bid price',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey.shade200,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      prefixIcon: Icon(Icons.money, color: Colors.grey,),
                                    ),
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Name can\'t be empty';
                                      }
                                      if (text.length < 1) {
                                        return 'Please enter a valid name';
                                      }
                                      if(text.length > 49){
                                        return 'Name can\'t be more than 50';
                                      }
                                    },
                                    onChanged: (text) => setState(() {
                                      minBidPriceTextEditingController.text = text;
                                    }),
                                  ),

                                  const SizedBox(height: 20,),

                                  GestureDetector(
                                    onTap: () async {
                                      DateTime? newDate = await showDatePicker(
                                        context: context,
                                        initialDate: date,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2100),
                                      );

                                      // if 'cancel' => null
                                      if(newDate == null) return;

                                      //if 'OK' => DateTime
                                      setState(() {
                                        date = newDate;
                                        print(date);
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            color: Colors.grey,
                                          ),

                                          SizedBox(width: 10,),

                                          Text(
                                            '${date.day}/${date.month}/${date.year}',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20,),

                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.purple,
                                      onPrimary: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(32.0)
                                      ),
                                      //minimumSize: const Size(double.infinity, 50),
                                    ),
                                    onPressed: () async {
                                      _submit();
                                    },
                                    child: const Text(
                                      'Submit',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),



                        ],
                      ),
                    ),



                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}
