//import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class Buy extends StatefulWidget {
  @override
  _BuyState createState() => _BuyState();
}

class _BuyState extends State<Buy> {

//  static const platform = const MethodChannel("razorpay_flutter");

//  static const platform = const MethodChannel("razorpay_flutter");

  Razorpay _razorpay;

  @override
  void initState(){
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  handlePaymentSuccess(PaymentSuccessResponse response){
    print('${response.paymentId} Payment Successful');

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
      'key': 'api_key',
      'amount': 100, //in the smallest currency sub-unit.
      'name': 'Streak Corp.',
//      'order_id': 'orderId12}', // Generate order_id using Orders API
      'description': 'Fine T-Shirt',
      'prefill': {
        'contact': 'phone_number',
        'email': 'email_id'
      }
    };

    try{
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: (){
            checkout();
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
            child: Text('BUY', style: TextStyle(
              fontSize: 20.0, color: Colors.white
            ),),
          ),
        ),
      ),
    );
  }
}
