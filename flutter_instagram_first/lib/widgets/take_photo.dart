import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/constants/common_size.dart';
import 'package:flutter_instagram_first/constants/screen_size.dart';

class TakePhoto extends StatelessWidget {
  const TakePhoto({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: size.width,
          height: size.width,
          color: Colors.black,
        ),
        Expanded(
          //컨테이너 전체가 버튼
          //InkWell로 감싸고 onTap을 넣어주면 버튼이 된다
          // child: InkWell(
          //   onTap: (){},
          //   child: Padding(
          //     padding: const EdgeInsets.all(common_s_gap),
          //     child: Container(
          //       decoration: ShapeDecoration(
          //           shape: CircleBorder(side: BorderSide(color: Colors.black12,width: 20))),
          //     ),
          //   ),
          // ),

          //shape만 버튼
          child: OutlineButton(
            onPressed: () {},
            shape: CircleBorder(),
            borderSide: BorderSide(color: Colors.black12, width: 20),
          ),
        ),
      ],
    );
  }
}
