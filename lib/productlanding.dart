import 'package:flutter/material.dart';
import 'package:flutter_app/buy.dart';
import 'package:flutter_app/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'home.dart';
class ProductLanding extends StatefulWidget {

  String productId, productName, imageUrl;
  int productPrice;

  ProductLanding({
    this.productId,
    this.imageUrl,
    this.productPrice,
    this.productName
  });

  @override
  _ProductLandingState createState() => _ProductLandingState(
      productId : this.productId,
      imageUrl : this.imageUrl,
      productPrice : this.productPrice,
      productName : this.productName
  );
}

class _ProductLandingState extends State<ProductLanding> {

  String productId, productName, imageUrl;
  int productPrice;

  Razorpay _razorpay;

  @override
  void initState(){
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  myOrders(String resp) async{
    await Firestore.instance.collection('myOrders').document('$userId').collection('orders').document(resp)
        .setData({
      'productId': productId,
      'productPrice': productPrice,
      'orderId': resp,
      'productName': productName,
    });
  }

  handlePaymentSuccess(PaymentSuccessResponse response){
    print('${response.paymentId} Payment Successful');
    myOrders(response.paymentId);
  }

  handlePaymentFailure(PaymentFailureResponse response){
    print('${response.code} Payment Unsuccessful');
  }

  handleExternalWallet(ExternalWalletResponse response){
    print('External Wallet');
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  checkout() async{
    var options = {
      'key': 'rzp_test_mKn49B9pkV1QsO',
      'amount': productPrice, //in the smallest currency sub-unit.
      'name': 'Streak Corp.',
//      'order_id': 'orderId12}', // Generate order_id using Orders API
      'description': '$productName',
      'prefill': {
        'contact': '9123456789',
        'email': 'amandeep110045@gmail.com'
      }
    };

    try{
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }

  }

  _ProductLandingState({
    this.productId,
    this.imageUrl,
    this.productPrice,
    this.productName
  });

  addProductToCart() async{
    await Firestore.instance.collection('cart').document('$userId').collection('products').document('$productId')
        .setData({
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'inCart': true,
      'imageUrl': imageUrl,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
                onTap: (){
                  addProductToCart();
                },
                child: Icon(Icons.shopping_cart, color: Colors.black,)),
          ),
        ],
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.black,)),
        title: Text('${productName.toUpperCase()}', style: GoogleFonts.roboto(
          color: Colors.black
        ),),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Image.network('$imageUrl', fit: BoxFit.cover,),
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            SizedBox(
              height: 5,
            ),



            Expanded(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: ListView(
                  children: <Widget>[

                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${productName.toUpperCase()}',style: GoogleFonts.roboto(color: Colors.black, fontSize: 35.0,
                                fontWeight: FontWeight.w400),
                            ),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '\$ $productPrice \t\t',style: GoogleFonts.roboto(color: Colors.black, fontSize: 20.0,
                                    fontWeight: FontWeight.w400),
                                ),
                                TextSpan(
                                  text: '\$ 700', style: GoogleFonts.roboto(decoration: TextDecoration.lineThrough, color: Colors.red, fontSize: 20.0,
                                    fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10,),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.red, Colors.orange],
                              ),
                            ),
                            child: Text('Assured Deal',style: GoogleFonts.roboto(color: Colors.black, fontSize: 15.0,
                                fontWeight: FontWeight.w400)),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Color.fromRGBO(56, 151, 46, 0.8),
                          ),
                          child: Text('4.2',style: GoogleFonts.roboto(color: Colors.white, fontSize: 15.0,
                              fontWeight: FontWeight.w400)),
                        ),
                        SizedBox(width: 10.0,),
                        Text('Very Good'),
                        Spacer(),
                        Text('42 reviews >', style: GoogleFonts.roboto(color: Colors.red, fontSize: 15.0, fontWeight: FontWeight.w500),),
                      ],
                    ),
                    Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
//                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Specifications',style: GoogleFonts.roboto(color: Colors.black, fontSize: 25.0,
                            fontWeight: FontWeight.w600)),
                        SizedBox(
                          height: 15,
                        ),
                        Table(
                          children: [
                            TableRow(
                              children: [
                                Text('ModelName:',style: GoogleFonts.roboto(color: Colors.black, fontSize: 20.0,
                                    fontWeight: FontWeight.w400),
                                ),
                                Text('${productName.toUpperCase()} gtx',style: GoogleFonts.roboto(color: Colors.black, fontSize: 20.0,
                                    fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Text('Price:',style: GoogleFonts.roboto(color: Colors.black, fontSize: 20.0,
                                    fontWeight: FontWeight.w400),
                                ),
                                Text('\$ $productPrice',style: GoogleFonts.roboto(color: Colors.black, fontSize: 20.0,
                                    fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Text('Model No.:',style: GoogleFonts.roboto(color: Colors.black, fontSize: 20.0,
                                    fontWeight: FontWeight.w400),
                                ),
                                Text('${productId.toString().substring(0,5)}-fx50dy',style: GoogleFonts.roboto(color: Colors.black, fontSize: 20.0,
                                    fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),



            GestureDetector(
              onTap: (){
                checkout();
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                color: Color.fromRGBO(56, 151, 46, 0.8),
                child: Align(
                    alignment: Alignment.center,
                    child: Text('Continue', style: GoogleFonts.roboto(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500),)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
