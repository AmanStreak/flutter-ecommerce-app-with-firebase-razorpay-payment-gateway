import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {

  bool emptyCart = true;

  @override
  void initState(){
    super.initState();
    getCartData();
  }

  @override
  void dispose(){
    super.dispose();

  }

  getCartData() async{
   await Firestore.instance.collection('cart').document('$userId').collection('products')
        .where('inCart', isEqualTo: true).getDocuments().then((doc){
          if(doc.documents.length != 0){
            if(!mounted) return;
            setState(() {
              emptyCart = false;
            });
            showCartItems();
          }
   });

  }

  showEmptyCart(){
    return Center(
      child: Image.network('https://www.supplyvan.com/media/new_images/rsz_empty-cart.png'),
    );
  }

  showCartItems(){
    return Container(
      child: FutureBuilder(
        future: Firestore.instance.collection('cart').document('$userId').collection('products').getDocuments(),
        builder: (context, snap){


          if(snap.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snap.data.documents.length,
            itemBuilder: (context, int i){
              if(snap.data.documents[i]['inCart']){
                return Padding(
                  padding: const EdgeInsets.only(top: 5, right: 5),
                  child: GestureDetector(
                    onTap: (){},
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
//                                    Align(
//                                        alignment: Alignment.centerLeft,
//                                        child: Text('Category: ${snap.data.documents[i]['productCategory']}', style: GoogleFonts.roboto(fontWeight: FontWeight.w400),)),
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
              }
              return Text('');
            },
          );


        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: emptyCart? showEmptyCart(): showCartItems(),
    );
  }
}
