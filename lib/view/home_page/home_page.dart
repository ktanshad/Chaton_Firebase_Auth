import 'package:authentication/controller/auth_provider.dart';
import 'package:authentication/controller/internetconnectivity_provider.dart';
import 'package:authentication/controller/posts_provider.dart';
import 'package:authentication/view/home_page/widgets/chaton_post_widget.dart';
import 'package:authentication/widgets/textfield_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  //user
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    Provider.of<InternetConnectivityProvider>(context, listen: false)
                  .getInternetConnectivity(context);
    final postsprovider = Provider.of<PostsProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Home Page'),
        actions: [
          //sign out button
          IconButton(
            onPressed: ()async {
              //get auth service
              final authprovider =
                  Provider.of<AuthProvider>(context, listen: false);
              authprovider.signOut();
               
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            //the chat area
            Consumer<PostsProvider>(
              builder: (context, postsprovider, child) {
                   
                final posts = postsprovider.posts;
                if (posts.isEmpty) {
                  return Center(child: Text('No posts available.'));
                } else {
                  return Expanded(
                      child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];

                      return ChatonPost(
                        message: post['Message'],
                        user: post['UserEmail'],
                        postid: post.id,
                      );
                    },
                  ));
                }
              },
            ),

            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  //textfield
                  Expanded(
                      child: MyTextField(
                          controller: postsprovider.textController,
                          hintText: "write something..",
                          obscureText: false)),
                  //post button
                  IconButton(
                      onPressed: () async {
                        final postsprovider =
                            Provider.of<PostsProvider>(context, listen: false);
                        //only post if there is something in the textfield
                        if (postsprovider.textController.text.isNotEmpty && postsprovider.textController.text!=null) {
                          postsprovider.addPost(currentUser.email!,
                              postsprovider.textController.text);

                          postsprovider.textController.clear();
                        }
                      },
                      icon: const Icon(Icons.arrow_circle_up))
                ],
              ),
            ),

            //logged in as
            Text('Logged in as:' + currentUser.email!),
          ],
        ),
      ),
    );
  }
}
