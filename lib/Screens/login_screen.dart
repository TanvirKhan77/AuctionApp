import 'package:auctionapp/Screens/home_screen.dart';
import 'package:auctionapp/splashScreen/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Global/global.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  signInWithGoogle(BuildContext context) async {

    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth!.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);

      if(userCredential != null){
        FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .set(
            {
              "uid": userCredential.user!.uid,
              "email": userCredential.user!.email.toString(),
              "name": userCredential.user!.displayName.toString(),
              "photoUrl": userCredential.user!.photoURL.toString(),
            });

        //save locally
        sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences!.setString("uid", userCredential.user!.uid);
        await sharedPreferences!.setString("email", userCredential.user!.email.toString());
        await sharedPreferences!.setString("name", userCredential.user!.displayName.toString());
        await sharedPreferences!.setString("photoUrl", userCredential.user!.photoURL.toString());
      }

      print(userCredential.user!.displayName);
      print(userCredential.user!.email);
      print(userCredential.user!.phoneNumber); //Not working
      print(userCredential.user!.photoURL);
      print(userCredential.user!.uid);

      Fluttertoast.showToast(msg: "Successfully logged in.");
      Navigator.push(context, MaterialPageRoute(builder: (c) => HomeScreen()));
    } catch (e) {
      print("Error occurred.");
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
            Column(
              children: [
                Image.asset('images/city.jpg'),

                const SizedBox(height: 20,),

                Text(
                  "Sign In",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          signInWithGoogle(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('images/google.png',height: 20,),

                              SizedBox(width: 10,),

                              Text("Sign in with Google"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
