import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instagram_first/constants/firestore_keys.dart';
import 'package:flutter_instagram_first/models/firestore/user_model.dart';
import 'package:flutter_instagram_first/repo/helper/transformers.dart';

//with : Transformers 안에서 있는 모든 변수, 메드를 사용하겠다
class UserNetworkRepository with Transformers {
  Future<void> attemptCreateUser({String userKey, String email}) async {
    final DocumentReference userRef =
        Firestore.instance.collection(COLLECTION_USERS).document(userKey);

    DocumentSnapshot snapshot = await userRef.get();
    if (!snapshot.exists) {
      return await userRef.setData(UserModel.getMapForCreateUser(email));
    }
  }

  Stream<UserModel> getUserModelStream(String userKey) {
    // .get()을 하면 1번만 가지고오고 ,
    // .snapshots을 하면 stream을 보내주기 때문에 정보가 변할 때마다 보내준다.
    //snapshots stream을 받아와서 그 stream에서 던져주는 각각의 DocumentSnapshot을
    //UserModel로 변화를 시켜준다
    return Firestore.instance
        .collection(COLLECTION_USERS)
        .document(userKey)
        .snapshots()
        .transform(toUser);
  }

  //모든 유저 리스트 가져오기
  Stream<List<UserModel>> getAllUsersWithoutMe() {
    //snapshots이 Users 콜렉션에 있는 모든 유저들을 의미
    return Firestore.instance
        .collection(COLLECTION_USERS)
        .snapshots()
        .transform(toUsersExceptMe);
  }
  // Following 할 때
  Future<void> followUser({String myUserKey, String otherUserKey}) async {
    final DocumentReference myUserRef =
        Firestore.instance.collection(COLLECTION_USERS).document(myUserKey);
    final DocumentSnapshot mySnapshot = await myUserRef.get();
    final DocumentReference otherUserRef =
        Firestore.instance.collection(COLLECTION_USERS).document(otherUserKey);
    final DocumentSnapshot otherSnapshot = await otherUserRef.get();

    //두 군대 동시에 업데이트해줘야 하기 때문에 transaction을 사용해야 함

    Firestore.instance.runTransaction((tx) async {
      if (mySnapshot.exists && otherSnapshot.exists) {
        await tx.update(myUserRef, {
          //해당 키를 더해준다
          KEY_FOLLOWINGS: FieldValue.arrayUnion([otherUserKey])
        });
        int currentFollwers = otherSnapshot.data[KEY_FOLLOWERS];
        await tx.update(otherUserRef, {KEY_FOLLOWERS: currentFollwers+1});
      }
    });
  }

  // UnFollowing 할 때
  Future<void> unfollowUser({String myUserKey, String otherUserKey}) async {
    final DocumentReference myUserRef =
        Firestore.instance.collection(COLLECTION_USERS).document(myUserKey);
    final DocumentSnapshot mySnapshot = await myUserRef.get();
    final DocumentReference otherUserRef =
        Firestore.instance.collection(COLLECTION_USERS).document(otherUserKey);
    final DocumentSnapshot otherSnapshot = await otherUserRef.get();

    //두 군대 동시에 업데이트해줘야 하기 때문에 transaction을 사용해야 함

    Firestore.instance.runTransaction((tx) async {
      if (mySnapshot.exists && otherSnapshot.exists) {
        await tx.update(myUserRef, {
          //해당 키를 빼준다
          KEY_FOLLOWINGS: FieldValue.arrayRemove([otherUserKey])
        });
        int currentFollwers = otherSnapshot.data[KEY_FOLLOWERS];
        await tx.update(otherUserRef, {KEY_FOLLOWERS: currentFollwers-1});
      }
    });
  }
}

UserNetworkRepository userNetworkRepository = UserNetworkRepository();
