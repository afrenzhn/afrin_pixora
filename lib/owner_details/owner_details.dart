import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pixora/home/home_screen.dart';

import '../widget/Button_square.dart';

class OwnerDetails extends StatefulWidget {
  String? img;
  String? userImg;
  String?name;
  DateTime?date;
  String?docId;
  String?userId;
  int?downloads;

  OwnerDetails({
    this.img,
    this.userImg,
    this.name,
    this.date,
    this.docId,
    this.userId,
    this.downloads,
});



  @override
  State<OwnerDetails> createState() => _OwnerDetailsState();
}

class _OwnerDetailsState extends State<OwnerDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.orange[50],
        ),
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                  color: Colors.black,
                  child: Column(
                    children: [
                      Image.network(

                        widget.img!,
                        width: MediaQuery.of(context).size.width,
                      )

                    ],
                  ),
                ),
                SizedBox(height: 30,),

                Text("Owner Information",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                ),
                SizedBox(height: 30,),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    image:DecorationImage(
                      image: NetworkImage(
                        widget.userImg!,

                      ),
                      fit: BoxFit.cover,

                    )
                  ),
                ),
                SizedBox(height: 30,),
                Text("Uploaded by: "+widget.name!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height:30),
                Text(
                  DateFormat("dd MMMM yyy -hh:mm a").format(widget.date!).toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                FirebaseAuth.instance.currentUser!.uid==widget.userId
                ?
                    Padding(
                        padding: EdgeInsets.only(left: 8,right: 8),
                      child: Button(
                        text: "Delete",
                        colors: Colors.orange,

                        press: ()async{
                          FirebaseFirestore.instance.collection("wallpaper")
                              .doc(widget.docId).delete()
                              .then((value)
                              {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
                              });
                        }
                      ),
                    )
                    :
                    Container(),
                Padding(
                  padding: EdgeInsets.only(left: 8,right: 8),
                  child: Button(
                    text: "Go Back",
                    colors: Colors.orange,
                    press: ()async{
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
                    },


                  ),
                )


              ],
            )
          ],
        ),
      ),




    );
  }
}
