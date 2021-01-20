import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_instagram_first/models/firestore/user_model.dart';

class UserModelState extends ChangeNotifier {
  UserModel _userModel;

  //UserModel을 전달받는 스트림이라 <UserModel>
  StreamSubscription<UserModel> _currentStreamSub;

  UserModel get userModel => _userModel;

  set userModel(UserModel userModel) {
    _userModel = userModel;
    notifyListeners();
  }

  set currentStreamSub(StreamSubscription<UserModel> currentStreamSub) =>
      _currentStreamSub = currentStreamSub;

  //유저가 로그아웃을 했을 때 구독권을 취소
  clear() {
    //구독권이 있는지 없는지 체크
    if (_currentStreamSub != null) _currentStreamSub.cancel();
    _currentStreamSub = null;
    _userModel = null;
  }

  bool amIFollowingThisUser(String otherUserKey) {
    if (_userModel == null ||
        _userModel.followings == null ||
        _userModel.followings.isEmpty) return false;
    //다른 유저의 키를 가지고 있으면 내가 그 사람을 following하고 있는거
    return _userModel.followings.contains(otherUserKey);
  }
}
