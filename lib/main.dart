import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'todopage.dart';

User user;
String email;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'todo': (context)=>MyTodoPage(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Welcome'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final FirebaseAuth _auth=FirebaseAuth.instance;
  final GoogleSignIn googleSignIn=new GoogleSignIn();

  Future<User> _signIn()async{
    GoogleSignInAccount googleSignInAccount=await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication=await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final UserCredential authResult = await _auth.signInWithCredential(credential);

    user = authResult.user;
    email=user.email;
    print("user: ${user.displayName} logged in");
    return user;
  }
  void _signOut(){
    googleSignIn.signOut();
    user=null;
    print("user signed out");
  }

  void handleSignIn(){
    if(user!=null){
      print("user entered ");

    }
    else{
      _signIn();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image : DecorationImage(
              image: NetworkImage("https://wallpapercave.com/wp/wp4305136.jpg"),
              fit:BoxFit.cover
            )
          ),


          child:Center(
            child:Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 200)),
                  ElevatedButton(

                    onPressed: (){ 
                      handleSignIn();
                      if(user!=null) {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => MyTodoPage()));
                      }
                    },
                    
                    
                    style: TextButton.styleFrom(

                      backgroundColor: Colors.black12,
                      elevation: 1,
                    ),
                    child: Text("Enter"),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  ElevatedButton(
                      onPressed: ()=>_signOut(),
                      style: TextButton.styleFrom(

                        backgroundColor: Colors.black12,
                        elevation: 1,
                      ),
                      child: Text("SignOut"),


                  )
                ]
            )

          ),
        )
      )
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
