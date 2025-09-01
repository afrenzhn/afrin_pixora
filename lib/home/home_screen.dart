import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pixora/login/loginscreen.dart';
import 'package:pixora/owner_details/owner_details.dart';
import '../profile_screen/profile_screen.dart';
import '../search_post/search post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String changeTitle = "Grid View";
  bool checkView = false;

  File? imageFile;
  String? imageUrl;
  String? myImage;
  String? myName;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    readUserInfo();
  }

  void readUserInfo() async {
    FirebaseFirestore.instance
        .collection("user")
        .doc(_auth.currentUser!.uid)
        .get()
        .then((snapshot) {
      myImage = snapshot.get("userImage");
      myName = snapshot.get("name");
      setState(() {});
    });
  }

  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Please choose an option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  _getFromCamera();
                },
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.camera_alt_outlined, color: Colors.black),
                    ),
                    Text("Camera", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  _getFromGallery();
                },
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.image, color: Colors.black),
                    ),
                    Text("Gallery", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile?.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile?.path);
    Navigator.pop(context);
  }

  void _cropImage(String? filePath) async {
    if (filePath == null) return;
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  void _uploadImage() async {
    if (imageFile == null) {
      Fluttertoast.showToast(msg: "Please select an Image");
      return;
    }
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child("user Images")
          .child(DateTime.now().toString() + '.jpg');
      await ref.putFile(imageFile!);
      imageUrl = await ref.getDownloadURL();
      await FirebaseFirestore.instance.collection("wallpaper").doc(DateTime.now().toString()).set({
        'id': _auth.currentUser!.uid,
        'userImage': myImage,
        'name': myName,
        'email': _auth.currentUser!.email,
        'Image': imageUrl,
        'downloads': 0,
        'createdAt': DateTime.now(),
      });
      Fluttertoast.showToast(msg: "Image Uploaded Successfully");
      setState(() {
        imageFile = null;
      });
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  Widget listViewWidget(String docId, String img, String userImg, String name, DateTime date,
      String userId, int downloads) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 8,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OwnerDetails(
                        img: img,
                        userImg: userImg,
                        name: name,
                        date: date,
                        docId: docId,
                        userId: userId,
                        downloads: downloads,
                      ),
                    ),
                  );
                },
                child: Image.network(img, fit: BoxFit.cover),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(userImg),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text(DateFormat("dd MMMM, yyyy - hh:mm a").format(date)),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget gridViewWidget(String docId, String img, String userImg, String name, DateTime date,
      String userId, int downloads) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => OwnerDetails(
              img: img,
              userImg: userImg,
              name: name,
              date: date,
              docId: docId,
              userId: userId,
              downloads: downloads,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        child: Image.network(img, fit: BoxFit.cover),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            setState(() {
              changeTitle = "List View";
              checkView = true;
            });
          },
          onDoubleTap: () {
            setState(() {
              changeTitle = "Grid View";
              checkView = false;
            });
          },
          child: Text(changeTitle),
        ),
        leading: IconButton(
          icon: const Icon(Icons.login_outlined),
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) =>  Loginscreen()),
            );
          },
        ),
        backgroundColor: Colors.orange[200],
        actions: [
          IconButton(
            icon: const Icon(Icons.person_search_outlined),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => SearchPost()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => ProfileScreen()));
            },
          ),
        ],
      ),
      floatingActionButton: Wrap(
        direction: Axis.horizontal,
        children: [
          FloatingActionButton(
            heroTag: "1",
            backgroundColor: Colors.orange[50],
            onPressed: _showImageDialog,
            child: Icon(Icons.camera_enhance, color: Colors.orange[400]),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: "2",
            backgroundColor: Colors.orange[50],
            onPressed: _uploadImage,
            child: Icon(Icons.cloud_upload, color: Colors.orange[400]),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("wallpaper")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            final docs = snapshot.data!.docs;

            if (checkView) {
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  return listViewWidget(
                    doc.id,
                    doc["Image"],
                    doc["userImage"],
                    doc["name"],
                    (doc["createdAt"] as Timestamp).toDate(),
                    doc["id"],
                    doc["downloads"],
                  );
                },
              );
            } else {
              return GridView.builder(
                padding: const EdgeInsets.all(6),
                itemCount: docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  return gridViewWidget(
                    doc.id,
                    doc["Image"],
                    doc["userImage"],
                    doc["name"],
                    (doc["createdAt"] as Timestamp).toDate(),
                    doc["id"],
                    doc["downloads"],
                  );
                },
              );
            }
          } else {
            return const Center(
              child: Text(
                "No wallpapers found",
                style: TextStyle(fontSize: 20),
              ),
            );
          }
        },
      ),
    );
  }
}
