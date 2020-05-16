import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  logoutUser() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await FirebaseAuth.instance.signOut().then((data){
       pref.clear().then((data){
         Navigator.of(context).pushReplacement(
           MaterialPageRoute(builder: (context) => MyApp()),
         );
       });
     });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          CircleAvatar(
            radius: 50.0,
            backgroundImage: NetworkImage('https://pbs.twimg.com/profile_images/1255017440708382720/9btmpsKr_400x400.png'),
          ),
          SizedBox(
            height: 15,
          ),
          Divider(),
          StreamBuilder(
            stream: Firestore.instance.collection('users').document('$userId').snapshots(),
            builder: (context, snap){
              if(snap.connectionState == ConnectionState.waiting){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

                return Table(

//                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: {
                    0 : FixedColumnWidth(50.0),
                    1 : FixedColumnWidth(150.0)
                  },
                  children: [
                    TableRow(

                      children: [
                        Icon(Icons.person),
                        Text('Name :', style: GoogleFonts.roboto(fontSize: 16.0)),
                        Text('${snap.data['name']}', style: GoogleFonts.roboto(fontSize: 16.0)),
                      ],
                    ),

                    TableRow(
                      children: [
                        Icon(Icons.alternate_email),
                        Text('Email :', style: GoogleFonts.roboto(fontSize: 16.0)),
                        Text('${snap.data['email']}', style: GoogleFonts.roboto(fontSize: 16.0)),
                      ],
                    ),
                  ],
                );

            },
          ),
          SizedBox(
            height: 100,
          ),
          GestureDetector(
            onTap: (){
              logoutUser();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
              child: Text('LOGOUT', style: GoogleFonts.roboto(fontSize: 20.0, color: Colors.white,
                  fontWeight: FontWeight.w400, letterSpacing: 1.0)),
            ),
          ),
        ],
      ),
    );
  }
}
