import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'main.dart';

void main(){
  runApp(MyTodo());
}

class MyTodo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyTodoPage(),
    );
  }
}

class MyTodoPage extends StatefulWidget {

  @override
  _MyTodoPageState createState() => _MyTodoPageState();
}

class _MyTodoPageState extends State<MyTodoPage> {

  String toDoItem='';

  createTodo(){
    DocumentReference documentReference=FirebaseFirestore.instance.collection(email).doc(toDoItem);
    Map<String, String> todos={"toDoItem":toDoItem};
     documentReference.set(todos).whenComplete((){
       print("$toDoItem added");
     });
  }

  deleteTodo(toDoItem){
    DocumentReference documentReference=FirebaseFirestore.instance.collection(email).doc(toDoItem);
    documentReference.delete().whenComplete((){
      print("$toDoItem deleted");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${user.displayName}'s ToDos"),
      ),
      body:Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image : DecorationImage(
                image: NetworkImage("https://wallpapercave.com/wp/wp4549463.jpg"),
                fit:BoxFit.cover
            )
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection(email).snapshots(),
          builder: (context, snapshots){
            return ListView.builder(
                //shrinkWrap: true,
                itemCount: snapshots.data.docs.length,
                itemBuilder: (context, index){
                  DocumentSnapshot documentSnapshot=snapshots.data.docs[index];
                  return Dismissible(
                      key: Key(documentSnapshot["toDoItem"]),
                      child: Card(
                        child: ListTile(
                          tileColor: Colors.black26,
                          title: Text(documentSnapshot["toDoItem"]??'Hello!!!'),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                            ),
                            onPressed: (){
                                deleteTodo(documentSnapshot["toDoItem"]??'Hello!!!');
                            },
                          ),
                        ),
                      )
                  );
                });
          },
        ),
      ) ,

      floatingActionButton: FloatingActionButton(
        child:Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title: Text("New Item"),
                content: TextField(
                  onChanged: (String newItemAdd){
                    toDoItem=newItemAdd;
                  },
                ),
                actions: <Widget> [
                  TextButton(
                      onPressed: (){
                        createTodo();
                        Navigator.of(context).pop();
                      },
                      child: Text("Add"))
                ],
              );
            },
          );
        },
      ),
    );
  }
}
