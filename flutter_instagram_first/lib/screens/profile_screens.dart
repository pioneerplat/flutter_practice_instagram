import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/constants/screen_size.dart';
import 'package:flutter_instagram_first/widgets/profile_body.dart';
import 'package:flutter_instagram_first/widgets/profile_side_menu.dart';

//변수가 class바깥에 정의되어 있으면 자동으로 static변수가 되어서 바깥에서 접근이 가능하다
//static은 앱이 실행되면서 값이 생성 되는것이 아니라 앱이 실행됨과 동시에 값이 존재한다
const duration = Duration(milliseconds: 1000);

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final menuWidth = size.width / 3 * 2;
  MenuStatus _menuStatus = MenuStatus.closed;
  double bodyXPos = 0;
  double menuXPos = size.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        //Stack 에서 코드가 밑에 있을수록 우리가 보이는 으로 바깥으로 나온다.
        body: Stack(
          children: <Widget>[
            AnimatedContainer(
              duration: duration,
              transform: Matrix4.translationValues(bodyXPos, 0, 0),
              curve: Curves.fastOutSlowIn,
              child: ProfileBody(onMenuChanged: () {
                //닫혀 있으면 열어주고 닫혀있지 않으면 닫아줘
                /*
                if (_menuStatus == MenuStatus.closed)
                  _menuStatus = MenuStatus.opened;
                else
                  _menuStatus = MenuStatus.closed;
                 */
                setState(() {
                  _menuStatus = (_menuStatus == MenuStatus.closed)
                      ? MenuStatus.opened
                      : MenuStatus.closed;

                  switch (_menuStatus) {
                    case MenuStatus.opened:
                      bodyXPos = -menuWidth;
                      menuXPos = size.width - menuWidth;
                      break;
                    case MenuStatus.closed:
                      bodyXPos = 0;
                      menuXPos = size.width;
                      break;
                  }
                });
              }),
            ),
            //Positined의 top은 Stack의 위에서 얼마나 떨어져있나, Bottom은 아래에서 얼마나 떨어져있나
            AnimatedContainer(
                duration: duration,
                curve: Curves.fastOutSlowIn,
                transform: Matrix4.translationValues(menuXPos, 0, 0),
                child: Positioned(
                  top: 0,
                  bottom: 0,
                  width: menuWidth,
                  child: ProfileSideMenu(menuWidth),
                )),
          ],
        ));
  }
}

enum MenuStatus { opened, closed }
