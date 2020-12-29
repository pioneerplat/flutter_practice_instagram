import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/constants/common_size.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RoundedAvatar extends StatelessWidget {
  const RoundedAvatar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        //랜덤이미지, 가로세로가 100인 이미지를 가져온
        imageUrl: 'https://picsum.photos/100',
        width: avatar_size,
        height: avatar_size,
      ),
    );
  }
}