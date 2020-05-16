import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/model/product.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {

  bool isProductAdded = false;

  String imageUrl;

  File selectedImage;

  String productCategory, productId, productName, productPrice, productQuantity;

  final formKey = GlobalKey<FormState>();

  addProductForm(){
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(10.0),
        color: Colors.white,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),

            ),
            padding: EdgeInsets.all(10.0),
//          height: orientation == Orientation.landscape?  MediaQuery.of(context).size.height * 0.8: MediaQuery.of(context).size.height * 0.5 ,

            child: Form(
              key: formKey,
              child: Column(
//              mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Welcome Admin,',style: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 25.0),),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.category, color: Color.fromRGBO(56, 151, 46, 0.8),),
                      labelText: 'Product Category',
                    ),
                    validator: (input){
                      if(input.isEmpty){
                        return 'Invalid Category';
                      }
                      return null;
                    },
                    onSaved: (input) => productCategory = input,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(

                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: Color.fromRGBO(56, 151, 46, 0.8),),
                      labelText: 'Product Name',
                    ),
                    validator: (input){
                      if(input.isEmpty){
                        return 'Invalid Product Name';
                      }
                      return null;
                    },
                    onChanged: (input) => productName = input,
                  ),
                  TextFormField(

                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.attach_money, color: Color.fromRGBO(56, 151, 46, 0.8),),
                      labelText: 'Price',
                    ),
                    validator: (input){
                      if(input.isEmpty){
                        return 'Invalid Product Price';
                      }
                      if(int.parse(input) < 0){
                        return 'Invalid Product Price';
                      }
                      return null;
                    },
                    onChanged: (input) => productPrice = input,
                  ),
                  TextFormField(

                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.confirmation_number, color: Color.fromRGBO(56, 151, 46, 0.8),),
                      labelText: 'Product Quantity',
                    ),
                    validator: (input){
                      if(input.isEmpty){
                        return 'Invalid Product Name';
                      }
                      if(int.parse(input) < 0){
                        return 'Invalid Product Name';
                      }
                      return null;
                    },
                    onChanged: (input) => productQuantity = input,
                  ),
                  SizedBox(
                    height: 70,
                  ),

                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 1, end: 35),
                    curve: Curves.bounceOut,
                    duration: const Duration(seconds: 2),
                    builder: (context, double padd, _){
                      return RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: padd, vertical: padd/3),
                        color: Color.fromRGBO(56, 151, 46, 0.8),
                        onPressed: (){
                          saveProductData();
                        },
                        child: Text('SUBMIT',
                          style: TextStyle(
                            letterSpacing: 2.0,
                            color: Colors.white,
                            fontSize: 20.0,
                          ),),
                      );
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  saveProductData()async{
    if(selectedImage != null){
      if(formKey.currentState.validate()){
        formKey.currentState.save();
        setState(() {
          isProductAdded = true;
        });
        await uploadImage();
      }
    }
  }

  sendProductDataToFirestore() async{
    productId = DateTime.now().millisecondsSinceEpoch.toString();
    Product product = Product(productCategory: productCategory, productId: productId, productName: productName, productPrice: int.parse(productPrice), productQuantity: int.parse(productQuantity), imageUrl: this.imageUrl);
    await Firestore.instance.collection('products').document('category').collection('$productCategory').document('$productId').setData(product.toMap()).then((value) => setState((){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    })).catchError((err){
      setState(() {
        isProductAdded = false;
      });
    });
  }

  chooseImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = image;
    });
  }

  uploadImage() async{
    StorageReference storageReference = FirebaseStorage.instance.ref().child('image${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask storageUploadTask = storageReference.putFile(selectedImage);
    await storageUploadTask.onComplete.then((value) {
      storageReference.getDownloadURL().then((url){
        setState(() {
          imageUrl = url;
        });
        sendProductDataToFirestore();
      }).catchError((error){
        setState(() {
          isProductAdded = false;
        });
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: isProductAdded ? Center(child: CircularProgressIndicator()) : addProductForm(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          chooseImage();
        },
        backgroundColor: Color.fromRGBO(56, 151, 46, 0.8),
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
