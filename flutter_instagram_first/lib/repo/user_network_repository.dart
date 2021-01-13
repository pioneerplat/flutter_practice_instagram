import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instagram_first/constants/firestore_keys.dart';
import 'package:flutter_instagram_first/models/firestore/user_model.dart';
import 'package:local_image_provider/local_album.dart';

class UserNetworkRepository {
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
    return Firestore.instance.collection(COLLECTION_USERS)
        .document(userKey)
        .snapshots().transform(streamTransformer)
  }
}

UserNetworkRepository userNetworkRepository = UserNetworkRepository();
