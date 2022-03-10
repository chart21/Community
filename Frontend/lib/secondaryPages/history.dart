import 'package:flutter/material.dart';

//should show rental and leasing history of the user //***local file read (Blockchain does not keep track of history (!)) */
class HistoryPage extends StatefulWidget {
  HistoryPage({Key key}) : super(key: key);

  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Widget> containers = [
    Container(
      color: Colors.brown,
    ),
    Container(
      color: Colors.blue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('History'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Rentals',
              ),
              Tab(
                text: 'Offers',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: containers,
        ),
      ),
    );
  }
}
