import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/*
FirebaseUser => User
AuthResult => UserCredential
currentUser() => currentUser
onAuthStateChanged => authStateChanges()
 */

class FirebaseAuthState extends ChangeNotifier {
  FirebaseAuthStatus _firebaseAuthStatus = FirebaseAuthStatus.signout;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User _user;

  void watchAuthChange() {
    //authStateChanges stream을 통해서 변화가 될 때마다 user를 계속 던져준다
    _firebaseAuth.authStateChanges().listen((user) {
      if (user == null && _user == null) {
        return; //그냥 끝낸다
      } else if (user != _user) {
        _user = user;
        changeFirebaseAuthStatus();
      }
    });
  }

  void registerUser(BuildContext context, {@required String email, @required String password}) {
    _firebaseAuth
    //.trim() 하면 모든 띄어쓰기를 제거해 준다
        .createUserWithEmailAndPassword(email: email.trim(), password: password.trim())
        .catchError((error) {
      print(error);
      String _message = "";
      switch (error.code) {
        case 'email-already-in-use':
          _message = "이메일이 이미 존재";
          break;
        case 'invalid-email':
          _message = "정확한 이메일 주소를 넣어";
          break;
        case 'weak-password':
          _message = "좀 더 복잡한 패스워드를 ";
          break;
        case 'operation-not-allowed':
          _message = "이건 무슨 에러지?";
          break;
      }

      SnackBar snackBar = SnackBar(content: Text(_message),);
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  void login({@required String email, @required String password}) {
    _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  void signOut() {
    _firebaseAuthStatus = FirebaseAuthStatus.signout;
    if (_user != null) {
      _user = null;
      _firebaseAuth.signOut();
    }
    notifyListeners();
  }

  //[] 옵션으로 넣어줘도 되고 안 넣어 줘도 된다
  void changeFirebaseAuthStatus([FirebaseAuthStatus firebaseAuthStatus]) {
    if (firebaseAuthStatus != null) {
      _firebaseAuthStatus = firebaseAuthStatus;
    } else {
      if (_firebaseAuthStatus != null) {
        _firebaseAuthStatus = FirebaseAuthStatus.signin;
      } else {
        _firebaseAuthStatus = FirebaseAuthStatus.signout;
      }
    }
    //FirebaseAuthState를 구독하고 있는 위젯들한테 상태변화되었으니 디스플레이에 변화를 주라고 알려줌
    notifyListeners();
  }

  FirebaseAuthStatus get firebaseAuthStatus => _firebaseAuthStatus;
}

enum FirebaseAuthStatus {
  //로그아웃한 상태, 로그인하는 중인 상태, 로그인 상태
  signout,
  progress,
  signin
}
