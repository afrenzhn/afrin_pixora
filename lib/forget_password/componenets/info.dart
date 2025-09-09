
import 'package:firebase_auth/firebase_auth.dart';
import'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pixora/account_check/account_check.dart';
import 'package:pixora/login/loginscreen.dart';
import 'package:pixora/signup_screen/Signup_screen.dart';
import 'package:pixora/widget/Button_square.dart';
import 'package:pixora/widget/input.dart';


class Credential extends StatelessWidget {
 final FirebaseAuth _auth = FirebaseAuth.instance;

final TextEditingController _emailTextController=TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Center(
              child: Image.asset("images/forget2.png",
              width: 400,

              )
              ,
            ),
          ),
          SizedBox(height: 10,),
          InputField(
            hintText: "Enter email",
            obsecureText: false,
            icon: Icons.email_rounded,
            textEditingController: _emailTextController,

          ),
          SizedBox(height: 5,),
         Center(
           child: Button(
             text:"Send Link",
             colors: Colors.deepOrange,
             press: () async {
               try{
                 await _auth.sendPasswordResetEmail(
                 email: _emailTextController.text
                 );
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                   backgroundColor: Colors.orange,
                   content: Text("Password reset email has been sent",
                   style: TextStyle(
                     fontSize: 18
                   ),
                     ),

                 ),

           );
           }
           on FirebaseAuthException catch(error){
                 Fluttertoast.showToast(msg: error.toString());

           }
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Loginscreen()));

             },
           ),
         ),
          TextButton(
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>SignupScreen()));

              },
              child: Center(child: Text("Create Account")),
          ),


          AccountCheck(
              login: false,
              press: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Loginscreen()));

              },
          )
        ],
      ),
    );
  }
}
