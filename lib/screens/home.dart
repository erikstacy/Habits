import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
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
                child: Text('Yo mama'),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
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
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.search),
                        title: Text('Search'),
                      ),
                      ListTile(
                        leading: Icon(Icons.mail),
                        title: Text('Mail'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              color: Colors.white,
              icon: Icon(Icons.close),
              onPressed: () {},
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(
          Icons.add,
        ),
        onPressed: () {},
      ),
    );
  }
}