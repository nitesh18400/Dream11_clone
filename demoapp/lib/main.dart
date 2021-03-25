import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:countdown_flutter/countdown_flutter.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int curr_index = 0;
  final tbs = [
    Center(
      child: Home(),
    ),
    Center(
      child: Text('Search'),
    ),
    Center(
      child: Text('Friends'),
    ),
    Center(
      child: Text('More'),
    ),
  ];
  void _onItemTapped(int index) {
    setState(() {
      curr_index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: tbs[curr_index],
        bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
                backgroundColor: Colors.red,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                title: Text('Search'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text('Friends'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz_sharp),
                title: Text('More'),
              ),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: curr_index,
            selectedItemColor: Colors.red,
            iconSize: 20,
            onTap: _onItemTapped,
            elevation: 5),
      ),
    );
  }
}

class DropDown extends StatefulWidget {
  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String dropdownValue = 'Cricket';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 40,
        elevation: 16,
        iconEnabledColor: Colors.red,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
          });
        },
        items: <String>['Cricket', 'Cric', 'Cir', 'Cri']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 38, 0, 0),
                  child: DropDown(),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(120, 38, 2, 0),
                  child: IconButton(
                    icon: Icon(
                      Icons.notifications_none_sharp,
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                )
              ],
            ),
            Column(children: [
              Padding(
                padding: EdgeInsets.fromLTRB(5, 38, 13, 0),
                child: IconButton(
                  iconSize: 5,
                  icon: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      'https://static.independent.co.uk/s3fs-public/thumbnails/image/2019/01/07/11/bunny-rabbit.jpg?width=982&height=726&auto=webp&quality=75',
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ]),
          ],
        ),
        Row(
          children: [
            Row(
              children: [
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 150,
                  child: ContainedTabBarView(
                    tabs: [
                      Text(
                        'Upcoming',
                        // style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'Live',
                        // style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'Results',
                      ),
                    ],
                    tabBarProperties: TabBarProperties(
                        indicatorColor: Colors.red,
                        unselectedLabelColor: Colors.grey,
                        labelColor: Colors.red),
                    views: [
                      MyCard(),
                      Container(color: Colors.green),
                      Container(color: Colors.blue),
                    ],
                    onChange: (index) => print(index),
                  ),
                )
              ],
            )
          ],
        ),
        Row(
          children: [],
        ),
      ],
    );
  }
}

class MyCard extends StatefulWidget {
  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  List<String> t = [
    'First',
    'Second',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _func(),
      builder: (context, snapshot) {
        var matchdata = snapshot;
        if ((matchdata.connectionState == ConnectionState.none &&
            matchdata.hasData == null)) {
          return Center(
            child: Text(
              "Loading....",
              style: TextStyle(
                fontSize: 25.0,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        } else {
          if (matchdata.data == null || matchdata.data['matches'] == []) {
            return Center(
              child: Text(
                "Loading....",
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          } else {
            return Container(
              color: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView.builder(
                    itemCount: matchdata.data['matches'].length,
                    itemBuilder: (context, index) {
                      var x = matchdata.data['matches'][index]['startdate'];
                      String t1 = matchdata.data['matches'][index]['team1'];
                      String t2 = matchdata.data['matches'][index]['team2'];
                      String t1fl = 'images/' + t1 + '.png';
                      String t2fl = 'images/' + t2 + '.png';
                      var local = DateTime.fromMillisecondsSinceEpoch(x);
                      print(x.runtimeType);
                      return Card(
                        child: Container(
                          height: 130,
                          child: ListTile(
                            onTap: () {},
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    "IPL Match " +
                                        matchdata.data['matches'][index]
                                            ['match'],
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 15, 0),
                                  child: Center(
                                      child: Image(
                                          height: 80,
                                          width: 40,
                                          image: AssetImage('images/vs.png'))),
                                ),
                                Center(
                                  child: CountdownFormatted(
                                    duration: Duration(milliseconds: x),
                                    builder:
                                        (BuildContext ctx, String remaining) {
                                      return new Container(
                                        color: Colors.transparent,
                                        child: new Container(
                                            decoration: new BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    new BorderRadius.only(
                                                  topLeft:
                                                      const Radius.circular(
                                                          10.0),
                                                  topRight:
                                                      const Radius.circular(
                                                          10.0),
                                                )),
                                            child: new Center(
                                              child: new Text(
                                                remaining,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            leading: Column(
                              children: [
                                Image(
                                  image: AssetImage(t1fl),
                                  height: 40,
                                  width: 40,
                                ),
                                Text(matchdata.data['matches'][index]['team1']),
                              ],
                            ),
                            trailing: Column(
                              children: [
                                Image(
                                  image: AssetImage(t2fl),
                                  height: 40,
                                  width: 40,
                                ),
                                Text(matchdata.data['matches'][index]['team2'])
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            );
          }
        }
      },
    );
  }

  _func() async {
    final response = await http.get('https://clash11.herokuapp.com/getmatches');
    if (response.statusCode == 200) {
      var obj = json.decode(response.body);
      return obj;
    }
  }
}
