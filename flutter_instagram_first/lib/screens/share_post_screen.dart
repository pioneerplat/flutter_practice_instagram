import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/constants/common_size.dart';
import 'package:flutter_instagram_first/constants/screen_size.dart';
import 'package:flutter_instagram_first/models/firestore/post_model.dart';
import 'package:flutter_instagram_first/models/firestore/user_model.dart';
import 'package:flutter_instagram_first/models/user_model_state.dart';
import 'package:flutter_instagram_first/repo/image_network_repository.dart';
import 'package:flutter_instagram_first/repo/post_network_repository.dart';
import 'package:flutter_instagram_first/widgets/my_progress_indicator.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:provider/provider.dart';

class SharePostScreen extends StatefulWidget {
  final File imageFile;
  final String postKey;

  SharePostScreen(this.imageFile, {Key key, @required this.postKey})
      : super(key: key);

  @override
  _SharePostScreenState createState() => _SharePostScreenState();
}

class _SharePostScreenState extends State<SharePostScreen> {

  TextEditingController _textEditingController = TextEditingController();

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
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              // 밑에 작은 박스가 나옴 //builder에는 context가 오지만 지금은 사용하지 않으니 _ 로 대체
              showModalBottomSheet(
                  context: context,
                  builder: (_) => MyProgressIndicator(),
                  // true로 하면 빈공간을 클릭해서 없앨 수 있음
                  isDismissible: false,
                  // ture로 하면 드래그해서 없앨 수 있음
                  enableDrag: false);
              //이 부분이 끝날 때까지 기다리기 위해 await를 걸어줌 (이부분이 끝나면 로딩을 종료하기 위해)
              await imageNetworkRepository.uploadImage(widget.imageFile,
                  postKey: widget.postKey);
              //이 명령어를 주면 ModalBottomSheet 이 사라진다

              UserModel usermodel =
                  Provider
                      .of<UserModelState>(context, listen: false)
                      .userModel;

              await postNetworkRepository.createNewPost(
                  widget.postKey,
                  PostModel.getMapForCreatePost(
                      userKey: usermodel.userKey,
                      username: usermodel.username,
                      caption: _textEditingController.text));
              //Navigator.of(context).pop(); 은 이전화면으로 되돌아가는 Stack 에서 push 와 pop기능
              //dismiss progress(Model Bottom Sheet) 인디케이터가 사라지게 함
              Navigator.of(context).pop();
              //이 화면에서 나가게한다
              Navigator.of(context).pop();

            },
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
          _tags(),
          SizedBox(
            height: common_s_gap,
          ),
          _divider,
          SectionSwitch('Facebook'),
          SectionSwitch('Instagram'),
          SectionSwitch('Tumblr'),
          _divider
        ],
      ),
    );
  }

  Tags _tags() {
    return Tags(
      horizontalScroll: true,
      itemCount: _tagItems.length,
      //수평스크롤 높이
      heightHorizontalScroll: 30,
      itemBuilder: (index) =>
          ItemTags(
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
    );
  }

  Divider get _divider =>
      Divider(
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
        widget.imageFile,
        width: size.width / 6,
        height: size.width / 6,
        //사이즈가 오버되는 부분은 잘라준다
        fit: BoxFit.cover,
      ),
      title: TextField(
        //share_post_screen에 왔을 때 이 TextField에 자동으로 커서가 오게 한다
        autofocus: true,
        controller: _textEditingController,
        decoration: InputDecoration(
            hintText: 'Write a caption...', border: InputBorder.none),
      ),
    );
  }
}

class SectionSwitch extends StatefulWidget {
  final String _title;

  const SectionSwitch(this._title, {
    Key key,
  }) : super(key: key);

  @override
  _SectionSwitchState createState() => _SectionSwitchState();
}

class _SectionSwitchState extends State<SectionSwitch> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget._title,
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
      trailing: CupertinoSwitch(
        value: checked,
        onChanged: (onValue) {
          setState(() {
            checked = onValue;
          });
        },
      ),
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: common_gap),
    );
  }
}
