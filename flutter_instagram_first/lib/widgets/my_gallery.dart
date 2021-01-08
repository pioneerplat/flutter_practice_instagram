import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/models/gallery_state.dart';
import 'package:flutter_instagram_first/screens/share_post_screen.dart';
import 'package:local_image_provider/device_image.dart';
import 'package:local_image_provider/local_image.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
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
          children: getImages(context, galleryState),
        );
      },
    );
  }

  //이미지를 보여주는 부분
  List<Widget> getImages(BuildContext context, GalleryState galleryState) {
    //.toList로 리스트로 바꿔줘야 List<Widget> 타입이 된다
    //scale을 주지 않으면 원본이미지를 불러오기때문에 memory issue가 발생한다 scale 1이 기본값 0.1로 줄여주면 된다
    return galleryState.images
        .map((localImage) =>
            //각각의 이미지를 클릭할 수 있는 버튼으로 바꿔주기 위해 InkWell 위젯으로 감싸준다
            InkWell(
              //local이미지를 바로 파일로 받아올 수 없기 때문에 Bite로 바꿔준다음 Bite를 파일로 변환
              onTap: () async {
                Uint8List bytes = await localImage.getScaledImageBytes(
                    galleryState.localImageProvider, 0.3);
                final String timeInMilli =
                    DateTime.now().microsecondsSinceEpoch.toString();
                try {
                  //getTemporaryDirectory()).path 저장되는 폴더 위치 , $timeInMilli.png 파일명
                  final path = join((await getTemporaryDirectory()).path, '$timeInMilli.png');

                  //File(path)파일을 생성해서 .. 찍으면 뒤에 메소드를 실행하고 그 파일을 imageFile 로 리턴
                  File imageFile = File(path)..writeAsBytesSync(bytes);

                  //화면에 사진찍은걸 보여줌
                  //(_) 원래 context를 받아와야하지만 지금은 사용하지 않기때문에 _로 대체함
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => SharePostScreen(imageFile)));
                } catch (e) {}
              },
              child: Image(
                image: DeviceImage(localImage, scale: 0.1),
              ),
            ))
        .toList();
  }

  Future<Uint8List> localImageToBytes(
      GalleryState galleryState, LocalImage localImage) {
    return localImage.getScaledImageBytes(galleryState.localImageProvider, 0.3);
  }
}
