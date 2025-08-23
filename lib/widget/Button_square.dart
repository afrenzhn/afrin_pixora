
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
          padding: EdgeInsets.only(top: 6,bottom: 6),
        child: Container(
          width:200,
          height: 50,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.orange[700],
              ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20,
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
