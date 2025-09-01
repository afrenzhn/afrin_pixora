import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User{

  String ? email;
  String?name;
  String? userImage;
  DateTime? createAt;
  String?id;




  User({
    this.email,
    this.name,
    this.userImage,
    this.createAt,
    this.id,
});
  User.fromJson(Map<String,dynamic>json){
    email=json["email"];
    name=json["name"];
    userImage=json["userImage"];
    id=json["id"];

  }

  Map<String,dynamic>toJson(){
    final Map<String,dynamic>data=Map<String,dynamic>();
    data["email"]=email;
    data["name"]=name;
    data["userImage"]=userImage;
    data["createAt"]=createAt;createAt != null ? Timestamp.fromDate(createAt!) : null;
    data["id"]=id;
    return data;


  }

}