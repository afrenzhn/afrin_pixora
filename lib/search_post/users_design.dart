import 'package:flutter/material.dart';
import 'package:pixora/search_post/user.dart';
import 'package:pixora/search_post/users_specific_posts.dart';
class UsersDesign extends StatefulWidget {


  User?model;
  BuildContext?context;
  UsersDesign({
    this.model,
    this.context,
});


  @override
  State<UsersDesign> createState() => _UsersDesignState();
}

class _UsersDesignState extends State<UsersDesign> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>UsersSpecificPostsScreen(
          userId: widget.model!.id,
        )));

      },
      child: Card(
        child:Padding(padding:EdgeInsets.all(16),
          child: Container(
            height: 150,
              width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.orange[400],
                  minRadius: 30,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                          widget.model!.userImage!,
                      ),
                    ),
                ),
                SizedBox(height: 15,),
                Text(
                  widget!.model!.name!,
                  style: TextStyle(
                    color: Colors.orange[400],
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  widget!.model!.email!,
                  style: TextStyle(
                    color: Colors.orange[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }
}
