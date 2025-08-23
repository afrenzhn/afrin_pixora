import 'package:flutter/material.dart';
import 'package:pixora/login/componenets/info.dart';

import 'componenets/headings.dart';
class Loginscreen extends StatelessWidget {
   Loginscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      //bg color set

      decoration: BoxDecoration(
        color: Colors.black,

      ),

     child: Scaffold(
       backgroundColor: Colors.orange[100],
       body: Center(
         child: SingleChildScrollView(
           child: Column(
             children: [
               Headtexts(),
               Credential(),
             ],
           ),
         ),
       ),

     ),

    );
  }
}
