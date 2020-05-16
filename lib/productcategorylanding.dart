import 'package:flutter/material.dart';
import 'package:flutter_app/productlanding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ProductCategoryLanding extends StatefulWidget{
  ProductCategoryLandingState createState() => ProductCategoryLandingState();
}

class ProductCategoryLandingState extends State<ProductCategoryLanding>{

  Orientation orientation;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category'),
      ),
      body: FutureBuilder(
        future: Firestore.instance.collection('products').document('category').collection('watch').getDocuments(),
        builder: (context, AsyncSnapshot snap){
          if(snap.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snap.data.documents.length,
            itemBuilder: (context, int i){
              return Padding(
                padding: const EdgeInsets.only(top: 5, right: 5),
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ProductLanding(
                        imageUrl: snap.data.documents[i]['imageUrl'],
                        productId: snap.data.documents[i]['productId'],
                        productName: snap.data.documents[i]['productName'],
                        productPrice: snap.data.documents[i]['productPrice'],
                      )),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
//                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                height: MediaQuery.of(context).size.width * 0.2,
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Image.network('${snap.data.documents[i]['imageUrl']}',
                                  height: 90, alignment: Alignment.centerLeft, fit: BoxFit.cover, ),
                              ),
                              Container(
//                                color: Colors.grey,
                                height: 90,
                                width: MediaQuery.of(context).size.width * 0.65,
                                padding: EdgeInsets.all(10.0),
                                child: Column(
//                      mainAxisAlignment: MainAxisAlignment.start,
//                      mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('${snap.data.documents[i]['productName']}', style: GoogleFonts.roboto(fontWeight: FontWeight.w600),)),
                                    Spacer(),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Category: ${snap.data.documents[i]['productCategory']}', style: GoogleFonts.roboto(fontWeight: FontWeight.w400),)),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text('\$ ${snap.data.documents[i]['productPrice']}', style: GoogleFonts.roboto(fontWeight: FontWeight.w600),)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),


                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}