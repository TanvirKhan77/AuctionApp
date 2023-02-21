import 'dart:async';

import 'package:auctionapp/Screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Global/global.dart';
import '../Screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTimer() {
    Timer(const Duration(seconds: 3), () async {

      Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
      // if(await firebaseAuth.currentUser != null){
      //
      //   // checkIfUserRecordExists(firebaseAuth.currentUser!);
      //
      //   Navigator.push(context, MaterialPageRoute(builder: (c) => HomeScreen()));
      // }
      // else{
      //   Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
      // }
    });
  }

  // checkIfUserRecordExists(User currentUser) async
  // {
  //   await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(currentUser.uid)
  //       .get()
  //       .then((record) async
  //   {
  //     if(record.exists) //record exists
  //         {
  //       await sharedPreferences!.setString("uid", record.data()!["uid"]);
  //       await sharedPreferences!.setString("email", record.data()!["email"]);
  //       await sharedPreferences!.setString("name", record.data()!["name"]);
  //     }
  //     else //record not exists
  //         {
  //       FirebaseAuth.instance.signOut();
  //       Fluttertoast.showToast(msg: "This user's record do not exists.");
  //     }
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Auction App',
          style: TextStyle(
            color: Colors.black,
            fontSize: 50,
          ),
        ),
      ),
    );
  }
}
