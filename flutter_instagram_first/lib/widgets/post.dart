import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/constants/common_size.dart';
import 'package:flutter_instagram_first/constants/screen_size.dart';
import 'package:flutter_instagram_first/models/firestore/post_model.dart';
import 'package:flutter_instagram_first/models/user_model_state.dart';
import 'package:flutter_instagram_first/repo/image_network_repository.dart';
import 'package:flutter_instagram_first/repo/post_network_repository.dart';
import 'package:flutter_instagram_first/screens/comments_screen.dart';
import 'package:flutter_instagram_first/widgets/comment.dart';
import 'package:flutter_instagram_first/widgets/my_progress_indicator.dart';
import 'package:flutter_instagram_first/widgets/rounded_avatar.dart';
import 'package:provider/provider.dart';

class Post extends StatelessWidget {
  final PostModel postModel;

  Post(this.postModel, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    return Container(
//      //accents color를 인덱스의 수만큼 받아와서 하나씩 번갈아 가면서 사용한다는 뜻
//      color: Colors.accents[index % Colors.accents.length],
//      height: 100,
//    );

    //CashedNetworkImage는 이미지를 디바이스에 저장해놓은 후 다시 돌아왔을때 다운받은 이미지를 사용한다.
    //pub.dev에서 Installing-> dependencies에서 복사 -> pupspec.yaml에 붙여넣은다음 import해서 사
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, //왼쪽 정렬
      children: <Widget>[
        _postHeader(),
        _postImage(),
        _postActions(context),
        _postLikes(),
        _postCaption(),
        _lastComment(),
        _moreComments(context)
      ],
    );
  }

  Widget _postCaption() {
    //하나의 Text안에 여러가지 style이 있을때 RichText를 사용
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: common_gap, vertical: common_xxs_gap),
      child: Comment(
        showImage: false,
        username: postModel.username,
        text: postModel.caption,
      ),
    );
  }

  Widget _lastComment() {
    //하나의 Text안에 여러가지 style이 있을때 RichText를 사용
    return Padding(
      padding: const EdgeInsets.only(
          left: common_gap, right: common_gap, top: common_xxs_gap),
      child: Comment(
        showImage: false,
        username: postModel.lastCommentor,
        text: postModel.lastComment,
      ),
    );
  }

  Padding _postLikes() {
    return Padding(
      padding: const EdgeInsets.only(left: common_gap),
      child: Text(
        '${postModel.numOfLikes == null ? 0 : postModel.numOfLikes
            .length} likes',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Row _postActions(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
            icon: ImageIcon(AssetImage('assets/images/bookmark.png')),
            color: Colors.black87,
            onPressed: null),
        IconButton(
            icon: ImageIcon(AssetImage('assets/images/comment.png')),
            color: Colors.black87,
            onPressed: () {
              _goToComments(context);
            }),
        IconButton(
            icon: ImageIcon(AssetImage('assets/images/direct_message.png')),
            color: Colors.black87,
            onPressed: null),

        //공간을 채우는 위젯
        Spacer(),

        Consumer<UserModelState>(
          builder: (BuildContext context, UserModelState userModelState,
              Widget child) {
            return IconButton(
                icon: ImageIcon(
                  //userKey를 포함하고 있는지 확인하고 있으면 빨간색 하트
                  AssetImage(postModel.numOfLikes.contains(
                    //Provider.of<UserModelState>(context, listen: false) 대신 userModelState쓰면된다
                      userModelState.userModel.userKey)
                      ? 'assets/images/heart_selected.png'
                      : 'assets/images/heart.png'),
                  color: Colors.redAccent,
                ),
                color: Colors.black87,
                onPressed: () {
                  postNetworkRepository.toggleLike(
                      postModel.postKey, userModelState.userModel.userKey);
                });
          },
        )
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
        Expanded(child: Text(postModel.username)),

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

  Widget _postImage() {
    Widget progress = MyProgressIndicator(
      containerSize: size.width,
    );
    return CachedNetworkImage(
      //가로200 세로300
        imageUrl: postModel.postImg,

        //Url에서 이미지를 불러 오는 동안 loading시간에 할일 설정
        placeholder: (BuildContext context, String url) {
          return progress;
        },

        //위 Url에서 다운받은 이미지를 imageProvider를 통해서 가져온다.
        imageBuilder: (BuildContext context,
            ImageProvider imageProvider,) {
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

  Widget _moreComments(BuildContext context) {
    return Visibility(
      // 댓글이 없거나 1개 이하일때는 보이지 않게 하기 위해
      visible: (postModel.numOfComments != null && postModel.numOfComments > 1),
      child: GestureDetector(
        onTap: () {
          _goToComments(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: common_gap),
          child: Text("${postModel.numOfComments - 1} more comments..."),
        ),
      ),
    );
  }

  _goToComments(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return CommentsScreen(postModel.postKey);
    }));
  }
}
