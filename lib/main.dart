// IvyHacks 2020
// Oct 1-4, 2020

// Problem:   Communicating with colleagues in different timezones most times
//            require that you remember the actual time for their location.
// Solution:  An app that shows the actual time and the timezone for a contact's
//            location. This eliminates the need to remember colleagues timezones
//            and the need convert to the actual time for that person.

// Packages needed for the app
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
//import 'dart:io';

// class User {
//   final String uid;

//   User({this.uid});
// }

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user object based on FirebaseUser
  // Register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e.toString());
    }
  }

  // Sign in with email and password

  // Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

void main() => runApp(App());

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        // if (snapshot.hasError) {
        //   return SomethingWentWrong();
        // }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return TimeSite();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        // return Loading();
      },
    );
  }
}

// class SomethingWentWrong extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(child: Text('Something Went Wrong')),
//     );
//   }
// }

// class Loading extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(child: Text('Loading')),
//     );
//   }
// }

class TimeSite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

// Home page displaying the login and the sign up buttons
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.asset('images/logo.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FlatButton(
                      child: Text('Login'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FlatButton(
                      color: Colors.deepPurpleAccent[400],
                      child: Text('Sign Up'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistrationPage()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ))));
  }
}

// Login page
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(child: Column()),
      ),
    );
  }
}

// The registration or sign-up page
class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final AuthService _auth = AuthService();
  //final _formKey = GlobalKey<FormState>();

  String firstName = '';
  String lastName = '';
  String email = '';
  String password1 = '';
  String password2 = '';

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'First Name',
                      ),
                      onChanged: (value) {
                        setState(() => firstName = value);
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Last Name',
                      ),
                      onChanged: (value) {
                        setState(() => lastName = value);
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      onChanged: (value) {
                        setState(() => email = value);
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                      onChanged: (value) {
                        setState(() => password1 = value);
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Confirm Password',
                      ),
                      onChanged: (value) {
                        setState(() => password2 = value);
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FlatButton(
                    color: Colors.deepPurpleAccent[400],
                    child: Text('Sign Up'),
                    onPressed: () async {
                      if (password1 == password2) {
                        _auth.registerWithEmailAndPassword(email, password1);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileSettingsPage()),
                        );
                      } else {
                        print('Passwords does not match');
                      }
                    },
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

// This page will let the user input information such as timezone
class ProfileSettingsPage extends StatefulWidget {
  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Profile Settings"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(),
        ),
      ),
    );
  }
}

// This page will list all the chats that the user has started and have
// not dismissed
class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(),
    );
  }
}

class IndividualChatPage extends StatefulWidget {
  @override
  _IndividualChatPageState createState() => _IndividualChatPageState();
}

class _IndividualChatPageState extends State<IndividualChatPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
