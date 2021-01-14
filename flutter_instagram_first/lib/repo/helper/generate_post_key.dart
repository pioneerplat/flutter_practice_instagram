import 'package:flutter_instagram_first/models/firestore/user_model.dart';

String getNewPostKey(UserModel userModel) =>
    "${DateTime.now().millisecondsSinceEpoch}_${userModel.userKey}";
