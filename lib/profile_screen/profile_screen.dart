import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pixora/home/home_screen.dart';
import 'package:pixora/login/loginscreen.dart';
import 'package:firebase_storage/firebase_storage.dart'as  fStorage;
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
  String? userNameInput;
  String?userImageUrl;
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
        _updateImageFirestore();
      });
    }
  }
  Future _updateUserName()async{

    await FirebaseFirestore.instance.collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
        {
          "name": userNameInput,


        });

  }

  _displayTextInputDialog(BuildContext)async{
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text(
            "Update Your Name Here"),
          content: TextField(
            onChanged: (value){
              setState(() {
                userNameInput=value;
              });
          },
            decoration: InputDecoration(
                hintText: "Type Here"
            ),

          ),
          actions: [
            ElevatedButton(
              child: Text("Cancel",
              style: TextStyle(
                color: Colors.deepOrange
              ),),
              onPressed: (){
                setState(() {
                  Navigator.pop(context);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent
              ),
            ),
            ElevatedButton(
              child: Text("Save",
                style: TextStyle(
                    color: Colors.deepOrange
                ),),
              onPressed: (){
              _updateUserName();
              updateProfileNameOnUserExistingPosts();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red
              ),
            ),
          ],
          );

      }
    );
  }
void _updateImageFirestore()async{
    String fileName=DateTime.now().microsecondsSinceEpoch.toString();
    fStorage.Reference reference =fStorage.FirebaseStorage.instance.ref()
    .child("userImages").child(fileName);
    fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
    fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete((){});
    await taskSnapshot.ref.getDownloadURL().then((url)async{
      userImageUrl=url;
    });
    await FirebaseFirestore.instance.collection("user")
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .update({
      "userImages":userImageUrl,
    });

}
updateProfileImageOnUserExistingPosts()async {
  await FirebaseFirestore.instance.collection("wallpaper")
      .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((snapshot) {
    for (int index = 0; index < snapshot.docs.length; index++) {
      String userProfileImageInPost = snapshot.docs[index]['userImage'];

      if (userProfileImageInPost != userImageUrl) {
        FirebaseFirestore.instance.collection("wallpaper")
            .doc(snapshot.docs[index].id)
            .update(
            {
              "userImage": userImageUrl,
            }
        );
      }
    }
  });
}
    updateProfileNameOnUserExistingPosts()async{
      await FirebaseFirestore.instance.collection("wallpaper")
          .where("id",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((snapshot)
      {
        for(int index =0 ;index<snapshot.docs.length;index++){
          String userProfileNameInPost=snapshot.docs[index]['Name'];

          if(userProfileNameInPost != userNameInput){
            FirebaseFirestore.instance.collection("wallpaper")
                .doc(snapshot.docs[index].id)
                .update(
                {
                  "Name":userNameInput,
                }
            );
          }
        }
      });


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
           Card(
             elevation: 3,
             shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(15)),
             margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
             child: ListTile(
               leading: CircleAvatar(
                 backgroundColor: Colors.orange[100],
                 child: Icon(Icons.person, color: Colors.deepOrange),
               ),
               title: Text(
                 name ?? "No Name",
                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
               ),
               subtitle: Text("Name"),
               trailing: IconButton(
                 icon: Icon(Icons.edit, color: Colors.deepOrange),
                 onPressed: () {
                   _displayTextInputDialog(context);
                 },
               ),
             ),
           ),

           // Email Card
           Card(
             elevation: 3,
             shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(15)),
             margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
             child: ListTile(
               leading: CircleAvatar(
                 backgroundColor: Colors.orange[100],
                 child: Icon(Icons.email, color: Colors.deepOrange),
               ),
               title: Text(
                 email ?? "No Email",
                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
               ),
               subtitle: Text("Email"),
             ),
           ),

           // Phone Number Card
           Card(
             elevation: 3,
             shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(15)),
             margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
             child: ListTile(
               leading: CircleAvatar(
                 backgroundColor: Colors.orange[100],
                 child: Icon(Icons.phone, color: Colors.deepOrange),
               ),
               title: Text(
                 phoneNo ?? "No Phone Number",
                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
               ),
               subtitle: Text("Phone Number"),
             ),
           ),
           SizedBox(height: 10,),

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
