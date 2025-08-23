import 'package:flutter/material.dart';
import 'package:pixora/forget_password/componenets/headt_txt.dart';
import 'package:pixora/forget_password/componenets/info.dart';

class Forgetpass extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
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
                HeadText(),
                Credential(),
              ],
            ),
          ),
        ),

      ),

    );
  }
}
