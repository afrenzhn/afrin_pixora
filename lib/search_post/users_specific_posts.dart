
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pixora/login/loginscreen.dart';
import 'package:pixora/owner_details/owner_details.dart';
import '../profile_screen/profile_screen.dart';
import '../search_post/search post.dart';

class UsersSpecificPostsScreen extends StatefulWidget {
 String?userId;

 UsersSpecificPostsScreen({
   this.userId,
});
  @override
  State<UsersSpecificPostsScreen> createState() => _UsersSpecificPostsScreenState();
}

class _UsersSpecificPostsScreenState extends State<UsersSpecificPostsScreen> {
 
  String? myImage;
  String? myName;

  @override
  void initState() {
    super.initState();
    readUserInfo();
  }

  void readUserInfo() async {
    FirebaseFirestore.instance
        .collection("user")
        .doc(widget.userId)
        .get()
        .then<dynamic>((DocumentSnapshot snapshot)async {
      myImage = snapshot.get("userImage");
      myName = snapshot.get("name");
      
    });
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
                      builder: (_) => OwnerDetails(),
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

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[200],
      appBar: AppBar(
      
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
      
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("wallpaper")
        .where("id",isEqualTo: widget.userId)
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            final docs = snapshot.data!.docs;

            {
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
