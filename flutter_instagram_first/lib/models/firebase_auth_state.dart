import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/*
FirebaseUser => User
AuthResult => UserCredential
currentUser() => currentUser
onAuthStateChanged => authStateChanges()
 */

class FirebaseAuthState extends ChangeNotifier {
  FirebaseAuthStatus _firebaseAuthStatus = FirebaseAuthStatus.progress;
  User _user;

  //[] 옵션으로 넣어줘도 되고 안 넣어 줘도 된다
  void changeFirebaseAuthStatus([FirebaseAuthStatus firebaseAuthStatus]) {
    if(_firebaseAuthStatus != null) {
      _firebaseAuthStatus = _firebaseAuthStatus;
    }else{
      if(_firebaseAuthStatus != null){
        _firebaseAuthStatus = FirebaseAuthStatus.signin;
      }else{
        _firebaseAuthStatus = FirebaseAuthStatus.signout;
      }
    }
    //FirebaseAuthState를 구독하고 있는 위젯들한테 상태변화되었으니 디스플레이에 변화를 주라고 알려줌
    notifyListeners();
  }
}

enum FirebaseAuthStatus {
  //로그아웃한 상태, 로그인하는 중인 상태, 로그인 상태
  signout, progress, signin
}