import 'package:flutter/material.dart';
class HeadText extends StatelessWidget {
  const HeadText({super.key});

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
              child: const Text("Forget Password?",
                style: TextStyle(
                  fontSize:30,
                  letterSpacing: 5,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Morgan",

                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            //signup page er
            child: Container(
              child: const Text("Reset Here",
                style: TextStyle(
                  fontSize:25,
                  letterSpacing: 5,
                  color: Colors.black,
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
