import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:pixora/account_check/account_check.dart';
import 'package:pixora/home/home_screen.dart';
import 'package:pixora/login/loginscreen.dart';
import 'package:pixora/widget/input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widget/Button_square.dart';


class Credentials extends StatefulWidget {
  
  @override
  State<Credentials> createState() => _CredentialsState();
}

class _CredentialsState extends State<Credentials> {
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final TextEditingController _fullNameController=TextEditingController(text: "");
  final TextEditingController _emailTextController=TextEditingController(text: "");
  final TextEditingController _passController=TextEditingController(text: "");
  final TextEditingController _phoneNumberController=TextEditingController(text: "");

File?imageFile;
String?imageUrl;
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
  //camera theke anar jonno method
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
        imageFile=File(croppedImage.path);
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    return  Padding(
        padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              _showImageDialog();
              //create showimagedialog
            },
            child: CircleAvatar(
              radius: 80,

              backgroundImage: imageFile==null
              ?
                  AssetImage("images/image3.0.jpg")
                  :
                  Image.file(imageFile!).image,
            ),
          ),
          SizedBox(height: 8,),
          InputField(
            hintText: "Enter Username",
            obsecureText: false,
            icon: Icons.person,
            textEditingController: _fullNameController,
          ),
          SizedBox(height: 5,),
          InputField(
            hintText: "Enter E-mail",
            obsecureText: false,
            icon: Icons.email,
            textEditingController: _emailTextController,
          ),
          SizedBox(height: 5,),
          InputField(
            hintText: "Enter Password",
            obsecureText: true,
            icon: Icons.lock,
            textEditingController: _passController,
          ),
          SizedBox(height: 5,),
          InputField(
            hintText: "Enter Phone Number",
            obsecureText: false,
            icon: Icons.phone,
            textEditingController: _phoneNumberController,
          ),
          SizedBox(height: 5,),
          Button(
            text: "Create Account",
            colors: Colors.deepOrange,
            press: () async {
              try {
                String? imageUrl;

                // Only upload if an image is selected
                if (imageFile != null) {
                  final ref = FirebaseStorage.instance
                      .ref()
                      .child("userImages")
                      .child(DateTime.now().toString() + ".jpg");

                  await ref.putFile(imageFile!);
                  imageUrl = await ref.getDownloadURL();
                }

                // Create user with email + password
                await _auth.createUserWithEmailAndPassword(
                  email: _emailTextController.text.trim(),
                  password: _passController.text.trim(),
                );

                final User? user = _auth.currentUser;
                final _uid = user!.uid;

                // Save user info to Firestore
                await FirebaseFirestore.instance.collection("user").doc(_uid).set({
                  'id': _uid,
                  'userImage': imageUrl ?? "", // <-- leave empty if no image
                  'name': _fullNameController.text.trim(),
                  'email': _emailTextController.text.trim(),
                  'phoneNumber': _phoneNumberController.text.trim(),
                  'createAt': FieldValue.serverTimestamp(),
                });

                Navigator.canPop(context) ? Navigator.pop(context) : null;
              } catch (error) {
                Fluttertoast.showToast(msg: error.toString());
              }
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
            },
          ),

          AccountCheck(
            login: false,
            press: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Loginscreen()));
            },
          )

        ],

    ),
    );
  }
}
