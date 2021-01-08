import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/models/camera_state.dart';
import 'package:flutter_instagram_first/widgets/my_gallery.dart';
import 'package:flutter_instagram_first/widgets/take_photo.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class CameraScreen extends StatefulWidget {
  CameraState _cameraState = CameraState();

  @override
  // PageView를 컨트롤하기 위한 컨트롤러
  _CameraScreenState createState() {
    _cameraState.getReadyToTakePhoto();
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State<CameraScreen> {
  int _currentIndex = 1;
  PageController _pageController = PageController(initialPage: 1);
  String _title = "Photo";

  @override
  void dispose() {
    _pageController.dispose();
    widget._cameraState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //바로생성해서 던져주는 방법 과 value를 통해서 주는 방법 2가지가 있다
        //여기서는 _cameraState.getReadyToTakePhoto();를 먼저 하기 위해서 밑에 방법을 사용한다
        //ChangeNotifierProvider(create: (context) => CameraState())
        ChangeNotifierProvider<CameraState>.value(value: widget._cameraState),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: PageView(
          controller: _pageController,
          children: <Widget>[
            MyGallery(),
            TakePhoto(),
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
            BottomNavigationBarItem(
                icon: Icon(Icons.ac_unit), label: 'GALLERY'),
            BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: 'PHOTO'),
            BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: 'VIDEO')
          ],
          currentIndex: _currentIndex,
          onTap: _onItemTabbed,
        ),
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
