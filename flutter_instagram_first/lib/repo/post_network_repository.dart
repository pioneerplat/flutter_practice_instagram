import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instagram_first/constants/firestore_keys.dart';

class PostNetworkRepository {
  Future<Map<String, dynamic>> createNewPost(
      String postKey, Map<String, dynamic> postData) async {
    //해당 document의 reference 가져오기
    final DocumentReference postRef =
        Firestore.instance.collection(COLLECTION_POSTS).document(postKey);


    //reference를 통해서 snapshot을 가져옴
    final DocumentSnapshot postSnapshot = await postRef.get();

    //user reference 가져오기
    final DocumentReference userRef = Firestore.instance
        .collection(COLLECTION_USERS)
        .document(postData[KEY_USERKEY]);

    //업데이트 둘 중 하나라도 실패하면 이전 상태로 되돌아간다
    return Firestore.instance.runTransaction((Transaction tx) async {
      //snapshot이 존재하는지 물어본다
      if (!postSnapshot.exists) {
        await tx.set(postRef, postData);
        //그냥 외우자 arrayUnion : array안에 추가를 하라는 뜻
        await tx.update(userRef, {
          KEY_MYPOSTS: FieldValue.arrayUnion([postKey])
        });
      }
    });
  }

  Future<void> updatePostImageUrl({String postImg, String postKey}) async {
    final DocumentReference postRef =
    Firestore.instance.collection(COLLECTION_POSTS).document(postKey);
    final DocumentSnapshot postSnapshot = await postRef.get();

    if (postSnapshot.exists) {
      await postRef.updateData({KEY_POSTIMG: postImg});
    }
  }
  Stream<void> getPostsFromSpecificUser(String userKey) {
    // where은 컬렉션 안에서 where이하에 일치하는 부분만 가지고 오겠다
    return Firestore.instance.collection(COLLECTION_POSTS).where(KEY_USERKEY, isEqualTo: userKey)
  }
}

PostNetworkRepository postNetworkRepository = PostNetworkRepository();
