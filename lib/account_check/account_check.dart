import 'package:flutter/material.dart';

class AccountCheck extends StatelessWidget {

 final bool login;
 final VoidCallback press;

 AccountCheck({
   required this.login,
   required this.press,
});

  @override
  Widget build(BuildContext context) {
    return Row(

      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          login?"Don't have an Account? ":"Already have an Account?",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,

          ),

        ),
        SizedBox(width: 5,),
        GestureDetector(
          onTap: press,
          child: Text(
            login?"Create an Account":"Log In",
            style: TextStyle(
              fontSize: 16
,
            color: Colors.blue[900],
            fontWeight: FontWeight.bold),
          ),
        )


      ],






    );
  }
}
