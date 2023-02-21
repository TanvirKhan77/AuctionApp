import 'package:auctionapp/Screens/form_screen.dart';
import 'package:auctionapp/Screens/posted_items_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Global/global.dart';
import '../splashScreen/splash_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
            SizedBox(height: 100,),

            Center(
              child: Text(
                "Profile Screen",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),

            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.20,
                    backgroundColor: Colors.white,
                    child: Image.network(sharedPreferences!.getString("photoUrl")!,),
                  ),
                  
                  SizedBox(height: 20,),
                  
                  Text(
                    "Name",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),

                  SizedBox(height: 10,),
                  
                  Text(
                    "${sharedPreferences!.getString("name")}",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),

                  SizedBox(height: 10,),

                  Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),

                  SizedBox(height: 10,),

                  Text(
                    "${sharedPreferences!.getString("email")}",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.home,
                  size: 26.5,
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
                    color: Colors.purple,
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
