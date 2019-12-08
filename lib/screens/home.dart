import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habits_app/services/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1b1e44),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1b1e44),
              Color(0xFF2d3447),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            tileMode: TileMode.clamp,
          ),
        ),
        child: SafeArea(
          child: CategoryList(),
        ),
      ),
      bottomNavigationBar: new OurBottomBar(auth: auth),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
        },
      ),
    );
  }
}

class OurBottomBar extends StatefulWidget {
  const OurBottomBar({
    Key key,
    @required this.auth,
  }) : super(key: key);

  final AuthService auth;

  @override
  _OurBottomBarState createState() => _OurBottomBarState();
}

class _OurBottomBarState extends State<OurBottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color(0xFF2d3447),
      shape: CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.menu),
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (context) => Drawer(
                child: Container(
                  color: Color(0xFF2d3447),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          await widget.auth.signOut();
                          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                        },
                        child: ListTile(
                          leading: Icon(
                            Icons.exit_to_app,
                            color: Colors.white,
                          ),
                          title: Text(
                            'Sign Out',
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.close),
            onPressed: () {
              resetHabits();
            },
          ),
        ],
      ),
    );
  }

  void resetHabits() {
    UserProfile userProfile = Provider.of<UserProfile>(context);

    Firestore.instance
      .collection('users')
      .document(userProfile.uid)
      .collection('categories')
      .snapshots()
      .listen((data) => data.documents.forEach((doc) => 
        Firestore.instance
          .collection('users')
          .document(userProfile.uid)
          .collection('categories')
          .document(doc.documentID)
          .collection('habits')
          .snapshots()
          .listen((data) => data.documents.forEach((otherDoc) =>
            Firestore.instance
              .collection('users')
              .document(userProfile.uid)
              .collection('categories')
              .document(doc.documentID)
              .collection('habits')
              .document(otherDoc.documentID)
              .setData(
                {
                  'isDone': false,
                },
                merge: true,
              )
          ))
      ));
  }
}

class CategoryList extends StatefulWidget {

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    UserProfile userProfile = Provider.of<UserProfile>(context);

    return new StreamBuilder(
      stream: Firestore.instance.collection('users').document(userProfile.uid).collection('categories').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text("Loading...");
        return new ListView(
          scrollDirection: Axis.horizontal,
          children: snapshot.data.documents.map((document) {
            return Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.symmetric(vertical: 80, horizontal: 10),
              width: 350,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple[900],
                    Colors.deepPurple[500],
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  tileMode: TileMode.clamp
                ),
                borderRadius: BorderRadius.circular(16.0),
                //color: Color(0xFF00b894),
                boxShadow: [new BoxShadow(
                  color: Colors.black12,
                  offset: Offset(5.0, 5.0),
                  blurRadius: 1.0,
                  spreadRadius: 0.0,
                )],
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        document['title'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () {
                        },
                      ),
                    ],
                  ),
                  HabitList(
                    currentDoc: document.documentID,
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class HabitList extends StatefulWidget {
  final String currentDoc;

  HabitList({this.currentDoc});

  @override
  _HabitListState createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  @override
  Widget build(BuildContext context) {
    UserProfile userProfile = Provider.of<UserProfile>(context);

    return Expanded(
      child: new StreamBuilder(
        stream: Firestore.instance.collection('users').document(userProfile.uid).collection('categories').document(widget.currentDoc).collection('habits').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Text("Loading...");
          return new ListView(
            children: snapshot.data.documents.map((document) {
              bool isDone = document['isDone'];
              return Row(
                children: <Widget>[
                  Checkbox(
                    activeColor: Colors.deepPurple,
                    value: isDone,
                    onChanged: (change) {
                      Firestore.instance.collection('users').document(userProfile.uid).collection('categories').document(widget.currentDoc).collection('habits').document(document.documentID).setData(
                        {
                        'isDone': change,
                        },
                        merge: true,
                      );
                    },
                  ),
                  Text(
                    document['title'],
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        }
      ),
    );
  }
}