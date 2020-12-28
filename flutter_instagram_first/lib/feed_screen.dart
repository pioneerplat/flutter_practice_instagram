import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
            icon: Icon(CupertinoIcons.photo_camera_solid, color: Colors.black87,),
            // Material 디자인
            //icon: Icon(Icons.camera_alt),
            onPressed: null
        ),

        // 가운데
          middle: Text('instagram',
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
                  onPressed: null),
              IconButton(
                  icon: ImageIcon(
                    AssetImage('assets/images/actionbar_camera.png'),
                    color: Colors.black87,
                  ),
                  onPressed: null)
            ],

          ),
      ),

      body: ListView.builder(itemBuilder: feedListBuilder, itemCount: 30,),
    );
  }

  Widget feedListBuilder(BuildContext context, int index) {
    return Container(
      //accents color를 인덱스의 수만큼 받아와서 하나씩 번갈아 가면서 사용한다는 뜻
      color: Colors.accents[index % Colors.accents.length],
      height: 100,
    );
  }
}

