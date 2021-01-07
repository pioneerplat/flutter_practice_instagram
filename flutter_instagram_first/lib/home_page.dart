import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/constants/screen_size.dart';
import 'package:flutter_instagram_first/screens/camera_screen.dart';
import 'package:flutter_instagram_first/screens/feed_screen.dart';
import 'package:flutter_instagram_first/screens/profile_screens.dart';
import 'package:permission_handler/permission_handler.dart';

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
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

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
      key: _key,
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
  //async, await로 Future<bool>값이 도착할 때 까지 기다렸다가 true가 도착하면 열어준다.
  void _openCamera() async {
    if (await checkIfPermissionGranted(context))
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CameraScreen()));
    else {
      SnackBar snackBar = SnackBar(
        content: Text('사진, 파일, 마이크 접근 허용 해주셔야 카메라 사용 가능합니다.'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            _key.currentState.hideCurrentSnackBar();
          },
        ),
      );
      _key.currentState.showSnackBar(snackBar);
    }
  }

  Future<bool> checkIfPermissionGranted(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.camera, Permission.microphone].request();
    bool permitted = true;

    statuses.forEach((permission, permissionStatus) {
      //1개라도 허락이 되지 않았으면 false로 넘긴다
      if (!permissionStatus.isGranted) permitted = false;
    });
    return permitted;
  }
}
