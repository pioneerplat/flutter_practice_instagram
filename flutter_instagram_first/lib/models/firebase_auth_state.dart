import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_instagram_first/repo/user_network_repository.dart';
import 'package:flutter_instagram_first/utills/simple_snackbar.dart';

/*
FirebaseUser => User
AuthResult => UserCredential
currentUser() => currentUser
onAuthStateChanged => authStateChanges()
 */

class FirebaseAuthState extends ChangeNotifier {
  //상태 기본값
  //FirebaseAuthStatus _firebaseAuthStatus = FirebaseAuthStatus.signout;
  FirebaseAuthStatus _firebaseAuthStatus = FirebaseAuthStatus.progress;

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _firebaseUser;
  FacebookLogin _facebookLogin;

  void watchAuthChange() {
    //authStateChanges stream을 통해서 변화가 될 때마다 user를 계속 던져준다
    _firebaseAuth.onAuthStateChanged.listen((user) {
      if (user == null && _firebaseUser == null) {
        changeFirebaseAuthStatus();
        return; //그냥 끝낸다
      } else if (user != _firebaseUser) {
        _firebaseUser = user;
        changeFirebaseAuthStatus();
      }
    });
  }

  void registerUser(BuildContext context,
      {@required String email, @required String password}) async {
    changeFirebaseAuthStatus(FirebaseAuthStatus.progress);
    AuthResult authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(
            //.trim() 하면 모든 띄어쓰기를 제거해 준다
            email: email.trim(),
            password: password.trim())
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
          _message = "이건 무슨 에러지? 해당 동작은 여기서 금지야";
          break;
      }

      SnackBar snackBar = SnackBar(
        content: Text(_message),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });

    FirebaseUser firebaseUser = authResult.user;
    if (firebaseUser == null) {
      SnackBar snackBar = SnackBar(
        content: Text("Please try again later"),
      );
    } else {
      //todo send data to firestore
      await userNetworkRepository.attemptCreateUser(
          userKey: firebaseUser.uid, email: firebaseUser.email);
    }
  }

  void login(BuildContext context,
      {@required String email, @required String password}) {
    changeFirebaseAuthStatus(FirebaseAuthStatus.progress);
    _firebaseAuth
        .signInWithEmailAndPassword(
            email: email.trim(), password: password.trim())
        .catchError((error) {
      String _message = "";
      switch (error.code) {
        case 'invalid-email':
          _message = "올바른 이메일 넣어줘";
          break;
        case 'user-disabled':
          _message = "너 차단됨? ㅋ";
          break;
        case 'user-not-found':
          _message = "아이디가 없어";
          break;
        case 'wrong-password':
          _message = "password 틀렸어";
          break;
      }
      SnackBar snackBar = SnackBar(
        content: Text(_message),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  void signOut() async {
    changeFirebaseAuthStatus(FirebaseAuthStatus.progress);
    _firebaseAuthStatus = FirebaseAuthStatus.signout;
    if (_firebaseUser != null) {
      _firebaseUser = null;
      await _firebaseAuth.signOut();
      if (await _facebookLogin.isLoggedIn) {
        await _facebookLogin.logOut();
      }
    }
    notifyListeners();
  }

  //context는 알림창 역할을 하는 SnackBar를 사용하기 위해
  void loginWithFacebook(BuildContext context) async {
    changeFirebaseAuthStatus(FirebaseAuthStatus.progress);

    if (_facebookLogin == null) _facebookLogin = FacebookLogin();
    //facebookLogin.logIn의 반환 타입인 FacebookLoginResult 타입으로 받아오기 위해 await로 감싸준다
    //final result = await facebookLogin.logIn(['email']);
    final FacebookLoginResult result = await _facebookLogin.logIn(['email']);
    switch (result.status) {
      //로그인 성공
      case FacebookLoginStatus.loggedIn:
        _handleFacebookTokenWithFirebase(context, result.accessToken.token);
        break;

      //로그인 취소
      case FacebookLoginStatus.cancelledByUser:
        simpleSnackbar(context, 'User cancel facebook sign in');
        break;

      //로그인 과정에서 에러
      case FacebookLoginStatus.error:
        simpleSnackbar(context, 'Error while facebook sign in 잉?');
        _facebookLogin.logOut();
        break;
    }
  }

  //SnackBar를 위한 context
  void _handleFacebookTokenWithFirebase(
      BuildContext context, String token) async {
    //토큰을 사용해서 파이어베이스로 로그인하기
    final AuthCredential credential =
        FacebookAuthProvider.getCredential(accessToken: token);
    final AuthResult authResult =
        await _firebaseAuth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    if (user == null) {
      simpleSnackbar(context, '페이스북 로그인이 실패했다 나중에 다시해봐');
    } else {
      _firebaseUser = user;
    }
    notifyListeners();
  }

  //[] 옵션으로 넣어줘도 되고 안 넣어 줘도 된다
  void changeFirebaseAuthStatus([FirebaseAuthStatus firebaseAuthStatus]) {
    if (firebaseAuthStatus != null) {
      _firebaseAuthStatus = firebaseAuthStatus;
    } else {
      //if (_firebaseAuthStatus != null) { 이거때문에 에러남..
      if (_firebaseUser != null) {
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
