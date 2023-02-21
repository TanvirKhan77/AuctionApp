import 'package:auctionapp/Screens/product_detail_screen.dart';
import 'package:auctionapp/Screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import '../Global/global.dart';
import '../splashScreen/splash_screen.dart';
import 'form_screen.dart';
import 'home_screen.dart';

class PostedItemsScreen extends StatefulWidget {
  const PostedItemsScreen({Key? key}) : super(key: key);

  @override
  State<PostedItemsScreen> createState() => _PostedItemsScreenState();
}

class _PostedItemsScreenState extends State<PostedItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.purple,
        body: Padding(
          padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text('My Posted Items',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("products").snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if(!snapshot.hasData){
                      return Text('');
                    }
                    else {
                      return GridView.count(
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        primary: false,
                        crossAxisCount: 2,
                        children: [
                          for(int i = 0; i < snapshot.data.docs.length;i++)
                            if(snapshot.data.docs[i].data()["userUid"] == sharedPreferences!.getString("uid"))
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (c) =>
                                      ProductDetailScreen(
                                        photoUrl: snapshot.data.docs[i].data()["photoUrl"],
                                        productName: snapshot.data.docs[i].data()["productName"],
                                        productDescription: snapshot.data.docs[i].data()["productDescription"],
                                        minBidPrice: snapshot.data.docs[i].data()["minBidPrice"],
                                        auctionEndTime: DateFormat('dd/MM/yyyy').format(DateTime.parse(((snapshot.data.docs[i].data()["auctionEndTime"] as Timestamp).toDate()).toString())),
                                      ))
                                  );
                                },
                                child: Card(
                                  color: Colors.white,
                                  shape:RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  elevation: 4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: Image.network(snapshot.data.docs[i].data()["photoUrl"]),
                                      ),

                                      Expanded(
                                        flex: 1,
                                        child: Text(snapshot.data.docs[i].data()["productName"]),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                        ],
                      );
                    }
                  },
                ),
              ),


            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 10,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedIconTheme: IconThemeData(color: Colors.purple),
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
          selectedItemColor: Colors.black,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => HomeScreen()));
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.home,
                    size: 26.5,
                  ),
                ),
              ),
              label: 'Home Page',
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => ProfileScreen()));
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.person,
                    size: 28,
                    color: Colors.grey,
                  ),
                ),
              ),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Container(
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (c) => FormScreen()));
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  )
              ),
              label: "Add Item",
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => PostedItemsScreen()));
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.post_add,
                    size: 26.5,
                    color: Colors.purple,
                  ),
                ),
              ),
              label: 'Posted Items',
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () async {
                  await GoogleSignIn().signOut();
                  FirebaseAuth.instance.signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (c) => SplashScreen()));
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.exit_to_app,
                    size: 28,
                  ),
                ),
              ),
              label: 'Sign Out',
            ),
          ],
          //currentIndex: _selectedIndex,
          //onTap: _onItemTapped,
        ),
      ),
    );
  }
}
