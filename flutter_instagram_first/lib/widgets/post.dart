import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/constants/common_size.dart';
import 'package:flutter_instagram_first/widgets/my_progress_indicator.dart';
import 'package:flutter_instagram_first/widgets/rounded_avatar.dart';

class Post extends StatelessWidget {
  final int index;
  Size size;

  Post(
    this.index, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    return Container(
//      //accents color를 인덱스의 수만큼 받아와서 하나씩 번갈아 가면서 사용한다는 뜻
//      color: Colors.accents[index % Colors.accents.length],
//      height: 100,
//    );

    if (size == null) {
      //우리가 사용하고있는 디바이스의 사이즈
      size = MediaQuery.of(context).size;
    }

    //CashedNetworkImage는 이미지를 디바이스에 저장해놓은 후 다시 돌아왔을때 다운받은 이미지를 사용한다.
    //pub.dev에서 Installing-> dependencies에서 복사 -> pupspec.yaml에 붙여넣은다음 import해서 사
    return Column(
      children: <Widget>[
        _postHeader(),
        _postImage(),
      ],
    );
  }

  Widget _postHeader() {
    return Row(
      children: <Widget>[
        //Padding으로 감싸주면 Padding을 줄 수 있다. (이미지 양 옆을 8.0만큼 공간을 준)
        //ClipOval로 감싸주면 child안에 이미지를 동그랗게 만들어준다.
        Padding(
          //common_xxs_gap은 common_size.dart파일에서 관리
          padding: const EdgeInsets.all(common_xxs_gap),
          child: RoundedAvatar(),
        ),
        //Expanded 위젯으로 감싸주면 이미지와 IconButton의 공간을 제외한 나머지 공간을 Text로 채울수 있다.
        Expanded(child: Text('username')),

        IconButton(
            icon: Icon(
              //... 모양의 아이콘
              Icons.more_horiz,
              color: Colors.black87,
            ),
            onPressed: null)
      ],
    );
  }

  CachedNetworkImage _postImage() {
    return CachedNetworkImage(
        //가로200 세로300
        imageUrl: 'https://picsum.photos/id/$index/2000/2000',

        //Url에서 이미지를 불러 오는 동안 loading시간에 할일 설정
        placeholder: (BuildContext context, String url) {
          return MyProgressIndicator(
            containerSize: size.width,
          );
        },

        //위 Url에서 다운받은 이미지를 imageProvider를 통해서 가져온다.
        imageBuilder: (
          BuildContext context,
          ImageProvider imageProvider,
        ) {
          return AspectRatio(
            // 이미지 가로 세로의 비를 1로
            aspectRatio: 1,

            child: Container(
              decoration: BoxDecoration(
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover)),
            ),
          );
        });
  }
}


