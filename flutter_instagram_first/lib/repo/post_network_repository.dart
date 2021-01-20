import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instagram_first/constants/firestore_keys.dart';
import 'package:flutter_instagram_first/models/firestore/post_model.dart';
import 'package:flutter_instagram_first/repo/helper/transformers.dart';
import 'package:rxdart/rxdart.dart';
//import 'package:rxdart/streams.dart';

class PostNetworkRepository with Transformers {
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

  Stream<List<PostModel>> getPostsFromSpecificUser(String userKey) {
    // where은 컬렉션 안에서 where이하에 일치하는 부분만 가지고 오겠다
    return Firestore.instance
        .collection(COLLECTION_POSTS)
        .where(KEY_USERKEY, isEqualTo: userKey)
        .snapshots()
        .transform(toPosts);
  }

  Stream<List<PostModel>> fetchPostsFromAllFollowers(List<dynamic> followers) {
    final CollectionReference collectionReference =
        Firestore.instance.collection(COLLECTION_POSTS);
    List<Stream<List<PostModel>>> streams = [];
    for (final follower in followers) {
      //해당 followers에서 userkey가 매치되는 포스트들만 가지고 온다
      streams.add(collectionReference
          .where(KEY_USERKEY, isEqualTo: follower)
          //스트림을 생성
          .snapshots()
          //스트림이 도착을 할 때 toPosts를 이용해서 QuerySnapshot을 List<PostModel>로 변경 해줌
          .transform(toPosts));
    }

    //List<List<PostModel>> 이런 식으로 도착하는 걸 combineListOfPosts를 이용해
    //하나의 리스트로 합쳐준 다음 다시 latestToTop을 사용해 순서를 정렬해서 stream으로 내보내 준다
    return CombineLatestStream.list<List<PostModel>>(streams)
        .transform(combineListOfPosts).transform(latestToTop);
  }
}

PostNetworkRepository postNetworkRepository = PostNetworkRepository();
