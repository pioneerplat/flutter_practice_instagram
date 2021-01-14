import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/constants/material_white.dart';
import 'package:flutter_instagram_first/home_page.dart';
import 'package:flutter_instagram_first/models/firebase_auth_state.dart';
import 'package:flutter_instagram_first/models/user_model_state.dart';
import 'package:flutter_instagram_first/repo/user_network_repository.dart';
import 'package:flutter_instagram_first/screens/auth_screen.dart';
import 'package:flutter_instagram_first/widgets/my_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseAuthState _firebaseAuthState = FirebaseAuthState();
  Widget _currentWidget;

  @override
  Widget build(BuildContext context) {
    _firebaseAuthState.watchAuthChange();
    return MultiProvider(
      providers: [
        //value는 기존에 생성되어 있는 데이터를 넣어주는 것
        ChangeNotifierProvider<FirebaseAuthState>.value(
            value: _firebaseAuthState),
        //value를 사용하지 않고 생성자를 사용해 UserModelState를 바로 생성해 준다
        ChangeNotifierProvider<UserModelState>(
          create: (_) => UserModelState(),
        ),
      ],
      child: MaterialApp(
        //home: AuthScreen(),
        home: Consumer<FirebaseAuthState>(builder: (BuildContext context,
            FirebaseAuthState firebaseAuthState, Widget child) {
          switch (firebaseAuthState.firebaseAuthStatus) {
            case FirebaseAuthStatus.signout:
              _clearUserModel(context);
              _currentWidget = AuthScreen();
              break;
            case FirebaseAuthStatus.signin:
              //listen을 하면 해당 stream을 구독하고 있는 상태이다 다른 stream을 연결할 때 구독을 취소해 줘야 한다
              //즉 로그아웃을 하면 구독을 취소해 줘야
              _initUserModel(firebaseAuthState, context);
              _currentWidget = HomePage();
              break;
            default:
              _currentWidget = MyProgressIndicator();
          }
          //자연스럽게 화면 전환하기 위해
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _currentWidget,
          );
        }),
        theme: ThemeData(primarySwatch: white),
      ),
    );
  }

  void _initUserModel(
      FirebaseAuthState firebaseAuthState, BuildContext context) {
    UserModelState userModelState =
        Provider.of<UserModelState>(context, listen: false);
    userModelState.currentStreamSub = userNetworkRepository
        .getUserModelStream(firebaseAuthState.firebaseUser.uid)
        .listen((userModel) {
          //userModel 업데이트
      userModelState.userModel = userModel;
    });
  }

  void _clearUserModel(BuildContext context) {
    UserModelState userModelState =
        Provider.of<UserModelState>(context, listen: false);
    userModelState.clear();
  }
}
