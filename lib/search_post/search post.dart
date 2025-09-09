import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pixora/home/home_screen.dart';
import 'package:pixora/search_post/user.dart';
import 'package:pixora/search_post/users_design.dart';
class SearchPost extends StatefulWidget {
  const SearchPost({super.key});

  @override
  State<SearchPost> createState() => _SearchPostState();
}

class _SearchPostState extends State<SearchPost> {
  Future<QuerySnapshot>?postDocumentsList;
  String userNameText=" ";
  initSearchingPost(String textEntered){
    postDocumentsList=FirebaseFirestore.instance.collection("user")
        .where("name",isGreaterThanOrEqualTo: textEntered)
        .get();
    setState(() {
      postDocumentsList;
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
        title: TextField(
          onChanged: (textEntered)
          {
            setState(() {
              userNameText=textEntered;

            });
            initSearchingPost(textEntered);
          },
          decoration: InputDecoration(
            hintText:  "Search post....",
            hintStyle: TextStyle(
              color: Colors.black,
            ),
            border: InputBorder.none,
            suffixIcon: IconButton(

                icon: Icon(Icons.search,color: Colors.black,),
              onPressed: (){
              initSearchingPost(userNameText);
              },
            ),
            prefixIcon: IconButton(
              padding: EdgeInsets.only(right: 12,bottom: 4),
                icon: Icon(Icons.arrow_back,color: Colors.black,),
                onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
          },
            )
          ),
        ),
      ),
     body: FutureBuilder<QuerySnapshot>(
         future: postDocumentsList,
         builder: (context,snapshot) {
           return snapshot.hasData
               ?
           ListView.builder(
             itemCount: snapshot.data!.docs.length,
             itemBuilder: (context, index) {
               User model =User.fromJson(
                 snapshot.data!.docs[index].data()! as Map<String,dynamic>

               );


               return UsersDesign(
                 model: model,
                 context: context,
               );
             },
           )

               :
               Center(child: Text("No Record Exists"),);
         }
     ),
    );
  }
}
