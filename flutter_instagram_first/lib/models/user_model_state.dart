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
}