import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instagram_first/constants/firestore_keys.dart';
import 'package:flutter_instagram_first/models/firestore/comment_model.dart';
import 'package:flutter_instagram_first/repo/helper/transformers.dart';

class CommentNetworkRepository with Transformers {
  Future<void> createNewComment(
      String postKey, Map<String, dynamic> commentData) async {
    final DocumentReference postRef =
        Firestore.instance.collection(COLLECTION_POSTS).document(postKey);
    final DocumentSnapshot postSnapshot = await postRef.get();
    //해당 Document에서 sub collection으로 만약 성이 존재하면 document를 생성하고
    //존재하지 않으면 COLLECTION_COMMENTS을 생성하고 그안에 document를 생성해서 그 reference를 가지고 온다
    final DocumentReference commentRef =
        postRef.collection(COLLECTION_COMMENTS).document();

    return Firestore.instance.runTransaction((tx) async {
      if (postSnapshot.exists) {
        //commentRef에다가 commentData를 저장한다
        await tx.set(commentRef, commentData);

        //numOfCommnets는 snapshot에서 가지고 와서 +1 해준다
        int numOfComments = postSnapshot.data[KEY_NUMOFCOMMENTS];
        //postRef안에 데이터를 저장한다
        await tx.update(postRef, {
          KEY_NUMOFCOMMENTS: numOfComments + 1,
          //commentsData에서 가지고 온다
          KEY_LASTCOMMENT: commentData[KEY_COMMENT],
          KEY_LASTCOMMENTTIME: commentData[KEY_LASTCOMMENTTIME],
          KEY_LASTCOMMENTOR: commentData[KEY_LASTCOMMENTOR],
        });
      }
    });
  }

  Stream<List<CommentModel>> fetchAllComments(String postKey) {
    return Firestore.instance
        .collection(COLLECTION_POSTS)
        .document(postKey)
        .collection(COLLECTION_COMMENTS)
        .orderBy(KEY_COMMENTTIME, descending: false)
        .snapshots().transform(toComments);
  }
}
