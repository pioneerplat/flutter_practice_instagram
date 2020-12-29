import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  final int index;
  Size size;

  Post(this.index,{
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

//    return Container(
//      //accents color를 인덱스의 수만큼 받아와서 하나씩 번갈아 가면서 사용한다는 뜻
//      color: Colors.accents[index % Colors.accents.length],
//      height: 100,
//    );

    if(size==null) {
      //우리가 사용하고있는 디바이스의 사이즈
      size = MediaQuery.of(context).size;
    }

  //CashedNetworkImage는 이미지를 디바이스에 저장해놓은 후 다시 돌아왔을때 다운받은 이미지를 사용한다.
    //pub.dev에서 Installing-> dependencies에서 복사 -> pupspec.yaml에 붙여넣은다음 import해서 사
    return CachedNetworkImage(
      //가로200 세로300
      imageUrl: 'https://picsum.photos/id/$index/2000/2000',

      //Url에서 이미지를 불러 오는 동안 loading시간에 할일 설정
      placeholder: (BuildContext context, String url){
        return Container(
            width: size.width,
            height: size.width,
            child: Center(child: SizedBox(height: 60, width: 60,
                child: CircularProgressIndicator(backgroundColor: Colors.black38, valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),))));
      },

      //위 Url에서 다운받은 이미지를 imageProvider를 통해서 가져온다.
      imageBuilder: (BuildContext context, ImageProvider imageProvider,){
        return AspectRatio(
          // 이미지 가로 세로의 비를 1로
          aspectRatio: 1,

          child:  Container(
            decoration:  BoxDecoration(
              image: DecorationImage(image:  imageProvider, fit: BoxFit.cover)
            ),
          ),
        );
      }
    );

  }
}