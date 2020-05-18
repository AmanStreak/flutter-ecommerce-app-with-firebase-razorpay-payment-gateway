import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/myOrderProvider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/main.dart';

class MyOrders extends StatefulWidget{
  @override
  MyOrdersState createState() => MyOrdersState();
}

class MyOrdersState extends State<MyOrders>{

  MyOrderProvider myOrderProvider;

  @override
  void initState(){
    super.initState();
    getOrderData();
  }
  
  getOrderData() async{
    print('$userId');
    QuerySnapshot snapshot = await Firestore.instance.collection('myOrders').document('$userId').collection('orders').getDocuments();
    print('avail');
    if(snapshot.documents.length != 0){
      print('avail');
      myOrderProvider.orderAvailability();
    }
  }

  noOrders(){
    return Center(
      child: Image.network('https://www.supplyvan.com/media/new_images/rsz_empty-cart.png'),
    );
  }

  showOrders(){
    return FutureBuilder(
      future: Firestore.instance.collection('myOrders').document('$userId').collection('orders').getDocuments(),
      builder: (context, snap){
        if(snap.connectionState == ConnectionState.done){
          return ListView.builder(
            itemCount: snap.data.documents.length,
            itemBuilder: (context, int i){
              return ListTile(
                title: Text('${snap.data.documents[i]['productName']}'),
                subtitle: Text('${snap.data.documents[i]['orderId']}'),
                trailing: Text('${snap.data.documents[i]['productPrice']}'),
                leading: Icon(Icons.monetization_on, color: Colors.green,),
              );
            },
          );
        }
        return Text('');
      },
    );
  }

  @override
  Widget build(BuildContext context){
//    final MyOrderProvider myOrderState = Provider.of<MyOrderProvider>(context);

    return ChangeNotifierProvider<MyOrderProvider>(
      create: (_) => MyOrderProvider(),
      child: Consumer<MyOrderProvider>(
        builder: (context, data, widget){
          myOrderProvider = Provider.of<MyOrderProvider>(context);
          return Scaffold(
            body: myOrderProvider.order ? showOrders() : noOrders(),
          );
        },
      ),
    );


  }
}