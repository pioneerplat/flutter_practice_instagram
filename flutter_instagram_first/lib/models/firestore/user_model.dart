import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instagram_first/constants/firestore_keys.dart';


class UserModel {
  final String userKey;
  final String profileImg;
  final String email;
  final List<dynamic> myPosts;
  final int followers;
  final List<dynamic> likedPosts;
  final String username;
  final List<dynamic> followings;
  final DocumentReference reference;

  //fromMap - dart언어
  UserModel.fromMap(Map<String, dynamic> map, this.userKey, {this.reference})
      : profileImg = map[KEY_PROFILEIMG],
        username = map[KEY_USERNAME],
        email = map[KEY_EMAIL],
        likedPosts = map[KEY_LIKEDPOSTS],
        followers = map[KEY_FOLLOWERS],
        followings = map[KEY_FOLLOWINGS],
        myPosts = map[KEY_MYPOSTS];

  //fromSnapshot - cloud_firestore.dart언어 (각각의 document를 snapshot으로 보면 됨
  UserModel.fromSnapshot(DocumentSnapshot snapshot)
  : this.fromMap(
    snapshot.data,
    snapshot.documentID,
    reference: snapshot.reference
  );
}


