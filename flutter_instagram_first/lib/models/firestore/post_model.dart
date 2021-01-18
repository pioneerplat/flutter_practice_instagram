import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instagram_first/constants/firestore_keys.dart';

class PostModel {
  final String postKey;
  final String userKey;
  final String username;
  final String postImg;
  final List<dynamic> numOflikes;
  final String caption;
  final String lastCommentor; // 마지막으로 comment한 사람의 user ID
  final String lastComment;
  final DateTime lastCommentTime;
  final int numOfComments;
  final DateTime postTime;
  final DocumentReference reference;

  //pstKey 와 referece는 직접 추출을 한다
  PostModel.fromMap(Map<String, dynamic> map, this.postKey, {this.reference})
      :
        userKey = map[KEY_USERKEY],
        username = map[KEY_USERNAME],
        postImg = map[KEY_POSTIMG],
        numOflikes = map[KEY_NUMOFLIKES],
        caption = map[KEY_CAPTION],
        lastCommentor = map[KEY_LASTCOMMENTOR],
        lastComment = map[KEY_LASTCOMMENT],
  //KEY_LASTCOMMENTTIME 값이 없을 때 에러가 나기 때문에 (값이 없으면 데이터 값을 지금 시간으로 넣어준다)
        lastCommentTime = map[KEY_LASTCOMMENTTIME] == null
            ? DateTime.now().toUtc()
            : (map[KEY_LASTCOMMENTTIME] as Timestamp).toDate(),
        numOfComments = map[KEY_NUMOFCOMMENTS],
        postTime = map[KEY_POSTTIME] == null
            ? DateTime.now().toUtc()
            : (map[KEY_POSTTIME]).toDate();

  //fromSnapshot - cloud_firestore.dart언어 (각각의 document를 snapshot으로 보면 됨
  PostModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
      snapshot.data,
      snapshot.documentID,
      reference: snapshot.reference
  );

  static Map<String, dynamic> getMapForCreatePost({String userKey, String username, String caption}) {
    Map<String, dynamic> map = Map();
    map[KEY_USERKEY] = userKey;
    map[KEY_USERNAME] = username;
    map[KEY_POSTIMG] = "";
    map[KEY_NUMOFLIKES] = [];
    map[KEY_CAPTION] = caption;
    map[KEY_LASTCOMMENTOR] = "";
    map[KEY_LASTCOMMENT] = "";
    map[KEY_LASTCOMMENTTIME] = DateTime.now().toUtc();
    map[KEY_NUMOFCOMMENTS] = 0;
    map[KEY_POSTTIME] = DateTime.now().toUtc();
    return map;
  }
}