import 'package:flutter/material.dart';

class ProfileSideMenu extends StatelessWidget {
  final double menuWith;

  //{}안에다가 넣어주면 옵션값이 되어서 넣어줘도 되고 안넣어줘도 되는 값이 되기때문에 this.menuWith를 밖으로 뺀다
  const ProfileSideMenu(
    this.menuWith, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: menuWith,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text(
                'Setting',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            //리스트에 아이콘이 들어간것을 사용하기 쉽도록 만들어 놓은 flutter 위젯
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.black87,
              ),
              title: Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
