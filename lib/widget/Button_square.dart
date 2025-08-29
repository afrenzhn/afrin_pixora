
//5 pg
import 'package:flutter/material.dart';
class Button extends StatelessWidget {
  final String text;
  final VoidCallback press;
  final Color colors;


  Button({
    required this.text,
    required this.press,
    required this.colors,


  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    onTap: press,
      child: Padding(
          padding: EdgeInsets.only(top: 10,bottom: 10),
        child: Container(
          width:150,
          height: 50,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.orange[700],
              ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
            ),
        ),
    );
  }
}
