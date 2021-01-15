import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/constants/common_size.dart';
import 'package:flutter_instagram_first/constants/screen_size.dart';
import 'package:flutter_tags/flutter_tags.dart';

class SharePostScreen extends StatelessWidget {
  final File imageFile;
  final String postKey;

  SharePostScreen(this.imageFile, {Key key, @required this.postKey})
      : super(key: key);

  List<String> _tagItems = [
    "approval",
    "pigeon",
    "brown",
    "expenditure",
    "compromise",
    "citizen",
    "inspire",
    "relieve",
    "grave",
    "incredible",
    "invasion",
    "voucher",
    "girl",
    "relax",
    "problem",
    "queue",
    "aviation",
    "profile",
    "palace",
    "drive",
    "money",
    "revolutionary",
    "string",
    "detective",
    "follow",
    "text",
    "bet",
    "decade",
    "means",
    "gossip"
  ];

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
        children: <Widget>[
          _captionWithImage(),
          //padding을 없애려면 thickness와 heignt를 똑같이 주면 된다
          _divider,
          _sectionButton('Tag People'),
          _divider,
          _sectionButton('Add Location'),
          Tags(
            horizontalScroll: true,
            itemCount: _tagItems.length,
            //수평스크롤 높이
            heightHorizontalScroll: 30,
            itemBuilder: (index) => ItemTags(
              index: index,
              title: _tagItems[index],
              activeColor: Colors.grey[200],
              textActiveColor: Colors.black87,
              borderRadius: BorderRadius.circular(4),
              //splashColor: Colors.grey[800],
              color: Colors.green,
              //그림자
              elevation: 2,
            ),
          )
        ],
      ),
    );
  }

/*
  Divider _divider() {
    return Divider(
          color: Colors.grey[300],
          thickness: 1,
          height: 1,
        );
  }
 */
  // 이렇게 하면 호출할 때 _divider() 이 아닌 _divider로 이름만으로 호출할 수 있게 된다
  Divider get _divider => Divider(
        color: Colors.grey[300],
        thickness: 1,
        height: 1,
      );

  ListTile _sectionButton(String title) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
      trailing: Icon(Icons.navigate_next),
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: common_gap),
    );
  }

  ListTile _captionWithImage() {
    return ListTile(
      contentPadding:
          EdgeInsets.symmetric(vertical: common_gap, horizontal: common_gap),
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
    );
  }
}
