import 'package:flutter/material.dart';
import 'package:flutter_app/productcategorylanding.dart';
import 'package:google_fonts/google_fonts.dart';

class Products extends StatefulWidget{
  @override
  ProductsState createState() => ProductsState();
}

class ProductsState extends State<Products>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(right: 15.0, left: 15.0),
        child: Column(
          children: <Widget>[
            Align(child: Text('Welcome', style: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 30.0),
            ),alignment: Alignment.centerLeft,),
            SizedBox(
              height: 20,
            ),
            Stack(
              children:<Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ProductCategoryLanding()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.srcATop),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network('https://images.pexels.com/photos/1546333/pexels-photo-1546333.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
                          fit: BoxFit.cover,),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.yellow,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),

                    child: Text('TITAN', style: GoogleFonts.robotoSlab(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.w500, letterSpacing: 2.0),),
                  ),
                ),
                Positioned(
                  top: 130,
                  left: 20,
                  child: Text(
                    'Summer Sale', style: GoogleFonts.roboto(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text('Explore >',  style: GoogleFonts.roboto(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500),),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Stack(
              children: <Widget>[
                ColorFiltered(
                  colorFilter: ColorFilter.mode(Colors.black12.withOpacity(0.1), BlendMode.srcATop),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network('https://images.pexels.com/photos/3165335/pexels-photo-3165335.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  child: Text('50% off on Gaming \nConsoles',style: GoogleFonts.roboto(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.w600),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}