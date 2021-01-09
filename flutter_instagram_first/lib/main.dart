import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/constants/material_white.dart';
import 'package:flutter_instagram_first/home_page.dart';
import 'package:flutter_instagram_first/models/firebase_auth_state.dart';
import 'package:flutter_instagram_first/screens/auth_screen.dart';
import 'package:flutter_instagram_first/widgets/my_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseAuthState _firebaseAuthState = FirebaseAuthState();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FirebaseAuthState>.value(
      value: _firebaseAuthState,
      child: MaterialApp(
        //home: AuthScreen(),
        home: Consumer<FirebaseAuthState>(
            builder: (BuildContext context, FirebaseAuthState firebaseAuthState,
                Widget child) {
              switch(firebaseAuthState.firebaseAuthStatus){

                case FirebaseAuthStatus.signout:
                  return AuthScreen();
                case FirebaseAuthStatus.progress:
                  return MyProgressIndicator();
                case FirebaseAuthStatus.signin:
                  return HomePage();
                default:
                  return MyProgressIndicator();
              }
            },
            child: HomePage()),
        theme: ThemeData(primarySwatch: white),
      ),
    );
  }
}
