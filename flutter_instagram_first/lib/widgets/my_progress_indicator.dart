import 'package:flutter/material.dart';

class MyProgressIndicator extends StatelessWidget {
  final double containerSize;
  final double progressSize;

  const MyProgressIndicator(
      {Key key, this.containerSize, this.progressSize = 60})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: containerSize,
        height: containerSize,
        child: Center(
            child: SizedBox(
                height: progressSize,
                width: progressSize,
                /* 원이 빙글빙글 돌아가는 로딩 화면 
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black38,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                )
                 */

                //내가 원하는 로딩화면
                child: Image.asset('assets/images/loading_img.gif')
            )));
  }
}
