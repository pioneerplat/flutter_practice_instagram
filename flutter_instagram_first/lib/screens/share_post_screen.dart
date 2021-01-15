import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/constants/common_size.dart';
import 'package:flutter_instagram_first/constants/screen_size.dart';

class SharePostScreen extends StatelessWidget {
  final File imageFile;
  final String postKey;

  const SharePostScreen(this.imageFile, {Key key, @required this.postKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {},
            child: Text(
              "Share",
              textScaleFactor: 1.4,
              style: TextStyle(color: Colors.blue),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: common_gap, horizontal: common_gap),
            leading: Image.file(
              imageFile,
              width: size.width / 6,
              height: size.width / 6,
              //사이즈가 오버되는 부분은 잘라준다
              fit: BoxFit.cover,
            ),
            title: TextField(
              decoration: InputDecoration(
                  hintText: 'Write a caption...', border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }
}
