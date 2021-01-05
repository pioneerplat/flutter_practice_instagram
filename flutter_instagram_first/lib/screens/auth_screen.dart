import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/screens/profile_screens.dart';
import 'package:flutter_instagram_first/widgets/fade_stack.dart';
import 'package:flutter_instagram_first/widgets/sign_in_form.dart';
import 'package:flutter_instagram_first/widgets/sign_up_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

//한가지 애니메이션을 사용할때 SingleTickerProviderStateMixin 사용한다.
class _AuthScreenState extends State<AuthScreen> {
  int selectedForm = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //true로 되어있으면 키보드 같은게 올라오면서 화면크기를 줄여준다. 화면의 변화를 주지않기 위해 false
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Stack(
              children: <Widget>[
                FadeStack(
                  selectedForm: selectedForm,
                ),
                //Positioned Stack안에서만 사용 가능
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 40,
                  child: Container(
                    color: Colors.white,
                    child: FlatButton(
                      shape: Border(top: BorderSide(color: Colors.grey)),
                      onPressed: () {
                        setState(() {
                          //if( <instance> is <class>){} 타입비교
                          if (selectedForm == 0) {
                            selectedForm = 1;
                          } else {
                            selectedForm = 0;
                          }
                        });
                      },
                      child: RichText(
                        text: TextSpan(
                          text: (selectedForm == 0)
                              ? "Already have an account? "
                              : "Don't have an account? ",
                          style: TextStyle(color: Colors.grey),
                          children: [
                            TextSpan(
                                text: (selectedForm == 0)
                                    ? "Sign In"
                                    : "Sign Up",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}
