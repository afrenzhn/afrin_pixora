import 'package:flutter/material.dart';

import 'text_field.dart';
class InputField extends StatelessWidget {
//4th page
  final String hintText;
  final IconData icon;
  final bool obsecureText;
  final TextEditingController textEditingController;
  //constructor names InputField
  InputField({
    required this.hintText,
    required this.icon,
    required this.obsecureText,
    required this.textEditingController,
}

);
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      //another dart file  khulbo txtfield
//txt field er design

      child: TextField(
        cursorColor: Colors.black,
        obscureText: obsecureText,
        controller:textEditingController ,
        decoration: InputDecoration(
          hintText: hintText,
          helperStyle: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
          prefixIcon: Icon(icon,color: Colors.black,size: 20,),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: BorderSide.none, // Remove border when not focused
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: BorderSide(color: Colors.deepOrange), // Border when not focused
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: BorderSide(color: Colors.teal), // Border when focused
          ),
        ),

      ),


    );
  }
}
