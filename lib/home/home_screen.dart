import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
class Home_screen extends StatefulWidget {
  const Home_screen({super.key});

  @override
  State<Home_screen> createState() => _Home_screenState();
}

class _Home_screenState extends State<Home_screen> {
  File?imageFile;

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
        imageFile=File(croppedImage.path);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange[100],

      ),
      child: Scaffold(
        floatingActionButton:Wrap(
          direction: Axis.horizontal,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: FloatingActionButton(
                heroTag: "1",
                backgroundColor: Colors.orange[50],
                onPressed: (){
                  //show image dialog
                  _showImageDialog();
                },
                child: Icon(Icons.camera_enhance,
                  color: Colors.orange[400],
                ),
              ),
            ),
            Container(
              
              margin: EdgeInsets.all(10),
              child: FloatingActionButton(
              heroTag: "2",
                backgroundColor: Colors.orange[50],
                onPressed: (){
                
                
                //up image
                
                
                },
                child: Icon(Icons.cloud_upload,
                color: Colors.orange[400],),
              ),
            )
          ],
        ),
       backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.orange[200],
              
            ),
          ),
        ),
        
      ),
    );
  }
}
