import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_instagram_first/models/firestore/comment_model.dart';
import 'package:flutter_instagram_first/models/firestore/post_model.dart';
import 'package:flutter_instagram_first/models/firestore/user_model.dart';

class Transformers {
  final toUser = StreamTransformer<DocumentSnapshot, UserModel>.fromHandlers(
      handleData: (snapshot, sink) async {
    sink.add(UserModel.fromSnapshot(snapshot));
  });
  final toUsersExceptMe =
      StreamTransformer<QuerySnapshot, List<UserModel>>.fromHandlers(
          handleData: (snapshot, sink) async {
    List<UserModel> users = [];
    // 현재 유저(나)
    FirebaseUser _firebaseUser = await FirebaseAuth.instance.currentUser();
    snapshot.documents.forEach((documentSnapshot) {
      //내 아이디를 제외한 유저들을 가지고 오기 위해
      if (_firebaseUser.uid != documentSnapshot.documentID) {
        //UserModel로 변경해서 list로 넣어준다
        users.add(UserModel.fromSnapshot(documentSnapshot));
      }
    });
    //QuerySnapshot이 도착할 때마다 유저리스트를 생성해서 싱크대를 통해서 나가게 되어있다.
    sink.add(users);
  });
  final toPosts =
      StreamTransformer<QuerySnapshot, List<PostModel>>.fromHandlers(
          handleData: (snapshot, sink) async {
    List<PostModel> posts = [];

    snapshot.documents.forEach((documentSnapshot) {
      posts.add(PostModel.fromSnapshot(documentSnapshot));
    });
    //QuerySnapshot이 도착할 때마다 유저리스트를 생성해서 싱크대를 통해서 나가게 되어있다.
    sink.add(posts);
  });

  //documentsSnapshot을 CommentModel로 변경을 해준다음 List로 모아서 sink로 보내준다
  final toComments =
      StreamTransformer<QuerySnapshot, List<CommentModel>>.fromHandlers(
          handleData: (snapshot, sink) async {
    List<CommentModel> comments = [];
    snapshot.documents.forEach((documentSnapshot) {
      comments.add(CommentModel.fromSnapshot(documentSnapshot));
    });
    //QuerySnapshot이 도착할 때마다 유저리스트를 생성해서 싱크대를 통해서 나가게 되어있다.
    sink.add(comments);
  });

  final combineListOfPosts =
      StreamTransformer<List<List<PostModel>>, List<PostModel>>.fromHandlers(
          handleData: (listOfPosts, sink) async {
    List<PostModel> posts = [];

    //<List<List<PostModel>> 있는걸 다 꺼내서 하나의 리스트에 넣어준다
    for(final postList in listOfPosts){
      posts.addAll(postList);
    }

    //QuerySnapshot이 도착할 때마다 유저리스트를 생성해서 싱크대를 통해서 나가게 되어있다.
    sink.add(posts);
  });

  final latestToTop =
      StreamTransformer<List<PostModel>, List<PostModel>>.fromHandlers(
          handleData: (posts, sink) async {
    //비교한 값 중 큰 값을 위로 올림
    posts.sort((a, b) => b.postTime.compareTo(a.postTime));
    sink.add(posts);
  });
}
