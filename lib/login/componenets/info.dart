import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pixora/forget_password/forget_password.dart';
import 'package:pixora/signup_screen/Signup_screen.dart';
import 'package:pixora/widget/Button_square.dart';
import 'package:pixora/widget/input.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../account_check/account_check.dart';
import '../../home/home_screen.dart';


class Credential extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding (
        padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Center(
            child: CircleAvatar(
              radius: 150,
              backgroundImage: AssetImage(
                "images/df2.png",


              ),
              backgroundColor: Colors.transparent,

            ),
            //inputdart khulbo
          ),
          SizedBox(height: 15,),
          InputField(
            hintText: "Enter Email",
            icon: Icons.email,
            obsecureText: false,
            textEditingController:_emailController,

          ),
          SizedBox(height: 15,),
          InputField(
          hintText: "Enter Password",
          icon: Icons.lock,
          obsecureText: true,
            textEditingController:_passController,
          ),
          SizedBox(height: 15,),
          Row(
           mainAxisAlignment: MainAxisAlignment.end,

            children: [
              GestureDetector(
                onTap: (){
                  //forgetpass edile ekhne theke okhne jabe
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Forgetpass()));
                },
                child: Text(

                  "Forget Password?",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    color: Colors.black,



                  ),
                ),

              )
            ],

          ),
          Button(
            text: "Log In",
            colors: Colors.black54,
            press: () async{

              try{
                await _auth.signInWithEmailAndPassword(
                 email: _emailController.text.trim().toLowerCase(),
                 password: _passController.text.trim(),
                );
                //login a dile homepage e jabe
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Home_screen()));
              }
              //pubs yml e flutter toast add korsi
              catch(error){

                Fluttertoast.showToast(
                  msg: "Error: ${error.toString()}",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }

            },
          ),
          AccountCheck(
            login: true,
            press: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>SignupScreen()));

            },




          )




        ],
      ),
    );
  }
}
