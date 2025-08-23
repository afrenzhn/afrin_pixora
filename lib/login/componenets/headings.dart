import 'package:flutter/material.dart';
class Headtexts extends StatelessWidget {
   Headtexts({super.key});
// log in e call korbo
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;

    return Padding(

      padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 15.0),
      child: Column(
        children: [

          SizedBox(height:size.height*0.05),
          Center(

            //signup page er
            child: Container(


              child: const Text("Pixora",
              style: TextStyle(
                fontSize:55,
                letterSpacing: 5,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: "Morgan",

              ),
              ),
            ),
          ),
          const SizedBox(height: 8),


        ],
      ),
    );
  }
}
