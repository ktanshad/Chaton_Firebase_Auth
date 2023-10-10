import 'package:authentication/services/posts_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostsProvider extends ChangeNotifier{
  PostsServices postsservices=PostsServices();
  //text controller
  final textController = TextEditingController();
   //user
  final currentUser = FirebaseAuth.instance.currentUser!;

  List<DocumentSnapshot>posts=[];

  PostsProvider(){
    fetchPosts();
  }

  //Fetch posts from Firebase Firestore
Future<void>fetchPosts()async{
  try{
    final querySnapshot=await postsservices.fetchPosts();
    posts=querySnapshot.docs;
    notifyListeners();
  }catch(e){
    throw Exception(e.toString());
  }
}


//add posts from firebasestore
Future<void>addPost(String user,String message)async{
  postsservices.addPost(user, message);
   //update the post list after adding a new post
    await fetchPosts();
  
   
}


}