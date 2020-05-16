import 'package:flutter/material.dart';
import 'main.dart';
import 'package:flutter_app/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
class LogIn extends StatefulWidget{
  @override
  LogInState createState() => LogInState();
}

AuthResult authResult;

class LogInState extends State<LogIn>{

  String email, password;

  bool showPassword = true;


  bool isSignIn = true;

  @override
  void initState(){
    super.initState();

  }

  final formKey = GlobalKey<FormState>();

  saveUserCridentials() async{
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      setState((){
        isSignIn = false;
      });
      await signIn();
    }
  }

  signIn() async{
    authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).catchError((error){
      setState(() {
        isSignIn = true;
      });
      print(error.toString());
    });
    try{
      if(authResult.user.uid != null){
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setString('user', authResult.user.uid).then((data){
          print('Data');
        });

        setState(() {
          isSignIn = false;
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyApp()),
        );
      }
    }
    catch(err){
      print(err.toString());
    }
  }

  signInForm(Orientation orientation){
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(10.0),
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),

          ),
          padding: EdgeInsets.all(10.0),
          height: orientation == Orientation.landscape?  MediaQuery.of(context).size.height * 0.8: MediaQuery.of(context).size.height * 0.5 ,

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
                      Text('Welcome back,',style: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 25.0),),

                      GestureDetector(
                          onTap: (){
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => SignUp()),
                            );
                          },
                          child: Text('Sign Up',style: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 20.0, color: Color.fromRGBO(56, 151, 46, 0.8)),)),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                    child: Text('Sign in to continue',style: GoogleFonts.roboto(fontWeight: FontWeight.w400, fontSize: 15.0))),
                SizedBox(
                  height: 50,
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
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: showPassword,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock, color: Color.fromRGBO(56, 151, 46, 0.8),),
                    suffixIcon: GestureDetector(
                        child: Icon(Icons.remove_red_eye),
                        onTap: (){
                          setState((){
                            showPassword = !showPassword;
                          });
                        },
                    ),
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
                        saveUserCridentials();
                      },
                      child: Text('LOGIN',
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
//                Row(
//                  mainAxisSize: MainAxisSize.min,
//                  children: <Widget>[
//                    Text("Don't have an account?",
//                      style: TextStyle(
//                        fontSize: 17.0,
//
//                      ),),
//                    InkWell(
//                      onTap: (){
//
//                        Navigator.of(context).push(
//                          MaterialPageRoute(builder: (context) => SignUp()),
//                        );
//                      },
//                      child: Text("\t Sign-Up",style: TextStyle(
//                        fontSize: 18.0,
//                        fontWeight: FontWeight.bold,
//                        color: Theme.of(context).accentColor,
//                      ),),
//                    ),
//                  ],
//                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(

      body: isSignIn? signInForm(orientation): Center(child: CircularProgressIndicator()),
    );
  }
}