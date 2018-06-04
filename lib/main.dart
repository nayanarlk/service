import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

  Future<String> _testSignInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    print("The $user is signed in!");

    return 'signInWithGoogle succeeded: $user';
  }

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    Widget buttonSection = new Container(
      padding: new EdgeInsets.all(20.0),
      child: new Row(
        children: [
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new MaterialButton(
                  child: new Text(
                    "Sign In", 
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 20.0
                      ),
                    ),
                  onPressed: (){_testSignInWithGoogle();},
                  height: 50.0,
                  minWidth: 400.0,
                  color: Colors.blueAccent,
                ),

                SizedBox(height: 10.0),

                new MaterialButton(
                  child: new Text(
                    "Sign Up",
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 20.0
                      ),
                    ),
                  onPressed: null,
                  height: 50.0,
                  minWidth: 400.0,
                  color: Colors.blueAccent,
                )
              ],
            ),
          ),
        ],
      ),
    );

    Widget textFieldSection = new Container(
      padding: new EdgeInsets.symmetric(vertical:12.0),
      child: new Row(
        children: [
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new TextField(
                  autocorrect: false,
                  obscureText: false,
                  controller: _usernameController,
                  maxLines: 1,
                  decoration: new InputDecoration(
                    hintText: "Username",
                    icon: new Icon(Icons.person),
                  ),

                  style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.black
                  ),
                ),

                new SizedBox(height: 10.0),

                new TextField(
                  autocorrect: false,
                  obscureText: true,
                  controller: _passwordController,
                  maxLines: 1,
                  decoration: new InputDecoration(
                    hintText: "Password",
                    icon: new Icon(Icons.vpn_key),
                  ),

                  style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.black
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget titleSection = new Container(
      padding: new EdgeInsets.symmetric(vertical:12.0),
      child: new Row(
        children: [
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: new Text(
                    "Please login using your credentials",
                    style: new TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return new MaterialApp(
      title: "Service",
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      
      home: new Scaffold(
        body: new ListView(
          reverse: true,
          children: [
            SizedBox(height: 30.0),
            new Image.asset(
              'assets/logo.png',
              height: 200.0,
            ),
            titleSection,
            textFieldSection,
            buttonSection
          ].reversed.toList(),
        ),
      ),
    );
  }
}