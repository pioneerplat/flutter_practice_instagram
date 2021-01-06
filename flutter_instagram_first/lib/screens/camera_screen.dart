import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  @override
  // PageView를 컨트롤하기 위한 컨트롤러
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  int _currentIndex = 0;
  PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        onPageChanged: (index){
          setState(() {
            _currentIndex = index;
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
      _currentIndex = index;
      _pageController.animateToPage(_currentIndex,
          duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
    });
  }
}
