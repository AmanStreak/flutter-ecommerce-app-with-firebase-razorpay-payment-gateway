import 'package:flutter/material.dart';
import 'package:flutter_app/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/model/user.dart';
import 'package:google_fonts/google_fonts.dart';
class SignUp extends StatefulWidget{
  @override
  SignUpState createState() => SignUpState();
}

AuthResult authResult;

class SignUpState extends State<SignUp>{

  bool isSignUp = true;
  bool showPassword = true;
  bool confirmPassword = true;
  String name;
  String userId;
  String email, password;
  final formKey = GlobalKey<FormState>();



  saveUserCridentials() async{
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      setState((){
        isSignUp = false;
      });
      await createUser();
    }
  }

  createUser() async{
    authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).catchError((e){
      setState(() {
        isSignUp = true;
      });
      print(e);
    });
    print('AUTH ${authResult.user.uid}');
    if(authResult.user.uid != null){
      sendUserDetailsToFireStore();
    }
  }

  sendUserDetailsToFireStore() async{
    userId = authResult.user.uid;
    User userData = User(email: this.email, userId: this.userId, isAdmin: false, name: this.name);
    await Firestore.instance.collection('users').document(userId).setData(userData.toMap()).catchError((e){
      print(e.toString());
      setState((){
        isSignUp = true;
      });
    }).then((data){
      if(authResult.user.uid != null){
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  signUpForm(orientation){
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(10.0),
//        color: Theme.of(context).accentColor,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),

          ),
          padding: EdgeInsets.all(10.0),
          height: orientation == Orientation.landscape?  MediaQuery.of(context).size.height * 0.8: MediaQuery.of(context).size.height * 0.5,

          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Welcome',style: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 30.0),),
                    GestureDetector(
                          onTap: (){
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => LogIn()),
                            );
                          },
                        child: Text('Sign in',style: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 20.0, color: Color.fromRGBO(56, 151, 46, 0.8)),)),
                  ],
                ),
              ),
              SizedBox(
                height: 70,
              ),
              Form(
                key: formKey,
                child: Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person, color: Color.fromRGBO(56, 151, 46, 0.8),),
                        labelText: 'Name',
                      ),
                      validator: (input){

                        if(input.isEmpty){
                          return 'Invalid Name';
                        }

                        if(input.length > 30){
                          return 'Invalid Email';
                        }
                        return null;
                      },
                      onSaved: (input) => name = input,
                    ),

                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.alternate_email, color: Color.fromRGBO(56, 151, 46, 0.8),),
                        labelText: 'Email',
                      ),
                      validator: (input){
                        if(!input.contains('.')){
                          return 'Invalid Email';
                        }
                        if(input.isEmpty){
                          return 'Invalid Email';
                        }
                        if(!input.contains('@')){
                          return 'Invalid Email';
                        }
                        if(input.length > 30){
                          return 'Invalid Email';
                        }
                        return null;
                      },
                      onSaved: (input) => email = input,
                    ),
//                      SizedBox(
//                        height: 10,
//                      ),
                    TextFormField(
                      obscureText: showPassword,

                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Color.fromRGBO(56, 151, 46, 0.8),),
                        suffixIcon: GestureDetector(
                          onTap: (){
                            setState((){
                              showPassword = !showPassword;
                            });
                          },
                          child: Icon(Icons.remove_red_eye)),
                        labelText: 'Password',
                      ),
                      validator: (input){
                        if(input.length < 6){
                          return 'Password length too short';
                        }
                        return null;
                      },
                      onChanged: (input) => password = input,
                    ),
                    TextFormField(
                      obscureText: confirmPassword,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock, color: Color.fromRGBO(56, 151, 46, 0.8),),
                          suffixIcon: GestureDetector(
                              onTap: (){
                                setState((){
                                  confirmPassword = !confirmPassword;
                                });
                              },
                              child: Icon(Icons.remove_red_eye)),
                            labelText: 'Confirm Password',

                        ),
                        validator: (input){
                          if(input != password){
                            return "Password should be same";
                          }
                          return null;
                        }
                    ),
                    SizedBox(
                      height: 50,
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
                            saveUserCridentials();
                          },
                          child: Text('SIGNUP',
                            style: TextStyle(
                              letterSpacing: 2.0,
                              color: Colors.white,
                              fontSize: 20.0,
                            ),),
                        );
                      },
                    ),
                    SizedBox(
                      height: 65,
                    ),

       //             Text('By creating an account, you agree \nto our terms & conditions.', textAlign: TextAlign.center,),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'By creating an account, you agree', style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: '\nto our ', style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: 'terms & conditions.', style: TextStyle(color: Colors.black, decoration: TextDecoration.underline, decorationColor: Colors.green, decorationStyle: TextDecorationStyle.solid),
                          ),
                        ],
                      ),
                    ),


//                    Row(
//                      mainAxisSize: MainAxisSize.min,
//                      children: <Widget>[
//                        Text("Already have an account?",
//                          style: TextStyle(
//                            fontSize: 17.0,
//
//                          ),),
//                        InkWell(
//                          onTap: (){
//
//                            Navigator.of(context).push(
//                              MaterialPageRoute(builder: (context) => LogIn()),
//                            );
//                          },
//                          child: Text("\t LogIn",style: TextStyle(
//                            fontSize: 18.0,
//                            fontWeight: FontWeight.bold,
//                            color: Theme.of(context).accentColor,
//                          ),),
//                        ),
//                      ],
//                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context){
    Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      backgroundColor: Colors.white,
      body: isSignUp? signUpForm(orientation): Center(child: CircularProgressIndicator()),
    );
  }
}