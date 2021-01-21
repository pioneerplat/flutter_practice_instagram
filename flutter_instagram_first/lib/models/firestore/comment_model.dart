import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instagram_first/constants/firestore_keys.dart';

class CommentModel {
  final String username;
  final String userKey;
  final String comment;
  final DateTime commentTime;
  final String commentKey;
  final DocumentReference reference;

  //fromMap - dart언어
  CommentModel.fromMap(Map<String, dynamic> map, this.commentKey,
      {this.reference})
      : username = map[KEY_USERNAME],
        userKey = map[KEY_USERKEY],
        comment = map[KEY_COMMENT],
        commentTime = map[KEY_COMMENTTIME] == null
            ? DateTime.now().toUtc()
            : (map[KEY_COMMENTTIME] as Timestamp).toDate();

  //fromSnapshot - cloud_firestore.dart언어 (각각의 document를 snapshot으로 보면 됨
  CommentModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, snapshot.documentID,
            reference: snapshot.reference);

  // comment를 새로 달 때
  static Map<String, dynamic> getMapForNewComment(
      String userKey, String username, String comment) {
    Map<String, dynamic> map = Map();
    map[KEY_PROFILEIMG] = "";
    map[KEY_USERKEY] = userKey;
    map[KEY_USERNAME] = username;
    map[KEY_COMMENT] = comment;
    map[KEY_COMMENTTIME] = DateTime.now().toUtc();
    return map;
    
  }
}
