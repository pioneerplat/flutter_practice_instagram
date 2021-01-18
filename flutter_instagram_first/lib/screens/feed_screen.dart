import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/models/firestore/user_model.dart';
import 'package:flutter_instagram_first/models/user_model_state.dart';
import 'package:flutter_instagram_first/repo/user_network_repository.dart';
import 'package:flutter_instagram_first/widgets/post.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        title: Text('instagram',
          style: TextStyle(fontFamily: 'VeganStyle', color: Colors.black87),
        ),
      ),
      */
      appBar: CupertinoNavigationBar(
        // 왼쪽
        leading: IconButton(
            //쿠퍼티노 디자인 사용법
            icon: Icon(
              CupertinoIcons.photo_camera_solid,
              color: Colors.black87,
            ),
            // Material 디자인
            //icon: Icon(Icons.camera_alt),
            onPressed: null),

        // 가운데
        middle: Text(
          'instagram',
          style: TextStyle(fontFamily: 'VeganStyle', color: Colors.black87),
        ),

        // 오른쪽
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: ImageIcon(
                AssetImage('assets/images/actionbar_camera.png'),
                color: Colors.black87,
              ),
              onPressed: () {
              },
            ),
            IconButton(
              icon: ImageIcon(
                AssetImage('assets/images/direct_message.png'),
                color: Colors.black87,
              ),
              onPressed: ()  {
                userNetworkRepository.getAllUsersWithoutMe().listen((users) {
                  print(users);
                });
                //Provider.of<UserModelState>(context, listen: false).clear();
              },
            )
          ],
        ),
      ),
      body: ListView.builder(
        itemBuilder: feedListBuilder,
        itemCount: 30,
      ),
    );
  }

  Widget feedListBuilder(BuildContext context, int index) {
    return Post(index);
  }
}
