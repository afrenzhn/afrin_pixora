import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pixora/home/home_screen.dart';
import 'package:pixora/login/loginscreen.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String?name='';
  String?email="";
  String? image='';
  String?phoneNo='';
  File? imageXFile;

  Future _getDataFromDatabase() async{
    await FirebaseFirestore.instance.collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((Snapshot)async{
          if(Snapshot.exists){
            setState(() {
              name=Snapshot.data()!['name'];
              email=Snapshot.data()!['email'];
             image= Snapshot.data()!['userImage'];
              phoneNo=Snapshot.data()!['phoneNumber'];
            });
          }

    });
  }
  @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
  }
  void _showImageDialog(){
    showDialog(
      context: context,
      builder: (context)
      {
        return AlertDialog(
          title: Text("Please choose an option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap:(){
                  //getfromcamera
                  _getFromCamera();
                },
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.all(4),
                      child: Icon(Icons.camera_alt_outlined,
                        color: Colors.black,
                      ),

                    ),
                    Text("Camera",
                      style: TextStyle(
                          color: Colors.black
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap:(){
                  _getFromGallery();
                  //getfromgallery
                },
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.all(4),
                      child: Icon(Icons.image,
                        color: Colors.black,
                      ),

                    ),
                    Text("Gallery",
                        style: TextStyle(
                            color: Colors.black
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  void _getFromCamera()async
  {
    XFile?pickedFile = await ImagePicker().pickImage(source:ImageSource.camera);
    _cropImage(pickedFile?.path);
    Navigator.pop(context);
  }
  //gallery theke anar jonno method
  void _getFromGallery()async
  {
    XFile?pickedFile = await ImagePicker().pickImage(source:ImageSource.gallery);
    _cropImage(pickedFile?.path);
    Navigator.pop(context);
  }
  void _cropImage(filePath)async{
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath:filePath,
        maxHeight:1080,
        maxWidth:1080
    );
    if(croppedImage!=null){
      setState(() {
        imageXFile=File(croppedImage.path);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.orange[200],

          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange[100],
        title: Center(
          child: Text("Profile",
          style: TextStyle(fontWeight: FontWeight.bold,
          fontFamily: "Morgan",letterSpacing: 3,fontSize: 30),
          ),

        ),
        leading: IconButton(
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
            },
            icon:Icon(Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
            )


        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.orange[50],

        ),
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           GestureDetector(
             onTap: (){
               _showImageDialog();
             },
             child: CircleAvatar(
               backgroundColor: Colors.orange,
               minRadius: 60,
               child: CircleAvatar(
                 radius: 55,
                 backgroundImage: imageXFile==null
                 ?
                 NetworkImage(
                   image!
                 )
                     :
                     Image.file
                       (imageXFile!).image,
               ),
             ),
           ),
           SizedBox(height: 10,),
           Row(
             crossAxisAlignment: CrossAxisAlignment.center,
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Text(
               'Name: '+name!,
               style: TextStyle(
                 fontSize: 25,
                 fontWeight: FontWeight.bold,
                 color: Colors.black,
               ),
             ),
             IconButton(
                 onPressed: (){
                   //displaytextinput
                 },
                 icon: Icon(Icons.edit),
             )
           ],
           ),
           SizedBox(height: 10,),
           Text(
             'Email: '+email!,
             style: TextStyle(
               fontSize: 20,
               fontWeight: FontWeight.bold,
               color: Colors.black,

             ),
           ),
           SizedBox(height: 10,),
           Text(
             'Phone Number: '+phoneNo!,
             style: TextStyle(
               fontSize: 20,
               fontWeight: FontWeight.bold,
               color: Colors.black,

             ),
           ),
           SizedBox(height: 20,),
           ElevatedButton(
               onPressed: (){
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Loginscreen()));
               },
               style: ElevatedButton.styleFrom(
               backgroundColor: Colors.orange,
               padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
               ),
               child: Text("Logout",
               style: TextStyle(color: Colors.white,fontSize: 20),),
           )

         ],
        ),
      ),
    );
  }
}
