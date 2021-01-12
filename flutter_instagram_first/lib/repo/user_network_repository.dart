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
    if(!snapshot.exists){
      return await userRef.setData(UserModel.getMapForCreateUser(email));
    }
  }
}

UserNetworkRepository userNetworkRepository = UserNetworkRepository();
