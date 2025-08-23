import 'package:flutter/material.dart';
import 'package:pixora/signup_screen/Components/infoss.dart';

import 'Components/Heading_txt.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
                HeadingText(),
                Credentials(),
              ],
            ),
          ),
        ),

      ),

    );;
  }
}
