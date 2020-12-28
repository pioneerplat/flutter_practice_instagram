import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/feed_screen.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BottomNavigationBarItem> btmNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: " "),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: " "),
    BottomNavigationBarItem(icon: Icon(Icons.add), label: " "),
    BottomNavigationBarItem(icon: Icon(Icons.healing), label: " "),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: " ")
  ];

  int _selectedIntex = 0;

  static List<Widget> _screens = <Widget>[
    FeedScreen(),
    Container(color: Colors.green,),
    Container(color: Colors.red,),
    Container(color: Colors.blue,),
    Container(color: Colors.pink,),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _selectedIntex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // 아이탬이 선택 되었을때 움직이지 않게 고정
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: btmNavItems,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.black,
          currentIndex: _selectedIntex,
          onTap: _onBtmItemClick,
        ),
    );
  }

  void _onBtmItemClick(int index) {
    print(index);
    setState(() {
      _selectedIntex = index;
    });

  }
}


