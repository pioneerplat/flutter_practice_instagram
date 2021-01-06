import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/screens/camera_screen.dart';
import 'package:flutter_instagram_first/screens/feed_screen.dart';
import 'package:flutter_instagram_first/screens/profile_screens.dart';
import 'constants/screen_size.dart';

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
    Container(
      color: Colors.green,
    ),
    Container(
      color: Colors.black,
    ),
    Container(
      color: Colors.blue,
    ),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    if (size == null) {
      //우리가 사용하고있는 디바이스의 사이즈
      size = MediaQuery.of(context).size;
    }
    return Scaffold(
      body: IndexedStack(
        index: _selectedIntex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // 아이탬이 선택 되었을때 움직이지 않게 고정
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
    switch (index) {
      case 2:
        _openCamera();
        break;
      //case로 선택된 index말고 다른값이 들어오면
      default:
        {
          print(index);
          setState(() {
            _selectedIntex = index;
          });
        }
    }
  }

  //새로운 창을 띄우는 방법 중 하나 (외우자)
  //Navigator : 앱에서 여기저기 이동할 수 있도록 도와주는 Class
  //Navigator.of(context) 네비게이터의 상태 인덱스를 가져온다
  //pushReplacement 와 push가 있는데 push는 현재화면을 없애지 않고 그위로 가져온다
  void _openCamera() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CameraScreen()));
  }
}
