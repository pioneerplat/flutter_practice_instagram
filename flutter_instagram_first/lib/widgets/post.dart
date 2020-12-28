import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  final int index;

  const Post(this.index,{
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //accents color를 인덱스의 수만큼 받아와서 하나씩 번갈아 가면서 사용한다는 뜻
      color: Colors.accents[index % Colors.accents.length],
      height: 100,
    );
  }
}