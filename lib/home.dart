import 'package:flutter/material.dart';
import 'package:flutter_app/cart.dart';
import 'package:flutter_app/myorders.dart';
import 'package:flutter_app/productadmin.dart';
import 'package:flutter_app/products.dart';
import 'package:flutter_app/profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isAdmin = false;

  String userId;

  int index = 0;

  PageController pageController = PageController();

  @override
  void initState(){
    super.initState();
    pageController = PageController(initialPage: 0);
    getUserId();
  }

  String name;



  getUserId() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString('user');
    print(userId);
    DocumentSnapshot documentSnapshot = await Firestore.instance.collection('users').document(userId).get();
    if(documentSnapshot.exists){
      setState((){
        name = documentSnapshot.data['name'];
        isAdmin = documentSnapshot.data['isAdmin'];
      });
    }
  }

  checkAdmin(){
    if(isAdmin){
      return Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Align(
          alignment: Alignment.center,
            child: GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Admin()),
                  );
                },
                child: Text('Admin', style: GoogleFonts.roboto(color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w400),))),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (int index){
          pageController.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.bounceOut);
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            title: Text('Home'),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text('Cart'),
            icon: Icon(Icons.shopping_cart),
          ),
          BottomNavigationBarItem(
            title: Text('Orders'),
            icon: Icon(Icons.bookmark_border)
          ),
          BottomNavigationBarItem(
            title: Text('Profile'),
            icon: Icon(Icons.person),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text('Hi $name,', style: GoogleFonts.roboto(color: Colors.black)),
        actions: <Widget>[
          isAdmin? checkAdmin() : Text(''),
        ],
      ),
      body: PageView(

        onPageChanged: (int i){
          setState(() {
            index = i;
          });
        },
        controller: pageController,
        children: <Widget>[
          Products(),
          Cart(),
          MyOrders(),
          Profile(),
        ],
      ),
    );
  }
}
