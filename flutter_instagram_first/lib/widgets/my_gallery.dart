import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/models/gallery_state.dart';
import 'package:local_image_provider/device_image.dart';
import 'package:provider/provider.dart';

class MyGallery extends StatefulWidget {
  @override
  _MyGalleryState createState() => _MyGalleryState();
}

class _MyGalleryState extends State<MyGallery> {
  @override
  Widget build(BuildContext context) {
    //crossAxisCount 가로에 몇개의 item을 배치할 것인가
    return Consumer<GalleryState>(
      builder: (BuildContext context, GalleryState galleryState, Widget child) {
        return GridView.count(
          crossAxisCount: 3,
          children: getImages(galleryState),
        );
      },
    );
  }

  //이미지를 보여주는 부분
  List<Widget> getImages(GalleryState galleryState) {
    //.toList로 리스트로 바꿔줘야 List<Widget> 타입이 된다
    //scale을 주지 않으면 원본이미지를 불러오기때문에 memory issue가 발생한다 scale 1이 기본값 0.1로 줄여주면 된다
    return galleryState.images.map((localImage) => Image(image: DeviceImage(localImage, scale: 0.1),)).toList();
  }
}
