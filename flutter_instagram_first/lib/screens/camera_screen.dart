import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  @override
  // PageView를 컨트롤하기 위한 컨트롤러
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  int _currentIndex = 1;
  PageController _pageController = PageController(initialPage: 1);
  String _title = "Photo";

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          Container(
            color: Colors.cyanAccent,
          ),
          Container(
            color: Colors.amberAccent,
          ),
          Container(
            color: Colors.greenAccent,
          ),
        ],
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
            switch (_currentIndex) {
              case 0:
                _title = 'Gallery';
                break;
              case 1:
                _title = 'Photo';
                break;
              case 2:
                _title = 'Vedio';
                break;
            }
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        //아이콘을 안보이게 하기 위해
        iconSize: 0,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: 'GALLERY'),
          BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: 'PHOTO'),
          BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: 'VIDEO')
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTabbed,
      ),
    );
  }

  void _onItemTabbed(index) {
    print(index);
    setState(() {
      // onPageChanged에 넣어줬기 때문에 굳이 넣어주지 않아도 된다
      //_currentIndex = index;
      _pageController.animateToPage(_currentIndex,
          duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
    });
  }
}
