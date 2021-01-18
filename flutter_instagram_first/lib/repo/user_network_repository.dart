import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instagram_first/constants/firestore_keys.dart';
import 'package:flutter_instagram_first/models/firestore/user_model.dart';
import 'package:flutter_instagram_first/repo/helper/transformers.dart';

//with : Transformers 안에서 있는 모든 변수, 메드를 사용하겠다
class UserNetworkRepository with Transformers {
  Future<void> attemptCreateUser({String userKey, String email}) async {
    final DocumentReference userRef = Firestore.instance
        .collection(COLLECTION_USERS)
        .document(userKey);

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
    return Firestore.instance.collection(COLLECTION_USERS)
        .document(userKey).snapshots().transform(toUser);


  }
}

UserNetworkRepository userNetworkRepository = UserNetworkRepository();
