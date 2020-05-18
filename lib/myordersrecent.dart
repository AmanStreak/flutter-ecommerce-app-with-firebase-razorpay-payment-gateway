import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/main.dart';
class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  
  bool orders = false;
  
  @override
  void initState(){
    super.initState();
    getOrderData();
  }
  
  getOrderData() async{
    QuerySnapshot snapshot = await Firestore.instance.collection('myOrders').document('$userId').collection('orders').getDocuments();
    print('MyOrders');
    if(snapshot.documents.isNotEmpty){
      setState(() {
        orders = true;
      });
    }
  }
  
  showMyOrders(){
    return Container(

      child: FutureBuilder(
        future: Firestore.instance.collection('myOrders').document('$userId').collection('orders').getDocuments(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, int i){
              return ListTile(
                leading: Icon(Icons.monetization_on, color: Colors.green,),
                title: Text('${snapshot.data.documents[i]['productName']}'),
                subtitle: Text('Order Id: ${snapshot.data.documents[i]['orderId']}'),
                trailing: Text('${snapshot.data.documents[i]['productPrice']}'),
              );
            },
          );
        },
      ),
    );
  }
  
  noOrders(){
    return Center(
      child: Image.network('https://www.supplyvan.com/media/new_images/rsz_empty-cart.png'),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: orders? showMyOrders() : noOrders(),
    );
  }
}
