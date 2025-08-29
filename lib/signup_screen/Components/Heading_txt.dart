import 'package:flutter/material.dart';

class HeadingText extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 30,vertical: 15),
      child: Column(
        children: [
          SizedBox(height:size.height*0.05),
          Center(
            //2-pg, heading,text
            child: Container(
              child:  Text("Pixora",
                style: TextStyle(
                  fontSize:35,
                  letterSpacing: 5,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Morgan",

                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Center(
            //2-pg, heading,text
            child: Container(

              child:  Text("Create Account",
                style: TextStyle(
                  fontSize:25,
                  letterSpacing: 5,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Morgan",

                ),
              ),
            ),
          ),


        ],
      ),



    );
  }
}
